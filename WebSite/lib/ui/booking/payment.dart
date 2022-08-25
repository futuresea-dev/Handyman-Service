import 'package:abg_utils/abg_utils.dart';
import 'package:abg_utils/payments_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_client/flutter_paystack_client.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import '../../theme.dart';
import '../strings.dart';

int paymentMethod = 1;
String paymentMethodId = "";

paymentsList(ProviderData provider, List<Widget> list, Function() _redraw, bool _noMargin){
  var _margin = isMobile() || _noMargin ? EdgeInsets.only(left: 10, right: 10, bottom: 10)
      : EdgeInsets.only(left: windowWidth*0.2, right: windowWidth*0.2, bottom: 10);

  if (provider.acceptPaymentInCash)
  list.add(Container(
    margin: _margin,
    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    decoration: BoxDecoration(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(theme.radius),
    ),
    child: checkBox43(strings.get(115), /// "Cash payment",
        theme.booking4CheckBoxColor, "assets/cache.png",
        theme.style14W800,
        paymentMethod == 1, (val) {
          if (val) {
            paymentMethod = 1;
            _redraw();
          }
        }),
  ));

  //
  // Stripe
  //
  if (appSettings.stripeEnable)
    list.add(Container(
      margin: _margin,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: checkBox43("Stripe",
          theme.booking4CheckBoxColor, "assets/stripe.png",
          theme.style14W800,
          paymentMethod == 2, (val) {
            if (val) {
              paymentMethod = 2;
              _redraw();
            }
          }),
    ));

  //
  // Razorpay
  //
  if (appSettings.razorpayEnable)
    list.add(Container(
        margin: _margin,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: checkBox43("Razorpay",
            theme.booking4CheckBoxColor, "assets/razorpay.png",
            theme.style14W800,
            paymentMethod == 3, (val) {
              if (val) {
                paymentMethod = 3;
                _redraw();
              }
            })));

  //
  // Paypal
  //
  if (appSettings.paypalEnable)
    list.add(Container(
        margin: _margin,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: checkBox43("Pay Pal",
            theme.booking4CheckBoxColor, "assets/paypal.png",
            theme.style14W800,
            paymentMethod == 4, (val) {
              if (val) {
                paymentMethod = 4;
                _redraw();
              }
            })));

  //
  // Flutterwave
  //
  if (appSettings.flutterWaveEnable)
    list.add(Container(
        margin: _margin,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("Flutterwave",
            theme.booking4CheckBoxColor, "assets/flutterwave.png",
            theme.style14W800,
            paymentMethod == 5, (val) {
              if (val) {
                paymentMethod = 5;
                _redraw();
              }
            })));

  //
  // Paystack
  //
  if (appSettings.payStackEnable)
    list.add(Container(
        margin: _margin,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("Paystack",
            theme.booking4CheckBoxColor, "assets/paystack.png",
            theme.style14W800,
            paymentMethod == 6, (val) {
              if (val) {
                paymentMethod = 6;
                _redraw();
              }
            })));
  //
  // MercadoPago
  //
  if (appSettings.mercadoPagoEnable) {
    list.add(Container(
        margin: _margin,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("MercadoPago",
            theme.booking4CheckBoxColor, "assets/mercadopago.png",
            theme.style14W800,
            paymentMethod == 7, (val) {
              if (val) {
                paymentMethod = 7;
                _redraw();
              }
            }))
    );
  }
  //
  // Instamojo
  //
  // if (_mainModel.localAppSettings.payStackEnable) {
  // list.add(Container(
  //     margin: _margin,
  //     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
  //     decoration: BoxDecoration(
  //       color: (darkMode) ? Colors.black : Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: checkBox43("Instamojo",
  //         theme.booking4CheckBoxColor, "assets/instamojo.png",
  //         theme.style14W800,
  //         _mainModel.paymentMethod == 8, (val) {
  //           if (val) {
  //             _mainModel.paymentMethod = 8;
  //             _redraw();
  //           }
  //         }))
  // );
  // list.add(SizedBox(height: 10,),);
  // }
  //
  // Payu
  //
  // if (_mainModel.localAppSettings.payStackEnable) {
  // list.add(Container(
  //   padding: EdgeInsets.only(left: 10, right: 10),
  //   height: 80,
  //   child: button1s5("assets/payu.png", _mainModel.cart.paymentMethod == 8, (){
  //     _mainModel.cart.paymentMethod = 8;
  //     _redraw();
  //   }),
  // ),);
  // list.add(SizedBox(height: 10,),);
  // }
  //
  // Paymob
  //
  // if (_mainModel.localAppSettings.payStackEnable) {
  // list.add(Container(
  //     margin: _margin,
  //     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
  //     decoration: BoxDecoration(
  //       color: (darkMode) ? Colors.black : Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: checkBox43("Paymob",
  //         theme.booking4CheckBoxColor, "assets/paymob.png",
  //         theme.style14W800,
  //         _mainModel.paymentMethod == 9, (val) {
  //           if (val) {
  //             _mainModel.paymentMethod = 9;
  //             _redraw();
  //           }
  //         }))
  // );
  // list.add(SizedBox(height: 10,),);
  // }
}

