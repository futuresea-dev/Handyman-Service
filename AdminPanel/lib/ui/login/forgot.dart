import 'package:abg_utils/abg_utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/theme.dart';
import 'package:ondemand_admin/widgets/buttons/button2.dart';
import 'package:ondemand_admin/widgets/edit/edit37.dart';
import '../strings.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _DashboardLoginScreenState createState() => _DashboardLoginScreenState();
}

class _DashboardLoginScreenState extends State<ForgotScreen> {

  final _controllerEmail = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        Stack(
          children: <Widget>[

            Container(
              margin: EdgeInsets.all(20),
              child: BackSiteButton(text: strings.get(419)) /// "Go back",
            ),

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
                              Text(strings.get(192), /// "Reset password",
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                              SizedBox(height: 40),
                              Edit37(
                                hint: strings.get(86), /// "Email",
                                bkgColor: Colors.white,
                                iconColor: Colors.grey,
                                borderColor: Colors.grey.withAlpha(100),
                                radius: 5,
                                icon: Icons.email,
                                controller: _controllerEmail,
                              ),
                              SizedBox(height: 20,),
                              button2a(strings.get(193), theme.style14W600White, theme.mainColor, theme.radius, _reset, true), /// "Send new password",
                            ],
                          )
                        ),
                    ],
                  ),),
              ])),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                    child: Text(appSettings.copyright, style: theme.style14W400Grey,)),
              ),

            if (_wait)
              Center(child: Container(child: Loader7(color: theme.mainColor,))),
          ],
    );
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _reset() async {
    _waits(true);
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _controllerEmail.text);
    }catch(ex) {
      _waits(false);
      return messageError(context, ex.toString());
    }
    _waits(false);
    messageOk(context, strings.get(194)); /// "Reset password email sended. Please check your mail."
  }
}
