import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/pages/cart.dart';

import '../main.dart';

class InCartOrder {
  String resId;
  String? platId;
  String name;
  String img;
  int qtt;
  double originalPrice;
  double calculatedDishOnlyPrice;
  double discountPercent;
  double extrasAmount = 0.0;
  List<Map<String, dynamic>> selectedExtrasList;

  InCartOrder(
      {this.platId,
      required this.resId,
      required this.name,
      required this.img,
      required this.qtt,
      required this.originalPrice,
      required this.calculatedDishOnlyPrice,
      required this.discountPercent,
      required this.selectedExtrasList,
      this.extrasAmount = 0.0});
}

class Cart {
  String? resId;
  String? resName;
  List<InCartOrder>? items = [];
  String shippingAddress;
  Cart({this.resId, this.items, required this.shippingAddress, this.resName});
}

class Order {
  String? id;
  String? orderNo;
  int status;
  String customerId; //retrieve customer information from this id
  String? couponCode;
  String? selectedCarrier;
  String? selectedCarrierName;
  String? resId;
  String? deliveryCode;
  List ignoredByCarriers;
  String deliveryAddress;
  String resName;
  List<Map<String, dynamic>> orderedMealsList;
  Map<String, dynamic> orderRating;
  bool rated;
  DateTime orderTime;
  double deliveryFee;
  double extrasAmount;
  double mealsAmount;
  double associationAmount;
  double discountAmount;
  double couponDiscount;
  double tip;
  double total;

  Order(
      {this.id,
      this.orderNo,
      required this.status,
      required this.customerId,
      this.couponCode,
      this.selectedCarrier,
      this.resId,
      this.deliveryCode,
      this.selectedCarrierName,
      required this.tip,
      required this.resName,
      required this.deliveryAddress,
      required this.deliveryFee,
      required this.ignoredByCarriers,
      required this.orderedMealsList,
      required this.orderRating,
      required this.rated,
      required this.orderTime,
      required this.extrasAmount,
      required this.mealsAmount,
      required this.discountAmount,
      required this.associationAmount,
      required this.couponDiscount,
      required this.total});

  Map<String, dynamic> toMap(dFee) {
    return {
      'orderNo': orderNo,
      'status': status,
      'customerId': customerId,
      'selectedCarrier': null,
      'couponCode': couponCode,
      'orderedMealsList': orderedMealsList,
      'orderTime': orderTime,
      'total': total,
      'tip': 0.0,
      'deliveryAddress': myCart.shippingAddress,
      'resName': resName,
      'ignoredByCarriers': [],
      'deliveryFee': dFee,
      'extrasAmount': extrasAmount,
      'mealsAmount': mealsAmount,
      'discountAmount': discountAmount,
      'associationAmount': associationAmount,
      'couponDiscount': couponDiscount,
      'rated': rated,
      'orderRating': orderRating
    };
  }

  Map<String, dynamic> toGlobalMap(fee, resid) {
    return {
      'orderNo': orderNo,
      'status': status,
      'customerId': customerId,
      'selectedCarrier': null,
      'couponCode': couponCode,
      'resId': resid,
      'orderedMealsList': orderedMealsList,
      'orderTime': orderTime,
      'total': total,
      'tip': tip,
      'deliveryAddress': myCart.shippingAddress,
      'resName': resName,
      'ignoredByCarriers': ignoredByCarriers,
      'deliveryFee': fee,
      'extrasAmount': extrasAmount,
      'mealsAmount': mealsAmount,
      'discountAmount': discountAmount,
      'associationAmount': associationAmount,
      'couponDiscount': couponDiscount,
      'rated': rated,
      'orderRating': orderRating
    };
  }

  factory Order.fromSnapShot(snapshot) => Order(
        id: snapshot.id,
        orderNo: snapshot['orderNo'],
        status: snapshot['status'],
        customerId: snapshot['customerId'],
        resId: snapshot['resId'],
        orderTime: snapshot['orderTime'].toDate(),
        selectedCarrier: snapshot['selectedCarrier'] ?? "",
        ignoredByCarriers: snapshot['ignoredByCarriers'],
        deliveryFee: snapshot['deliveryFee'],
        couponCode: snapshot['couponCode'] ?? null,
        total: snapshot['total'],
        selectedCarrierName:
            snapshot.data().toString().contains('selectedCarrierName')
                ? snapshot['selectedCarrierName']
                : 'not assigned',
        resName: snapshot.data().toString().contains('resName')
            ? snapshot['resName']
            : 'missing',
        deliveryCode: snapshot.data().toString().contains('deliveryCode')
            ? snapshot['deliveryCode']
            : '',
        tip: snapshot.data().toString().contains('tip') ? snapshot['tip'] : 0.0,
        deliveryAddress: snapshot.data().toString().contains('deliveryAddress')
            ? snapshot['deliveryAddress']
            : myCart.shippingAddress,
        extrasAmount: snapshot.data().toString().contains('extrasAmount')
            ? snapshot['extrasAmount']
            : 0.0,
        mealsAmount: snapshot.data().toString().contains('mealsAmount')
            ? snapshot['mealsAmount']
            : 0.0,
        discountAmount: snapshot.data().toString().contains('discountAmount')
            ? snapshot['discountAmount']
            : 0.0,
        couponDiscount: snapshot.data().toString().contains('couponDiscount')
            ? snapshot['couponDiscount']
            : 0.0,
        associationAmount:
            snapshot.data().toString().contains('associationAmount')
                ? snapshot['associationAmount']
                : 0.0,
        rated: snapshot.data().toString().contains('rated')
            ? snapshot['rated']
            : false,
        orderRating: snapshot.data().toString().contains('orderRating')
            ? snapshot['orderRating']
            : {'stars': 0, 'comment': ""},
        orderedMealsList:
            List<Map<String, dynamic>>.from(snapshot['orderedMealsList']),
      );
}

class OrderedMeal {
  int qtt;
  String mealId; //retrieve meal information using this id
  double mealPrice;
  double extrasAmount;
  List<Map<String, dynamic>> extrasList;
  OrderedMeal(this.qtt, this.mealId,
      {required this.mealPrice,
      required this.extrasList,
      required this.extrasAmount});
  Map<String, dynamic> toMap() {
    return {
      'qtt': qtt,
      'mealId': mealId,
      'mealPrice': mealPrice,
      'extrasAmount': extrasAmount,
      'extrasList': extrasList
    };
  }

  factory OrderedMeal.fromSnapshot(snapshot) => OrderedMeal(
        snapshot['qtt'],
        snapshot['mealId'],
        mealPrice: snapshot.toString().contains('mealPrice')
            ? snapshot['mealPrice']
            : 0.0,
        extrasAmount: snapshot.toString().contains('extrasAmount')
            ? snapshot['extrasAmount']
            : 0.0,
        extrasList: snapshot.toString().contains('extrasList')
            ? List<Map<String, dynamic>>.from(snapshot['extrasList'])
            : [],
      );
}

class Ordered {
  List<OrderedMeal> orders;
  int orderNumber;
  String status;
  double total;
  DateTime timestamp;

  Ordered(
      {required this.orderNumber,
      required this.orders,
      required this.status,
      required this.timestamp,
      required this.total});

  factory Ordered.fromSnap(snap) => Ordered(
      orderNumber: snap['orderNo'],
      orders: snap['orderedMealsList'],
      status: snap['status'],
      timestamp: snap['orderTime'],
      total: snap['total']);
}
