import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/model/model.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/widgets/buttons/button1.dart';
import 'package:ondprovider/widgets/cards/card44.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class JobInfoScreen extends StatefulWidget {
  @override
  _JobInfoScreenState createState() => _JobInfoScreenState();
}

class _JobInfoScreenState extends State<JobInfoScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    setJobInfoListen((){
      for (var item in bookings)
        if (item.id == currentOrder.id)
          currentOrder = item;
      dprint("setJobInfoListen currentOrder=${currentOrder.status}");
      _redraw();
    });
    _init();
    super.initState();
  }

  _init() async {
    _mainModel.customerAddress = [];
    List<AddressData> _userAddress = await getUserAddress(currentOrder.customerId);
    for (var item in _userAddress)
      if (item.address == currentOrder.address)
        _mainModel.customerAddress.add(item);
    _redraw();
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
    var _found = false;
    for (var item in appSettings.statuses) {
      if (_found) {
        _currentStatus = item;
        break;
      }
      if (item.id == currentOrder.status)
        _found = true;
    }

    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
            textDirection: strings.direction,
            child: Stack(
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                  child: ListView(
                    children: _getList(_currentStatus),
                  ),
                ),

                if (!currentOrder.finished)
                Container(
                  alignment: Alignment.bottomCenter,
                  child: button1a(_currentStatus.cancel ? "" : getTextByLocale(_currentStatus.name, strings.locale), /// button
                      theme.style16W800White,
                      theme.mainColor, (){_continue(_currentStatus);}, _currentStatus.byProviderApp),
                ),

                appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                    "${strings.get(44)} ${currentOrder.id}", context, () { /// Booking ID
                      goBack();
                    }),

                if (_wait)
                  Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

              ],
            )

        ));
  }

  _getList(StatusData _currentStatus){
    List<Widget> list = [];

    var _date = strings.get(30); /// "Any Time",
    if (!currentOrder.anyTime)
      _date = appSettings.getDateTimeString(currentOrder.selectTime);

    list.add(ClipPath(
        clipper: ClipPathClass23(20),
        child: Container(
          padding: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 20),
          width: windowWidth,
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Card43(
                    image: currentOrder.customerAvatar,
                    text1: currentOrder.customer,
                    text2: "",
                    bookingAt: _date,
                    text3: getPriceString(currentOrder.total),
                    date: appSettings.getStatusName(currentOrder.status, strings.locale),
                    dateCreating: appSettings.getDateTimeString(currentOrder.time),
                    bookingId: currentOrder.id,
                    icon: Icon(Icons.payment, color: theme.mainColor, size: 15,),
                    bkgColor: (theme.darkMode) ? Colors.black : Colors.white,
                    stringBookingId: strings.get(44), /// "Booking ID",
                    stringTimeCreation: strings.get(186), /// Time creation
                    stringBookingAt: strings.get(217), /// Booking At
                    // image: currentOrder.customerAvatar,
                    // customerName: currentOrder.customer,
                    // serviceName: getTextByLocale(currentOrder.service, strings.locale),
                    // dateCreating: appSettings.getDateTimeString(currentOrder.time),
                    // bookingId: currentOrder.id,
                    // date: _date,
                    // jobStatus: appSettings.getStatusName(currentOrder.status, strings.locale),
                    // mainModel: _mainModel,
                    // address: currentOrder.address,
                    // paymentMethod: currentOrder.paymentMethod,
                    // icon: Icon(Icons.calendar_today_outlined, color: theme.mainColor, size: 15,),
                  )),
              SizedBox(height: 10,),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      if (_mainModel.customerAddress.isNotEmpty)
                        button2c(strings.get(209), theme.mainColor, (){ /// "On map",
                          route("mapCustomer");
                        }),
                      // Icon(Icons.phone, color: Colors.blue, size: 20,),
                      // SizedBox(width: 10,),
                      // InkWell(
                      //   onTap: (){
                      //     callMobile(currentOrder.c);
                      //   },
                      //   child: Text(strings.get(38),                  /// "Call now",
                      //       style: theme.style16W800Blue),
                      // ),
                      SizedBox(width: 30,),
                      Icon(Icons.message, color: Colors.green, size: 20,),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          setChatData(currentOrder.customer, 0,
                              currentOrder.customerAvatar, currentOrder.customerId);
                          route("chat");
                        },
                        child: Text(strings.get(39), /// "Message",
                            style: theme.style16W800Green),
                      )
                    ],
                  )),
              SizedBox(height: 10,),



            ],
          ),

        )),);

    bool _current = false;
    for (var item in appSettings.statuses){
      // date
      var _date = "";
      if (!_current){
        DateTime _time = currentOrder.getHistoryDate(item.id).time;
        String _text = appSettings.getDateTimeString(_time);
        _date = "${strings.get(46)}:\n$_text";  /// Time
      }
      //
      var passed = isPassed(item);
      if (item.cancel && !passed && !currentOrder.finished)
        list.add(Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
            child: button1a(getTextByLocale(item.name, strings.locale), /// cancel button
           theme.style16W800White,
                theme.mainColor, (){
            _continue(item);
         }, true)));

      if (item.cancel && passed) {
        var t = strings.get(121); // "by administrator",
        var _itemCancel = cancelItem(item);
        if (_itemCancel != null) {
          if (_itemCancel.byProvider)
            t = strings.get(120); // by provider
          if (_itemCancel.byCustomer)
            t = strings.get(119); // by customer
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
          strings.get(159), /// "Addons"
          strings.get(203), /// "Subtotal"
          strings.get(204), /// "Discount"
          strings.get(215), /// "VAT/TAX"
          strings.get(216)  /// "Total amount"
      );
    }else{
      setDataToCalculate(currentOrder, null);
      list.add(pricingTable(
          (String code){
            if (code == "addons") return strings.get(159);  /// "Addons",
            if (code == "direction") return strings.direction;
            if (code == "locale") return localSettings.locale;
            if (code == "pricing") return strings.get(53);  /// "Pricing",
            if (code == "quantity") return strings.get(54);  /// "Quantity",
            if (code == "taxAmount") return strings.get(55);  /// "Tax amount",
            if (code == "total") return strings.get(56);  /// "Total",
            if (code == "subtotal") return strings.get(203);  /// "Subtotal",
            if (code == "discount") return strings.get(236);  /// "Discount"
            return "";
          }
      ));
    }
    list.add(SizedBox(height: 50,));

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
    var ret = await setNextStep(currentItem, false, true, false,
        strings.get(118), /// "Now status:",
        strings.get(117) /// "Booking status was changed",
    );
    _waits(false);
    if (ret != null)
      return messageError(context, ret);
  }
}



