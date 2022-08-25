import 'package:flutter/material.dart';
import 'package:abg_utils/abg_utils.dart';

bool onDemandUserLogin = false;
bool darkMode = false;

ServiceAppTheme theme = ServiceAppTheme();
late Decoration decor;
ServiceAppCustomization serviceApp = ServiceAppCustomization();

class ServiceAppCustomization{
  double radius = 10;
  Color mainColor = Color(0xff69c4ff);
  Color colorBackground = Color(0xfff1f6fe);
  Color blackColorTitleBkg = Color(0xff202020);
  // splash
  String logo = ""; // https://firebasestorage.googleapis.com/v0/b/brevix.appspot.com/o/apps%2Fc0b154bc-050a-4bce-babd-04d50f889cbb.jpg?alt=media&token=ef7a8e8a-7737-4504-980c-dbc48b2947ee
  String splashImage = "";
  bool logoAsset = true;
  bool splashImageAsset = true;
  Color splashColor = Color(0xff1c7bab);
  // lang
  bool langLogoAsset = true;
  String langLogo = "";
  // login
  bool loginLogoAsset = true;
  String loginLogo = "";
  bool loginImageAsset = true;
  String loginImage = "";
  // register
  bool registerLogoAsset = true;
  String registerLogo = "";
  // home
  bool homeLogoAsset = true;
  String homeLogo = "";
  // provider
  Color providerStarColor = Color(0xFFFFA726);
  bool providerGLogoAsset = true;
  String providerGLogo = "";
  bool providerRLogoAsset = true;
  String providerRLogo = "";
  // service
  Color serviceStarColor = Color(0xFFFFA726);
  bool serviceGLogoAsset = true;
  String serviceGLogo = "";
  bool serviceRLogoAsset = true;
  String serviceRLogo = "";
  // category
  Color categoryStarColor = Color(0xFFFFA726);
  Color categoryBoardColor = Color(0xFF66BB6A);
  // booking
  bool bookingNotFoundImageAsset = true;
  String bookingNotFoundImage = "";
  // chat
  bool chatLogoAsset = true;
  String chatLogo = "";
  // chat 2
  bool chat2LogoAsset = true;
  String chat2Logo = "";
  bool chatSendButtonImageAsset = true;
  String chatSendButtonImage = "";
  // notify
  bool notifyLogoAsset = true;
  String notifyLogo = "";
  bool notifyNotFoundImageAsset = true;
  String notifyNotFoundImage = "";
  // account
  bool accountLogoAsset = true;
  String accountLogo = "";
  // profile
  bool profileLogoAsset = true;
  String profileLogo = "";
  // documents
  bool documentsLogoAsset = true;
  String documentsLogo = "";
  // booking 1
  Color booking1CheckBoxColor = Color(0xFFFFA726);
  // booking 4
  Color booking4CheckBoxColor = Color(0xFFFFA726);
  // booking 5
  bool booking5LogoAsset = true;
  String booking5Logo = "";

