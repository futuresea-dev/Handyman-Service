import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'dart:html';
import 'package:universal_html/html.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  double windowWidth = 0;
  double windowHeight = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      window.history.pushState("1", "title", null);
      Navigator.pushNamed(context, "/main");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return  WillPopScope(
        onWillPop: () async {
      dprint("WillPopScope start");
      return false;
    },
    child: button2b("go", (){
      window.history.pushState("1", "2", null);
      Navigator.pushNamed(context, "/main");
    }));
  }
}
