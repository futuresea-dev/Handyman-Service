import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/edit37.dart';
import 'package:ondemand_admin/widgets/edit38.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import 'strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  late MainModel _mainModel;
  final _editControllerName = TextEditingController();
  final _editControllerEmail = TextEditingController();
  final _editControllerPhone = TextEditingController();
  final _editControllerPassword1 = TextEditingController();
  final _editControllerPassword2 = TextEditingController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
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
    return Container(
        margin: EdgeInsets.only(top : 30),
        alignment: Alignment.center,
        child: Container(
          width: isMobile() ? windowWidth : windowWidth*0.4,
          padding: EdgeInsets.all(30),
          child: _getList2(),
        )
    );
  }

  _getList2(){

    List<Widget> list = [];

    list.add(SizedBox(height: 30,));
    list.add(image16(userAccountData.userAvatar.isNotEmpty ? Image.network(userAccountData.userAvatar, fit: BoxFit.cover,)
        : Image.asset("assets/avatar.png",),
        100, Colors.white));
    list.add(SizedBox(height: 50,));
    list.add(button2c(strings.get(184), theme.mainColor, _changeAvatar)); /// "Change avatar",
    list.add(SizedBox(height: 50,));

    if (isMobile())
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...list,
          ..._getList(),
        ]
      );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
            children: list,
        ),
        SizedBox(width: 30,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        )),
      ],
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 40,));

    list.add(Text(strings.get(51), style: theme.style14W400)); /// "Name",
    list.add(SizedBox(height: 5));
    list.add(Edit37(
      controller: _editControllerName,
    ));
    list.add(SizedBox(height: 20));

    if (userAccountData.userSocialLogin.isEmpty){
      list.add(Text(strings.get(33), style: theme.style14W400)); /// "Email",
      list.add(SizedBox(height: 5));
      list.add(Edit37(
        controller: _editControllerEmail,
      ));
      list.add(SizedBox(height: 20));
    }
    list.add(Text(strings.get(60), style: theme.style14W400)); /// "Phone number",
    list.add(SizedBox(height: 5));
    if (appSettings.isOtpEnable()) {
      list.add(Text(_editControllerPhone.text, style: theme.style14W400,));
      list.add(SizedBox(height: 5,));
      list.add(Text(strings.get(146), style: theme.style12W600Orange,)); /// Your phone number verified. You can't edit phone number
    }else
      list.add(Edit37(
        controller: _editControllerPhone,
      ));
    list.add(SizedBox(height: 20));
    list.add(button2x(strings.get(130), (){_changeInfo();})); /// "SAVE",

    list.add(SizedBox(height: 20,));

    if (userAccountData.userSocialLogin.isEmpty){
      list.add(Text(strings.get(132), style: theme.style16W400)); /// "Change password",
      list.add(SizedBox(height: 20));
      list.add(Text(strings.get(133), style: theme.style14W400)); /// "New password",
      list.add(SizedBox(height: 5));
      list.add(Edit38(
        hint: "",
        bkgColor: Colors.white,
        iconColor: Colors.grey,
        borderColor: Colors.grey.withAlpha(100),
        controller: _editControllerPassword1,
      ));
      list.add(SizedBox(height: 20));
      list.add(Text(strings.get(134), style: theme.style14W400)); /// "Confirm New password",
      list.add(SizedBox(height: 5));
      list.add(Edit38(
        hint: "",
        bkgColor: Colors.white,
        iconColor: Colors.grey,
        borderColor: Colors.grey.withAlpha(100),
        controller: _editControllerPassword2,
      ));
      list.add(SizedBox(height: 20));
      list.add(button2x(strings.get(135), (){_changePassword();})); /// "CHANGE PASSWORD",
    }

    return list;
  }

  _changeInfo() async {
    if (_editControllerName.text.isEmpty)
      return messageError(context, strings.get(87)); /// "Please Enter name"

    _mainModel.waits(true);
    var ret = await changeInfo(_editControllerName.text,
        _editControllerEmail.text, _editControllerPhone.text);
    _mainModel.waits(false);
    if (ret != null)
      messageError(context, ret);
    else
      messageOk(context, strings.get(131)); /// "Data saved",
  }

  _changePassword() async {
    if (_editControllerPassword1.text.isEmpty)
      return messageError(context, strings.get(136)); /// "Enter Password"
    if (_editControllerPassword2.text.isEmpty)
      return messageError(context, strings.get(137)); /// "Enter Confirm Password"
    if (_editControllerPassword1.text != _editControllerPassword2.text)
      return messageError(context, strings.get(138)); /// "Passwords are not equal",

    _mainModel.waits(true);
    var ret = await changePassword(_editControllerPassword1.text);
    _mainModel.waits(false);
    if (ret != null)
      messageError(context, ret);
    else
      messageOk(context, strings.get(139)); /// "Password changed",
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _changeAvatar() async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(
          maxHeight: 400,
          maxWidth: 400,
          source: ImageSource.gallery);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null) {
      Uint8List bytesImage = await pickedFile.readAsBytes();
      var ret = await uploadImage("webSiteAvatar", bytesImage);
      if (ret != null)
        messageError(context, ret);

      _redraw();
    }
  }

}
