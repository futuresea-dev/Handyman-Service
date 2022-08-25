import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'package:ondprovider/widgets/cards/card46.dart';
import 'theme.dart';

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
    super.initState();
  }

  _init() async {
    _waits(true);
    var ret = await loadReviewsForProviderScreen(currentProvider.id);
    if (ret != null)
      messageError(context, ret);
    _waits(false);
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
    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+130, left: 10, right: 10),
              child: ListView(
                children: _getList(),
              ),
            ),

            ClipPath(
                clipper: ClipPathClass23(20),
                child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    width: windowWidth,
                    child: card46(
                        rating.isNaN ? "0" : rating.toStringAsFixed(1), theme.style25W800,
                        strings.get(75), /// "Average Ratings",
                        theme.style12W600Grey,
                        Image.asset("assets/ondemand/ondemand13.png", fit: BoxFit.cover),
                        windowWidth, (theme.darkMode) ? Colors.black : Colors.white, (){}
                    )
                )),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black, "", context, () {
              Navigator.pop(context);
            }),


            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

          ],
        ))

    );
  }

  _getList(){
    List<Widget> list = [];

    for (var item in reviews){
       list.add(card47(item.userAvatar,
           item.userName,
           appSettings.getDateTimeString(item.time),
           item.text,
           item.images,
           item.rating,
           context, strings.direction
       ),);
       list.add(SizedBox(height: 10,));
    }

    list.add(SizedBox(height: 100,));

    return list;
  }
}
