

import 'dart:convert';

import 'package:clicandeats/models/cardDetails.dart';
import 'package:clicandeats/services/httpService.dart';

Future<CardDetails>? getMyPaymentMethods(context, cusId) async {
  var response = await HttpService().getMyPaymentMethods(context, cusId);
  print("RESPONSE: ${response}");
  var jsons = jsonDecode(await response.stream.bytesToString());

  return CardDetails.fromJson(jsons);
}