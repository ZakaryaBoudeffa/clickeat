import 'package:clicandeats/firebaseFirestore/restaurantsOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/day.dart';
import 'package:clicandeats/models/restaurant.dart';
import 'package:clicandeats/pages/restaurantPage.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'offerCard.dart';

class TopRated extends StatelessWidget {
  List<String> filter;
  String uId;
  final double carrierFee;
  final double additionalKmFee;

  final GeoFirePoint dest;
  double distance = 0.0;
  double deliveryFee = 0.0;
  TopRated(this.filter, {required this.uId,
    required this.carrierFee,
    required this.additionalKmFee,
    required this.dest});

  @override
  Widget build(BuildContext context) {
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
                'Les mieux notés',
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
                stream: FirebaseResOp().getTopRatedRestaurants(filter),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data!.size > 0){ return Row(
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
                          // print("RATING: ${resto['rating']??"ok"}");
                          dynamic rated = resto['rating']['rated'] ?? 6;
                          dynamic stars = resto['rating']['stars'] ?? 4.0;
                          var currentDay = DateTime.now().weekday;
                          // print(
                          //     '${timing.length} - ${currentDay} resid: ${restaurant.id}');
                          restaurant.hours = timing;
                          return resto['rating']['stars'] > 0 ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: OfferCard(
                                onclick: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RestaurantPage(
                                          uId: uId,
                                          restaurant: restaurant,
                                          img: restaurant.avatar ??
                                              'assets/images/app_icon.png',
                                          isAsset: restaurant.avatar == null
                                              ? true
                                              : false,
                                          stars: stars,
                                          rated: rated)),
                                ),
                                name: restaurant.name!,
                                img: restaurant.avatar ??
                                    'assets/images/app_icon.png',
                                timing: timing,
                                categories: resto['category'].toString(),
                                isAsset:
                                restaurant.avatar == null ? true : false,
                                stars: stars,
                                distance: distance,
                                dFee: deliveryFee,
                                carrierFee: carrierFee,
                                additionalKmFee: additionalKmFee,
                                dest: dest,
                                restaurantAddress: restaurant.address!,
                                isOpen: restaurant.availability!,
                                rated: rated),
                          ) : Container();
                        })
                      ],
                    );}
                    else {
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
                    }

                  } else if (snapshot.hasError) {
                    print(snapshot.error);
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
