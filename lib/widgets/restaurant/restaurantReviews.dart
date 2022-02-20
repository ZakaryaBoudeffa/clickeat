import 'package:flutter/material.dart';

class Review {
  String name;
  int stars;
  String comment;
  Review({required this.name,required this.stars,required this.comment});
}

class RestaurantReviews extends StatelessWidget {
  final _reviews = [
    Review(
        name: 'Chafik Maouche',
        stars: 4,
        comment:
            'I recommend to everyone! I would like to come back here again and again.'),
    Review(
        name: 'Bilel',
        stars: 5,
        comment:
            'This cozy restaurant has left the best impressions! Hospitable hosts, delicious dishes, beautiful presentation, wide wine list and wonderful dessert. '),
    Review(
      name: 'John Doe',
      stars: 3,
      comment: 'i love this restaurant',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
       // padding: EdgeInsets.all(20),
       //  decoration: BoxDecoration(
       //    borderRadius: BorderRadius.circular(30),
       //    color: Colors.white,
       //    boxShadow: [
       //      BoxShadow(
       //        blurRadius: 10,
       //        color: Colors.grey[100],
       //      )
       //    ],
       //  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commentaires',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ..._reviews.map((e) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          e.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 20,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: e.stars,
                              itemBuilder: (context, index) {
                                return Icon(
                                  Icons.star,
                                  color: Colors.yellow.shade700,
                                  size: 15,
                                );
                              }),
                        )
                      ],
                    ),
                    Text(
                      e.comment,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
