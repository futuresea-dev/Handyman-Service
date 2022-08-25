import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/widgets/cards/card42.dart';
import 'theme.dart';

class Chat2Screen extends StatefulWidget {
  @override
  _Chat2ScreenState createState() => _Chat2ScreenState();
}

class _Chat2ScreenState extends State<Chat2Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  TextEditingController messageEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    messageEditingController.dispose();
    _scrollController.dispose();
    chatId = "";
    super.dispose();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    var ret = await initChat(_redraw);
    if (ret != null)
      messageError(context, ret);
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
    return Scaffold(
        body: Directionality(
            textDirection: strings.direction,
            child: Stack(
              children: <Widget>[

                Container(
                  color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+80, bottom: 90),
                  child:
                  _chatMessages(),
                ),

                _header(),

                appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                    "", context, () {
                      goBack();
                    }),

                _editFieldForMessage(),

              ],
            ))

    );
  }

  _header(){
    return ClipPath(
        clipper: ClipPathClass23(20),
        child: Container(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: windowWidth,
            padding: EdgeInsets.only(top: 5, bottom: 30),
            child: card42(
              chatName, theme.style18W800,
              "", theme.style14W600Grey,
              Image.asset("assets/ondemand/ondemand6.png", fit: BoxFit.cover),
                (chatLogo.isNotEmpty) ?
              image16(ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Container(
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        UnconstrainedBox(child:
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(backgroundColor: Colors.black, ),
                        )),
                    imageUrl: chatLogo,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context,url,error) => Icon(Icons.error),
                  ),
                ),
              ), 60, Colors.white) : Container(),
              windowWidth,  (theme.darkMode) ? Colors.black : Colors.white,
            )
        ));
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(DateFormat(appSettings.
            dateFormat).format(_time)),)));
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

  _editFieldForMessage(){
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 10),
      width: windowWidth,
      child: Container(
        padding: EdgeInsets.all(10),
        color: (theme.darkMode) ? theme.blackColorTitleBkg : Color(0x54FFFFFF),
        child: Row(
          children: [
            Expanded(child: Edit24(
                height: 60,
                hint: strings.get(29), /// "Write your message ...",
                color: Colors.grey.withAlpha(30),
                radius: 50,
                style: theme.style14W400,
                controller: messageEditingController,
                type: TextInputType.text
            )
            ),
            SizedBox(width: 16,),
            GestureDetector(
              onTap: () async {
                if (messageEditingController.text.isNotEmpty){
                  var ret = await addMessage(messageEditingController.text, strings.get(103));  /// "Chat message"
                  if (ret == null)
                    setState(() {
                      messageEditingController.text = "";
                    });
                  else
                    messageError(context, ret);
                }
              },
              child: Image.asset("assets/ondemand/ondemand7.png",
                height: 60, width: 60,),
            ),
          ],
        ),
      ),
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
              Container(child: Text(time, style: theme.style12W600Grey,),),

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
                  style: theme.style14W600Grey
              ),
            )),

            if (!sendByMe)
              Container(child: Text(time, style: theme.style12W600Grey,),),
            if (!sendByMe)
              Container(width: 20,),
          ],
        )
    );
  }
}


