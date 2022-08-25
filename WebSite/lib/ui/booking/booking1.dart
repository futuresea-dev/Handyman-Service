import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:ondemand_admin/widgets/edit37.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';

class BookNowScreen extends StatefulWidget {
  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _editControllerHint = TextEditingController();
  late MainModel _mainModel;
  double _show = 0;
  final ScrollController _scrollController2 = ScrollController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    couponCode = "";
    super.initState();
  }

  @override
  void dispose() {
    _scrollController2.dispose();
    _editControllerHint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Column(children: _getList());
  }

  Widget _getDialogBody(){
    var widget = CupertinoDatePicker(
        onDateTimeChanged: (DateTime picked) {
          cartSelectTime = picked;
          print(picked.toString());
          _redraw();
        },
        mode: CupertinoDatePickerMode.dateAndTime,
        use24hFormat: appSettings.timeFormat == "24h",
        initialDateTime: DateTime.now().add(Duration(minutes: 1)),
        minimumDate: DateTime.now()
    );

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: windowHeight*0.4,
            child: widget,
          ),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: button2(strings.get(99), theme.mainColor, (){ /// "CLOSE"
                _show = 0;
                _redraw();
              })),
        ]);
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    list.add(Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(strings.get(90), /// "Your address",
                  style: theme.style13W800, textAlign: TextAlign.start,)),
                SizedBox(width: 10,),
                button2x(strings.get(91), (){  /// "Add new",
                  _mainModel.route("address_add");
                }),
              ],
            ),
            Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.orange),
                SizedBox(width: 10,),
                Expanded(child: _addresses())
              ],
            ),
            //SizedBox(height: 10,),
          ],
        )
    ));

    bool _noContinue = false;
    if (!ifUserAddressInProviderRoute(_mainModel.currentService.providers.isNotEmpty ? _mainModel.currentService.providers[0] : "")){
      var _pr = getProviderById(_mainModel.currentService.providers[0]);
      if (_pr != null){
        if (_pr.acceptOnlyInWorkArea)
          _noContinue = true;
      }
      list.add(Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(child: Text(strings.get(92), style: theme.style13W800Red,)), /// "Your address is outside provider work area"
              SizedBox(width: 10,),
              button2x(strings.get(93), (){  /// "See details",
                _mainModel.route("booking_map_details");
              })
            ],
          )
      ));
    }

    list.add(SizedBox(height: 20,));

    list.add(Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Edit37(
        hint: strings.get(94), /// "Special Requests",
        icon: Icons.email,
        controller: _editControllerHint,
      ),
    ));

    list.add(SizedBox(height: 20,));

    Widget _time = Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(5),
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                // color: (darkMode) ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(theme.radius),
              ),
              child: checkBox43(strings.get(95), /// "Any Time",
                  theme.booking1CheckBoxColor, "",
                  theme.style14W800, cartAnyTime, (val) {
                    if (val) {
                      cartAnyTime = val;
                      _redraw();
                    }
                  }),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                // color: (darkMode) ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: checkBox43(strings.get(96), /// "Schedule an Order",
                  theme.booking1CheckBoxColor, "",
                  theme.style14W800, !cartAnyTime, (val) {
                    if (val) {
                      cartAnyTime = false;
                      _redraw();
                    }
                  }),
            ),
          ],
        ));

    Widget _selectTime = !cartAnyTime ?
    Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(child: button2(strings.get(97), /// "Select a Date & Time",
                        theme.mainColor, (){
                          _show = 1;
                          _redraw();
                        }
                      //    _dateTime
                    )),
                  ],
                )),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                // color: (darkMode) ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(strings.get(98), style: theme.style14W800,), /// "Requested Service on",
                  SizedBox(height: 10,),
                  Text(appSettings.getDateTimeString(cartSelectTime),
                    style: theme.style18W800,),
                ],
              ),
            ),
            SizedBox(height: 10,),
            if (_show == 1)
              _getDialogBody(),

          ],
        )) : Container();

    if (isMobile()){
      list.add(_time);
      list.add(SizedBox(height: 10,));
      list.add(_selectTime);
    }else
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _time),
          SizedBox(width: 20,),
          Expanded(child: _selectTime)
      ],));

    list.add(SizedBox(height: 30,));
    if (!_noContinue)
      list.add(button2x(strings.get(62), (){  /// "CONTINUE"
        if (getCurrentAddress().id.isEmpty)
          return messageError(context, strings.get(100));  /// "Please select address",
        cartHint = _editControllerHint.text;
        _mainModel.route("book1");
      }));

    list.add(SizedBox(height: 150,));

    return list;
  }


  Widget _addresses(){
    List<Widget> list = [];
    // first - current address
    for (var item in userAccountData.userAddress)
      if (item == getCurrentAddress())
        _oneItem(list, item);

    for (var item in userAccountData.userAddress)
      if (item != getCurrentAddress())
        _oneItem(list, item);

    list.add(SizedBox(width: 10,));
    return Container(
      height: 40,
      child: ListView(
        controller: _scrollController2,
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _oneItem(List<Widget> list, AddressData item){
    list.add(
        InkWell(onTap: (){
          setCurrentAddress(item.id);
          _scrollController2.jumpTo(0);
          _redraw();
        },
            child: Container(
              decoration: BoxDecoration(
                color: getCurrentAddress() == item ? Colors.blue.withAlpha(50) : Colors.transparent,
                border: Border.all(color: getCurrentAddress() != item ? Colors.blue.withAlpha(50) : Colors.transparent),
                borderRadius: BorderRadius.circular(theme.radius),
              ),
              padding: EdgeInsets.all(10),
              child: Text(item.address, style: theme.style14W400,),
            )));
    list.add(SizedBox(width: 10,));
  }
}
