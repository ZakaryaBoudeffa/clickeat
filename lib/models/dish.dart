
import 'package:clicandeats/models/extras.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dish {
  String? id;
  String name;
  String dsc;
  String image;
  double price;
  double discountedPrice;
  double? weight;
  DateTime? dateCreated;
  bool isAvailable;
  List<Map<String, dynamic>>? extras;

  Dish({this.id,
        required this.name,
        required this.dsc,
        required this.image,
        required this.price,
        required this.isAvailable,
        this.dateCreated,
        required this.discountedPrice,
        this.extras,
        this.weight});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dsc': dsc,
      'image': image,
      'price': price,
      'discountedPrice': discountedPrice,
      'extras': extras,
      'isAvailable': isAvailable
      //'status': status
    };
  }

  factory Dish.fromMap(dynamic mealMap) => Dish(
      id: mealMap['id'],
      name: mealMap["name"],
      dsc: mealMap["dsc"],
      image: mealMap["image"],
      price: mealMap['price'],
      discountedPrice: double.parse(mealMap['discountedPrice'].toString()),
      isAvailable: mealMap['isAvailable'],
      extras: mealMap["extras"]);

  factory Dish.fromDocumentSnapshot(dynamic mealMap) => Dish(
    //id: mealMap['id'],
      name: mealMap["name"],
      dsc: mealMap["dsc"],
      image: mealMap["image"],
      price: mealMap['price'],
      discountedPrice: double.parse(mealMap['discountedPrice'].toString()),
      isAvailable: mealMap['isAvailable'],
      extras:List.from(mealMap['extras'])
  );

  factory Dish.fromSnapShot(QueryDocumentSnapshot mealMap, id) {
    print("meal map ID: ${mealMap.id}");

    return Dish(
        id: mealMap.id,
        name: mealMap['name'],
        dsc: mealMap["dsc"],
        image: mealMap["image"],
        price: mealMap["price"],
        discountedPrice: double.parse(mealMap['discountedPrice'].toString()),
        isAvailable: mealMap['isAvailable']
      //extras: mealMap["extras"]
    );
  }
}
// List<Map<String, dynamic>> extrasList = [
//   Extras( name: 'Sauces', extraItems:  [
//     ExtrasItem('Kecthup 2 packs', 0.5, true).toMap(),
//     ExtrasItem('Harrisa', 0, true).toMap(),
//     ExtrasItem('Mustard', null, false).toMap()
//   ], noOfSelectableExtras: 0, isRequired: 0 ).toMap(),
//   Extras(name: 'Sides', extraItems: [
//     ExtrasItem('Cold drink', 1, true).toMap(),
//     ExtrasItem('Cookie', 0.5, true).toMap(),
//     ExtrasItem('Juice', null, true).toMap()
//   ],noOfSelectableExtras: 0, isRequired: 0).toMap(),
// ];