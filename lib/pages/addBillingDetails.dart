import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/services/httpService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AddBillingDetails extends StatefulWidget {
  final String cusId;
  AddBillingDetails({required this.cusId});
  @override
  _AddBillingDetailsState createState() => _AddBillingDetailsState();
}

class _AddBillingDetailsState extends State<AddBillingDetails> {

  Map<String, dynamic>? _paymentSheetData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _paymentSheetData != null ? null : _initPaymentSheet,
                child: const Text('Init payment sheet'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _paymentSheetData != null ? _displayPaymentSheet : null,
                child: const Text('Show payment sheet'),
              ),
            ],
          )),
    );
  }


  Future<void> _initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      _paymentSheetData = await HttpService().paymentSheet(cusId, '1000');

      if (_paymentSheetData!['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error code: ${_paymentSheetData!['error']}')));
        return;
      }

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: false,
          googlePay: false,
          //style: ThemeMode.dark,
          testEnv: false,
          merchantCountryCode: 'DE',
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: _paymentSheetData!['customer'],
          paymentIntentClientSecret: _paymentSheetData!['paymentIntent'],
          customerEphemeralKeySecret: _paymentSheetData!['ephemeralKey'],
        ),
      );
      setState(() {
        _displayPaymentSheet();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> _displayPaymentSheet() async {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment succesfully completed'),
        ),
      );
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.error.localizedMessage}'),
        ),
      );
    }
  }
  // CardFieldInputDetails? _card;
  //
  // final _editController = CardEditController();
  //
  // bool loading = false;
  // @override
  // Widget build(BuildContext context) {
  //   Stripe.publishableKey =
  //       "pk_test_51JLTYJDoc9ztdhid3M7JX2QnBsGsr5HNvVqu52Z0gbWMCOWrPi3Or693cdJtCgzj3xIhrqIrgkTFZaOkElfJs6Vj00CTEQxutB";
  //
  //   return Scaffold(
  //       appBar: MyAppBar(
  //         title:
  //             Text('Nouvelles informations de facturation'), //New billing info
  //         back: true,
  //       ),
  //       body: Container(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   CardField(
  //                     decoration: InputDecoration(
  //                         contentPadding: EdgeInsets.zero,
  //                         focusedBorder:
  //                             UnderlineInputBorder(borderSide: BorderSide()),
  //                         fillColor: Colors.grey),
  //                     controller: _editController,
  //                     numberHintText: "4242 4242 4242 4242",
  //                     autofocus: true,
  //                     onCardChanged: (c) {
  //                       setState(() {
  //                         //_editController.value =card;
  //                         _card = c;
  //                         // print("EDITCOntroller: ${card}");
  //                       });
  //                     },
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   loading
  //                       ? CircularProgressIndicator()
  //                       : SizedBox(
  //                           width: double.infinity,
  //                           child: MaterialButton(
  //                             height: 45,
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(10)),
  //                             color: Theme.of(context).primaryColor,
  //                             onPressed: () async {
  //                               dynamic res = await HttpService()
  //                                   .setupIntentForPaymentSheet(widget.cusId);
  //                               if (res != false) makePaymanet(res);
  //
  //                               // Put customer id and billing details in
  //                               // if (_card != null) {
  //                               //   setState(() {
  //                               //     loading = true;
  //                               //   });
  //                               //   bool res = await HttpService()
  //                               //       .setupIntent(_card!, widget.cusId);
  //                               //   if (res == true)
  //                               //     Navigator.pop(context);
  //                               //   else {
  //                               //     final snackBar = SnackBar(
  //                               //         backgroundColor: Colors.red.shade700,
  //                               //         content: Text(
  //                               //             'Une erreur s\'est produite. Carte non ajoutée')); //An error occurred. Card not added
  //                               //     ScaffoldMessenger.of(context)
  //                               //         .showSnackBar(snackBar);
  //                               //     setState(() {
  //                               //       loading = false;
  //                               //     });
  //                               //   }
  //                               // } else {
  //                               //   print("CARD CANNOT BE EMPTY");
  //                               //   final snackBar = SnackBar(
  //                               //       backgroundColor: Colors.black87,
  //                               //       content: Text(
  //                               //           'La carte ne peut pas être vide')); //Card cannot be empty
  //                               //   ScaffoldMessenger.of(context)
  //                               //       .showSnackBar(snackBar);
  //                               // }
  //                               // setState(() {
  //                               //   _card = null;
  //                               // });
  //                             },
  //                             child: Text(
  //                               "Ajouter",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.white),
  //                             ),
  //                           ),
  //                         ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }
  //
  // Map<String, dynamic>? paymentIntentData;
  //
  // Future<void> makePaymanet(setupIntentCS) async {
  //   try {
  //     final url = Uri.parse(
  //         'https://us-central1-cliceats-1c53d.cloudfunctions.net/stripePayment');
  //     final response =
  //         await http.get(url, headers: {'Content-Type': 'application/json'});
  //
  //     print('respose: ${response.body}');
  //     paymentIntentData = jsonDecode(response.body);
  //     print('paymentIntentData: ${paymentIntentData}');
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //             style: ThemeMode.light,
  //            // customFlow: true,
  //             customerId: widget.cusId,
  //             //setupIntentClientSecret: setupIntentCS,
  //             // setupIntentClientSecret: 'seti_1JRgQlDoc9ztdhidmb2C7fJ2_secret_K5sBcBvWvU3l3kDJQXbcsT7MD9PMIRj',
  //              paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
  //             applePay: false,
  //             merchantDisplayName: 'ClicEats',
  //             merchantCountryCode: 'US',
  //             googlePay: false));
  //     // setState(() {
  //     //
  //     // });
  //     displayPaymentSheet(paymentIntentData!['paymentIntent']);
  //    // displayPaymentSheet(setupIntentCS);
  //   } catch (e) {
  //     print("Error in makePayment $e");
  //   }
  // }
  //
  // Future<void> displayPaymentSheet(setupIntentCS) async {
  //   try {
  //     print("hi");
  //     await Stripe.instance
  //         .presentPaymentSheet(
  //             parameters: PresentPaymentSheetParameters(
  //                 clientSecret: setupIntentCS,
  //                 // clientSecret: 'seti_1JRgQlDoc9ztdhidmb2C7fJ2_secret_K5sBcBvWvU3l3kDJQXbcsT7MD9PMIRj',
  //                 confirmPayment: true))
  //         .then((value) => log("SUCCESS PAYEMT"))
  //         .onError((error, stackTrace) => 'pi error $error')
  //         .catchError((err) => print("kkk $err"));
  //     print("ok");
  //     // _success(context);
  //     // setState(() {
  //     //   //paymentIntentData = null;
  //     // });
  //   } catch (e) {
  //     log("error in displayPaymentSHeet $e");
  //     print("error in displayPaymentSHeet $e");
  //   }
  // }
}
