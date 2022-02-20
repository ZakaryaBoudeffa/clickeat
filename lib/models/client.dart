import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String? avatar;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? address;
  String? cusId;
  bool? themeLight;

  Client({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.avatar,
    this.cusId,
     this.themeLight,
  });

  factory Client.fromSnapshot( snap) => Client(
    firstName: snap['firstName']??"",
    lastName: snap['lastName'],
    email: snap['email'],
    phone: snap['phone'],
    address: snap['address'],
    avatar: snap['avatar'],
    themeLight: snap.toString().contains('themeLight')
        ? snap['themeLight']
        : true,
  );


  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName':lastName,
      'phone': phone,
      'address': address,
      'email': email,
      'avatar': avatar ?? "",
      'themeLight' : true,
    };
  }
}

class ShippingInfo {
  String? firstName;
  String? lastName;
  String? phone;

  /// make address and get exact corrdinates using below details
  String? address;
  String? city;
  String? roadNumber; //56
  String? stage; //1
  String? doorNumber; //f15
  String? entrance; //// 2f

  ShippingInfo(
      {this.firstName,
      this.lastName,
      this.phone,
      this.address,
      this.city,
      this.roadNumber,
      this.doorNumber,
      this.entrance,
      this.stage});

  factory ShippingInfo.fromSnapshot( snap) => ShippingInfo(
    firstName: snap['firstName']??"",
    lastName: snap['lastName'],
    phone: snap['phone'],
    city: snap['city'],
    address: snap['address'],
    roadNumber: snap['roadNumber']??"",
    doorNumber: snap['doorNumber']??"",
    entrance: snap['entrance']??"",
    stage: snap['stage']??"",
  );

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName':lastName,
      'phone': phone,
      'address': address,
      'city':city,
      'roadNumber': roadNumber,
      'doorNumber': doorNumber,
      'entrance': entrance,
      'stage': stage
    };
  }
}
