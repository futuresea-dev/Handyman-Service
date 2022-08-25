import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/service.dart';
import 'package:ondemandservice/ui/booking/payment.dart';
import 'package:ondemandservice/ui/theme.dart';
import '../ui/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'account.dart';
import 'lang.dart';

class MainModel with ChangeNotifier, DiagnosticableTreeMixin {

  List<LangData> appLangs = [];
  String directoryPath = "";

  List<ProductData> serviceSearch = [];
  ProductData currentService = ProductData.createEmpty();
  ProviderData currentProvider = ProviderData.createEmpty();
  // List<OfferData> offers = [];
  bool searchActivate = false;

  //
  // Navigation
  //
  bool showBottomBar = true;
  BlogData? openBlog;
  AddressData? addressData;
  late Function(String) openDialog;
  CategoryData categoryData = CategoryData.createEmpty();
  // OrderData jobInfo = OrderData.createEmpty();
  bool anyTime = true;
  bool scheduleTime = false;
  DateTime selectTime = DateTime.now();
  clearBookData(){
    anyTime = true;
    scheduleTime = false;
    selectTime = DateTime.now();
    countProduct = 1;
    paymentMethod = 1;
    couponId = "";     // 2746fde7643fgd
    couponCode = "";   // CODE25
    discountType = ""; // "percent" or "fixed"
    discount = 0;      // 12
    couponCode = "";
  }

  setMainWindow(Function(String) _openDialog){
    openDialog = _openDialog;
  }

  late MainModelUserAccount account;
  late MainDataLang lang;
  late MainModelService service;

  Future<String?> init(BuildContext context) async {
    account = MainModelUserAccount(parent: this);
    lang = MainDataLang(parent: this);
    service = MainModelService(parent: this);

    //
    // Settings
    //
    String? _return;
    _return = await getSettingsFromFile((AppSettings _appSettings){
      appSettings = _appSettings;
    });

    loadSettings(() async {
      await saveSettingsToLocalFile(appSettings);
      for (var item in appSettings.customerAppElementsDisabled)
        appSettings.customerAppElements.remove(item);
    });

    //
    // THEME
    //
    if (!themeFromServerLoad) {
      var ret = await getThemeFromServer();
      if (ret != null && _return == null)
        _return = ret;
    }

    //
    // Langs
    //
    var ret = await ifNeedLoadNewLanguages(appLangs, "service", (LangData _) {});
    if (ret != null)
      messageError(context, ret);

    await loadLangsFromLocal(localSettings.locale, appSettings.currentServiceAppLanguage,
            (LangData item){
          strings.setLang(item.data, item.locale, context, item.direction);
        }, (List<LangData> langs){
          appLangs = langs;
        });

    notifyListeners();
    return _return;
  }

  Future<String?> init2(Function() _redraw) async {
    var ret = await loadCategory(true);
    if (ret != null)
      return ret;
    _redraw();
    ret = await initService("all", "", (){});
    if (ret != null)
      return ret;
    loadProvider((){
      redrawMainWindow();
    });
    _redraw();
    initProviderDistances();
    ret = await loadOffers();
    if (ret != null)
      return ret;
    ret = await loadBanners();
    if (ret != null)
      return ret;
    ret = await loadArticleCache(true);
    if (ret != null)
      return ret;

    notifyListeners();
    return null;
  }

  String currentPage = "home";
  bool cartUser = true;

  Future<String?> finish(String paymentMethod) async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "user == null";
    if (appSettings.statuses.isEmpty)
      return "statuses.isEmpty";
    bool cachePayment = false;
    if (paymentMethod == strings.get(81)) /// "Cash payment",
      cachePayment = true;

    String? ret;
    if (!cartUser){
      ret = await finishCartV1(currentService, false, paymentMethod,
          strings.get(160), /// "From user:",
          strings.get(157) /// "New Booking was arrived",
      );
    }else { // ver4 cart
      ret = await finishCartV4(false, paymentMethod, cachePayment,
          strings.get(160), /// "From user:",
          strings.get(157) /// "New Booking was arrived",
      );
    }
    if (ret != null)
      return ret;

    return null;
  }

  notify(){
    notifyListeners();
  }
}

getTheme() async {
  dprint("getTheme");
  try{
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    var _file = File('$directoryPath/theme.json');
    if (await _file.exists()){
      final contents = await _file.readAsString();
      var data = json.decode(contents);
      dprint("getTheme $data");
      theme = AppTheme.fromJson(data);
    }else{
      dprint("getTheme - file $directoryPath/theme.json not found");
      await getThemeFromServer();
    }
  }catch(ex){
    print("getTheme $ex");
  }
}

bool themeFromServerLoad = false;

getThemeFromServer() async {
  try{
    dprint("getThemeFromServer");
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    var querySnapshot = await FirebaseFirestore.instance.collection("settings").doc("serviceApp").get();
    theme = AppTheme.fromJson(querySnapshot.data()!);
    // save local
    var _t = json.encode(theme.toJson());
    await File('$directoryPath/theme.json').writeAsString(_t);
    themeFromServerLoad = true;
    dprint("getThemeFromServer save $directoryPath/theme.json");
  }catch(ex){
    print("getThemeFromServer $ex");
  }
  return null;
}

