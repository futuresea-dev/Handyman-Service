import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:abg_utils/abg_utils.dart';
import '../ui/strings.dart';
import 'model.dart';

class MainDataLang {
  final MainModel parent;

  List<LangData> appLangs = [];
  String currentLang = "";

  MainDataLang({required this.parent});

  Future<String?> load(BuildContext context) async {
    var querySnapshot = await FirebaseFirestore.instance.collection("language").doc("langs").get();
    var data = querySnapshot.data();
    if (data == null)
      return "load language data = null";
    if (data['list'] == null)
      return "load language list = null";

    var element = data['list'];
    appLangs = [];
    element.forEach((element) {
      if (element["app"] == "service")
        appLangs.add(LangData(name: element["name"], engName: element["engName"], image: "", app: "site",
            direction: element["direction"] == "ltr" ? TextDirection.ltr : TextDirection.rtl, locale: element["locale"],
            data: {}),);
    });

    currentLang = pref.get("defLang");
    var _locale = "en";
    if (appSettings.defaultSiteAppLanguage.isNotEmpty)
      _locale = appSettings.defaultSiteAppLanguage;
    if (currentLang.isNotEmpty)
      _locale = currentLang;
    //
    // get languages
    //
    for (var item in appLangs){
      var _doc = "${item.app}_${item.locale}";
      var querySnapshot = await FirebaseFirestore.instance.collection("language").doc(_doc).get();
      var data = querySnapshot.data();
      if (data != null) {
        Map<String, dynamic> _words = data['data'];
        _words.forEach((key, value) {
          item.data.addAll({key : value});
        });

        if (item.locale == _locale)
          strings.setLang(item.data, item.locale, context, item.direction);
      }
    }
    return null;
  }

  String getCurrentLanguageName(){
    var _locale = "en";
    if (appSettings.defaultSiteAppLanguage.isNotEmpty)
      _locale = appSettings.defaultSiteAppLanguage;
    if (currentLang.isNotEmpty)
      _locale = currentLang;
    for (var item in appLangs)
      if (item.locale == _locale)
        return item.name;
      return "";
  }

  setAppLang(String _locale, BuildContext context){
    pref.set("defLang", _locale);
    currentLang = _locale;
    for (var item in appLangs)
      if (item.locale == _locale)
        strings.setLang(item.data, item.locale, context, item.direction);
    parent.redraw();
  }
}