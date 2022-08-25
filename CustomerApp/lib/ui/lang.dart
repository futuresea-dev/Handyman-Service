import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../model/model.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  final bool openFromSplash;

  const LanguageScreen({Key? key, this.openFromSplash = true}) : super(key: key);
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final ScrollController _scrollController = ScrollController();
  late MainModel _mainModel;

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
    _redraw();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
              children: [
                NestedScrollView(
                  controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          expandedHeight: windowHeight*0.2,
                          automaticallyImplyLeading: false,
                          pinned: true,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: ClipPath(
                            clipper: ClipPathClass23((_scroller < 5) ? 5 : _scroller),
                              child: Container(
                              color: (theme.darkMode) ? Colors.black : Colors.white,
                              child: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: _title(),
                            titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                            title: _titleSmall()
                          )),
                        ))
                      ];
                    },
                  body: Container(
                    width: windowWidth,
                    height: windowHeight,
                    child: _body(),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.all(20),
                  child: button2(strings.get(2), theme.mainColor, _submit), /// "SUBMIT",
                )
              ]),
        ));
  }

  _title() {
    return Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      height: windowHeight * 0.3,
      width: windowWidth/2,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              width: windowWidth*0.3,
              child: theme.langLogoAsset ? Image.asset("assets/ondemands/ondemand3.png", fit: BoxFit.cover) :
              CachedNetworkImage(
                  imageUrl: theme.langLogo,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
              ),
              //Image.asset("assets/ondemands/ondemand3.png", fit: BoxFit.cover),
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          ),
        ],
      ),
    );
  }

  _titleSmall(){
    return Container(
        alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _scroller),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(3), // "Language",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(4), // "Preferred Language",
                style: theme.style10W600Grey),
          ],
        )
    );
  }

  _body(){
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
        children: _children(),
      ),
    );
  }

  _children() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(5), // "Select Preferred Language",
         style: theme.style18W800));
    list.add(SizedBox(height: 20,));
    list.add(_radioGroup());
    list.add(SizedBox(height: 200,));
    return list;
  }

  _radioGroup(){
    List<Widget> list = [];

    for (var item in _mainModel.appLangs)
      list.add(ListTile(
          title: Text(
            item.name, style: theme.style14W800,
          ),
          leading: Radio(
            value: item.locale,
            groupValue: appSettings.currentServiceAppLanguage,
            activeColor: theme.mainColor,
            onChanged: (String? value) {
              if (value == null)
                return;
              _set = true;
              _mainModel.lang.setLang(value, context);
              _redraw();
            },
          )));

    return Theme(
        data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.grey
    ),
    child: Column(
      children: list
    ));
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  var _set = false;

  _submit() async {
    if (!_set)
      _mainModel.lang.setLang("en", context);
    if (!widget.openFromSplash) {
      goBack();
    }else {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/ondemandservice_main");
    }
  }
}

