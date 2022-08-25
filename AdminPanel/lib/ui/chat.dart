import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/responsive.dart';
import 'package:ondemand_admin/widgets/cards/card41.dart';
import 'package:ondemand_admin/widgets/edit/edit32.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController messageEditingController = TextEditingController();
  final TextEditingController _controllerSearch = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var ret = await loadUsersForChatInAdminPanel();
      if (ret != null)
        messageError(context, ret);
      ret = await getChatMessages(_redraw, app: "admin");
      if (ret != null)
        return messageError(context, ret);
    });
    super.initState();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    messageEditingController.dispose();
    _scrollController.dispose();
    _controllerSearch.dispose();
    for (var item in customersChat)
      if (item.listen != null)
        item.listen!.cancel();
    super.dispose();
  }

  Widget _chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? _listMessages(snapshot.requireData)
            : Container();
      },
    );
  }

  _listMessages(QuerySnapshot snapshot) {
    List<Widget> list = [];
    DateTime? _lastTime;
    User? user = FirebaseAuth.instance.currentUser;
    for (var item in snapshot.docs) {
      if (item.data() == null)
        continue;
      Map<String, dynamic> t = item.data() as Map<String, dynamic>;
      if (t["time"] == null)
        continue;
      var _time = t["time"].toDate().toLocal();
      if (_lastTime != null)
        if (_time.year != _lastTime.year || _time.month != _lastTime.month ||
            _time.day != _lastTime.day)
          list.add(Center(child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Color(0xffa1f4f0),
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: Text(DateFormat(appSettings.dateFormat).format(_time)),)));
      _lastTime = _time;
      list.add(MessageTile(
        message: t["message"],
        sendByMe: user!.uid == t["sendBy"],
        time: DateFormat(appSettings.getTimeFormat()).format(_time),
      ));
    }
    Future.delayed(const Duration(milliseconds: 700), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
    return ListView(
      controller: _scrollController,
      children: list,);
  }

  final ScrollController _scrollController = ScrollController();

  _addMessage() async {
    if (messageEditingController.text.isNotEmpty){
      var ret = await addMessage(messageEditingController.text, strings.get(252));  /// "Chat message"
      if (ret == null)
        setState(() {
          messageEditingController.text = "";
        });
      else
        messageError(context, ret);
    }
  }

  String chatRoomId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.withAlpha(20),
        body: Stack(
          children: <Widget>[
            Responsive(
                mobile: (){
                  return Column(
                    children: [
                    Container(
                      height: windowHeight*0.4,
                      child: _users(),
                    ),
                    Container(
                      height: windowHeight*0.5,
                      child: _chat(),
                    ),
                    ],
                  );
                },
                desktop: (){
                  return Row(
                    children: [
                      Container(
                        width: windowWidth*0.3,
                        height: windowHeight,
                        child: _users(),
                      ),
                      Expanded(child: _chat()),
                    ],
                  );
                }
            ),
          ],
        ),

    );
  }

  _users(){
    return Container(
        decoration: BoxDecoration(
          color: (theme.darkMode) ? dashboardColorCardDark : dashboardColorCardGrey,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        margin: EdgeInsets.all(20),
        child: Stack(
          children: [
            _customersWindow(),
          ],
        ));
  }

  _chat(){
    return Container(
      decoration: BoxDecoration(
        color: (theme.darkMode) ? dashboardColorCardDark : dashboardColorCardGrey,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      margin: EdgeInsets.all(20),
      child: Stack(
        children: [
          Container(alignment: Alignment.topCenter,
              width: windowWidth,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(chatName, style: theme.style16W800),
                    SizedBox(height: 10,),
                    Divider()
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 60),
            child: _chatMessages(),                                           /// chat messages window
          ),
          if (chatId.isNotEmpty)
            Container(alignment: Alignment.bottomCenter,
              width: windowWidth,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(child: edit32(messageEditingController, strings.get(162), /// "Message ...",
                        (theme.darkMode) ?  Colors.white : Colors.black)),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        _addMessage();
                      },
                      child: Image.asset("assets/dashboard2/tg.png",
                        height: 35, width: 35,),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _searchText = "";

  _customersWindow(){
    List<Widget> list = [];
    list.add(Container(
      margin: EdgeInsets.all(10),
      child: Edit24(
        hint: strings.get(60), /// "Search",
        color: Colors.grey,
        style: theme.style14W400,
        radius: 10,
        controller: _controllerSearch,
          onChangeText: (String text){
            _searchText = text;
            setState(() {
            });
          }
      )
    ));

    list.add(SizedBox(height: 20,));

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return list;

    for (var item in customersChat){
      if (_searchText.isNotEmpty)
        if (!item.name.toUpperCase().contains(_searchText.toUpperCase()) && !item.email.toUpperCase().contains(_searchText.toUpperCase()))
          continue;

        Widget w = InkWell(
            onTap: () async {
              setChatData(item.name, item.unread, item.logoServerPath, item.id);
              await initChat(_redraw);
              _redraw();
            },
            child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Card41(
                    all: item.all,
                    unread: item.unread,
                    image: item.logoServerPath,
                    name: item.name,
                    email: item.email,
                    lastMessage: item.lastMessage,
                    lastMessageTime: item.lastMessageTime != null
                        ? appSettings.getDateTimeString(item.lastMessageTime!)
                        : "",
                    bkgColor: item.id == chatId ? Colors.blue.withAlpha(40): (theme.darkMode) ? Colors.black : Colors.white
                )
            ));
      if (item.id == chatId)
        list.insert(2, w);
      else
        list.add(w);

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

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String time;

  MessageTile({required this.message, required this.sendByMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [

            if (sendByMe)
              Container(width: 20,),
            if (sendByMe)
              Container(child: Text(time, style: theme.style12W800,),),

            Flexible(child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: sendByMe ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                ) :
                BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: sendByMe ? Color(0xffa1f4f0) : Color(0xffe1f0ff),
              ),
              child: Text(message,
                  textAlign: TextAlign.start,
                  maxLines: 20,
                  style: TextStyle(
                    fontFamily: theme.font,
                    color: Color(0xff7e8299),)),
            )),

            if (!sendByMe)
              Container(child: Text(time, style: theme.style12W800,),),
            if (!sendByMe)
              Container(width: 20,),
          ],
        )
    );
  }
}


