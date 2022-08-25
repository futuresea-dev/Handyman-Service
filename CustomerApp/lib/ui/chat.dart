import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/cards/card41.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  String _searchText = "";
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _scrollController.addListener(_scrollListener);
    _init();
    super.initState();
  }

  _init() async {
    _waits(true);
    var ret = await loadUsersForChatInCustomerApp();
    if (ret != null)
      return messageError(context, ret);
    _waits(false);
    ret = await getChatMessages(_redraw);
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

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
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

            IEasyDialog2(setPosition: (double value){_show = value;
              if (_show == 0){
                _mainModel.showBottomBar = true;
                redrawMainWindow();
              }
            }, getPosition: () {return _show;}, color: Colors.grey,
              getBody: _getDialogBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),

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
            child:
            Container(
              width: windowWidth*0.3,
              height: windowWidth*0.3,
              child: theme.chatLogoAsset ? Image.asset("assets/ondemands/ondemand21.png", fit: BoxFit.contain) :
              showImage(theme.chatLogo, fit: BoxFit.contain)
              //
              // CachedNetworkImage(
              //     imageUrl: ,
              //     imageBuilder: (context, imageProvider) => Container(
              //       decoration: BoxDecoration(
              //         image: DecorationImage(
              //           image: imageProvider,
              //           fit: BoxFit.contain,
              //         ),
              //       ),
              //     )
              // ),
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
          color: (theme.darkMode) ? Colors.black : Colors.white,
          decor: decor,
          style: theme.style14W400,
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

    for (var item in customersChat){
      if (_searchText.isNotEmpty)
        if (!item.name.toUpperCase().contains(_searchText.toUpperCase()))
            continue;
      list.add(InkWell(
        onTap: (){
          setChatData(item.name, item.unread, item.logoServerPath, item.id);
          if (userAccountData.blockedUsers.contains(item.id)){
            _openDialog("");
          }else
            route("chat2");
        },
          child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
              child: Card41(
              all: item.all,
              unread: item.unread,
              image: item.logoServerPath,
              text1: item.name,
              text2: item.lastMessage, style2: theme.style14W600Grey,
              text3: item.lastMessageTime != null
                  ? appSettings.getDateTimeString(item.lastMessageTime!)
                  : "",
              style3: theme.style12W600Grey,
              blocked: userAccountData.blockedUsers.contains(item.id),
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

  double _show = 0;

  _openDialog(String val){
    _show = 1;
    _mainModel.showBottomBar = false;
    redrawMainWindow();
    // _redraw();
  }

  Widget _getDialogBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${strings.get(252)} $chatName?", style: theme.style14W800,), /// Unblock
        SizedBox(height: 10,),
        Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
        SizedBox(height: 10,),
        Text(strings.get(253), style: theme.style14W400), /// They be able to message you. You be able to message them. They won't be notified that you unblocked them.
        SizedBox(height: 60,),
        button2(strings.get(252), theme.mainColor, () async { /// "Unblock"
          var ret = await removeBlockedUser(chatId);
          if (ret != null)
            messageError(context, ret);
          else{
            _show = 0;
            _mainModel.showBottomBar = true;
            redrawMainWindow();
            messageOk(context, "${strings.get(245)} $chatName ${strings.get(254)}"); /// "User" unblocked
          }
        }),
        SizedBox(height: 10,),
        button2(strings.get(246), theme.mainColor,  (){ /// "Cancel"
          _show = 0;
          _mainModel.showBottomBar = true;
          redrawMainWindow();
        }),
      ],
    );
  }
}

