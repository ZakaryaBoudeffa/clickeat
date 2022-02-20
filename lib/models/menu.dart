

class MenuCategory {
  String name;
  List<Map<String, dynamic>>? meals = [];
  List<dynamic> mealIds = [];
  MenuCategory({required this.name, required this.meals,required this.mealIds});


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'meals':meals,
      'mealIds': mealIds
    };
  }

  MenuCategory fromMap(Map json){
    return MenuCategory(name: json['name'], meals: json['meals'], mealIds: json['mealIds']);
  }
}



//
// List<MenuCategory> menuCardList = [
//   MenuCategory(name: "Continental", plats: [
//     Dish(
//       image: 'assets/images/products/p1.jpg',
//       name: 'Kabab',
//       price: 24,
//       discountedPrice: 22,
//       isAvailable: true,
//       extras: extrasList,
//       dsc: 'Lorem ipsum dolor sit amet,  consectetur adipiscing elit. Lorem ipsum dolor sit amet,  consectetur adipiscing elit. Lorem ipsum dolor sit amet,  consectetur adipiscing elit.Lorem ipsum dolor sit amet,  consectetur adipiscing elit..',
//     ),
//     Dish(
//       image: 'assets/images/products/p2.jpg',
//       name: 'Bourak',
//       price: 30,
//       discountedPrice: 18,
//       isAvailable: true,
//       dsc: 'Lorem ipsum dolor sit amet,  consectetur adipiscing elit..',
//     ),
//     Dish(
//       image: 'assets/images/products/p3.jpg',
//       name: 'caesar salad',
//       price: 32,
//       discountedPrice: 27,
//       isAvailable: true,
//       extras: extrasList,
//       dsc: 'Lorem ipsum dolor sit amet,  consectetur adipiscing elit..',
//     ),
//   ]),
//
//   MenuCategory(name: "Fast Food", plats: [
//     Dish(
//       image: 'assets/images/products/p5.jpg',
//       name: 'Kabab',
//       price: 24,
//       discountedPrice: 22,
//       isAvailable: true,
//       dsc: 'Lorem ipsum dolor sit amet,  consectetur adipiscing elit. Lorem ipsum dolor sit amet,  consectetur adipiscing elit. Lorem ipsum dolor sit amet,  consectetur adipiscing elit.Lorem ipsum dolor sit amet,  consectetur adipiscing elit..',
//     ),
//     Dish(
//       image: 'assets/images/products/p6.jpg',
//       name: 'Bourak',
//       price: 30,
//       discountedPrice: 18,
//       isAvailable: true,
//       dsc: 'Lorem ipsum dolor sit amet,  consectetur adipiscing elit..',
//     ),
//   ]),
// ];
