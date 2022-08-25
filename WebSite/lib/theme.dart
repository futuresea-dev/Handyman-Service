import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/strings.dart';

AppTheme theme = AppTheme();

var errorColor = Color(0xffff3030);

getBkgColor() => theme.darkMode ? Colors.black : Colors.white;

class AppTheme implements DefaultTheme{

  @override
  bool darkMode = false;

  @override
  Color mainColor = Color(0xff69c4ff);

  @override
  double radius = 8;

  @override
  Color blackColorTitleBkg = Color(0xff202020);

  Color categoryStarColor = Color(0xFFFFA726);
  Color categoryBoardColor = Color(0xFF66BB6A);
  Color serviceStarColor = Color(0xFFFFA726);
  Color booking1CheckBoxColor = Color(0xFFFFA726);
  Color booking4CheckBoxColor = Color(0xFFFFA726);

  AppTheme(){
    mainColor = appSettings.websiteMainColor;
    //
    double _fontSizePlus = 0;
    // double? _letterSpacing = 0.6;
    if (strings.locale == "ar") {
      _font = "Harmattan";
      _fontSizePlus+=2;
      // _letterSpacing = null;
    }
    //
    final double? _letterSpacing = null;

    style10W400White = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 10+_fontSizePlus, fontWeight: FontWeight.w400, color: Colors.white);
    style10W400 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 10+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style10W800White = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 10+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style10W600Grey = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 10+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.grey);
    style11W800W = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 11+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style11W600 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 11+_fontSizePlus, fontWeight: FontWeight.w600, color: (darkMode) ? Colors.white : Colors.black);
    style12W600Red = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.red);
    style12W400 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style12W800MainColor = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w800, color: mainColor);
    style12W600StarsCategory = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: categoryStarColor);
    style12W600StarsService = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: serviceStarColor);
    style12W800 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style12W400D = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing, decoration: TextDecoration.lineThrough,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w400, color: Colors.grey);
    style12W600Grey = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.grey);
    style12W600Blue = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.blue);
    style12W600Orange = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.orange);
    style12W600White = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.white);
    style12W800W = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 12+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style13W400 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style13W800Blue = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.blue);
    style13W800 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style14W400 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style14W600 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w600, color: (darkMode) ? Colors.white : Colors.black);
    style14W800 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style14W800MainColor = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w800, color: mainColor);
    style13W800Red = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 13+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.red);
    style14W400Grey = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w400, color: Colors.grey);
    style14W800W = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style14W600White = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.white);
    style14W600Grey = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 14+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.grey);
    style15W400 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 15+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style16W800White = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.white);
    style16W800Orange = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.orange);
    style16W800Blue = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.blue);
    style16W600Grey = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w600, color: Colors.grey);
    style16W800Green = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.green);
    style16W400 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w400, color: (darkMode) ? Colors.white : Colors.black);
    style16W800 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style16W400U = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 16+_fontSizePlus, fontWeight: FontWeight.w400,
        decoration: TextDecoration.lineThrough,
        color: (darkMode) ? Colors.white : Colors.black);
    style18W800 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 18+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style18W800Grey = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 18+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.grey);
    style18W400White = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 18+_fontSizePlus, fontWeight: FontWeight.w400, color: Colors.white);
    style20W800Green = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 20+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.green);
    style20W800Red = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 20+_fontSizePlus, fontWeight: FontWeight.w800, color: Colors.red);
    style20W800 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 20+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    style25W800 = TextStyle(fontFamily: _font, letterSpacing: _letterSpacing,
        fontSize: 25+_fontSizePlus, fontWeight: FontWeight.w800, color: (darkMode) ? Colors.white : Colors.black);
    aTheme = this;
  }

  String _font = "Montserrat";

  @override
  late TextStyle style10W400White;
  @override
  late TextStyle style10W400;
  @override
  late TextStyle style10W800White;
  late TextStyle style10W600Grey; 
  @override
  late TextStyle style11W800W;
  @override
  late TextStyle style11W600;
  @override
  late TextStyle style12W400;
  @override
  late TextStyle style12W800MainColor;
  late TextStyle style12W600StarsCategory;
  late TextStyle style12W600StarsService;
  @override
  late TextStyle style12W800;
  @override
  late TextStyle style12W400D;
  @override
  late TextStyle style12W600Grey;
  late TextStyle style12W600Blue; 
  @override
  late TextStyle style12W600Orange; 
  @override
  late TextStyle style12W600White;
  @override
  late TextStyle style12W800W;
  late TextStyle style12W600Red;
  @override
  late TextStyle style13W400;
  @override
  late TextStyle style13W800;
  @override
  late TextStyle style13W800Blue;
  @override
  late TextStyle style13W800Red;
  @override
  late TextStyle style14W400Grey;
  late TextStyle style14W800W; 
  @override
  late TextStyle style14W400;
  late TextStyle style14W600;
  @override
  late TextStyle style14W600White;
  @override
  late TextStyle style14W800;
  @override
  late TextStyle style14W800MainColor;
  late TextStyle style14W600Grey;
  late TextStyle style15W400;
  late TextStyle style16W400;
  @override
  late TextStyle style16W800Green;
  @override
  late TextStyle style16W800;
  @override
  late TextStyle style16W800White; 
  @override
  late TextStyle style16W400U;
  @override
  late TextStyle style16W800Orange;
  late TextStyle style16W800Blue;
  late TextStyle style16W600Grey;
  late TextStyle style18W800;
  late TextStyle style18W800Grey;
  late TextStyle style18W400White; 
  late TextStyle style20W800;
  late TextStyle style20W800Green;
  late TextStyle style20W800Red; 
  late TextStyle style25W800;

  @override
  late Color backgroundColor;

  @override
  late Color secondColor;

  @override
  late TextStyle style13W400U;

  @override
  late TextStyle style30W800White;


}
