import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:clicandeats/firebaseFirestore/ordersOp.dart';
import 'package:clicandeats/firebaseFirestore/restaurantsOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/extras.dart';
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/models/restaurant.dart';
import 'package:clicandeats/utils/appBar.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/cart/productCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TrackOrder extends StatefulWidget {
  TrackOrder(
      {Key? key,
      required this.order,
      required this.resName,
      required this.resAddrs,
      required this.source,
      required this.sourceIcon,
      required this.destIcon,
      required this.dest,
      required this.orderedMeals})
      : super(key: key);

  Order order;
  String resName;
  String resAddrs;
  GeoFirePoint source;
  GeoFirePoint dest;
  Uint8List sourceIcon;
  Uint8List destIcon;
  final List<OrderedMeal> orderedMeals;
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  Set<Marker> markers = HashSet<Marker>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  // BehaviorSubject<double> radius = BehaviorSubject(seedValue: 100.0);
  late Stream<dynamic> query;
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    setMarkers(widget.source, widget.sourceIcon);
    setMarkers(widget.dest, widget.destIcon);
  }

  void setMarkers(GeoFirePoint point, Uint8List icon) {
    setState(() {
      markers.add(Marker(
          markerId: MarkerId(""),
          icon: BitmapDescriptor.fromBytes(icon),
          position: LatLng(point.latitude, point.longitude)));
    });
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double x0 = 0.0, x1 = 0.0, y0 = 0.0, y1 = 0.0;
    for (LatLng latLng in list) {
      if (x0 == 0.0) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return new Scaffold(
      appBar: MyAppBar(
        back: true,
        uId: widget.order.customerId,
        title: "Your order is on the way",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Expanded(flex: 2, child: Text('Your order from:')),
                    //     SizedBox(width: 20),
                    //     Expanded(flex: 4, child: Text('${widget.resName}')),
                    //   ],
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Expanded(flex: 2, child: Text('Source:')),
                    //     SizedBox(width: 20),
                    //     Expanded(flex: 4, child: Text('${widget.resAddrs}')),
                    //   ],
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Expanded(flex: 2, child: Text('Destination: ')),
                    //     SizedBox(width: 20),
                    //     Expanded(
                    //         flex: 4,
                    //         child: Text('${widget.order.deliveryAddress}')),
                    //   ],
                    // ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: widget.orderedMeals
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: FutureBuilder(
                                        future: FirebaseOpOrders()
                                            .getMealDetails(
                                                e.mealId, widget.order.resId),
                                        builder: (context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            print(
                                                "snapshot meal: ${snapshot.data!.get('name')}");
                                            List<Extras> extras = [];
                                            extras = e.extrasList
                                                .map((i) => Extras.fromJson(i))
                                                .toList();
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "x${e.qtt} ${snapshot.data!.get('name')}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              //color: Colors.black,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            '${e.mealPrice}€',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      // e.extrasList.length > 0 ?  Text(
                                                      //   '${e.mealPrice} + ${e.extrasAmount} € x${e.qtt}',
                                                      //   // 'x${e.qtt} (${snapshot.data!.get('price')}€)',
                                                      //   style: TextStyle(
                                                      //     fontSize: 12,
                                                      //     fontWeight: FontWeight.bold,
                                                      //     color: Colors.black,
                                                      //   ),
                                                      // ): Text(
                                                      //   '${e.mealPrice} € x${e.qtt}',
                                                      //   // 'x${e.qtt} (${snapshot.data!.get('price')}€)',
                                                      //   style: TextStyle(
                                                      //     fontSize: 12,
                                                      //     fontWeight: FontWeight.bold,
                                                      //     color: Colors.black,
                                                      //   ),
                                                      // ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ...extras
                                                              .map((extra) {
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${extra.name}:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          4),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      ...extra
                                                                          .extraItems!
                                                                          .map(
                                                                              (extraItems) {
                                                                        ExtrasItem
                                                                            extraItem =
                                                                            ExtrasItem.fromJson(extraItems);
                                                                        return Row(
                                                                          children: [
                                                                            Text(extraItem.name),
                                                                            Expanded(
                                                                              child: Container(),
                                                                            ),
                                                                            Text('${extraItem.price!.toStringAsFixed(2)} €')
                                                                          ],
                                                                        );
                                                                      })
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          }),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else
                                            return Text('$loadingText...');
                                        }),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Votre commande est en cours de livraison...',
                      style: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 20),
                    //   height: MediaQuery.of(context).size.height * 0.5,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(10),
                    //     child: GoogleMap(
                    //       mapType: MapType.normal,
                    //       initialCameraPosition: CameraPosition(
                    //         target: LatLng(
                    //             widget.dest.latitude, widget.dest.longitude),
                    //         zoom: 15,
                    //       ),
                    //       zoomControlsEnabled: true,
                    //       compassEnabled: true,
                    //       zoomGesturesEnabled: true,
                    //       myLocationEnabled: true,
                    //       myLocationButtonEnabled: true,
                    //       markers: markers,
                    //       mapToolbarEnabled: true,
                    //       cameraTargetBounds: CameraTargetBounds.unbounded,
                    //       onMapCreated: _onMapCreated,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      // height: 100,
                      child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("carriers")
                              .doc('nTzyqJeDiaMP7xBzXvNeZ2b8w6R2')
                              .get(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            //sighting = Sighting.fromMap(snapshot.data.data()); // Gives you the data map
                            if (snapshot.hasData) {
                              LatLng latLng = LatLng(
                                  snapshot.data!
                                      .get('location')['geopoint']
                                      .latitude,
                                  snapshot.data!
                                      .get('location')['geopoint']
                                      .longitude);
                              return Column(
                                children: [
                                  Text(
                                      '${snapshot.data!.get('location')['geopoint'].latitude.toString()}  : ${snapshot.data!.get('location')['geopoint'].longitude.toString()}'),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GoogleMap(
                                        mapType: MapType.normal,
                                        initialCameraPosition: CameraPosition(
                                          target: latLng,
                                          // target: LatLng(widget.dest.latitude, widget.dest.longitude),
                                          zoom: 15,
                                        ),
                                        zoomControlsEnabled: true,
                                        compassEnabled: true,
                                        zoomGesturesEnabled: true,
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: true,
                                        markers: markers,
                                        mapToolbarEnabled: true,
                                        cameraTargetBounds:
                                            CameraTargetBounds.unbounded,
                                        onMapCreated: _onMapCreated,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else
                              return Text("loading");
                          }),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });

    _controller.complete(controller);
    DocumentSnapshot s = (await FirebaseFirestore.instance
        .collection("carriers")
        .doc('nTzyqJeDiaMP7xBzXvNeZ2b8w6R2')
        .snapshots()) as DocumentSnapshot<Map<String, dynamic>>;
    var marker = Marker(
        position: LatLng(s.get('location')['geopoint'].latitude,
            s.get('location')['geopoint'].longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "marker"),
        markerId: MarkerId(''));

    mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(s.get('location')['geopoint'].latitude,
          s.get('location')['geopoint'].longitude),
      zoom: 15,
    )));
    // controller.moveCamera(
    //   CameraUpdate.newLatLngBounds(
    //     boundsFromLatLngList([
    //       LatLng(s.get('location')['geopoint'].latitude,
    //           s.get('location')['geopoint'].longitude),
    //       LatLng(widget.dest.latitude, widget.dest.longitude)
    //     ]),
    //     40.0,
    //   ),
    // );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(TrackOrder._kLake));
  // }
  //
  // void _updateMarkers(List<DocumentSnapshot> documentList) {
  //   print(documentList);
  //
  //   documentList.forEach((DocumentSnapshot document) {
  //     GeoPoint pos = document.data['position']['geopoint'];
  //     double distance = document.data['distance'];
  //     var marker = Marker(
  //         position: LatLng(pos.latitude, pos.longitude),
  //         icon: BitmapDescriptor.defaultMarker,
  //         infoWindow: InfoWindow(title: "marker"),
  //         markerId: MarkerId('')
  //     );
  //
  //     //mapController.addMarker(marker);
  //   });
  // }
  //
  // _startQuery() async {
  //   // Get users location
  //
  //
  //   // Make a referece to firestore
  //   var ref = firestore.collection('locations');
  //   GeoFirePoint center = geo.point(latitude: widget.source.latitude,
  //      longitude: widget.source.longitude);
  //
  //   firestore.collection('carriers').doc('nTzyqJeDiaMP7xBzXvNeZ2b8w6R2').get();
  //
  //   // subscribe to query
  //   subscription = radius.switchMap((rad) {
  //     return geo.collection(collectionRef: ref).within(
  //         center: center,
  //         radius: rad,
  //         field: 'position',
  //         strictMode: true
  //     );
  //   }).listen(_updateMarkers);
  // }

  // _updateQuery(value) {
  //   setState(() {
  //     radius.add(value);
  //   });
  // }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }
}
