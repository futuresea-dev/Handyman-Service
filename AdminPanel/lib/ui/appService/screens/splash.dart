import 'package:abg_utils/abg_utils.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'strings.dart';
import 'theme.dart';

class SplashScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const SplashScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double windowWidth = 0;
  double windowHeight = 0;

  _startNextScreen(){
    // Navigator.pop(context);
    // Navigator.pushNamed(context, "/ondemandservice_lang");
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, _startNextScreen);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Scaffold(
        body: Stack(
          children: <Widget>[

            Container(color: (darkMode) ? Colors.black : serviceApp.colorBackground),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: windowWidth*0.3,
                    height: windowWidth*0.3,
                    child: serviceApp.logoAsset ? Image.asset("assets/ondemands/ondemand1.png", fit: BoxFit.contain) :
                      Image.network(
                          serviceApp.logo,
                        fit: BoxFit.cover)
                  ),
                  SizedBox(height: 20,),
                  Text(strings.get(0),                                /// "HANDYMAN",
                      style: theme.style16W800),
                  SizedBox(height: 5,),
                  Text(strings.get(1),                                /// "SERVICE",
                      style: theme.style10W600Grey),
                  SizedBox(height: 20,),
                  Loader7(color: serviceApp.splashColor)
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: UnconstrainedBox(
                  child: Container(
                      width: windowWidth,
                      height: windowWidth/2,
                      child: serviceApp.splashImageAsset ?
                      Image.asset("assets/ondemands/ondemand2.png",
                          fit: BoxFit.cover
                      ) :
                      Image.network(
                          serviceApp.splashImage,
                          fit: BoxFit.cover)
                  )),
            )

          ],
        )

    );
  }



}


