import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:abg_utils/abg_utils.dart';

class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {

  final _controllerGooglePlayLink = TextEditingController();
  final _controllerAppStoreLink = TextEditingController();

  @override
  void initState() {
    _controllerGooglePlayLink.text = appSettings.googlePlayLink;
    _controllerAppStoreLink.text = appSettings.appStoreLink;
    super.initState();
  }

  @override
  void dispose() {
    _controllerGooglePlayLink.dispose();
    _controllerAppStoreLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body(strings.get(42), "assets/dashboard2/dashboard5.png", _getList()); /// "Settings | Share This App Menu",
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(textElement(strings.get(43), "", _controllerGooglePlayLink)); // Google Play Link
    list.add(SizedBox(height: 20,));
    list.add(textElement(strings.get(44), "", _controllerAppStoreLink)); // AppStore Link

    list.add(SizedBox(height: 50,));
    list.add(Center(child: button2b(strings.get(9), _save))); // "Save"

    list.add(SizedBox(height: 100,));

    return list;
  }

  _save() async {
    waitInMainWindow(true);
    var ret = await saveSettingsShare(_controllerGooglePlayLink.text, _controllerAppStoreLink.text);
    if (ret == null)
      messageOk(context, strings.get(81)); /// "Data saved",
    else
      messageError(context, ret);
    waitInMainWindow(false);
  }
}


