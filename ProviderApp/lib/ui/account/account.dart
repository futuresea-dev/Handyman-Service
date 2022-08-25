import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/account/subscription.dart';
import 'package:ondprovider/ui/portfolio.dart';
import 'package:ondprovider/ui/account/earning.dart';
import 'package:ondprovider/widgets/buttons/button199.dart';
import '../profile.dart';
import '../reviews.dart';
import '../settings.dart';
import '../strings.dart';
import 'package:ondprovider/widgets/cards/card42button.dart';
import '../theme.dart';
import 'map_work_area.dart';

class AccountScreen extends StatefulWidget {
  final Function() redraw;
  const AccountScreen({Key? key, required this.redraw}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  EarningData? _earning;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    var ret = await loadRatings(currentProvider.id);
    if (ret != null)
      messageError(context, ret);
    _redraw();
    ret = await loadPayoutProvider(currentProvider.id);
    if (ret != null)
      messageError(context, ret);
    List<EarningData> _datas = getEarningData(currentProvider);
    if (_datas.isNotEmpty)
      _earning = _datas.last;
    // ret = await _mainModel.wallet.initWallet();
    // if (ret != null)
    //   messageError(context, ret);
    if (isSubscriptionDateExpired()){
      currentProvider.available = false;
      saveProviderFromAdmin();
      redrawMainWindow();
    }
    _redraw();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

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

                      if (appSettings.enableSubscriptions)
                        getSubscriptionInfo(),

                      if (ratingsLoad)
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 00),
                          decoration: BoxDecoration(
                            color: (theme.darkMode) ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: card45(windowWidth-20,
                                    ratingIndex5,
                                    ratingIndex4,
                                    ratingIndex3,
                                    ratingIndex2,
                                    ratingIndex1,
                                    rating,
                                    "$ratingCount ${strings.get(58)}", /// reviews
                                    strings.get(59), /// "Read all",
                                    _openAllreviews))
                            ],
                          )),

                      SizedBox(height: 20,),

                      Button198(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(213), /// "Provider Available/Unavailable",
                          textStyle: theme.style16W800,
                          text2: strings.get(214), /// Temporary disable your account
                          textStyle2: theme.style12W600Grey,
                          icon: Icon(Icons.check_circle,
                            color: currentProvider.available ? theme.mainColor : Colors.grey,),
                          getCheckValue: (){return currentProvider.available;},
                          rColor: theme.mainColor,
                          callback: (bool val) async {
                            if (isSubscriptionDateExpired()){
                              currentProvider.available = false;
                              redrawMainWindow();
                              return messageError(context, strings.get(284)); /// You subscriptions expired
                            }
                            var ret = await setProviderAvailable(currentProvider, val);
                            if (ret != null)
                              messageError(context, ret);
                            else
                              currentProvider.available = val;
                            redrawMainWindow();
                          }
                      ),

                      SizedBox(height: 10,),

                      Button199(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(78), /// "Wallet",
                          textStyle: theme.style16W800,
                          text2: strings.get(79), /// "Know your earnings",
                          textStyle2: theme.style12W600Grey,
                          text3: _earning != null ? getPriceString(_earning!.payout) : "",
                          textStyle3: theme.style16W800,
                          pressButton: _wallet,
                          icon: Icon(Icons.wallet_membership, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(123), /// "My Page",
                          textStyle: theme.style16W800,
                          text2: strings.get(124), /// "Edit Provider information",
                          textStyle2: theme.style12W600Grey,
                          pressButton: _mypage,
                          icon: Icon(Icons.work, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(142), /// "My Services",
                          textStyle: theme.style16W800,
                          text2: strings.get(143), /// "Edit Service information",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                              route("services");
                          },
                          icon: Icon(Icons.workspaces_outline, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(225), /// "My Products",
                          textStyle: theme.style16W800,
                          text2: strings.get(226), /// "Edit Products information",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("products");
                          },
                          icon: Icon(Icons.workspaces_outline, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(179), /// "My Work Area",
                          textStyle: theme.style16W800,
                          text2: strings.get(180), /// "Edit your work area",
                          textStyle2: theme.style12W600Grey,
                          pressButton: _workArea,
                          icon: Icon(Icons.map_outlined, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(269), /// "Settings",
                          textStyle: theme.style16W800,
                          text2: strings.get(270), /// "Set minimum amd maximum order amounts",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.attach_money_outlined, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(60), // "Change Language",
                          textStyle: theme.style16W800,
                          text2: strings.get(61), // "Set your Preferred language",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("language");
                          },
                          icon: Icon(Icons.padding, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button198(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(76), // "Enable Dark Mode",
                          textStyle: theme.style16W800,
                          text2: strings.get(77), // "Set you favorite mode",
                          textStyle2: theme.style12W600Grey,
                          icon: Icon(Icons.dark_mode, color: (theme.darkMode) ? Colors.white : Colors.black,),
                          getCheckValue: (){return theme.darkMode;},
                          rColor: Colors.grey,
                          callback: (bool val){
                            localSettings.setDarkMode(val);
                            theme = AppTheme(val);
                            widget.redraw();
                          }
                      ),

                      SizedBox(height: 10,),

                      Button198(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(212), /// "Enable Notify",
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
                          text: strings.get(82), // "Privacy Policy",
                          textStyle: theme.style16W800,
                          text2: strings.get(83), // "Known our Privacy Policy",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("policy");
                          },
                          icon: Icon(Icons.privacy_tip_outlined, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(108), /// "About Us",
                          textStyle: theme.style16W800,
                          text2: strings.get(109), /// "Known About Us",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("about");
                          },
                          icon: Icon(Icons.settings_applications, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(110), /// "Terms & Conditions",
                          textStyle: theme.style16W800,
                          text2: strings.get(111), /// "Known Terms & Conditions",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("terms");
                          },
                          icon: Icon(Icons.copy, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(89), // "Notifications",
                          textStyle: theme.style16W800,
                          text2: strings.get(90), // "Lots of important information",
                          textStyle2: theme.style12W600Grey,
                          pressButton: (){
                            route("notify");
                          },
                          icon: Icon(Icons.notifications, color: theme.mainColor,)
                      ),

                      SizedBox(height: 10,),

                      Button197(color: (theme.darkMode) ? Colors.black : Colors.white,
                          text: strings.get(91), // "Log Out",
                          textStyle: theme.style16W800,
                          text2: strings.get(92), // "End the session",
                          textStyle2: theme.style12W600Grey,
                          pressButton: _logout,
                          icon: Icon(Icons.logout, color: theme.mainColor,)
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
                        strings.get(57), /// "Press for view profile",
                        theme.style14W600Grey,
                        Opacity(opacity: 0.5,
                            child: Image.asset("assets/ondemand/ondemand6.png", fit: BoxFit.cover)),
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
        ))

    );
  }

  _openProfile(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  _openAllreviews(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewsScreen(),
      ),
    );
  }

  _mypage(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PortfolioScreen(),
      ),
    );
  }

  _wallet(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EarningScreen(),
      ),
    );
  }

  _workArea(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapWorkAreaScreen(),
      ),
    );
  }

  _logout() async {
    await logout();
    currentProvider = ProviderData.createEmpty();
    widget.redraw();
  }
}


