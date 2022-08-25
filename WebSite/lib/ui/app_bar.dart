import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/filter.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:provider/provider.dart';

import 'strings.dart';
import '../theme.dart';
import 'address.dart';

class TopAppBar extends StatefulWidget {
  final Function() openMenuAccount;
  final Function() openMobileMenu;
  final Function() openMenuLangs;

  const TopAppBar({Key? key, required this.openMenuAccount,
    required this.openMobileMenu, required this.openMenuLangs}) : super(key: key);
  @override
  _TopAppBarState createState() => _TopAppBarState();
}


class _TopAppBarState extends State<TopAppBar> {

  final _controllerSearch = TextEditingController();
  late MainModel _mainModel;
  final GlobalKey _key = GlobalKey();
  final GlobalKey _key2 = GlobalKey();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _mainModel.controllerSearch = _controllerSearch;
    super.initState();
  }

  @override
  void dispose() {
    _controllerSearch.dispose();
    _mainModel.controllerSearch = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (isMobile())
      return Container(
          color: Colors.white,
        child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        height: 95,
        child: Column(children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(onPressed: widget.openMobileMenu, icon: Icon(Icons.menu)),
            SizedBox(width: 5,),
            InkWell(
                onTap: (){
                  _mainModel.route("home");
                },
                child: Container(
                  height: 40,
                  child: appSettings.websiteLogoServer.isEmpty ? Image.asset("assets/applogo.png",
                      fit: BoxFit.contain)
                      : Image.network(appSettings.websiteLogoServer, fit: BoxFit.contain,),
                )),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Row(
                children: [
                  Container(
                      width: 200,
                      height: 42,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), bottomLeft: Radius.circular(theme.radius)),
                      ),
                      child: Edit26(
                        hint: strings.get(191),  /// "Search service, provider or product",
                        color: (theme.darkMode) ? Colors.black : Colors.white,
                        style: theme.style14W400,
                        useAlpha: false,
                        icon: Icons.search,
                        controller: _controllerSearch,
                        onChangeText: (String val) {

                        },
                      )),

                  button2ForAppBar(strings.get(31), (){  /// Search
                    _search();
                  }, ),
                  SizedBox(width: 10,),
                  if (user != null)
                    button98a(theme.mainColor, Icons.shopping_cart,
                        cart.isNotEmpty ? cart.length.toString() : "", (){
                          _mainModel.route("cart");
                        }, size: 35)
                ],
              ),

          ],)
          ]
        )
      ));

    return Container(
      // margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              _mainModel.route("home");
            },
            child: Container(
              height: 40,
              child: appSettings.websiteLogoServer.isEmpty ? Image.asset("assets/applogo.png",
                  fit: BoxFit.contain)
                  : Image.network(appSettings.websiteLogoServer, fit: BoxFit.contain,),
          )),

          SizedBox(width: 20,),

          Container(
            width: 400,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), bottomLeft: Radius.circular(theme.radius)),
              ),
              child: Edit26(
            hint: strings.get(191),  /// "Search service, provider or product",
            color: (theme.darkMode) ? Colors.black : Colors.white,
            style: theme.style14W400,
            useAlpha: false,
            icon: Icons.search,
            controller: _controllerSearch,
            onChangeText: (String val) {

            },
          )),
          button2ForAppBar(strings.get(31), (){  /// Search
            _search();
          }, ),

          SizedBox(width: 10,),
          Container(key: _key2, height: 1, width: 1),
          Icon(Icons.language, color: Colors.black.withAlpha(100),),
          SizedBox(width: 8,),
          ButtonTextWeb(text: _mainModel.lang.getCurrentLanguageName(),
            onTap: (){
              _openListLang();
              widget.openMenuLangs();
            },
          ),

          SizedBox(width: 10,),
          if (user != null)
            comboBoxAddress(_mainModel, 200),
          SizedBox(width: 10,),
          Container(key: _key, height: 1, width: 1),
          if (user != null)
            ButtonTextWeb(text: strings.get(123), onTap: (){ /// "Account",
              _openListUsers();
              widget.openMenuAccount();
            },),
          if (user != null)
            SizedBox(width: 20,),

          if (user == null)
            ButtonTextWeb(text: strings.get(36), onTap: (){_mainModel.route("login");},), /// "Sign In",
          if (user != null)
            button98a(theme.mainColor, Icons.shopping_cart,
                cart.isNotEmpty ? cart.length.toString() : "", (){
                  _mainModel.route("cart");
                }, size: 40)
          // if (user != null && windowWidth > 1300)
          //   ButtonTextWeb(text: strings.get(40), onTap: (){ /// "Sign Out",
          //     logout();
          //     _mainModel.route("home");
          //     _mainModel.redraw();
          //   },),

        ],
      ),
    );
  }

  _search(){
    if (_controllerSearch.text.isEmpty)
      return;
    _mainModel.searchActivate = true;
    if (filterType == 1){ // service
      serviceSearchText = _controllerSearch.text;
      applyFilter(_mainModel);
    }
    if (filterType == 2){ // provider
      providerSearchText = _controllerSearch.text;
      applyFilter(_mainModel);
    }
    if (filterType == 3) { // article
      articleSearchText = _controllerSearch.text;
      applyFilter(_mainModel);
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      redrawMainWindow();
    });

  }

  _openListLang(){
    final RenderBox? renderBox = _key2.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox!.localToGlobal(Offset.zero); // this is global position
    _mainModel.dialogPositionY = position.dy;
    _mainModel.dialogPositionX = position.dx;
    if (windowWidth - position.dx < 200)
      _mainModel.dialogPositionX = windowWidth - 200;
    _mainModel.dialogWidth = 200; //renderBox.size.width;
  }

  _openListUsers(){
    final RenderBox? renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox!.localToGlobal(Offset.zero); // this is global position
    _mainModel.dialogPositionY = position.dy;
    _mainModel.dialogPositionX = position.dx;
    if (windowWidth - position.dx < 200)
      _mainModel.dialogPositionX = windowWidth - 200;
    _mainModel.dialogWidth = 200; //renderBox.size.width;
  }
}

