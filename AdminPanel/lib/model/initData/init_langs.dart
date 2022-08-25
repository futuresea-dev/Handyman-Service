import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/initData/site_lang.dart';
import 'providerlang.dart';
import 'customer_lang.dart';

import '../../ui/strings.dart';
import 'admin_langs.dart';
//
// class LangData{
//   LangData({required this.name, required this.engName, required this.image,
//     required this.direction, required this.locale, required this.app, required this.data, required this.words});
//   String name;
//   String engName;
//   String image;
//   TextDirection direction;
//   String locale;
//   String app;
//   Map<int, String> data;
//   int words;
//
//   Map toJson() => {
//     'name' : name,
//     'engName' : engName,
//     'direction' : direction == TextDirection.ltr ? "ltr" : 'rtl',
//     'locale' : locale,
//     'app' : app,
//     'words' : words,
//   };
// }

Map<String, dynamic> _convert(Map<int, String> _source){
  Map<String, dynamic> _ret = {};
  _source.forEach((key, value) {
    _ret.addAll({key.toString() : value});
  });
  return _ret;
}

List<LangData> initialLangData = [
  LangData(name: "English", engName: "English", image: "", app: "service",
      direction: TextDirection.ltr, locale: "en", data: _convert(servicesEng), words: servicesEng.length),
  LangData(name: "Deutsh", engName: "German", image: "", app: "service",
      direction: TextDirection.ltr, locale: "de", data: _convert(servicesDeu), words: servicesDeu.length),
  LangData(name: "Spana", engName: "Spanish", image: "", app: "service",
      direction: TextDirection.ltr, locale: "es", data: _convert(servicesEsp), words: servicesEsp.length),
  LangData(name: "Français", engName: "French", image: "", app: "service",
      direction: TextDirection.ltr, locale: "fr", data: _convert(servicesFrench), words: servicesFrench.length),
  LangData(name: "عربى", engName: "Arabic", image: "", app: "service",
      direction: TextDirection.rtl, locale: "ar", data: _convert(servicesArabic), words: servicesArabic.length),
  LangData(name: "Português", engName: "Portuguese", image: "", app: "service",
      direction: TextDirection.ltr, locale: "pt", data: _convert(servicesPort), words: servicesPort.length),
  LangData(name: "Русский", engName: "Russian", image: "", app: "service",
      direction: TextDirection.ltr, locale: "ru", data: _convert(servicesRus), words: servicesRus.length),
  LangData(name: "हिंदी", engName: "Hindi", image: "", app: "service",
      direction: TextDirection.ltr, locale: "hi", data: _convert(servicesHindi), words: servicesHindi.length),

  LangData(name: "English", engName: "English", image: "", app: "provider",
      direction: TextDirection.ltr, locale: "en", data: _convert(providerEng), words: providerEng.length),
  LangData(name: "Deutsh", engName: "German", image: "", app: "provider",
      direction: TextDirection.ltr, locale: "de", data: _convert(providerDeu), words: providerDeu.length),
  LangData(name: "Spana", engName: "Spanish", image: "", app: "provider",
      direction: TextDirection.ltr, locale: "es", data: _convert(providerEsp), words: providerEsp.length),
  LangData(name: "Français", engName: "French", image: "", app: "provider",
      direction: TextDirection.ltr, locale: "fr", data: _convert(providerFrench), words: providerFrench.length),
  LangData(name: "عربى", engName: "Arabic", image: "", app: "provider",
      direction: TextDirection.rtl, locale: "ar", data: _convert(providerArabic), words: providerArabic.length),
  LangData(name: "Português", engName: "Portuguese", image: "", app: "provider",
      direction: TextDirection.ltr, locale: "pt", data: _convert(providerPort), words: providerPort.length),
  LangData(name: "Русский", engName: "Russian", image: "", app: "provider",
      direction: TextDirection.ltr, locale: "ru", data: _convert(providerRus), words: providerRus.length),
  LangData(name: "हिंदी", engName: "Hindi", image: "", app: "provider",
      direction: TextDirection.ltr, locale: "hi", data: _convert(providerHindi), words: providerHindi.length),

  LangData(name: "English", engName: "English", image: "", app: "admin",
      direction: TextDirection.ltr, locale: "en", data: _convert(strings.langEng), words: strings.langEng.length),
  LangData(name: "Deutsh", engName: "German", image: "", app: "admin",
      direction: TextDirection.ltr, locale: "de", data: _convert(adminDeu), words: adminDeu.length),
  LangData(name: "Spana", engName: "Spanish", image: "", app: "admin",
      direction: TextDirection.ltr, locale: "es", data: _convert(adminEsp), words: adminEsp.length),
  LangData(name: "Français", engName: "French", image: "", app: "admin",
      direction: TextDirection.ltr, locale: "fr", data: _convert(adminFrench), words: adminFrench.length),
  LangData(name: "عربى", engName: "Arabic", image: "", app: "admin",
      direction: TextDirection.rtl, locale: "ar", data: _convert(adminArabic), words: adminArabic.length),
  LangData(name: "Português", engName: "Portuguese", image: "", app: "admin",
      direction: TextDirection.ltr, locale: "pt", data: _convert(adminPort), words: adminPort.length),
  LangData(name: "Русский", engName: "Russian", image: "", app: "admin",
      direction: TextDirection.ltr, locale: "ru", data: _convert(adminRus), words: adminRus.length),
  LangData(name: "हिंदी", engName: "Hindi", image: "", app: "admin",
      direction: TextDirection.ltr, locale: "hi", data: _convert(adminHindi), words: adminHindi.length),

  LangData(name: "English", engName: "English", image: "", app: "site",
      direction: TextDirection.ltr, locale: "en", data: _convert(siteLangEng), words: siteLangEng.length),
  LangData(name: "Deutsh", engName: "German", image: "", app: "site",
      direction: TextDirection.ltr, locale: "de", data: _convert(siteLangDeu), words: siteLangDeu.length),
  LangData(name: "Spana", engName: "Spanish", image: "", app: "site",
      direction: TextDirection.ltr, locale: "es", data: _convert(siteLangEsp), words: siteLangEsp.length),
  LangData(name: "Français", engName: "French", image: "", app: "site",
      direction: TextDirection.ltr, locale: "fr", data: _convert(siteLangFrench), words: siteLangFrench.length),
  LangData(name: "عربى", engName: "Arabic", image: "", app: "site",
      direction: TextDirection.rtl, locale: "ar", data: _convert(siteLangArabic), words: siteLangArabic.length),
  LangData(name: "Português", engName: "Portuguese", image: "", app: "site",
      direction: TextDirection.ltr, locale: "pt", data: _convert(siteLangPort), words: siteLangPort.length),
  LangData(name: "Русский", engName: "Russian", image: "", app: "site",
      direction: TextDirection.ltr, locale: "ru", data: _convert(siteLangRus), words: siteLangRus.length),
  LangData(name: "हिंदी", engName: "Hindi", image: "", app: "site",
      direction: TextDirection.ltr, locale: "hi", data: _convert(siteLangHindi), words: siteLangHindi.length),

];

