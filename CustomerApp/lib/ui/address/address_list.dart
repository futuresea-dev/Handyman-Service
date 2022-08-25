import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/widgets/buttons/button197n.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class AddressListScreen extends StatefulWidget {
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    super.initState();
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
          children: [

            Container(
              child: ListView(
                padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                children: _children(),
              ),
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                strings.get(188), context, () {goBack();}), /// My Address

            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(10),
              child: button2(strings.get(117), /// "Add address",
                  theme.mainColor, (){
                    route("address_add");
                }, ),
            )

          ]),
        ));
  }

  _children() {
    List<Widget> list = [];

    list.add(SizedBox(height: MediaQuery.of(context).padding.top+50,));

    var _count = 0;
    list.add(SizedBox(height: 10,));
    var _address = getCurrentAddress();
    if (_address.id.isNotEmpty){
      list.add(Text(strings.get(214) + ":", style: theme.style12W600Grey,)); /// "Current address",
      list.add(SizedBox(height: 10,));
      list.add(_item(_address, false));
      list.add(SizedBox(height: 10,));
    }

    bool _first = true;
    for (var item in userAccountData.userAddress) {
      if (item == _address)
        continue;
      if (_first){
        list.add(SizedBox(height: 10,));
        list.add(Text(strings.get(215) + ":", style: theme.style12W600Grey,)); /// "Other addresses",
        list.add(SizedBox(height: 10,));
        _first = false;
      }
      list.add(_item(item, true));
      list.add(SizedBox(height: 10,));
      _count++;
    }

    if (_count == 0){
        list.add(SizedBox(height: 100,));
        list.add(Container(
            width: windowWidth*0.5,
            height: windowWidth*0.5,
            child: Image.asset("assets/nofound.png", fit: BoxFit.contain)
        ));
        list.add(SizedBox(height: 50,));
        list.add(Center(child: Text(strings.get(189), /// "Address not found",
            style: theme.style14W800)));
    }

    list.add(SizedBox(height: 200,));
    return list;
  }

  _item(AddressData item, bool upIcon){
    return Stack(
        children: [
          Positioned.fill(child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, color: Colors.red, size: 30,),
          )),
          Dismissible(key: Key(item.id),
              onDismissed: (DismissDirection _direction){
                _delete(item);
              },
              confirmDismiss: (DismissDirection _direction) async {
                if (_direction == DismissDirection.startToEnd)
                  return false;
                return true;
              },
              child:
              Button197N(
                  item: item,
                  upIcon: upIcon,
                pressButtonDelete: (){
                  _delete(item);
                },
                pressButton: (){
                  _mainModel.addressData = item;
                  route("address_details");
                },
                pressSetCurrent: (){
                  setCurrentAddress(item.id);
                  _redraw();
                }
              )
          )
        ]);
  }

  _delete(AddressData item) async {
    var ret = await deleteLocation(item);
    if (ret != null)
      messageError(context, ret);
    _redraw();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

}

