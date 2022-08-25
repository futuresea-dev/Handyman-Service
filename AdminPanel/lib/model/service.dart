import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ui/strings.dart';
import 'model.dart';

class MainDataService {

  final MainModel parent;

  MainDataService({required this.parent});

  //
  // PROVIDERS
  //
  changeProvider(){
    currentProduct.providers = [];
    for (var item in providers)
      if (item.select)
        currentProduct.providers.add(item.id);
  }

  String serviceSelected = "-1";
  List<ComboData> serviceData = [];

  Future<String?> load(BuildContext context) async{
    initService("all", "", (){
      serviceData = [];
      serviceData.add(ComboData(strings.get(254), "-1"));  // "All"
      _setCategoryAndProvider();
      if (parent.serviceSortFilter != null)
        parent.serviceSortFilter!(null);
      redrawMainWindow();
    });
    return null;
  }

  _setCategoryAndProvider(){
    for (var item in categories) {
      item.select = false;
      for (var item2 in currentProduct.category)
        if (item2 == item.id)
          item.select = true;
    }
    for (var item in providers) {
      item.select = false;
      for (var item2 in currentProduct.providers)
        if (item2 == item.id)
          item.select = true;
    }
  }

  //
  // PRICE
  //
  PriceData getPrice(){
    PriceData currentPrice = PriceData.createEmpty();
    double _price = double.maxFinite;
    for (var item in currentProduct.price) {
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

  List<ComboData> priceUnitCombo = [
    ComboData(strings.get(149), "hourly"),
    ComboData(strings.get(150), "fixed"),
  ];
  String priceUnitComboValue = "hourly";

  emptyCurrent(){
    currentProduct = ProductData.createEmpty();
    _setCategoryAndProvider();
    if (parent.initEditorInServiceScreen != null)
      parent.initEditorInServiceScreen!();
    redrawMainWindow();
  }

  select(ProductData select){
    currentProduct = select;
    _setCategoryAndProvider();
    if (parent.initEditorInServiceScreen != null)
      parent.initEditorInServiceScreen!();
    redrawMainWindow();
  }

  copy(){
    var text = "";
    for (var item in product){
      text = "$text${item.id}\t${parent.getTextByLocale(item.name)}"
          "\t${parent.getTextByLocale(item.desc)}"
          "\t${getPriceString(item.tax)}\t${getPriceString(item.taxAdmin)}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csv(){
    List<List> t2 = [];
    t2.add([
      strings.get(114), /// "Id",
      strings.get(54), /// "Name",
      strings.get(73), /// "Description",
      strings.get(130), /// "Tax",
      strings.get(266), /// "Tax for administration",
    ]);
    for (var item in product){
      t2.add([item.id, parent.getTextByLocale(item.name),
      parent.getTextByLocale(item.desc), getPriceString(item.tax),
      getPriceString(item.taxAdmin)
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

  String getServiceMinPrice(ProductData item){
    double _price = double.maxFinite;
    for (var item in item.price) {
      if (item.discPrice != 0){
        if (item.discPrice < _price) {
          _price = item.discPrice;
        }
      }else
      if (item.price < _price)
        _price = item.price;
    }
    if (_price == double.maxFinite)
      _price = 0;
    return getPriceString(_price);
  }

  getPriceString(double price){
    if (appSettings.rightSymbol) {
      // dprint("getPriceString $price ${price.toStringAsFixed(2)}");
      // var t = price.toStringAsFixed(2);
      return "${appSettings.symbol}${price.toStringAsFixed(appSettings.digitsAfterComma)}";
    }
    return "${price.toStringAsFixed(appSettings.digitsAfterComma)}${appSettings.symbol}";
  }

  Future<String?> saveInMainScreenServices() async{
    appSettings.inMainScreenServices = [];
    for (var item in product)
      if (item.select)
        appSettings.inMainScreenServices.add(item.id);
    //
    try{
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"inMainScreenServices": appSettings.inMainScreenServices}, SetOptions(merge:true));
    }catch(ex){
      return "MainDataService saveInMainScreenServices " + ex.toString();
    }
    parent.notify();
    return null;
  }

  List<AddonData>? getProviderAddons(){
    if (currentProduct.providers.isNotEmpty)
      for (var item in providers)
        if (item.id == currentProduct.providers[0])
          return item.addon;
    return null;
  }

}

ProductData currentTestService = ProductData("1",
  [StringData(code: "en", text: "Carpet shampooing")],
  tax: 10,
  descTitle: [StringData(code: "en", text: "Description")],
  desc: [StringData(code: "en", text: "asta la vista ... ")],
  visible: true,
  price: [PriceData([StringData(code: "en", text: "Carpet shampooing Hi")], 20, 10, "fixed", ImageData())],
  gallery: [],
  duration: Duration(minutes: 20),
  category: [],
  providers: [],
  rating1: 0,
  rating2: 0,
  rating3: 4,
  rating4: 3,
  rating5: 3,
  countRating: 2,
  rating: 4,
  addon: [],
  timeModify: DateTime.now(), group: [],
);

