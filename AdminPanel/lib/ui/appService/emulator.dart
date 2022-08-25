import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/appService/screens/account.dart';
import 'package:ondemand_admin/ui/appService/screens/add_address.dart';
import 'package:ondemand_admin/ui/appService/screens/banner.dart';
import 'package:ondemand_admin/ui/appService/screens/bookings.dart';
import 'package:ondemand_admin/ui/appService/screens/booknow.dart';
import 'package:ondemand_admin/ui/appService/screens/booknow1.dart';
import 'package:ondemand_admin/ui/appService/screens/booknow2.dart';
import 'package:ondemand_admin/ui/appService/screens/booknow3.dart';
import 'package:ondemand_admin/ui/appService/screens/booknow4.dart';
import 'package:ondemand_admin/ui/appService/screens/category.dart';
import 'package:ondemand_admin/ui/appService/screens/chat.dart';
import 'package:ondemand_admin/ui/appService/screens/chat2.dart';
import 'package:ondemand_admin/ui/appService/screens/documents.dart';
import 'package:ondemand_admin/ui/appService/screens/lang.dart';
import 'package:ondemand_admin/ui/appService/screens/notify.dart';
import 'package:ondemand_admin/ui/appService/screens/profile.dart';
import 'package:ondemand_admin/ui/appService/screens/register.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/provider.dart';
import 'screens/service.dart';
import 'screens/splash.dart';
import '../strings.dart';
import '../theme.dart';
import 'screens/login.dart';

class EmulatorServiceScreen extends StatefulWidget {

  const EmulatorServiceScreen({Key? key}) : super(key: key);

  @override
  _EmulatorServiceScreenState createState() => _EmulatorServiceScreenState();
}

class _EmulatorServiceScreenState extends State<EmulatorServiceScreen> {

  bool onDemandDarkMode = false;
  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  Color onDemandMainColor = Color(0xff69c4ff);
  Color onDemandColorBackground = Color(0xfff1f6fe);
  Color onDemandBlackColorTitleBkg = Color(0xff202020);
  late MainModel _mainModel;

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  double _scroller = 20;
  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    _scroller = 20-(_scrollPosition/(windowHeight*0.1/20));
    if (_scroller < 0)
      _scroller = 0;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = _mainModel.getEmulatorWidth();
    windowHeight = _mainModel.getEmulatorHeight();
    // for (var item in _mainModel.emulatorServiceDataCombo)
    //   print("emulatorServiceDataCombo = ${item.id} ${item.text}");
    // print("currentEmulatorLanguage = ${_mainModel.currentEmulatorLanguage}");

    return Container(
    width: windowWidth+windowWidth*0.1,
      height: windowHeight+windowHeight*0.1+50,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: windowWidth/2,
                  child: checkBox1a(context, strings.get(12), /// "Dark mode",
                  theme.mainColor, theme.style14W400, _mainModel.serviceApp.onDemandDarkMode2,
                      (val) {
                    if (val == null) return;
                    _mainModel.serviceApp.setonDemandDarkMode(val);
                    setState(() {
                    });
                  })),
              Expanded(child: Container(
                  width: 120,
                  child: Combo(inRow: true, text: "",
                    data: _mainModel.emulatorServiceDataCombo,
                    value: _mainModel.currentEmulatorLanguage,
                    onChange: (String value){
                      _mainModel.setEmulatorLang(value);
                      setState(() {
                      });
                    },)))
            ],
          ),
          SizedBox(height: 10,),
          Stack(
            children: [
              Container(
                  width: windowWidth+windowWidth*0.1,
                  height: windowHeight+windowHeight*0.1,
                  child: Image.asset("assets/dashboard2/dashboard7.png",
                      fit: BoxFit.cover
                  )
              ),

              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: Container(
                    height: windowHeight+windowHeight*0.1-windowHeight*0.13,
                    margin: EdgeInsets.only(left: windowWidth*0.05, right: windowWidth*0.05, top: windowHeight*0.08, bottom: windowHeight*0.05),
                    width: windowWidth,
                    // height: windowHeight,
                    child: _body(windowWidth, windowHeight),
                  )),
            ],
          )
        ],
      )
    );
  }

  _body(double windowWidth, double windowHeight){
    var select = context.watch<MainModel>().serviceApp.select;
    // ignore: unnecessary_statements
    context.watch<MainModel>().langs;
    // ignore: unnecessary_statements
    context.watch<MainModel>().serviceApp.needsRedraw;

    if (select.id == "splash")
      return SplashScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "lang")
      return LanguageScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "login")
      return LoginScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "register")
      return RegisterScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "main")
      return HomeScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "provider")
      return ProvidersScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "service")
      return ServicesScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "category")
      return CategoryScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "booking")
      return BookingScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "chat1")
      return ChatScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "chat2")
      return Chat2Screen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "notify")
      return NotifyScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "account")
      return AccountScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "profile")
      return ProfileScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "documents")
      return DocumentsScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "booking1")
      return BookNowScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "booking2")
      return BookNowScreen1(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "addaddress")
      return AddAddressScreen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "booking3")
      return BookNow2Screen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "booking4")
      return BookNow3Screen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "booking5")
      return BookNow4Screen(windowWidth: windowWidth, windowHeight: windowHeight,);
    if (select.id == "banner")
      return BannerScreen(windowWidth: windowWidth, windowHeight: windowHeight,);


    return Container(child: Text(select.name),);
  }

}

