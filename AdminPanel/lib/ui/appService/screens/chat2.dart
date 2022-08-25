
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/widgets/cards/card42.dart';
import 'theme.dart';

class Chat2Screen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;
  const Chat2Screen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Scaffold(
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            // Container(
            //     color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
            //     margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+80, bottom: 90),
            //     child:
            //     _chatMessages(),
            //
            // ),

            _header(),

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black,
                "", context, () {
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
      color: (darkMode) ? Colors.black : Colors.white,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: windowWidth,
      padding: EdgeInsets.only(top: 5, bottom: 30),
      child: card42(
        "user name", theme.style18W800,
        "", theme.style14W600Grey,
            //Image.asset("assets/ondemands/ondemand6.png", fit: BoxFit.cover),
          serviceApp.chat2LogoAsset ? Image.asset("assets/ondemands/ondemand6.png", fit: BoxFit.cover) :
          Image.network(
              serviceApp.chat2Logo,
              fit: BoxFit.cover),
            Container(),
            windowWidth,  (darkMode) ? Colors.black : Colors.white,
        )
    ));
  }

  _editFieldForMessage(){
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 10),
      width: windowWidth,
      child: Container(
        padding: EdgeInsets.all(10),
        color: (darkMode) ? serviceApp.blackColorTitleBkg : Color(0x54FFFFFF),
        child: Row(
          children: [
            Expanded(child: Edit24(
              height: 60,
                hint: strings.get(57), // "Write your message ...",
                color: Colors.grey.withAlpha(30),
                radius: 50,
                style: theme.style14W400,
                controller: messageEditingController,
                type: TextInputType.emailAddress
            )
            ),
            SizedBox(width: 16,),
            GestureDetector(
              onTap: () async {

              },
              child: Container(
                width: 60,
                height: 60,
                child: serviceApp.chatSendButtonImageAsset ? Image.asset("assets/ondemands/ondemand7.png", fit: BoxFit.contain) :
                Image.network(
                    serviceApp.chatSendButtonImage,
                    fit: BoxFit.contain)
                // Image.asset("assets/ondemands/ondemand7.png",
                //   height: 60, width: 60,),
              )
            ),
          ],
        ),
      ),
    );
  }

  // List<Widget> _childs() {
  //   List<Widget> list = [];
  //
  //   list.add(Center(child: Container(
  //     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
  //     decoration: BoxDecoration(
  //       color: Color(0xffa1f4f0),
  //       borderRadius: BorderRadius.circular(theme.radius),
  //     ),
  //     child: Text("12 may")))
  //   );
  //
  //   list.add(MessageTile(
  //     message: "I want to clear my carpet",
  //     sendByMe: false,
  //     time: "12:30",
  //   ));
  //
  //   list.add(MessageTile(
  //     message: "Hello",
  //     sendByMe: true,
  //     time: "12:34",
  //   ));
  //
  //   return list;
  // }
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


