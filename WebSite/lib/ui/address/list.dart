import 'package:ondemand_admin/widgets/button197a.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';

class AddressListScreen extends StatefulWidget {
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _controllerCode = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Column(children: _getList());
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    list.add(SizedBox(height: 30,));
    list.add(button2x(strings.get(69), /// "Add address",
        (){
          _mainModel.route("address_add");
        }));

    var _count = 0;
    list.add(SizedBox(height: 10,));
    var _address = getCurrentAddress();
    if (_address.id.isNotEmpty){
      list.add(Text(strings.get(66) + ":", style: theme.style12W600Grey,)); /// "Current address",
      list.add(SizedBox(height: 10,));
      list.add(UnconstrainedBox(child: _item(_address, false)));
      list.add(SizedBox(height: 10,));
      _count++;
    }

    bool _first = true;
    List<Widget> list3 = [];
    for (var item in userAccountData.userAddress) {
      if (item == _address)
        continue;
      if (_first){
        list.add(SizedBox(height: 10,));
        list.add(Text(strings.get(67) + ":", style: theme.style12W600Grey,)); /// "Other addresses",
        list.add(SizedBox(height: 10,));
        _first = false;
      }
      list3.add(_item(item, true));
      _count++;
    }
    if (list3.isNotEmpty)
      list.add(Wrap(
        runSpacing: 10,
        spacing: 10,
        children: list3,
      ));

    if (_count == 0){
      list.add(SizedBox(height: 30,));
      list.add(Container(
          width: 200,
          height: 200,
          child: Image.asset("assets/nofound.png", fit: BoxFit.contain)
      ));
      list.add(SizedBox(height: 50,));
      list.add(Center(child: Text(strings.get(68), /// "Address not found",
          style: theme.style14W800)));
    }

    list.add(SizedBox(height: 200,));

    return list;
  }

  _item(AddressData item, bool upIcon){
    double _width = isMobile() ? windowWidth*0.8 : windowWidth*0.4-20;

    return Stack(
        children: [
          Positioned.fill(child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            width: _width,
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, color: Colors.red, size: 30,),
          )),
          Container(
              width: _width,
              child: Dismissible(key: Key(item.id),
              onDismissed: (DismissDirection _direction){
                _delete(item);
              },
              confirmDismiss: (DismissDirection _direction) async {
                if (_direction == DismissDirection.startToEnd)
                  return false;
                return true;
              },
              child: Button197a(
                  item: item,
                  upIcon: upIcon,
                  pressButtonDelete: (){
                    _delete(item);
                  },
                  pressButton: (){
                    _mainModel.addressData = item;
                    _mainModel.route("address_details");
                  },
                  pressSetCurrent: (){
                    setCurrentAddress(item.id);
                    _redraw();
                  }
              )
              ))
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
