import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import '../../main.dart';
import '../strings.dart';
import '../theme.dart';

int paymentMethod = 1;

paymmentsList(List<Widget> list, Function() _redraw, BuildContext context){

  //
  // Apple Pay and Google Pay
  //
  var _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: currentSubscription.price.toStringAsFixed(appSettings.digitsAfterComma),
      status: PaymentItemStatus.final_price,
    )
  ];
  if (enableGoogleApplePay)
    list.add(GooglePayButton(
      paymentConfigurationAsset: 'payment_profile_google_pay.json',
      paymentItems: _paymentItems,
      style: theme.darkMode ? GooglePayButtonStyle.black : GooglePayButtonStyle.white,
      type: GooglePayButtonType.pay,
      height: 50,
      margin: const EdgeInsets.only(left: 10, right: 10),
      onPaymentResult: (Map<String, dynamic> result) {
        _appointment("GPay: ${result["paymentMethodData"]["description"]}");
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    ));

  dec(String image, int type){
    return InkWell(
        onTap: (){
      paymentMethod = type;
      paymentProcess(currentSubscription.price, context, getTextByLocale(currentSubscription.text, locale),);
    },
    child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(strings.get(283)), /// "Pay with"
            SizedBox(width: 10,),
            Image.asset(image, height: 30,)
          ],
        ),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1),
            ),
          ],
        )
    ));
  }

  //
  // Stripe
  //
  if (appSettings.stripeEnable)
    list.add(dec("assets/stripe.png", 2));

  //
  // Razorpay
  //
  if (appSettings.razorpayEnable)
    list.add(dec("assets/razorpay.png", 3));

  //
  // Paypal
  //
  if (appSettings.paypalEnable)
    list.add(dec("assets/paypal.png", 4));

  //
  // Flutterwave
  //
  if (appSettings.flutterWaveEnable)
    list.add(dec("assets/flutterwave.png", 5));

  //
  // Paystack
  //
  if (appSettings.payStackEnable)
    list.add(dec("assets/paystack.png", 6));

  //
  // MercadoPago
  //
  if (appSettings.mercadoPagoEnable)
    list.add(dec("assets/mercadopago.png", 7));

  //
  // Instamojo
  //
  if (appSettings.instamojoEnable)
    list.add(dec("assets/instamojo.png", 8));

  //
  // Payu
  //
  if (appSettings.payUEnable)
    list.add(dec("assets/payu.png", 9));

  //
  // Paymob
  //
  if (appSettings.payMobEnable)
    list.add(dec("assets/paymob.png", 10));
}

