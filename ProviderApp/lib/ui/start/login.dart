import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _editControllerEmail = TextEditingController();
  final _editControllerPassword = TextEditingController();

  @override
  void dispose() {
    _editControllerEmail.dispose();
    _editControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[


            ListView(
              children: [
                ClipPath(
                    clipper: ClipPathClass23(20),
                    child: Container(
                      color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
                      width: windowWidth,
                      height: windowHeight/2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: windowHeight*0.1,),
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
                                  ),),
                          ),
                          SizedBox(height: 20,),
                          Text(strings.get(1), // "PROVIDER",
                              style: theme.style10W600Grey),
                          SizedBox(height: 20,),
                          Expanded(child: Container(
                              width: windowWidth,
                              // height: windowWidth/2,
                              child: Image.asset("assets/ondemand/ondemand2.png",
                                  fit: BoxFit.cover
                              ))
                          )
                        ],
                      ),
                    )),

                Container(
                  // margin: EdgeInsets.only(top: windowHeight*0.5),
                  height: windowHeight*0.5,
                  color: (theme.darkMode) ? Colors.black : Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Text(strings.get(6), // "Sign in now",
                            style: theme.style16W800,
                          ),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: edit42(strings.get(7), /// "Email",
                              _editControllerEmail,
                              strings.get(8), // "Enter your Email",
                              type: TextInputType.emailAddress),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Edit43(
                              text: strings.get(9), // "Password",
                              controller: _editControllerPassword,
                              hint: strings.get(10), // "Enter your Password",
                              ),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: button2(strings.get(11), // "CONTINUE",
                              theme.mainColor, (){_login();}, style: theme.style16W800White, radius: 50),
                        ),

                        SizedBox(height: 10,),
                        button134(strings.get(182), /// "Forgot password?",
                                (){
                                  Navigator.pushNamed(context, "/forgot");
                            }, style: theme.style14W400),
                        SizedBox(height: 10,),

                        Container(
                          margin: EdgeInsets.all(20),
                          child: button2(strings.get(12), // "REGISTER",
                              theme.mainColor, (){_register();}, style: theme.style16W800White, radius: 50),
                        ),
                        //
                        // Center(
                        //   child: Text(strings.get(13), // "or continue with",
                        //       style: theme.style14W600Grey),
                        // ),
                        //
                        // SizedBox(height: 10,),
                        //
                        // Container(
                        //     alignment: Alignment.bottomCenter,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         Flexible(child: button195a("Facebook", theme.style16W800White, mainColor, _facebookLogin, true)),
                        //         SizedBox(width: 1,),
                        //         Flexible(child: button196a("Google", theme.style16W800White, mainColor, _googleLogin, true)),
                        //       ],
                        //     )
                        // )
                      ],
                    ),
                  ),
                ),

              ],
            ),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

          ],
        )

    ));
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

  _login() async {
    if (_editControllerEmail.text.isEmpty)
      return messageError(context, strings.get(93)); /// "Please Enter Email",

    if (_editControllerPassword.text.isEmpty)
      return messageError(context, strings.get(94)); /// "Please Enter Password",

    _waits(true);
    var ret = await loginProvider(_editControllerEmail.text, _editControllerPassword.text, true,
        strings.get(95), /// User not found
        strings.get(205), /// User must be Provider
        strings.get(96)  /// "User is disabled. Connect to Administrator for more information.",
      );
    _waits(false);
    if (ret != null)
      return messageError(context, ret);
    Navigator.pop(context);
    Navigator.pushNamed(context, "/ondemand_main");
  }

  _register(){
    Navigator.pushNamed(context, "/ondemand_register");
  }
}


