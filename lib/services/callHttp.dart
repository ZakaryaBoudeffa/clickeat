import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class chttp {

  static Future<http.Response> call(
      {context,
        method,
         Map<String, String>? queryParameters,
        url,
        required Map<String, String> headers,
        body,
        Encoding? encoding}) async {
   // final overlay = LoadingOverlay.of(context);

    final response = await callMethod(
        method: method,
        queryParameters: queryParameters,
        url: url,
        headers: headers,
        body: body,
        encoding: encoding);

    if ((response.body == null || response.body == '') &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      return response;
    }


    var res = jsonDecode(response.body);


    // print(res);

    switch (response.statusCode) {
      case 200:
        {

        }
        break;

      case 400:
        {
           print('error 400 : ${res['message']} ${res['error']}');
          //Common.error(context, res['message'], res['error']);
        }
        break;

      case 403:
        {
          print("error 403: Invalid credentials");
          //Common.error(context, "Invalid credentials", "Check your credentials and try again");
        }
        break;

      case 500:
        {
          print("error 500: ${res['message']} ${res['error']}");
          //Common.error(context, res['message'], res['error']);
        }
        break;
    }

    return response;
  }

  static Future<http.Response> callMethod(
      {method,
        queryParameters,
        url,
        required Map<String, String> headers,
        body,
         Encoding? encoding}) {
    switch (method) {
      case "post":
        {
          print("IN POST");
          return http.post(url, headers: headers, body: body);
          break;
        }

      case "put":
        {
          return http.put(url, headers: headers, body: body);
          break;
        }

      case "get":
        {
          return http.get(url, headers: headers);
          break;
        }

      case "delete":
        {
          return http.delete(url, headers: headers);
          break;
        }

    }
    return http.post(url, headers: headers, body: body);
  }
}
