import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/horizontal_articles.dart';
import 'package:ondemand_admin/widgets/image.dart';
import 'package:ondemand_admin/widgets/service_item.dart';
import 'package:provider/provider.dart';
import '../mainModel/model.dart';
import 'strings.dart';
import '../theme.dart';

class ProviderScreen extends StatefulWidget {
  @override
  _ProviderScreenState createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;
  var scrollController = ScrollController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Column(children : _getList());
  }

  List<Widget> _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    User? user = FirebaseAuth.instance.currentUser;

    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(strings.get(6), style: theme.style18W800,), /// "Provider",
        SizedBox(width: 20,),
        if (user != null)
          IconButton(
              icon: userAccountData.userFavoritesProviders.contains(_mainModel.currentProvider.id)
                  ? Icon(Icons.favorite, size: 25,)
                  : Icon(Icons.favorite_border, size: 25,),
              color: Colors.orange,
              onPressed: () {
                changeFavoritesProviders(_mainModel.currentProvider);
                redrawMainWindow();
              },
          )
      ],
    ));

    list.add(SizedBox(height: 10,));

    Widget _widgetWWW = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_mainModel.currentProvider.phone.isNotEmpty)
          Row(children: [
            Text(strings.get(3) + ":", style: theme.style14W600Grey,), /// "Phone"
            SizedBox(width: 10,),
            Text(_mainModel.currentProvider.phone, style: theme.style14W600,)
          ],),
        SizedBox(height: 10,),
        if (_mainModel.currentProvider.www.isNotEmpty)
          Row(children: [
            Text(strings.get(4) + ":", style: theme.style14W600Grey,), /// "WWW"
            SizedBox(width: 10,),
            ButtonTextWeb(text: _mainModel.currentProvider.www, onTap: (){
              openUrl(_mainModel.currentProvider.www);
            })
          ],),
        SizedBox(height: 10,),
        if (_mainModel.currentProvider.instagram.isNotEmpty)
          Row(children: [
            Text(strings.get(5) + ":", style: theme.style14W600Grey,), /// "Instagram"
            SizedBox(width: 10,),
            ButtonTextWeb(text: _mainModel.currentProvider.instagram, onTap: (){
              openUrl(_mainModel.currentProvider.instagram);
            },)
          ],),
        SizedBox(height: 10,),
        if (_mainModel.currentProvider.telegram.isNotEmpty)
          Row(children: [
            Text(strings.get(7) + ":", style: theme.style14W600Grey,), /// "Telegram"
            SizedBox(width: 10,),
            ButtonTextWeb(text: _mainModel.currentProvider.telegram, onTap: (){
              openUrl(_mainModel.currentProvider.telegram);
            },)
          ],),
      ],
    );

    Widget _widgetName = Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Card50forProvider(
          direction: strings.direction,
          locale: strings.locale,
          category: categories,
          provider: _mainModel.currentProvider,
        )
    );

    //
    // Logo, name and phone
    //
    if (isMobile()){
      list.add(_widgetName);
      SizedBox(height: 10,);
      list.add(_widgetWWW);
    }else
      list.add(Row(
        children: [
          Expanded(child: _widgetName),
          SizedBox(width: 10,),
          _widgetWWW
        ],
      ));

    list.add(SizedBox(height: 20,));

    //
    // About us and work time
    //
    List<Widget> list2 = [];
    var index = 0;
    for (var item in _mainModel.currentProvider.workTime){
      if (item.weekend)
        continue;
      list2.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Text(strings.get(8+index), style: theme.style14W800,),
              SizedBox(width: 10,),
              Text(item.openTime, style: theme.style14W400),
              Text("-"),
              Text(item.closeTime, style: theme.style14W400),
            ],
          )));
      list2.add(SizedBox(height: 5,));
      index++;
    }

    Widget _widgetWorkTime = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list2
    );

    Widget _widgetDesc = Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        color: (theme.darkMode) ? Colors.black : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getTextByLocale(_mainModel.currentProvider.descTitle, strings.locale),
              style: theme.style16W800, textAlign: TextAlign.start,),   // "Description",
            Divider(color: (theme.darkMode) ? Colors.white : Colors.black, thickness: 0.5,),
            SizedBox(height: 5,),
            Text(getTextByLocale(_mainModel.currentProvider.desc, strings.locale), style: theme.style14W400),
            SizedBox(height: 5,),
            Divider(color: (theme.darkMode) ? Colors.white : Colors.black, thickness: 0.5,),
          ],
        )
    );

    if (isMobile()){
      list.add(_widgetDesc);
      list.add(SizedBox(height: 10,));
      list.add(_widgetWorkTime);
    }else
      list.add(Row(
        children: [
          if (_mainModel.currentProvider.descTitle.isNotEmpty)
            Expanded(child: _widgetDesc),
          _widgetWorkTime
        ],
      ));

    list.add(SizedBox(height: 20,));

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
      list.add(articleHorizontalBar(_mainModel.currentProvider.id, windowWidth, context, _mainModel, scrollController));
      list.add(SizedBox(height: 20,));
    }

    //
    // Gallery
    //
    list.add(Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Text(strings.get(15), /// "Galleries",
              style: theme.style14W800,)),
    );

    list.add(SizedBox(height: 10,));

    //_mainModel.gallery = _mainModel.currentProvider.gallery;
    if (_mainModel.currentProvider.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _mainModel.currentProvider.gallery.map((e){
            return ImageGallery(item: e, gallery: _mainModel.currentProvider.gallery,);
          }).toList(),
        ),
      ));

    list.add(SizedBox(height: 20,));

    //
    // Services
    //
    list.add(Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Text(strings.get(16), /// "Services",
          style: theme.style14W800,)),
    );

    list.add(SizedBox(height: 20,));

    List<Widget> list3 = [];
    for (var item in product){
      if (!item.providers.contains(_mainModel.currentProvider.id))
        continue;
      var _width = isMobile() ? windowWidth*0.9-40 : windowWidth*0.4-40;
      list3.add(serviceItem(_width, -1, _mainModel, item, user));
    }

    list.add(Wrap(
      spacing: 10,
      runSpacing: 10,
      children: list3,
    ));

    list.add(SizedBox(height: 20,));

    return list;
  }
}
