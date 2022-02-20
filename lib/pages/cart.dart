import 'dart:developer';

import 'package:clicandeats/firebaseFirestore/associationsOp.dart';
import 'package:clicandeats/firebaseFirestore/notifications.dart';
import 'package:clicandeats/firebaseFirestore/ordersOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/dish.dart';
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/pages/paymentSuccessPage.dart';
import 'package:clicandeats/pages/signInPage.dart';
import 'package:clicandeats/services/httpService.dart';
import 'package:clicandeats/utils/appBar.dart';
import 'package:clicandeats/widgets/cart/applyCoupon.dart';
import 'package:clicandeats/widgets/cart/productCard.dart';
import 'package:clicandeats/widgets/drawer/myDrawer.dart';
import 'package:clicandeats/widgets/drawer/shippinginfos.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class CartPage extends StatefulWidget {
  final String uId;
  final bool back;
  final String resId;
  CartPage(this.back, {required this.uId, required this.resId});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, dynamic>? _paymentSheetData;
  double deliveryFee = 0.0;
  bool loading = false;
  late double _mealAndExtrasTotal;
  late double discount;

  String resId = "";
  String resName = "";
  double couponVal = 0.0;
  bool invalidCoupon = false;
  String? _couponCode;

  double extrasTotal = 0;
  double discountTotal = 0;
  double mealsTotal = 0;
  double couponTotal = 0;
  double associationTotal = 0;

  totalTotal() {
    double t = mealsTotal + extrasTotal;
    print("totalTotal t: $t");
    print('extras Total : $extrasTotal');
  }

  _calcTotal() {
    _mealAndExtrasTotal = 0.0;
    discount = 0.0;
    extrasTotal = 0.0;
    discountTotal = 0.0;
    mealsTotal = 0.0;
    couponTotal = 0.0;
    associationTotal = 0.0;

    for (var e in inCart) {
      mealsTotal += e.calculatedDishOnlyPrice * e.qtt;
      discountTotal += e.originalPrice * e.discountPercent / 100 * e.qtt;
      extrasTotal += e.extrasAmount * e.qtt;
      print(e.extrasAmount);
      _mealAndExtrasTotal +=
          e.calculatedDishOnlyPrice * e.qtt + e.extrasAmount * e.qtt;
      discount += e.originalPrice * e.discountPercent / 100 * e.qtt;
    }
    totalTotal();
    setState(() {});
  }

  @override
  void initState() {
    _calcTotal();
    getResIdFromPrefs();
    setState(() {});
    super.initState();
  }

  getResIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('myCart_resId')) {
      resId = prefs.getString('myCart_resId')!;
      resName = prefs.getString('myCart_resName')!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    Stripe.publishableKey =
        "pk_test_51JLTYJDoc9ztdhid3M7JX2QnBsGsr5HNvVqu52Z0gbWMCOWrPi3Or693cdJtCgzj3xIhrqIrgkTFZaOkElfJs6Vj00CTEQxutB";
    // TODO: switch to live here
    // Stripe.publishableKey =
    //     "pk_live_51JLTYJDoc9ztdhid6JsyBDRjZaZQqTI5BYbsf4CwLWsadERfPwyBLKXfyWM6mkyU0Xr0JRow7ghfrEIRtAQMSo9A00IEvulum6";

    return Scaffold(
        appBar: widget.uId == ""
            ? AppBar(
                //automaticallyImplyLeading: true,
                leading: widget.back
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          //size: 40,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    : Builder(builder: (BuildContext context) {
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
                  "Mon panier",
                  style: TextStyle(fontSize: 16, color: _settings.themeLight ? Colors.black : Colors.white),
                ),
              )
            : MyAppBar(
                title: Text('Mon panier', style: TextStyle(fontSize: 16, color: _settings.themeLight ? Colors.black : Colors.white)),
                back: widget.back,
                uId: widget.uId,
              ),
        drawer: MyDrawer(

        ),
        body: widget.uId == ""
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Expanded(child: Container(),),
                  SvgPicture.asset(
                    'assets/images/decor.svg',
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Connectez-vous pour voir votre panier',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Expanded(child: Container(),),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.6,
                    height: 48,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Text(
                      'Connectez-vous',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ))
            : Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: inCart.length > 0
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: ShippingInfos(
                                                uId: widget.uId,
                                                onclick: () {
                                                  setState(() {
                                                    print(
                                                        "Shipping info updated");
                                                  });
                                                },
                                              ),
                                            ),
                                            ...inCart.map((e) {
                                              return ProductCard(
                                                  order: e,
                                                  onclick: _calcTotal);
                                            }),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8),
                                                        child: Text(
                                                          'Sous total: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${_mealAndExtrasTotal.toStringAsFixed(2)} €',
                                                        style: TextStyle(
                                                          //    fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8),
                                                        child: Text(
                                                            'Remise: '), //discount
                                                      ),
                                                      Text(
                                                        '${discount.toStringAsFixed(2)} €',
                                                        style: TextStyle(
                                                          // fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  loading
                                                      ? Text('En traitement...')
                                                      // ? Text('processing')
                                                      : myCart.shippingAddress ==
                                                              ""
                                                          ? Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 25),
                                                              child: Center(
                                                                  child: Text(
                                                                // 'Missing shipping address - Add '
                                                                // 'shipping address to calculate '
                                                                // 'total amount',
                                                                'Veuillez saisir votre adresse de livraison svp',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                            )
                                                          : FutureBuilder<
                                                                  double>(
                                                              future: FirebaseOpOrders().calculateDeliveryFee(
                                                                  context,
                                                                  widget.uId,
                                                                  widget.resId ==
                                                                          ""
                                                                      ? inCart[
                                                                              0]
                                                                          .resId
                                                                      : widget
                                                                          .resId),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return Center(
                                                                      child:
                                                                          Column(
                                                                    children: [
                                                                      CircularProgressIndicator
                                                                          .adaptive(
                                                                        semanticsValue:
                                                                            'log',
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          'Calcul du total...'), //calculating total
                                                                    ],
                                                                  ));
                                                                }
                                                                if (snapshot
                                                                    .hasData) {
                                                                  deliveryFee =
                                                                      snapshot
                                                                          .data!;

                                                                  // print(
                                                                  //     "CART SETTINGS VAL ${_settings.num}");
                                                                  return Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                              'Frais de livraison : '),
                                                                          Text(
                                                                            snapshot.hasData
                                                                                ? '+ ${deliveryFee.toStringAsFixed(2)} €'
                                                                                : '-',
                                                                            style:
                                                                                TextStyle(
                                                                              // fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      ApplyCoupon(
                                                                        resId:
                                                                            resId,
                                                                        onCouponApplied: (double
                                                                                val,
                                                                            String
                                                                                couponCode) {
                                                                          if (val ==
                                                                              0.0)
                                                                            setState(() {
                                                                              invalidCoupon = true;
                                                                            });
                                                                          else {
                                                                            setState(() {
                                                                              invalidCoupon = false;
                                                                              couponVal = val;
                                                                              _couponCode = couponCode;
                                                                            });
                                                                          }
                                                                        },
                                                                      ),
                                                                      invalidCoupon
                                                                          ? Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                'Coupon invalide',
                                                                                style: TextStyle(color: Colors.red.shade700),
                                                                              ),
                                                                            )
                                                                          : couponVal > 0.0
                                                                              ? Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    'Coupon appliqué ${((deliveryFee + _mealAndExtrasTotal)).toStringAsFixed(2)} - $couponVal% ',
                                                                                    style: TextStyle(color: Colors.green.shade700),
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              0,
                                                                          vertical:
                                                                              10,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'Total TTC: ',
                                                                                    style: TextStyle(
                                                                                      fontSize: 17,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: _settings.themeLight ? Colors.black : Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    //'${(((deliveryFee + _stotal) - discount) - (((deliveryFee + _stotal) - discount) * couponVal/100)).toStringAsFixed(2)}€',
                                                                                    couponVal > 0.0 ? '${totalAmount(deliveryFee).toStringAsFixed(2)}€' : '${((deliveryFee + _mealAndExtrasTotal)).toStringAsFixed(2)}',
                                                                                    style: TextStyle(
                                                                                      fontSize: 17,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: _settings.themeLight ? Colors.black : Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            MaterialButton(
                                                                              color: Theme.of(context).primaryColor,
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                              onPressed: () async {
                                                                                {
                                                                                  if (_mealAndExtrasTotal > 1) {
                                                                                    setState(() {
                                                                                      loading = true;
                                                                                    });

                                                                                    var createdOrderId = await createOrder(totalAmount(deliveryFee).toStringAsFixed(2));
                                                                                    if (createdOrderId != false) {
                                                                                      print("%%%%%%% Order id $createdOrderId");
                                                                                      _initPaymentSheet(totalAmount(deliveryFee).toStringAsFixed(2), createdOrderId);
                                                                                    }
                                                                                  } else {
                                                                                    _error(context, "Le montant du sous-total doit être supérieur à 1 euro");
                                                                                    // "Order amount should be greater than 30");
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: Text(
                                                                                'Paiement',
                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                25,
                                                                            vertical:
                                                                                8),
                                                                        child:
                                                                            RichText(
                                                                          text: TextSpan(
                                                                              text: 'La somme de '
                                                                                  '${(((deliveryFee + _mealAndExtrasTotal)) * donationPercent / 100).toStringAsFixed(2)}€ '
                                                                                  'va être versée par ',
                                                                              style: TextStyle(color: _settings.themeLight ? Colors.black : Colors.white),
                                                                              children: [
                                                                                TextSpan(text: 'Clic&Eats', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                                                                TextSpan(text: ' à des associations caritatives')
                                                                              ]),
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            border: Border.all(width: 4, color: Theme.of(context).primaryColor)),
                                                                      )
                                                                    ],
                                                                  );
                                                                } else
                                                                  return Center(
                                                                      child:
                                                                          Column(
                                                                    children: [
                                                                      CircularProgressIndicator
                                                                          .adaptive(
                                                                        semanticsValue:
                                                                            'log',
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          'Calcul du total...'), // calculating total
                                                                    ],
                                                                  ));
                                                              }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                      'Votre panier est vide'), //Your cart is empty
                                ),
                        ),
                      ),
                    ],
                  ),
                  loading
                      ? Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          color: Colors.black26,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      : Container()
                ],
              ));
  }

  double totalAmount(dFee) {
    return (((dFee + _mealAndExtrasTotal)) -
        (((dFee + _mealAndExtrasTotal)) * couponVal / 100));
    // return ((dFee + _mealAndExtrasTotal) - discount);
  }

  @override
  void dispose() {
    log("*** CART DISPOSED***");
    super.dispose();
  }

  Future<void> _initPaymentSheet(String totalAmount, orderId) async {
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
      _displayPaymentSheet(orderId);
      //  });
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> _displayPaymentSheet(orderId) async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
        clientSecret: _paymentSheetData!['paymentIntent'],
        confirmPayment: true,
      ));

      setState(() {
        _paymentSheetData = null;
      });
      await FirebaseOpOrders()
          .updateOrderStatus(
              orderId: orderId,
              resId: widget.resId == "" ? inCart[0].resId : widget.resId,
              cusId: widget.uId)
          .then((value) async {
        //update donation amount
        await FirebaseAssociationOp().updateMyDonationAmount(
            double.parse(
                (((deliveryFee + _mealAndExtrasTotal)) * donationPercent / 100)
                    .toStringAsFixed(2)),
            widget.uId);

        //go to payment success page and remove this screen
        String orderNo = orderId.substring(1, 6);
        // log("TOPIC NAME: $orderNo");
        // FirebaseMessaging.instance.subscribeToTopic(orderNo).then((value) {
        //   log('Subscribed to orderNo: $orderNo');

        //   FirebaseNotificationsOp().addNotificationForRestaurant(
        //       'A new order'
        //       ' placed - #$orderNo',
        //       widget.resId == "" ? inCart[0].resId : widget.resId);
        // });
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => PaymentSuccess(orderNo)),
          ModalRoute.withName(
            '/',
          ),
        );

        myCart.resId = null;
        // myCart.items!.clear();
        inCart.clear();
        inCart = [];
        loading = false;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        setState(() {});
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Paiement effectué avec succès'),
          // content: Text('Payment successfully completed'),
        ),
      );
    } on StripeException catch (e) {
      setState(() {
        loading = false;
      });
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

  _error(context, msg) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var _settings = Provider.of<AppStateManager>(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/paymentfailed.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Paiement échoué',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _settings.themeLight ? Colors.black : Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Impossible de passer la commande, une erreur survenu lors de votre paiement.',
                  style: TextStyle(
                    fontSize: 13,
                    // fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Reason',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _settings.themeLight ? Colors.black : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  msg ??
                      "Inconnu. Veuillez contacter l'assistance ou réessayer plus tard",
                  // msg ?? "Unknown. Please contact support or try again later",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Réessayez",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future createOrder(total) async {
    List<Map<String, dynamic>> mealsList = [];
    mealsList.clear();
    if (_mealAndExtrasTotal > 1) {
      setState(() {
        loading = true;
      });
      Order tempOrder = Order(
          couponCode: _couponCode,
          couponDiscount: couponVal == 0.0 ? 0.0 : total - total / couponVal,
          associationAmount: double.parse(
              (((deliveryFee + _mealAndExtrasTotal)) * donationPercent / 100)
                  .toStringAsFixed(2)),
          extrasAmount: extrasTotal,
          mealsAmount: double.parse(mealsTotal.toStringAsFixed(2)),
          discountAmount: double.parse(discount.toStringAsFixed(2)),
          status: 0,
          customerId: widget.uId,
          selectedCarrier: null,
          selectedCarrierName: null,
          orderedMealsList: mealsList,
          tip: 0.0,
          ignoredByCarriers: [],
          orderTime: DateTime.now(),
          deliveryFee: double.parse(deliveryFee.toStringAsFixed(2)),
          resName: resName,
          resId: resId,
          //resId: widget.resId == "" ? inCart[0].resId : widget.resId,
          deliveryAddress: myCart.shippingAddress,
          total: double.parse(total),
          rated: false,
          orderRating: {'stars': 0, 'comment': ""});
      inCart.forEach((element) {
        mealsList.add(
          OrderedMeal(element.qtt, '${element.platId}',
                  mealPrice: element.calculatedDishOnlyPrice,
                  extrasAmount: element.extrasAmount,
                  extrasList: element.selectedExtrasList)
              .toMap(),
        );
      });
      var result =
          await FirebaseOpOrders().addOrder(tempOrder, context, widget.uId);
      print("RESULT = $result");
      if (result != false)
        return result;
      else {
        setState(() {
          loading = false;
        });
        final snackBar = SnackBar(backgroundColor: Colors.black87, content: Text(
            //An error occurred in placing order. Please try again later!
            'Une erreur s\'est produite lors de la commande. Veuillez réessayer plus tard!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    } else {
      setState(() {
        loading = false;
      });
      print("ORDER AMOUNT SHOULD BE GREATER THAN 1 Euro");
      final snackBar = SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
              '⚠️ Le montant de la commande doit être supérieur à 1 euro'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }
}
