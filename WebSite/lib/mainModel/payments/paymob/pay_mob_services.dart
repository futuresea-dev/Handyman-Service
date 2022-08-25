import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

// String _apiKey = "ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKSVV6VXhNaUo5LmV5SndjbTltYVd4bFgzQnJJam8zT1RBM09Dd2libUZ0WlNJNkltbHVhWFJwWVd3aUxDSmpiR0Z6Y3lJNklrMWxjbU5vWVc1MEluMC45LWZnU0NSY0VfQ1RFdC00OUhXdHlHbFJGbFNzbl8wQUpFcFJFQ3VyLWt4WlV6bmdmS3hKV3VNV3gtZmtxNHhEbzFBNFRtLVcxXy1kLTRwb1FFNVNNZw==";
// String _frame = "191358";
// String _integrationId = "202620";

class PayMobServices {

  String? accessToken;

  // 1. authentication
  Future<String?> authentication(String _apiKey) async {
    try {
      var response = await http.post(Uri.parse('https://accept.paymobsolutions.com/api/auth/tokens'),
          body: convert.jsonEncode({
            "api_key": _apiKey
          }),
          headers: {
            "content-type": "application/json",
          });
      if (response.statusCode == 201) {
        final body = convert.jsonDecode(response.body);
        accessToken = body["token"];
        return accessToken;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  String? _itemPrice;
  String? _orderId;

  // 2 create order
  createOrder(String itemPrice, String orderId, String code) async {
    _orderId = orderId;
    _itemPrice = (double.parse(itemPrice)*100).toString();
    try {
      var response = await http.post(Uri.parse("https://accept.paymobsolutions.com/api/ecommerce/orders"),
          body: convert.jsonEncode({
            "auth_token": accessToken,
            "delivery_needed": "false",
            "amount_cents": "$_itemPrice",
            "currency": code, //"EGP",
            // "merchant_order_id": _orderId,
          }),
          headers: {
            "content-type": "application/json",
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
          _orderId = body["id"].toString();
        return _orderId;
      } else {
        throw Exception(body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // for executing the payment transaction
  executePayment(String _integrationId, String _frame,
          String country,
          String postalCode, String state, String city, String street,
          String building, String floor, String apartment, String firstName,
          String lastName, String userEmail, String phoneNumber, String code) async {
    try {
      var _body = convert.jsonEncode({
        "auth_token": "$accessToken",
        "amount_cents": "$_itemPrice",
        "expiration": 3600,
        "order_id": _orderId,
        "billing_data": {
          "apartment": apartment,
          "email": userEmail,
          "floor": floor,
          "first_name": firstName,
          "street": street,
          "building": building,
          "phone_number": phoneNumber,
          "shipping_method": "no",
          "postal_code": postalCode,
          "city": city,
          "country": country,
          "last_name": lastName,
          "state": state
        },
        "currency": code,
        "integration_id": _integrationId,
        "lock_order_when_paid": "false"
      });
      var response = await http.post(Uri.parse("https://accept.paymobsolutions.com/api/acceptance/payment_keys"),
          body: _body,
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken.toString()
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        var token = body['token'];
        return "https://accept.paymob.com/api/acceptance/iframes/$_frame?payment_token=$token";
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}