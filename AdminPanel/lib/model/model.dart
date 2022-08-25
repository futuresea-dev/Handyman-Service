import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ondemand_admin/model/langs.dart';
import 'package:ondemand_admin/model/notify.dart';
import 'package:ondemand_admin/model/provider.dart';
import 'package:ondemand_admin/model/service.dart';
import 'package:ondemand_admin/model/serviceappsettings.dart';
import 'package:ondemand_admin/model/settings.dart';
import 'package:soundpool/soundpool.dart';
import 'package:uuid/uuid.dart';
import '../ui/main.dart';
import '../ui/strings.dart';
import 'banner.dart';
import 'blog.dart';
import 'booking.dart';
import 'category.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart' as str;
import 'offer.dart';

class MainModel with ChangeNotifier, DiagnosticableTreeMixin {

  Function()? initEditorInProductScreen;
  Function()? initEditorInServiceScreen;
  Function()? initEditorInProvidersScreen;
  Function()? initEditorInCategoryScreen;
  Function()? initEditorInOfferScreen;

  Function(String? val)? providerSortFilter;
  Function(String? val)? serviceSortFilter;

  // ignore: prefer_function_declarations_over_variables
  Function() allRedraw = (){};

  setAllRedraw(Function() _allRedraw){
    allRedraw = _allRedraw;
  }

