import 'package:abg_utils/abg_utils.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import '../ui/strings.dart';
import 'model.dart';

class MainDataProvider with DiagnosticableTreeMixin {
  final MainModel parent;
  MainDataProvider({required this.parent});

  List<UserData> providersRequest = [];
  UserData? newProvider;

  List<ComboData> providersCombo = [];
  String providersComboValue = "1";

  List<ComboData> providersComboForProducts = [];
  String providersComboValueForProduct = "";

  List<ComboData> providersComboForProductsSort = [];
  String providersComboValueForProductSort = "";

  List<ComboData> providersComboForService = [];
  String providersComboValueForService = "";

  Future<String?> load() async{
    try{
      loadProvider((){
        providersComboValue = "1";
        providersCombo = [];
        providersCombo.add(ComboData(strings.get(254), "1")); /// "All"

        providersComboValueForProduct = "root";
        providersComboForProducts = [];
        providersComboForProducts.add(ComboData(strings.get(424), "root")); /// "Global (owner) item"

        providersComboForProductsSort = [];
        providersComboValueForProductSort = "all";
        providersComboForProductsSort.add(ComboData(strings.get(254), "all")); /// "All"
        providersComboForProductsSort.add(ComboData(strings.get(424), "root")); /// "Global (owner) item"

        providersComboForService = [];
        providersComboForService.add(ComboData(strings.get(221), "1")); /// "Please select provider",
        providersComboValueForService = "1";

        for (var item in providers){
          providersCombo.add(ComboData(getTextByLocale(item.name, strings.locale), item.id));
          providersComboForProducts.add(ComboData(getTextByLocale(item.name, strings.locale), item.id));
          providersComboForProductsSort.add(ComboData(getTextByLocale(item.name, strings.locale), item.id));
          providersComboForService.add(ComboData(getTextByLocale(item.name, strings.locale), item.id));
        }
        if (currentScreen() == "booking" && parent.providerSortFilter != null)
          parent.providerSortFilter!(null);
        redrawMainWindow();
      });
    }catch(ex){
      return "MainDataProvider load " + ex.toString();
    }
    return null;
  }

  Function(List<gm.LatLng>)? _callbackChangeMap;

  getArea(Function(List<gm.LatLng>) callback){
    _callbackChangeMap = callback;
    List<gm.LatLng> _area = [];

    for (var item in currentProvider.route)
      _area.add(gm.LatLng(item.latitude, item.longitude));

    return callback(_area);
  }

