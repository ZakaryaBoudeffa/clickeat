import 'dart:developer';
import 'package:clicandeats/firebaseFirestore/feeOp.dart';
import 'package:clicandeats/firebaseFirestore/geoFlutterFire.dart';
import 'package:clicandeats/firebaseFirestore/profileOp.dart';
import 'package:clicandeats/firebaseFirestore/resCategoryOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/client.dart';
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/services/placesServices.dart';
import 'package:clicandeats/utils/addressSearch.dart';
import 'package:clicandeats/utils/appBar.dart';
import 'package:clicandeats/widgets/drawer/myDrawer.dart';
import 'package:clicandeats/widgets/home/allRestaurants.dart';
import 'package:clicandeats/widgets/home/bestOffers.dart';
import 'package:clicandeats/widgets/home/donatedMoney.dart';
import 'package:clicandeats/widgets/home/popularResaurants.dart';
import 'package:clicandeats/widgets/home/topRated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Cart myCart = Cart(shippingAddress: "");
double donationPercent = 0;
String cusId = "";

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _search = TextEditingController();
  late String? userId;
  double carrierFee = 0.0;
  double additionalKmFee = 0.0;
  GeoFirePoint dest = GeoFirePoint(0, 0);
  @override
  void initState() {
    print("HOMEPAGE init State");
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    print("HOMEPAGE: DID CHANGE DEPENDENCIES");
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
      initializeShipping();
      initializeFee();
      initializeMe();
      print("HOMEPAGE init USERID: $userId");
      initializePlatformFee();
    } else {
      userId = "";
      _search.text = myCart.shippingAddress;
      print("HOMEPAGE - USER IS NOT LOGGED IN");
    }
    super.didChangeDependencies();
  }

  initializeShipping() async {
    DocumentSnapshot value =
        await FirebaseProfileOp().getShippingInfoFuture(userId);
    if (value.exists) {
      myCart = Cart(shippingAddress: value.get('address').toString());
      // myCart.shippingAddress = value.get('address').toString();
      print("^^^^^^^^^^^^^SHIPPING INITIALIZED ${myCart.shippingAddress}");
      dest = myCart.shippingAddress == ""
          ? GeoFirePoint(0.1, 0.1)
          : await FlutterFireOpGeo()
              .convertAddressToCoordinates(myCart.shippingAddress);
      print(
          "^^^^^^^^^^^^^DEST INITIALIZED ${dest.coords.latitude} : ${dest.coords.longitude}");
    }
    if(mounted)
    setState(() {});
  }

  initializeFee() async {
    DocumentSnapshot value = await FirebaseFeeOp().getFee();
    if (value.exists) {
      donationPercent = value.get('donationPercent');
      print("Donation percent initialized $donationPercent");
    }
  }

  initializePlatformFee() async {
    await FirebaseFirestore.instance
        .collection('fee')
        .doc('fee')
        .get()
        .then((value) {
      carrierFee = value.get('carrierFee');
      additionalKmFee = value.get('additionalKmFee').toDouble();
    }).then((value) {
      setState(() {});
    });
  }

  initializeMe() async {
    DocumentSnapshot value = await FirebaseProfileOp().getMyInfo(userId);
    if (value.exists) {
      cusId = value.get('cusId');
      print("cusID initialized $cusId");
    }
  }

  List<String> selectedCategoryList = [];
  List<String> categoryList = [
    'Food',
  ];
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    // selectedCategoryList.clear();
    print("CARRIER FEE : $carrierFee");
    return Scaffold(
      appBar: userId == ""
          ? AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: Icon(
                Icons.menu_rounded,
                size: 35,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
              title: Text(
                "Accueil",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            )
          : MyAppBar(
              back: false,
              uId: userId!,
              title: DonatedMoney(
                uId: userId!,
              ),
            ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
          // padding: EdgeInsets.symmetric(vertical: 0),
          child: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: FirebaseProfileOp().getShippingInfoFuture(userId),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    //   print(snapshot.data!.exists);
                    ShippingInfo info =
                        ShippingInfo.fromSnapshot(snapshot.data!.data());
                    _search.text = info.address!;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: TextFormField(
                        onTap: () async {
                          final sessionToken = Uuid().v4();
                          final Suggestion result = await showSearch(
                            context: context,
                            delegate: AddressSearch(sessionToken),
                          );
                          myCart.shippingAddress = result.description;
                          _search.text = result.description;
                          final placeDetails =
                              await PlaceApiProvider(sessionToken)
                                  .getPlaceDetailFromId(result.placeId);
                          log(placeDetails.toString());
                        },
                        readOnly: true,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500),
                        controller: _search,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          labelText: 'Livré à',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: _settings.themeLight ? Colors.black : Colors.grey
                          ),
                          fillColor: _settings.themeLight ? Colors.white :darkAccentColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            //  borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    );
                    // } else
                    //   return Text('Shipping info not found');
                  } else
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: TextFormField(
                        onTap: () async {
                          final sessionToken = Uuid().v4();
                          final Suggestion result = await showSearch(
                            context: context,
                            delegate: AddressSearch(sessionToken),
                          );
                          myCart.shippingAddress = result.description;
                          _search.text = result.description;
                          final placeDetails =
                          await PlaceApiProvider(sessionToken)
                              .getPlaceDetailFromId(result.placeId);
                          log(placeDetails.toString());
                        },
                        readOnly: true,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500),
                        controller: _search,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          labelText: 'Livré à',
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                          fillColor: _settings.themeLight ? Colors.white :darkAccentColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            //  borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    );
                }),
            SizedBox(
              height: 0,
            ),
            FutureBuilder<Object>(
                future: FirebaseResCategoriesOp().getCategoriesFuture(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.size > 0) {
                      snapshot.data!.docs.forEach((element) {
                        categoryList.add(element.get('name'));
                      });
                      return MultiSelectChipField<String>(
                        chipColor: Theme.of(context).scaffoldBackgroundColor,
                        textStyle: TextStyle(color: _settings.themeLight ? Theme.of(context).accentColor : Colors.white70),
                        items: categoryList
                            .map((String e) => MultiSelectItem(e, e))
                            .toList(),
                        icon: Icon(Icons.check),
                        onTap: (values) {
                          setState(() {
                            selectedCategoryList = values;
                          });
                        },
                        initialValue: List.from(selectedCategoryList),
                        showHeader: false,
                        headerColor: Colors.grey[200],
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        selectedTextStyle: TextStyle(color: Colors.black),
                        validator: (val) {
                          if (val == [])
                            return "Categori list can not be empty";
                        },
                      );
                    } else
                      return Container();
                  } else
                    return Text('--');
                }),
            SizedBox(
              height: 10,
            ),
            AllRestaurants(
              selectedCategoryList,
              uId: userId!,
              additionalKmFee: additionalKmFee,
              carrierFee: carrierFee,
              dest: dest,
            ),
            SizedBox(
              height: 30,
            ),
            PopularRestaurants(
              selectedCategoryList,
              uId: userId!,
              additionalKmFee: additionalKmFee,
              carrierFee: carrierFee,
              dest: dest,
            ),
            SizedBox(
              height: 30,
            ),
            TopRated(
              selectedCategoryList,
              uId: userId!,
              additionalKmFee: additionalKmFee,
              carrierFee: carrierFee,
              dest: dest,
            ),
            SizedBox(
              height: 30,
            ),
            BestOffers(
              selectedCategoryList,
              uId: userId!,
              additionalKmFee: additionalKmFee,
              carrierFee: carrierFee,
              dest: dest,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    log("HOME PAGE DISPOSED");
    super.dispose();
  }
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: 
      Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
            //  alignment: WrapAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,
                      vertical: 30),
                  child: Text('Choose your delivery location', textAlign:
                  TextAlign
                      .center, style: Theme.of
                    (context).textTheme
                      .headline6,),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25,
                //       vertical: 10),
                //   child: Text('Select your delivery address '),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: TextFormField(
                    onTap: () async {
                      final sessionToken = Uuid().v4();
                      final Suggestion result = await showSearch(
                        context: context,
                        delegate: AddressSearch(sessionToken),
                      );
                      myCart.shippingAddress = result.description;
                      _search.text = result.description;
                      final placeDetails =
                      await PlaceApiProvider(sessionToken)
                          .getPlaceDetailFromId(result.placeId);
                      log(placeDetails.toString());
                    },
                    readOnly: true,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                    controller: _search,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      labelText: 'Livré à',
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        //  borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
