import 'package:clicandeats/firebaseFirestore/geoFlutterFire.dart';
import 'package:clicandeats/firebaseFirestore/restaurantsOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/day.dart';
import 'package:clicandeats/models/restaurant.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/pages/restaurantPage.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/home/offerCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AllRestaurants extends StatelessWidget {
  List<String> filter;
  String uId;
  double carrierFee;
  double additionalKmFee;

  final GeoFirePoint dest;
  double distance = 0.0;
  double deliveryFee = 0.0;
  AllRestaurants(this.filter,
      {required this.uId,
      required this.carrierFee,
      required this.additionalKmFee,
      required this.dest});
  @override
  Widget build(BuildContext context) {
    print("ALL RESTAURANTS build");
    var _settings = Provider.of<AppStateManager>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tous les Restaurants',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Voir tout',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_forward,
                      size: 20, color: Theme.of(context).primaryColor
                      //color: Color(0xFFBFBFBF),
                      )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: StreamBuilder(
                stream: FirebaseResOp().getAllRestaurants(filter),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.size > 0) {
                      return Row(
                        children: [
                          ...snapshot.data!.docs.map((resto) {
                            Restaurant restaurant =
                                Restaurant.fromSnapshot(resto);
                            List<Day> timing = [];
                            var list = resto['hours'];
                            if (list!.length > 0) {
                              for (int i = 0; i < 7; i++)
                                if (DateTime.now().weekday == i + 1)
                                  timing.add(Day.fromMap(list[i]));
                            }
                            dynamic rated = resto['rating']['rated'] ?? 6;
                            dynamic stars = resto['rating']['stars'] ?? 4.0;
                            restaurant.hours = timing;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: OfferCard(
                                onclick: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RestaurantPage(
                                          uId: uId,
                                          restaurant: restaurant,
                                          img: restaurant.avatar == null
                                              ? 'assets/images/app_icon.png'
                                              : restaurant.avatar!,
                                          isAsset: restaurant.avatar == null
                                              ? true
                                              : false,
                                          stars: stars,
                                          rated: rated)),
                                ),
                                name: restaurant.name!,
                                img: restaurant.avatar == null
                                    ? 'assets/images/app_icon.png'
                                    : restaurant.avatar!,
                                timing: timing,
                                categories: resto['category'].toString(),
                                isAsset:
                                    restaurant.avatar == null ? true : false,
                                stars: stars,
                                dFee: deliveryFee,
                                distance: distance,
                                restaurantAddress: restaurant.address!,
                                isOpen: restaurant.availability!,
                                rated: rated,
                                carrierFee: carrierFee,
                                additionalKmFee: additionalKmFee,
                                dest: dest,
                              ),
                            );
                          })
                        ],
                      );
                    } else
                      return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 35,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Oups, aucun partenaire propose cette catégorie de plat,',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Choisissez une autre catégorie',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('$errorText'));
                  } else
                    return placeholderCard(_settings);
                }),
          ),
        ),
      ],
    );
  }
}
