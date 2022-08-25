import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: [

            Container(
              child: ListView(
                padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                children: _children(),
              ),
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                strings.get(193), context, () {  /// Set Location
                    goBack();
            }),

          ]),
        ));
  }

  _children() {
    List<Widget> list = [];

    list.add(SizedBox(height: 100,));
    list.add(Container(
      width: windowWidth*0.5,
      height: windowWidth*0.5,
      child: Image.asset("assets/address2.png", fit: BoxFit.contain)
    ));
    list.add(SizedBox(height: 50,));
    list.add(Center(child: Text(strings.get(194), /// "Find services near your",
      style: theme.style25W400)));
    list.add(SizedBox(height: 10,));
    list.add(Center(child: Text(strings.get(195), /// "By allowing location access, you can search for services and providers near your.",
        style: theme.style12W600Grey, textAlign: TextAlign.center,)));
    list.add(SizedBox(height: 50,));
    list.add(Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(10),
      child: button2(strings.get(196), /// "Use currents location",
          theme.mainColor, () async {
            _mainModel.account.addAddressByCurrentPosition();
        }),
    ));
    list.add(Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: button2outline(strings.get(197), /// "Set from map"
          theme.style14W800MainColor, theme.mainColor, theme.radius, (){
              route("address_add_map");
        }, true,
          theme.darkMode ? Colors.black : Colors.white
      ),
    ));
    list.add(SizedBox(height: 200,));
    return list;
  }



}

