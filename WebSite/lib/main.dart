import 'dart:html';

import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:ondemand_admin/ui/start.dart';
import 'package:provider/provider.dart';
import 'config.dart';
import 'lang_listener.dart';
import 'ui/main.dart';
import 'ui/strings.dart';
import 'mainModel/model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp();
  await pref.init();
  setConfig();
  FacebookAuth.instance.webInitialize(
    appId: "499673981290732",//<-- YOUR APP_ID
    cookie: true,
    xfbml: true,
    version: "v9.0",
  );

  needStat = true;
  initStat("website2", "2.8.0.23");

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MainModel()),
            ChangeNotifierProvider(create: (_) => LanguageChangeNotifierProvider()),
          ],
          child: WebApp()
      )
  );
}

class WebApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    MainModel _mainModel = Provider.of<MainModel>(context, listen: false);
    context.watch<LanguageChangeNotifierProvider>().currentLocale;
    // var obs = NavigatorObserver();

    return MaterialApp(
      title: strings.get(0),///  App name
      debugShowCheckedModeBanner: false,
      // navigatorObservers: [obs],
      theme: ThemeData(
        fontFamily: "Tajawal",
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/main',
      onGenerateRoute: (RouteSettings settings) {

        print("settings.name=${settings.name}");
        if (settings.name != null && settings.name == "/start")
          return MaterialPageRoute(builder: (_) => StartScreen());

        if (settings.name != null && settings.name == "/privacy-policy.html"){
          _mainModel.openDocument = "policy";
          return MaterialPageRoute(builder: (_) => MainScreen(state: "documents"));
        }
        if (settings.name != null && settings.name == "/terms.html"){
          _mainModel.openDocument = "terms";
          return MaterialPageRoute(builder: (_) => MainScreen(state: "documents"));
        }
        if (settings.name != null && settings.name == "/about.html"){
          _mainModel.openDocument = "about";
          return MaterialPageRoute(builder: (_) => MainScreen(state: "documents"));
        }

        if (settings.name != null && settings.name != "/") {
          print("onGenerateRoute ${settings.name}");
          Uri uri = Uri.parse(settings.name!);
          var t = uri.pathSegments;

          if (t.isNotEmpty && t[0] == "paypal_success") {
            _mainModel.payPalSuccess = true;
            if (uri.queryParameters["paymentId"] != null)
              _mainModel.payPalPaymentId = uri.queryParameters["paymentId"]!;
            if (uri.queryParameters["booking"] != null) {
              cartLastAddedId = uri.queryParameters["booking"]!;
              // _mainModel.lastBooking = uri.queryParameters["booking"]!;
            }
          }
          if (t.isNotEmpty && t[0] == "paypal_cancel") {
            _mainModel.payPalCancel = true;
            if (uri.queryParameters["paymentId"] != null)
              _mainModel.payPalPaymentId = uri.queryParameters["paymentId"]!;
            if (uri.queryParameters["booking"] != null) {
              cartLastAddedId = uri.queryParameters["booking"]!;
              // _mainModel.lastBooking = uri.queryParameters["booking"]!;
            }
          }
          if (t.isNotEmpty && t[0] == "stripe_success") {
            _mainModel.stripeSuccess = true;
            if (uri.queryParameters["booking"] != null) {
              cartLastAddedId = uri.queryParameters["booking"]!;
              // _mainModel.lastBooking = uri.queryParameters["booking"]!;
            }
          }
          if (t.isNotEmpty && t[0] == "stripe_cancel") {
            _mainModel.stripeCancel = true;
            if (uri.queryParameters["booking"] != null) {
              cartLastAddedId = uri.queryParameters["booking"]!;
              // _mainModel.lastBooking = uri.queryParameters["booking"]!;
            }
          }
          if (t.isNotEmpty && t[0] == "flutterwave_success") {
            _mainModel.flutterwave = true;
            if (uri.queryParameters["booking"] != null) {
              cartLastAddedId = uri.queryParameters["booking"]!;
              // _mainModel.lastBooking = uri.queryParameters["booking"]!;
            }
            if (uri.queryParameters["transaction_id"] != null)
              _mainModel.flutterwaveTransactionId =
              uri.queryParameters["transaction_id"]!;
          }
          if (t.isNotEmpty && t[0] == "mercadopago_success" &&
              !_mainModel.mercadoPagoSuccess) {
            _mainModel.mercadoPagoSuccess = true;
            print("lib main _mainModel.mercadoPagoSuccess=${_mainModel
                .mercadoPagoSuccess}");
            if (uri.queryParameters["booking"] != null) {
              cartLastAddedId = uri.queryParameters["booking"]!;
              // _mainModel.lastBooking = uri.queryParameters["booking"]!;
            }
            if (uri.queryParameters["collection_id"] != null)
              _mainModel.mercadoPagoTransactionId =
              uri.queryParameters["collection_id"]!;
            var t = document.getElementById("mercadopago-checkout");
            print(t.toString());
            if (t != null)
              t.remove();
            var t1 = document.getElementsByClassName(
                "mp-mercadopago-checkout-wrapper");
            for (var item in t1)
              item.remove();
            // /mercadopago_success?booking=&collection_id=1243047401&collection_status=approved&payment_id=1243047401&status=approved&external_reference=null&payment_type=credit_card&merchant_order_id=3541554078&preference_id=140010600-115a9f04-c1b7-4775-8444-e7c628e48238&site_id=MLU&processing_mode=aggregator&merchant_account_id=null
          }
          // paymob
          // https://www.abg-studio.com/ondemandSite/?is_voided=false&error_occured=false&is_3d_secure=true&source_data.sub_type=MasterCard&
          // amount_cents=1680&has_parent_transaction=false&captured_amount=0&merchant_commission=0&is_void=false&is_auth=false&
          // hmac=c1b7c4da8e0d8b6aa13c2efe7eb840c688429ce2aae757ae28519f2756f1aded2bbe7b30f1e2b8ef922efda10c009af9c84cb0444d427bfbb78264c0e14ddd4a&pending=false&
          // owner=246931&
          // integration_id=1563218&
          // profile_id=138667&created_at=2021-11-06T21%3A25%3A40.337437&
          // order=21538148&
          // source_data.type=card&
          // currency=EGP&source_data.pan=2346&is_standalone_payment=true&success=false&is_capture=false&data.message=BLOCKED&is_refund=false&refunded_amount_cents=0&id=16851556&txn_response_code=BLOCKED&is_refunded=false
        }

        if (settings.name != null && settings.name == "/")
          return null;

        print("MaterialPageRoute MainScreen");
        return MaterialPageRoute(builder: (_) => MainScreen());
      },
      // http://localhost:55581/#/paypal_success?paymentId=PAYID-MFZLSCI9YK430952U073062A&token=EC-1MY47356VP0553603&PayerID=5TRVVUPHE8SGY
      //  /flutterwave_success?booking=&status=successful&tx_ref=RX1&transaction_id=2567702
      // routes: {
      //   '/main': (BuildContext context) => MainScreen(route: "main"),
      //   '/stripe_success': (BuildContext context) => MainScreen(route: "stripe_success"),
      //   '/stripe_cancel': (BuildContext context) => MainScreen(route: "stripe_cancel"),
      // },
    );
  }
}