  Future<String?> loadRequest() async{
    try{
      var querySnapshot = await FirebaseFirestore.instance.collection("listusers").
          where("providerRequest", isEqualTo: true).get();
      providersRequest = [];
      addStat("(admin) provider Request", querySnapshot.docs.length);
      for (var result in querySnapshot.docs) {
        var _data = result.data();
        //print("Provider Request $_data");
        var t = UserData.fromJson(result.id, _data);
        providersRequest.add(t);
      }
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"provider_new_request_count": 0}, SetOptions(merge:true));
    }catch(ex){
      return "MainDataProvider loadRequest " + ex.toString();
    }
    return null;
  }

  Future<String?> deleteRequest(UserData val) async {
    try{
      await FirebaseFirestore.instance.collection("listusers").doc(val.id)
          .set({"providerRequest": false}, SetOptions(merge:true));
      providersRequest.remove(val);
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"provider_request_count": FieldValue.increment(-1)}, SetOptions(merge:true));
    }catch(ex){
      return "MainDataProvider deleteRequest " + ex.toString();
    }
    parent.notify();
    return null;
  }

  articleCopy(){
    var text = "";
    for (var item in productDataCache){
      text = "$text${item.id}\t${item.visible}\t${getTextByLocale(item.name, strings.locale)}\t"
      "${getPriceString(item.price)}\t${getPriceString(item.discPrice)}\t"
      "${item.providers.isNotEmpty ? getProviderNameById(item.providers[0], locale) : strings.get(424)}\t" /// "Global (owner) item",
      "${item.stock}\t${appSettings.getDateTimeString(item.timeModify)}\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String articleCsv(){
    List<List> t2 = [];
    t2.add([
      strings.get(114), /// "Id",
      strings.get(70), /// "Visible",
      strings.get(54), /// "Name",
      strings.get(144), /// "Price",
      strings.get(145), /// "Discount price",
      strings.get(178), /// "Provider
      strings.get(446), /// In Stock
      strings.get(450), /// Last Time Modify
    ]);
    for (var item in productDataCache){
      t2.add([item.id, item.visible, getTextByLocale(item.name, strings.locale),
        getPriceString(item.price),
        getPriceString(item.discPrice),
        item.providers.isNotEmpty ? getProviderNameById(item.providers[0], locale) : strings.get(424), /// "Global (owner) item",
        item.stock,
        appSettings.getDateTimeString(item.timeModify),
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

  createNewProvider(UserData val){
    newProvider = val;
    currentProvider = ProviderData.createEmpty();
    currentProvider.login = val.email;
    currentProvider.phone = val.phone;
    currentProvider.desc = [StringData(code: parent.langEditDataComboValue, text: val.providerDesc)];
    currentProvider.address = val.providerAddress;
    currentProvider.route = val.providerWorkArea;
    currentProvider.name = [StringData(code: parent.langEditDataComboValue, text: val.providerName)];
    currentProvider.logoServerPath = val.providerLogoServerPath;
    currentProvider.logoLocalFile = val.providerLogoLocalFile;
    currentProvider.category = val.providerCategory;
  }

  select(ProviderData select){
    currentProvider = select;
    if (_callbackChangeMap != null)
      getArea(_callbackChangeMap!);
  }

  //
  // Open Close Time
  //
  String weekDataComboValue = "1";
  List<ComboData> weekDataCombo = [
    ComboData(strings.get(134), "0"), // "Monday",
    ComboData(strings.get(135), "1"), // "Tuesday",
    ComboData(strings.get(136), "2"), // "Wednesday",
    ComboData(strings.get(137), "3"), // "Thursday",
    ComboData(strings.get(138), "4"), // "Friday",
    ComboData(strings.get(139), "5"), // "Saturday",
    ComboData(strings.get(140), "6"), // "Sunday",
  ];

  Future<String?> createPayout(ProviderData _provider, double total, String text) async {
    try{
      var _data = {
        "providerId": _provider.id,
        "providerName": _provider.name.map((i) => i.toJson()).toList(),
        "total": total,
        "comment": text,
        "time": FieldValue.serverTimestamp()
      };
      var ret = await FirebaseFirestore.instance.collection("payout").add(_data);
      _data["time"] = "";
      payout.add(PayoutData.fromJson(ret.id, _data));
    }catch(ex){
      return "MainDataProvider createPayout " + ex.toString();
    }
    parent.notify();
    return null;
  }

  copyEarning(){
    var text = "";
    for (var item in providers){
      EarningData _data = EarningData();
      var _items = getEarningData(item);
      if (_items.isNotEmpty)
        _data = _items.last;
      text = "$text${parent.getTextByLocale(item.name)}\t${_data.count}\t${getPriceString(_data.total)}"
          "\t${getPriceString(_data.admin)}\t${getPriceString(_data.provider)}"
          "\t${getPriceString(_data.tax)}\t${getPriceString(_data.payout)}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  copyEarningDetails(ProviderData _detailItem){
    List<EarningData> items = getEarningData(_detailItem);
    var text = "";
    for (var _data in items){
      text = "$text${_data.id}"
          "\t${getPriceString(_data.total)}\t${getPriceString(_data.admin)}"
          "\t${getPriceString(_data.provider)}"
          "\t${getPriceString(_data.tax)}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csvEarningDetails(ProviderData _detailItem){
    List<EarningData> items = getEarningData(_detailItem);
    List<List> t2 = [];
    t2.add([
      strings.get(114), // "Id",
      strings.get(177), // "Total",
      strings.get(268), // "Admin",
      strings.get(178), // "Provider",
      strings.get(130), // "Tax",
    ]);
    for (var _data in items){
      t2.add([_data.id, getPriceString(_data.total),
        getPriceString(_data.admin), getPriceString(_data.provider),
        getPriceString(_data.tax),
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

  String csvEarning(){
    List<List> t2 = [];
    t2.add([
      strings.get(178), // "Provider",
      strings.get(264), // "Bookings",
      strings.get(177), // "Total",
      strings.get(268), // "Admin",
      strings.get(178), // "Provider",
      strings.get(130), // "Tax",
      strings.get(269), // "To payout",
    ]);
    for (var item in providers){
      EarningData _data = EarningData();
      var _items = getEarningData(item);
      if (_items.isNotEmpty)
        _data = _items.last;
      t2.add([parent.getTextByLocale(item.name), _data.count, getPriceString(_data.total),
        getPriceString(_data.admin), getPriceString(_data.provider),
        getPriceString(_data.tax), getPriceString(_data.payout)
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

  copyPayouts(){
    var text = "";
    for (var item in payout){
      text = "$text${parent.getTextByLocale(item.providerName)}\t${appSettings.getDateTimeString(item.time)}"
          "\t${getPriceString(item.total)}\t${item.comment}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csvPayouts(){
    List<List> t2 = [];
    t2.add([
      strings.get(178), // "Provider",
      strings.get(273), // "Time",
      strings.get(177), // "Total",
      strings.get(180), // "Comment",
    ]);
    for (var item in payout){
      t2.add([parent.getTextByLocale(item.providerName), appSettings.getDateTimeString(item.time),
      getPriceString(item.total), item.comment
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

  copy(){
    var text = "";
    for (var item in providers){
      text = "$text${item.id}\t${parent.getTextByLocale(item.name)}"
          "\t${item.phone}\t${item.www}\t${item.instagram}\t${item.telegram}"
          "\t${item.address}\t${item.tax}%"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csv(){
    List<List> t2 = [];
    t2.add([
      strings.get(114), // "Id",
      strings.get(54), // "Name",
      strings.get(124), // "Phone",
      strings.get(125), // "Web Page",
      strings.get(127), // "Instagram",
      strings.get(126), // "Telegram",
      strings.get(97), // "Address",
      strings.get(130), // "Tax",
    ]);
    for (var item in providers){
      t2.add([item.id, parent.getTextByLocale(item.name), item.phone,
        item.www, item.instagram, item.telegram, item.address, "${item.tax}%"
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

  copyRequest(){
    var text = "";
    for (var item in providersRequest){
      text = "$text${item.name}\t${item.email}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csvRequest(){
    List<List> t2 = [];
    t2.add([
      strings.get(54), // "Name",
      strings.get(86), // "Email",
    ]);
    for (var item in providersRequest){
      t2.add([item.name, item.email,
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

}



