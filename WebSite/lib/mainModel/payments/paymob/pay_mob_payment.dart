import 'dart:core';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'package:webviewx/webviewx.dart';
import 'dart:ui' as ui;
import 'pay_mob_services.dart';

class PayMobPayment extends StatefulWidget {
  final String id;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final String payAmount;
  final String userPhone;
  final String apiKey;
  final String frame;
  final String integrationId;
  //
  final String country;
  final String postalCode;
  final String state;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String apartment;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  PayMobPayment({required this.userFirstName, this.userLastName = "",
    required this.userEmail, required this.payAmount,
    required this.apiKey, required this.frame, required this.integrationId, required this.userPhone, this.id = "", required this.country,
    required this.postalCode, required this.state, required this.city, required this.street, required this.building, required this.floor,
    required this.apartment, required this.firstName, required this.lastName, required this.email, required this.phoneNumber});

  @override
  State<StatefulWidget> createState() {
    return PayMobPaymentState();
  }
}

class PayMobPaymentState extends State<PayMobPayment> {
  String? checkoutUrl;
  String? accessToken;
  var services = PayMobServices();
  List<String> payResponse = [];
  late WebViewXController webviewController;

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      try {
        // _mainModel.localAppSettings.code = "EGP";
        accessToken = await services.authentication(widget.apiKey);
        if (accessToken == null)
          return messageError(context, "Check apiKey");
        await services.createOrder(widget.payAmount, cartLastAddedId, appSettings.code);
        checkoutUrl = await services.executePayment(
            widget.integrationId, widget.frame,
            widget.country, widget.postalCode, widget.state, widget.city, widget.street,
            widget.building, widget.floor, widget.apartment, widget.firstName,
            widget.lastName, widget.userEmail, widget.phoneNumber, appSettings.code);
        if (checkoutUrl == null)
          return messageError(context, "executePayment fails");

        setState(() {
        });

      } catch (e) {
        print('PayMobPaymentState: ' + e.toString());
        messageError(context, e.toString());
      }
    });
  }

  // https://www.abg-studio.com/restaurants_site/public/PayMob?is_voided=false&error_occured=false&is_3d_secure=true&source_data.sub_type=MasterCard&
  // amount_cents=1233300&has_parent_transaction=false&captured_amount=0&merchant_commission=0&is_void=false&is_auth=false&hmac=8f5c7ff4004318df75e6ea17487f0181903b1c60f7a57e7faadc9e2f2fc1292b5db7282fbe840828a4fbe027e78c9e00ef1df0017ed06143079a51ba227ef514
  // &pending=false&owner=130228&integration_id=202620&profile_id=79078&created_at=2021-11-06T18%3A26%3A20.407661&
  // order=21516669&source_data.type=card&currency=EGP&source_data.pan=2346&is_standalone_payment=true&success=false&
  // is_capture=false&data.message=BLOCKED&is_refund=false&refunded_amount_cents=0&id=16832787&txn_response_code=BLOCKED&is_refunded=false
  int quantity = 1;

  // Map<String, dynamic> getOrderParams(userFirstName, userLastName, itemName, itemPrice, String currency) {
  //   Map<String, dynamic> params = ;
  //   return params;
  // }

  appBar(title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=> Navigator.pop(context)),
      backgroundColor: Colors.white,
      title: Text(
        title,
      ),
    );
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
      return Scaffold(body: HtmlElementView(viewType: 'pp-html'));
    }
    else
      return Scaffold(body: Container());

    // if (checkoutUrl != null) {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: appBar("PayMob"),
    //     body: WebViewX(
    //       initialContent: "",
    //       onWebViewCreated: (controller) {
    //         webviewController = controller;
    //         webviewController.loadContent(
    //           checkoutUrl!,
    //           SourceType.urlBypass,
    //         );
    //       } ,
    //       javascriptMode: JavascriptMode.unrestricted,
    //       navigationDelegate: (NavigationRequest request) {
    //         print(request.content.source);
    //         // if (request.url.contains("txn_response_code=APPROVED")) {
    //         //   final uri = Uri.parse(request.url);
    //         //   // txn_response_code=BLOCKED
    //         //   // https://www.abg-studio.com/restaurants_site/public/PayMob?integration_id=202620&is_capture=false&source_data.pan=2346&
    //         //   // currency=EGP&is_3d_secure=true&profile_id=79078&owner=130228&created_at=2021-11-05T11%3A29%3A13.392335&refunded_amount_cents=0&
    //         //   // error_occured=false&is_standalone_payment=true&data.message=BLOCKED&
    //         //   // source_data.sub_type=MasterCard&has_parent_transaction=false&is_refunded=false&merchant_commission=0&
    //         //   // success=false&txn_response_code=BLOCKED&id=16721709&is_void=false&source_data.type=card&
    //         //   // pending=false&order=21396413&captured_amount=0&is_auth=false&amount_cents=16800&
    //         //   // hmac=f0a530a789b968f425ce7e0f438d69579f56f11763a23db339ff132e87325aac9546a703b432900b5d7ccc24c8f4d4d02b5c823c8eb69694bdd0cad39152f82b&is_voided=false&is_refund=false
    //         //
    //         //   // final payerID = uri.queryParameters['id'];
    //         //   // if (payerID != null) {
    //         //     // services.executePayment(payerID, widget.userFirstName, widget.userPhone, widget.userEmail)
    //         //     //     .then((List<String> ls) {
    //         //     //    print("paymentMethod: " + payerID+"  "+ accessToken + " " +ls[0]);
    //         //     //    setState(() {
    //         //     //      payResponse = ls;
    //         //     //    });
    //         //     // widget.onFinish(uri.queryParameters['id']);
    //         //     Navigator.of(context).pop();
    //         //     Navigator.of(context).pop();
    //         //     // });
    //         //   // } else
    //         //   //   Navigator.of(context).pop();
    //         // }
    //         // if (request.url.contains("txn_response_code=BLOCKED")){
    //         //   messageError(context, "BLOCKED");
    //         //   Navigator.of(context).pop();
    //         //   Navigator.of(context).pop();
    //         // }
    //         //
    //         //
    //         // // if (request.url.contains(cancelURL)) {
    //         // //   Navigator.of(context).pop();
    //         // // }
    //         return NavigationDecision.navigate;
    //       },
    //       width: windowWidth,
    //       height: windowHeight,
    //     ),
    //   );
    // } else {
    //   return Scaffold(
    //     appBar: AppBar(
    //       leading: IconButton(
    //           icon: Icon(Icons.arrow_back),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           }),
    //       backgroundColor: Colors.black12,
    //       elevation: 0.0,
    //     ),
    //     body: Center(child: Container(child: CircularProgressIndicator())),
    //   );
    // }
  }
}
