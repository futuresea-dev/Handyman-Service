import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/model/repair/repair_screen.dart';
import 'package:ondemand_admin/ui/payouts.dart';
import 'package:ondemand_admin/ui/product/product.dart';
import 'package:ondemand_admin/ui/providers/providers_request.dart';
import 'package:ondemand_admin/ui/review.dart';
import 'package:ondemand_admin/ui/settings/admin_panel_app_settings.dart';
import 'package:ondemand_admin/ui/settings/profile.dart';
import 'package:ondemand_admin/ui/settings/provider_app_settings.dart';
import 'package:ondemand_admin/ui/settings/sample.dart';
import 'package:ondemand_admin/ui/settings/website_app_settings.dart';
import 'package:ondemand_admin/ui/subscription.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'banners/banners.dart';
import 'blog/blog.dart';
import 'customers.dart';
import 'dialogs/dialogs.dart';
import 'earning.dart';
import 'login/forgot.dart';
import 'login/login.dart';
import 'settings/main_screen_elements.dart';
import 'favorite.dart';
import 'settings/list_service.dart';
import 'providers/providers.dart';
import 'services/service.dart';
import 'appService/app_settings.dart';
import 'booking/booking.dart';
import 'settings/statuses.dart';
import 'category/category.dart';
import 'chat.dart';
import 'home.dart';
import 'settings/langs.dart';
import 'offers/offers.dart';
import 'settings/gateway.dart';
import 'settings/share.dart';
import 'settings/general.dart';
import 'strings.dart';
import '../widgets/appbars/appbar36.dart';
import '../widgets/menu/menu1.dart';
import 'settings/currency.dart';
import 'settings/documents.dart';
import 'notify.dart';
import 'settings/otp.dart';
import 'theme.dart';

class Dashboard2Screen extends StatefulWidget {
  @override
  _Dashboard2ScreenState createState() => _Dashboard2ScreenState();
}

bool isMenuShow = true;

