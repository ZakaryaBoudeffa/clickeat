import 'package:clicandeats/models/category.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final List<Category> _categories = [
    Category(
      icon: 'assets/images/categories/sushi.png',
      name: 'Sushi',
    ),
    Category(
      icon: 'assets/images/categories/pizza.png',
      name: 'Pizza',
    ),
    Category(
      icon: 'assets/images/categories/fast.png',
      name: 'Fast food',
    ),
    Category(
      icon: 'assets/images/categories/kebab.png',
      name: 'Kebab',
    ),
    Category(
      icon: 'assets/images/categories/halal.png',
      name: 'Halal',
    ),
    Category(
      icon: 'assets/images/categories/hamburger.png',
      name: 'Burgers',
    ),
    Category(
      icon: 'assets/images/categories/chicken.png',
      name: 'Poulet',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
    //  width: MediaQuery.of(context).size.width,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
       // color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ..._categories.map<Widget>((cat) {
            return Card(
              margin: EdgeInsets.all(3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height:2,
                    ),
                    Image.asset(
                      cat.icon,
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      height:2,
                    ),
                    FittedBox(

                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(cat.name, maxLines: 1, style: TextStyle(fontSize: 12),),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}
