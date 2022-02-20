import 'dart:convert';

import 'package:clicandeats/models/cardDetails.dart' as cardDetails;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HttpService {
  var apiUrl = 'https://us-central1-cliceats-1c53d.cloudfunctions.net';

  Future<String> createPaymentIntent(cusId, pmId, double total,
      cardDetails.BillingDetails billingDetails) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request =
        http.Request('POST', Uri.parse('$apiUrl/createPaymentIntent'));

    print('TOTAL: ${total.toStringAsFixed(2)}');
    request.bodyFields = {
      'currency': 'eur',
      'paymentMethodType': 'card',
      'cusId': '$cusId',
      'pmId': '$pmId',
      'total': total.toStringAsFixed(1)
    };
    PaymentIntentsStatus r;
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    Map<String, dynamic>? paymentIntentClientSecret;
    paymentIntentClientSecret =
        jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200 &&
        !paymentIntentClientSecret!.containsKey('error')) {
      // print(paymentIntentClientSecret);
      print('Payment result: ${paymentIntentClientSecret['result']}');

      if (paymentIntentClientSecret['result'] == true) {
        return 'success';
      } else if (paymentIntentClientSecret['result'] == false &&
          paymentIntentClientSecret.containsKey('requires_action')) {
      //  print("%%%%%%%% Here");
        try {
          r = await Stripe.instance
              .handleCardAction(paymentIntentClientSecret['pi_cs'])
              .then((value) {
          //  print("card handled ${value.status}");
            //if (value.status == PaymentIntentsStatus.Succeeded)
            return value.status;
            // else
            //   return "Authentication failed";
          });
        } catch (e) {
          return "The provided PaymentMethod has failed authentication";
        }
      } else {
        return 'Error in payment intent';
      }
    } else {
      print(paymentIntentClientSecret.toString());
      return "Status code ${response.statusCode} - ${paymentIntentClientSecret.toString()}";
    }
    return r.toString();
  }


  Future paymentSheet(cusId, totalAmount) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse('https://us-central1-cliceats-1c53d.cloudfunctions.net/paymentSheet'));
    request.bodyFields = {
      'cusId': cusId,
      'total': totalAmount
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      return  json.decode(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    return {'error': response.reasonPhrase};
    }

  }

  Future setupIntentForPaymentSheet(cusId) async {
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://us-central1-cliceats-1c53d.cloudfunctions.net/setupIntent'));
      request.bodyFields = {'cusId': cusId};
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map<String, dynamic> _clientSecret =jsonDecode( await response.stream.bytesToString());
        print("CLIENT_SECRET ${_clientSecret['client_secret']}");
        return _clientSecret['client_secret'];
        // dynamic res = await confirmSetupIntent(card, _clientSecret['client_secret']);
        // if(res == true)
        //   return true;
        // else return false;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (e) {
      print("EXCEPTION IN CONFIRMATION OF SETUP INTENT: $e");
      return false;
    }
  }


  Future<bool> setupIntent(CardFieldInputDetails card, cusId) async {
    try {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://us-central1-cliceats-1c53d.cloudfunctions.net/setupIntent'));
      request.bodyFields = {'cusId': 'cus_K5mHuxcpqphykC'};
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Map<String, dynamic> _clientSecret =jsonDecode( await response.stream.bytesToString());
        print("CLIENT_SECRET ${_clientSecret['client_secret']}");
        dynamic res = await confirmSetupIntent(card, _clientSecret['client_secret']);
        if(res == true)
          return true;
        else return false;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (e) {
      print("EXCEPTION IN CONFIRMATION OF SETUP INTENT: $e");
      return false;
    }
  }

  Future<bool> confirmSetupIntent(CardFieldInputDetails card, clientSecret) async {
    print("CONFIRM SETUP INTENT CS: $clientSecret");
    try {
      await Stripe.instance
          .confirmSetupIntent(
              clientSecret,
              PaymentMethodParams.card(
                  setupFutureUsage: PaymentIntentsFutureUsage.OnSession,
                  billingDetails: BillingDetails(
                      email: 'lybakashif@gmail.com', name: 'Lyba Lyba')))
          .then((value) => print("SETUP INTENT Confirmed"));
      return true;
    } catch (e) {
      print("EXCEPTION IN CONFIRMATION OF SETUP INTENT: $e");
      return false;
    }
  }

  Future<http.StreamedResponse> getMyPaymentMethods(context, cusId) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://us-central1-cliceats-1c53d.cloudfunctions.net/myPaymentMethods'));
    request.bodyFields = {'cusId': cusId};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      return response;
      // return
    } else {
      print(response.reasonPhrase);
      return response;
    }
  }
}
