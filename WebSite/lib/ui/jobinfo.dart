import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/button1.dart';
import 'package:ondemand_admin/widgets/card44.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import 'strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class JobInfoScreen extends StatefulWidget {
  @override
  _JobInfoScreenState createState() => _JobInfoScreenState();
}

class _JobInfoScreenState extends State<JobInfoScreen> {

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
      _redraw();
    });
    super.initState();
  }

  @override
  void dispose() {
    setJobInfoListen(null);
    super.dispose();
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
    return Container(
        margin: EdgeInsets.only(top : 30),
          alignment: Alignment.center,
          child: Container(
          margin: isMobile() ? EdgeInsets.only(left : 10, right: 10)
              : EdgeInsets.only(left : 30, right: 30),
          width: isMobile() ? windowWidth : windowWidth*0.4+60,
          child: Column(
              // padding: EdgeInsets.only(top : 0),
              children: _getList(),
            ),
          ));
  }

  _getList() {
    List<Widget> list = [];

    list.add(BackSiteButton(text: strings.get(155))); /// Back to bookings list
    list.add(SizedBox(height: 40,));

    // var _date = strings.get(95); /// "Any Time",
    // if (!currentOrder.anyTime)
    //   _date = appSettings.getDateTimeString(currentOrder.selectTime);

    //
    // Get last status
    //
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

    //
    // if status of this item is last
    //
    var _needReview = false;
    if (currentOrder.status == _last.id)
      _needReview = true;

    //
    // Upper card
    //
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Card43(image: currentOrder.providerAvatar,
            text1: getTextByLocale(currentOrder.provider, strings.locale),
            text2: getTextByLocale(currentOrder.service, strings.locale),
            text3: getPriceString(currentOrder.total),
            date: appSettings.getStatusName(currentOrder.status, strings.locale),
            dateCreating: appSettings.getDateTimeString(currentOrder.time),
            bookingId: currentOrder.id,
            // text4: appSettings.getStatusName(currentOrder.status, strings.locale),
            stringTimeCreation: strings.get(156), /// Time creation
            stringBookingId: strings.get(157), /// "Booking ID",
            icon: Icon(Icons.payment, color: theme.mainColor, size: 15,),
        )));

    list.add(SizedBox(height: 10,));
    list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.blue, size: 20,),
                  SizedBox(width: 10,),
                  Text(strings.get(3), style: theme.style14W800),  /// "Phone",
                  SizedBox(width: 10,),
                  Text(currentOrder.providerPhone, style: theme.style14W400),
                ],
              ),

              SizedBox(height: 10,),
              Row(children: [
                Text(strings.get(154), style: theme.style14W800),  /// "Id",
                SizedBox(width: 10,),
                Text(currentOrder.id, style: theme.style14W400,),
              ],)


            ],
          ))
    );
    list.add(SizedBox(height: 10,));

    //
    //
    //
    bool _current = false;
    for (var item in appSettings.statuses){
      // date
      var _date = "";
      var passed = isPassed(item);
      if (!_current && passed){
        DateTime _time = currentOrder.getHistoryDate(item.id).time;
        String _text = appSettings.getDateTimeString(_time);
        _date = "${strings.get(147)}:\n$_text";  /// Requested on
      }
      //
      if (item.cancel && !passed && !currentOrder.finished)
        list.add(Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          child: button1a(getTextByLocale(item.name, strings.locale), /// cancel button
          theme.style16W800White,
          theme.mainColor, (){
            _continue(item);
          }, true))
        );

      if (item.cancel && passed) {
        var t = strings.get(148); /// "by administrator",
        var _itemCancel = cancelItem(item);
        if (_itemCancel != null) {
        if (_itemCancel.byProvider)
        t = strings.get(149); /// by provider
        if (_itemCancel.byCustomer)
        t = strings.get(150); /// by customer
        _date = "$_date\n$t";
        }
      }

     //if (passed)
     //    list.add(Card44(image: item.serverPath,
     //      text1: getTextByLocale(item.name),
     //      text2: _date,
     //      bkgColor: (!_current) ? (darkMode) ? Color(0xff404040) : Colors.white : Colors.transparent,
     //      iconColor: (!_current) ? Colors.green : Colors.grey,),
     //    );
         list.add(Card44(image: item.serverPath,
           name: getTextByLocale(item.name, strings.locale),
           date: _date,
           bkgColor: (passed) ? (theme.darkMode) ? Color(0xff404040) : Colors.white : Colors.transparent,
           iconColor: (!_current) ? Colors.green : Colors.grey,),
         );

      if (item.id == currentOrder.status)
        _current = true;
    }

    list.add(SizedBox(height: 20,));

    // _mainModel.price = PriceData(currentOrder.priceName, currentOrder.price,
    //     currentOrder.discPrice, currentOrder.priceUnit, ImageData());
    // _mainModel.count = currentOrder.count;
    // _mainModel.coupon = OfferData(currentOrder.couponId,
    //     currentOrder.couponName, discount: currentOrder.discount, discountType: currentOrder.discountType,
    //     services: [], providers: [], category: [], expired: DateTime.now(), desc: []);
    // _mainModel.currentService.tax = currentOrder.tax;
    // _mainModel.currentService.addon = currentOrder.addon;
    // list.add(pricingTable(context, _mainModel));

    if (currentOrder.ver4){
      cartCurrentProvider = ProviderData.createEmpty()..id = currentOrder.providerId;
      tablePricesV4(list, currentOrder.products,
          strings.get(23), /// "Addons"
          strings.get(181), /// "Subtotal"
          strings.get(182), /// "Discount"
          strings.get(208), /// "VAT/TAX"
          strings.get(196)  /// "Total amount"
      );
    }else{
      setDataToCalculate(currentOrder, null);
      list.add(pricingTable(
              (String code){
            if (code == "addons") return strings.get(23);  /// "Addons",
            if (code == "direction") return strings.direction;
            if (code == "locale") return strings.locale;
            if (code == "pricing") return strings.get(109);  /// "Pricing",
            if (code == "quantity") return strings.get(108);  /// "Quantity",
            if (code == "taxAmount") return strings.get(112);  /// "Tax amount",
            if (code == "total") return strings.get(113);  /// "Total",
            if (code == "subtotal") return strings.get(181);  /// "Subtotal",
            if (code == "discount") return strings.get(182);  /// "Discount"
            return "";
          }
      ));
    }
    if (_currentStatus.byCustomerApp && !_currentStatus.cancel)
      list.add(Container(
        alignment: Alignment.bottomCenter,
        child: button1a(_currentStatus.cancel ? "" : getTextByLocale(_currentStatus.name, strings.locale), /// button
        theme.style16W800White,
        theme.mainColor, (){_continue(_currentStatus);}, _currentStatus.byCustomerApp && !_currentStatus.cancel),
      ));

    if (_needReview && !currentOrder.rated)
      list.add(Container(
        alignment: Alignment.bottomCenter,
        child: button1a(strings.get(153), /// "Rate this provider",
        theme.style16W800White,
        theme.mainColor, (){
          _mainModel.route("rate");
            }, true),
      ));

    list.add(SizedBox(height: 20,));

    return list;
  }

  _continue(StatusData currentItem) async {
    _mainModel.waits(true);
    var ret = await setNextStep(currentItem, true, false, false,
        strings.get(151), /// "Now status:",
        strings.get(152) /// "Booking status was changed",
    );
    _mainModel.waits(false);
    if (ret != null)
      return messageError(context, ret);
  }

}
