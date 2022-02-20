import 'package:clicandeats/models/Settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentSuccess extends StatefulWidget {
  final String orderId;
  //final String uid;
  PaymentSuccess(this.orderId);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    print("current tab = ${_settings.currentTab}");
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           // mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/icons/done.png',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Paiement réussi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text('Commande# ${widget.orderId}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              Text(
                //dear customer youe order is placed. Cisit orders page to check your order status
                'Cher client, votre commande est passée.'
                    '\n\nVeuillez visiter la page des commandes pour vérifier l\'état de votre commande',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //fontSize: 15,
                  //fontWeight: FontWeight.bold,
                  //color: Colors.black,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  _settings.changeTab(2);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  // int count = 0;
                  // //Navigator.of(context).pop(context);
                  // Navigator.of(context, rootNavigator: true).pop(context);
                  // // Navigator.pop(context);
                  // // Navigator.popUntil(context, (route) {
                  // //   return count++ == 1;
                  // // });
                },
                child: Text(
                  //back to home page
                  'Retour à la page d\'accueil',
                  style: TextStyle(
                    color: Colors.white
                    //fontSize: 15,
                    // fontWeight: FontWeight.w900,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}