import 'package:flutter/material.dart';
import 'package:abg_utils/abg_utils.dart';
import 'package:ondemand_admin/ui/strings.dart';

AppTheme theme = AppTheme(false);

Color colorBackground = Color(0xfffafafa); //Color(0xfff1f6fe);

var dashboardBlackColor = Color(0xff000050);
var dashboardColorForEdit = Color(0xff000060).withAlpha(40);
var dashboardErrorColor = Color(0xffff3030);

var dashboardColorCardGrey = Color(0xfff3f6f9);
var dashboardColorCardGreenGrey = Color(0xffddf1f3);
var dashboardColorCardDark = Color(0xff303030);

// bool demo = false;

class AppTheme implements DefaultTheme{

  @override
  Color blackColorTitleBkg = Color(0xff101010);

  @override
  bool darkMode = false;

  @override
  var mainColor = Color(0xff3699ff);

  String font = "Montserrat";
  @override
  double radius = 10;

  AppTheme(bool _dartMode){
    darkMode = _dartMode;
    mainColor = appSettings.adminPanelMainColor;
    backgroundColor = Colors.transparent;
    secondColor = Colors.transparent;
    //
    double _fontSizePlus = 0;
    double? _letterSpacing; // 0.6
    if (strings.locale == "ar") {
      font = "Harmattan";
      _fontSizePlus+=2;
      _letterSpacing = null;
    }

    //
    style10W400White = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 10+_fontSizePlus, fontWeight: FontWeight.w400, color: Colors.white);
    style10W800White = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 10+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style10W600Grey = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 10+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.grey);
    style10W400 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 10+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style11W600 = TextStyle(fontFamily: font, letterSpacing: 0.4,
        fontSize: 11+_fontSizePlus, fontWeight: FontWeight.w600, color: (darkMode) ? Colors.white : Colors.black);
    style11W800W = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 11+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style12W600Grey = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.grey);
    style12W600Orange = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.orange);
    style12W600White = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.white);
    style12W400 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style12W800 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style12W800MainColor = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w800, color: mainColor);
    style12W400D = TextStyle(fontFamily: font, letterSpacing: _letterSpacing, decoration: TextDecoration.lineThrough,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w400, color: Colors.grey);
    style12W800W = TextStyle(fontFamily: font, letterSpacing: 0.4,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style13W600Grey = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.grey);
    style13W800Green = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.green);
    style13W800Red = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.red);
    style13W400U = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w400,
        decoration: TextDecoration.lineThrough,
        color: (darkMode) ? Colors.white : Colors.black);
    style14W400U = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w400,
        decoration: TextDecoration.lineThrough,
        color: (darkMode) ? Colors.white : Colors.black);
    style13W400 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style13W800Blue = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.blue);
    style13W800 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style14W400 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style14W600 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w600, color: (darkMode) ? Colors.white : Colors.black);
    style14W800 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style14W800MainColor = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w800, color: mainColor);
    style14W600White = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.white);
    style14W600Grey = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.grey);
    style14W400Grey = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w400, color: Colors.grey);
    style16W800Black = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.black);
    style16W800 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style16W800Main = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: mainColor);
    style16W800White = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style16W800Green = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.green);
    style16W800Red = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.red);
    style16W800Orange = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.orange);
    style16W800Grey = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.grey);
    style16W400U = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w400,
        decoration: TextDecoration.lineThrough,
        color: (darkMode) ? Colors.white : Colors.black);
    style18W800Grey = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 18+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.grey);
    style18W800 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 18+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style20W800White = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 20+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style25W800 = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 25+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style30W800White = TextStyle(fontFamily: font, letterSpacing: _letterSpacing,
        fontSize: 30+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    aTheme = this;
  }

  @override
  late TextStyle style10W400White;
  @override
  late TextStyle style10W800White;
  @override
  late TextStyle style10W400;
  late TextStyle style10W600Grey;
  @override
  late TextStyle style11W800W;
  @override
  late TextStyle style11W600;
  @override
  late TextStyle style12W400;
  @override
  late TextStyle style12W800MainColor;
  @override
  late TextStyle style12W600Grey;
  @override
  late TextStyle style12W600Orange;
  @override
  late TextStyle style12W600White;
  @override
  late TextStyle style12W800W;
  @override
  late TextStyle style12W400D;
  @override
  late TextStyle style12W800;
  late TextStyle style13W600Grey;
  late TextStyle style13W800Green;
  @override
  late TextStyle style13W800;
  @override
  late TextStyle style13W800Red;
  @override
  late TextStyle style13W800Blue;
  @override
  late TextStyle style13W400;
  @override
  late TextStyle style14W400;
  late TextStyle style14W600;
  late TextStyle style14W400U;
  @override
  late TextStyle style14W600White;
  @override
  late TextStyle style14W800;
  @override
  late TextStyle style14W800MainColor;
  late TextStyle style14W600Grey;
  @override
  late TextStyle style14W400Grey;
  late TextStyle style16W800Black;
  @override
  late TextStyle style16W800;
  @override
  late TextStyle style16W800White;
  late TextStyle style16W800Main;
  @override
  late TextStyle style16W800Green;
  late TextStyle style16W800Red;
  @override
  late TextStyle style16W800Orange;
  late TextStyle style16W800Grey;
  late TextStyle style18W800;
  late TextStyle style18W800Grey;
  late TextStyle style20W800White;
  late TextStyle style25W800;
  @override
  late TextStyle style30W800White;

  @override
  late Color backgroundColor;

  @override
  late Color secondColor;

  @override
  late TextStyle style13W400U;

  @override
  late TextStyle style16W400U;
}
