import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/model/model.dart';
import 'package:ondprovider/ui/chat2.dart';
import 'package:ondprovider/ui/documents.dart';
import 'package:ondprovider/ui/products/products.dart';
import 'package:ondprovider/ui/service/services.dart';
import 'package:provider/provider.dart';
import 'account/pay_subscription_plan.dart';
import 'account/subscription_plan.dart';
import 'jobinfo.dart';
import 'lang.dart';
import 'map_customer.dart';
import 'notify.dart';
import 'strings.dart';
import 'account/account.dart';
import 'bookings.dart';
import 'chat.dart';
import 'theme.dart';

class OnMainScreen extends StatefulWidget {
  @override
  _OnMainScreenState createState() => _OnMainScreenState();
}

class _OnMainScreenState extends State<OnMainScreen> {
  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;

  @override
  void initState() {
    state = "booking";
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _mainModel.account.userAndNotifyListen(_redraw, context);
    _init();
    super.initState();
  }

  _init() async {
    _waits(true);
    var ret = await loadCategory(true);
    if (ret != null)
      messageError(context, ret);
    _waits(false);
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

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    // ignore: unnecessary_statements
    context.watch<MainModel>().chatCount;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        Navigator.pop(context);
        Navigator.pushNamed(context, "/ondemand_login");
      });

    // var count = context.watch<MainModel>().numberOfUnreadMessages;
    // if (_state == "notify" && count != 0)
    //   _mainModel.numberOfUnreadMessages = 0;

    drawState(_route, context, _redraw, strings.locale, strings.direction);

    return WillPopScope(
        onWillPop: () async {
          if (_show != 0){
            _show = 0;
            return false;
          }
          if (state == "booking" || state == "chat" || state == "notify" || state == "account"){
            _dialogName = "exit";
            _show = 1;
            _redraw();
            return false;
          }
        goBack();
        return false;
    },
    child: Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: ParentScreen(
        waitWidget: Loader7v1(color: aTheme.mainColor,),
        child: Stack(
          children: <Widget>[

            if (state == "chat")
              ChatScreen(),
            if (state == "booking")
              BookingScreen(),
            if (state == "account")
              AccountScreen(redraw: _redraw),
            if (state == "notify")
              NotifyScreen(),

            Container(
              alignment: Alignment.bottomCenter,
              child: BottomBar13(colorBackground: (theme.darkMode) ? Colors.black : Colors.white,
                  colorSelect: theme.mainColor,
                  colorUnSelect: Colors.grey,
                  textStyle: theme.style10W600Grey,
                  textStyleSelect: theme.style12W800MainColor,
                  radius: theme.radius,
                  callback: (int y){
                    if (y == 0) state = "chat";
                    if (y == 1) state = "booking";
                    if (y == 2) state = "account";
                    if (y == 3) state = "notify";
                    setState(() {
                    });
                  }, //initialSelect: _currentPage,
                  getItem: (){
                    switch(state){
                      case "chat":
                        return 0;
                      case "booking":
                        return 1;
                      case "account":
                        return 2;
                      case "notify":
                        return 3;
                    }
                    return 0;
                  },
                  text: [strings.get(26), /// "Chat",
                    strings.get(27),      /// "Booking",
                    strings.get(28),      /// "Account"
                    strings.get(89),      /// "Notifications"
                  ],
                  icons: ["assets/ondemand/001-chat.png",
                    "assets/ondemand/031-book.png",
                    "assets/ondemand/008-user.png",
                    "assets/notifyicon.png",
                  ],
                getUnreadMessages: (int index) {
                  if (index == 0)
                    return _mainModel.chatCount;
                  if (index == 1)
                    return newBookingCount;
                  if (index == 3)
                    return getNumberOfUnreadMessages();
                  return 0;
                },
              ),
            ),

            if (state == "chat2")
              Chat2Screen(),
            if (state == "language")
              LanguageScreen(openLogin: false, redraw: _redraw),
            if (state == "policy" || state == "about" || state == "terms")
              PolicyScreen(source: state),
            if (state == "jobinfo")
              JobInfoScreen(),
            if (state == "services")
              ServicesAllScreen(),
            if (state == "mapCustomer")
              MapCustomerScreen(),
            if (state == "products")
              ProductsAllScreen(),
            if (state == "subscription_plan")
              SubscriptionPlanScreen(),
            if (state == "pay_subscription")
              PaySubscriptionPlanScreen(),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
              getBody: _getBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

          ],
        ))

    ));
  }

  _route(String state2) {
    state = state2;
    if (state.isEmpty)
      state = "booking";
    _redraw();
  }

  double _show = 0;
  String _dialogName = "";

  _getBody(){
    if (_dialogName == "exit")
      return getBodyDialogExit(strings.get(207), strings.get(146), strings.get(208),
              (){_show = 0;_redraw();});  /// Are you sure you want to exit? No Exit
    return Container();
  }
}


