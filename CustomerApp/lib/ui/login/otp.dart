import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/ui/theme.dart';
import '../strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _editControllerCode = TextEditingController();

  @override
  void dispose() {
    _editControllerCode.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _out();
    super.deactivate();
  }

  bool _continuePress = false;

  _out() {
    if (!_continuePress)
      logout();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
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
                      Text(strings.get(52), // "Verification",
                          style: theme.style25W800),
                      SizedBox(height: 5,),
                      Text(strings.get(50), // "in less than a minute",
                          style: theme.style16W600Grey),
                    ],
                  ))),

                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.bottomRight,
                      width: windowWidth*0.3,
                      child: Image.asset("assets/ondemands/ondemand4.png",
                          fit: BoxFit.contain
                      ))
                ],


              ),
            )),

            Container(
              margin: EdgeInsets.only(top: windowHeight*0.4),
              height: windowHeight*0.6,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(strings.get(54), // "We've sent 6 digit verification code.",
                          style: theme.style15W400),
                    ),

                    SizedBox(height: 50,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: edit42(strings.get(55), // "Enter code",
                          _editControllerCode,
                          strings.get(56), // "Enter 6 digits code",
                          type: TextInputType.number),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.all(20),
                      child: button2(strings.get(46), theme.mainColor, /// "CONTINUE",
                          (){_continue();}),
                    ),

                  ],
                ),
              ),
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {_out(); goBack(); }),

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

  _continue() async {
    if (_editControllerCode.text.isEmpty)
      return messageError(context, strings.get(234)); /// "Please enter code",

    _waits(true);
    var ret = await otp(_editControllerCode.text, appSettings,
      strings.get(225), /// Please enter valid code
    );
    _waits(false);
    if (ret != null)
      return messageError(context, ret);

    _continuePress = true;
    goBack();
    goBack();
  }
}



