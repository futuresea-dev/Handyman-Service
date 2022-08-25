import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import 'strings.dart';
import '../../theme.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;
  TabController? _tabController;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _tabController = TabController(vsync: this, length: appSettings.statuses.length);
    super.initState();
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
    return Stack(
      children: <Widget>[

        Container(
          alignment: Alignment.center,
          child: Container(
          height: windowHeight,
          width: isMobile() ? windowWidth*0.9 : windowWidth*0.4,
          margin: EdgeInsets.only(top: 170),
          child: TabBarView(
              controller: _tabController,
              children: _tabBody()
          ),
        )),

        Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: windowWidth,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  BackSiteButton(text: strings.get(47)), /// "Go back",
                  SizedBox(height: 20,),

                  Text(strings.get(124), /// "Booking",
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
            ),

      ],
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
      // var _date = strings.get(144); /// "Any Time",
      // if (!item.anyTime)
      //   _date = appSettings.getDateTimeString(item.selectTime);
      list.add(InkWell(
          onTap: () async {
            waitInMainWindow(true);
            var ret = await bookingGetItem(item);
            waitInMainWindow(false);
            if (ret != null)
              return messageError(context, ret);
            _mainModel.route("jobinfo");
          },
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              width: isMobile() ? windowWidth*0.9 : windowWidth*0.4,
              child: Card43(image: item.providerImage,
                text1: getTextByLocale(item.providerName, strings.locale),
                text2: item.name,
                text3: getPriceString(item.total),
                date: _text,
                dateCreating: appSettings.getDateTimeString(item.time),
                bookingId: item.id,
                // text4: _text,
                stringTimeCreation: strings.get(156), /// Time creation
                stringBookingId: strings.get(157), /// "Booking ID",
                icon: Icon(Icons.payment, color: theme.mainColor, size: 15,),
              )))
      );
      list.add(SizedBox(height: 10,));
      _empty = false;
    }

    if (_empty) {
      list.add(Center(child:
      Container(
        width: 400,
        height: 400,
        child: Image.asset("assets/nofound.png", fit: BoxFit.contain)
      ),
      ));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(143), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 20,));
    // list.add(getBottomWidget(_mainModel));

    return ListView(
      children: list,
    );
  }

}
