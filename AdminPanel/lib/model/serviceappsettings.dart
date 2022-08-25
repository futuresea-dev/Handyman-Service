import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/theme.dart';
import '../ui/strings.dart';
import 'model.dart';
import '../ui/appService/screens/theme.dart' as theme_service;

class MainDataModelServiceApp with DiagnosticableTreeMixin{

  final MainModel parent;

  MainDataModelServiceApp({required this.parent});

  Screen select = Screen.createEmpty();
  bool initList = false;
  bool onDemandDarkMode2 = false;
  Color onDemandMainColor2 = Color(0xff69c4ff);
  Color onDemandColorBackground2 = Color(0xfff1f6fe);
  Color onDemandBlackColorTitleBkg2 = Color(0xff202020);
  //
  List<ComboData> langDataCombo = [];
  String langDataComboValue = "en";
  Map<int, String> currentLang = {};
  //
  bool needsRedraw = false;

  init(BuildContext context) async {
    //setLang
    parent.setEmulatorServiceAppLang();
    await parent.service.load(context);
    //currentLang = str.strings.langData[0].langData;
    // langDataCombo = [];
    // for (var item in str.strings.langData)
    //   langDataCombo.add(ComboData(item.name, item.locale));
    selectScreen(screens[0]);
  }

  setLang(String val){
    // langDataComboValue = val;
    // for (var item in str.strings.langData)
    //   if (item.locale == val)
    //     currentLang = item.langData;
    // _initStringsFields();
    // initList = true;
    // notifyListeners();
  }

  needRedraw(){
    needsRedraw = true;
    _saveFields();
    theme_service.theme = theme_service.ServiceAppTheme();
    _saveStrings();
    parent.notify();
  }

  setonDemandDarkMode(bool val){
    onDemandDarkMode2 = val;
    darkMode = val;
    theme = ServiceAppTheme();
    parent.notify();
  }

  setMainColor(Color color){
    onDemandMainColor2 = color;
    serviceApp.mainColor = color;
    parent.notify();
  }

  setonDemandColorBackground(Color color){
    onDemandColorBackground2 = color;
    serviceApp.colorBackground = color;
    parent.notify();
  }

  setonDemandBlackColorTitleBkg(Color color){
    onDemandBlackColorTitleBkg2 = color;
    serviceApp.blackColorTitleBkg = color;
    parent.notify();
  }

  selectScreen(Screen item){
    initList = true;
    select = item;
    _initStringsFields();
    _initColors();
    _initFields(item);
    parent.notify();
  }

  _initColors(){
    for (var item in select.fields) {
      if (item.typeData == "color")
        item.color = toColor(item.data);
    }
  }

  _initStringsFields(){
    for (var item in select.strings) {
      // print("id=${int.parse(item.id)}");
      var text = currentLang[int.parse(item.id)];
      item.data = (text != null) ? text : "";
      item.controller.text = item.data;
      // print("text=$text");
      // print("item.controller.text=${item.controller.text}");
    }
  }

  emulatorSetWord(item, String val){
    for (var item2 in parent.listWordsForEdit)
      if (item2.id == item.id) {
        item2.word = val;
        break;
      }
    for (var item3 in parent.serviceAppLangs)
      if (item3.app == "service" && item3.locale == parent.editLangNowDataComboValue)
        item3.data[item.id] = val;

    item.data = val;
    needRedraw();
  }

  _saveStrings(){
    parent.setEmulatorServiceAppLang();
  }