  String userEmail = "";
  String userName = "";
  String userPhone = "";
  String userAvatar = "";

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  //  Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    print("=================logout===============");
    userEmail = "";
    userName = "";
    userPhone = "";
    userAvatar = "";
    redrawMainWindow();
  }

  getUserData(Function _redraw){
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null){
      if (user.email != null)
        userEmail = user.email!;
      FirebaseFirestore.instance.collection("listusers").doc(user.uid).get().then((querySnapshot) async {
        if (querySnapshot.exists){
          var data = querySnapshot.data()!;
          userName = (data["name"]  != null) ? data["name"] : "";
          userPhone = (data["phone"]  != null) ? data["phone"] : "";
          userAvatar = (data["logoServerPath"]  != null) ? data["logoServerPath"] : "";
          _redraw();
        }
      });
    }
  }

  setUserData(Uint8List? _imageData, String name) async {
    var serverPath = "";
    var localFile = "";
    if (_imageData != null) {
      try {
        var f = Uuid().v4();
        var name = "avatar/$f.jpg";
        // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
        // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);

        serverPath = await dbSaveFile(name, _imageData);
        localFile = name;
      } catch (e) {
        return e.toString();
      }
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "user = null";
    if (name.isEmpty)
      return strings.get(91); /// "Please Enter Name",
    var _data = {
      'name' : name,
    };
    if (serverPath.isNotEmpty)
    _data.addAll({
      'logoServerPath' : serverPath,
      'logoLocalPath' : localFile,
    });

    try {
      await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set(_data, SetOptions(merge: true));
    } catch (e) {
      return e.toString();
    }
    userName = name;
    if (serverPath.isNotEmpty)
      userAvatar = serverPath;
    return null;
  }

  //bool demo = false;
  // String appname = "HANDYMAN";
  // bool rightSymbol = false;
  // int digitsAfterComma = 2;
  List<ComboData> digitsData = [
    ComboData("0", "0"),
    ComboData("1", "1"),
    ComboData("2", "2"),
    ComboData("3", "3"),
  ];
  // String code = "USD";
  // String symbol = "\$";
  // String distanceUnit = "km";
  // setPriceStringDataForUtils() => setPriceStringData(rightSymbol, digitsAfterComma, symbol);
  List<ComboData> distData = [
    ComboData("km", "km"),
    ComboData("mile", "mile"),
  ];
  List<ComboData> timeFormatData = [
    ComboData("12h", "12h"),
    ComboData("24h", "24h"),
  ];
  // String dateFormat = "yyyy.MM.dd";
  List<ComboData> dateFormatData = [
    ComboData("yyyy.MM.dd", "yyyy.MM.dd"),
    ComboData("dd.MM.yyyy", "dd.MM.yyyy"),
    ComboData("dd-MM-yyyy", "dd-MM-yyyy"),
    ComboData("dd-MMMM-yyyy", "dd-MMMM-yyyy"),
  ];

  String completeStatus = "";
  List<ComboData> statusesCombo = [];
  List<ComboData> statusesComboForBookingSearch = [];
  String statusesComboValueBookingSearch = "-1";
  StatusData currentStatus = StatusData.createEmpty();

  notify(){
    notifyListeners();
  }

  // ignore: prefer_function_declarations_over_variables
  Function(String) callback = (String _){};

  double getWorkspaceWidth(){
    var d  = (isMenuShow && windowWidth >= 1200)
        ? windowWidth -300
        : windowWidth;
    if (d < 800)
      d = 800;
    return d;
  }

  // 1620 - 270 = 1350
  // 1920-300
  //
  double getEmulatorWidth() => 232*1.45*0.8;
  double getEmulatorHeight() => 437*1.5*0.8;

  double getEditWorkspaceWidthWithEmulator(){
    var d = getWorkspaceWidth()-getEmulatorWidth()-140;
    if (d < 800)
      d = 800;
    return d;
  }

  double getEditWorkspaceWidth(){
    var d = getWorkspaceWidth()-140;
    if (d < 800)
      d = 800;
    return d;
  }

  // Function()? showDialogAddVariants;
  UserData currentProviderRequest = UserData.createEmpty();
  // Function()? showDialogViewProviderRequestInfo;
  // Function()? showDialogAddVImageUrl;
  String addImageType = "";

  late MainDataModelLangs langs;
  late MainDataModelSettings settings;
  late MainDataModelServiceApp serviceApp;
  late MainDataCategory category;
  late MainDataProvider provider;
  late MainDataService service;
  late MainDataOffer offer;
  late MainDataNotify notifyModel;
  late MainDataBooking booking;
  late MainDataBanner banner;
  late MainDataBlog blog;

  Future<String?> init(Function(String) _callback, BuildContext context, Function()? _redrawMenu) async {
    langs = MainDataModelLangs(parent: this);
    settings = MainDataModelSettings(parent: this);
    serviceApp = MainDataModelServiceApp(parent: this);
    category = MainDataCategory(parent: this);
    provider = MainDataProvider(parent: this);
    service = MainDataService(parent: this);
    offer = MainDataOffer(parent: this);
    notifyModel = MainDataNotify(parent: this);
    booking = MainDataBooking(parent: this);
    banner = MainDataBanner(parent: this);
    blog = MainDataBlog(parent: this);

    dprint("model init");
    callback = _callback;
    var ret = await settings.settings(context, _redrawMenu);
    if (ret != null)
      return ret;
    ret = await langs.languages(_callback, context);
    if (ret != null)
      return ret;
    _callback(strings.get(213)); /// "Loading Service App theme ...",
    ret = await serviceApp.loadEmulatorServiceAppData();
    if (ret != null)
      return ret;
    _callback(strings.get(218)); /// "Loading Category ...",
    ret = await loadCategory(false);
    if (ret != null)
      return ret;
    category.parentListMake();
    ret = await loadBookingCache("", "");
    if (ret != null)
      return ret;
    _callback(strings.get(469)); /// "Loading Product cache ...",
    ret = await loadArticleCache(false);
    if (ret != null)
      messageError(context, ret);
    ret = await provider.load();
    if (ret != null)
      return ret;

    _loadSound();

    return null;
  }

  Soundpool pool = Soundpool.fromOptions();
  int soundId = 0;

  _loadSound() async{
    // print("loadSound rootBundle.load");
    await rootBundle.load("assets/sound.mp3").then((ByteData soundData) async {
      // print("loadSound pool.load");
      soundId = await pool.load(soundData);
      // print("loadSound soundId=$soundId");
    });
  }

  playSound() async {
    // print("playSound soundId=$soundId");
    if (soundId != 0)
      await pool.play(soundId);
  }

  //
  // Languages for Service App + Provider App + Admin Panel
  //
  List<ComboData> appsDataCombo = [
    ComboData(strings.get(110), "service"),
    ComboData(strings.get(111), "provider"),
    ComboData(strings.get(112), "admin"),
    ComboData(strings.get(389), "site"),  /// "Web Site",
  ];
  String appsDataComboValue = "service";
  List<ComboData> langDataCombo = [];
  String editLangNowDataComboValue = "en";
  List<LangField> listWordsForEdit = [];

  String langEditDataComboValue = "en";

  List<LangData> serviceAppLangs = [];
  List<LangData> providerAppLangs = [];
  List<LangData> adminAppLangs = [];
  List<LangData> siteAppLangs = [];
  String currentSiteLanguage = "en";
  //
  List<ComboData> adminDataCombo = [];
  // String currentAdminLanguage = "en";
  //
  List<ComboData> emulatorServiceDataCombo = [];
  List<ComboData> emulatorProviderDataCombo = [];
  String currentEmulatorLanguage = "en";

  String getTextByLocale(List<StringData> _data){
    for (var item in _data)
      if (item.code == langEditDataComboValue)
        return item.text;
    for (var item in _data)
      if (item.code == "en")
        return item.text;
    return "";
  }
  setEmulatorServiceAppLang() async {
    for (var item in serviceAppLangs)
      if (item.locale == currentEmulatorLanguage) {
        if (item.data.isEmpty)
          await langs.loadLanguage(item);
        str.strings.setLang(item.data);
      }
  }

  setEmulatorLang(String val) async {
    currentEmulatorLanguage = val;
    await setEmulatorServiceAppLang();
    notifyListeners();
  }

  setLang(String val) async {
    await langs.setLang(val);
    notifyListeners();
  }

  //
  //
  //
  Future<String?> setImageData(Field item, Uint8List _imageData) async {
    try{
      var f = Uuid().v4();
      var name = "apps/$f.jpg";
      // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
      // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
      item.serverPath = await dbSaveFile(name, _imageData);
      item.localFile = name;
      item.value = false;
      serviceApp.needRedraw();
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  copyReviews(){
    var text = "";
    for (var item in reviews){
      text = "$text${item.id}\t${item.rating}\t${item.userName}"
          "\t${item.serviceName}\t${appSettings.getDateTimeString(item.time)}\t${item.text}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csvReviews(){
    List<List> t2 = [];
    t2.add([
      strings.get(114), /// "Id",
      strings.get(286), /// "Rating",
      strings.get(262), /// "User name",
      strings.get(282), /// "Service",
      strings.get(273), /// "Time",
      strings.get(287), /// "Review"
    ]);
    for (var item in reviews){
      t2.add([item.id, item.rating, item.userName, item.serviceName,
        appSettings.getDateTimeString(item.time), item.text
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

}
