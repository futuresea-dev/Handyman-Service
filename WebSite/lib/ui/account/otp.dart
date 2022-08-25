import 'package:ondemand_admin/widgets/edit37.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

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
                borderRadius: BorderRadius.circular(theme.radius),
              ),
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                      child: Column(
                        children: [
                          Center(
                            child: Text(strings.get(65), /// "We've sent 6 digit verification code.",
                                style: theme.style15W400),
                          ),

                          SizedBox(height: 50,),

                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Edit37(
                              hint: strings.get(64), /// "Enter code",
                              icon: Icons.email,
                              controller: _controllerCode,
                              type: TextInputType.number,
                            ),
                          ),

                          SizedBox(height: 20,),

                          button2(strings.get(62), theme.mainColor, _continue), /// "CONTINUE"

                          SizedBox(height: 20,),
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
    var ret = await otp(_controllerCode.text, appSettings,
      strings.get(122), /// Please enter valid code
    );
    if (ret != null)
      return messageError(context, ret);

    _continuePress = true;
    _mainModel.route("home");
  }

}
