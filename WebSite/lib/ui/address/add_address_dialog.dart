import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:ondemand_admin/widgets/edit37.dart';
import 'package:provider/provider.dart';
import 'package:abg_utils/abg_utils.dart';
import '../strings.dart';
import '../../theme.dart';

class AddAddressScreen extends StatefulWidget {
  final Function() close;

  const AddAddressScreen({Key? key, required this.close}) : super(key: key);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  int _type = 1;
  late MainModel _mainModel;
  final _editControllerAddress = TextEditingController();
  final _editControllerName = TextEditingController();
  final _editControllerPhone = TextEditingController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _editControllerAddress.text = _mainModel.account.address;
    _editControllerName.text = userAccountData.userName;
    _editControllerPhone.text = userAccountData.userPhone;
    super.initState();
  }

  @override
  void dispose() {
    _editControllerAddress.dispose();
    _editControllerName.dispose();
    _editControllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Center(child: Container(
          color: Colors.white,
            padding: EdgeInsets.all(50),
          // margin: EdgeInsets.all(windowWidth*0.1),
        width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Center(child: Text(strings.get(78), /// "Add the location",
                    textAlign: TextAlign.center, style: theme.style14W800)),
                SizedBox(height: 30,),
                Text(strings.get(79), /// "Label as",
                    textAlign: TextAlign.start, style: theme.style14W400),
                SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(child: button2x(strings.get(80), /// "Home",
                            (){
                          _type = 1;
                          _mainModel.redraw();
                        },
                      style: _type == 1 ? theme.style12W800W : theme.style12W800,
                      color: _type == 1 ? theme.mainColor : Colors.grey.withAlpha(80),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: button2x(strings.get(82), /// "Office",
                            (){
                          _type = 2;
                          _mainModel.redraw();
                        }, style: _type == 2 ? theme.style12W800W : theme.style12W800,
                        color: _type == 2 ? theme.mainColor : Colors.grey.withAlpha(80),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: button2x(strings.get(83), /// "Other",
                            (){
                          _type = 3;
                          _mainModel.redraw();
                        }, style: _type == 3 ? theme.style12W800W : theme.style12W800,
                      color: _type == 3 ? theme.mainColor : Colors.grey.withAlpha(80),
                    )),
                  ],
                ),
                SizedBox(height: 10,),
                SizedBox(height: 5,),
                Container(width: 400,
                  child: Edit37(
                  hint: strings.get(81), /// "Delivery Address",
                  icon: Icons.map,
                  controller: _editControllerAddress,
                )),
                SizedBox(width: 5,),
                Text("${strings.get(74)} $userCurrentLatitude - " /// "Latitude",
                    "${strings.get(75)} $userCurrentLongitude", style: theme.style10W400,), /// "Longitude",
                SizedBox(height: 15,),
                Container(width: 400,
                  child: Edit37(
                  hint: strings.get(84), /// "Contact name",
                  icon: Icons.account_circle_outlined,
                  controller: _editControllerName,
                )),
                SizedBox(height: 15,),
                Container(width: 400,
                  child: Edit37(
                  hint: strings.get(85), /// "Contact phone number",
                  icon: Icons.phone,
                  controller: _editControllerPhone,
                )),
                SizedBox(height: 25,),
                Row(
                  children: [
                    Expanded(child: button2x(strings.get(86), /// "Save location",
                            () async {
                          var ret = await saveLocation(_type, _editControllerAddress.text, _editControllerName.text,
                              _editControllerPhone.text,
                            strings.get(77), /// "Please enter address",
                            strings.get(87), /// "Please Enter name",
                            strings.get(88) /// "Please enter phone",
                          );
                          if (ret != null)
                            return messageError(context, ret);
                          widget.close();
                          goBack();
                          if (currentScreen() == "address_add")
                            goBack();
                        }))
                  ],
                ),
              ],
        )
    ));
  }


}