  ServiceAppCustomization({
    this.mainColor = const Color(0xff69c4ff), this.colorBackground = const Color(0xfff1f6fe),
    this.blackColorTitleBkg = const Color(0xff202020),
    // splash
    this.logo = "", this.splashImage = "", this.logoAsset = true,
    this.splashImageAsset = true, this.splashColor = const Color(0xff1c7bab),
    // lang
    this.langLogoAsset = true,
    this.langLogo = "",
    // login
    this.loginImageAsset = true, this.loginLogo = "", this.loginLogoAsset = true, this.loginImage = "",
    // register
    this.registerLogoAsset = true, this.registerLogo = "",
    // home
    this.homeLogoAsset = true, this.homeLogo = "",
    // provider
    this.providerStarColor = const Color(0xFFFFA726),
    this.providerGLogoAsset = true, this.providerGLogo = "",
    this.providerRLogoAsset = true, this.providerRLogo = "",
    // service
    this.serviceStarColor = const Color(0xFFFFA726),
    this.serviceGLogoAsset = true, this.serviceGLogo = "",
    this.serviceRLogoAsset = true, this.serviceRLogo = "",
    // category
    this.categoryStarColor = const Color(0xFFFFA726),
    this.categoryBoardColor = const Color(0xFF66BB6A),
    // booking
    this.bookingNotFoundImageAsset = true, this.bookingNotFoundImage = "",
    // chat
    this.chatLogoAsset = true, this.chatLogo = "",
    // chat 2
    this.chat2LogoAsset = true, this.chat2Logo = "",
    this.chatSendButtonImageAsset = true, this.chatSendButtonImage = "",
    // notify
    this.notifyLogoAsset = true, this.notifyLogo = "",
    this.notifyNotFoundImageAsset = true, this.notifyNotFoundImage = "",
    // account
    this.accountLogoAsset = true, this.accountLogo = "",
    // profile
    this.profileLogoAsset = true, this.profileLogo = "",
    // documents
    this.documentsLogoAsset = true, this.documentsLogo = "",
    // booking 1
    this.booking1CheckBoxColor = const Color(0xFFFFA726),
    // booking 4
    this.booking4CheckBoxColor = const Color(0xFFFFA726),
    // booking 5
    this.booking5LogoAsset = true, this.booking5Logo = "",

  }){
    decor = BoxDecoration(
      color: (darkMode) ? blackColorTitleBkg: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.grey.withAlpha(20)),
    );
  }

  Map<String, dynamic> toJson() => {
    'mainColor' : mainColor.value.toString(),
    'colorBackground' : colorBackground.value.toString(),
    'blackColorTitleBkg' : blackColorTitleBkg.value.toString(),
    // splash
    'logo' : logo,
    'splashImage' : splashImage,
    'logoAsset' : logoAsset,
    'splashImageAsset' : splashImageAsset,
    'splashColor' : splashColor.value.toString(),
    // lang
    'langLogoAsset' : langLogoAsset,
    'langLogo' : langLogo,
    // login
    'loginLogoAsset' : loginLogoAsset,
    'loginLogo' : loginLogo,
    'loginImageAsset' : loginImageAsset,
    'loginImage' : loginImage,
    // register
    'registerLogoAsset' : registerLogoAsset,
    'registerLogo' : registerLogo,
    // home
    'homeLogoAsset' : homeLogoAsset,
    'homeLogo' : homeLogo,
    // provider
    'providerGLogoAsset' : providerGLogoAsset,
    'providerGLogo' : providerGLogo,
    'providerRLogoAsset' : providerRLogoAsset,
    'providerRLogo' : providerRLogo,
    'providerStarColor' : providerStarColor.value.toString(),
     // service
    'serviceGLogoAsset' : serviceGLogoAsset,
    'serviceGLogo' : serviceGLogo,
    'serviceRLogoAsset' : serviceRLogoAsset,
    'serviceRLogo' : serviceRLogo,
    'serviceStarColor' : serviceStarColor.value.toString(),
    // category
    'categoryStarColor' : categoryStarColor.value.toString(),
    'categoryBoardColor' : categoryBoardColor.value.toString(),
    // booking
    'bookingNotFoundImageAsset' : bookingNotFoundImageAsset,
    'bookingNotFoundImage' : bookingNotFoundImage,
     // chat
    'chatLogoAsset' : chatLogoAsset,
    'chatLogo' : chatLogo,
     // chat 2
    'chat2LogoAsset' : chat2LogoAsset,
    'chat2Logo' : chat2Logo,
    'chatSendButtonImageAsset' : chatSendButtonImageAsset,
    'chatSendButtonImage' : chatSendButtonImage,
     // notify
    'notifyLogoAsset' : notifyLogoAsset,
    'notifyLogo' : notifyLogo,
    'notifyNotFoundImageAsset' : notifyNotFoundImageAsset,
    'notifyNotFoundImage' : notifyNotFoundImage,
    // account
    'accountLogoAsset' : accountLogoAsset,
    'accountLogo' : accountLogo,
     // profile
    'profileLogoAsset' : accountLogoAsset,
    'profileLogo' : accountLogo,
     // documents
    'documentsLogoAsset' : documentsLogoAsset,
    'documentsLogo' : documentsLogo,
    // booking 1
    'booking1CheckBoxColor' : booking1CheckBoxColor.value.toString(),
    // booking 4
    'booking4CheckBoxColor' : booking4CheckBoxColor.value.toString(),
    // booking 5
    'booking5LogoAsset' : booking5LogoAsset,
    'booking5Logo' : booking5Logo,
  };

  factory ServiceAppCustomization.fromJson(Map<String, dynamic> data){
    return ServiceAppCustomization(
      mainColor : (data["mainColor"] != null) ? toColor(data["mainColor"]) : Color(0xff69c4ff),
      colorBackground : (data["colorBackground"] != null) ? toColor(data["colorBackground"]) : Color(0xfff1f6fe),
      blackColorTitleBkg: (data["blackColorTitleBkg"] != null) ? toColor(data["blackColorTitleBkg"]) : Color(0xff202020),
      // splash
      logo : (data["logo"] != null) ? data["logo"]: "",
      splashImage : (data["splashImage"] != null) ? data["splashImage"]: "",
      logoAsset : (data["logoAsset"] != null) ? data["logoAsset"]: true,
      splashImageAsset : (data["splashImageAsset"] != null) ? data["splashImageAsset"]: true,
      splashColor : (data["splashColor"] != null) ? toColor(data["splashColor"]) : Color(0xff1c7bab),
      // lang
      langLogoAsset : (data["langLogoAsset"] != null) ? data["langLogoAsset"]: true,
      langLogo : (data["langLogo"] != null) ? data["langLogo"]: "",
      // login
      loginLogoAsset : (data["loginLogoAsset"] != null) ? data["loginLogoAsset"]: true,
      loginLogo : (data["loginLogo"] != null) ? data["loginLogo"]: "",
      loginImageAsset : (data["loginImageAsset"] != null) ? data["loginImageAsset"]: true,
      loginImage : (data["loginImage"] != null) ? data["loginImage"]: "",
      // register
      registerLogoAsset : (data["registerLogoAsset"] != null) ? data["registerLogoAsset"]: true,
      registerLogo : (data["registerLogo"] != null) ? data["registerLogo"]: "",
      // home
      homeLogoAsset : (data["homeLogoAsset"] != null) ? data["homeLogoAsset"]: true,
      homeLogo : (data["homeLogo"] != null) ? data["homeLogo"]: "",
      // provider
      providerStarColor : (data["providerStarColor"] != null) ? toColor(data["providerStarColor"]) : Color(0xFFFFA726),
      providerGLogoAsset : (data["providerGLogoAsset"] != null) ? data["providerGLogoAsset"]: true,
      providerGLogo : (data["providerGLogo"] != null) ? data["providerGLogo"]: "",
      providerRLogoAsset : (data["providerRLogoAsset"] != null) ? data["providerRLogoAsset"]: true,
      providerRLogo : (data["providerRLogo"] != null) ? data["providerRLogo"]: "",
      // service
      serviceStarColor : (data["serviceStarColor"] != null) ? toColor(data["serviceStarColor"]) : Color(0xFFFFA726),
      serviceGLogoAsset : (data["serviceGLogoAsset"] != null) ? data["serviceGLogoAsset"]: true,
      serviceGLogo : (data["serviceGLogo"] != null) ? data["serviceGLogo"]: "",
      serviceRLogoAsset : (data["serviceRLogoAsset"] != null) ? data["serviceRLogoAsset"]: true,
      serviceRLogo : (data["serviceRLogo"] != null) ? data["serviceRLogo"]: "",
      // category
      categoryStarColor : (data["categoryStarColor"] != null) ? toColor(data["categoryStarColor"]) : Color(0xFFFFA726),
      categoryBoardColor : (data["categoryBoardColor"] != null) ? toColor(data["categoryBoardColor"]) : Color(0xFF66BB6A),
      // booking
      bookingNotFoundImageAsset : (data["bookingNotFoundImageAsset"] != null) ? data["bookingNotFoundImageAsset"]: true,
      bookingNotFoundImage : (data["bookingNotFoundImage"] != null) ? data["bookingNotFoundImage"]: "",
      // chat
      chatLogoAsset : (data["chatLogoAsset"] != null) ? data["chatLogoAsset"]: true,
      chatLogo : (data["chatLogo"] != null) ? data["chatLogo"]: "",
      // chat 2
      chat2LogoAsset : (data["chat2LogoAsset"] != null) ? data["chat2LogoAsset"]: true,
      chat2Logo : (data["chat2Logo"] != null) ? data["chat2Logo"]: "",
      chatSendButtonImageAsset : (data["chatSendButtonImageAsset"] != null) ? data["chatSendButtonImageAsset"]: true,
      chatSendButtonImage : (data["chatSendButtonImage"] != null) ? data["chatSendButtonImage"]: "",
      // notify
      notifyLogoAsset : (data["notifyLogoAsset"] != null) ? data["notifyLogoAsset"]: true,
      notifyLogo : (data["notifyLogo"] != null) ? data["notifyLogo"]: "",
      notifyNotFoundImageAsset : (data["notifyNotFoundImageAsset"] != null) ? data["notifyNotFoundImageAsset"]: true,
      notifyNotFoundImage : (data["notifyNotFoundImage"] != null) ? data["notifyNotFoundImage"]: "",
      // account
      accountLogoAsset : (data["accountLogoAsset"] != null) ? data["accountLogoAsset"]: true,
      accountLogo : (data["accountLogo"] != null) ? data["accountLogo"]: "",
      // profile
      profileLogoAsset : (data["profileLogoAsset"] != null) ? data["profileLogoAsset"]: true,
      profileLogo : (data["profileLogo"] != null) ? data["profileLogo"]: "",
      //  documents
      documentsLogoAsset : (data["documentsLogoAsset"] != null) ? data["documentsLogoAsset"]: true,
      documentsLogo : (data["documentsLogo"] != null) ? data["documentsLogo"]: "",
      // booking 1
      booking1CheckBoxColor : (data["booking1CheckBoxColor"] != null) ? toColor(data["booking1CheckBoxColor"]) : Color(0xFFFFA726),
      // booking 4
      booking4CheckBoxColor : (data["booking4CheckBoxColor"] != null) ? toColor(data["booking4CheckBoxColor"]) : Color(0xFFFFA726),
      // booking 5
      booking5LogoAsset : (data["booking5LogoAsset"] != null) ? data["booking5LogoAsset"]: true,
      booking5Logo : (data["booking5Logo"] != null) ? data["booking5Logo"]: "",

    );
  }
}

