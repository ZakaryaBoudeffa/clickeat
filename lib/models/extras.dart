import 'package:flutter/material.dart';


class Extras {
  String name;
  int isRequired;
  int noOfSelectableExtras;
  bool? noOfSelectedItemsPass;
  List<Map<String, dynamic>>? extraItems = [];
  TextEditingController? extrasItemNameCtrl = TextEditingController();
  TextEditingController? extrasItemPriceCtrl = TextEditingController();
  Extras(
      {
        required this.name,
        required this.isRequired,
        required this.noOfSelectableExtras,
        this.noOfSelectedItemsPass = false,
        this.extraItems,
        this.extrasItemNameCtrl,
        this.extrasItemPriceCtrl,
      });

  static double extrasAmount = 0.0;
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'extraItems': extraItems,
      'isRequired': isRequired,
      'noOfSelectableExtras': noOfSelectableExtras
    };
  }

  factory Extras.fromMap(Map json) {
    return Extras(
        name: json['name'],
        isRequired: json['isRequired'],
        noOfSelectableExtras: json['noOfSelectableExtras'],
        extrasItemNameCtrl: TextEditingController(),
        extrasItemPriceCtrl: TextEditingController(),
        extraItems: []);
  }
  factory Extras.fromJson(Map json) {
    return Extras(
        name: json['name'],
        isRequired: json['isRequired'],
        noOfSelectableExtras: json['noOfSelectableExtras'],
        extrasItemNameCtrl: TextEditingController(),
        extrasItemPriceCtrl: TextEditingController(),
        extraItems: List.from(json['extraItems']));
  }
}

class ExtrasItem {
  String name;
  double? price;
  bool isAvailable;
  ExtrasItem({required this.name, required this.price,required this.isAvailable});


  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'isAvailable': isAvailable};
  }

  factory ExtrasItem.fromMap(Map json) {
    return ExtrasItem(name: json['name'], price: json['price'],
        isAvailable: json['isAvailable']);
  }
  factory ExtrasItem.fromJson(Map json){
    return ExtrasItem(name: json['name'], price: json['price'],
        isAvailable: json['isAvailable']);
  }
}
