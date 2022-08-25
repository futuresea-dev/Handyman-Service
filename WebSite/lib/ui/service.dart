import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/addons.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:ondemand_admin/widgets/button202a.dart';
import 'package:ondemand_admin/widgets/horizontal_articles.dart';
import 'package:ondemand_admin/widgets/image.dart';
import 'package:ondemand_admin/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../mainModel/model.dart';
import 'strings.dart';
import '../theme.dart';
import 'bottom.dart';
import 'package:abg_utils/abg_utils.dart';

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  var scrollController = ScrollController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _init();
    for (var item in _mainModel.currentService.addon)
      item.selected = false;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  _init() async {
    var ret = await loadReviewsForServiceScreen(_mainModel.currentService.id);
    if (ret != null)
      messageError(context, ret);
    _redraw();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top : 0),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
                  child: Column(children : _getList()),
                ),
                getBottomWidget(_mainModel)
              ],
            ),),

        Container(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
          children: [
            button2x2(strings.get(194), /// "Add to cart",
                    (){
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user == null)
                    return _mainModel.route("login");
                  _mainModel.currentService.countProduct = 1;
                  var ret = addToCart(_mainModel.currentService, strings.get(199)); /// This product already in the cart
                  if (ret != null)
                    messageError(context, ret);
                  else
                    messageOk(context, strings.get(198)); /// Product added to cart
                  redrawMainWindow();
                }, padding: EdgeInsets.only(top: 15, bottom: 15, left: 35, right: 35)
            ),
            SizedBox(height: 10,),
            button2x2(strings.get(89), (){  /// Book this service
              User? user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                _mainModel.route("login");
              }else
                _mainModel.route("book");
            }),
          ],
          )
        )

      ],
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    list.add(Text(strings.get(17), style: theme.style18W800,)); /// "Service",
    list.add(SizedBox(height: 10,));

    List<Widget> list3 = [];
    list3.add(card51(_mainModel.currentService.rating.toInt(), theme.serviceStarColor, 16),);
    list3.add(SizedBox(width: 5,));
    list3.add(Text(_mainModel.currentService.rating.toStringAsFixed(1),
      style: theme.style14W400, textAlign: TextAlign.center,),);
    list3.add(SizedBox(width: 20,));
    getPriceText(_mainModel.getPrice(), list3, _mainModel);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null){
      list3.add(SizedBox(width: 10,));
      list3.add(Container(
        alignment: Alignment.topRight,
        child: IconButton(icon: userAccountData.userFavorites.contains(_mainModel.currentService.id)
            ? Icon(Icons.favorite, size: 30,)
            : Icon(Icons.favorite_border, size: 30), color: Colors.orange,
          onPressed: (){
            changeFavorites(_mainModel.currentService);
          }, ),
      )
      );
    }

    bool yesSelect = false;
    for (var item in _mainModel.currentService.price)
      if (item.selected)
        yesSelect = true;
    if (!yesSelect){
      bool first = true;
      for (var item in _mainModel.currentService.price) {
        if (first) {
          first = false;
          item.selected = true;
          //localSettings.price = item;
        }else
          item.selected = false;
      }
    }

    List<Widget> list4 = [];

    for (var item in _mainModel.currentService.price){
      List<Widget> list2 = [];
      list2.add((item.image.serverPath.isNotEmpty)
          ? Container(
          width: 30,
          height: 30,
          child: Image.network(item.image.serverPath, fit: BoxFit.contain))
          : Container(width: 30, height: 30));
      list2.add(SizedBox(width: 10,));
      list2.add(Expanded(child: Text(getTextByLocale(item.name, strings.locale), style: theme.style14W400)));
      list2.add(SizedBox(width: 5,));
      getPriceText(item, list2, _mainModel);
      list4.add(InkWell(
          onTap: (){
            for (var item in _mainModel.currentService.price)
              item.selected = false;
            item.selected = true;
            //_mainModel.price = item;
            _redraw();
          },
          child: Container(
              color: (item.selected) ? Colors.grey.withAlpha(80) : Colors.grey.withAlpha(10),
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              child: Row(children: list2))
      ));
    }

    Widget _widgetName = Column(
      children: [
        Text(getTextByLocale(_mainModel.currentService.name, strings.locale), style: theme.style14W800),    /// name
        SizedBox(height: 5,),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: list3
        )
      ],
    );

    Widget _widgetPrice = Column(
      children: list4,
    );

    //
    // Name and price
    //
    if (isMobile()) {
      list.add(_widgetName);
      list.add(SizedBox(height: 10,));
      list.add(_widgetPrice);
    }else
      list.add(Row(
        children: [
          Expanded(child: _widgetName),
          Expanded(child: _widgetPrice)
        ],
      )
    );

    list.add(SizedBox(height: 40,));

    if (_mainModel.currentService.price.isNotEmpty) {
      list.add(Divider(color: Colors.grey.withAlpha(100), thickness: 0.5,));
      list.add(SizedBox(height: 10,));
    }

    //
    // addons
    //
    listAddons(list, windowWidth, _redraw, _mainModel);

    //
    // Description
    //

    Widget _widgetDuration = Row(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.get(24),                                                 /// "Duration",
            style: theme.style13W800,),
          Text(strings.get(25),                                                 /// "This service can take up to",
            style: theme.style12W400,)
        ],
      ),
      SizedBox(width: 20,),
      Text("${_mainModel.currentService.duration.inMinutes} ${strings.get(26)}", style: theme.style16W800,) /// min
    ],);

    Widget _widgetDesc = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getTextByLocale(_mainModel.currentService.descTitle, strings.locale),
          style: theme.style14W800, textAlign: TextAlign.start,),   /// "Description",
        Divider(color: (theme.darkMode) ? Colors.white : Colors.black, thickness: 0.5),
        SizedBox(height: 5,),
        Text(getTextByLocale(_mainModel.currentService.desc, strings.locale), style: theme.style12W400),
        SizedBox(height: 5),
        Divider(color: (theme.darkMode) ? Colors.white : Colors.black, thickness: 0.5,),
      ],
    );

    if (_mainModel.currentService.descTitle.isNotEmpty){
      isMobile() ?
          list.add(Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: (theme.darkMode) ? Colors.black : Colors.white,
              child: Column(children: [
                _widgetDesc,
                SizedBox(width: 30,),
                _widgetDuration
              ],)
          ))
          : list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Row(children: [
            Expanded(child: _widgetDesc),
            SizedBox(width: 30,),
            _widgetDuration
          ],)
      ));
    }

    list.add(SizedBox(height: 20,),);

    //
    // provider
    //
    if (_mainModel.currentService.providers.isNotEmpty)
      list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
              SizedBox(height: 5,),
              Text(strings.get(6), /// "Provider",
                style: theme.style13W800, textAlign: TextAlign.start,),
              SizedBox(height: 5,),
            ],
          )
      ));
    for (var item in _mainModel.currentService.providers){
      for (var item2 in providers){
        if (item == item2.id){
          list.add(Container(
            width: isMobile() ? windowWidth*0.6 : windowWidth*0.3,
            height: isMobile() ? windowWidth*0.6*0.45 : windowWidth*0.3*0.45,
            child: button202a(getTextByLocale(item2.name, strings.locale),
                item2.imageUpperServerPath, windowWidth*0.3, (){
                  _mainModel.currentProvider = item2;
                  _mainModel.route("provider");
                },)));
          list.add(SizedBox(height: 10,));
        }
      }
    }

    if (ifProviderHaveArticles(_mainModel.currentService.providers.isNotEmpty ? _mainModel.currentService.providers[0] : "")){
      list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
          child: Row(
            children: [
              Expanded(child: Text(strings.get(210), /// "Provider products",
                style: theme.style13W800,)),
            ],
          )));
      list.add(SizedBox(height: 20,));
      list.add(articleHorizontalBar(_mainModel.currentService.providers.isNotEmpty ? _mainModel.currentService.providers[0] : "",
          windowWidth, context, _mainModel, scrollController));
      list.add(SizedBox(height: 20,));
    }

    //
    // Gallery
    //
    list.add(Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Text(strings.get(15), /// "Galleries",
              style: theme.style13W800,)),
    );
    list.add(SizedBox(height: 10,));
    // _mainModel.gallery = _mainModel.currentService.gallery;
    if (_mainModel.currentService.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _mainModel.currentService.gallery.map((e){
            return ImageGallery(item: e, gallery: _mainModel.currentService.gallery,);
          }).toList(),
        ),
      ));

    list.add(SizedBox(height: 20,));

    if (reviews.isNotEmpty)
      list.add(Container(
          // color: (darkMode) ? blackColorTitleBkg : colorBackground,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(child: Column(
                children: [
                  Text(strings.get(211), /// "Reviews & Ratings"
                    style: theme.style14W800,),
                  SizedBox(height: 20,),
                  Row(children: [
                    card51(_mainModel.currentService.rating.toInt(), theme.serviceStarColor, 16),
                    SizedBox(width: 5,),
                    Text(_mainModel.currentService.rating.toStringAsFixed(1),
                      style: theme.style12W600StarsService, textAlign: TextAlign.center,),
                    SizedBox(width: 5,),
                    Text("(${_mainModel.currentService.countRating.toString()})", style: theme.style14W800, textAlign: TextAlign.center,),
                  ],),
                ],
              )),
            ],
          )));

    list.add(SizedBox(height: 10,));

    for (var item in reviews){
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        color: Colors.grey.withAlpha(10),
        child: card47(item.userAvatar,
          item.userName,
          appSettings.getDateTimeString(item.time),
          item.text,
          item.images,
          item.rating, //iconStarsColor: theme.serviceStarColor,
          context, strings.direction
        ),
      ));

      // list.add(SizedBox(height: 20,));
    }

    list.add(SizedBox(height: 20,));

    return list;
  }
}
