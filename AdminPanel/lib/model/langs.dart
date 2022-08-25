import 'package:firebase_auth/firebase_auth.dart';
import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/theme.dart';

import '../ui/strings.dart';
import 'model.dart';
import 'initData/init_langs.dart';

class LangField{
  final String id;
  String word;
  var controller = TextEditingController();

  LangField(this.id, this.word);
}

class MainDataModelLangs{

  final MainModel parent;

  MainDataModelLangs({required this.parent});

  Future<String?> languagesCreate(Function(String) _callback) async {
    try{
      _callback(strings.get(205)); /// "Installation languages ...",
      double percentage = 0;
      var oneStep = 100/initialLangData.length;
      for (var item in initialLangData){
        var _doc = "${item.app}_${item.locale}";

        Map<String, dynamic> _yourDocument = {};
        item.data.forEach((key, value) {
          _yourDocument.addAll({key.toString(): value});
        });
        if (_yourDocument.length != item.words){
          for (var item2 in initialLangData)
            if (item2.locale == "en" && item2.app == item.app){
              var index = 0;
              item2.data.forEach((key, value) {
                if (index >= _yourDocument.length)
                  _yourDocument.addAll({key.toString(): value});
                index++;
              });
              // var _t = _yourDocument.length;
              // _yourDocument.addAll({_t.toString(): value});
            }
        }
        var _data = {
          'ver': 1,
          "data" : _yourDocument
        };
        await FirebaseFirestore.instance.collection("language").doc(_doc).set(_data, SetOptions(merge:true));
        percentage += oneStep;
        _callback("${strings.get(205)} ${percentage.toStringAsFixed(0)}%"); /// "Installation languages ...",
      }
      var _data = {
        'ver': 1,
        'update': 1,
        'list': initialLangData.map((i) => i.toJson()).toList()
      };
      await FirebaseFirestore.instance.collection("language").doc("langs").set(_data, SetOptions(merge:true));
    }catch(ex){
      return ex.toString();
    }
    return null;
  }

  loadLanguage(LangData element) async {
    var _doc = "${element.app}_${element.locale}";
    var querySnapshot = await FirebaseFirestore.instance.collection("language").doc(_doc).get();
    var data = querySnapshot.data();
    if (data != null) {
      Map<String, dynamic> _words = data['data'];
      _words.forEach((key, value) {
        if (value != null)
          element.data.addAll({key: value});
      });
    }
  }

  installSiteLang() async {
    for (var item in initialLangData){
      if (item.app != "site")
        continue;

      var _doc = "${item.app}_${item.locale}";
      Map<String, dynamic> _yourDocument = {};
      item.data.forEach((key, value) {
        _yourDocument.addAll({key.toString(): value});
      });

      var _data = {
        'ver': 1,
        "data" : _yourDocument
      };
      await FirebaseFirestore.instance.collection("language").doc(_doc).set(_data, SetOptions(merge:true));
      _data = {
        'list': initialLangData.map((i) => i.toJson()).toList()
      };
      await FirebaseFirestore.instance.collection("language").doc("langs").set(_data, SetOptions(merge:true));
    }
  }

  bool _siteFound = false;

