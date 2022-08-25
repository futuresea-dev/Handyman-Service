import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';

class OnDemandPhoneScreen extends StatefulWidget {
  @override
  _OnDemandPhoneScreenState createState() => _OnDemandPhoneScreenState();
}

class _OnDemandPhoneScreenState extends State<OnDemandPhoneScreen> {
  
  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
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
                      Text(strings.get(19), // "Verification",
                          style: theme.style25W800),
                      SizedBox(height: 5,),
                      Text(strings.get(15), // "in less than a minute",
                          style: theme.style16W600Grey),
                    ],
                  ))),

                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.bottomRight,
                      width: windowWidth*0.3,
                      child: Image.asset("assets/ondemand/ondemand4.png",
                          fit: BoxFit.contain
                      ))
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
                      child: edit42(strings.get(20), // "Phone number",
                          _editControllerPhone,
                          strings.get(21), // "Enter your Phone number",
                          type: TextInputType.phone),
                    ),

                    SizedBox(height: 50,),

                    Center(
                      child: Text(strings.get(22), // "We'll sent verification code.",
                          style: theme.style15W400),
                    ),

                    SizedBox(height: 50,),

                    Container(
                      margin: EdgeInsets.all(20),
                      child: button2(strings.get(11), // "CONTINUE",
                          theme.mainColor, (){_continue();}, style: theme.style16W800White, radius: 50),
                    ),

                  ],
                ),
              ),
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {Navigator.pop(context);})

          ],
        )

    ));
  }

  _continue(){
    Navigator.pushNamed(context, "/ondemand_otp");
  }
}


