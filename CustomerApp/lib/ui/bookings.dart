import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'theme.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

int _lastPage = 0;

class _BookingScreenState extends State<BookingScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: appSettings.statuses.length);
    if (_tabController != null)
      _tabController!.addListener(() {
        _lastPage = _tabController!.index;
        _redraw();
      });
    _tabController!.animateTo(_lastPage);
    super.initState();
  }

  _redraw(){
    if(mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    _tabController!.dispose();
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
          children: <Widget>[

            Container(
              height: windowHeight,
              width: windowWidth,
              margin: EdgeInsets.only(top: 130),
              child: TabBarView(
                controller: _tabController,
                children: _tabBody()
              ),
            ),

            ClipPath(
                clipper: ClipPathClass23(20),
                child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: windowWidth,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.get(63), // "Booking",
                      style: theme.style20W800),
                  SizedBox(height: 20,),
                  TabBar(
                    labelColor: Colors.black,
                    indicatorWeight: 4,
                    isScrollable: true,
                    indicatorColor: theme.mainColor,
                    tabs: _tabHeaders(),
                    controller: _tabController,
                  ),
                ],
              ),
            )),


          ],
        ))

    );
  }

  _tabHeaders(){
    List<Widget> list = [];
    for (var item in appSettings.statuses)
      list.add(Text(getTextByLocale(item.name, strings.locale),
          textAlign: TextAlign.center, style: theme.style12W800));
    return list;
  }

  _tabBody(){
    List<Widget> list = [];
    for (var item in appSettings.statuses)
        list.add(_tabChild(item.id, getTextByLocale(item.name, strings.locale)));
    return list;
  }

  _tabChild(String sort, String _text){
    List<Widget> list = [];

    bool _empty = true;
    for (var item in ordersDataCache){
      if (item.status != sort)
        continue;
      // var _date = strings.get(109); /// "Any Time",
      // if (!item.anyTime)
      //   _date = appSettings.getDateTimeString(item.selectTime);
      list.add(InkWell(
          onTap: () async {
            waitInMainWindow(true);
            var ret = await bookingGetItem(item);
            waitInMainWindow(false);
            if (ret != null)
              return messageError(context, ret);
            route("jobinfo");
          },
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card43(image: item.providerImage,
                text1: getTextByLocale(item.providerName, strings.locale),
                text2: item.name,
                text3: getPriceString(item.total),
                date: _text,
                // bookingAt: _date,
                dateCreating: appSettings.getDateTimeString(item.time),
                bookingId: item.id,
                icon: Icon(Icons.payment, color: theme.mainColor, size: 15,),
                bkgColor: (theme.darkMode) ? Colors.black : Colors.white,
                stringBookingId: strings.get(232), /// "Booking ID",
                stringTimeCreation: strings.get(231), /// Time creation

              ))
      ));
      list.add(SizedBox(height: 10,));
      _empty = false;
    }

    if (_empty) {
      list.add(Center(child:
      Container(
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.bookingNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.bookingNotFoundImage,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            )
        ),
        // Image.network(
        //     theme.logo,
        //     fit: BoxFit.cover),
      ),
      //Image.asset("assets/nofound.png"))
      ));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 200,));
    return ListView(
      children: list,
    );
  }

}


