import 'package:clicandeats/firebaseFirestore/geoFlutterFire.dart';
import 'package:clicandeats/firebaseFirestore/profileOp.dart';
import 'package:clicandeats/firebaseFirestore/restaurantsOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';

import 'package:clicandeats/models/Settings.dart' as sett;

class FirebaseOpOrders {
  String collectionName = 'allOrders';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addOrder(Order orderData, context, uId) async {
    double deliveryFee = orderData.deliveryFee;

    ///get client orders collection reference ,
    ///because we want to create orders with
    ///same generated id in other collections too
    DocumentReference document =
        firestore.collection('client').doc(uId).collection('orders').doc();
    try {
      orderData.orderNo =
          DateTime.now().toString() + "0012${document.id.substring(1, 6)}";
      await document.set(orderData.toGlobalMap(0.0, orderData.resId));
      var customerAddress = myCart.shippingAddress;

      print('addOrder: customer address :$customerAddress');
      DocumentSnapshot resto =
          await FirebaseResOp().getRestaurantDetails(resId: orderData.resId);
      var restaurantAddress = resto.get('address');
      print('addOrder: restaurantAddress $restaurantAddress');
      GeoFirePoint source = await FlutterFireOpGeo()
          .convertAddressToCoordinates(restaurantAddress);
      GeoFirePoint destination =
          await FlutterFireOpGeo().convertAddressToCoordinates(customerAddress);

      //calculate distance
      double distance =
          FlutterFireOpGeo().calculateDistance(source, destination);
      print("addOrder: DISTANCE ${distance}");

      //calculate delivery fee
      await firestore.collection('fee').doc('fee').get().then((value) {
        double carrierFee = value.get('carrierFee');
        double additionalKmFee = value.get('additionalKmFee').toDouble();

        if (distance < 1) {
          deliveryFee = carrierFee;
        } else if (distance > 1) {
          deliveryFee = carrierFee;
          distance = distance - 1;
          for (; distance >= 0; distance--) {
            // print("DIS: $distance");
            deliveryFee = deliveryFee + additionalKmFee;
            // print("fee: $deliveryFee");
          }
        }
        print("addOrder: DELIVERYFEE: $deliveryFee");

        ///update delivery fee in firestore of main order created in client collection
        /// this is for history purposes
        firestore
            .collection('client')
            .doc(uId)
            .collection('orders')
            .doc(document.id)
            .update({'deliveryFee': deliveryFee});
      }).then((value) {
        // print("DELIVERY FEE NOW: $deliveryFee");
        firestore
            .collection('allOrders')
            .doc(document.id)
            .set(orderData.toGlobalMap(deliveryFee, orderData.resId))
            .then((value) => firestore //create the order in resto collection -
                .collection('restos')
                .doc(orderData.resId)
                .collection('orders')
                .doc(document.id)
                .set(orderData.toMap(deliveryFee))
                .then((value) => firestore
                    .collection('restos')
                    .doc(orderData.resId)
                    .update({'totalOrders': FieldValue.increment(1)})));
      });
      return document.id;

      // FirebaseNotificationOperations().addNotification(
      //     'A new order placed.', resId);
      // orderData.resId = resId;
      // print("OrderData: ${document.id}   ${orderData.resId}");

      // });

      //     .then((value){
      //
      //   FirebaseNotificationOperations().addNotification(
      //       'A new order placed.', resId);
      //   orderData.resId = resId;
      //   print("OrderData: ${document.id}   ${orderData.resId}");
      //    firestore
      //       .collection('allOrders')
      //       .doc()
      //       .set(orderData.toGlobalMap());
      // });
    } catch (e) {
      final snackBar = SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
              'Une erreur s\'est produite. Veuillez réessayer plus tard ou contacter l\'assistance !'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  /// this method will be called when the client has paid the
  /// amount on checkout screen successfully only then the
  /// orders status will change to 1 and will start showing
  /// to respective restaurant
  Future updateOrderStatus({orderId, resId, cusId}) {
    return firestore
        .collection('restos')
        .doc(resId)
        .collection('orders')
        .doc(orderId)
        .update({'status': 1}).then((value) {
      firestore
          .collection('allOrders') //update global orders collection
          .doc(orderId)
          .update({'status': 1});
      firestore
          .collection('client')
          .doc(cusId)
          .collection('orders')
          .doc(orderId)
          .update({'status': 1});
    });
  }

  Future<double> calculateDeliveryFee(context, uid, resId) async {
    print("CALCULATE DELIEVRY FEE: ");
    DocumentSnapshot customer =
        await FirebaseProfileOp().getShippingInfoFuture(uid);
    var customerAddress = customer.get('address');
    double deliveryFee = 0.0;
    // print('custoer adres :$customerAddress');
    DocumentSnapshot resto =
        await FirebaseResOp().getRestaurantDetails(resId: resId);
    var restaurantAddress = resto.get('address');
    // print('restaurantAddress $restaurantAddress');
    GeoFirePoint source =
        await FlutterFireOpGeo().convertAddressToCoordinates(restaurantAddress);
    GeoFirePoint destination = await FlutterFireOpGeo()
        .convertAddressToCoordinates(myCart.shippingAddress);

    //calculate distance
    double distance = FlutterFireOpGeo().calculateDistance(source, destination);
    // print("DISTANCE ${distance}");

    await firestore.collection('fee').doc('fee').get().then((value) {
      double carrierFee = value.get('carrierFee');
      double additionalKmFee = value.get('additionalKmFee').toDouble();

      if (distance < 1) {
        deliveryFee = carrierFee;
      } else if (distance > 1) {
        deliveryFee = carrierFee;
        distance = distance - 1;
        for (; distance >= 0; distance--) {
          //print("DIS: $distance");
          deliveryFee = deliveryFee + additionalKmFee;
          //print("fee: $deliveryFee");
        }
      }
      print("CALCULATE DELIEVRY FEE:: DELIVERY FEE: $deliveryFee");
    });
    return deliveryFee;
  }

  Stream<QuerySnapshot> getMyOrders(uid) {
    return firestore
        .collection('client')
        .doc(uid)
        .collection('orders')
        // .where('status', isGreaterThan: 0)
        //.orderBy('status', descending: true)
        .orderBy('orderTime', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getMealDetails(mid, resId) {
    return firestore
        .collection('restos')
        .doc(resId)
        .collection('meals')
        .doc(mid)
        .get();
  }

  rateOrder(orderId, resId, cId, double stars, comment) async {
    // update client collection -> orders - order id -> rated = true and rating.update = {}
    firestore
        .collection('client')
        .doc(cId)
        .collection('orders')
        .doc(orderId)
        .update({
      'rated': true,
      'orderRating': {'stars': stars, 'comment': comment == "" ? "" : comment}
    });
    // update resto collection -> orders - order id -> rated = true and rating.update = {}
    firestore
        .collection('restos')
        .doc(resId)
        .collection('orders')
        .doc(orderId)
        .update({
      'rated': true,
      'orderRating': {'stars': stars, 'comment': comment == "" ? "" : comment}
    });

    /// get current total rated and stars of restaurant
    ///
    ///
    DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection('restos').doc(resId).get();
    print(doc.get('rating.rated'));
    var updateStars;
    if (doc.get('rating.rated') >= 1) {
      updateStars = (doc.get('rating.stars') + stars) / 2;
    } else
      updateStars = stars;
    print('updated rating: $updateStars');

    //update restaurant total rating stars and rated orders
    firestore.collection('restos').doc(resId).update(
        {'rating.stars': updateStars, 'rating.rated': FieldValue.increment(1)});
  }

  Future<bool> addATip(
      clientId, resId, carrierId, orderId, double tipAmount, context) async {
    try {
      await firestore
          .collection('allOrders')
          .doc(orderId)
          .set({'tip': tipAmount}, SetOptions(merge: true))
          .then((value) => firestore
              .collection('client')
              .doc(clientId)
              .collection('orders')
              .doc(orderId)
              .set({'tip': tipAmount}, SetOptions(merge: true)))
          .then((value) => firestore
              .collection('restos')
              .doc(resId)
              .collection('orders')
              .doc(orderId))
        ..set({'tip': tipAmount}, SetOptions(merge: true));
      return true;
    } on FirebaseException catch (e) {
      print('Firebase Exception in addATip function: ${e.code} ${e.message}');
      return false;
    } catch (e) {
      final snackBar = SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
              'Une erreur s\'est produite. Veuillez réessayer plus tard ou contacter l\'assistance!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }
}
