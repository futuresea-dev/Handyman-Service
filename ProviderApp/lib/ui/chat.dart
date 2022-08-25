import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/widgets/cards/card41.dart';
import 'theme.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  String _searchText = "";
  double windowSize = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _init();
    super.initState();
  }

  _init() async {
    _waits(true);
    var ret = await loadUsersForChatInProviderApp();
    if (ret != null)
      messageError(context, ret);
    _waits(false);
    ret = await getChatMessages(_redraw, app: "provider");
    if (ret != null)
      messageError(context, ret);
    _redraw();
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
    _controllerSearch.dispose();
    for (var item in customersChat)
      if (item.listen != null)
        item.listen!.cancel();
    super.dispose();
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
                    child: Stack(
                      children: [
                        _body(),
                        if (_wait)
                          Center(child: Container(child: Loader7v1(color: theme.mainColor,))),
                      ],
                    ),
                  ),
                ),

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
              child: Image.asset("assets/ondemand/ondemand21.png", fit: BoxFit.cover),
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
        padding: EdgeInsets.only(bottom: _scroller, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(26), /// "Chat",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(101), /// Chatting online
                style: theme.style10W600Grey),
          ],
        )
    );
  }

  _body(){
    List<Widget> list = [];

    list.add(Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Edit26(
          hint: strings.get(102), /// "Search",
          color: (theme.darkMode) ? Colors.black : Colors.white,
          style: theme.style14W400,
          decor: decor,
          icon: Icons.search,
          useAlpha: false,
          controller: _controllerSearch,
          onChangeText: (String value){
            _searchText = value;
            setState(() {
            });
          }
      ),
    ));

    list.add(SizedBox(height: 20,));

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return list;

    for (var item in customersChat){
      if (_searchText.isNotEmpty)
        if (!item.name.toUpperCase().contains(_searchText.toUpperCase()))
            continue;

      list.add(InkWell(
          onTap: (){
            setChatData(item.name, item.unread, item.logoServerPath, item.id);
            route("chat2");
          },
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card41(
                all: item.all,
                unread: item.unread,
                image: item.logoServerPath,
                text1: item.name, style1: theme.style16W800,
                text2: item.lastMessage, style2: theme.style14W600Grey,
                text3: item.lastMessageTime != null
                    ? appSettings.getDateTimeString(item.lastMessageTime!)
                    : "",
                style3: theme.style12W600Grey,
                bkgColor: (theme.darkMode) ? Colors.black : Colors.white
              )
          )));
      list.add(SizedBox(height: 10,));
    }

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          children: list,
        )
    );
  }
}

