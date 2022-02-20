import 'dart:developer';

import 'package:clicandeats/firebaseFirestore/profileOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/cardDetails.dart' as cardDetails;
import 'package:clicandeats/pages/checkoutPage.dart';
import 'package:clicandeats/services/resToObject.dart';
import 'package:clicandeats/pages/manageBillingInfo.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

class BillingInfos extends StatefulWidget {
  String uId;
  //final Function(String, String, cardDetails.BillingDetails) onCardChanged;
  BillingInfos({required this.uId});
  @override
  _BillingInfosState createState() => _BillingInfosState();
}

class _BillingInfosState extends State<BillingInfos> {
  String cusId = "";
  int selectedIndex = -1;
  String selectedCardId = "";
  @override
  void initState() {
    Future n = getInfo();
    log('cusId: $cusId');
    super.initState();
  }



  Future getInfo() async {
    await FirebaseProfileOp().getMyInfo(widget.uId).then((value) {
      print(value.get('cusId'));
      setState(() {
        cusId = value.get('cusId');
      });
    });
  }

  // final _editController = CardEditController();
  // CardFieldInputDetails? card;
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 10,
        //     color: Colors.grey[100]!,
        //   ),
        // ],
        borderRadius: BorderRadius.circular(6),
        color: _settings.themeLight ? Colors.white : darkAccentColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Informations de paiement',
                    style: TextStyle(
                      //  fontSize: 13,
                      fontWeight: FontWeight.bold,
                     // color: Colors.black,
                    ),
                  ),
                ),
                // cusId == ""
                //     ? MaterialButton(
                //         onPressed: () async {
                //           await Navigator.pushNamed(context, '/addBilling');
                //           setState(() {
                //             print("BACK ON MANAGE BILLING SCREEN ");
                //           });
                //         },
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(7),
                //             side: BorderSide(
                //                 color: Theme.of(context).primaryColor)),
                //         child: Text(
                //           'Ajouter',
                //           style: TextStyle(fontSize: 12, color: Colors.black87
                //               //fontWeight: FontWeight.w900,
                //               ),
                //         ),
                //       )
                //     :
                // MaterialButton(
                //         onPressed: () async {
                //           Navigator.pushNamed(context, '/editBilling');
                //         },
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(7),
                //             side: BorderSide(
                //                 color: Theme.of(context).primaryColor)),
                //         child: Text(
                //           'Gérer',
                //           style: TextStyle(fontSize: 12, color: Colors.black87
                //               //fontWeight: FontWeight.w900,
                //               ),
                //         ),
                //       ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 90,
            // color: Colors.blue,
            child: FutureBuilder<cardDetails.CardDetails>(
                future: getMyPaymentMethods(context, cusId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.paymentMethods.data.length > 0) {
                      return ListTile(
                        leading: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 40,
                          child: snapshot.data!.paymentMethods.data[0].card
                                      .brand ==
                                  'visa'
                              ? SvgPicture.asset('assets/images/icons/visa.svg',
                                  //color: Colors.red,
                                  semanticsLabel: 'A red up arrow')
                              : snapshot.data!.paymentMethods.data[0].card
                                          .brand ==
                                      'mastercard'
                                  ? SvgPicture.asset(
                                      'assets/images/icons/masterCard.svg',
                                      //color: Colors.red,
                                      semanticsLabel: 'A red up arrow')
                                  : Icon(CupertinoIcons.creditcard),
                        ),
                        //  :  Icon(CupertinoIcons.creditcard),

                        title: Text(
                          '${snapshot.data!.paymentMethods.data[0].type}',
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                            '**** **** **** ${snapshot.data!.paymentMethods.data[0].card.last4}',
                        style: TextStyle(color:  _settings.themeLight ? Colors.black : Colors.white),),

                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ManageBillingInfo(uId: widget.uId)));
                        },
                        //  tileColor: Colors.pink,
                      );
                    } else {
                      return Center(child: Text('Pas de moyen de paiement'));
                    }
                  } else
                    return Center(child: Text('$loadingText...'));
                }),
          ),
        ],
      ),
    );
  }
}
