import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:clicandeats/firebaseFirestore/geoFlutterFire.dart';
import 'package:clicandeats/firebaseFirestore/notifications.dart';
import 'package:clicandeats/firebaseFirestore/ordersOp.dart';
import 'package:clicandeats/firebaseFirestore/restaurantsOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/extras.dart';
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/pages/trackOrderMapPage.dart';
import 'package:clicandeats/services/httpService.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/signup/registrationFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../main.dart';
import 'orderedProductCard.dart';

class OrderedCard extends StatelessWidget {
  TextEditingController commentController = TextEditingController();
  TextEditingController tipAmountController = TextEditingController();
  TextEditingController starsController = TextEditingController();
  final Order order;
  final List<OrderedMeal> orderedMeals;
  OrderedCard({required this.order, required this.orderedMeals});
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    Stripe.publishableKey =
        "pk_test_51JLTYJDoc9ztdhid3M7JX2QnBsGsr5HNvVqu52Z0gbWMCOWrPi3Or693cdJtCgzj3xIhrqIrgkTFZaOkElfJs6Vj00CTEQxutB";
    // TODO: switch to live here
    // Stripe.publishableKey =
    //     "pk_live_51JLTYJDoc9ztdhid6JsyBDRjZaZQqTI5BYbsf4CwLWsadERfPwyBLKXfyWM6mkyU0Xr0JRow7ghfrEIRtAQMSo9A00IEvulum6";

