import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';

class GatewaysScreen extends StatefulWidget {
  @override
  _GatewaysScreenState createState() => _GatewaysScreenState();
}

class _GatewaysScreenState extends State<GatewaysScreen> {

  final _controllerStripePKey = TextEditingController();
  final _controllerStripeSKey = TextEditingController();
  final _controllerPayPalSKey = TextEditingController();
  final _controllerPayPalClient = TextEditingController();
  final _controllerRazorpayCompanyName = TextEditingController();
  final _controllerRazorpayKeyId = TextEditingController();
  // payStack
  final _controllerPayStack = TextEditingController();
  // FlutterWave
  final _controllerFlutterWaveEncryptionKey = TextEditingController();
  final _controllerFlutterWavePublicKey = TextEditingController();
  // mercadoPago
  final _controllerMercadoPagoAccessToken = TextEditingController();
  final _controllerMercadoPagoPublicKey = TextEditingController();
  // PayMob
  final _controllerPayMobApiKey = TextEditingController();
  final _controllerPayMobFrame = TextEditingController();
  final _controllerPayMobIntegrationId = TextEditingController();
  // Instamojo
  final _controllerInstamojoToken = TextEditingController();
  final _controllerInstamojoApiKey = TextEditingController();
  // PayU
  final _controllerPayUApiKey = TextEditingController();
  final _controllerPayUMerchantId = TextEditingController();

  @override
  void initState() {
    _controllerStripePKey.text = appSettings.stripeKey;
    _controllerStripeSKey.text = appSettings.stripeSecretKey;
    _controllerPayPalClient.text = appSettings.paypalClientId;
    _controllerPayPalSKey.text = appSettings.paypalSecretKey;
    _controllerRazorpayCompanyName.text = appSettings.razorpayName;
    _controllerRazorpayKeyId.text = appSettings.razorpayKey;
    _controllerPayStack.text = appSettings.payStackKey;
    _controllerFlutterWaveEncryptionKey.text = appSettings.flutterWaveEncryptionKey;
    _controllerFlutterWavePublicKey.text = appSettings.flutterWavePublicKey;
    //
    _controllerMercadoPagoAccessToken.text = appSettings.mercadoPagoAccessToken;
    _controllerMercadoPagoPublicKey.text = appSettings.mercadoPagoPublicKey;
    // PayMob
    _controllerPayMobApiKey.text = appSettings.payMobApiKey;
    _controllerPayMobFrame.text = appSettings.payMobFrame;
    _controllerPayMobIntegrationId.text = appSettings.payMobIntegrationId;
    // Instamojo
    _controllerInstamojoToken.text = appSettings.instamojoToken;
    _controllerInstamojoApiKey.text = appSettings.instamojoApiKey;
    // PayU
    _controllerPayUApiKey.text = appSettings.payUApiKey;
    _controllerPayUMerchantId.text = appSettings.payUMerchantId;

    super.initState();
  }

