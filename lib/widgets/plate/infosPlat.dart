import 'package:clicandeats/firebaseFirestore/favoritesOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/dish.dart';
import 'package:clicandeats/models/extras.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoPlat extends StatefulWidget {
  final Dish plat;
  final String resId;
  final String platId;
  final String resName;
  final uId;
  InfoPlat(
      {required this.uId,
      required this.plat,
      required this.resId,
      required this.platId,
      required this.resName});
  @override
  _InfoPlatState createState() => _InfoPlatState();
}

class _InfoPlatState extends State<InfoPlat> {
  bool _fav = false;

  @override
  Widget build(BuildContext context) {
    print('plat id ${widget.platId} : ${widget.resId}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.6,
          child: Image.network(
            widget.plat.image,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.plat.name,

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        //color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.plat.discountedPrice > 0
                          ? Text(
                              '${widget.plat.price.toStringAsFixed(2)}€',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${((calculateDishTotalOnly(widget.plat.price, widget.plat.discountedPrice)).toStringAsFixed(2)).toString()} €',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      widget.uId != "" ?FutureBuilder(
                          future: FirebaseFavoriteOp()
                              .getFavDishStatus(widget.uId),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              DocumentSnapshot<Object?>? s = snapshot.data;
                              // print(
                              //     "S: ${s!.data().toString().contains('favDishes')}");
                              if (s!.data().toString().contains('favDishes')) {
                                // print(
                                //     'fav snapshot ${snapshot.data!.get('favDishes')}');
                                var temp =
                                    List.from(snapshot.data!.get('favDishes'));
                                if (temp.contains(
                                    widget.resId + ":" + widget.platId)) {
                                 // print("is FAV");
                                  _fav = true;
                                } else {
                                 // print("no fav");
                                  _fav = false;
                                }
                              } else
                                _fav = false;

                              return IconButton(
                                icon: Icon(
                                  _fav
                                      ? CupertinoIcons.suit_heart_fill
                                      : CupertinoIcons.suit_heart,
                                  size: 20,
                                  color: Colors.red[700],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _fav = !_fav;
                                    if (_fav == true)
                                      FirebaseFavoriteOp().addDishToFavorites(
                                          widget.uId,
                                          widget.resId,
                                          widget.platId);
                                    if (_fav == false)
                                      FirebaseFavoriteOp()
                                          .removeDishFromFavorites(
                                              widget.uId,
                                              widget.resId,
                                              widget.platId);
                                  });
                                },
                              );
                            } else
                              return Text("");
                          }) : Container(),
                      // IconButton(
                      //   constraints: BoxConstraints.tight(Size(20, 20)),
                      //   padding: EdgeInsets.zero,
                      //   icon: Icon(
                      //     _fav ? Icons.favorite : Icons.favorite_border,
                      //     //  size: 30,
                      //     color: Colors.red,
                      //   ),
                      //   onPressed: () {
                      //     setState(() {
                      //       FirebaseFavoriteOp().addDishToFavorites(currentUserID,  widget.resId, widget.platId);
                      //       _fav = !_fav;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Theme.of(context).accentColor,
                    size: 18,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    '${widget.resName}',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   widget.plat.dsc,
              //   style: TextStyle(
              //     fontWeight: FontWeight.normal,
              //     // fontSize: 14,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
