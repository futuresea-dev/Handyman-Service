import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/strings.dart';
import 'model.dart';

class MainDataLang {
  final MainModel parent;

  MainDataLang({required this.parent});

  // Future<String?> loadLangsFromLocal(BuildContext context) async {
  //
  //   try{
  //     var directory = await getApplicationDocumentsDirectory();
  //     var directoryPath = directory.path;
  //     var _file = File('$directoryPath/listlangs.json');
  //     if (!await _file.exists())
  //       return null;
  //     final contents = await _file.readAsString();
  //     var data = json.decode(contents);
  //     dprint("_loadLangsFromLocal $data");
  //     parent.appLangs = data.map((f) => LangData.fromJson(f)).cast<LangData>().toList();
  //     dprint("_loadLangsFromLocal appLangs ${parent.appLangs}");
  //     for (var item in parent.appLangs){
  //       var _doc = "${item.app}_${item.locale}";
  //       var _file = File('$directoryPath/$_doc.json');
  //       if (!await _file.exists())
  //         return null;
  //       final contents = await _file.readAsString();
  //       dprint('read local lang $directoryPath/$_doc.json');
  //       item.data = json.decode(contents);
  //       if (localSettings.locale.isNotEmpty){
  //         if (localSettings.locale == item.locale)
  //           strings.setLang(item.data, item.locale, context, item.direction);
  //       }else
  //       if (appSettings.currentServiceAppLanguage == item.locale)
  //         strings.setLang(item.data, item.locale, context, item.direction);
  //     }
  //   }catch(ex){
  //     return "model loadLangsFromLocal " + ex.toString();
  //   }
  //   return null;
  // }

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

