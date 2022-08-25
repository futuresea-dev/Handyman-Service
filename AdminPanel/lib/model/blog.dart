import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:uuid/uuid.dart';
import '../ui/strings.dart';
import 'model.dart';

class MainDataBlog {

  final MainModel parent;
  MainDataBlog({required this.parent});
  BlogData current = BlogData.createEmpty();
  List<BlogData> blog = [];
  String ensureVisible = "";
  HtmlEditorController controller = HtmlEditorController();

  Future<String?> load() async{
    try{
      var querySnapshot = await FirebaseFirestore.instance.collection("blog").orderBy("time", descending: true).get();
      blog = [];
      for (var result in querySnapshot.docs) {
        var _data = result.data();
        var t = BlogData.fromJson(result.id, _data);
        blog.add(t);
      }
      addStat("(admin) blog", blog.length);
    }catch(ex){
      return "MainDataBanner load " + ex.toString();
    }
    return null;
  }

  emptyCurrent(){
    current = BlogData.createEmpty();
    controller.setText("");
    parent.notify();
  }

  select(BlogData _select, bool _load){
    ensureVisible = _select.id;
    current = _select;
    controller.clear();
    if (_load)
      Future.delayed(const Duration(milliseconds: 3000), () {
        controller.setText(getTextByLocale(_select.text, parent.langEditDataComboValue));
      });
    else
      controller.setText(getTextByLocale(_select.text, parent.langEditDataComboValue));

    parent.notify();
  }

  _setText(String _text) async {
    var _found = false;
    for (var item in current.text)
      if (item.code == parent.langEditDataComboValue) {
        item.text = _text;
        _found = true;
      }
    if (!_found)
      current.text.add(StringData(code: parent.langEditDataComboValue, text: _text));
  }

  Future<String?> save(String name, String desc) async {
    var _text = await controller.getText();
    if (name.isEmpty)
      return strings.get(91); /// Please enter name
    if (_text.isEmpty)
      return strings.get(357); /// Please enter text
    if (desc.isEmpty)
      return strings.get(360); /// "Please enter short description",
    if (current.serverPath.isEmpty)
      return strings.get(361); /// Please select preview image
    _setText(_text);
    try{
      var _data = current.toJson();
      if (current.id.isEmpty){
        var t = await FirebaseFirestore.instance.collection("blog").add(_data);
        current.id = t.id;
        blog.add(current);
        await FirebaseFirestore.instance.collection("settings").doc("main")
            .set({"blog_count": FieldValue.increment(1)}, SetOptions(merge:true));
      }else{
        await FirebaseFirestore.instance.collection("blog").doc(current.id).set(_data, SetOptions(merge:true));
      }
    }catch(ex){
      return ex.toString();
    }
    parent.notify();
    return null;
  }

  setName(String val){
    for (var item in current.name)
      if (item.code == parent.langEditDataComboValue) {
        item.text = val;
        return parent.notify();
      }
    current.name.add(StringData(code: parent.langEditDataComboValue, text: val));
    parent.notify();
  }

  setDesc(String val){
    for (var item in current.desc)
      if (item.code == parent.langEditDataComboValue) {
        item.text = val;
        return parent.notify();
      }
    current.desc.add(StringData(code: parent.langEditDataComboValue, text: val));
    parent.notify();
  }

  setImageData(Uint8List _imageData) async {
    try{
      var f = Uuid().v4();
      var name = "blog/$f.jpg";
      // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
      // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
      current.serverPath = await dbSaveFile(name, _imageData);
      current.localFile = name;
      parent.notify();
    } catch (ex) {
      return "blog setImageData " + ex.toString();
    }
    return null;
  }

  Future<String?> delete(BlogData val) async {
    // demo mode
    if (appSettings.demo)
      return strings.get(65); /// "This is Demo Mode. You can't modify this section",
    try{
      await FirebaseFirestore.instance.collection("blog").doc(val.id).delete();
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"blog_count": FieldValue.increment(-1)}, SetOptions(merge:true));
      if (val.id == current.id)
        current = BlogData.createEmpty();
      blog.remove(val);
    }catch(ex){
      return "blog delete " + ex.toString();
    }
    parent.notify();
    return null;
  }

  copy(){
    var text = "";
    for (var item in blog){
      text = "$text${item.id}\t${parent.getTextByLocale(item.name)}"
          "\t${appSettings.getDateTimeString(item.time)}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  csv(){
    List<List> t2 = [];
    t2.add([
      strings.get(114), // "Id",
      strings.get(54), // "Name",
      strings.get(353), // "Date",
    ]);
    for (var item in blog){
      t2.add([item.id, parent.getTextByLocale(item.name),
        appSettings.getDateTimeString(item.time)
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }

}
