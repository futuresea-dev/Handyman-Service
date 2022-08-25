import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/cards/card42.dart';

class Chat2Screen extends StatefulWidget {
  @override
  _Chat2ScreenState createState() => _Chat2ScreenState();
}

class _Chat2ScreenState extends State<Chat2Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final TextEditingController _messageEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _editControllerText = TextEditingController();

  @override
  void dispose() {
    _messageEditingController.dispose();
    _scrollController.dispose();
    _editControllerText.dispose();
    chatId = "";
    super.dispose();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    var ret = await initChat((){setState(() {});});
    if (ret != null)
      messageError(context, ret);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
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
            }, enableRightMenuButton: true, onRightMenuClick:
              (){
                _openDialog("");
              }),

            _editFieldForMessage(),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
              getBody: _getDialogBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),


          ],
        ))

    );
  }

  _header(){
    return ClipPath(
        clipper: ClipPathClass23(20),
    child: Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 20, right: 20),
      width: windowWidth,
      padding: EdgeInsets.only(top: 5, bottom: 30),
      child: card42(
        chatName, theme.style18W800,
        "", theme.style14W600Grey,
            // background color
        theme.chat2LogoAsset ? Image.asset("assets/ondemands/ondemand6.png", fit: BoxFit.cover) :
        CachedNetworkImage(
            imageUrl: theme.chat2Logo,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            )
        ),
            // user avatar
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
                hint: strings.get(57), // "Write your message ...",
                color: Colors.grey.withAlpha(30),
                radius: 50,
                style: theme.style14W400,
                controller: _messageEditingController,
                type: TextInputType.text
            )
            ),
            SizedBox(width: 16,),
            GestureDetector(
              onTap: () async {
                if (_messageEditingController.text.isNotEmpty){
                  var ret = await addMessage(_messageEditingController.text, strings.get(156));  /// "Chat message"
                  if (ret == null)
                    setState(() {
                      _messageEditingController.text = "";
                    });
                  else
                    messageError(context, ret);
                }
              },
              child: Container(
                width: 60,
                height: 60,
                child: theme.chatSendButtonImageAsset ? Image.asset("assets/ondemands/ondemand7.png", fit: BoxFit.contain) :
                CachedNetworkImage(
                    imageUrl: theme.chatSendButtonImage,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                ),
                  // Image.asset("assets/ondemands/ondemand7.png",
                  //   height: 60, width: 60,)
              )
            ),
          ],
        ),
      ),
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  String _dialogName = "";
  double _show = 0;

  _openDialog(String val){
    _dialogName = val;
    _show = 1;
    _redraw();
  }

  Widget _getDialogBody(){
    if (_dialogName == "block")
      return _getBodyDialogBlock();
    if (_dialogName == "report")
      return _getBodyDialogReport();
    if (_dialogName == "reportSent")
      return _getBodyDialogReportSent();

    return _getBodyDialogMenu();
  }

  Widget _getBodyDialogReportSent(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.get(250), style: theme.style14W800,), /// Thanks for letting us know
        SizedBox(height: 10,),
        Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
        SizedBox(height: 10,),
        Text(strings.get(251), style: theme.style14W400), /// "Your feedback is important in helping us keep the community safe.
        SizedBox(height: 60,),
        button2(strings.get(114), theme.mainColor, (){ /// "Ok"
          _show = 0;
          _redraw();
        }),
      ],
    );
  }

  Widget _getBodyDialogReport(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.get(241), style: theme.style14W800,), /// Report
        SizedBox(height: 10,),
        Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
        SizedBox(height: 10,),
        Text(strings.get(248), style: theme.style14W400), /// "Why are you reporting this user?"
        SizedBox(height: 10,),
        Text(strings.get(249), style: theme.style14W400), /// Your report is anonymous, except if you're reporting an intellectual property infringement.
        SizedBox(height: 10,),
        edit42("", _editControllerText, strings.get(57), /// "Write your message ...",
        ),
        SizedBox(height: 30,),
        button2(strings.get(241), theme.mainColor, (){ /// "Report"
          if (_editControllerText.text.isEmpty)
            return messageError(context, strings.get(57)); /// "Write your message ...",
          _openDialog("reportSent");
        }),
        SizedBox(height: 10,),
        button2(strings.get(246), theme.mainColor, (){ /// "Cancel"
          _show = 0;
          _redraw();
        }),
      ],
    );
  }

  Widget _getBodyDialogBlock(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${strings.get(243)} $chatName?", style: theme.style14W800,), /// Block
        SizedBox(height: 10,),
        Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
        SizedBox(height: 10,),
        Text(strings.get(244), style: theme.style14W400), /// "They won't be able to message you. You won't be able to message them. They won't be notified that you blocked them. "
        SizedBox(height: 60,),
        button2(strings.get(242), theme.mainColor, () async { /// "Block user"
          var ret = await addBlockedUser(chatId);
          if (ret != null)
            messageError(context, ret);
          else{
            goBack();
            messageOk(context, "${strings.get(245)} $chatName ${strings.get(247)}"); /// "User" blocked
          }
        }),
        SizedBox(height: 10,),
        button2(strings.get(246), theme.mainColor,  (){ /// "Cancel"
          _show = 0;
          _redraw();
        }),
      ],
    );
  }

  Widget _getBodyDialogMenu(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        button1s(strings.get(241), Icons.report, "report", _openDialog), /// "Report ..."
        SizedBox(height: 10,),
        button1s(strings.get(242), Icons.block, "block", _openDialog), /// "Block user"
        SizedBox(height: 10,),
        Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
        SizedBox(height: 10,),
        button1s(strings.get(246), Icons.cancel, "", (String _){ /// "Cancel"
          _show = 0;
          _redraw();
        }),
      ],
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


