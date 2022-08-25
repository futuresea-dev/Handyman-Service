import 'dart:async';
import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/account.dart';
import 'package:ondemand_admin/ui/booking/payment.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../theme.dart';
import '../ui/strings.dart';
import 'lang.dart';
import 'dart:html' as html;

class MainModel with ChangeNotifier, DiagnosticableTreeMixin {

  ProviderData currentProvider = ProviderData.createEmpty();
  CategoryData currentCategory = CategoryData.createEmpty();
  ProductData currentService = ProductData.createEmpty();
  List<UserData> users = [];
  late MainModelAccount account;
  late MainDataLang lang;

  TextEditingController controllerSearch = TextEditingController();

  //
  // booking
  //
  clearBookData(){
    cartAnyTime = true;
    cartSelectTime = DateTime.now();
    cartHint = "";
    countProduct = 1;
    paymentMethod = 1;
    couponId = "";     // 2746fde7643fgd
    couponCode = "";   // CODE25
    discountType = ""; // "percent" or "fixed"
    discount = 0;      // 12
    couponCode = "";
  }

  bool cartUser = true;

  Future<String?> finish(bool temporary) async{
    // if (currentService.providers.isEmpty)
    //   return "currentService.providers.isEmpty";
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return "user == null";
    if (appSettings.statuses.isEmpty)
      return "Statuses is empty. localAppSettings.statuses.isEmpty";

    bool cachePayment = false;
    if (paymentMethodId == strings.get(115)) /// "Cash payment",
      cachePayment = true;

    String? ret;
    if (!cartUser){
      ret = await finishCartV1(currentService, temporary, paymentMethodId,
          strings.get(117), /// "From user:",
          strings.get(118) /// "New Booking was arrived",
      );
    }else { // ver4 cart
      ret = await finishCartV4(temporary, paymentMethodId, cachePayment,
        strings.get(117), /// "From user:",
        strings.get(118) /// "New Booking was arrived",
      );
    }
    if (ret != null)
      return ret;

    return null;
  }

  String getLastBooking(){
    return pref.get("lastBooking");
  }


  // String getProviderId(String login){
  //   for (var item in users)
  //     if (item.email == login)
  //       return item.id;
  //   return "";
  // }

  // navigate
  BlogData? openBlog;
  AddressData? addressData;
  // OrderData jobInfo = OrderData.createEmpty();
  late Function() redraw;
  late Function(String) route;
  late Function(String) openDialog;
  late Function(bool) waits;
  late BuildContext context;
  String openDocument = "";
  bool flutterwave = false;
  bool flutterwaveCheckId = false;
  String flutterwaveId = "";
  String flutterwaveTransactionId = "";
  //
  bool flutterwaveShow = false;
  bool mercadoPagoShow = false;
  bool payPalShow = false;
  double total = 0;
  String desc = "";
  bool instamojoShow = false;
  //
  // String lastBooking = "";
  // String lastBookingForUser = "";
  bool payPalSuccess = false;
  bool payPalCancel = false;
  bool stripeSuccess = false;
  bool stripeCancel = false;
  bool cashSuccess = false;
  String payPalPaymentId = "";
  bool razorpaySuccess = false;
  bool mercadoPagoSuccess = false;
  String mercadoPagoTransactionId = "";
  //
  double dialogPositionX = 0;
  double dialogPositionY = 0;
  double dialogWidth = 0;
  //
  // search
  //
  bool searchActivate = false;
  List<ProductData> serviceSearch = [];
  // String searchText = "";
  int ascDesc = 0;
  SfRangeValues filterPrice = SfRangeValues(100, 1000);
  double getFilterMinPrice(){
    return filterPrice.start;
  }
  double getFilterMaxPrice(){
    return filterPrice.end;
  }

  setMainWindow(Function() _redraw, Function(String) _route,
      Function(String) _openDialog, Function(bool) _waits, BuildContext _context){
    redraw = _redraw;
    route = _route;
    openDialog = _openDialog;
    waits = _waits;
    context = _context;
  }

  ProviderData? getProviderById(String _providerId) {
    for (var item in providers)
      if (item.id == _providerId)
        return item;
    return null;
  }

  html.Storage get localStorage => html.window.localStorage;

  Future<String?> init(BuildContext context, Function() _redraw) async {
    account = MainModelAccount(parent: this);
    lang = MainDataLang(parent: this);

    //
    loadSettings(() async {
      await saveSettingsToLocalFile(appSettings);
      theme = AppTheme();
    });
    // var ret = await _getAppServerSettings();
    // if (ret != null)
    //   return ret;
    account.userListen(context);

    var ret = await lang.load(context);
    if (ret != null)
      return ret;
    _redraw();
    ret = await loadProvider
        ((){
          initProviderDistances();
          redrawMainWindow();
        });
    if (ret != null)
      return ret;
    _redraw();
    ret = await loadCategory(true);
    if (ret != null)
      return ret;
    _redraw();
    ret = await initService("all", "", (){});
    if (ret != null)
      return ret;
    if (cart.isEmpty)
      initCart();
    _redraw();
    ret = await loadBanners();
    if (ret != null)
      return ret;
    _redraw();
    ret = await loadArticleCache(true);
    if (ret != null)
      return ret;
    _redraw();
    ret = await loadBlog(true);
    if (ret != null)
      return ret;
    ret = await loadOffers();
    if (ret != null)
      return ret;

    initComplete = true;
    return null;
  }

  bool initComplete = false;

  PriceData getPrice(){
    PriceData currentPrice = PriceData.createEmpty();
    double _price = double.maxFinite;
    for (var item in currentService.price) {
      if (item.discPrice != 0){
        if (item.discPrice < _price) {
          _price = item.discPrice;
          currentPrice = item;
        }
      }else
      if (item.price < _price) {
        _price = item.price;
        currentPrice = item;
      }
    }
    if (_price == double.maxFinite)
      _price = 0;
    return currentPrice;
  }

}

