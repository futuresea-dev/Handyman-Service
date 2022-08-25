import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/ui/rating.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/cards/card44.dart';

class JobInfoScreen extends StatefulWidget {
  @override
  _JobInfoScreenState createState() => _JobInfoScreenState();
}

class _JobInfoScreenState extends State<JobInfoScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;

  @override
  void initState() {
    setJobInfoListen((){
      for (var item in bookings)
        if (item.id == currentOrder.id)
          currentOrder = item;
      _redraw();
    });
    super.initState();
  }

  @override
  void dispose() {
    setJobInfoListen(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    StatusData _currentStatus = StatusData.createEmpty();
    StatusData _last = StatusData.createEmpty();
    var _found = false;
    for (var item in appSettings.statuses) {
      if (_found) {
        _currentStatus = item;
        _found = false;
      }
      if (item.id == currentOrder.status) {
        _found = true;
      }
      if (!item.cancel)
        _last = item;
    }

    var _needReview = false;
    if (currentOrder.status == _last.id)
      _needReview = true;

    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            Container(
              padding: EdgeInsets.only(top: 0, left: 0, right: 0),
              child: ListView(
                children: _getList(),
              ),
            ),

            if (_currentStatus.byCustomerApp && !_currentStatus.cancel)
            Container(
              alignment: Alignment.bottomCenter,
              child: button2(_currentStatus.cancel ? "" : getTextByLocale(_currentStatus.name, strings.locale), /// button
                  theme.mainColor, (){
                      _continue(_currentStatus);
              }, enable: _currentStatus.byCustomerApp && !_currentStatus.cancel, radius: 0),
            ),

            if (_needReview && !currentOrder.rated)
              Container(
                alignment: Alignment.bottomCenter,
                child: button2(strings.get(161), /// "Rate this provider",
                    theme.mainColor, (){_rate();}, radius: 0),
              ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "${strings.get(66)} ${currentOrder.id}", context, () { // Booking ID
                  goBack();
            }),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

          ],
        )

        ));
  }

  _getList(){
    List<Widget> list = [];

    var _date = strings.get(109); /// "Any Time",
    if (!currentOrder.anyTime)
      _date = appSettings.getDateTimeString(currentOrder.selectTime);

    list.add(ClipPath(
        clipper: ClipPathClass23(20),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20, bottom: 20),
          width: windowWidth,
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Card43(image: currentOrder.providerAvatar,
                    text1: getTextByLocale(currentOrder.provider, strings.locale),
                    text2: "", //getTextByLocale(currentOrder.service, strings.locale),
                    text3: getPriceString(currentOrder.total),
                    bookingAt: _date,
                    date: appSettings.getStatusName(currentOrder.status, strings.locale),
                    dateCreating: appSettings.getDateTimeString(currentOrder.time),
                    bookingId: currentOrder.id,
                    icon: Icon(Icons.payment, color: theme.mainColor, size: 15,),
                    bkgColor: Colors.transparent,
                    stringBookingId: strings.get(232), /// "Booking ID",
                    stringTimeCreation: strings.get(231), /// Time creation
                    stringBookingAt: strings.get(284), /// Booking At
                )),
              SizedBox(height: 10,),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blue, size: 20,),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){callMobile(currentOrder.providerPhone);},
                        child: Text(strings.get(64),                  /// "Call now",
                            style: theme.style14W800MainColor),
                      ),
                      SizedBox(width: 30,),
                      Icon(Icons.message, color: Colors.green, size: 20,),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          setChatData(getTextByLocale(currentOrder.provider, strings.locale), 0,
                              currentOrder.providerAvatar, currentOrder.providerId);
                          route("chat2");
                        },
                        child: Text(strings.get(65), /// "Message",
                            style: theme.style14W800MainColor),
                      )
                    ],
                  )),
              SizedBox(height: 10,),
            ],
          ),
        )),);
    //
    //
    //
    bool _current = false;
    for (var item in appSettings.statuses){
      // date
      var _date = "";
      if (!_current){
        DateTime _time = currentOrder.getHistoryDate(item.id).time;
        String _text = appSettings.getDateTimeString(_time);
        _date = "${strings.get(78)}:\n$_text";  /// Requested on
      }
      //
      var passed = isPassed(item);
      if (item.cancel && !passed && !currentOrder.finished)
        list.add(Container(
            margin: EdgeInsets.only(top: 15, bottom: 15),
            child: button2(getTextByLocale(item.name, strings.locale), /// cancel button
                theme.mainColor, (){
                  _continue(item);
                }, radius: 0)));

      if (item.cancel && passed) {
        var t = strings.get(210); // "by administrator",
        var _itemCancel = cancelItem(item);
        if (_itemCancel != null) {
          if (_itemCancel.byProvider)
            t = strings.get(211); // by provider
          if (_itemCancel.byCustomer)
            t = strings.get(212); // by customer
          _date = "$_date\n$t";
        }
      }

      list.add(Card44(image: item.serverPath,
        text1: getTextByLocale(item.name, strings.locale),
        style1: theme.style16W800,
        text2: passed ? _date : "",
        style2: TextStyle(fontSize: 16, color: Colors.grey),
        bkgColor: passed
            ? (theme.darkMode) ? Color(0xff404040) : Colors.white
            : Colors.transparent,
        iconColor: !_current ? Colors.green : Colors.grey,),
      );
      if (item.id == currentOrder.status)
        _current = true;
    }

    list.add(SizedBox(height: 20,));

    if (currentOrder.ver4){
      cartCurrentProvider = ProviderData.createEmpty()..id = currentOrder.providerId;
      tablePricesV4(list, currentOrder.products,
        strings.get(221), /// "Addons"
        strings.get(235), /// "Subtotal"
        strings.get(236), /// "Discount"
        strings.get(276), /// "VAT/TAX"
        strings.get(263)  /// "Total amount"
    );
    }else{
      setDataToCalculate(currentOrder, null);
      list.add(pricingTable(
              (String code){
            if (code == "addons") return strings.get(221);  /// "Addons",
            if (code == "direction") return strings.direction;
            if (code == "locale") return localSettings.locale;
            if (code == "pricing") return strings.get(74);  /// "Pricing",
            if (code == "quantity") return strings.get(75);  /// "Quantity",
            if (code == "taxAmount") return strings.get(76);  /// "Tax amount",
            if (code == "total") return strings.get(77);  /// "Total",
            if (code == "subtotal") return strings.get(235);  /// "Subtotal",
            if (code == "discount") return strings.get(236);  /// "Discount"
            return "";
          }
      ));
    }

    list.add(SizedBox(height: 150,));

    return list;
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

  _continue(StatusData currentItem) async {
    _waits(true);
    var ret = await setNextStep(currentItem, true, false, false,
        strings.get(158), /// "Now status:",
        strings.get(159) /// "Booking status was changed",
    );
    _waits(false);
    if (ret != null)
      return messageError(context, ret);
  }

  _rate(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingScreen(), //ReviewsScreen(),
      ),
    );
  }

}



