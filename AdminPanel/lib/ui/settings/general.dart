import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/ui/strings.dart';
import '../../model/model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final _controllerMapApi = TextEditingController();
  final _controllerMessageKey = TextEditingController();
  final _controllerComission = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPhone = TextEditingController();
  late MainModel _mainModel;

  @override
  void dispose() {
    _controllerComission.dispose();
    _controllerMapApi.dispose();
    _controllerMessageKey.dispose();
    _controllerEmail.dispose();
    _controllerPhone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _controllerMapApi.text = appSettings.googleMapApiKey;
    _controllerMessageKey.text = appSettings.cloudKey;
    _controllerPhone.text = appSettings.adminPhone;
    _controllerEmail.text = appSettings.adminEmail;
    if (appSettings.defaultAdminComission != 0)
      _controllerComission.text = appSettings.defaultAdminComission.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return body(strings.get(28), "assets/dashboard2/dashboard2.png", _getList()); /// "Settings | General",
  }

  _getList() {
    List<Widget> list = [];

    if (isMobile()) {
      list.add(SizedBox(height: 20,));
      list.add(Combo(text: strings.get(30), // "Default unit of distance:",
        data: _mainModel.distData, value: appSettings.distanceUnit,
        onChange: (String value){appSettings.distanceUnit = value; setState(() {});},));
      list.add(SizedBox(height: 20,));
      list.add(Combo(text: strings.get(39), // "Time Format:",
        data: _mainModel.timeFormatData,
        value: appSettings.timeFormat,
        onChange: (String value){appSettings.timeFormat = value; setState(() {});},));
      list.add(Combo(text: strings.get(45), // "Date Format:",
        data: _mainModel.dateFormatData,
        value: appSettings.dateFormat,
        onChange: (String value){appSettings.dateFormat = value; setState(() {});},));
    }else{
      // list.add(Row(
      //   children: [
      //     Expanded(child: textElement(strings.get(29), "", _controllerName)), // "App Name:",
      //     SizedBox(width: 20,),
      //     Expanded(child: Combo(text: strings.get(30), // "Default unit of distance:",
      //       data: _mainModel.distData, value: appSettings.distanceUnit,
      //       onChange: (String value){appSettings.distanceUnit = value; setState(() {});},))
      // ]));
      list.add(SizedBox(height: 10,));
      list.add(Row(
          children: [
            Expanded(child: Combo(text: strings.get(39), // "Time Format:",
              data: _mainModel.timeFormatData,
              value: appSettings.timeFormat,
              onChange: (String value){appSettings.timeFormat = value; setState(() {});},)),
            SizedBox(width: 20,),
            Expanded(child: Combo(text: strings.get(45), // "Date Format:",
              data: _mainModel.dateFormatData,
              value: appSettings.dateFormat,
              onChange: (String value){appSettings.dateFormat = value; setState(() {});},))
          ]));
    }

    if (isMobile())
      list.add(textElement(strings.get(46), "", _controllerMapApi)); // "Google Maps Api Key:"
    else{
      list.add(Row(
        children: [
          Expanded(
              child: textElement(strings.get(46), "", _controllerMapApi) // "Google Maps Api Key:"
          ),
          SizedBox(width: 20,),
          Expanded(child: Combo(text: strings.get(30), /// "Default unit of distance:",
            data: _mainModel.distData, value: appSettings.distanceUnit,
            onChange: (String value){appSettings.distanceUnit = value; setState(() {});},))
        ],
      ));
    }
    list.add(textElement(strings.get(47), "", _controllerMessageKey)); // "Firebase Cloud Messaging Key:"

    list.add(SizedBox(height: 10,));
    if (isMobile())
      list.add(numberElement2Percentage(strings.get(358), "10", _controllerComission, (String _ ){})); /// Default Admin Commission
    else{
      list.add(Row(
        children: [
          Expanded(
            child:  numberElement2Percentage(strings.get(358), "10", _controllerComission, (String _ ){}) /// Default Admin Commission
          ),
          SizedBox(width: 20,),
          Expanded(child: Container())
        ],
      ));
    }

    if (isMobile()){
      list.add(textElement(strings.get(470) + ":", "", _controllerEmail)); /// "Administration Email"
      list.add(SizedBox(height: 10,));
      list.add(textElement(strings.get(471) + ":", "", _controllerPhone)); /// "Administration Phone"
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(470), "", _controllerEmail)), /// "Administration Email"
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(471), "", _controllerPhone)), /// "Administration Phone"
        ],
      ));
    }

    list.add(SizedBox(height: 50,));
    list.add(Center(child: button2b(strings.get(9), _save))); // "Save"
    list.add(SizedBox(height: 100,));

    return list;
  }

  _save() async {
    waitInMainWindow(true);
    var ret = await settingsSaveGeneral(_controllerMapApi.text, _controllerMessageKey.text,
        _controllerComission.text, _controllerEmail.text, _controllerPhone.text);
    if (ret == null)
      messageOk(context, strings.get(81)); /// "Data saved",
    else
      messageError(context, ret);
    waitInMainWindow(false);
  }
}


