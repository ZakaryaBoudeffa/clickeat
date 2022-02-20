import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  String? name;
  DateTime? expiration;
  double? percentage;

  Coupon({this.name, this.expiration, this.percentage});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'expiration': expiration,
      'percentage': percentage,
    };
  }

  Coupon fromSnapshot(DocumentSnapshot e) {
    log("${Timestamp.now()} -- ${e['coupon']['expiration']}");
    return Coupon(
      name: e['coupon']['name'],
      expiration: e['coupon']['expiration'].toDate(),
      percentage: e['coupon']['percentage'].toDouble(),
    );
  }
}