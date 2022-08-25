import 'package:ondemand_admin/widgets/edit37.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/edit38.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerPassword2 = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerPassword2.dispose();
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
            SizedBox(height: 20,),
            Container(
              margin: isMobile() ? null : EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
              child: BackSiteButton(text: strings.get(46))), /// Back to Login
            SizedBox(height: 20,),
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
                  Text(strings.get(49), style: theme.style25W800), /// "Register",
                  SizedBox(height: 10,),
                  Text(strings.get(50), style: theme.style16W600Grey), /// "in less than a minute",

                  SizedBox(height: 20),
                  Edit37(
                    hint: strings.get(51), /// "Name",
                    iconColor: Colors.grey,
                    icon: Icons.account_circle_outlined,
                    controller: _controllerName,
                  ),
                  SizedBox(height: 20),
                  Edit37(
                    hint: strings.get(43), /// "Email",
                    iconColor: Colors.grey,
                    icon: Icons.email,
                    controller: _controllerEmail,
                  ),
                  SizedBox(height: 20,),
                  Edit38(
                    hint: strings.get(34), /// "Password",
                    bkgColor: Colors.white,
                    iconColor: Colors.grey,
                    borderColor: Colors.grey.withAlpha(100),
                    controller: _controllerPassword,
                  ),
                  SizedBox(height: 20,),
                  Edit38(
                    hint: strings.get(52), /// "Confirm Password",
                    bkgColor: Colors.white,
                    iconColor: Colors.grey,
                    borderColor: Colors.grey.withAlpha(100),
                    controller: _controllerPassword2,
                  ),

                  SizedBox(height: 30,),
                  button2(strings.get(49), theme.mainColor, _register), /// "Register",
                  SizedBox(height: 30,),
                ],
              )
          ),

          ],
        )),
    );

    return list;
  }

  _register() async {
    if (_controllerEmail.text.isEmpty)
      return strings.get(54); /// "Please Enter Email",
    if (_controllerPassword.text.isEmpty || _controllerPassword2.text.isEmpty)
      return strings.get(55); /// "Please enter password",
    if (_controllerPassword.text != _controllerPassword2.text)
      return strings.get(56); /// "Passwords are not equal",
    if (!validateEmail(_controllerEmail.text))
      return strings.get(57); /// "Email are wrong",
    ///
    _mainModel.waits(true);
    var ret = await register(_controllerName.text, _controllerEmail.text,
      _controllerPassword.text, _controllerPassword2.text,);
    _mainModel.waits(false);
    if (ret != null)
      return messageError(context, ret);

    goBack();
    goBack();
  }

}