class _Dashboard2ScreenState extends State<Dashboard2Screen>  with WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MainModel _mainModel;

  @override
  void initState() {
    state = "booking";   // initial route
    _mainModel = Provider.of<MainModel>(context,listen:false);
    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) async {
      if (user == null) {
        dprint("=================listen user log out===============");
      } else {
        if (_mainModel.langs.needUpdate) {
          _showLoader = true;
          await _mainModel.langs.languages(_log, context);
          _showLoader = false;
        }

        dprint("=================log in===============");
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null)
          listenChat(user, playSound: (){
              // sound
              _mainModel.playSound();
          });

        var ret = await initBookings("all", ""); // _mainModel.booking.init();
        if (ret != null)
          messageError(context, ret);

        _mainModel.getUserData(_redraw);
      }
    });
    try{
      _initData();
      _mainModel.setAllRedraw(_redraw);


      // _mainModel.showDialogAddVariants = _showDialogAddVariants;
      // _mainModel.showDialogViewProviderRequestInfo = _showDialogViewProviderRequestInfo;
      // _mainModel.showDialogAddVImageUrl = _showDialogAddVImageUrl;
    }catch(ex){
      messageError(context, ex.toString());
    }
    super.initState();
  }

  bool _showLoader = true;
  String _loaderText = "";
  _initData() async {
    _loaderText = strings.get(202); /// "Loading data ...",
    var ret = await _mainModel.init(_log, context, _redrawMenu);
    if (ret != null)
      messageError(context, ret);

    _showLoader = false;
    _redraw();
  }

  _redrawMenu() {
    _initMenu();
    _redraw();
  }

  _log(String text){
    _loaderText = text;
    _redraw();
  }

  _routeMenu1(String id){
    closeAllPopups();
    // print("Pressed menu item $id");
    if (id == "logout")
      return _mainModel.logout(context);

    state = id;
    setState(() {});
  }

  _initMenu(){
    menu1 = [];
    menu1.add(Menu4Data("home", strings.get(153), icon: Icons.home));                           /// "Home"
    menu1.add(Menu4Data("booking", strings.get(175), icon: Icons.calendar_today_outlined,       /// "Booking",
        all: ordersDataCache.length, unread: getUnreadCountByAdmin(),));
    menu1.add(Menu4Data("earning", strings.get(263), icon: Icons.money, ),);                    /// "Earnings"
    menu1.add(Menu4Data("payout", strings.get(272), icon: Icons.money, ),);                     /// "Providers Payouts"
    menu1.add(Menu4Data("category", strings.get(56), icon: Icons.category,                      /// "Categories"
        all: categories.length),);
    menu1.add(Menu4Data("provider", strings.get(96), icon: Icons.supervisor_account,            /// "Providers"
        all: appSettings.providerCount),);
    menu1.add(Menu4Data("provider_request", strings.get(246),                                   /// "Providers Requests"
        icon: Icons.supervisor_account, all: appSettings.providerRequestCount,
        unread: appSettings.providerNewRequestCount),
    );
    menu1.add(Menu4Data("subscriptions", strings.get(490), icon: Icons.subscriptions_rounded,),);            /// "Subscriptions"
    menu1.add(Menu4Data("service", strings.get(142), icon: Icons.cleaning_services,             /// Services
        all: appSettings.serviceCount),);
    menu1.add(Menu4Data("products", strings.get(423), icon: Icons.pages_rounded,             /// Products
        all: productDataCache.length),);
    menu1.add(Menu4Data("customers", strings.get(157), icon: Icons.supervisor_account_rounded,  /// Customers
        all: appSettings.customersCount),);
    menu1.add(Menu4Data("favorite", strings.get(320), icon: Icons.favorite));                   /// "Favorites"
    menu1.add(Menu4Data("banners", strings.get(328), icon: Icons.credit_card));                 /// "Banners"
    menu1.add(Menu4Data("blog", strings.get(352), icon: Icons.text_fields,                      /// "Blog"
        all: appSettings.blogCount)
    );
    menu1.add(Menu4Data("chat", strings.get(161), icon: Icons.chat));                           /// "Chat"
    menu1.add(Menu4Data("notify", strings.get(13), icon: Icons.notifications));                 /// "Send Notification"
    menu1.add(Menu4Data("offers", strings.get(156), icon: Icons.card_giftcard,                  /// "Offers",
        all: appSettings.offersCount)
    );
    menu1.add(Menu4Data("review", strings.get(260), icon: Icons.star_rate,                      /// "Service Reviews",
        all: appSettings.serviceReviews),
    );
    // menu1.add(Menu4Data("users0", strings.get(78), icon: Icons.supervisor_account,          /// "Users"
    //     child: [Menu4Data("users", strings.get(78)),                                        /// "Users"
    //       Menu4Data("roles", strings.get(79)),                                              /// "Roles"
    //     ])); //

    menu1.add(Menu4Data("settings0", strings.get(33), icon: Icons.settings,                 /// "Settings"
        child: [Menu4Data("general", strings.get(32)),                                      /// "General"
          Menu4Data("currency", strings.get(31)),                                           /// "Currency"
          Menu4Data("gateways", strings.get(41)),                                           /// "Payment Gateways"
          Menu4Data("otp", strings.get(367)),                                                /// "SMS OTP Verify"
          Menu4Data("share", strings.get(40)),                                              /// Share This App
          Menu4Data("documents", strings.get(152)),                                         /// "Documents"
          Menu4Data("booking_status", strings.get(172)),                                    /// "Booking Statuses"
          Menu4Data("sample_data", strings.get(233)),                                       /// "Sample Data"
          // Menu4Data("repair", "Repair data"),                                               /// Repair data
        ])); //
    menu1.add(Menu4Data("apps_settings0", strings.get(106), icon: Icons.app_settings_alt,   /// "Apps Settings"
        child: [
          Menu4Data("appSettings", strings.get(98)),                                        /// Service App Settings
          Menu4Data("providerAppSettings", strings.get(417)),                               /// Provider App Settings
          Menu4Data("webSiteAppSettings", strings.get(418)),                                /// WebSite App Settings
          Menu4Data("adminPanelAppSettings", strings.get(422)),                             /// Admin Panel Settings
          Menu4Data("mspos", strings.get(339)),                                             /// Main Screen Elements Position
          Menu4Data("listService", strings.get(337)),                                       /// List Service
          Menu4Data("appslang", strings.get(107))                                           /// Languages
        ])); //

  }
  List<Menu4Data> menu1 = [];

  var menu2 = [
    Menu1Data("profile", "Profile", Icons.account_circle),
    Menu1Data("logout", "Log Out", Icons.exit_to_app),
  ];

  _routeMenu2(String id){
    closeAllPopups();
    // print("Pressed menu item $id");
    // if (id == "request")
    //   Navigator.pushNamed(context, "/taxi_request");
    state = id;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;

    if (state == "forgot"){
      return Scaffold(
          backgroundColor: dashboardColorCardGrey,
          body: ForgotScreen()
      );
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      //dprint("build user = null");
      drawState((String val){state = val; _redraw();}, context, _redraw, strings.locale, strings.direction);
      return Scaffold(
          backgroundColor: dashboardColorCardGrey,
          body: LoginScreen()
          );
    }

    _initMenu();
    openGallery = _openGallery;

    Widget _child = Container();
    if (state == "blog")
      _child = BlogScreen();
    if (state == "banners")
      _child = BannersScreen();
    if (state == "favorite")
      _child = FavoritesScreen();
    if (state == "payout")
      _child = PayoutsScreen();
    if (state == "earning")
      _child = EarningScreen();
    if (state == "booking")
      _child = BookingScreen();
    if (state == "customers")
      _child = CustomersScreen();
    if (state == "review")
      _child = ReviewScreen();
    if (state == "offers")
      _child = OffersScreen();
    if (state == "chat")
      _child = ChatScreen();
    if (state == "home")
      _child = HomeScreen();
    // users
    // if (_state == "roles")
    //   _child = RolesScreen();
    // if (_state == "users")
    //   _child = UsersScreen();
    // providers
    if (state == "provider")
      _child = ProvidersScreen();
    if (state == "provider_request")
      _child = ProvidersRequestScreen(
        openProvidersScreen: (){
        state = "provider";
        _redraw();
      },);
    // services
    if (state == "service")
      _child = ServicesScreen();
    if (state == "products")
      _child = ArticlesScreen();
    // settings
    if (state == "general")
      _child = SettingsScreen();
    if (state == "currency")
      _child = CurrencyScreen();
    if (state == "share")
      _child = ShareScreen();
    if (state == "gateways")
      _child = GatewaysScreen();
    if (state == "otp")
      _child = OTPScreen();
    if (state == "documents")
      _child = DocumentsScreen();
    if (state == "booking_status")
      _child = BookingStatusesScreen();
    if (state == "sample_data")
      _child = SampleDataScreen();
    if (state == "profile")
      _child = ProfileScreen();

    // apps settings
    if (state == "appSettings")
      _child = AppServiceSettingsScreen();
    if (state == "providerAppSettings")
      _child = ProviderAppSettingsScreen();
    if (state == "webSiteAppSettings")
      _child = WebSiteAppSettingsScreen();
    if (state == "adminPanelAppSettings")
      _child = AdminPanelAppSettingsScreen();
    if (state == "appslang")
      _child = AppLangScreen();
    if (state == "notify")
      _child = NotifyScreen();
    if (state == "category")
      _child = CategoryScreen();
    if (state == "mspos")
      _child = ElementPositionScreen();
    if (state == "listService")
      _child = ListServiceScreen();
    if (state == "repair")
      _child = RepairScreen();
    if (state == "subscriptions")
      _child = SubscriptionScreen();

    drawState((String _){}, context, _redraw, strings.locale, strings.direction);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : colorBackground,
        drawer: Menu4(context: context, callback: _routeMenu2, data: menu1, header: header(), noPop: false,
            style: theme.style14W400, hoverStyle: theme.style14W800,
            iconColor: Colors.grey, hoverIconColor: Colors.blue,
            bgkColor: (theme.darkMode) ? Colors.black : Colors.white,
            hoverBkgColor: (theme.darkMode) ? Colors.black : Color(0xfff0f0f0),
            select : state, bkgColor: (theme.darkMode) ? theme.blackColorTitleBkg : colorBackground,
            stringVersion: "${strings.get(453)} $appVersion"
        ),
        endDrawer: Menu1(context: context, callback: _routeMenu1, data: menu2, redraw: (){_initMenu(); setState(() {});},),
        body: ParentScreen(
            waitWidget: Loader7(color: aTheme.mainColor,),
            child: GestureDetector(
            onTap: (){
              closeAllPopups();
              _redraw();
            },
            child: Stack(
            children: <Widget>[

            Container (
              color: Colors.grey.withAlpha(20),
              padding: strings.direction == TextDirection.ltr ?
              EdgeInsets.only(top: MediaQuery.of(context).padding.top+40, left: (isMenuShow && windowWidth >= 1200) ? 300 : 0)
                :
              EdgeInsets.only(top: MediaQuery.of(context).padding.top+40, right: (isMenuShow && windowWidth >= 1200) ? 300 : 0),
              child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: _child
                  )
            ),

            if (isMenuShow && windowWidth >= 1200)
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40),
                child: Menu4(context: context, callback: _routeMenu2, data: menu1, header: header(), noPop: true,
                    style: theme.style14W400, hoverStyle: theme.style14W800,
                    iconColor: Colors.grey, hoverIconColor: Colors.blue,
                    bgkColor: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
                    hoverBkgColor: (theme.darkMode) ? Colors.black : Color(0xfff0f0f0),
                    select : state, bkgColor: (theme.darkMode) ? theme.blackColorTitleBkg : colorBackground,
                    stringVersion: "${strings.get(453)} $appVersion"
                ),
              ),

            if (!_showLoader)
            appbar36((theme.darkMode) ? Colors.black : Colors.white, (theme.darkMode) ? Colors.white : Colors.black,
                strings.get(0), Icons.menu, _mainModel.userAvatar, "Admin",         /// "HANDYMAN",
                theme.style16W800, _mainModel, context, (int id) {
                  switch(id){
                    case 0:
                      if (windowWidth < 1200)
                        isMenuShow = false;
                      isMenuShow = !isMenuShow;
                      if (isMenuShow && windowWidth < 1200) {
                        _scaffoldKey.currentState!.openDrawer();
                      }
                      setState(() {});
                      break;
                    case 1:
                      _scaffoldKey.currentState!.openEndDrawer();
                      break;
                    case 2:
                      _scaffoldKey.currentState!.openEndDrawer();
                      break;
                  }
                }, Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(strings.get(12), style: theme.style14W800), // "Dark Mode",
                      SizedBox(width: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                          child: CheckBox48(onChanged: (bool value) async {
                          theme = AppTheme(value);
                          _redraw();
                          var ret = await saveAdminPanelDarkMode(theme.darkMode);
                          if (ret != null)
                            messageError(context, ret);
                        }, value: theme.darkMode,)),
                    ],
                  ),
                ), (){_initMenu(); setState(() {});}, (){
                  state = "chat"; _redraw();
                }),

              ...getDialogs(
                  (){ // openProvidersScreen
                    state = "provider";
                    _redraw();
                  }
              ),

            if (_showLoader)
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: (theme.darkMode) ? Colors.black : Colors.white,
                  width: windowWidth,
                  height: windowHeight,
                  child: Center(child: Text(_loaderText, style: theme.style14W800,)),
                ),
              ),

              if (_needOpenGallery)
                InkWell(
                    onTap: (){
                      _needOpenGallery = false;
                      _redraw();
                    },
                    child: Container(
                      width: windowWidth,
                      height: windowHeight,
                      color: Colors.black.withAlpha(200),
                      child: GalleryScreenWeb(),
                    )
                ),

          ],
        )
    )));
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  bool _needOpenGallery = false;

  _openGallery(){
    _needOpenGallery = true;
    _redraw();
  }

  header() {
    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        width: double.maxFinite,
        color: (theme.darkMode) ? dashboardBlackColor : theme.mainColor,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Card16(image: _mainModel.userAvatar,
                  text1: _mainModel.userName,
                  style1: theme.style14W600White,
                  text2: "",
                  style2: theme.style12W800,
                  bkgColor: Colors.transparent,
                  radius: 80,
                )),
            SizedBox(height: 20,),
          ],
        )
    );
  }
}