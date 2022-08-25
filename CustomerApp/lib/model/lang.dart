import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

import '../ui/strings.dart';
import 'model.dart';

class MainDataLang {
  final MainModel parent;

  MainDataLang({required this.parent});

  setLang(String value, BuildContext context) async {
    localSettings.setLocal(value);
    //
    appSettings.currentServiceAppLanguage = value;
    for (var item in parent.appLangs){
      if (localSettings.locale.isNotEmpty){
        if (localSettings.locale == item.locale)
          strings.setLang(item.data, item.locale, context, item.direction);
      }else
      if (appSettings.currentServiceAppLanguage == item.locale)
        strings.setLang(item.data, item.locale, context, item.direction);
    }
    await saveSettingsToLocalFile(appSettings);
  }

}
