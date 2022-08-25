import 'dart:io';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'profile.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/cards/card42button.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+160, left: 0, right: 0),
                child: ListView(
                    children: [

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(170), /// "Your Favorites",
                          textStyle: theme.style16W800,
                          text2: strings.get(171), /// "View your favorite services",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("favorite");
                          },
                          icon: Icon(Icons.favorite, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(255), /// "Your Favorite Providers",
                          textStyle: theme.style16W800,
                          text2: strings.get(256), /// "View your favorite providers",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("favorite_providers");
                          },
                          icon: Icon(Icons.favorite, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(10), // "Change Language",
                          textStyle: theme.style16W800,
                          text2: strings.get(11), // "Set your Preferred language",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("language");
                          },
                          icon: Icon(Icons.padding, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button198(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(12), // "Enable Dark Mode",
                          textStyle: theme.style16W800,
                          text2: strings.get(13), // "Set you favorite mode",
                          textStyle2: theme.style12W600Grey,
                          icon: Icon(Icons.dark_mode, color: (theme.darkMode) ? Colors.white : Colors.black,),
                          getCheckValue: (){return theme.darkMode;},
                          rColor: Colors.grey,
                          callback: (bool val){
                            localSettings.setDarkMode(val);
                            theme = AppTheme(val);
                            redrawMainWindow();
                          }
                      ),

                      SizedBox(height: 10,),

                      Button198(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(258), // "Enable Notify",
                          textStyle: theme.style16W800,
                          text2: "",
                          textStyle2: theme.style12W600Grey,
                          icon: Icon(userAccountData.enableNotify
                              ? Icons.notifications_active : Icons.notifications_off,
                            color: (theme.darkMode) ? Colors.white : Colors.black,),
                          getCheckValue: (){return userAccountData.enableNotify;},
                          rColor: theme.mainColor,
                          callback: (bool val) async {
                            var ret = await setEnableDisableNotify(val);
                            if (ret != null)
                              messageError(context, ret);
                            else
                              userAccountData.enableNotify = val;
                            redrawMainWindow();
                          }
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(14), /// "Privacy Policy",
                          textStyle: theme.style16W800,
                          text2: strings.get(15), /// "Known our Privacy Policy",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("policy");
                            //widget.callback("policy", "account");
                          },
                          icon: Icon(Icons.privacy_tip_outlined, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(146), /// "About Us",
                          textStyle: theme.style16W800,
                          text2: strings.get(147), /// "Known About Us",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("about");
                            //widget.callback("about", "account");
                          },
                          icon: Icon(Icons.settings_applications, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(148), /// "Terms & Conditions",
                          textStyle: theme.style16W800,
                          text2: strings.get(149), /// "Known Terms & Conditions",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("terms");
                          },
                          icon: Icon(Icons.copy, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(19), /// "Notifications",
                          textStyle: theme.style16W800,
                          text2: strings.get(20), // "Lots of important information",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("notify");
                          },
                          icon: Icon(Icons.notifications, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(238), /// "Share this app",
                          textStyle: theme.style16W800,
                          text2: "",
                          textStyle2: theme.style12W600Grey,
                          pressButton: () async {
                            var code = "";
                            if (Platform.isIOS)
                              code = appSettings.googlePlayLink;
                            if(Platform.isAndroid)
                              code = appSettings.appStoreLink;
                            await Share.share(code,
                                subject: strings.get(238), /// Share This App,
                                sharePositionOrigin: null);
                          },
                          icon: Icon(Icons.share, color: Colors.blue,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(17), /// "Log Out",
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
                    color: (theme.darkMode) ? Colors.black : Colors.white,
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: card42button(
                        userAccountData.userName,
                        theme.style20W800,
                        strings.get(16), /// "Press for view profile",
                        theme.style14W600Grey,
                        Opacity(opacity: 0.5,
                        child:
                        theme.accountLogoAsset ? Image.asset("assets/ondemands/ondemand12.png", fit: BoxFit.cover) :
                        CachedNetworkImage(
                            imageUrl: theme.accountLogo,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                        ),
                        //Image.asset("assets/ondemands/ondemand12.png", fit: BoxFit.cover)
                        ),
                        image16(userAccountData.userAvatar.isNotEmpty ?
                        CachedNetworkImage(
                            imageUrl: userAccountData.userAvatar,
                            imageBuilder: (context, imageProvider) => Container(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            )
                        ) : Image.asset("assets/user5.png", fit: BoxFit.cover), 80, Colors.white),
                        windowWidth, (theme.darkMode) ? Colors.black : Colors.white, _openProfile
                    )
                ))

          ],
        )

    ));
  }

  _openProfile(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  _logout() async {
    await logout();
    redrawMainWindow();
  }

  // _openAllreviews(){
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ReviewsScreen(),
  //     ),
  //   );
  // }


}


