
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'theme.dart';

class ChatScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;
  const ChatScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Scaffold(
      backgroundColor: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
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
                            color: (darkMode) ? Colors.black : Colors.white,
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

                  ],
                ),
              ),
            ),

          ]),
      ));
  }

  _title() {
    return Container(
      color: (darkMode) ? Colors.black : Colors.white,
      height: windowHeight * 0.3,
      width: windowWidth/2,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              width: windowWidth*0.3,
              child: serviceApp.chatLogoAsset ? Image.asset("assets/ondemands/ondemand21.png", fit: BoxFit.contain) :
              Image.network(
                  serviceApp.chatLogo,
                  fit: BoxFit.cover)
              //Image.asset("assets/ondemands/ondemand21.png", fit: BoxFit.cover),
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
            Text(strings.get(7), // "Chat",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(85), // Chatting online
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
          hint: strings.get(122), /// "Search",
          color: (darkMode) ? Colors.black : Colors.white,
          style: theme.style14W400,
          decor: decor,
          icon: Icons.search,
          useAlpha: false,
          controller: _controllerSearch,
          onChangeText: (String value){
            // _searchText = value;
            setState(() {
            });
          }
      ),
    ));

    list.add(SizedBox(height: 20,));

    // for (var item in _mainModel.customersChat){
    //   if (_searchText.isNotEmpty)
    //     if (!item.name.toUpperCase().contains(_searchText.toUpperCase()))
    //         continue;
    //   list.add(InkWell(
    //     onTap: (){
    //       Provider.of<MainModel>(context,listen:false)
    //           .setChatData(item.name, item.unread, item.logoServerPath, item.id);
    //       widget.callback("chat");
    //     },
    //       child: Container(
    //       margin: EdgeInsets.only(left: 10, right: 10),
    //           child: Card41(
    //           all: item.all,
    //           unread: item.unread,
    //           image: item.logoServerPath,
    //           text1: item.name, style1: theme.style16W800,
    //           text2: item.lastMessage, style2: theme.style14W600Grey,
    //           text3: item.lastMessageTime != null
    //               ? Provider.of<MainModel>(context,listen:false).localAppSettings.getDateTimeString(item.lastMessageTime!)
    //               : "",
    //           style3: theme.style12W600Grey,
    //           bkgColor: (darkMode) ? Colors.black : Colors.white
    //       )
    //   )));
    //   list.add(SizedBox(height: 10,));
    // }

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          children: list,
        )
    );
  }
}

