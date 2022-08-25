
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class BookingScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;
  const BookingScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  TabController? _tabController;
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _tabController = TabController(vsync: this, length: appSettings.statuses.length);
    super.initState();
  }

  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

  @override
  void dispose() {
    _tabController!.dispose();
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
              color: (darkMode) ? Colors.black : Colors.white,
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
                    indicatorColor: serviceApp.mainColor,
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
      list.add(Text(getTextByLocale(item.name, _mainModel.currentEmulatorLanguage),
          textAlign: TextAlign.center, style: theme.style12W800));
    return list;
  }

  _tabBody(){
    List<Widget> list = [];
    for (var item in appSettings.statuses)
        list.add(_tabChild(item.id, getTextByLocale(item.name, _mainModel.currentEmulatorLanguage)));
    return list;
  }

  _tabChild(String sort, String _text){
    List<Widget> list = [];

    int _count = 0;
    bool _empty = true;
    for (var item in ordersDataCache){
      if (item.status != sort)
        continue;
      _count++;
      if (_count == 10)
        break;
      // var _date = strings.get(109); /// "Any Time",
      // if (!item.anyTime)
      //   _date = Provider.of<MainModel>(context,listen:false).getDateTimeString(item.selectTime);
      list.add(InkWell(
          onTap: (){},
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card43(
                image: item.providerImage,
                text1: getTextByLocale(item.providerName, locale),
                text2: item.name,
                text3: getPriceString(item.total),
                date: _text,
                // bookingAt: _date,
                dateCreating: appSettings.getDateTimeString(item.time),
                bookingId: item.id,
                icon: Icon(Icons.payment, color: Colors.black, size: 15,),
                bkgColor: (darkMode) ? Colors.black : Colors.white,
                stringBookingId: strings.get(66), /// "Booking ID",
                stringTimeCreation: strings.get(231), /// Time creation

                // image: item.customerAvatar,
                // text1: getTextByLocale(item.provider, _mainModel.currentEmulatorLanguage), style1: theme.style16W800,
                // text2: getTextByLocale(item.service, _mainModel.currentEmulatorLanguage), style2: theme.style12W600Grey,
                // text3: _date, style3: theme.style14W400,
                // text4: _text, style4: theme.style16W800Blue,
                // icon: Icon(Icons.calendar_today_outlined, color: serviceApp.mainColor, size: 15,),
                // bkgColor: (darkMode) ? Colors.black : Colors.white,
              )
          )
      ));
      list.add(SizedBox(height: 10,));
      _empty = false;
    }

    if (_empty) {
      list.add(Center(child: Container(
        width: windowWidth*0.7,
        height: windowHeight*0.7,
        child: serviceApp.bookingNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        Image.network(
            serviceApp.bookingNotFoundImage,
            fit: BoxFit.contain),))); //Image.asset("assets/nofound.png")));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 200,));
    return ListView(
      children: list,
    );
  }
}