  Future<String?> updateLanguages(Function(String) _callback) async {
    try{
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("language").get();
      double percentage = 0;
      _callback(strings.get(319)); /// "Update  languages ...",
      var oneStep = 100/(querySnapshot.docs.length);
      for (QueryDocumentSnapshot item in querySnapshot.docs){
        if (item.id.startsWith("site"))
          _siteFound = true;
        var name = item.id.substring(item.id.length-2);
        var _found = false;
        for (var lang in initialLangData){
          if (lang.app == item.id.substring(0, item.id.length-3) && name == lang.locale){
            var ret = await saveUpdatedLang(lang, item, item.id);
            if (ret != null)
              return ret;
            percentage += oneStep;
            _found = true;
            _callback(strings.get(319) + "${percentage.toInt()}%"); /// "Update  languages ...",
          }
        }
        if (!_found && item.id != "langs"){
          name = "en";
          for (var lang in initialLangData){
            if (lang.app == item.id.substring(0, item.id.length-3) && name == lang.locale){
              var ret = await saveUpdatedLang(lang, item, item.id);
              if (ret != null)
                return ret;
              percentage += oneStep;
              _found = true;
              _callback(strings.get(319) + "${percentage.toInt()}%"); /// "Update  languages ...",
            }
          }
        }
      }
      if (!_siteFound)
        installSiteLang();
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"langVersion": strings.languageVersion}, SetOptions(merge:true));
      await FirebaseFirestore.instance.collection("language").doc("langs")
          .set({"ver": FieldValue.increment(1)}, SetOptions(merge:true));
    }catch(ex){
      return ex.toString();
    }
    return null;
  }

  bool needUpdate = false;

  Future<String?> languages(Function(String) _callback, BuildContext context) async {
    try{
      var querySnapshot = await FirebaseFirestore.instance.collection("language").doc("langs").get();
      var data = querySnapshot.data();
      User? user = FirebaseAuth.instance.currentUser;
      if (data == null) {
        if (user == null){
          needUpdate = true;
          return null;
        }else{
          var ret = await languagesCreate(_callback);
          if (ret != null)
            return ret;
          querySnapshot = await FirebaseFirestore.instance.collection("language").doc("langs").get();
          data = querySnapshot.data();
          if (data == null)
            return strings.get(201); /// "Can't initialize language data",
        }
      }else{
        //
        // update
        //
        if (appSettings.langVersion < strings.languageVersion){
          if (user != null) {
            var ret = await updateLanguages(_callback);
            if (ret != null)
              return ret;
          }else
            needUpdate = true;
          // load langs data again
          querySnapshot = await FirebaseFirestore.instance.collection("language").doc("langs").get();
          data = querySnapshot.data();
          if (data == null)
            return strings.get(201); /// "Can't initialize language data",
        }
      }

      _callback(strings.get(204)); /// "Loading languages ...",
      // print("MainDataModel _languages $data");
      double percentage = 0;

      if (data['list'] != null) {
        parent.siteAppLangs = [];
        parent.serviceAppLangs = [];
        parent.providerAppLangs = [];
        parent.adminAppLangs = [];
        var element = data['list'];
        element.forEach((element) {
          if (element["app"] == "service")
            parent.serviceAppLangs.add(LangData(name: element["name"], engName: element["engName"], image: "", app: "service",
                direction: element["direction"] == "ltr" ? TextDirection.ltr : TextDirection.rtl, locale: element["locale"],
                data: {}, words: element["words"]), );
          if (element["app"] == "provider")
            parent.providerAppLangs.add(LangData(name: element["name"], engName: element["engName"], image: "", app: "provider",
                direction: element["direction"] == "ltr" ? TextDirection.ltr : TextDirection.rtl, locale: element["locale"],
                data: {}, words: element["words"]),);
          if (element["app"] == "admin")
            parent.adminAppLangs.add(LangData(name: element["name"], engName: element["engName"], image: "", app: "admin",
                direction: element["direction"] == "ltr" ? TextDirection.ltr : TextDirection.rtl, locale: element["locale"],
                data: {}, words: element["words"]),);
          if (element["app"] == "site")
            parent.siteAppLangs.add(LangData(name: element["name"], engName: element["engName"], image: "", app: "site",
                direction: element["direction"] == "ltr" ? TextDirection.ltr : TextDirection.rtl, locale: element["locale"],
                data: {}, words: element["words"]),);
        });
      }

      var oneStep = 25;

      for (var element in parent.serviceAppLangs)
        if (element.locale == appSettings.defaultServiceAppLanguage){
          await loadLanguage(element);
          percentage += oneStep;
          _callback("${strings.get(206)} ${percentage.toStringAsFixed(0)}%"); /// "Read languages ...",
        }

      for (var element in parent.providerAppLangs)
        if (element.locale == appSettings.defaultProviderAppLanguage){
          await loadLanguage(element);
          percentage += oneStep;
          _callback("${strings.get(206)} ${percentage.toStringAsFixed(0)}%"); /// "Read languages ...",
        }

      for (var element in parent.adminAppLangs)
        if (element.locale == appSettings.currentAdminLanguage){
          await loadLanguage(element);
          percentage += oneStep;
          _callback("${strings.get(206)} ${percentage.toStringAsFixed(0)}%"); /// "Read languages ...",
          strings.setLang(appSettings.currentAdminLanguage, element.data, context, element.direction); // set admin panel lang
          theme = AppTheme(theme.darkMode);
        }

      for (var element in parent.siteAppLangs)
        if (element.locale == parent.currentSiteLanguage){
          await loadLanguage(element);
          percentage += oneStep;
          _callback("${strings.get(206)} ${percentage.toStringAsFixed(0)}%"); /// "Read languages ...",
        }

      await setLang(parent.editLangNowDataComboValue);
      initLang();
    }catch(ex){
      return "languages " + ex.toString();
    }
    return null;
  }

  setAdminLang(String value, BuildContext context) async {
    appSettings.currentAdminLanguage = value;
    for (var item in parent.adminAppLangs)
      if (item.locale == value) {
        if (item.data.isEmpty)
          await loadLanguage(item);
        strings.setLang(appSettings.currentAdminLanguage, item.data, context, item.direction); // set admin panel lang
        theme = AppTheme(theme.darkMode);
      }
    var _data = {
      "currentAdminLanguage": appSettings.currentAdminLanguage,
    };
    try{
      await FirebaseFirestore.instance.collection("settings").doc("main").set(_data, SetOptions(merge:true));
    }catch(ex){
      return ex.toString();
    }
  }

  setLang(String val) async{
    parent.listWordsForEdit = [];
    parent.editLangNowDataComboValue = val;
    List<LangData> _data = [];
    if (parent.appsDataComboValue == "service")
      _data = parent.serviceAppLangs;
    if (parent.appsDataComboValue == "provider")
      _data = parent.providerAppLangs;
    if (parent.appsDataComboValue == "admin")
      _data = parent.adminAppLangs;
    if (parent.appsDataComboValue == "site")
      _data = parent.siteAppLangs;

    for (var item in _data)
      if (item.locale == val) {
        if (item.data.isEmpty)
          await loadLanguage(item);
        item.data.forEach((key, value) {
          var lang = LangField(key, value);
          lang.controller.text = value;
          parent.listWordsForEdit.add(lang);
        });
      }
  }

  initLang(){
    parent.langDataCombo = [];
    if (parent.appsDataComboValue == "service"){
      for (var item in parent.serviceAppLangs) {
        var _name = item.name;
        if (appSettings.defaultServiceAppLanguage == item.locale)
          _name = "$_name - ${strings.get(132)}";                   /// "default",
        parent.langDataCombo.add(ComboData(_name, item.locale));
      }
    }
    if (parent.appsDataComboValue == "provider"){
      for (var item in parent.providerAppLangs) {
        var _name = item.name;
        if (appSettings.defaultProviderAppLanguage == item.locale)
          _name = "$_name - ${strings.get(132)}";                   /// "default",
        parent.langDataCombo.add(ComboData(_name, item.locale));
      }
    }
    if (parent.appsDataComboValue == "admin"){
      for (var item in parent.adminAppLangs) {
        var _name = item.name;
        if (appSettings.defaultAdminAppLanguage == item.locale)
          _name = "$_name - ${strings.get(132)}";                   /// "default",
        parent.langDataCombo.add(ComboData(_name, item.locale));
      }
    }
    if (parent.appsDataComboValue == "site"){
      for (var item in parent.siteAppLangs) {
        var _name = item.name;
        if (appSettings.defaultSiteAppLanguage == item.locale)
          _name = "$_name - ${strings.get(132)}";                   /// "default",
        parent.langDataCombo.add(ComboData(_name, item.locale));
      }
    }
    //
    parent.adminDataCombo = [];
    for (var item in parent.adminAppLangs)
      parent.adminDataCombo.add(ComboData(item.name, item.locale));
    parent.emulatorServiceDataCombo = [];
    for (var item in parent.serviceAppLangs)
      parent.emulatorServiceDataCombo.add(ComboData(item.name, item.locale));
    parent.emulatorProviderDataCombo = [];
    for (var item in parent.providerAppLangs)
      parent.emulatorProviderDataCombo.add(ComboData(item.name, item.locale));
  }

  saveWord(String id, String word){
    if (parent.appsDataComboValue == "service") {
      for (var item in parent.serviceAppLangs)
        if (item.locale == parent.editLangNowDataComboValue)
          item.data[id] = word;
    }
    if (parent.appsDataComboValue == "provider") {
      for (var item in parent.providerAppLangs)
        if (item.locale == parent.editLangNowDataComboValue)
          item.data[id] = word;
    }
    if (parent.appsDataComboValue == "admin") {
      for (var item in parent.adminAppLangs)
        if (item.locale == parent.editLangNowDataComboValue)
          item.data[id] = word;
    }
    if (parent.appsDataComboValue == "site") {
      for (var item in parent.siteAppLangs)
        if (item.locale == parent.editLangNowDataComboValue)
          item.data[id] = word;
    }
  }

  setApp(String val) async {
    parent.appsDataComboValue = val;
    if (parent.appsDataComboValue == "service")
      await setLang(appSettings.defaultServiceAppLanguage);
    if (parent.appsDataComboValue == "provider")
      await setLang(appSettings.defaultProviderAppLanguage);
    if (parent.appsDataComboValue == "admin")
      await setLang(appSettings.defaultAdminAppLanguage);
    if (parent.appsDataComboValue == "site")
      await setLang(appSettings.defaultSiteAppLanguage);
    initLang();
    parent.notify();
  }

  getDefaultLangByApp(){
    if (parent.appsDataComboValue == "service")
      return appSettings.defaultServiceAppLanguage;
    if (parent.appsDataComboValue == "provider")
      return appSettings.defaultProviderAppLanguage;
    if (parent.appsDataComboValue == "site") {
      var lang = appSettings.defaultSiteAppLanguage;
      if (parent.langDataCombo.isNotEmpty) {
        var _found = false;
        for (var item in parent.langDataCombo)
          if (item.id == lang)
            _found = true;
        if (!_found)
          lang = parent.langDataCombo[0].id;
      }
      return lang;
    }
    return appSettings.defaultAdminAppLanguage;
  }

  setDefaultLangByApp(String val) {
    if (parent.appsDataComboValue == "service") {
      appSettings.defaultServiceAppLanguage = val;
      parent.langEditDataComboValue = val;
    }
    if (parent.appsDataComboValue == "site")
      appSettings.defaultSiteAppLanguage = val;
    if (parent.appsDataComboValue == "provider")
      appSettings.defaultProviderAppLanguage = val;
    if (parent.appsDataComboValue == "admin")
      appSettings.defaultAdminAppLanguage = val;
    _saveDefaultLangByApp();
    initLang();
    parent.notify();
  }

  _saveDefaultLangByApp() async {
    try{
      var _data = {
        "defaultServiceAppLanguage" : appSettings.defaultServiceAppLanguage,
        "defaultProviderAppLanguage" : appSettings.defaultProviderAppLanguage,
        "defaultSiteAppLanguage" : appSettings.defaultSiteAppLanguage,
      };
      await FirebaseFirestore.instance.collection("settings").doc("main").set(_data, SetOptions(merge:true));
    }catch(ex){
      return ex.toString();
    }
  }

  saveLanguageWords() async {
    try{
      List<LangData> current = [];

      if (parent.appsDataComboValue == "service")
        current = parent.serviceAppLangs;
      if (parent.appsDataComboValue == "provider")
        current = parent.providerAppLangs;
      if (parent.appsDataComboValue == "admin")
        current = parent.adminAppLangs;
      if (parent.appsDataComboValue == "site")
        current = parent.siteAppLangs;

      for (var item in current){
        if (item.app == parent.appsDataComboValue && item.locale == parent.editLangNowDataComboValue){
          var _doc = "${item.app}_${item.locale}";

          Map<String, dynamic> _yourDocument = {};
          item.data.forEach((key, value) {
            _yourDocument.addAll({key.toString(): value});
          });
          var _data = {
            "data" : _yourDocument
          };
          await FirebaseFirestore.instance.collection("language").doc(_doc).set(_data, SetOptions(merge:true));
          await FirebaseFirestore.instance.collection("language").doc("langs")
              .set({"ver": FieldValue.increment(1)}, SetOptions(merge:true));
        }
      }
    }catch(ex){
      return ex.toString();
    }
    return null;
  }

  String newLandValue = "";
  List<ComboData> _newLangsDataComboLocal = [];

  List<ComboData> getNewLangList(){
    _newLangsDataComboLocal = [];

    bool _found = false;
    _newLangsDataComboLocal.addAll(newLangsDataCombo);
    for (var item in parent.langDataCombo)
      _newLangsDataComboLocal.removeWhere((element) {
        if (element.id == item.id)
          return true;
        return false;
      });

    for (var item in _newLangsDataComboLocal)
      if (item.id == newLandValue)
        _found = true;

    if (!_found)
      newLandValue = "";

    if (_newLangsDataComboLocal.isNotEmpty && newLandValue.isEmpty)
      newLandValue = _newLangsDataComboLocal[0].id;

    return _newLangsDataComboLocal;
  }

  createNewLanguage() async {
    try{
      var _name = "";
      for (var item in _newLangsDataComboLocal)
        if (item.id == newLandValue)
          _name = item.text;
      Map<String, dynamic> _yourDocument = {};
      //
      var _doc = "";
      if (parent.appsDataComboValue == "service"){
        int words = 1;
        if (parent.serviceAppLangs.isNotEmpty)
          words = parent.serviceAppLangs[0].words;
        parent.serviceAppLangs.add(LangData(name: _name, engName: _name, image: "", app: "service",
            direction: TextDirection.ltr, locale: newLandValue,
            data: {}, words: words), );
        // save
        _doc = "${parent.appsDataComboValue}_$newLandValue";
        //Map<String, dynamic> _yourDocument = {};
        for (var lng in parent.serviceAppLangs)
          if (lng.locale == "en") {
            if (lng.data.isEmpty)
              await loadLanguage(lng);
            lng.data.forEach((key, value) {
              _yourDocument.addAll({key.toString(): value});
            });
          }
      }
      if (parent.appsDataComboValue == "provider"){
        int words = 1;
        if (parent.providerAppLangs.isNotEmpty)
          words = parent.providerAppLangs[0].words;
        parent.providerAppLangs.add(LangData(name: _name, engName: _name, image: "", app: "provider",
            direction: TextDirection.ltr, locale: newLandValue,
            data: {}, words: words), );
        // save
        _doc = "${parent.appsDataComboValue}_$newLandValue";
        for (var lng in parent.providerAppLangs)
          if (lng.locale == "en") {
            if (lng.data.isEmpty)
              await loadLanguage(lng);
            lng.data.forEach((key, value) {
              _yourDocument.addAll({key.toString(): value});
            });
          }
      }
      if (parent.appsDataComboValue == "admin"){
        int words = 1;
        if (parent.adminAppLangs.isNotEmpty)
          words = parent.adminAppLangs[0].words;
        parent.adminAppLangs.add(LangData(name: _name, engName: _name, image: "", app: "admin",
            direction: TextDirection.ltr, locale: newLandValue,
            data: {}, words: words), );
        // save
        _doc = "${parent.appsDataComboValue}_$newLandValue";
        for (var lng in parent.adminAppLangs)
          if (lng.locale == "en") {
            if (lng.data.isEmpty)
              await loadLanguage(lng);
            lng.data.forEach((key, value) {
              _yourDocument.addAll({key.toString(): value});
            });
          }
      }
      if (parent.appsDataComboValue == "site"){
        int words = 1;
        if (parent.siteAppLangs.isNotEmpty)
          words = parent.siteAppLangs[0].words;
        parent.siteAppLangs.add(LangData(name: _name, engName: _name, image: "", app: "site",
            direction: TextDirection.ltr, locale: newLandValue,
            data: {}, words: words), );
        // save
        _doc = "${parent.appsDataComboValue}_$newLandValue";
        for (var lng in parent.siteAppLangs)
          if (lng.locale == "en") {
            if (lng.data.isEmpty)
              await loadLanguage(lng);
            lng.data.forEach((key, value) {
              _yourDocument.addAll({key.toString(): value});
            });
          }
      }
      var _data = {
        'ver': 1,
        "data" : _yourDocument
      };
      await FirebaseFirestore.instance.collection("language").doc(_doc).set(_data, SetOptions(merge:true));
      List<LangData> _initialLangData = [];
      _initialLangData.addAll(parent.serviceAppLangs);
      _initialLangData.addAll(parent.providerAppLangs);
      _initialLangData.addAll(parent.adminAppLangs);
      _initialLangData.addAll(parent.siteAppLangs);
      var _data2 = {
        'list': _initialLangData.map((i) => i.toJson()).toList()
      };
      await FirebaseFirestore.instance.collection("language").doc("langs").set(_data2, SetOptions(merge:true));
      await FirebaseFirestore.instance.collection("language").doc("langs")
          .set({"ver": FieldValue.increment(1)}, SetOptions(merge:true));
      parent.editLangNowDataComboValue = newLandValue;
      await parent.setLang(newLandValue);
      await parent.langs.setApp(parent.appsDataComboValue);
    }catch(ex){
      return "createNewLanguage " + ex.toString();
    }
    return null;
  }

  // ISO 639-1 Code
  List<ComboData> newLangsDataCombo = [
    ComboData("Afar", "aa"),
    ComboData("Abkhazian", "ab"),
    ComboData("Afrikaans", "af"),
    ComboData("Akan", "ak"),
    ComboData("Albanian", "sq"),
    ComboData("Amharic", "am"),
    ComboData("Arabic", "ar"),
    ComboData("Aragonese", "an"),
    ComboData("Armenian", "hy"),
    ComboData("Assamese", "as"),
    ComboData("Avaric", "av"),
    ComboData("Avestan", "ae"),
    ComboData("Aymara", "ay"),
    ComboData("Azerbaijani", "az"),
    ComboData("Bashkir", "ba"),
    ComboData("Bambara", "bm"),
    ComboData("Basque", "eu"),
    ComboData("Belarusian", "be"),
    ComboData("Bengali", "bn"),
    ComboData("Bihari languages", "bh"),
    ComboData("Bislama", "bi"),
    ComboData("Tibetan", "bo"),
    ComboData("Bosnian", "bs"),
    ComboData("Breton", "br"),
    ComboData("Bulgarian", "bg"),
    ComboData("Burmese", "my"),
    ComboData("Catalan; Valencian", "ca"),
    ComboData("Czech", "cs"),
    ComboData("Chamorro", "ch"),
    ComboData("Chechen", "ce"),
    ComboData("Chinese", "zh"),
    ComboData("Church Slavic", "cu"),
    ComboData("Chuvash", "cv"),
    ComboData("Cornish", "kw"),
    ComboData("Corsican", "co"),
    ComboData("Cree", "cr"),
    ComboData("Welsh", "cy"),
    ComboData("Danish", "da"),
    ComboData("German", "de"),
    ComboData("Maldivian", "dv"),
    ComboData("Dutch", "nl"),
    ComboData("Dzongkha", "dz"),
    ComboData("Greek", "el"),
    ComboData("English", "en"),
    ComboData("Esperanto", "eo"),
    ComboData("Estonian", "et"),
    ComboData("Basque", "eu"),
    ComboData("Ewe", "ee"),
    ComboData("Faroese", "fo"),
    ComboData("Persian", "fa"),
    ComboData("Fijian", "fj"),
    ComboData("Finnish", "fi"),
    ComboData("French", "fr"),
    ComboData("Western Frisian", "fy"),
    ComboData("Fulah", "ff"),
    ComboData("Georgian", "ka"),
    ComboData("German", "de"),
    ComboData("Gaelic", "gd"),
    ComboData("Irish", "ga"),
    ComboData("Galician", "gl"),
    ComboData("Manx", "gv"),
    ComboData("Guarani", "gn"),
    ComboData("Gujarati", "gu"),
    ComboData("Haitian", "ht"),
    ComboData("Hausa", "ha"),
    ComboData("Hebrew", "he"),
    ComboData("Herero", "hz"),
    ComboData("Hindi", "hi"),
    ComboData("Hiri Motu", "ho"),
    ComboData("Croatian", "hr"),
    ComboData("Hungarian", "hu"),
    ComboData("Armenian", "hy"),
    ComboData("Igbo", "ig"),
    ComboData("Icelandic", "is"),
    ComboData("Ido", "io"),
    ComboData("Sichuan Yi", "ii"),
    ComboData("Inuktitut", "iu"),
    ComboData("Interlingue", "ie"),
    ComboData("Interlingua International", "ia"),
    ComboData("Indonesian", "id"),
    ComboData("Inupiaq", "ik"),
    ComboData("Icelandic", "is"),
    ComboData("Italian", "it"),
    ComboData("Javanese", "jv"),
    ComboData("Japanese", "ja"),
    ComboData("Kalaallisut", "kl"),
    ComboData("Kannada", "kn"),
    ComboData("Kashmiri", "ks"),
    ComboData("Georgian", "ka"),
    ComboData("Kanuri", "kr"),
    ComboData("Kazakh", "kk"),
    ComboData("Central Khmer", "km"),
    ComboData("Kikuyu", "ki"),
    ComboData("Kinyarwanda", "rw"),
    ComboData("Kirghiz; Kyrgyz", "ky"),
    ComboData("Komi", "kv"),
    ComboData("Kongo", "kg"),
    ComboData("Korean", "ko"),
    ComboData("Kuanyama", "kj"),
    ComboData("Kurdish", "ku"),
    ComboData("Lao", "lo"),
    ComboData("Latin", "la"),
    ComboData("Latvian", "lv"),
    ComboData("Limburgan", "li"),
    ComboData("Lingala", "ln"),
    ComboData("Lithuanian", "lt"),
    ComboData("Luxembourgish", "lb"),
    ComboData("Luba-Katanga", "lu"),
    ComboData("Ganda", "lg"),
    ComboData("Macedonian", "mk"),
    ComboData("Marshallese", "mh"),
    ComboData("Malayalam", "ml"),
    ComboData("Maori", "mi"),
    ComboData("Marathi", "mr"),
    ComboData("Malay", "ms"),
    ComboData("Macedonian", "mk"),
    ComboData("Malagasy", "mg"),
    ComboData("Maltese", "mt"),
    ComboData("Mongolian", "mn"),
    ComboData("Maori", "mi"),
    ComboData("Malay", "ms"),
    ComboData("Burmese", "my"),
    ComboData("Nauru", "na"),
    ComboData("Navajo; Navaho", "nv"),
    ComboData("Ndebele, South;", "nr"),
    ComboData("Ndebele, North;", "nd"),
    ComboData("Ndonga", "ng"),
    ComboData("Nepali", "ne"),
    ComboData("Dutch; Flemish", "nl"),
    ComboData("Norwegian Nynorsk;", "nn"),
    ComboData("Bokmål, Norwegian;", "nb"),
    ComboData("Norwegian", "no"),
    ComboData("Chichewa; Chewa;", "ny"),
    ComboData("Occitan", "oc"),
    ComboData("Ojibwa", "oj"),
    ComboData("Oriya", "or"),
    ComboData("Oromo", "om"),
    ComboData("Ossetian; Ossetic", "os"),
    ComboData("Panjabi; Punjabi", "pa"),
    ComboData("Persian", "fa"),
    ComboData("Pali", "pi"),
    ComboData("Polish", "pl"),
    ComboData("Portuguese", "pt"),
    ComboData("Pushto; Pashto", "ps"),
    ComboData("Quechua", "qu"),
    ComboData("Romansh", "rm"),
    ComboData("Romanian", "ro"),
    ComboData("Rundi", "rn"),
    ComboData("Russian", "ru"),
    ComboData("Sango", "sg"),
    ComboData("Sanskrit", "sa"),
    ComboData("Sinhala", "si"),
    ComboData("Slovak", "sk"),
    ComboData("Slovenian", "sl"),
    ComboData("Northern Sami", "se"),
    ComboData("Samoan", "sm"),
    ComboData("Shona", "sn"),
    ComboData("Sindhi", "sd"),
    ComboData("Somali", "so"),
    ComboData("Sotho, Southern", "st"),
    ComboData("Spanish", "es"),
    ComboData("Albanian", "sq"),
    ComboData("Sardinian", "sc"),
    ComboData("Serbian", "sr"),
    ComboData("Swati", "ss"),
    ComboData("Sundanese", "su"),
    ComboData("Swahili", "sw"),
    ComboData("Swedish", "sv"),
    ComboData("Tahitian", "ty"),
    ComboData("Tamil", "ta"),
    ComboData("Tatar", "tt"),
    ComboData("Telugu", "te"),
    ComboData("Tajik", "tg"),
    ComboData("Tagalog", "tl"),
    ComboData("Thai", "th"),
    ComboData("Tibetan", "bo"),
    ComboData("Tigrinya", "ti"),
    ComboData("Tonga", "to"),
    ComboData("Tswana", "tn"),
    ComboData("Tsonga", "ts"),
    ComboData("Turkmen", "tk"),
    ComboData("Turkish", "tr"),
    ComboData("Twi", "tw"),
    ComboData("Uighur", "ug"),
    ComboData("Ukrainian", "uk"),
    ComboData("Urdu", "ur"),
    ComboData("Uzbek", "uz"),
    ComboData("Venda", "ve"),
    ComboData("Vietnamese", "vi"),
    ComboData("Volapük", "vo"),
    ComboData("Welsh", "cy"),
    ComboData("Walloon", "wa"),
    ComboData("Wolof", "wo"),
    ComboData("Xhosa", "xh"),
    ComboData("Yiddish", "yi"),
    ComboData("Yoruba", "yo"),
    ComboData("Zhuang", "za"),
    ComboData("Chinese", "zh"),
    ComboData("Zulu", "zu"),
  ];
}

