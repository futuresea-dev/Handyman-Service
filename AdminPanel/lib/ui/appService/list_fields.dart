import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/model/serviceappsettings.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class ListFields extends StatefulWidget {
  @override
  _ListFieldsState createState() => _ListFieldsState();
}

class _ListFieldsState extends State<ListFields> {

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: (windowWidth/2 < 600) ? 600 : windowWidth/2,
            height: windowHeight,
            decoration: BoxDecoration(
              color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: ListView(
              children: _getList(),
            ),
        ),
        if (_wait)
          Center(child: Container(child: Loader7(color: theme.mainColor,))),
      ],
    );
  }

  _getList(){
    List<Widget> list = [];

    var initList = context.watch<MainModel>().serviceApp.initList;
    if (initList)
      _mainModel.serviceApp.initList = false;

    for (var item in _mainModel.serviceApp.select.fields){
      //
      // Strings
      //
      if (item.typeData == "string"){
        if (initList)
          item.controller.text = item.data;
        list.add(textElement2(item.name, "", item.controller, (String val){
          item.data = val;
          Provider.of<MainModel>(context,listen:false).serviceApp.needRedraw();
        }));
      }
      //
      // bool
      //
      if (item.typeData == "bool") {
        list.add(checkBox1a(context, item.name,
            theme.mainColor, theme.style14W400, item.data == "true",
                (val) {
              if (val == null) return;
              item.data = val ? "true" : "false";
              Provider.of<MainModel>(context, listen: false).serviceApp.needRedraw();
              setState(() {});
            }));
      }
      //
      // color
      //
      if (item.typeData == "color"){
        list.add(Row(
          children: [
            SelectableText(item.name, style: theme.style14W400,),
            SizedBox(width: 10,),
            Container(
              width: 150,
              child: ElementSelectColor(getColor: (){return item.color;}, setColor: (Color val){
                item.color = val;
                Provider.of<MainModel>(context,listen:false).serviceApp.needRedraw();
                setState(() {
                });
              },),
              )
          ],
        ));
      }
      //
      // selectImage
      //
      if (item.typeData == "selectImage"){
        list.add(Row(
          children: [
            SelectableText(item.name, style: theme.style14W800,),
            SizedBox(width: 30,),
            Expanded(child: checkBox1a(context, strings.get(211), /// "default image",
              theme.mainColor, theme.style14W400, item.value,
                  (val) {
                if (val == null) return;
                item.value = val;
                Provider.of<MainModel>(context, listen: false).serviceApp.needRedraw();
                setState(() {});
              })),
            Expanded(child: button2b(strings.get(75), (){_selectImage(item);})) /// "Select image",
          ],
        ));
      }
      list.add(SizedBox(height: 5,));
    }
    list.add(SizedBox(height: 20,));
    if (_mainModel.serviceApp.select.fields.isNotEmpty)
      list.add(Row(
        children: [
          button2b(strings.get(9), _saveAll), /// "Save",
        ],
      ));

    if (_mainModel.serviceApp.select.strings.isNotEmpty){
      list.add(SizedBox(height: 10,));
      list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Text(strings.get(105), style: theme.style16W800,),           /// "Words in screen",
          SizedBox(width: 20,),
          if (!isMobile())
            Text(strings.get(108), style: theme.style14W400,),          /// "Select language",
          if (!isMobile())
            Expanded(child: Container(
              width: 120,
              child: Combo(inRow: true, text: "",
                data: _mainModel.emulatorServiceDataCombo,
                value: _mainModel.editLangNowDataComboValue,
                onChange: (String value) async {
                  await Provider.of<MainModel>(context,listen:false).setLang(value);
                  // Provider.of<MainDataModel>(context,listen:false).langs.setEmulatorLang(value);
                  setState(() {
                  });
                },))),
        ],
      ));
      if (isMobile()){
        list.add(Row(
          children: [
            Text(strings.get(108), style: theme.style14W400,),          /// "Select language",
            Expanded(child: Container(
                width: 120,
                child: Combo(inRow: true, text: "",
                  data: _mainModel.emulatorServiceDataCombo,
                  value: _mainModel.editLangNowDataComboValue,
                  onChange: (String value) async {
                    await Provider.of<MainModel>(context,listen:false).setLang(value);
                    // Provider.of<MainDataModel>(context,listen:false).langs.setEmulatorLang(value);
                    setState(() {
                    });
                  },))),
          ],
        ));
      }

      list.add(SizedBox(height: 10,));
      //
      var _listWordsForEdit = Provider.of<MainModel>(context,listen:false).listWordsForEdit;
      for (var item in _mainModel.serviceApp.select.strings){
        for (var item2 in _listWordsForEdit)
          if (item2.id == item.id) {
            item.data = item2.word;
            //print("------------------------------------> item2.controller=${item2.controller}");
            list.add(textElement2("string ${item.id}", "", item2.controller, (String val){
              Provider.of<MainModel>(context,listen:false).serviceApp.emulatorSetWord(item, val);
            }));
            list.add(SizedBox(height: 5,));
            break;
          }
        //print("------------------------------------> item.controller=${item.controller}");
      }

      list.add(SizedBox(height: 20,));
      list.add(Row(
        children: [
          button2b(strings.get(212), _save), /// "Save words",
        ],
      ));
    }
    return list;
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _save() async {
    if (appSettings.demo)
      return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
    _waits(true);
    var ret = await Provider.of<MainModel>(context,listen:false).langs.saveLanguageWords();
    if (ret == null)
      messageOk(context, "${strings.get(185)} ${_mainModel.editLangNowDataComboValue}"); /// "Data saved for language: ",
    else
      messageError(context, ret);
    _waits(false);
  }

  _selectImage(Field item) async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      messageError(context, e.toString());
    }
    if (pickedFile != null){
      _waits(true);
      var ret = await Provider.of<MainModel>(context,listen:false).setImageData(item, await pickedFile.readAsBytes());
      _waits(false);
      if (ret == null)
        messageOk(context, strings.get(363)); /// "Image saved",
      else
        messageError(context, ret);
    }
  }

  _saveAll() async {
    // if (appSettings.demo)
    //   return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
    _waits(true);
    var ret = await Provider.of<MainModel>(context,listen:false).serviceApp.saveEmulatorServiceAppData();
    if (ret == null)
    messageOk(context, strings.get(81)); /// "Data saved",
    else
    messageError(context, ret);
    _waits(false);
  }
}