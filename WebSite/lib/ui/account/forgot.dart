import 'package:firebase_auth/firebase_auth.dart';
import 'package:ondemand_admin/widgets/edit37.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
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
              margin: isMobile() ? null : EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
              child: BackSiteButton(text: strings.get(46))), /// Back to Login
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
                          SizedBox(height: 20),
                          Text(strings.get(42), /// "Reset password",
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                          SizedBox(height: 40),
                          Edit37(
                            hint: strings.get(43), /// "Email",
                            iconColor: Colors.grey,
                            icon: Icons.email,
                            controller: _controllerEmail,
                          ),
                          SizedBox(height: 20,),
                          button2(strings.get(44), theme.mainColor, _reset), /// "Send new password",

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

  _reset() async {
    _mainModel.waits(true);
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _controllerEmail.text);
    }catch(ex) {
      _mainModel.waits(false);
      return messageError(context, ex.toString());
    }
    _mainModel.waits(false);
    messageOk(context, strings.get(45)); /// "Reset password email sent. Please check your mail."
  }

}
