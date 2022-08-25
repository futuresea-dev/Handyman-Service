import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlogDetailsScreen extends StatefulWidget {
  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {

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
    setState(() {
    });
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
        backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
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
                                child: Stack(
                                  children: [
                                    FlexibleSpaceBar(
                                      collapseMode: CollapseMode.pin,
                                      background: _title(),
                                      titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                    ),
                                  ],
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

                appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                    "", context, () {goBack();}),

              ]),
        ));
  }

  _title() {
    return Container(
        color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        height: windowHeight * 0.3,
        width: windowWidth,
        child: Container(
            width: windowWidth,
            margin: EdgeInsets.only(bottom: 10),
            child: _mainModel.openBlog!.serverPath.isNotEmpty ? CachedNetworkImage(
                imageUrl: _mainModel.openBlog!.serverPath,
                imageBuilder: (context, imageProvider) => Container(
                  width: double.maxFinite,
                  alignment: Alignment.bottomRight,
                  child: Container(
                    //width: height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                  ),
                )
            ) : Container()
        )
    );
  }

  _body(){
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ListView(
        padding: EdgeInsets.only(top: 0),
      children: [
        Text(getTextByLocale(_mainModel.openBlog!.name, strings.locale), style: theme.style14W800,),
        SizedBox(height: 10),
        Text(timeago.format(_mainModel.openBlog!.time, locale: appSettings.currentServiceAppLanguage),
            overflow: TextOverflow.ellipsis, style: theme.style10W600Grey),
        SizedBox(height: 20,),
        Html(
            data: "<body>${getTextByLocale(_mainModel.openBlog!.text, strings.locale)}",
            style: {
              "body": Style(
                  backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
                  color: (theme.darkMode) ? Colors.white : Colors.black
              ),
            }
        ),
        SizedBox(height: 300,),
      ],
    ));
  }
}

