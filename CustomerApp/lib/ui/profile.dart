import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:ondemandservice/widgets/cards/card42button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>  with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _editControllerName = TextEditingController();
  final _editControllerEmail = TextEditingController();
  final _editControllerPhone = TextEditingController();
  final _editControllerPassword1 = TextEditingController();
  final _editControllerPassword2 = TextEditingController();

  @override
  void initState() {
    _editControllerEmail.text = userAccountData.userEmail;
    _editControllerName.text = userAccountData.userName;
    _editControllerPhone.text = userAccountData.userPhone;
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
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);

    var _enablePhoneEdit = true;
    if (appSettings.isOtpEnable())
      _enablePhoneEdit = false;
    if (userAccountData.userSocialLogin.isNotEmpty)
      _enablePhoneEdit = true;

    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
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
                      color: (theme.darkMode) ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        edit42(strings.get(21), // "Name",
                            _editControllerName,
                            strings.get(22), // "Enter your name",
                            ),

                        SizedBox(height: 20,),

                        if (userAccountData.userSocialLogin.isEmpty)
                          edit42(strings.get(23), // "Email",
                              _editControllerEmail,
                              strings.get(24), // "Enter your Email",
                              ),

                        SizedBox(height: 20,),

                        edit42(strings.get(25), // "Phone number",
                            _editControllerPhone,
                            strings.get(26), // "Enter your Phone number",
                            style: _enablePhoneEdit ? theme.style15W400 : theme.style14W600Grey,
                            enabled: _enablePhoneEdit, type: TextInputType.phone
                        ),
                        if (!_enablePhoneEdit)
                          SizedBox(height: 5,),
                        if (!_enablePhoneEdit)
                          Text(strings.get(226), style: theme.style12W600Orange,), /// Your phone number verified. You can't edit phone number

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.all(20),
                          child: button2(strings.get(31), theme.mainColor, _changeInfo), /// "SAVE",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  if (userAccountData.userSocialLogin.isEmpty)
                    Column(
                      children: [
                        Text(strings.get(32), // "Change password",
                          style: theme.style16W800,),

                        SizedBox(height: 20,),

                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                          decoration: BoxDecoration(
                            color: (theme.darkMode) ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              children: [
                                Edit43(
                                    text: strings.get(33), // "New password",
                                    textStyle: theme.style14W600Grey,
                                    controller: _editControllerPassword1,
                                    hint: strings.get(34), // "Enter Password",
                                    color: (theme.darkMode) ? Colors.white : Colors.black),

                                SizedBox(height: 20,),

                                Edit43(
                                    text: strings.get(35), // "Confirm New password",
                                    textStyle: theme.style14W600Grey,
                                    controller: _editControllerPassword2,
                                    hint: strings.get(36), // "Enter Password",
                                    color: (theme.darkMode) ? Colors.white : Colors.black),

                                SizedBox(height: 20,),

                                Container(
                                  margin: EdgeInsets.all(20),
                                  child: button2(strings.get(37), theme.mainColor, _changePassword), /// "CHANGE PASSWORD",
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
                        theme.profileLogoAsset ? Image.asset("assets/ondemands/ondemand12.png", fit: BoxFit.cover) :
                        CachedNetworkImage(
                            imageUrl: theme.profileLogo,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                        ),
                        //Image.asset("assets/ondemands/ondemand12.png", fit: BoxFit.cover)
                        ),
                        image16(userAccountData.userAvatar.isNotEmpty ?
                        CachedNetworkImage(
                            imageUrl: userAccountData.userAvatar,
                            imageBuilder: (context, imageProvider) => Container(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            )
                        ) : Image.asset("assets/user5.png", fit: BoxFit.cover), 80, Colors.white),
                        windowWidth, (theme.darkMode) ? Colors.black : Colors.white, _photo
                    )
                ))),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black, "", context, () {
              Navigator.pop(context);
            }),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

          ],
        )

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

  _photo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pickedFile = await ImagePicker().getImage(
          maxWidth: 400,
          maxHeight: 400,
          source: ImageSource.camera);
      if (pickedFile != null) {
        dprint("Photo file: ${pickedFile.path}");
        _waits(true);
        var ret = await uploadAvatar(await pickedFile.readAsBytes());
        _waits(false);
        if (ret != null)
          messageError(context, ret);
      }
    }
  }

  _changePassword() async {
    if (_editControllerPassword1.text.isEmpty)
      return messageError(context, strings.get(34)); /// "Enter Password"
    if (_editControllerPassword2.text.isEmpty)
      return messageError(context, strings.get(151)); /// "Enter Confirm Password"
    if (_editControllerPassword1.text != _editControllerPassword2.text)
      return messageError(context, strings.get(140)); /// "Passwords are not equal",

    _waits(true);
    var ret = await changePassword(_editControllerPassword1.text);
    _waits(false);
    if (ret != null)
      messageError(context, ret);
    else
      messageOk(context, strings.get(152)); /// "Password changed",
  }

  _changeInfo() async {
    if (_editControllerName.text.isEmpty)
      return messageError(context, strings.get(153)); /// "Please Enter name"
    if (_editControllerEmail.text.isEmpty)
      return messageError(context, strings.get(135)); /// "Please Enter email"
    if (_editControllerPhone.text.isEmpty)
      return messageError(context, strings.get(209)); /// "Please Enter phone"

    _waits(true);
    var ret = await changeInfo(_editControllerName.text,
        _editControllerEmail.text, _editControllerPhone.text);
    _waits(false);
    if (ret != null)
      messageError(context, ret);
    else
      messageOk(context, strings.get(154)); /// "Data saved",
  }

}


