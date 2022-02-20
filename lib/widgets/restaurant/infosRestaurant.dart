import 'package:clicandeats/firebaseFirestore/favoritesOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfosRestaurant extends StatefulWidget {
  final String img;
  final bool isAsset;
  final Restaurant? restaurant;
  final dynamic stars;
  final dynamic rated;
  final uId;
  InfosRestaurant({required this.uId, this.restaurant, required this.img, required this.isAsset, this.stars,
    this.rated});
  @override
  _InfosRestaurantState createState() => _InfosRestaurantState();
}

class _InfosRestaurantState extends State<InfosRestaurant> {
  bool _fav = false;
  @override
  Widget build(BuildContext context) {
    print("InfosRestaurant UserId: ${widget.uId == ""}");
    var _settings = Provider.of<AppStateManager>(context);
    return Container(
      color: _settings.themeLight ?  Colors.white : Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //color: Colors.white,
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.5,
            child: widget.isAsset
                ? Image.asset(
                    '${widget.img}',
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    '${widget.img}',
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ExpansionTile(
                  collapsedIconColor: _settings.themeLight ? Colors.black : Colors.white,
                  iconColor: _settings.themeLight ? Colors.black : Colors.white,

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.restaurant == null
                            ? 'Kababitshi'
                            : widget.restaurant!.name!,
                        style: Theme.of(context).textTheme.headline5!.apply(color: _settings.themeLight ? Colors.black : Colors.white),
                      ),
                     widget.uId != "" ? FutureBuilder(
                        future: FirebaseFavoriteOp().getFavStatus(widget.uId, widget.restaurant!.id),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if(snapshot.hasData){
                            DocumentSnapshot<Object?>? s = snapshot.data;
                           // print("S: ${s!.data().toString().contains('favRestos')}");
                            if (s!.data().toString().contains('favRestos')){
                              //print('fav snapshot ${snapshot.data!.get('favRestos')}');
                              var temp = List.from(snapshot.data!.get('favRestos'));
                              if(temp.contains(widget.restaurant!.id))
                              {
                               // print("is FAV");
                                _fav = true;
                              }
                              else {
                               // print("no fav");
                                _fav = false;
                              }
                            }
                            else _fav = false;

                            return IconButton(
                              icon: Icon(
                                _fav ? CupertinoIcons.suit_heart_fill : CupertinoIcons.suit_heart,
                                size: 20,
                                color: Colors.red[700],
                              ),
                              onPressed: () {
                                setState(() {
                                  _fav = !_fav;
                                  if(_fav == true)
                                    FirebaseFavoriteOp().addResToFavorites(widget.uId, widget.restaurant!.id);
                                  if(_fav == false)
                                    FirebaseFavoriteOp().removeResFromFavorites(widget.uId, widget.restaurant!.id);

                                });
                              },
                            );
                          }
                          else return Text("");

                        }
                      ) : Container(),
                    ],
                  ),
                  tilePadding: EdgeInsets.zero,

                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            widget.restaurant == null
                                ? 'location 25'
                                : widget.restaurant!.address!,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade600,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(widget.rated == 0 ? 'Pas encore d\'évaluation' :
                        '${widget.stars.toStringAsFixed(1)}'),
                        SizedBox(width: 5),
                       widget.rated == 0 ? Container() : Text('(${widget.rated})'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.short_text,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            widget.restaurant == null
                                ? 'A cozy coffee bar & shoppe serving handcrafted pour overs, and the classic espressos, lattes and an amazing tea selection. We\'re famous for kaya butter toast, but we also serve other favorites. We offer a great selection of locally curated products a.'
                                : widget.restaurant!.dsc!,
                            textAlign: TextAlign.justify,
                            style: TextStyle(

                                //fontWeight: FontWeight.w800,
                                // fontSize: 13,
                                ),
                          ),
                        ),
                      ],
                    ),
                    widget.restaurant != null && widget.restaurant!.dsc != ""
                        ? SizedBox(
                            height: 20,
                          )
                        : Container(),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.restaurant == null
                              ? 'Horaires d\'ouverture: 8:00 am - 9:00 pm'
                              : 'Horaires d\'ouverture: ${widget.restaurant!.hours![0].startTime} - ${widget.restaurant!.hours![0].endTime}',
                          style: TextStyle(
                              // color: Colors.black87,
                              // fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.delivery_dining,
                    //       color: Theme.of(context).primaryColor,
                    //       size: 20,
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //       'Frais de livraison : 25€',
                    //       style: TextStyle(
                    //           //color: Colors.black87,
                    //           //fontSize: 12,
                    //           ),
                    //     ),
                    //   ],
                    // ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
