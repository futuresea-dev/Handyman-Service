
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:ondemand_admin/widgets/edit37.dart';
import 'package:ondemand_admin/widgets/edit38.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final GlobalKey _key = GlobalKey();
  double _dialogPositionY = 0;
  bool _ckeckValues = true;
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
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
              // margin: isMobile() ? null
              //     : EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
              child: BackSiteButton(text: strings.get(47))), /// "Go back",
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
                borderRadius: BorderRadius.circular(theme.radius),
              ),
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(strings.get(32), /// "Welcome. Please Login to continue"
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                          SizedBox(height: 40),
                          Edit37(
                            hint: strings.get(33), /// "Email",
                            icon: Icons.email,
                            controller: _controllerEmail,
                            onTap: _openListUsers,
                            onChangeText: (String value){
                              if (_dialogPositionY != 0){
                                _dialogPositionY = 0;
                                _redraw();
                              }
                            },
                          ),
                          Container(key: _key, height: 20, width: double.maxFinite),
                          Edit38(
                            hint: strings.get(34), /// "Password",
                            bkgColor: Colors.white,
                            iconColor: Colors.grey,
                            borderColor: Colors.grey.withAlpha(100),
                            controller: _controllerPassword,
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Expanded(child: checkBox1(strings.get(35), /// "Remember me",
                                  theme.mainColor, TextStyle(fontSize: 16, color: Colors.grey), _ckeckValues, (val) {setState(() {_ckeckValues = val!;});})),
                              SizedBox(width: 20,),
                              Expanded(child: button2(strings.get(36), theme.mainColor, (){_login();})) /// "Sign In"
                            ],
                          ),

                          SizedBox(height: 30,),

                        ],
                      )
                  ),
                  SizedBox(height: 20,),
                  button134(strings.get(39), /// "Forgot password?",
                          (){
                        _mainModel.route("forgot");
                      }, style: theme.style18W800Grey),
                  SizedBox(height: 10,),
                  button134(strings.get(48), /// "Don't have account. Register",
                          (){
                        _mainModel.route("register");
                      }, style: TextStyle(color: Colors.grey, fontSize: 18)),
                  SizedBox(height: 10,),
                  Center(
                    child: Text(strings.get(41), /// "or continue with",
                        style: theme.style12W400),
                  ),
                  SizedBox(height: 10,),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(child: button2("Facebook", theme.mainColor, _facebookLogin)),
                          SizedBox(width: 10,),
                          Flexible(child: button2("Google", theme.mainColor, _googleLogin)),
                        ],
                      )
                  ),

                  if (appSettings.demo)
                    Container(child: Column(
                      children: [
                        Divider(),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email: user@ondemand.com", style: theme.style12W600Grey,),
                                SizedBox(height: 10,),
                                Text("Password: 123456", style: theme.style12W600Grey,),
                              ],
                            ),
                            ),
                            button2icon(theme.mainColor, theme.radius, (){
                              _controllerEmail.text = "user@ondemand.com";
                              _controllerPassword.text = "123456";
                              _redraw();
                            }, )
                          ],
                        ),
                        SizedBox(height: 20,),
                      ],
                    ))
                ],
              ),)
          ],
        )),
    );

    return list;
  }

  _openListUsers(){
    final RenderBox? renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox!.localToGlobal(Offset.zero); // this is global position
    _dialogPositionY = position.dy;
    // _dialogPositionX = position.dx;
    // _dialogWidth = renderBox.size.width;
    _redraw();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _login() async {
    _mainModel.waits(true);
    var ret = await _mainModel.account.accountLogin(_controllerEmail.text, _controllerPassword.text, _ckeckValues);
    if (ret != null)
      messageError(context, ret);
    else
      _mainModel.route("home");

    _mainModel.waits(false);
  }

  _googleLogin() async {
    _mainModel.waits(true);
    var ret = await googleLogin();
    _mainModel.waits(false);
    if (ret != null)
      return messageError(context, ret);
    _mainModel.route("home");
  }

  _facebookLogin() async {
    _mainModel.waits(true);
    var ret = await facebookLogin();
    _mainModel.waits(false);
    if (ret != null)
      return messageError(context, ret);
    _mainModel.route("home");
  }

}