  List<Screen> screens = [
    Screen("splash", strings.get(100),                                          /// "Splash Screen"
        [
          Field(strings.get(214), "splash_logo", "", "selectImage"),            // "Logo"
          Field(strings.get(215), "splash_image", "", "selectImage"),           // Image
          Field(strings.get(216), "splash_color", "0xff1c7bab", "color"),       // Loader color
        ],
        strings: [
          Field("", "0", "", ""),
          Field("", "1", "", ""),
        ],
        image: "assets/dashboard2/ds1.jpg"),
    Screen("lang", strings.get(217),                                          /// "Language Screen"
        [
          Field(strings.get(215), "lang_logo", "", "selectImage"),            // "Image"
        ],
        strings: [
          Field("", "2", "", ""),
          Field("", "3", "", ""),
          Field("", "4", "", ""),
          Field("", "5", "", ""),
        ],
        image: "assets/dashboard2/ds2.jpg"),
    Screen("login", strings.get(101),                                          /// "Login Screen"
        [
          Field(strings.get(214), "login_logo", "", "selectImage"),            // "Logo"
          Field(strings.get(215), "login_image", "", "selectImage"),           // Image
        ],
        strings: [
          Field("", "0", "", ""),
          Field("", "1", "", ""),
          Field("", "43", "", ""),
          Field("", "23", "", ""),
          Field("", "24", "", ""),
          Field("", "44", "", ""),
          Field("", "45", "", ""),
          Field("", "46", "", ""),
          Field("", "47", "", ""),
          Field("", "48", "", ""),
        ],
        image: "assets/dashboard2/ds3.jpg"),
    Screen("register", strings.get(102),                                      /// "Register Screen"
        [
          Field(strings.get(214), "registerLogo", "", "selectImage"),            // "Logo"
        ],
        strings: [
          Field("", "49", "", ""),
          Field("", "50", "", ""),
          Field("", "21", "", ""),
          Field("", "22", "", ""),
          Field("", "23", "", ""),
          Field("", "24", "", ""),
          Field("", "44", "", ""),
          Field("", "45", "", ""),
          Field("", "51", "", ""),
          Field("", "46", "", ""),
        ],
        image: "assets/dashboard2/ds4.jpg"),
    Screen("main", strings.get(116),                                /// "Main Screen"
        [
          Field(strings.get(214), "homeLogo", "", "selectImage"),            // "Logo"
        ],
        strings: [
          Field("", "93", "", ""),
          Field("", "94", "", ""),
          Field("", "95", "", ""),
        ],
        image: "assets/dashboard2/ds5.jpg"),
    Screen("provider", strings.get(117),                                /// "Provider Screen"
        [
          // Field(strings.get(304), "providerStarColor", "0xFFFFA726", "color"),       // Star color
          Field(strings.get(302), "providerGLogo", "", "selectImage"),            // "'Gallery' Logo"
          // Field(strings.get(303), "providerRLogo", "", "selectImage"),            // "'Reviews & Ratings' Logo"
        ],
        strings: [
          Field("", "123", "", ""),
          Field("", "124", "", ""),
          Field("", "125", "", ""),
          Field("", "126", "", ""),
          Field("", "127", "", ""),
          Field("", "128", "", ""),
          Field("", "129", "", ""),
          Field("", "100", "", ""),
          //Field("", "101", "", ""),
        ],
        image: "assets/dashboard2/ds6.jpg"),
    Screen("service", strings.get(143),                                /// "Service Screen"
        [
          Field(strings.get(304), "serviceStarColor", "0xFFFFA726", "color"),       // Star color
          Field(strings.get(302), "serviceGLogo", "", "selectImage"),            // "'Gallery' Logo"
          Field(strings.get(303), "serviceRLogo", "", "selectImage"),            // "'Reviews & Ratings' Logo"
        ],
        strings: [
          Field("", "102", "", ""),
          Field("", "97", "", ""),
          Field("", "99", "", ""),
          Field("", "98", "", ""),
          Field("", "100", "", ""),
          Field("", "101", "", ""),
          Field("", "155", "", ""),
        ],
        image: "assets/dashboard2/ds7.jpg"),
    Screen("category", strings.get(288),                                /// "Categories Screen",
        [
          Field(strings.get(304), "categoryStarColor", "0xFFFFA726", "color"),       // Star color
          Field(strings.get(305), "categoryBoardColor", "0xFF00FF00", "color"),       // Category board color
        ],
        strings: [
          Field("", "95", "", ""),
        ],
        image: "assets/dashboard2/ds8.jpg"),
    Screen("booking", strings.get(289),                                /// "Booking Screen",
        [
          Field(strings.get(306), "bookingNotFoundImage", "", "selectImage"),            // "'Not found' image"
        ],
        strings: [
          Field("", "63", "", ""),
          Field("", "150", "", ""),
        ],
        image: "assets/dashboard2/ds9.jpg"),
    Screen("chat1", strings.get(290),                                /// "Chat users Screen",
        [
          Field(strings.get(214), "chatLogo", "", "selectImage"),            // "Logo"
        ],
        strings: [
          Field("", "7", "", ""),
          Field("", "85", "", ""),
          Field("", "122", "", ""),
        ],
        image: "assets/dashboard2/ds10.jpg"),
    Screen("chat2", strings.get(291),                                /// "Chat Screen",
        [
          Field(strings.get(214), "chat2Logo", "", "selectImage"),            // "Logo"
          Field(strings.get(307), "chatSendButtonImage", "", "selectImage"),            // "Send Button Image"
        ],
        strings: [
          Field("", "57", "", ""),
        ],
        image: "assets/dashboard2/ds11.jpg"),
    Screen("notify", strings.get(292),                                /// "Notifications Screen",
        [
          Field(strings.get(214), "notifyLogo", "", "selectImage"),            // "Logo"
          Field(strings.get(306), "notifyNotFoundImage", "", "selectImage"),            // "'Not found' image"
        ],
        strings: [
          Field("", "19", "", ""),
          Field("", "20", "", ""),
          Field("", "122", "", ""),
          Field("", "150", "", ""),
        ],
        image: "assets/dashboard2/ds12.jpg"),
    Screen("account", strings.get(293),                                /// "Account Screen",
        [
          Field(strings.get(214), "accountLogo", "", "selectImage"),            // "Logo"
        ],
        strings: [
          Field("", "10", "", ""),
          Field("", "11", "", ""),
          Field("", "12", "", ""),
          Field("", "13", "", ""),
          Field("", "14", "", ""),
          Field("", "15", "", ""),
          Field("", "146", "", ""),
          Field("", "147", "", ""),
          Field("", "148", "", ""),
          Field("", "149", "", ""),
          Field("", "17", "", ""),
          Field("", "18", "", ""),
          Field("", "19", "", ""),
          Field("", "20", "", ""),
          Field("", "16", "", ""),
        ],
        image: "assets/dashboard2/ds13.jpg"),
    Screen("profile", strings.get(294),                                /// "Profile Screen",
        [
          Field(strings.get(214), "profileLogo", "", "selectImage"),            // "Logo"
        ],
        strings: [
          Field("", "21", "", ""),
          Field("", "22", "", ""),
          Field("", "23", "", ""),
          Field("", "24", "", ""),
          Field("", "25", "", ""),
          Field("", "26", "", ""),
          Field("", "31", "", ""),
          Field("", "32", "", ""),
          Field("", "33", "", ""),
          Field("", "34", "", ""),
          Field("", "35", "", ""),
          Field("", "36", "", ""),
          Field("", "37", "", ""),
          Field("", "38", "", ""),
          Field("", "39", "", ""),
        ],
        image: "assets/dashboard2/ds14.jpg"),
    Screen("documents", strings.get(295),                                /// "Documents Screen",
        [
          Field(strings.get(214), "documentsLogo", "", "selectImage"),            // "Logo"
        ],
        strings: [
          Field("", "14", "", ""),
          Field("", "15", "", ""),
          Field("", "146", "", ""),
          Field("", "147", "", ""),
          Field("", "148", "", ""),
          Field("", "149", "", ""),
        ],
        image: "assets/dashboard2/ds15.jpg"),
    Screen("booking1", strings.get(296),                                /// "Booking Screen #1",
        [
          Field(strings.get(308), "booking1CheckBoxColor", "0xFFFFA726", "color"),       // CheckBox color
        ],
        strings: [
          Field("", "46", "", ""),
          Field("", "103", "", ""),
          Field("", "104", "", ""),
          Field("", "105", "", ""),
          Field("", "106", "", ""),
          Field("", "109", "", ""),
          Field("", "110", "", ""),
          Field("", "111", "", ""),
          Field("", "112", "", ""),
        ],
        image: "assets/dashboard2/ds16.jpg"),
    Screen("addaddress", strings.get(297),                                /// "Add Address Screen",
        [
        ],
        strings: [
          Field("", "122", "", ""),
          Field("", "119", "", ""),
          Field("", "120", "", ""),
          Field("", "121", "", ""),
          Field("", "117", "", ""),
        ],
        image: "assets/dashboard2/ds17.jpg"),
    Screen("booking2", strings.get(298),                                /// "Booking Screen #2",
        [
        ],
        strings: [
          Field("", "46", "", ""),
          Field("", "107", "", ""),
          Field("", "75", "", ""),
          Field("", "74", "", ""),
          Field("", "167", "", ""),
          Field("", "168", "", ""),
          Field("", "76", "", ""),
          Field("", "77", "", ""),
        ],
        image: "assets/dashboard2/ds18.jpg"),
    Screen("booking3", strings.get(299),                                /// "Booking Screen #3",
        [
        ],
        strings: [
          Field("", "46", "", ""),
          Field("", "111", "", ""),
          Field("", "109", "", ""),
          Field("", "103", "", ""),
          Field("", "105", "", ""),
          Field("", "75", "", ""),
          Field("", "74", "", ""),
          Field("", "167", "", ""),
          Field("", "168", "", ""),
          Field("", "76", "", ""),
          Field("", "77", "", ""),
        ],
        image: "assets/dashboard2/ds19.jpg"),
    Screen("booking4", strings.get(300),                                /// "Booking Screen #4",
        [
          Field(strings.get(308), "booking4CheckBoxColor", "0xFFFFA726", "color"),       // CheckBox color
        ],
        strings: [
          Field("", "77", "", ""),
          Field("", "81", "", ""),
          Field("", "113", "", ""),
        ],
        image: "assets/dashboard2/ds20.jpg"),
    Screen("booking5", strings.get(301),                                /// "Booking Screen #5",
        [
          Field(strings.get(214), "booking5Logo", "", "selectImage"),            // "Logo"
        ],
        strings: [
          Field("", "116", "", ""),
          Field("", "115", "", ""),
          Field("", "114", "", ""),
        ],
        image: "assets/dashboard2/ds21.jpg"),
  ];

