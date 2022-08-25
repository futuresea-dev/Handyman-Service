import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/login/phone.dart';
import 'package:ondemandservice/ui/documents.dart';
import 'package:ondemandservice/ui/products.dart';
import 'package:ondemandservice/ui/provider.dart';
import 'package:ondemandservice/ui/login/register.dart';
import 'package:ondemandservice/ui/providers_all.dart';
import 'package:ondemandservice/ui/service.dart';
import 'package:provider/provider.dart';
import 'account.dart';
import 'addpromo.dart';
import 'address/add_address.dart';
import 'address/add_address_map.dart';
import 'address/address_list.dart';
import 'address/map_details.dart';
import 'article.dart';
import 'blog/blog_all.dart';
import 'blog/blogdetails.dart';
import 'booking/checkout1.dart';
import 'booking/checkout2.dart';
import 'booking/map_details.dart';
import 'bookings.dart';
import 'booking/booknow.dart';
import 'booking/booknow1.dart';
import 'booking/booknow2.dart';
import 'booking/booknow3.dart';
import 'cart.dart';
import 'category.dart';
import 'chat.dart';
import 'enter_code.dart';
import 'favorite_providers.dart';
import 'strings.dart';
import 'chat2.dart';
import 'dialogs/add_address.dart';
import 'dialogs/filter.dart';
import 'favorite.dart';
import 'jobinfo.dart';
import 'lang.dart';
import 'login/forgot.dart';
import 'login/login.dart';
import 'login/otp.dart';
import 'map_near_by.dart';
import 'theme.dart';
import 'home.dart';
import 'notify.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  String _dialogName = "";
  final _editControllerAddress = TextEditingController();
  final _editControllerName = TextEditingController();
  final _editControllerPhone = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    state = "home";
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _editControllerAddress.dispose();
    _editControllerName.dispose();
    _editControllerPhone.dispose();
    super.dispose();
  }

  _init() async {
    _waits(true);
    _mainModel.account.userAndNotifyListen(_redraw, context);
    var ret = await _mainModel.init2(_redraw);
    _redraw();
    if (ret != null)
      messageError(context, ret);
    _waits(false);
    ret = await loadBlog(true);
    if (ret != null)
      messageError(context, ret);
    _redraw();
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

  _openDialog(String val){
    _dialogName = val;
    _show = 1;
    _redraw();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    _mainModel.setMainWindow(_openDialog);

    // if (user == null && _state != "home" && _state != "otp" && _state != "phone" && _state != "register" && _state != "forgot")
    if (user == null && (state == "booking" || state == "cart" || state == "notify" || state == "account"))
      state = "login";

    if (user != null && needOTPParam && state != "otp"
        && userAccountData.userSocialLogin.isEmpty)
      state = "phone";

    // var count = context.watch<MainModel>().numberOfUnreadMessages;
    // if (_state == "notify" && count != 0)
    //   _mainModel.numberOfUnreadMessages = 0;
    _mainModel.currentPage = state;

    drawState(_route, context, _redraw, strings.locale, strings.direction);

    return WillPopScope(
      onWillPop: () async {
        if (_show != 0){
          _show = 0;
          _redraw();
          return false;
        }
        if ((state == "home" && !_mainModel.searchActivate)
          || state == "booking" || state == "cart" || state == "notify" || state == "account"){
          _dialogName = "exit";
          _show = 1;
          _redraw();
          return false;
        }
        if (state == "home" && _mainModel.searchActivate){
          _mainModel.searchActivate = false;
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

            if (state == "home")
              HomeScreen(),
            if (state == "booking")
              BookingScreen(),
            if (state == "chat")
              ChatScreen(),
            if (state == "notify")
              NotifyScreen(),
            if (state == "account")
              AccountScreen(),
            if (state == "cart")
              CartScreen(),

            if (_mainModel.showBottomBar)
            Container(
              alignment: Alignment.bottomCenter,
              child: BottomBar13(colorBackground: (theme.darkMode) ? Colors.black : Colors.white,
                  colorSelect: Colors.blue,
                  colorUnSelect: Colors.grey,
                  textStyle: theme.style10W600Grey,
                  textStyleSelect: theme.style12W600Blue,
                  radius: 10,
                  callback: (int y){
                    if (y == 0) state = "home";
                    if (y == 1) state = "booking";
                    // if (y == 2) _state = "cart";
                   if (y == 2) state = "chat";
                    if (y == 3) state = "notify";
                    if (y == 4) state = "account";
                    callbackStackRemoveLast();
                    _redraw();
                  }, initialSelect: 0,
                  getItem: (){
                    if (state == "home") return 0;
                    if (state == "booking") return 1;
                    if (state == "chat") return 2;
                    // if (_state == "cart") return 2;
                    if (state == "notify") return 3;
                    if (state == "account") return 4;
                  },
                  text: [strings.get(6), // "Home",
                    strings.get(8), // "Booking",
                    // strings.get(268), // "Cart",
                    strings.get(7), // "Chat",
                    strings.get(96), // "Notify",
                    strings.get(9), // "Account"
                  ],
                  getUnreadMessages: (int index){
                    if (index == 2)
                      return chatCount;
                    // if (index == 2)
                    //   return cart.length;
                    if (index == 3)
                      return getNumberOfUnreadMessages();
                    return 0;
                  },
                  icons: ["assets/ondemands/home.png",
                    "assets/ondemands/031-book.png",
                    // "assets/ondemands/093-cart.png",
                    "assets/ondemands/001-chat.png",
                    "assets/ondemands/notifyicon.png",
                    "assets/ondemands/008-user.png"]
              ),
            ),

            if (state == "login")
              LoginScreen(),
            if (state == "register")
              RegisterScreen(),
            if (state == "service")
              ServicesScreen(),
            if (state == "category")
              CategoryScreen(),
            if (state == "favorite")
              FavoriteScreen(),
            if (state == "favorite_providers")
              FavoriteProvidersScreen(),
            if (state == "phone")
              PhoneScreen(),
            if (state == "otp")
              OTPScreen(),
            if (state == "chat2")
              Chat2Screen(),
            if (state == "language")
              LanguageScreen(openFromSplash: false),
            if (state == "policy" || state == "about" || state == "terms")
              DocumentsScreen(source: state),
            if (state == "book")
              BookNowScreen(),
            if (state == "book1")
              BookNowScreen1(),
            if (state == "book2")
              BookNow2Screen(),
            if (state == "book3")
              BookNow3Screen(),
            if (state == "checkout1")
              CheckOut1Screen(),
            if (state == "checkout2")
              CheckOut2Screen(),
            if (state == "jobinfo")
              JobInfoScreen(),
            if (state == "provider")
              ProvidersScreen(),
            if (state == "blog_details")
              BlogDetailsScreen(),
            if (state == "blog_all")
              BlogAllScreen(),
            if (state == "address_list")
              AddressListScreen(),
            if (state == "address_add")
              AddAddressScreen(),
            if (state == "address_add_map")
              AddAddressMapScreen(),
            if (state == "address_details")
              MapDetailsScreen(),
            if (state == "booking_map_details")
              MapDetailsBookingScreen(),
            if (state == "providers_all")
              ProvidersAllScreen(),
            if (state == "forgot")
              ForgotScreen(),
            if (state == "nearby")
              MapNearByScreen(),
            if (state == "article")
              ArticleScreen(),
            if (state == "products")
              ProductsScreen(),
            if (state == "add_promo")
              AddPromoScreen(),
            if (state == "enter_code")
              EnterCodeScreen(),

            if (state != "cart" && state != "checkout1" && state != "checkout2" && state != "add_promo"
                && state != "enter_code" && state != "book" && state != "book1" && state != "book2" && state != "book3")
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+10),
              alignment: Alignment.topRight,
              child: button98a(theme.mainColor, Icons.shopping_cart,
                  cart.isNotEmpty ? cart.length.toString() : "", (){
                    _route("cart");
                  }, size: 40)
            ),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
              getBody: _getDialogBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),

          ],
        ))

    ));
  }

  double _show = 0;

  _route(String state2){
    state = state2;
    if (state.isEmpty)
      state = "home";

    _redraw();
  }

  Widget _getDialogBody(){
    if (_dialogName == "addAddress")
      return getBodyAddressDialog((){
        _show = 0;
        _redraw();
      }, _mainModel, _editControllerAddress, _editControllerName,
          _editControllerPhone, context);
    if (_dialogName == "filter")
      return getBodyFilterDialog(_redraw, (){_show = 0; _redraw();}, _mainModel);
    // if (_dialogName == "article")
    //   return getBodyArticleDialog(_redraw, (){_show = 0; _redraw();}, windowWidth, _mainModel, context);
    // exit
    return getBodyDialogExit(strings.get(178), strings.get(179), strings.get(180),
            (){_show = 0;_redraw();});  /// Are you sure you want to exit? No Exit
  }
}


