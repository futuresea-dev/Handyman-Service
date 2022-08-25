import 'package:abg_utils/abg_utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mainModel/model.dart';
import 'strings.dart';
import '../theme.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Column(children: _getList());
  }


  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    var _text = strings.get(27); /// "Privacy Policy",
    if (_mainModel.openDocument == "about")
      _text = strings.get(28); /// "About Us",
    if (_mainModel.openDocument == "terms")
      _text = strings.get(29); /// "Terms & Conditions",

      var _data = appSettings.policy;
    if (_mainModel.openDocument == "about")
      _data = appSettings.about;
    if (_mainModel.openDocument == "terms")
      _data = appSettings.terms;

    list.add(Text(_text, style: theme.style18W800,));
    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.all(15),
      child: Html(
          data: "<body>$_data",
          style: {
            "body": Style(
                backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
                color: (theme.darkMode) ? Colors.white : Colors.black
            ),
          }
      ),
    ));

    return list;
  }

}
