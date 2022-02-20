import 'package:clicandeats/models/restaurant.dart';
import 'package:clicandeats/widgets/restaurant/menu.dart';
import 'package:clicandeats/widgets/restaurant/infosRestaurant.dart';
import 'package:flutter/material.dart';

class RestaurantPage extends StatelessWidget {
  final String img;
  final bool isAsset;
  final Restaurant? restaurant;
  final dynamic stars;
  final dynamic rated;
  final String uId;
  RestaurantPage({required this.uId, this.restaurant, required this.img,required this.isAsset,  this.stars,
    this.rated,});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                InfosRestaurant(restaurant: restaurant, img: img, isAsset: isAsset, rated: rated, stars: stars,uId: uId, ),
                Divider(),
                Menu(resId: restaurant!.id, resName: restaurant!.name!, uId: uId,),
               // RestaurantReviews()
              ],
            ),
          ),
          Positioned(
              top: 35,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  constraints: BoxConstraints.tight(Size(40, 40)),
                  padding: EdgeInsets.zero,
                  color:Colors.white,
                  icon: Icon(
                    Icons.arrow_back,
                    //   size: 40,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
          )
        ],
      ),
    );
  }
}
