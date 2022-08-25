
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'strings.dart';
import 'package:ondemand_admin/widgets/buttons/button2.dart';

class LoginScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const LoginScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
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
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Scaffold(
      backgroundColor: (darkMode) ? Colors.black : Colors.white,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: windowHeight*0.5),
              height: windowHeight*0.6,
              color: (darkMode) ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(strings.get(43), // "Sign in now",
                            style: theme.style16W800,
                      ),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: edit42(strings.get(23), // "Email",
                          _editControllerEmail,
                          strings.get(24), // "Enter your Email",
                          ),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Edit43(
                          text: strings.get(44), // "Password",
                          textStyle: theme.style14W600Grey,
                          controller: _editControllerPassword,
                          hint: strings.get(45), // "Enter your Password",
                          editStyle: theme.style16W400,
                          color: Colors.grey),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.all(20),
                      child: button2a(strings.get(46), // "CONTINUE",
                          theme.style16W800White, serviceApp.mainColor, 50, (){_continue();}, true),
                    ),

                    // SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.all(20),
                      child: button2a(strings.get(47), // "REGISTER",
                          theme.style16W800White, serviceApp.mainColor, 50, (){_register();}, true),
                    ),

                    Center(
                      child: Text(strings.get(48), // "or continue with",
                          style: theme.style14W600Grey),
                    ),

                    SizedBox(height: 10,),

                    Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(child: button195("Facebook", serviceApp.mainColor, (){print("button pressed");}, enable: true, style: theme.style16W800White)),
                            SizedBox(width: 1,),
                            Flexible(child: button196("Google", serviceApp.mainColor, (){print("button pressed");}, style: theme.style16W800White, enable: true)),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),

            ClipPath(
                clipper: ClipPathClass23(20),
                child: Container(
                  color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
                  width: windowWidth,
                  height: windowHeight/2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: windowHeight*0.1,),
                      Container(
                        width: windowWidth*0.3,
                        child:
                         (serviceApp.loginLogoAsset) ?
                         Image.asset("assets/ondemands/ondemand1.png", fit: BoxFit.cover) :
                         Image.network(
                           serviceApp.loginLogo,
                           fit: BoxFit.cover),
                      ),
                      SizedBox(height: 20,),
                      Text(strings.get(0), // "HANDYMAN",
                          style: theme.style16W800),
                      SizedBox(height: 5,),
                      Text(strings.get(1), // "SERVICE",
                        style: theme.style10W600Grey),
                      SizedBox(height: 20,),
                      Expanded(child: Container(
                          width: windowWidth,
                          child: (serviceApp.loginImageAsset) ?
                          Image.asset("assets/ondemands/ondemand2.png", fit: BoxFit.cover)
                          : Image.network(
                              serviceApp.loginImage,
                              fit: BoxFit.cover)
                        )
                      )
                    ],
                  ),
                )),


          ],
        )

    ));
  }

  _continue(){
    // onDemandUserLogin = true;
    // widget.redraw();
  }

  _register(){
    // onDemandUserLogin = true;
    // widget.redraw();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => RegisterScreen(),
    //   ),
    // );
  }
}


