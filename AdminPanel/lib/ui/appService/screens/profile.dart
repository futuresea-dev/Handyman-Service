
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/widgets/buttons/button2.dart';
import 'package:ondemand_admin/widgets/cards/card42button.dart';
import 'theme.dart';

class ProfileScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const ProfileScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  final _editControllerName = TextEditingController();
  final _editControllerEmail = TextEditingController();
  final _editControllerPhone = TextEditingController();
  final _editControllerPassword1 = TextEditingController();
  final _editControllerPassword2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _editControllerName.dispose();
    _editControllerEmail.dispose();
    _editControllerPhone.dispose();
    _editControllerPassword1.dispose();
    _editControllerPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;


    // var _enablePhoneEdit = true;
    // if (Provider.of<MainModel>(context,listen:false).localAppSettings.otpEnable)
    //   _enablePhoneEdit = false;
    // if (_mainModel.userSocialLogin.isNotEmpty)
    //   _enablePhoneEdit = true;

    return Scaffold(
        backgroundColor: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+130, left: 20, right: 20),
              child: ListView(
                children: [

                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: BoxDecoration(
                      color: (darkMode) ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(theme.radius),
                    ),
                    child: Column(
                      children: [
                        edit42(strings.get(21), // "Name",
                            _editControllerName,
                            strings.get(22), // "Enter your name",
                            ),

                        SizedBox(height: 20,),

                        // if (_mainModel.userSocialLogin.isEmpty)
                          edit42(strings.get(23), // "Email",
                              _editControllerEmail,
                              strings.get(24), // "Enter your Email",
                              ),

                        SizedBox(height: 20,),

                        edit42(strings.get(25), // "Phone number",
                            _editControllerPhone,
                            strings.get(26), // "Enter your Phone number",
                            type: TextInputType.phone, //_enablePhoneEdit
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.all(20),
                          child: button2s(strings.get(31), // "SAVE",
                              theme.style16W800White, serviceApp.mainColor, 50, _changeInfo, true),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  // if (_mainModel.userSocialLogin.isEmpty)
                    Column(
                      children: [
                        Text(strings.get(32), // "Change password",
                          style: theme.style16W800,),

                        SizedBox(height: 20,),

                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                          decoration: BoxDecoration(
                            color: (darkMode) ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(theme.radius),
                          ),
                          child: Column(
                              children: [
                                Edit43(
                                    text: strings.get(33), // "New password",
                                    textStyle: theme.style14W600Grey,
                                    controller: _editControllerPassword1,
                                    hint: strings.get(34), // "Enter Password",
                                    editStyle: theme.style15W400,
                                    color: (darkMode) ? Colors.white : Colors.black),

                                SizedBox(height: 20,),

                                Edit43(
                                    text: strings.get(35), // "Confirm New password",
                                    textStyle: theme.style14W600Grey,
                                    controller: _editControllerPassword2,
                                    hint: strings.get(36), // "Enter Password",
                                    editStyle: theme.style15W400,
                                    color: (darkMode) ? Colors.white : Colors.black),

                                SizedBox(height: 20,),

                                Container(
                                  margin: EdgeInsets.all(20),
                                  child: button2s(strings.get(37), // "CHANGE PASSWORD",
                                      theme.style16W800White, serviceApp.mainColor, 50, _changePassword, true),
                                ),
                              ]),
                    ),
                  ]),

                  SizedBox(height: 120,),
                ],
              ),
            ),

            InkWell(
              onTap: _photo,
                child: ClipPath(
                clipper: ClipPathClass23(20),
                child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    width: windowWidth,
                    child: card42button(
                        strings.get(38), /// "My Profile",
                        theme.style20W800,
                        strings.get(39), /// "Everything about you",
                        theme.style14W600Grey,
                        Opacity(opacity: 0.5,
                        child:
                        serviceApp.profileLogoAsset ? Image.asset("assets/ondemands/ondemand12.png", fit: BoxFit.contain) :
                        Image.network(
                            serviceApp.profileLogo,
                            fit: BoxFit.cover)
                        //Image.asset("assets/ondemands/ondemand12.png", fit: BoxFit.cover)
                        ),
                        image16(Image.asset("assets/user5.png", fit: BoxFit.cover), 80, Colors.white),
                        windowWidth, (darkMode) ? Colors.black : Colors.white, _photo
                    )
                ))),

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black, "", context, () {

            }),

            // if (_wait)
            //   Center(child: Container(child: Loader7(color: serviceApp.mainColor,))),

          ],
        )

    ));
  }

  // bool _wait = false;
  // _waits(bool value){
  //   _wait = value;
  //   _redraw();
  // }
  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

  _photo() async {
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   final pickedFile = await ImagePicker().getImage(
    //       maxWidth: 400,
    //       maxHeight: 400,
    //       source: ImageSource.camera);
    //   if (pickedFile != null) {
    //     dprint("Photo file: ${pickedFile.path}");
    //     _waits(true);
    //     var ret = await Provider.of<MainModel>(context,listen:false).uploadAvatar(pickedFile.path);
    //     _waits(false);
    //     if (ret != null)
    //       messageError(context, ret);
    //   }
    // }
  }

  _changePassword() async {
    // if (_editControllerPassword1.text.isEmpty)
    //   return messageError(context, strings.get(34)); /// "Enter Password"
    // if (_editControllerPassword2.text.isEmpty)
    //   return messageError(context, strings.get(151)); /// "Enter Confirm Password"
    // if (_editControllerPassword1.text != _editControllerPassword2.text)
    //   return messageError(context, strings.get(140)); /// "Passwords are not equal",
    //
    // _waits(true);
    // var ret = await Provider.of<MainModel>(context,listen:false).changePassword(_editControllerPassword1.text);
    // _waits(false);
    // if (ret != null)
    //   messageError(context, ret);
    // else
    //   messageOk(context, strings.get(152)); /// "Password changed",
  }

  _changeInfo() async {
    // if (_editControllerName.text.isEmpty)
    //   return messageError(context, strings.get(153)); /// "Please Enter name"
    //
    // _waits(true);
    // var ret = await Provider.of<MainModel>(context,listen:false).changeInfo(_editControllerName.text,
    //     _editControllerEmail.text, _editControllerPhone.text);
    // _waits(false);
    // if (ret != null)
    //   messageError(context, ret);
    // else
    //   messageOk(context, strings.get(154)); /// "Data saved",
  }

}


