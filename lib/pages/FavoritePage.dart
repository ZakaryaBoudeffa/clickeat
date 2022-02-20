import 'package:clicandeats/firebaseFirestore/favoritesOp.dart';
import 'package:clicandeats/firebaseFirestore/menuCategoriesOp.dart';
import 'package:clicandeats/firebaseFirestore/restaurantsOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/favorite/favoriteCard.dart';
import 'package:clicandeats/widgets/favorite/favoritePlatCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clicandeats/models/menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  final String uId;
  FavoritePage({required this.uId});
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 16),
            title: Text(
              'Favoris',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: _settings.themeLight ? Colors.black : Colors.white),
            ),
            bottom: TabBar(
              unselectedLabelColor: Theme.of(context).accentColor,
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(
                  text: 'Restaurants',
                ),
                Tab(
                  text: 'Plats',
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                //size: 40,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: TabBarView(
          children: [favRestos(), favDishes()],
        ),
      ),
    );
  }

  Widget favRestos() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFavoriteOp().getFavoriteRestos(uId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot<Object?>? s = snapshot.data;
            print("S: ${s!.data().toString().contains('favRestos')}");
            if (s.data().toString().contains('favRestos')  && List.from(snapshot.data!.get('favRestos')).length > 0) {
              if (List.from(snapshot.data!.get('favRestos')).length > 0) {
                print(
                    "FAV RESTOS: ${List.from(snapshot.data!.get('favRestos'))}");
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: List.from(snapshot.data!.get('favRestos'))
                          .map((e) => FutureBuilder(
                              future: FirebaseResOp()
                                  .getRestaurantDetails(resId: e),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data!.exists? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: FavoriteCard(
                                          isAsset:
                                          snapshot.data!.get('avatar') == null ? true : false,
                                          name: snapshot.data!.get('name'),
                                          img: snapshot.data!.get('avatar') ??'assets/images/app_icon.png',
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  ): Container(
                                    height: MediaQuery.of(context).size
                                        .height * 0.7,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/images/decor.svg', height: 100, width: 100,),
                                        Text(
                                            'Aucun Restaurant préféré trouvé'),
                                      ],
                                    ),
                                  );
                                } else
                                  return Container();
                              }))
                          .toList()),
                );
              } else
                return Container(
                  height: MediaQuery.of(context).size
                      .height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/decor.svg', height: 100, width: 100,),
                      Text(
                          'Aucun Restaurant préféré trouvé'),
                    ],
                  ),
                ); //No favorite
              // restos found
            } else
              return Container(
                height: MediaQuery.of(context).size
                    .height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/decor.svg', height: 100, width: 100,),
                    Text(
                        'Aucun Restaurant préféré trouvé'),
                  ],
                ),
              ); //No favorite restos
            // found
          }
          return Center(child: Text('$loadingText'));
        });
  }

  Widget favDishes() {
    return StreamBuilder(
        stream: FirebaseFavoriteOp().getFavoriteDishes(uId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot<Object?>? s = snapshot.data;
            print("S: ${s!.data().toString().contains('favDishes')}");
            if (s.data().toString().contains('favDishes')) {
              if (List.from(snapshot.data!.get('favDishes')).length > 0) {
                print(
                    "FAV Dishes: ${List.from(snapshot.data!.get('favDishes'))}");
                return SingleChildScrollView(
                  child: Column(
                      children: List.from(snapshot.data!.get('favDishes'))
                          .map((e) => FutureBuilder(
                              future: FirebaseMenuCategoriesOp().getMealDetails(
                                  e.toString().split(":")[1],
                                  e.toString().split(":")[0]),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData) {

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: FavoriteCard(
                                          isAsset:
                                          snapshot.data!.get('image') == null ?
                                          true : false,
                                          name: snapshot.data!.get('name'),
                                          img: snapshot.data!.get('image') ??'assets/images/app_icon.png',
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  );
                                } else
                                  return Center(child: Text(''));
                              }))
                          .toList()),
                );
              } else
                return Container(
                  height: MediaQuery.of(context).size
                      .height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/decor.svg', height: 100, width: 100,),
                      Text(
                          'Pas de plats favoris pour l\'instant..'),
                    ],
                  ),
                );; // no fav plat found
            } else
              return Container(
                height: MediaQuery.of(context).size
                    .height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/decor.svg', height: 100, width: 100,),
                    Text(
                        'Pas de plats favoris pour l\'instant..'),
                  ],
                ),
              ); //no fav plat found
          }
          return Center(child: Text('$loadingText'));
        });
  }
}