    starsController.text = '1';
    return order.status > 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _settings.themeLight ? Colors.white : darkAccentColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: _settings.themeLight
                        ? Colors.grey[200]!
                        : Colors.black26,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Commande #${order.orderNo!.split('.')[1]}',
                            style: TextStyle(),
                          ),
                        ),
                        order.status >= 1 && order.status < 4
                            ? statusDecor(
                                'Commande passée',
                                _settings.themeLight
                                    ? Colors.blue
                                    : Colors.white, //order placed
                                Colors.blue.withOpacity(0.2))
                            : order.status == 4
                                ? statusDecor(
                                    'in preparation',
                                    _settings.themeLight
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.7)
                                        : Colors.white,
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1))
                                : order.status == 5
                                    ? statusDecor(
                                        'prête', //ready
                                        _settings.themeLight
                                            ? Theme.of(context).primaryColor
                                            : Colors.white,
                                        Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3))
                                    : order.status == 6
                                        ? statusDecor(
                                            'en chemin', //on the way
                                            _settings.themeLight
                                                ? Colors.pink
                                                : Colors.white,
                                            Colors.pink.withOpacity(0.1))
                                        : order.status == 7
                                            ? statusDecor(
                                                'commande livré', //delivered
                                                _settings.themeLight
                                                    ? Colors.green.shade700
                                                    : Colors.white,
                                                Colors.green.shade700
                                                    .withOpacity(0.3))
                                            : order.status == 8
                                                ? statusDecor(
                                                    'annulé', //cancelled
                                                    _settings.themeLight
                                                        ? Colors.red.shade700
                                                        : Colors.white,
                                                    Colors.red.shade700
                                                        .withOpacity(0.3))
                                                : Text(
                                                    '',
                                                    style: TextStyle(
                                                        // fontSize: 17,
                                                        //color: Colors.black,
                                                        ),
                                                  ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ExpansionTile(
                      collapsedIconColor:
                          _settings.themeLight ? Colors.black : Colors.white,
                      iconColor:
                          _settings.themeLight ? Colors.black : Colors.white,
                      tilePadding: EdgeInsets.all(0),
                      childrenPadding: EdgeInsets.only(bottom: 20),
                      title: Text(
                        'Des détails', //details
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _settings.themeLight
                                ? Colors.black
                                : Colors.white),
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Adresse : ',
                                      style: TextStyle(),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${order.deliveryAddress} ',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          // color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: orderedMeals
                                  .map(
                                    (e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: FutureBuilder(
                                          future: FirebaseOpOrders()
                                              .getMealDetails(
                                                  e.mealId, order.resId),
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        '${snapshot.data!.get('image')}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          snapshot.data!
                                                              .get('name'),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            //color: Colors.black,
                                                          ),
                                                        ),
                                                        e.extrasList.length > 0 ?  Text(
                                                          '${e.mealPrice} + ${e.extrasAmount} € x${e.qtt}',
                                                          // 'x${e.qtt} (${snapshot.data!.get('price')}€)',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ): Text(
                                                          '${e.mealPrice} € x${e.qtt}',
                                                          // 'x${e.qtt} (${snapshot.data!.get('price')}€)',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            ...extras.map((extra)
                                                            {
                                                              return Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text('${extra
                                                                      .name}:',
                                                                    style: TextStyle
                                                                      (
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                        decoration:
                                                                        TextDecoration
                                                                            .underline),),
                                                                  Padding(
                                                                    padding: const
                                                                    EdgeInsets
                                                                        .symmetric
                                                                      (horizontal:
                                                                    10, vertical: 4),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        ...extra
                                                                            .extraItems!.map(
                                                                                (extraItems) {
                                                                              ExtrasItem extraItem = ExtrasItem.fromJson(extraItems);
                                                                              return
                                                                                Row(
                                                                                  children: [
                                                                                    Text
                                                                                      (extraItem.name),
                                                                                    Expanded(child: Container(),),
                                                                                    Text('${extraItem.price!.toStringAsFixed(2)} €')
                                                                                  ],
                                                                                );
                                                                            })
                                                                      ],),
                                                                  )
                                                                ],
                                                              );}
                                                            ),
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
                      ],
                    ),
                  ),
                  order.status == 7 && order.tip > 0
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Astuce ajoutée',
                                style: TextStyle(),
                              ),
                              Text(
                                ' ${order.tip.toStringAsFixed(2)}€',
                                style: TextStyle(
                                    // color: Colors.amber.shade700,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  order.status == 7 && order.rated == true
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Évalué',
                                style: TextStyle(),
                              ),
                              Text(
                                ' ${order.orderRating['stars'].toString()} ☆',
                                style: TextStyle(
                                  color: _settings.themeLight
                                      ? Colors.amber.shade700
                                      : Colors.amber.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(),
                        ),
                        Text(
                          '${DateFormat('kk:mm (dd/MM/yyyy)').format(order.orderTime)}',
                          style: TextStyle(
                              // color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coupon',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          (order.couponCode == null
                              ? 'Pas de coupon'
                              : order.couponCode)!,
                          style: TextStyle(
                            fontSize: 13,
                            //color: Colors.black
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sous total ',
                          style: TextStyle(),
                        ),
                        Text(
                          '${(order.total - order.deliveryFee).toStringAsFixed(2)}€',
                          style: TextStyle(
                              //color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Frais de livraison ', //delivery fee
                          style: TextStyle(),
                        ),
                        Text(
                          '${order.deliveryFee.toStringAsFixed(2)}€',
                          style: TextStyle(
                              // color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            //color: Colors.black,
                          ),
                        ),
                        Text(
                          '${order.total.toStringAsFixed(2)}€',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  order.status == 6
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            child: Text(
                              'Track order',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 40,
                            //  minWidth: double.maxFinite,
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              //fetch locations before push
                              DocumentSnapshot restaurant =
                                  await FirebaseResOp()
                                      .getRestaurantDetails(resId: order.resId);
                              String resName = restaurant.get('name');
                              String resAddr = restaurant.get('address');
                              GeoFirePoint source = await FlutterFireOpGeo()
                                  .convertAddressToCoordinates(resAddr);
                              GeoFirePoint dest = await FlutterFireOpGeo()
                                  .convertAddressToCoordinates(
                                      order.deliveryAddress);
                              final Uint8List sourceIcon =
                                  await getBytesFromAsset(
                                      'assets/images/res_icon.png', 150);
                              final Uint8List destIcon =
                                  await getBytesFromAsset(
                                      'assets/images/dest_icon.png', 150);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackOrder(
                                        order: order,
                                        orderedMeals: orderedMeals,
                                        resName: resName,
                                        resAddrs: resAddr,
                                        source: source,
                                        dest: dest,
                                        sourceIcon: sourceIcon,
                                        destIcon: destIcon)),
                              );
                            },
                          ),
                        )
                      : Container(),
                  order.deliveryCode != '' && order.deliveryCode != null
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Code de livraison',
                                style: TextStyle(),
                              ),
                              Text(
                                ' ${order.deliveryCode}',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  order.status == 7
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              order.tip == 0
                                  ? MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10))),
                                      height: 40,
                                      //  minWidth: double.maxFinite,
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              actions: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Annuler"),
                                                ),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    //
                                                    //TODO open payment sheet
                                                    await _initPaymentSheet(
                                                        tipAmountController
                                                            .text,
                                                        order.id,
                                                        context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Soumettre",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                                //Text('Submit')
                                              ],
                                              insetPadding: EdgeInsets.all(10),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 16),
                                              title: Text(
                                                'Ajouter un pourboire au livreur',
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: RegistrationTextFormField(
                                                        isObsecure: false,
                                                        icon: Icons
                                                            .monetization_on_rounded,
                                                        label:
                                                            'Entrer le montant',
                                                        controller:
                                                            tipAmountController,
                                                        keyboard: TextInputType
                                                            .number),
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                      child: Text(
                                        'Ajouter un pourboire',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                              order.rated == false
                                  ? SizedBox(width: 25)
                                  : Container(),
                              order.rated == false
                                  ? MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10))),
                                      height: 40,
                                      //  minWidth: double.maxFinite,
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        TextStyle ts = TextStyle(
                                            color: _settings.themeLight
                                                ? Colors.black
                                                : Colors.white);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              backgroundColor:
                                                  _settings.themeLight
                                                      ? Colors.white
                                                      : darkAccentColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              actions: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Annuler"),
                                                ),
                                                MaterialButton(
                                                  onPressed: () async {
                                                    //TODO - in resto order, customer order and all orders update the rating map
                                                    await FirebaseOpOrders()
                                                        .rateOrder(
                                                            order.id,
                                                            order.resId,
                                                            order.customerId,
                                                            double.parse(
                                                                starsController
                                                                    .text),
                                                            commentController
                                                                .text);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Soumettre",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                                //Text('Submit')
                                              ],
                                              insetPadding: EdgeInsets.all(20),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 16),
                                              title: Text(
                                                'Comment s\'est passée votre commande ?',
                                                textAlign: TextAlign.center,
                                                style: ts,
                                              ),
                                              content: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(
                                                    'Veuillez partager vos précieux commentaires',
                                                    textAlign: TextAlign.center,
                                                    style: ts,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: RatingBar.builder(
                                                      initialRating:
                                                          double.parse(
                                                              starsController
                                                                  .text),
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                        starsController.text =
                                                            rating.toString();
                                                        print(
                                                            "stars: ${starsController.text}");
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: RegistrationTextFormField(
                                                        isObsecure: false,
                                                        icon: Icons.text_fields,
                                                        label:
                                                            'Vos commentaires - facultatif',
                                                        controller:
                                                            commentController,
                                                        keyboard: TextInputType
                                                            .multiline),
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                      child: Text(
                                        'Ordre de taux',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget statusDecor(text, fontColor, bgColor) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fontColor,
        ),
      ),
    );
  }

  Map<String, dynamic>? _paymentSheetData;

  Future<void> _initPaymentSheet(String totalAmount, orderId, context) async {
    try {
      // 1. create payment intent on the server
      log("1. create payment intent on the server");
      log("CusId: $cusId : totalAmount: $totalAmount");
      _paymentSheetData = await HttpService().paymentSheet(cusId, totalAmount);

      if (_paymentSheetData!['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error code: ${_paymentSheetData!['error']}')));
        return;
      }

      // 2. initialize the payment sheet
      log('2. initialize the payment sheet');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: false,
          googlePay: false,
          //style: ThemeMode.dark,
          testEnv: false,
          merchantCountryCode: 'CE',
          merchantDisplayName: 'Clic&Eats',
          customerId: _paymentSheetData!['customer'],
          paymentIntentClientSecret: _paymentSheetData!['paymentIntent'],
          customerEphemeralKeySecret: _paymentSheetData!['ephemeralKey'],
        ),
      );
      // setState(() {
      _displayPaymentSheet(orderId, totalAmount, context);
      //  });
    } catch (e) {
      // setState(() {
      //   loading = false;
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> _displayPaymentSheet(orderId, tipAmount, context) async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
        clientSecret: _paymentSheetData!['paymentIntent'],
        confirmPayment: true,
      ));

      // setState(() {
      //   _paymentSheetData = null;
      // });

      await FirebaseOpOrders().addATip(order.customerId, order.resId,
          order.selectedCarrier, orderId, double.parse(tipAmount), context);
      await FirebaseNotificationsOp().addNotificationForDeliveryBoyForTip(
          'Vous avez un pourboire d\'un montant $tipAmount€ contre la commande # ${order.orderNo!.split('.')[1]}',
          order.selectedCarrier);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Paiement effectué avec succès'),
          // content: Text('Payment successfully completed'),
        ),
      );
    } on StripeException catch (e) {
      // setState(() {
      //   loading = false;
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: e.error.localizedMessage ==
                  "The payment has been "
                      "canceled"
              ? Text("La paiement a été annulé")
              : Text('${e.error.localizedMessage}'),
        ),
      );
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
