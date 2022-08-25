import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  
  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _editControllerEmail = TextEditingController();

  @override
  void dispose() {
    _editControllerEmail.dispose();
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

        ClipPath(
          clipper: ClipPathClass23(20),
          child: Container(
            color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
            width: windowWidth,
              height: windowHeight*0.3,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(strings.get(227), /// "Forgot password?",
                          style: theme.style25W800),
                      SizedBox(height: 5,),
                      // Text(strings.get(50), // "in less than a minute",
                      //     style: theme.style16W600Grey),
                    ],
                  ))),

                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.bottomRight,
                      width: windowWidth*0.3,
                      child: Image.asset("assets/ondemands/ondemand4.png",
                          fit: BoxFit.contain
                      )),
                ],


              ),
            )),

            Container(
              margin: EdgeInsets.only(top: windowHeight*0.3),
              height: windowHeight*0.9,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(height: 20),
                    Text(strings.get(228), /// "Reset password",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                    SizedBox(height: 40),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: edit42(strings.get(23), /// "Email",
                          _editControllerEmail,
                          strings.get(24), /// "Enter your Email",
                          type: TextInputType.emailAddress
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: button2(strings.get(229), theme.mainColor, _reset)), /// "Send new password",

                    SizedBox(height: 50,),

                  ],
                ),
              ),
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {goBack();}),

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

  _reset() async {
    if (_editControllerEmail.text.isEmpty)
      return messageError(context, strings.get(135)); /// "Please Enter Email",

    _waits(true);
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _editControllerEmail.text);
    }catch(ex) {
      _waits(false);
      return messageError(context, ex.toString());
    }
    _waits(false);
    messageOk(context, strings.get(230)); /// "Reset password email sent. Please check your mail."
  }


}


