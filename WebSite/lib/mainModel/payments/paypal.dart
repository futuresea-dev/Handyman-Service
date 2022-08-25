import 'package:universal_html/html.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'dart:ui' as ui;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:abg_utils/abg_utils.dart';

class PayPalPayment extends StatefulWidget {
  final double amount;
  final String desc;

  const PayPalPayment({Key? key, required this.amount, required this.desc}) : super(key: key);
  @override
  _PayPalPaymentState createState() => _PayPalPaymentState();
}

class _PayPalPaymentState extends State<PayPalPayment> {

  String? accessToken;
  String? checkoutUrl;
  String? executeUrl;
  String domain = "";
  String returnURL = "";
  String cancelURL = '';

  @override
  void initState() {
    returnURL = currentBase + "paypal_success?booking=$cartLastAddedId";
    cancelURL = currentBase + "paypal_cancel?booking=$cartLastAddedId";
    init();
    super.initState();
  }

  init() async {
    try {
      accessToken = await getAccessToken(appSettings.paypalClientId,
          appSettings.paypalSecretKey, appSettings.paypalSandBox.toString());
      if (accessToken == null)
        return messageError(context, 'PayPal accessToken = null');
      final transactions = getOrderParams(getCurrentAddress().name,
          "", // last name
          widget.desc,
          widget.amount.toStringAsFixed(appSettings.digitsAfterComma),
          appSettings.code);
      final res = await createPaypalPayment(transactions, accessToken);
      if (res != null) {
        setState(() {
          checkoutUrl = res["approvalUrl"];
          executeUrl = res["executeUrl"];
        });
      }
    } catch (ex) {
      messageError(context, 'PayPal exception: ' + ex.toString());
    }
  }

  // for getting the access token from Paypal
  Future<String?> getAccessToken(String clientId, String secret,
      String sandboxMode) async {
    domain = "https://api.paypal.com"; // for production mode
    if (sandboxMode == "true")
      domain = "https://api.sandbox.paypal.com"; // for sandbox mode
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["access_token"];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> getOrderParams(userFirstName, userLastName, itemName,
      String itemPrice, String currency) {
    Map<String, dynamic> params = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": itemPrice,
            "currency": currency,
            "details": {
              "subtotal": itemPrice,
              "shipping": "0",
              "handling_fee": "0",
              "shipping_discount": "0"
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": [
            ]
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return params;
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(transactions,
      accessToken) async {
    try {
      var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 400) {
        throw Exception(body["name"]);
      }
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (checkoutUrl != null){
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory("pp-html", (int viewId) {
        IFrameElement element = IFrameElement();
        window.onMessage.forEach((element) {
          print('Event Received in callback: ${element.data}');
          if (element.data == 'MODAL_CLOSED') {
            //Navigator.pop(context);
          }
          else if (element.data == 'SUCCESS') {
            print('PAYMENT SUCCESSFULL!!!!!!!');
          }
        });

        // element.width = '400';
        // element.height = '400';
        // element.src = 'https://www.youtube.com/embed/IyFZznAk69U';
        // element.src=Uri.dataFromString('<html><body><iframe src="https://www.youtube.com/embed/abc"></iframe></body></html>', mimeType: 'text/html').toString();
        // element.src=Uri.dataFromString(_makeText(), mimeType: 'text/html').toString();
        element.src = checkoutUrl;
        // element.src='assets/payments.html?name=$name&price=$price&image=$image';
        element.style.border = 'none';

        return element;
      });
      return HtmlElementView(viewType: 'pp-html');
    }
    else
      return Container();

  }
}