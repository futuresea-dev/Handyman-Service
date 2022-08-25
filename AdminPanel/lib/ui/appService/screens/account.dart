
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/widgets/cards/card42button.dart';
import 'theme.dart';

class AccountScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const AccountScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Scaffold(
        backgroundColor: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+160, left: 0, right: 0),
                child: ListView(
                    children: [

                      SizedBox(height: 20,),

                      Button197(color: (darkMode) ? Colors.black : Colors.white,
                          text: strings.get(10), // "Change Language",
                          textStyle: theme.style16W800,
                          text2: strings.get(11), // "Set your Preferred language",
                          textStyle2: theme.style12W600Grey,
                          pressButton: _changeLanguage,
                          icon: Icon(Icons.padding, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button198(color: (darkMode) ? Colors.black : Colors.white,
                          text: strings.get(12), // "Enable Dark Mode",
                          textStyle: theme.style16W800,
                          text2: strings.get(13), // "Set you favorite mode",
                          textStyle2: theme.style12W600Grey,
                          icon: Icon(Icons.dark_mode, color: (darkMode) ? Colors.white : Colors.black,),
                          getCheckValue: (){return darkMode;},
                          rColor: Colors.grey,
                          callback: (bool val){

                          }
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (darkMode) ? Colors.black : Colors.white,
                          text: strings.get(14), /// "Privacy Policy",
                          textStyle: theme.style16W800,
                          text2: strings.get(15), /// "Known our Privacy Policy",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){

                          },
                          icon: Icon(Icons.privacy_tip_outlined, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (darkMode) ? Colors.black : Colors.white,
                          text: strings.get(146), /// "About Us",
                          textStyle: theme.style16W800,
                          text2: strings.get(147), /// "Known About Us",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){

                          },
                          icon: Icon(Icons.settings_applications, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (darkMode) ? Colors.black : Colors.white,
                          text: strings.get(148), /// "Terms & Conditions",
                          textStyle: theme.style16W800,
                          text2: strings.get(149), /// "Known Terms & Conditions",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){

                          },
                          icon: Icon(Icons.copy, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (darkMode) ? Colors.black : Colors.white,
                          text: strings.get(19), // "Notifications",
                          textStyle: theme.style16W800,
                          text2: strings.get(20), // "Lots of important information",
                          textStyle2: theme.style12W600Grey,
                          pressButton: _notify,
                          icon: Icon(Icons.notifications, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (darkMode) ? Colors.black : Colors.white,
                          text: strings.get(17), // "Log Out",
                          textStyle: theme.style16W800,
                          text2: strings.get(18), // "End the session",
                          textStyle2: theme.style12W600Grey,
                          pressButton: _logout,
                          icon: Icon(Icons.logout, color: Colors.blue,)
                      ),

                      SizedBox(height: 120,),

                    ])
            ),


            ClipPath(
                clipper: ClipPathClass23(20),
                child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    width: windowWidth,
                    color: (darkMode) ? Colors.black : Colors.white,
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: card42button(
                        "user name",
                        theme.style20W800,
                        strings.get(16), /// "Press for view profile",
                        theme.style14W600Grey,
                        Opacity(opacity: 0.5,
                        child: serviceApp.accountLogoAsset ? Image.asset("assets/ondemands/ondemand12.png", fit: BoxFit.cover) :
                            Image.network(
                                serviceApp.accountLogo,
                                fit: BoxFit.cover)
                        ),
                          //Image.asset("assets/ondemands/ondemand12.png", fit: BoxFit.cover)
                        image16(Image.asset("assets/user5.png", fit: BoxFit.cover), 80, Colors.white),
                        windowWidth, (darkMode) ? Colors.black : Colors.white, _openProfile
                    )
                ))

          ],
        )

    ));
  }

  _openProfile(){

  }

  _changeLanguage(){
    // widget.callback("language");
  }

  _logout() async {
    // await Provider.of<MainModel>(context,listen:false).logout();
    // widget.redraw();
  }

  // _openAllreviews(){
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ReviewsScreen(),
  //     ),
  //   );
  // }

  _notify(){
    // widget.callback("notify");
  }
}


