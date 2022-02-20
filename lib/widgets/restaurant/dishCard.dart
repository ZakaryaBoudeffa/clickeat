import 'package:flutter/material.dart';

class DishCard extends StatelessWidget {
  final String img;
  final String name;
  final double price;
  final String desc;
  final double oldPrice;

  DishCard({
    required this.img,
    required this.name,
    required this.price,
    required this.desc,
    required this.oldPrice,
  });
  @override
  Widget build(BuildContext context) {
    return Card(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //color: Colors.grey[200],
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image.asset(
              img,
              width: MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.width * 0.4,

              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    //fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                  //  fontSize: 8,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${oldPrice.toStringAsFixed(0)}€',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      '${price.toStringAsFixed(0)}€',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.yellow[700],
                        ))
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