_appointment(MainModel _mainModel, BuildContext context) async {
  var ret = await _mainModel.finish(false);
  if (ret != null)
    return messageError(context, ret);
  _mainModel.cashSuccess = true;
  _mainModel.route("payment_success");
  _mainModel.clearBookData();
}

_appointmentTemporary(MainModel _mainModel, BuildContext context) async {
  var ret = await _mainModel.finish(true);
  if (ret != null)
    return messageError(context, ret);
}

paymentProcess(double _total, String _desc,
    MainModel _mainModel, BuildContext context, Function() _razorPayStart) async {
  if (paymentMethod == 1){
    paymentMethodId = strings.get(115); /// "Cash payment",
    _appointment(_mainModel, context);
  }
  if (paymentMethod == 2){
    waitInMainWindow(true);
    paymentMethodId = "Stripe: ${getTextByLocale(price.name, strings.locale)}";
    await _appointmentTemporary(_mainModel, context);
    var ret = await stripeWeb(_total, _desc);
    if (ret != null)
      messageError(context, ret);
  }
  //
  // Razorpay
  //
  if (paymentMethod == 3){
    _razorPayStart();
  }
  //
  // PayPal
  //
  if (paymentMethod == 4){
    await _appointmentTemporary(_mainModel, context);
    _mainModel.payPalShow = true;
    _mainModel.total = _total;
    _mainModel.desc = _desc;
    _mainModel.redraw();
  }
  //
  // Flutterwave
  //
  if (paymentMethod == 5){
    await _appointmentTemporary(_mainModel, context);
    _mainModel.total = _total;
    _mainModel.desc = _desc;
    _mainModel.flutterwaveShow = true;
    _mainModel.redraw();
  }
  //
  // Paystack
  //
  if (paymentMethod == 6){
    int _total2 = (_total*100).toInt();
    paymentMethodId = 'PayStack_${DateTime.now().millisecondsSinceEpoch}';
    PaystackClient.initialize(appSettings.payStackKey);
    Charge charge = Charge()
      ..amount = _total2
      ..reference = paymentMethodId
      ..email = userAccountData.userEmail;

    _mainModel.waits(true);
    final res = await PaystackClient.checkout(context, charge: charge);
    _mainModel.waits(false);
    if (res.status)
      _appointment(_mainModel, context);
    else
      dprint('Failed: ${res.message}');
  }
  //
  // Mercadopago
  //
  if (paymentMethod == 7){
    await _appointmentTemporary(_mainModel, context);
    var t = await getPreferenceId(_total, _desc, context, appSettings.mercadoPagoAccessToken);
    redirectToMPCheckout(appSettings.mercadoPagoPublicKey, t!);
  }
  //
  // Instamojo
  //
  // if (_mainModel.paymentMethod == 8){
  // await _appointmentTemporary();
  // _mainModel.instamojoShow = true;
  // _mainModel.redraw();
  //   String _total = _totalPrice.total.toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => InstaMojoPayment(
  //           userName: _mainModel.userName,
  //           email: _mainModel.userEmail,
  //           phone: _mainModel.userPhone,
  //           payAmount: _total,
  //           token: "test_74c92fefd050d5810d66feaf604", // PrivateToken
  //           apiKey: "test_abd60e0728ccabfd1c7e0d81135", // ApiKey
  //           sandBoxMode: "true", // SandBoxMode
  //           onFinish: (w){
  //             _appointment("INSTAMOJO: $w");
  //           }
  //       ),
  //     ),
  //   );
  // }
  //
  // Payu
  //
  // if (_mainModel.cart.paymentMethod == 8){
  //   String _total = _totalPrice.total.toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PayUPayment(
  //           userName: _mainModel.userName,
  //           email: _mainModel.userEmail,
  //           phone: _mainModel.userPhone,
  //           payAmount: _total,
  //           apiKey: "4Vj8eK4rloUd272L48hsrarnUA", // ApiKey
  //           merchantId: "MULD2miZ",
  //           sandBoxMode: "true",
  //           onFinish: (w){
  //             dprint("PayMob: $w");
  //             _appointment("PayMob: $w");
  //           }
  //       ),
  //     ),
  //   );
  // }
  //
  // PayMob
  //
  // if (_mainModel.cart.paymentMethod == 9){
  //   String _total = getTotal().toStringAsFixed(appSettings.digitsAfterComma);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PayMobMainScreen(
  //           userFirstName: _mainModel.userName,
  //           userEmail: _mainModel.userEmail,
  //           userPhone: _mainModel.userPhone,
  //           payAmount: _total,
  //           apiKey: appSettings.payMobApiKey, // ApiKey
  //           frame: appSettings.payMobFrame, // MobFrame
  //           integrationId: appSettings.payMobIntegrationId, // IntegrationId
  //       ),
  //     ),
  //   );
  // }

}