  @override
  void dispose() {
    _controllerStripePKey.dispose();
    _controllerStripeSKey.dispose();
    _controllerPayPalSKey.dispose();
    _controllerPayPalClient.dispose();
    _controllerRazorpayCompanyName.dispose();
    _controllerRazorpayKeyId.dispose();
    _controllerPayStack.dispose();
    _controllerFlutterWaveEncryptionKey.dispose();
    _controllerFlutterWavePublicKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body(strings.get(41), "assets/dashboard2/dashboard4.png", _getList()); /// "Payment Gateways"
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(SelectableText("Stripe", style: theme.style16W800));
    list.add(SizedBox(height: 20,));
    list.add(checkBox1a(context, strings.get(2), theme.mainColor, theme.style14W400, /// "Enable Stripe Payment"
        appSettings.stripeEnable, (val) {
      setState(() {appSettings.stripeEnable = val!;});}));

    if (isMobile()) {
      list.add(textElement(strings.get(3), "", _controllerStripePKey)); /// "Publishable key:"
      list.add(textElement(strings.get(4), "", _controllerStripeSKey)); /// Secret key:
    }else{
      list.add(Row(
        children: [
        Expanded(child: textElement(strings.get(3), "", _controllerStripePKey)), /// "Publishable key:"
        SizedBox(width: 20,),
        Expanded(child: textElement(strings.get(4), "", _controllerStripeSKey)), /// Secret key:
      ],));
    }

    list.add(SizedBox(height: 40,));
    list.add(Container(height: 1, width: windowWidth, color: Colors.black.withAlpha(10),));
    list.add(SizedBox(height: 20,));
    list.add(SelectableText("PayPal", style: theme.style16W800));
    list.add(SizedBox(height: 20,));
    list.add(Row(
      children: [
        Expanded(child: checkBox1a(context, strings.get(5), theme.mainColor, theme.style14W400, /// "Enable PayPal Payment"
            appSettings.paypalEnable, (val) {setState(() {
              appSettings.paypalEnable = val!;});})),
        SizedBox(width: 10,),
        Expanded(child: checkBox1a(context, strings.get(368), theme.mainColor, theme.style14W400, /// "PayPal SandBox mode"
            appSettings.paypalSandBox, (val) {setState(() {
              appSettings.paypalSandBox = val!;});})),
      ],
    ));

    if (windowWidth <= 700) {
      list.add(textElement(strings.get(6), "", _controllerPayPalClient)); /// Client Id:
      list.add(textElement(strings.get(7), "", _controllerPayPalSKey)); /// Secret key:
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(6), "", _controllerPayPalClient)), /// Client Id:
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(7), "", _controllerPayPalSKey)) /// Secret key:
        ],));
    }

    //
    // Razorpay
    //
    list.add(SizedBox(height: 40,));
    list.add(Container(height: 1, width: windowWidth, color: Colors.black.withAlpha(10),));
    list.add(SizedBox(height: 20,));
    list.add(SelectableText("Razorpay", style: theme.style16W800));
    list.add(SizedBox(height: 20,));
    list.add(checkBox1a(context, strings.get(8), theme.mainColor, theme.style14W400,  /// "Enable Razorpay Payment"
        appSettings.razorpayEnable,
            (val) {setState(() {appSettings.razorpayEnable = val!;});}));

    if (windowWidth <= 700) {
      list.add(textElement(strings.get(10), "", _controllerRazorpayKeyId)); /// "Key Id:",
      list.add(textElement(strings.get(11), "", _controllerRazorpayCompanyName)); /// "Your company name:",
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(10), "", _controllerRazorpayKeyId)), /// "Key Id:",
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(11), "", _controllerRazorpayCompanyName)), /// "Your company name:",
        ],));
    }

    //
    // payStack
    //
    list.add(SizedBox(height: 40,));
    list.add(Container(height: 1, width: windowWidth, color: Colors.black.withAlpha(10),));
    list.add(SizedBox(height: 20,));
    list.add(SelectableText("PayStack", style: theme.style16W800));
    list.add(SizedBox(height: 20,));
    list.add(checkBox1a(context, strings.get(315), theme.mainColor, theme.style14W400, /// "Enable PayStack Payment"
        appSettings.payStackEnable,
            (val) {setState(() {appSettings.payStackEnable = val!;});}));
    list.add(textElement(strings.get(10), "", _controllerPayStack)); // "Key Id:",

    //
    // FlutterWave
    //
    list.add(SizedBox(height: 40,));
    list.add(Container(height: 1, width: windowWidth, color: Colors.black.withAlpha(10),));
    list.add(SizedBox(height: 20,));
    list.add(SelectableText("Flutterwave", style: theme.style16W800));
    list.add(SizedBox(height: 20,));
    list.add(checkBox1a(context, strings.get(316), theme.mainColor, theme.style14W400,  /// "Enable Flutterwave Payment"
        appSettings.flutterWaveEnable,
            (val) {setState(() {appSettings.flutterWaveEnable = val!;});}));

    if (windowWidth <= 700) {
      list.add(textElement(strings.get(317), "", _controllerFlutterWavePublicKey)); /// "Public key:",
      list.add(textElement(strings.get(318), "", _controllerFlutterWaveEncryptionKey)); /// "Encryption key:",
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(317), "", _controllerFlutterWavePublicKey)), /// "Public key:",
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(318), "", _controllerFlutterWaveEncryptionKey)), /// "Encryption key:",
        ],));
    }

    //
    // mercadoPago
    //
    list.add(SizedBox(height: 40,));
    list.add(Container(height: 1, width: windowWidth, color: Colors.black.withAlpha(10),));
    list.add(SizedBox(height: 20,));
    list.add(SelectableText("MercadoPago", style: theme.style16W800));
    list.add(SizedBox(height: 20,));
    list.add(checkBox1a(context, strings.get(390), theme.mainColor, theme.style14W400,  /// "Enable MercadoPago Payment"
        appSettings.mercadoPagoEnable,
            (val) {setState(() {appSettings.mercadoPagoEnable = val!;});}));

    if (windowWidth <= 700) {
      list.add(textElement(strings.get(391), "", _controllerMercadoPagoAccessToken)); /// "Access Token:",
      list.add(textElement(strings.get(317), "", _controllerMercadoPagoPublicKey)); /// "Public key:",
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(391), "", _controllerMercadoPagoAccessToken)), /// "Access Token:",
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(317), "", _controllerMercadoPagoPublicKey)), /// "Public key:",
        ],));
    }

    //
    // PayMob
    //
    list.add(SizedBox(height: 40,));
    list.add(Container(height: 1, width: windowWidth, color: Colors.black.withAlpha(10),));
    list.add(SizedBox(height: 20,));
    list.add(SelectableText("PayMob ${strings.get(414)}", style: theme.style16W800)); /// "Available only in Customer App (In Web Site unavailable)"
    list.add(SizedBox(height: 20,));
    list.add(checkBox1a(context, strings.get(392), theme.mainColor, theme.style14W400,  /// "Enable PayMob Payment"
        appSettings.payMobEnable,
            (val) {setState(() {appSettings.payMobEnable = val!;});}));

    list.add(textElement(strings.get(393), "", _controllerPayMobApiKey)); /// "API key:",
    if (windowWidth <= 700) {
      list.add(textElement(strings.get(395), "", _controllerPayMobFrame)); /// "Frame Id:",
      list.add(textElement(strings.get(394), "", _controllerPayMobIntegrationId)); /// "Integration Id:",
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(395), "", _controllerPayMobFrame)), /// "Frame Id:",
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(394), "", _controllerPayMobIntegrationId)), /// "Integration Id:",
        ],));
    }

    //
    // Instamojo
    //
    list.add(SizedBox(height: 40,));
    list.add(Container(height: 1, width: windowWidth, color: Colors.black.withAlpha(10),));
    list.add(SizedBox(height: 20,));
    list.add(SelectableText("Instamojo ${strings.get(414)}", style: theme.style16W800)); /// "Available only in Customer App (In Web Site unavailable)"
    list.add(SizedBox(height: 20,));
    list.add(Row(
      children: [
        Expanded(child: checkBox1a(context, strings.get(396), theme.mainColor, theme.style14W400, /// "Enable Instamojo Payment"
            appSettings.instamojoEnable, (val) {setState(() {
              appSettings.instamojoEnable = val!;});})),
        SizedBox(width: 10,),
        Expanded(child: checkBox1a(context, strings.get(398), theme.mainColor, theme.style14W400, /// "Instamojo SandBox mode"
            appSettings.instamojoSandBoxMode, (val) {setState(() {
              appSettings.instamojoSandBoxMode = val!;});})),
      ],
    ));
    if (windowWidth <= 700) {
      list.add(textElement(strings.get(397), "", _controllerInstamojoToken)); /// "Token:",
      list.add(textElement(strings.get(393), "", _controllerInstamojoApiKey)); /// "Api key:",
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(397), "", _controllerInstamojoToken)), /// "Token:",
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(393), "", _controllerInstamojoApiKey)), /// "Api key:",
        ],));
    }

    //
    // PayU
    //
    list.add(SizedBox(height: 40,));
    list.add(Container(height: 1, width: windowWidth, color: Colors.black.withAlpha(10),));
    list.add(SizedBox(height: 20,));
    list.add(SelectableText("PayU ${strings.get(414)}", style: theme.style16W800)); /// "Available only in Customer App (In Web Site unavailable)"
    list.add(SizedBox(height: 20,));
    list.add(Row(
      children: [
        Expanded(child: checkBox1a(context, strings.get(402), theme.mainColor, theme.style14W400, /// "Enable PayU Payment"
            appSettings.payUEnable, (val) {setState(() {
              appSettings.payUEnable = val!;});})),
        SizedBox(width: 10,),
        Expanded(child: checkBox1a(context, strings.get(403), theme.mainColor, theme.style14W400, /// "PayU SandBox mode"
            appSettings.payUSandBoxMode, (val) {setState(() {
              appSettings.payUSandBoxMode = val!;});})),
      ],
    ));
    if (windowWidth <= 700) {
      list.add(textElement(strings.get(404), "", _controllerPayUMerchantId)); /// "Merchant Id",
      list.add(textElement(strings.get(393), "", _controllerPayUApiKey)); /// "Api key:",
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(404), "", _controllerPayUMerchantId)), /// "Merchant Id",
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(393), "", _controllerPayUApiKey)), /// "Api key:",
        ],));
    }
    //
    //
    //

    list.add(SizedBox(height: 40,));
    list.add(Center(child: button2b(strings.get(9), _save))); // "Save"
    list.add(SizedBox(height: 100,));

    return list;
  }

  _save() async {
    // demo mode
    if (appSettings.demo)
      return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
    if (appSettings.stripeEnable) {
      if (_controllerStripePKey.text.isEmpty || _controllerStripeSKey.text.isEmpty)
        return messageError(context, strings.get(195)); /// Please enter Stripe credentials
    }
    if (appSettings.paypalEnable) {
      if (_controllerPayPalSKey.text.isEmpty || _controllerPayPalClient.text.isEmpty)
        return messageError(context, strings.get(196)); /// Please enter PayPal credentials
    }
    if (appSettings.razorpayEnable) {
      if (_controllerRazorpayCompanyName.text.isEmpty || _controllerRazorpayKeyId.text.isEmpty)
        return messageError(context, strings.get(197)); /// Please enter Razorpay credentials
    }
    if (appSettings.payStackEnable) {
      if (_controllerPayStack.text.isEmpty)
        return messageError(context, strings.get(313)); /// Please enter PayStack credentials
    }
    if (appSettings.flutterWaveEnable) {
      if (_controllerFlutterWaveEncryptionKey.text.isEmpty || _controllerFlutterWavePublicKey.text.isEmpty)
        return messageError(context, strings.get(314)); /// Please enter FlutterWave credentials
    }
    if (appSettings.mercadoPagoEnable) {
      if (_controllerMercadoPagoAccessToken.text.isEmpty || _controllerMercadoPagoPublicKey.text.isEmpty)
        return messageError(context, strings.get(399)); /// Please enter MercadoPago credentials
    }
    if (appSettings.payMobEnable) {
      if (_controllerPayMobApiKey.text.isEmpty || _controllerPayMobFrame.text.isEmpty || _controllerPayMobIntegrationId.text.isEmpty)
        return messageError(context, strings.get(400)); /// Please enter PayMob credentials
    }
    if (appSettings.instamojoEnable) {
      if (_controllerInstamojoToken.text.isEmpty || _controllerInstamojoApiKey.text.isEmpty)
        return messageError(context, strings.get(401)); /// Please enter Instamojo credentials
    }
    if (appSettings.payUEnable) {
      if (_controllerPayUApiKey.text.isEmpty || _controllerPayUMerchantId.text.isEmpty)
        return messageError(context, strings.get(405)); /// Please enter PayU credentials
    }

    waitInMainWindow(true);
    var ret = await saveSettingsPayments(_controllerStripePKey.text, _controllerStripeSKey.text,
        _controllerPayPalSKey.text, _controllerPayPalClient.text,
        _controllerRazorpayCompanyName.text, _controllerRazorpayKeyId.text,
        _controllerPayStack.text, _controllerFlutterWaveEncryptionKey.text, _controllerFlutterWavePublicKey.text,
        // mercadoPago
        _controllerMercadoPagoAccessToken.text, _controllerMercadoPagoPublicKey.text,
        // PayMob
        _controllerPayMobApiKey.text, _controllerPayMobFrame.text, _controllerPayMobIntegrationId.text,
        // Instamojo
        _controllerInstamojoToken.text, _controllerInstamojoApiKey.text,
        // PayU
        _controllerPayUApiKey.text, _controllerPayUMerchantId.text
    );
    if (ret == null)
      messageOk(context, strings.get(81)); /// "Data saved",
    else
      messageError(context, ret);
    waitInMainWindow(false);
  }
}


