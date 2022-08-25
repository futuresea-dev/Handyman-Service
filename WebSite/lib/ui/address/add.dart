
import 'package:abg_utils/abg_utils.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';

class AddressAddScreen extends StatefulWidget {
  @override
  _AddressAddScreenState createState() => _AddressAddScreenState();
}

class _AddressAddScreenState extends State<AddressAddScreen> {

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

    list.add(SizedBox(height: 100,));
    list.add(Container(
        width: 200,
        height: 200,
        child: Image.asset("assets/address2.png", fit: BoxFit.contain)
    ));
    list.add(SizedBox(height: 50,));
    list.add(Center(child: Text(strings.get(70), /// "Find services near your",
        style: theme.style20W800)));
    list.add(SizedBox(height: 10,));
    list.add(Center(child: Text(strings.get(71), /// "By allowing location access, you can search for services and providers near your.",
      style: theme.style12W600Grey, textAlign: TextAlign.center,)));
    list.add(SizedBox(height: 50,));
    list.add(Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(10),
      child: button2x(strings.get(72), /// "Use currents location",
          () async {
            _mainModel.account.addAddressByCurrentPosition();
          }),
    ));
    list.add(Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: button2x(strings.get(73), /// "Set from map"
          (){
            _mainModel.route("address_add_map");
          },
      ),
    ));
    list.add(SizedBox(height: 200,));

    return list;
  }

}
