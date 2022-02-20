import 'package:clicandeats/firebaseFirestore/geoFlutterFire.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/day.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';

class OfferCard extends StatefulWidget {
  final String img;
  final String name;
  final List<Day>? timing;
  final String? categories;
  final bool isAsset;
  final String? type;
  final dynamic stars;
  final dynamic rated;
  final double distance;
  final double dFee;
  final GeoFirePoint dest;
  final double carrierFee;
  final double additionalKmFee;
  final String restaurantAddress;
  final bool isOpen;
  final VoidCallback? onclick;
  OfferCard(
      {required this.img,
      required this.name,
      required this.restaurantAddress,
      this.timing,
      this.categories,
      this.type,
      this.onclick,
      this.stars,
      this.rated,
      required this.carrierFee,
      required this.additionalKmFee,
      required this.dest,
      required this.distance,
      required this.dFee,
      required this.isOpen,
      required this.isAsset});

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  double distance = 0.0;
  double dist = 0.0;
  double dFee = 0.0;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   msc();
    //
    //   setState(() {
    //     print("DONEEEE");
    //     // msc();
    //   });
    // });
  }

  msc() {
    FlutterFireOpGeo()
        .convertAddressToCoordinates(widget.restaurantAddress)
        .then((value) {
      GeoFirePoint source = value;
      GeoFirePoint destination = widget.dest;
      print("SOURCE: ${source.latitude} ${source.longitude}");
      print("DEST: ${destination.latitude} "
          "${destination.longitude}");

      if (destination != GeoFirePoint(0.1, 0.1)) {
        distance = FlutterFireOpGeo().calculateDistance(destination, source);
        dist = distance;
        if (distance < 1) {
          dFee = widget.carrierFee;
        } else if (distance > 1) {
          dFee = widget.carrierFee;
          distance = distance - 1;
          for (; distance >= 0; distance--) {
            dFee = dFee + widget.additionalKmFee;
          }
        }
        print("DELIVERYFEE: $dFee");
      }

      //print("DIS : $distance");
      // setState(() {
      //
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return GestureDetector(
      onTap: () {
        if (widget.isOpen) if (widget.onclick != null) widget.onclick!();
      },
      child: Container(
        height: 190,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    border: Border.all(
                        color: _settings.themeLight
                            ? Colors.grey[100]!
                            : darkAccentColor),

                    color: _settings.themeLight
                        ? Colors.white
                        : Theme.of(context).scaffoldBackgroundColor,
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 10,
                    //     color: Colors.grey[100]!,
                    //   )
                    // ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: widget.isAsset
                        ? Image.asset(
                            widget.img,
                            fit: BoxFit.contain,
                          )
                        : Image.network(
                            widget.img,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                    decoration: BoxDecoration(
                        color: _settings.themeLight
                            ? Colors.white
                            : Theme.of(context).scaffoldBackgroundColor,
                        // color: Theme.of(context).primaryColor.withOpacity(0.7),
                        // border: Border.all(color: Theme.of(context).primaryColor, width:
                        // 1),
                        border: Border.all( color: _settings.themeLight
                            ? Colors.grey[100]!
                            : darkAccentColor),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(0))),
                    child: widget.rated == 0
                        ? Text(
                            'pas de notes',
                            style: TextStyle(fontSize: 12,
                                color: _settings.themeLight ? Colors.grey : Colors.white
                                // color: Theme.of(context).primaryColor
                                ),
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.star,
                                // color: Theme.of(context).primaryColor,
                                // color: Colors.black,
                                color: Colors.yellow.shade600,
                                size: 16,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                widget.stars == null
                                    ? '3.3'
                                    : widget.stars!.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Text(
                                widget.rated == null
                                    ? '(5)'
                                    : '(${widget.rated.toString()})',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                  ),
                )
              ],
            )),
            Container(
              width: 250,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: _settings.themeLight
                            ? Colors.grey[100]!
                            : darkAccentColor),
                    left: BorderSide(
                        color: _settings.themeLight
                            ? Colors.grey[100]!
                            : darkAccentColor),
                    right: BorderSide(
                        color: _settings.themeLight
                            ? Colors.grey[100]!
                            : darkAccentColor),
                  bottom: BorderSide(
                    //width: 0.2,
                        color: _settings.themeLight
                            ? Colors.grey[100]!
                            : darkAccentColor)),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: _settings.themeLight
                    ? Colors.white
                    : Theme.of(context).scaffoldBackgroundColor,
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 10,
                //     color: _settings.themeLight ? Colors.grey[100]! : Color(0xff33313),
                //   )
                // ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.isOpen
                              ? Theme.of(context).primaryColor
                              : null),
                    ),
                    Text(
                      widget.timing == null
                          ? "Ouvert 24h/20"
                          : '${widget.timing![0].startTime} - ${widget.timing![0].endTime}',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.categories == null
                                  ? 'fastfood'
                                  : widget.categories!
                                      .substring(
                                          1, widget.categories!.length - 1)
                                      .toLowerCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 11, fontStyle: FontStyle.italic
                                  //  color: Theme.of(context).primaryColor
                                  ),
                            ),
                          ),
                        ),
                        // rated == 0
                        //     ? Text(
                        //         'new',
                        //         style: TextStyle(
                        //             fontSize: 10,
                        //             color: Theme.of(context).primaryColor),
                        //       )
                        //     : Row(
                        //         children: [
                        //           Icon(
                        //             Icons.star,
                        //             color: Colors.yellow.shade700,
                        //             size: 14,
                        //           ),
                        //           SizedBox(
                        //             width: 1,
                        //           ),
                        //           Text(
                        //             stars == null ? '3.3' : stars!.toStringAsFixed(1),
                        //             style: TextStyle(
                        //               fontSize: 10,
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 1,
                        //           ),
                        //           Text(
                        //             rated == null
                        //                 ? '(5)'
                        //                 : '(${rated.toString()})',
                        //             style: TextStyle(
                        //               fontSize: 10,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                      ],
                    ),
                    widget.isOpen
                        ? Text(
                            'Ouvert',
                            style: TextStyle(color: Colors.green),
                          )
                        : Text('fermé'),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Icon(
                    //           Icons.location_history,
                    //           size: 16,
                    //           color: Theme.of(context).primaryColor,
                    //         ),
                    //         SizedBox(width: 2),
                    //         Text(
                    //           '${dist.toStringAsFixed(1)} km',
                    //           style: TextStyle(fontSize: 11),
                    //         )
                    //       ],
                    //     ),
                    //     Row(
                    //       children: [
                    //         Icon(
                    //           Icons.delivery_dining,
                    //           size: 16,
                    //           color: Theme.of(context).primaryColor,
                    //         ),
                    //         SizedBox(width: 2),
                    //         Text(
                    //           '${dFee.toStringAsFixed(2)} '
                    //           '€',
                    //           style: TextStyle(fontSize: 11),
                    //         )
                    //       ],
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
