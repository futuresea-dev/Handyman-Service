import 'package:ondemand_admin/widgets/edit37.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class MobilePhoneScreen extends StatefulWidget {
  @override
  _MobilePhoneScreenState createState() => _MobilePhoneScreenState();
}

class _MobilePhoneScreenState extends State<MobilePhoneScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _controllerPhone = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top : 0),
            child: ListView(
              children: _getList(),
            ),)
      ],
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 10,));

    list.add(Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 100,),
            UnconstrainedBox(
                child: Container(
                    width: 70,
                    height: 70,
                  child: appSettings.websiteLogoServer.isEmpty ? Image.asset("assets/applogo.png",
                      fit: BoxFit.contain)
                      : Image.network(appSettings.websiteLogoServer, fit: BoxFit.contain,),
                )),
            SizedBox(height: 30,),
            Container (
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                      child: Column(
                        children: [
                          Text(strings.get(59), style: theme.style20W800), /// "Verification",
                          SizedBox(height: 10,),
                          Text(strings.get(50), style: theme.style14W400), /// "in less than a minute",
                          SizedBox(height: 40,),
                          Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(appSettings.otpPrefix, style: theme.style18W800),
                                  SizedBox(width: 10,),
                                  Expanded(child: Edit37(
                                    hint: strings.get(60), /// "Phone number",
                                    icon: Icons.email,
                                    controller: _controllerPhone,
                                    type: TextInputType.phone
                                  )),
                                ],
                              )
                          ),

                          SizedBox(height: 50,),

                          Center(child: Text(strings.get(61), style: theme.style15W400)), /// "We'll sent verification code.",

                          SizedBox(height: 50,),

                          button2(strings.get(62), theme.mainColor, _continue), /// "CONTINUE"
                        ],
                      )
                  ),

                ],
              ),)
          ],
        )),
    );

    return list;
  }

  bool _continuePress = false;

  @override
  void deactivate() {
    _out();
    super.deactivate();
  }

  _out() {
    if (!_continuePress)
      logout();
  }

  _continue() async {

    if (_controllerPhone.text.isEmpty)
      return messageError(context, strings.get(63)); /// "Enter your phone number",

    _continuePress = true;

    login(){
      goBack();
    }

    _goToCode(){
      _mainModel.route("otp");
    }

    _mainModel.waits(true);
    var ret = await sendOTPCode(_controllerPhone.text, context, login, _goToCode,
        appSettings,
        strings.get(145) /// Code sent. Please check your phone for the verification code.
    );
    _mainModel.waits(false);
    if (ret != null)
      messageError(context, ret);

  }

}