paymentProcess(double _amount, BuildContext context, String _desc) async {

  // _mainModel = mainModel;
  // _context = context;
//  _book2 = book2;

  // double _amount = getTotal();
  double _total = _amount * 100;
  int _totalInt = _total.toInt();
  // String _totalString = getTotal().toStringAsFixed(appSettings.digitsAfterComma);
  String _totalString = _amount.toStringAsFixed(appSettings.digitsAfterComma);

  String _currencyCode = appSettings.code;
  String _userName = getCurrentAddress().name;
  // String _userAddress = _mainModel.account.getCurrentAddress().address;
  String _userPhone = getCurrentAddress().phone;
  String _userEmail = userAccountData.userEmail;
  //
  //
  //
  // if (paymentMethod == 1)
  //   _appointment(strings.get(81)); /// "Cash payment",
  //
  // Stripe
  //
  if (paymentMethod == 2){
    StripeMobile _stripe = StripeMobile();
    waitInMainWindow(true);
    try {
      _stripe.init(appSettings.stripeKey);
      _stripe.openCheckoutCard(_totalInt, // amount
          _desc,
          _userPhone,
          strings.get(0),
          _currencyCode,
          appSettings.stripeSecretKey,
          _appointment);
    }catch(ex){
      waitInMainWindow(false);
      print(ex.toString());
      messageError(context, ex.toString());
    }

    // StripeModel _stripe = StripeModel();
    // _waits(true);
    // try {
    //   _stripe.init(_mainModel.localAppSettings.stripeKey);
    //   var t = _total.toInt();
    //   _stripe.openCheckoutCard(t, "", "",
    //       _mainModel.localAppSettings.razorpayName,
    //       _mainModel.localAppSettings.code,
    //       _mainModel.localAppSettings.stripeSecretKey, _appointment);
    // }catch(ex){
    //   _waits(false);
    //   print(ex.toString());
    //   messageError(context, ex.toString());
    // }
  }
  if (paymentMethod == 3){
    waitInMainWindow(true);
    RazorpayMobile _razorpayModel = RazorpayMobile();
    _razorpayModel.init();
    _razorpayModel.openCheckout(
        _totalInt.toString(),
        _desc,
        _userPhone,
        appSettings.razorpayName,
        _currencyCode,
        appSettings.razorpayKey,
        _appointment, (String err){messageError(context, err);}
    );

    // _waits(true);
    // RazorpayModel _razorpayModel = RazorpayModel();
    // _razorpayModel.init();
    //
    // var t = _total.toInt();
    // _razorpayModel.openCheckout(t.toString(), "", "",
    //     _mainModel.localAppSettings.razorpayName,
    //     _mainModel.localAppSettings.code,
    //     _mainModel.localAppSettings.razorpayKey,
    //     _appointment, (String err){messageError(context, err);}
    // );
  }
  if (paymentMethod == 4){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaypalPayment(
            currency: _currencyCode,
            userFirstName: _userName,
            userLastName: "",
            userEmail: _userEmail,
            payAmount: _totalString,
            secret: appSettings.paypalSecretKey,
            clientId: appSettings.paypalClientId,
            sandBoxMode: appSettings.paypalSandBox.toString(),
            onFinish: (w){
              _appointment("PayPal: $w");
            }
        ),
      ),
    );

    // String _total = localSettings.getTotalString(_mainModel);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PaypalPayment(
    //         currency: _mainModel.localAppSettings.code,
    //         userFirstName: "",
    //         userLastName: "",
    //         userEmail: "",
    //         payAmount: _total,
    //         secret: _mainModel.localAppSettings.paypalSecretKey,
    //         clientId: _mainModel.localAppSettings.paypalClientId,
    //         sandBoxMode: _mainModel.localAppSettings.paypalSandBox.toString(),
    //         onFinish: (w){
    //           _appointment("PayPal: $w");
    //         }
    //     ),
    //   ),
    // );
  }
  //
  // Flutterwave
  //
  if (paymentMethod == 5){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlutterwaveMobile(
            onFinish: (String w){
              _appointment("Flutterwave: $w");
              waitInMainWindow(false);
            },
            desc: _desc,
            amount: _totalString, //getTotal().toStringAsFixed(appSettings.digitsAfterComma),
            code: _currencyCode, // currency code
            flutterWavePublicKey: appSettings.flutterWavePublicKey,
            userName: _userName,
            userEmail: _userEmail,
            userPhone: _userPhone
        ),
      ),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FlutterwavePayment(
    //         onFinish: (String w){
    //           _appointment("Flutterwave: $w");
    //           _waits(false);
    //         }
    //     ),
    //   ),
    // );
  }
  //
  // Paystack
  //
  if (paymentMethod == 6){
    var ret = await PayStackMobile().handleCheckout(_amount, _userEmail,
        context, appSettings.payStackKey);
    if (ret != null)
      _appointment(ret);
    // var _total = localSettings.getTotal(_mainModel);
    // var paystack = PayStackModel();
    // var ret = await paystack.handleCheckout(_total, _mainModel.userEmail, context, _mainModel.localAppSettings.payStackKey);
    // if (ret != null)
    //   _appointment(ret);
  }
  //
  // Mercadopago
  //
  if (paymentMethod == 7){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MercadoPagoMobile(
          onFinish: (String w){
            _appointment("MercadoPago: $w");
            waitInMainWindow(false);
          },
          desc: _desc,
          amount: _amount,
          accessToken: appSettings.mercadoPagoAccessToken,
          publicKey: appSettings.mercadoPagoPublicKey,
          code: appSettings.demo ? "BRL" : appSettings.code,
        ),
      ),
    );
  }
  //
  // Instamojo
  //
  if (paymentMethod == 8){
    String _total = _totalString; //_amount.toStringAsFixed(appSettings.digitsAfterComma);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstaMojoMobile(
            userName: _userName,
            email: _userEmail,
            phone: _userPhone,
            payAmount: _total,
            token: appSettings.instamojoToken, // PrivateToken
            apiKey: appSettings.instamojoApiKey, // ApiKey
            sandBoxMode: appSettings.instamojoSandBoxMode.toString(), // SandBoxMode
            onFinish: (w){
              _appointment("INSTAMOJO: $w");
            }
        ),
      ),
    );
  }
  //
  // Payu
  //
  if (paymentMethod == 9){
    // String _total = _totalPrice.total.toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayUMobile(
            userName: _userName,
            email: _userEmail,
            phone: _userPhone,
            payAmount: _totalString,
            apiKey: appSettings.payUApiKey, // ApiKey
            merchantId: appSettings.payUMerchantId,
            sandBoxMode: appSettings.payUSandBoxMode.toString(),
            onFinish: (w){
              dprint("PayU: $w");
              _appointment("PayU: $w");
            }
        ),
      ),
    );
  }
  //
  // PayMob
  //
  if (paymentMethod == 10){
    // String _total = _totalPrice.total.toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayMobMobile(
          userFirstName: _userName,
          userEmail: _userEmail,
          userPhone: _userPhone,
          payAmount: _totalString,
          apiKey: appSettings.payMobApiKey, // ApiKey
          frame: appSettings.payMobFrame, // MobFrame
          integrationId: appSettings.payMobIntegrationId, // IntegrationId
          onFinish: (w){
            dprint("PayMob: $w");
            _appointment("PayMob: $w");
          },
          code: appSettings.code,
          userName: userAccountData.userName,
          mainColor: theme.mainColor,
        ),
      ),
    );
  }
  waitInMainWindow(false);
}

_appointment(String paymentMethod) async {
  dprint("_appointment $paymentMethod");
  waitInMainWindow(true);
  var ret = await subscriptionFinish(paymentMethod);
  waitInMainWindow(false);
  if (ret != null)
    return messageError(buildContext, ret);
  goBack();
  goBack();
  redrawMainWindow();
}

