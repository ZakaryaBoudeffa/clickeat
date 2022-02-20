import 'dart:convert';
import 'dart:developer';

import 'package:clicandeats/firebaseFirestore/ordersOp.dart';
import 'package:clicandeats/models/cardDetails.dart' as cardDetails;
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/pages/paymentSuccessPage.dart';
import 'package:clicandeats/services/httpService.dart';
import 'package:clicandeats/services/resToObject.dart';
import 'package:clicandeats/utils/appBar.dart';
import 'package:clicandeats/widgets/drawer/billingInfos.dart';
import 'package:clicandeats/widgets/drawer/shippinginfos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

// class CheckoutPage extends StatefulWidget {
//   final double total;
//   CheckoutPage({required this.total});
//
//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }
//
// class _CheckoutPageState extends State<CheckoutPage> {
//   bool editBillingInfo = false;
//   CardFieldInputDetails? card;
//   final editController = CardEditController();
//   bool loading = false;
//   String _cusId = "";
//   late cardDetails.BillingDetails _billingDetails;
//   String _selectedCardId = "";
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     print("Checkout page disposed");
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Stripe.publishableKey =
//         "pk_test_51JLTYJDoc9ztdhid3M7JX2QnBsGsr5HNvVqu52Z0gbWMCOWrPi3Or693cdJtCgzj3xIhrqIrgkTFZaOkElfJs6Vj00CTEQxutB";
//     // print("BILLING DETAILS: ${_billingDetails == null}");
//     return Scaffold(
//       appBar: MyAppBar(
//         title: Text('Checkout'),
//         back: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: BillingInfos(
//                         onCardChanged: (String pmId, String cusId,
//                             cardDetails.BillingDetails bd) {
//                           if (_selectedCardId != "") {
//                             setState(() {
//                               _selectedCardId = "";
//                             });
//                           }
//                           setState(() {
//                             _selectedCardId = pmId;
//                             _cusId = cusId;
//                             _billingDetails = cardDetails.BillingDetails(
//                                 name: bd.name,
//                                 address: bd.address,
//                                 phone: bd.phone,
//                                 email: bd.email);
//
//                             print(
//                                 'BILLING DETAILS ${_billingDetails.email} ${_billingDetails.name} ${_billingDetails.address} ${_billingDetails.phone}');
//                           });
//                         },
//                       ),
//
//                       // Container(
//                       //   width: double.infinity,
//                       //   padding: EdgeInsets.all(10),
//                       //   decoration: BoxDecoration(
//                       //     boxShadow: [
//                       //       BoxShadow(
//                       //         blurRadius: 10,
//                       //         color: Colors.grey[100]!,
//                       //       ),
//                       //     ],
//                       //     borderRadius: BorderRadius.circular(10),
//                       //     color: Colors.white,
//                       //   ),
//                       //   child: Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.start,
//                       //     children: [
//                       //
//                       //       Padding(
//                       //         padding: const EdgeInsets.all(0.0),
//                       //         child: Row(
//                       //           mainAxisAlignment:
//                       //               MainAxisAlignment.spaceBetween,
//                       //           children: [
//                       //             Expanded(
//                       //               child: Text(
//                       //                 'Informations de paiement',
//                       //                 style: TextStyle(
//                       //                   //  fontSize: 13,
//                       //                   fontWeight: FontWeight.bold,
//                       //                   color: Colors.black,
//                       //                 ),
//                       //               ),
//                       //             ),
//                       //             // MaterialButton(
//                       //             //   onPressed: () async {
//                       //             //  await snapshot.data!.paymentMethods.data.length > 0
//                       //             //         ? Navigator.push(
//                       //             //             context,
//                       //             //             MaterialPageRoute(
//                       //             //                 builder: (context) => ManageBillingInfo(
//                       //             //                       isEdit: true,
//                       //             //                     )))
//                       //             //         : Navigator.push(
//                       //             //             context,
//                       //             //             MaterialPageRoute(
//                       //             //                 builder: (context) => ManageBillingInfo(
//                       //             //                       isEdit: false,
//                       //             //                     )));
//                       //             //
//                       //             //
//                       //             //   },
//                       //             //   shape: RoundedRectangleBorder(
//                       //             //       borderRadius: BorderRadius.circular(7),
//                       //             //       side: BorderSide(
//                       //             //           color: Theme.of(context).primaryColor)),
//                       //             //   child: Text(
//                       //             //     snapshot.data!.paymentMethods.data.length > 0 || card != null
//                       //             //         ? 'Changer'
//                       //             //         : "Ajouter ",
//                       //             //     style: TextStyle(fontSize: 12, color: Colors.black87
//                       //             //         //fontWeight: FontWeight.w900,
//                       //             //         ),
//                       //             //   ),
//                       //             // ),
//                       //           ],
//                       //         ),
//                       //       ),
//                       //       SizedBox(
//                       //         height: 10,
//                       //       ),
//                       //
//                       //       // CardField(
//                       //       //   decoration: InputDecoration(
//                       //       //       contentPadding: EdgeInsets.zero),
//                       //       //   controller: editController,
//                       //       //   numberHintText: "4242 4242 4242 4242",
//                       //       //   onCardChanged: (c) {
//                       //       //     setState(() {
//                       //       //       //_editController.value =card;
//                       //       //       card = c;
//                       //       //       print("EDITCOntroller: ${card}");
//                       //       //     });
//                       //       //   },
//                       //       // ),
//                       //     ],
//                       //   ),
//                       // ),
//                     ),
//                   ),
//                   _selectedCardId == ""
//                       ? Text('Select/Add a payment method',
//                           style: TextStyle(color: Colors.red, fontSize: 12))
//                       : Text(
//                           'NOTE: Selected card will be charged\n$_selectedCardId',
//                           style: TextStyle(
//                               fontSize: 12, color: Colors.blue.shade700),
//                         ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Container(
//                       width: double.infinity,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Total:',
//                             style: TextStyle(
//                               // fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Text(
//                             "${widget.total.toStringAsFixed(2)}€",
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             loading
//                 ? CircularProgressIndicator()
//                 : Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: MaterialButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         height: 45,
//                         color: _selectedCardId != ""
//                             ? Theme.of(context).primaryColor
//                             : Colors.grey,
//                         onPressed: () async {
//                           if (_selectedCardId != "" && _cusId != "") {
//                             print(
//                                 "selected cardID: $_selectedCardId  & cusId: $_cusId");
//                             if (widget.total > 30) {
//                               setState(() {
//                                 loading = true;
//                               });
//                               //makePaymanet();
//                               var createOrderRes = await createOrder();
//                               if (createOrderRes != false) {
//                                 print("%%%%%%% Order id $createOrderRes");
//                                 String paymentResult = await HttpService()
//                                     .createPaymentIntent(
//                                         _cusId,
//                                         _selectedCardId,
//                                         double.parse(
//                                             widget.total.toStringAsFixed(2)),
//                                         _billingDetails);
//                                 print("Payment res checkout: $paymentResult");
//                                 if (paymentResult ==
//                                         'PaymentIntentsStatus.Succeeded' ||
//                                     paymentResult == 'success') {
//                                   /// TODO Update order paid status in FIRE-STORE against the order ID
//                                   await FirebaseOpOrders().updateOrderStatus(
//                                       orderId: createOrderRes,
//                                       resId: myCart.resId,
//                                       cusId: currentUserID).then((value) {
//                                     //go to payment success page and remove this screen
//                                     Navigator.pushAndRemoveUntil<void>(
//                                       context,
//                                       MaterialPageRoute<void>(
//                                           builder: (BuildContext context) =>
//                                               PaymentSuccess('000')),
//                                       ModalRoute.withName('/'),
//                                     );
//                                     setState(() {
//                                       card = null;
//                                       myCart.resId = null;
//                                       myCart.items!.clear();
//                                       inCart.clear();
//                                       _selectedCardId = "";
//                                       _cusId = "";
//                                       loading = false;
//                                     });
//                                   });
//
//                                   /// /////////////////////////////////////////
//
//                                 } else {
//                                   // if (paymentResult != false || paymentResult != null) {
//                                   //   _error(context, paymentResult);
//                                   //   setState(() {
//                                   //     loading = false;
//                                   //   });
//                                   // }
//
//                                   //else
//                                   _error(context, paymentResult);
//                                   setState(() {
//                                     loading = false;
//                                   });
//                                 }
//                               }
//                             } else {
//                               _error(context,
//                                   "Order amount should be greater than 30");
//                             }
//                           }
//                         },
//                         child: Text(
//                           'Confirm and Pay',
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _error(context, msg) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(30.0))),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Center(
//                   child: Image.asset(
//                     'assets/images/paymentfailed.png',
//                     width: MediaQuery.of(context).size.width * 0.3,
//                     height: MediaQuery.of(context).size.height / 4,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   'Paiement échoué',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'Impossible de passer la commande, une erreur survenu lors de votre paiement.',
//                   style: TextStyle(
//                     fontSize: 13,
//                     // fontWeight: FontWeight.bold,
//                     color: Theme.of(context).accentColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   'Reason',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 Text(
//                   msg ?? "Unknown. Please contact support or try again later",
//                   style: TextStyle(
//                     //fontSize: 13,
//                     // fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Center(
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: Container(
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         child: Text(
//                           "Réessayez",
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   _success(context) {
//     return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: Image.asset(
//                   'assets/images/icons/done.png',
//                   width: 100,
//                   height: 100,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Paiement réussi',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 //dear customer your order is placed. Visit orders page to check your order status
//                 'Cher client, votre commande est passée.'
//                 '\n\nVeuillez visiter la page des commandes pour vérifier l\'état de votre commande',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 15,
//                   //fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.popUntil(context, ModalRoute.withName('/'));
//                 },
//                 child: Text(
//                   //back to home page
//                   'Retour à la page d\'accueil',
//                   style: TextStyle(),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   padding: EdgeInsets.symmetric(horizontal: 15),
//                   primary: Theme.of(context).primaryColor,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7)),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future createOrder() async {
//     List<Map<String, dynamic>> mealsList = [];
//     mealsList.clear();
//     if (widget.total > 30) {
//       setState(() {
//         loading = true;
//       });
//       Order tempOrder = Order(
//         status: 0,
//         customerId: currentUserID,
//         selectedCarrier: null,
//         orderedMealsList: mealsList,
//         ignoredByCarriers: [],
//         orderTime: DateTime.now(),
//         deliveryFee: 20,
//         resId: myCart.resId,
//         deliveryAddress: myCart.shippingAddress!,
//         total: widget.total,
//       );
//
//       inCart.forEach((element) {
//         mealsList.add(OrderedMeal(element.qtt, '${element.platId}').toMap());
//       });
//       var result = await FirebaseOpOrders().addOrder(tempOrder, context);
//       print("RESULT = $result");
//       if (result != false)
//         return result;
//       else {
//         setState(() {
//           loading = false;
//         });
//         final snackBar = SnackBar(
//             backgroundColor: Colors.black87,
//             content: Text(
//                 'An error occurred in placing order. Please try again later!'));
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         return false;
//       }
//     } else {
//       setState(() {
//         loading = false;
//       });
//       print("ORDER AMOUNT SHOULD BE GREATER THAN 30");
//       final snackBar = SnackBar(
//           backgroundColor: Colors.black87,
//           content: Text('⚠️ ORDER AMOUNT SHOULD BE GREATER THAN 30'));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       return false;
//     }
//   }
//
//
//
// }
