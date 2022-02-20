import 'dart:developer';

import 'package:clicandeats/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:clicandeats/main.dart';

class FirebaseProfileOp {
  String collectionName = 'client';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getMyInfo(uId) {
    print("MYINFO UID $uId");
    return firestore.collection(collectionName).doc(uId).get();
  }

  switchTheme(cId, value) {
    try{
      firestore
          .collection(collectionName)
          .doc(cId)
          .set({'themeLight': value}, SetOptions(merge: true));
    }
    catch (e){
      print("Error in switching theme info $e");
    }
  }

  Future<DocumentSnapshot> getThemeFromDb(cId){
    return firestore.collection(collectionName).doc(cId).get();
  }

  editProfile(Client clientData, cId) {
    firestore.collection(collectionName).doc(cId).update(clientData.toMap());
  }

  Stream<QuerySnapshot> getShippingInfo(uId) {
    return firestore
        .collection(collectionName)
        .doc(uId)
        .collection('shippingInfo')
        .snapshots();
  }

  // Future<QuerySnapshot> getShippingInfoFuture() {
  //   return firestore
  //       .collection(collectionName)
  //       .doc(currentUserID)
  //       .collection('shippingInfo').get();
  //
  // }

  Future<DocumentSnapshot> getShippingInfoFuture(uId) async {
    print("GETTING shipping info future with uID: $uId");
    return firestore
        .collection(collectionName)
        .doc(uId)
        .collection('shippingInfo')
        .doc('shippingInfo')
        .get();
  }

  addShippingInfo(context, Map<String, dynamic> info, infoId, uId) async {
    try {
      print("info: $info");
      await firestore
          .collection(collectionName)
          .doc(uId)
          .collection('shippingInfo')
          .doc('shippingInfo')
          .set(info)
          .then((value) {
        //show snakbar
        final snackBar = SnackBar(
            backgroundColor: Colors.black87,
            content: Text('🙌 Delivery information added'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } catch (e) {
      print("Error in editShipping info $e");
      log("Error in editShipping info $e");
    }
  }

  editShippingInfo(context, Map<String, dynamic> info, infoId, uId) async {
    try {
      print("info: $info");
      await firestore
          .collection(collectionName)
          .doc(uId)
          .collection('shippingInfo')
          .doc('shippingInfo')
          .update(info)
          .then((value) {
        //show snakbar
        final snackBar = SnackBar(
            backgroundColor: Colors.black87,
            content: Text('🙌 Vos informations ont été mises à jour'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } catch (e) {
      print("Error in editShipping info $e");
      log("Error in editShipping info $e");
    }
  }
}
