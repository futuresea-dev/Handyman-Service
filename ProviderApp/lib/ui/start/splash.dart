import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/model/model.dart';
import 'package:provider/provider.dart';
import '../lang.dart';
import '../strings.dart';
import '../theme.dart';

class OnDemandSplashScreen extends StatefulWidget {
  @override
  _OnDemandSplashScreenState createState() => _OnDemandSplashScreenState();
}

class _OnDemandSplashScreenState extends State<OnDemandSplashScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  bool _loaded = false;
  bool _startLoaded = false;
  late MainModel _mainModel;

  _startNextScreen(){
    if (_loaded) {
      if (!_startLoaded) {
        _startLoaded = true;
        Navigator.pop(context);
        if (localSettings.locale.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LanguageScreen(openLogin: true),
            ),
          );
        }else {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null)
            Navigator.pushNamed(context, "/ondemand_main");
          else
            Navigator.pushNamed(context, "/ondemand_login");
        }
      }
    }
  }

  @override
  void dispose() {
    dprint("splash dispose");
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context, listen: false);
    _load();
    super.initState();
    startTime();
  }

  _load() async {
    var ret = await _mainModel.init(context);
    if (ret != null) {
      messageError(context, ret);
      startTime();
      _loaded = true;
      return;
    }
    dprint("SplashScreen");
    _loaded = true;
    _startNextScreen();
  }

  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, _startNextScreen);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
          children: <Widget>[

          Container(color: (theme.darkMode) ? Colors.black : theme.colorBackground),

          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: windowWidth*0.3,
                    height: windowWidth*0.3,
                    child: localSettings.logo.isEmpty ? Image.asset("assets/ondemand/ondemand1.png", fit: BoxFit.contain)
                      : CachedNetworkImage(
                        imageUrl: localSettings.logo,
                        imageBuilder: (context, imageProvider) =>
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                          ),
                        )
                    ),)
                  ),
                  SizedBox(height: 20,),
                  Text(strings.get(1), // "PROVIDER",
                      style: theme.style10W600Grey),
                  SizedBox(height: 20,),
                  Loader7v1(color: Color(0xff1c7bab))
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child:     UnconstrainedBox(
                  child: Container(
                      width: windowWidth,
                      height: windowWidth/2,
                      child: Image.asset("assets/ondemand/ondemand2.png",
                          fit: BoxFit.cover
                      )
                  )),
            )

          ],
        )

    );
  }

}