class ServiceAppTheme{

  double radius = 10;
  static double reFactor = 0.8;
  static final String _font = "Montserrat";

  TextStyle style10W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 10*reFactor, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style10W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 10*reFactor, fontWeight: FontWeight.w600, color: Colors.grey);

  TextStyle style12W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 14*reFactor, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style12W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12*reFactor, fontWeight: FontWeight.w600, color: Colors.grey);

  TextStyle style12W600Blue = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12*reFactor, fontWeight: FontWeight.w600, color: Colors.blue);

  TextStyle style12W600Orange = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12*reFactor, fontWeight: FontWeight.w600, color: Colors.orange);

  //
  TextStyle style12W600Stars = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12*reFactor, fontWeight: FontWeight.w600, color: serviceApp.serviceStarColor);

  TextStyle style12W600StarsCategory = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12*reFactor, fontWeight: FontWeight.w600, color: serviceApp.categoryStarColor);

  //
  TextStyle style12W600White = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12*reFactor, fontWeight: FontWeight.w600, color: Colors.white);

  TextStyle style12W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12*reFactor, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style14W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 14*reFactor, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style14W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 14*reFactor, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style14W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 14*reFactor, fontWeight: FontWeight.w600, color: Colors.grey);

  TextStyle style15W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 15*reFactor, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style16W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style16W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style16W800White = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w800, color: Colors.white);

  TextStyle style16W800Main = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w800, color: serviceApp.mainColor);

  TextStyle style16W400U = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
      color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style16W800Green = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w800, color: Colors.green);

  TextStyle style16W800Red = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w800, color: Colors.red);

  TextStyle style16W800Orange = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w800, color: Colors.orange);

  TextStyle style16W800Blue = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w800, color: Colors.blue);

  TextStyle style16W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w600, color: Colors.grey);

  TextStyle style16W800Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16*reFactor, fontWeight: FontWeight.w800, color: Colors.grey);

  TextStyle style18W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 18*reFactor, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style18W800Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 18*reFactor, fontWeight: FontWeight.w800, color: Colors.grey);

  TextStyle style18W800Orange = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 18*reFactor, fontWeight: FontWeight.w800, color: Colors.orange);

  TextStyle style20W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 20*reFactor, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style20W800Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 20*reFactor, fontWeight: FontWeight.w800, color: Colors.grey);

  TextStyle style20W800Red = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 20*reFactor, fontWeight: FontWeight.w800, color: Colors.red);

  TextStyle style20W800Green = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 20*reFactor, fontWeight: FontWeight.w800, color: Colors.green);

  TextStyle style20W400U = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 20*reFactor, fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
      color: Colors.black);

  TextStyle style25W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 25*reFactor, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);

  TextStyle style14W800W = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 14*reFactor, fontWeight: FontWeight.w800, color: Colors.white);
}