  _initFields(Screen item){
    for (var item2 in item.fields){
      if (item.id == "splash"){
        if (item2.id == "splash_logo")
          item2.value = serviceApp.logoAsset;
        if (item2.id == "splash_image")
          item2.value = serviceApp.splashImageAsset;
        if (item2.id == "splash_color")
          item2.color =  serviceApp.splashColor;
      }
      if (item.id == "lang"){
        if (item2.id == "lang_logo")
          item2.value = serviceApp.langLogoAsset;
      }
      if (item.id == "login"){
        if (item2.id == "login_logo")
          item2.value = serviceApp.loginLogoAsset;
        if (item2.id == "login_image")
          item2.value = serviceApp.loginImageAsset;
      }
      if (item.id == "register"){
        if (item2.id == "registerLogo")
          item2.value = serviceApp.registerLogoAsset;
      }
      if (item.id == "home"){
        if (item2.id == "homeLogo")
          item2.value = serviceApp.homeLogoAsset;
      }
      if (item.id == "provider"){
        if (item2.id == "providerGLogo")
          item2.value = serviceApp.providerGLogoAsset;
        if (item2.id == "providerRLogo")
          item2.value = serviceApp.providerRLogoAsset;
        if (item2.id == "providerStarColor")
          item2.color =  serviceApp.providerStarColor;
      }
      if (item.id == "service"){
        if (item2.id == "serviceGLogo")
          item2.value = serviceApp.serviceGLogoAsset;
        if (item2.id == "serviceRLogo")
          item2.value = serviceApp.serviceRLogoAsset;
        if (item2.id == "serviceStarColor")
          item2.color =  serviceApp.serviceStarColor;
      }
      if (item.id == "category"){
        if (item2.id == "categoryStarColor")
          item2.color =  serviceApp.categoryStarColor;
        if (item2.id == "categoryBoardColor")
          item2.color =  serviceApp.categoryBoardColor;
      }
      if (item.id == "booking"){
        if (item2.id == "bookingNotFoundImage")
          item2.value = serviceApp.bookingNotFoundImageAsset;
      }
      if (item.id == "chat1"){
        if (item2.id == "chatLogo")
          item2.value = serviceApp.chatLogoAsset;
      }
      if (item.id == "chat2"){
        if (item2.id == "chat2Logo")
          item2.value = serviceApp.chat2LogoAsset;
        if (item2.id == "chatSendButtonImage")
          item2.value = serviceApp.chatSendButtonImageAsset;
      }
      if (item.id == "notify"){
        if (item2.id == "notifyLogo")
          item2.value = serviceApp.notifyLogoAsset;
        if (item2.id == "notifyNotFoundImage")
          item2.value = serviceApp.notifyNotFoundImageAsset;
      }
      if (item.id == "account"){
        if (item2.id == "accountLogo")
          item2.value = serviceApp.accountLogoAsset;
      }
      if (item.id == "profile"){
        if (item2.id == "profileLogo")
          item2.value = serviceApp.profileLogoAsset;
      }
      if (item.id == "documents"){
        if (item2.id == "documentsLogo")
          item2.value = serviceApp.documentsLogoAsset;
      }
      if (item.id == "booking1"){
        if (item2.id == "booking1CheckBoxColor")
          item2.color =  serviceApp.booking1CheckBoxColor;
      }
      if (item.id == "booking4"){
        if (item2.id == "booking4CheckBoxColor")
          item2.color =  serviceApp.booking4CheckBoxColor;
      }
      if (item.id == "booking5"){
        if (item2.id == "booking5Logo")
          item2.value = serviceApp.booking5LogoAsset;
      }

    }
  }

