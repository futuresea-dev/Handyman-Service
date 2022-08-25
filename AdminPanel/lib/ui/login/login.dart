import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/buttons/button2.dart';
import 'package:ondemand_admin/widgets/edit/edit37.dart';
import 'package:ondemand_admin/widgets/edit/edit38.dart';
import '../strings.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  double windowWidth = 0;
  double windowHeight = 0;

  final GlobalKey _key = GlobalKey();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  bool _ckeckValues = true;

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
    return GestureDetector(
            onTap: (){
              if (_dialogPositionY != 0){
                _dialogPositionY = 0;
                _redraw();
              }
            },
            child: Stack(
          children: <Widget>[

              Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UnconstrainedBox(
                          child: Container(
                              width: 70,
                              height: 70,
                              child: appSettings.adminPanelLogoServer.isEmpty ? Image.asset("assets/applogo.png",
                                  fit: BoxFit.contain)
                              : Image.network(appSettings.adminPanelLogoServer, fit: BoxFit.contain,),
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
                                    Text(strings.get(186), /// "Welcome. Please Login to continue"
                                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                                    SizedBox(height: 40),
                                    Edit37(
                                      hint: strings.get(187), /// "Email",
                                      bkgColor: Colors.white,
                                      borderColor: Colors.grey.withAlpha(100),
                                      radius: 5,
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
                                      hint: strings.get(93), /// "Password",
                                      bkgColor: Colors.white,
                                      iconColor: Colors.grey,
                                      borderColor: Colors.grey.withAlpha(100),
                                      radius: 5,
                                      controller: _controllerPassword,
                                    ),
                                    SizedBox(height: 30,),
                                    Row(
                                      children: [
                                        Expanded(child: checkBox1(strings.get(188), /// "Remember me",
                                            theme.mainColor, TextStyle(fontSize: 16, color: Colors.grey), _ckeckValues, (val) {setState(() {_ckeckValues = val!;});})),
                                        SizedBox(width: 20,),
                                        Expanded(child: button2a(strings.get(189), theme.style14W600White, theme.mainColor, theme.radius,
                                                (){_login();}, true)) /// "Sign In"
                                      ],
                                    ),

                                    SizedBox(height: 30,),

                                  ],
                                )
                            ),
                            SizedBox(height: 20,),
                            button134(strings.get(190), /// "Forgot password?",
                                    (){
                                      route("forgot");
                                  // Navigator.pushNamed(context, "/forgot");
                                }, style: theme.style18W800Grey),
                            SizedBox(height: 10,),
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
                                            Text("Email: admin@admin.com", style: theme.style12W600Grey,),
                                            SizedBox(height: 10,),
                                            Text("Password: 123456", style: theme.style12W600Grey,),
                                          ],
                                        ),
                                      ),
                                      button2icon(theme.mainColor, theme.radius, (){
                                        _controllerEmail.text = "admin@admin.com";
                                        _controllerPassword.text = "123456";
                                        setState(() {
                                        });
                                      }, )
                                    ],
                                  ),
                                ],
                              ))
                          ],
                        ),)
                    ],
                  )),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                    child: Text(appSettings.copyright, style: theme.style14W400Grey,)),
              ),

            _loginAndPasswordLists(),

            if (_wait)
              Center(child: Container(child: Loader7(color: theme.mainColor,))),

          ],
        ));
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _login() async {
    _waits(true);
    var ret = await accountLoginToDashboard(_controllerEmail.text, _controllerPassword.text, _ckeckValues,
        strings.get(191), /// "Username or password is incorrect"
        strings.get(250), /// "Permission denied");
    );
    if (ret != null)
      messageError(context, ret);
    else
      redrawMainWindow();
      //Navigator.pushNamed(context, "/dashboard2");
    _waits(false);
  }

  _loginAndPasswordLists(){
    if (_dialogPositionY == 0)
      return Container();
    List<Widget> list = [];
    String email2 = "";
    int t = 0;
    do{
      var email = pref.get("email$t");
      String pass = pref.get("pass$t");
      if (email.isNotEmpty && pass.isNotEmpty){
        list.add(InkWell(
          onTap: (){
            _controllerEmail.text = email;
            _controllerPassword.text = pass;
            _dialogPositionY = 0;
            _redraw();
          },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(email),
                Text("******"),
              ],),
            )));
      }
      t++;
      email2 = email;
    }while(email2.isNotEmpty);

    return Container(
      margin: EdgeInsets.only(top: _dialogPositionY, left: _dialogPositionX),
      width: _dialogWidth,
      child: ListView(
        shrinkWrap: true,
        children: list,
      ),);
  }

  double _dialogPositionX = 0;
  double _dialogPositionY = 0;
  double _dialogWidth = 0;

  _openListUsers(){
    final RenderBox? renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox!.localToGlobal(Offset.zero); // this is global position
    _dialogPositionY = position.dy;
    _dialogPositionX = position.dx;
    _dialogWidth = renderBox.size.width;
    _redraw();
  }
}
