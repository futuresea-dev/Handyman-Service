import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../ui/strings.dart';
import 'model.dart';

class MainDataBanner with DiagnosticableTreeMixin {
  final MainModel parent;
  MainDataBanner({required this.parent});
  List<BannerData> banners = [];
  BannerData current = BannerData.createEmpty();
  List<ComboData> bannerTypeData = [
    ComboData(strings.get(330), "service"), /// "Open service",
    ComboData(strings.get(331), "provider"), /// "Open provider",
    ComboData(strings.get(332), "category"), /// "Open category",
  ];
  String ensureVisible = "";
  var dataKey = GlobalKey();

  Future<String?> load() async{
    try{
      var querySnapshot = await FirebaseFirestore.instance.collection("banner").get();
      banners = [];
      for (var result in querySnapshot.docs) {
        var _data = result.data();
        // print("Banner $_data");
        var t = BannerData.fromJson(result.id, _data);
        banners.add(t);
      }
      addStat("(admin) banner", banners.length);
    }catch(ex){
      return "MainDataBanner load " + ex.toString();
    }
    return null;
  }

  setVisible(bool val){
    current.visible = val;
    dataKey = GlobalKey();
    parent.notify();
  }

  setName(String val){
    current.name = val;
    parent.notify();
  }

  setType(String value){
    current.type = value;
    parent.notify();
  }

  Future<String?> save() async {
    try{
      var _data = current.toJson();
      await FirebaseFirestore.instance.collection("banner").doc(current.id).set(_data, SetOptions(merge:true));
    }catch(ex){
      return "MainDataBanner save " + ex.toString();
    }
    parent.notify();
    return null;
  }

  Future<String?> create() async {
    try{
      var _data = current.toJson();
      var t = await FirebaseFirestore.instance.collection("banner").add(_data);
      current.id = t.id;
      banners.add(current);
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"banners_count": FieldValue.increment(1)}, SetOptions(merge:true));
    }catch(ex){
      return "MainDataBanner create " + ex.toString();
    }
    dataKey = GlobalKey();
    parent.notify();
    return null;
  }

  emptyCurrent(){
    current = BannerData.createEmpty();
    parent.notify();
  }

  setImageData(Uint8List _imageData) async {
    try{
      var f = Uuid().v4();
      var name = "banner/$f.jpg";
      // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
      // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
      current.serverImage = await dbSaveFile(name, _imageData);
      current.localImage = name;
      parent.notify();
    } catch (e) {
      return "MainDataBanner setImageData " + e.toString();
    }
    return null;
  }

  select(BannerData _selectInEmulator){
    ensureVisible = _selectInEmulator.id;
    current = _selectInEmulator;
    parent.notify();
  }

  Future<String?> delete(BannerData val) async {
    try{
      await FirebaseFirestore.instance.collection("banner").doc(val.id).delete();
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"banners_count": FieldValue.increment(-1)}, SetOptions(merge:true));
      if (val.id == current.id)
        current = BannerData.createEmpty();
      banners.remove(val);
      dataKey = GlobalKey();
    }catch(ex){
      return "MainDataBanner delete " + ex.toString();
    }
    parent.notify();
    return null;
  }

  copy(){
    var text = "";
    for (var item in banners){
      text = "$text${item.id}\t${item.name}"
          "\t${item.type}\t${item.visible ? strings.get(70) : strings.get(336)}" /// visible - hidden
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csv(){
    List<List> t2 = [];
    t2.add([
      strings.get(114), // "Id",
      strings.get(54), // "Name",
      strings.get(329), // "Banner type",
      strings.get(70), // visible
    ]);
    for (var item in banners){
      t2.add([item.id,
        item.name,
        item.type,
        item.visible ? strings.get(70) : strings.get(336) /// visible - hidden
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }
}