  _saveFields(){
    for (var item in select.fields) {
      //
      // splash
      //
      if (item.id == "splash_logo") {
        if (item.serverPath.isNotEmpty)
          serviceApp.logo = item.serverPath;
        serviceApp.logoAsset = item.value;
      }
      if (item.id == "splash_image") {
        if (item.serverPath.isNotEmpty)
          serviceApp.splashImage = item.serverPath;
        serviceApp.splashImageAsset = item.value;
      }
      if (item.id == "splash_color") serviceApp.splashColor = item.color;
      //
      // Lang
      //
      if (item.id == "lang_logo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.langLogo = item.serverPath;
        serviceApp.langLogoAsset = item.value;
      }
      //
      // login
      //
      if (item.id == "login_logo") {
        if (item.serverPath.isNotEmpty)
          serviceApp.loginLogo = item.serverPath;
        serviceApp.loginLogoAsset = item.value;
      }
      if (item.id == "login_image") {
        if (item.serverPath.isNotEmpty)
          serviceApp.loginImage = item.serverPath;
        serviceApp.loginImageAsset = item.value;
      }
      //
      // register
      //
      if (item.id == "registerLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.registerLogo = item.serverPath;
        serviceApp.registerLogoAsset = item.value;
      }
      //
      // Home
      //
      if (item.id == "homeLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.homeLogo = item.serverPath;
        serviceApp.homeLogoAsset = item.value;
      }
      //
      // provider
      //
      if (item.id == "providerStarColor") serviceApp.providerStarColor = item.color;
      if (item.id == "providerGLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.providerGLogo = item.serverPath;
        serviceApp.providerGLogoAsset = item.value;
      }
      if (item.id == "providerRLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.providerRLogo = item.serverPath;
        serviceApp.providerRLogoAsset = item.value;
      }
      //
      // service
      //
      if (item.id == "serviceStarColor") serviceApp.serviceStarColor = item.color;
      if (item.id == "serviceGLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.serviceGLogo = item.serverPath;
        serviceApp.serviceGLogoAsset = item.value;
      }
      if (item.id == "serviceRLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.serviceRLogo = item.serverPath;
        serviceApp.serviceRLogoAsset = item.value;
      }
      //
      // Category
      //
      if (item.id == "categoryStarColor") serviceApp.categoryStarColor = item.color;
      if (item.id == "categoryBoardColor") serviceApp.categoryBoardColor = item.color;
      //
      // Booking
      //
      if (item.id == "bookingNotFoundImage"){
        if (item.serverPath.isNotEmpty)
          serviceApp.bookingNotFoundImage = item.serverPath;
        serviceApp.bookingNotFoundImageAsset = item.value;
      }
      //
      // chat 1
      //
      if (item.id == "chatLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.chatLogo = item.serverPath;
        serviceApp.chatLogoAsset = item.value;
      }
      //
      // chat 2
      //
      if (item.id == "chat2Logo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.chat2Logo = item.serverPath;
        serviceApp.chat2LogoAsset = item.value;
      }
      if (item.id == "chatSendButtonImage"){
        if (item.serverPath.isNotEmpty)
          serviceApp.chatSendButtonImage = item.serverPath;
        serviceApp.chatSendButtonImageAsset = item.value;
      }
      //
      // notify
      //
      if (item.id == "notifyLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.notifyLogo = item.serverPath;
        serviceApp.notifyLogoAsset = item.value;
      }
      if (item.id == "notifyNotFoundImage"){
        if (item.serverPath.isNotEmpty)
          serviceApp.notifyNotFoundImage = item.serverPath;
        serviceApp.notifyNotFoundImageAsset = item.value;
      }
      //
      // account
      //
      if (item.id == "accountLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.accountLogo = item.serverPath;
        serviceApp.accountLogoAsset = item.value;
      }
      //
      // profile
      //
      if (item.id == "profileLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.profileLogo = item.serverPath;
        serviceApp.profileLogoAsset = item.value;
      }
      //
      // documents
      //
      if (item.id == "documentsLogo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.documentsLogo = item.serverPath;
        serviceApp.documentsLogoAsset = item.value;
      }
      //
      // Booking
      //
      if (item.id == "booking1CheckBoxColor") serviceApp.booking1CheckBoxColor = item.color;
      if (item.id == "booking4CheckBoxColor") serviceApp.booking4CheckBoxColor = item.color;
      if (item.id == "booking5Logo"){
        if (item.serverPath.isNotEmpty)
          serviceApp.booking5Logo = item.serverPath;
        serviceApp.booking5LogoAsset = item.value;
      }
    }
  }

  Future<String?> saveEmulatorServiceAppData() async {
    try{
      var _data = serviceApp.toJson();
      await FirebaseFirestore.instance.collection("settings").doc("serviceApp").set(_data, SetOptions(merge:true));
    }catch(ex){
      return ex.toString();
    }
    return null;
  }

  Future<String?> loadEmulatorServiceAppData() async {
    try{
      var querySnapshot = await FirebaseFirestore.instance.collection("settings").doc("serviceApp").get();
      if (querySnapshot.exists)
        serviceApp = ServiceAppCustomization.fromJson(querySnapshot.data()!);
    }catch(ex){
      return ex.toString();
    }
    return null;
  }

}

class Field{
  final String name;
  final String id;
  String data;
  final String typeData;
  var controller = TextEditingController();
  Color color = Colors.red;

  bool value;
  String localFile = "";
  String serverPath = "";

  Field(this.name, this.id, this.data, this.typeData, {this.value = true});
}

class Screen{
  final String id;
  final String name;
  final String image;
  final List<Field> fields;
  final List<Field> strings;

  Screen(this.id, this.name, this.fields, {this.image = "", this.strings = const []});

  factory Screen.createEmpty(){
    return Screen("", "", []);
  }
}