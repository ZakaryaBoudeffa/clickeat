import 'dart:developer';

import 'package:clicandeats/firebaseFirestore/profileOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/cardDetails.dart' as cardDetails;
import 'package:clicandeats/services/resToObject.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

class ManageBillingInfo extends StatefulWidget {
  final String uId;
  ManageBillingInfo({required this.uId});
  @override
  _ManageBillingInfoState createState() => _ManageBillingInfoState();
}

class _ManageBillingInfoState extends State<ManageBillingInfo> {
  CardFieldInputDetails? _card;
  String cusId = "";

  final _editController = CardEditController();

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

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    ///live key
    Stripe.publishableKey =
    "pk_live_51JLTYJDoc9ztdhid6JsyBDRjZaZQqTI5BYbsf4CwLWsadERfPwyBLKXfyWM6mkyU0Xr0JRow7ghfrEIRtAQMSo9A00IEvulum6";

    // Stripe.publishableKey =
//         "pk_test_51JLTYJDoc9ztdhid3M7JX2QnBsGsr5HNvVqu52Z0gbWMCOWrPi3Or693cdJtCgzj3xIhrqIrgkTFZaOkElfJs6Vj00CTEQxutB";

    log(cusId);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: _settings.themeLight? Colors.black:Colors.white, fontSize: 16),
        title: Text('Mes moyens de paiement'),
     //   title: Text('My Payment methods'),
        actions: [

          SizedBox(width: 10,),
        ],
        //back: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Text('My cards'),
            Expanded(
              child: FutureBuilder<cardDetails.CardDetails>(
                  future: getMyPaymentMethods(context, cusId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data!.paymentMethods.data.length > 0){
                        return Column(
                          children: snapshot.data!.paymentMethods.data
                              .map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(

                                leading: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 40,
                                  child: e.card
                                      .brand ==
                                      'visa'
                                      ? SvgPicture.asset('assets/images/icons/visa.svg',
                                      //color: Colors.red,
                                      semanticsLabel: 'A red up arrow')
                                      : e.card
                                      .brand ==
                                      'mastercard'
                                      ? SvgPicture.asset(
                                      'assets/images/icons/masterCard.svg',
                                      //color: Colors.red,
                                      semanticsLabel: 'A red up arrow')
                                      : Icon(CupertinoIcons.creditcard),
                                ),
                                tileColor: Theme.of(context).primaryColor.withOpacity(0.7),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                    '**** **** **** ${e.card.last4}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('expiry: ${e.card.expMonth.toString()}/${e.card.expYear.toString()}'),
                                  //  Text(e.id)
                                  ],
                                ),
                              ),
                              Divider(height: 10,)
                            ],
                          ))
                              .toList(),
                        );
                      }
                      else return Center(child: Text('Ajouter un moyen de paiement')); //Add a payment method
                    } else
                      return Center(child: Text('$loadingText...'));
                  }),
            ),
          ],
        ),
      ),

    );
  }
}
