
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/widgets/buttons/button2.dart';
import 'theme.dart';

class RegisterScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const RegisterScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  double windowWidth = 0;
  double windowHeight = 0;
  final _editControllerName = TextEditingController();
  final _editControllerEmail = TextEditingController();
  final _editControllerPassword1 = TextEditingController();
  final _editControllerPassword2 = TextEditingController();

  @override
  void dispose() {
    _editControllerName.dispose();
    _editControllerEmail.dispose();
    _editControllerPassword1.dispose();
    _editControllerPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Scaffold(
        backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

        ClipPath(
          clipper: ClipPathClass23(20),
          child: Container(
            color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
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
                      Text(strings.get(49), // "Register",
                          style: theme.style25W800),
                      SizedBox(height: 10,),
                      Text(strings.get(50), // "in less than a minute",
                          style: theme.style16W600Grey),
                    ],
                  ))),

                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.bottomRight,
                      width: windowWidth*0.3,
                      child: (serviceApp.registerLogoAsset) ?
                      Image.asset("assets/ondemands/ondemand5.png", fit: BoxFit.contain) :
                      Image.network(
                          serviceApp.registerLogo,
                          fit: BoxFit.cover),
                  )
                ],
              ),
            )),

            Container(
              margin: EdgeInsets.only(top: windowHeight*0.3),
              height: windowHeight*0.9,
              color: (darkMode) ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: edit42(strings.get(21), // "Name",
                          _editControllerName,
                          strings.get(22), // "Enter Name",
                          ),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: edit42(strings.get(23), // "Email",
                          _editControllerEmail,
                          strings.get(24), // "Enter Email",
                          ),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Edit43(
                          text: strings.get(44), // "Password",
                          textStyle: theme.style14W600Grey,
                          controller: _editControllerPassword1,
                          hint: strings.get(45), // "Enter Password",
                          editStyle: theme.style15W400,
                          color: Colors.grey),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Edit43(
                          text: strings.get(51), // "Confirm Password",
                          textStyle: theme.style14W600Grey,
                          controller: _editControllerPassword2,
                          hint: strings.get(45), // "Enter Password",
                          editStyle: theme.style15W400,
                          color: Colors.grey),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.all(20),
                      child: button2s(strings.get(46), // "CONTINUE",
                          theme.style16W800White, serviceApp.mainColor, 50, (){_continue();}, true),
                    ),

                  ],
                ),
              ),
            ),

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black,
                "", context, () {}),

          ],
        )

    ));
  }

  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

  _continue() async {
  }
}


