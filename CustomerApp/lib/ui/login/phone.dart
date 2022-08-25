import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  
  double windowWidth = 0;
  double windowHeight = 0;
  final _editControllerPhone = TextEditingController();

  @override
  void dispose() {
    _editControllerPhone.dispose();
    super.dispose();
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

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(appSettings.otpPrefix,
                              style: theme.style18W800),
                          SizedBox(width: 10,),
                          Expanded(child: edit42(strings.get(25), // "Phone number",
                              _editControllerPhone,
                              strings.get(26), // "Enter your Phone number",
                              type: TextInputType.phone)),
                        ],
                      )
                    ),

                    SizedBox(height: 50,),

                    Center(
                      child: Text(strings.get(53), // "We'll sent verification code.",
                          style: theme.style15W400),
                    ),

                    SizedBox(height: 50,),

                    Container(
                      margin: EdgeInsets.all(20),
                      child: button2(strings.get(46), theme.mainColor, _continue), /// "CONTINUE",
                    ),

                  ],
                ),
              ),
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {_out(); goBack();}),

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

  bool _continuePress = false;
  @override
  void deactivate() {
    _out();
    super.deactivate();
  }

  _out() {
    if (!_continuePress)
      logout();
  }

  _continue() async {
    if (_editControllerPhone.text.isEmpty)
      return messageError(context, strings.get(26)); /// "Enter your phone number",

    _continuePress = true;

    login(){
      goBack();
    }

    _goToCode(){
      route("otp");
    }

    _waits(true);
    var ret = await sendOTPCode(_editControllerPhone.text, context, login, _goToCode,
        appSettings, strings.get(143)); /// Code sent. Please check your phone for the verification code.
    _waits(false);
    if (ret != null)
      messageError(context, ret);

  }
}


