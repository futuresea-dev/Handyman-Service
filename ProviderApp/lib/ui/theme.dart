import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

AppTheme theme = AppTheme(false);
late Decoration decor;

class AppTheme implements DefaultTheme{

  @override
  bool darkMode = false;

  @override
  late Color mainColor;

  @override
  Color blackColorTitleBkg = Color(0xff101010);

  Color colorBackground = Color(0xfff1f6fe);
  var cardGreenGrey = Color(0xffddf1f3);

  AppTheme(bool _dartMode, {
    this.colorBackground = const Color(0xfff1f6fe),
    this.blackColorTitleBkg = const Color(0xff101010),
  }){
    darkMode = _dartMode;
    mainColor = localSettings.mainColor;
    style10W800White = TextStyle(fontFamily: _font, letterSpacing: 0.4,
        fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white);
    style10W400White = TextStyle(fontFamily: _font, letterSpacing: 0.4,
        fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white);
    style10W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 10, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style11W600 = TextStyle(fontFamily: _font, letterSpacing: 0.4,
        fontSize: 11, fontWeight: FontWeight.w600, color: (darkMode) ? Colors.white : Colors.black);
    style12W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 12, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style12W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 12, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style12W400D = TextStyle(fontFamily: _font, letterSpacing: 0.4, decoration: TextDecoration.lineThrough,
        fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey);
    style12W600Stars = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange);
    style12W600StarsCategory = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange);
    style12W800MainColor = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 12, fontWeight: FontWeight.w800, color: mainColor);
    style12W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 12, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style13W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 13, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style13W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 13, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style14W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 14, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style14W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 14, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style14W400U = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 14, fontWeight: FontWeight.w400,
        decoration: TextDecoration.lineThrough,
        color: (darkMode) ? Colors.white : Colors.black);
    style14W800MainColor = TextStyle(fontFamily: _font, letterSpacing: 0.4,
        fontSize: 14, fontWeight: FontWeight.w800, color: mainColor);
    style14W600White = TextStyle(fontFamily: _font, letterSpacing: 0.4,
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white);
    style15W400 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 15, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style16W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 16, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style18W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 18, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style20W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 20, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style25W800 = TextStyle(fontFamily: _font, letterSpacing: 0.6,
        fontSize: 25, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);

    decor = BoxDecoration(
      color: (darkMode) ? blackColorTitleBkg: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.grey.withAlpha(20)),
    );

    aTheme = this;
  }

  static final String _font = "Montserrat";
  @override
  double radius = 10;

  @override
  late TextStyle style11W600;
  late TextStyle style12W600Stars;
  @override
  late TextStyle style10W400;

  @override
  late TextStyle style10W400White;
  @override
  late TextStyle style10W800White;
  TextStyle style10W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey);
  TextStyle style10W600White = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white);

  TextStyle style11W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.4,
      fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey);

  @override
  TextStyle style11W800W = TextStyle(fontFamily: _font, letterSpacing: 0.4,
      fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white);

  @override
  late TextStyle style12W400;

  @override
  late TextStyle style12W800MainColor;

  @override
  TextStyle style12W800W = TextStyle(fontFamily: _font, letterSpacing: 0.4,
      fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white);

  @override
  TextStyle style12W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey);

  @override
  late TextStyle style12W400D;
  TextStyle style12W600Blue = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue);

  @override
  late TextStyle style12W800;

  @override
  TextStyle style12W600White = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white);

  @override
  TextStyle style12W600Orange = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange);

  late TextStyle style12W600StarsCategory;

  @override
  TextStyle style13W800Blue = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 13, fontWeight: FontWeight.w800, color: Colors.blue);

  TextStyle style13W800Green = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 13, fontWeight: FontWeight.w800, color: Colors.green);

  @override
  TextStyle style13W800Red = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 13, fontWeight: FontWeight.w800, color: Colors.red);

  @override
  late TextStyle style13W800;
  @override
  late TextStyle style13W400;

  @override
  TextStyle style14W400Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey);

  @override
  late TextStyle style14W600White;

  @override
  late TextStyle style14W800;
  @override
  late TextStyle style14W400;
  @override
  late TextStyle style14W800MainColor;

  TextStyle style14W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey);

  late TextStyle style14W400U;
  late TextStyle style15W400;
  @override
  late TextStyle style16W800;

  @override
  TextStyle style16W800White = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white);

  @override
  TextStyle style16W800Green = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.green);

  TextStyle style16W800Red = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.red);

  @override
  TextStyle style16W800Orange = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.orange);

  TextStyle style16W800Blue = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.blue);

  TextStyle style16W600Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey);

  TextStyle style16W800Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey);

  late TextStyle style18W800;

  TextStyle style18W800Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 18, fontWeight: FontWeight.w800, color: Colors.grey);

  late TextStyle style20W800;

  TextStyle style20W800Grey = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 20, fontWeight: FontWeight.w800, color: Colors.grey);

  late TextStyle style25W800;

  TextStyle style18W800Orange = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 18, fontWeight: FontWeight.w800, color: Colors.orange);

  @override
  TextStyle style30W800White = TextStyle(fontFamily: _font, letterSpacing: 0.6,
      fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white);

  @override
  late Color backgroundColor;

  @override
  late Color secondColor;

  @override
  late TextStyle style13W400U;

  @override
  late TextStyle style16W400U;

}