accountMenu(MainModel _mainModel, Function(String) close){

  _item(String text, String code){
    return Stack(
      children: [

        Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: Text(text, style: theme.style14W400,)),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  if (code == "logout") {
                    logout();
                    _mainModel.redraw();
                    close("home");
                  }else
                    close(code);
                }, // needed
              )),
        )
      ],
    );
  }

  if (_mainModel.dialogPositionY == 0)
    return Container();
  List<Widget> list = [];

  list.add(SizedBox(height: 10,));
  list.add(_item(strings.get(124), "booking"));  /// "Booking",
  list.add(_item(strings.get(125), "profile"));  /// "Profile",
  list.add(_item(strings.get(126), "favorite"));  /// "Favorites",
  list.add(_item(strings.get(185), "provider_favorite"));    /// "Favorite Providers",
  list.add(_item(strings.get(127), "notify"));  /// "Notifications",
  list.add(_item(strings.get(128), "address_list"));  /// "My Address",
  list.add(_item(strings.get(40), "logout"));  /// "Sign Out",
  list.add(SizedBox(height: 10,));

  print("lang Account");
  return Container(
    // key: _keyAccount,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.withAlpha(80)),
      borderRadius: BorderRadius.circular(3),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(3, 3),
        ),
      ],
    ),
    margin: EdgeInsets.only(top: _mainModel.dialogPositionY, left: _mainModel.dialogPositionX),
    width: _mainModel.dialogWidth,
    child: ListView(
      shrinkWrap: true,
      children: list,
    ),);
}

// final GlobalKey _keyLang = GlobalKey();
// final GlobalKey _keyLang = GlobalKey();

langMenu(MainModel _mainModel, Function() close, BuildContext context){

  _item(String text, String code){
    return Stack(
      children: [

        Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: Text(text, style: theme.style14W400,)),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  _mainModel.lang.setAppLang(code, context);
                  close();
                }, // needed
              )),
        )
      ],
    );
  }

  if (_mainModel.dialogPositionY == 0)
    return Container();
  List<Widget> list = [];

  list.add(SizedBox(height: 10,));
  for (var item in _mainModel.lang.appLangs)
    list.add(_item(item.name, item.locale));
  list.add(SizedBox(height: 10,));

  print("langMenu");
  return Container(
    // key: _keyLang,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.withAlpha(80)),
      borderRadius: BorderRadius.circular(3),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(3, 3),
        ),
      ],
    ),
    margin: EdgeInsets.only(top: _mainModel.dialogPositionY, left: _mainModel.dialogPositionX),
    width: _mainModel.dialogWidth,
    child: ListView(
      shrinkWrap: true,
      children: list,
    ),);
}