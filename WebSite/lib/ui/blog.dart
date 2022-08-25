import 'package:abg_utils/abg_utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mainModel/model.dart';
import 'strings.dart';
import '../theme.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {

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

    list.add(Text(getTextByLocale(_mainModel.openBlog!.name, strings.locale), style: theme.style18W800,));
    list.add(SizedBox(height: 10,));


    list.add(Text(timeago.format(_mainModel.openBlog!.time, locale: appSettings.currentServiceAppLanguage),
        overflow: TextOverflow.ellipsis, style: theme.style10W600Grey));

    list.add(Html(
      data: "<body>${getTextByLocale(_mainModel.openBlog!.text, strings.locale)}",
      style: {
      "body": Style(
      backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
      color: (theme.darkMode) ? Colors.white : Colors.black
      ),
      }
    ));
    list.add(SizedBox(height: 200,));

    return list;
  }

}
