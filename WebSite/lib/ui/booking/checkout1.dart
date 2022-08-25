import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../dialogs/dialogs.dart';
import '../strings.dart';

class CheckOut1Screen extends StatefulWidget {
  @override
  _CheckOut1ScreenState createState() => _CheckOut1ScreenState();
}

class _CheckOut1ScreenState extends State<CheckOut1Screen> {

  final _editControllerCoupon = TextEditingController();
  final _editControllerHint = TextEditingController();
  final ScrollController _scrollController2 = ScrollController();
  double _show = 0;
  late MainModel _mainModel;

  @override
  void initState() {
    needCouponDebugText = true;
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _editControllerHint.text = localSettings.hint;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController2.dispose();
    _editControllerHint.dispose();
    _editControllerCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 0),
      children: _body(),
    );
  }

  _body(){
    List<Widget> list = [];

    Widget _addressWidget = Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
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
                button2b(strings.get(91), (){  /// "Add new",
                  route("address_add");
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
    );

    Widget _addressBed = Container();

    bool _noContinue = false;
    if (cartCurrentProvider != null)
      if (!ifUserAddressInProviderRoute(cartCurrentProvider!.id))
        if (cartCurrentProvider!.acceptOnlyInWorkArea)
          _noContinue = true;
        _addressBed = Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(child: Text(strings.get(92), style: theme.style12W600Red,)), /// "Your address is outside provider work area"
              SizedBox(width: 10,),
              button2b(strings.get(93), (){  /// "See details",
                _mainModel.currentProvider = cartCurrentProvider!;
                route("booking_map_details");
              })
            ],
          )
        );


      Widget _coupon = Container();
    if (couponCode.isNotEmpty)
      _coupon = Container(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          child: Row(children: [
            Expanded(child: Text("${strings.get(214)}: $couponCode", style: theme.style14W800,), /// "Promo code",
            ),
            InkWell(
                onTap: (){
                  clearCoupon();
                  _redraw();
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(strings.get(215), style: theme.style12W800,), /// "Remove",
                ))
          ],));
    else
    if (isCouponsPresent(_mainModel.cartUser, _mainModel.currentService))
      _coupon = InkWell(
          onTap: (){
            showDialogCouponsList();
          },
          child: Container(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Text(strings.get(216), style: theme.style14W800,), /// "Add promo",
          ));
    else
      _coupon = Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Text("${strings.get(216)} | ${strings.get(217)}", style: theme.style14W400Grey,), /// "Promo not found",
      );

    // Widget _couponWidget = Container(
    //     color: (theme.darkMode) ? Colors.black : Colors.white,
    //     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    //     child: Column(
    //       children: [
    //         edit42(strings.get(101), /// "Coupon Code",
    //             _editControllerCoupon,
    //             "COUPON1",
    //             onchange: (String val){
    //               couponCode = val;
    //               cartCouponCode = val;
    //               _redraw();
    //             }
    //         ),
    //         if (cartCouponCode.isNotEmpty)
    //           SizedBox(height: 10,),
    //         if (cartCouponCode.isNotEmpty)
    //           Center(child: Text(_couponInfo,
    //             style: theme.style16W800, textAlign: TextAlign.center,))
    //       ],
    //     ));

    Widget _specialRequestWidget = Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: edit42(strings.get(94), /// "Special Requests",
          _editControllerHint,
          strings.get(207), /// "Is there anything else",
          ),
    );

    list.add(SizedBox(height: 20,));

    if (isMobile()){
      list.add(_addressWidget);
      list.add(_addressBed);
      list.add(SizedBox(height: 10,));
      list.add(_coupon);
      list.add(SizedBox(height: 10,));
      list.add(_specialRequestWidget);
    }else{
      list.add(Row(
        children: [
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _addressWidget,
              _addressBed
            ],
          ),),
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _coupon,
              SizedBox(height: 10,),
              _specialRequestWidget
            ],
          ),),
        ],
      ));
    }

    // list.add(Container(
    //   margin: EdgeInsets.only(left: 10, right: 10),
    //   padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    //   decoration: BoxDecoration(
    //     color: (theme.darkMode) ? Colors.black : Colors.white,
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   child: checkBox43(strings.get(109), /// "Any Time",
    //       theme.booking1CheckBoxColor, "",
    //       theme.style14W800, cartAnyTime, (val) {
    //         if (val) {
    //           cartAnyTime = val;
    //           _redraw();
    //         }
    //       }),
    // ));
    //
    // list.add(SizedBox(height: 10,));
    //
    // list.add(Container(
    //   margin: EdgeInsets.only(left: 10, right: 10),
    //   padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    //   decoration: BoxDecoration(
    //     color: (theme.darkMode) ? Colors.black : Colors.white,
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   child: checkBox43(strings.get(110), /// "Schedule an Order",
    //       theme.booking1CheckBoxColor, "",
    //       theme.style14W800, !cartAnyTime, (val) {
    //           if (val) {
    //             cartAnyTime = !val;
    //             _redraw();
    //           }
    //       }),
    // ));

    // list.add(SizedBox(height: 20,));

    // if (!cartAnyTime)
    //   list.add(Container(
    //       margin: EdgeInsets.only(left: 10, right: 10),
    //       child: Row(
    //     children: [
    //       Expanded(child: button2(strings.get(112), theme.mainColor,
    //           (){
    //             _show = 1;
    //             _redraw();
    //           }
    //       )), /// "Select a Date & Time",
    //     ],
    //   )));
    //
    // list.add(SizedBox(height: 10,));

    // if (!cartAnyTime)
    //   list.add(Container(
    //     margin: EdgeInsets.only(left: 10, right: 10),
    //     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    //     decoration: BoxDecoration(
    //       color: (theme.darkMode) ? Colors.black : Colors.white,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Column(
    //       children: [
    //         Text(strings.get(111), style: theme.style14W800,), /// "Requested Service on",
    //         SizedBox(height: 10,),
    //         Text(appSettings.getDateTimeString(cartSelectTime),
    //           style: theme.style18W800,),
    //       ],
    //     ),
    //   ));

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
                      cartAnyTime = !val;
                      _redraw();
                    }
                  }),
            ),
          ],
        ));

    Widget _selectTime = (!cartAnyTime) ?
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
      list.add(button2x(strings.get(62), _book)); /// "CONTINUE"


    list.add(SizedBox(height: 150,));
    return list;
  }

  Widget _getDialogBody(){
    var widget = CupertinoDatePicker(
        onDateTimeChanged: (DateTime picked) {
          cartSelectTime = picked;
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
        child: button2(strings.get(99), theme.mainColor, (){ /// "CLOSE",
          _show = 0;
          _redraw();
        }, )),
    ]);
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
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

  _book(){
    if (getCurrentAddress().id.isEmpty)
      return messageError(context, strings.get(100));  /// "Please select address",

    cartHint = _editControllerHint.text;

    route("checkout2");
  }

}
