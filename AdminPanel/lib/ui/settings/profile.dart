import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:abg_utils/abg_utils.dart';
import '../../model/model.dart';
import '../theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _controllerName = TextEditingController();
  late MainModel _mainModel;

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _controllerName.text = _mainModel.userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        body(strings.get(312), "assets/dashboard2/dashboard2.png", _getList()), /// "Settings | User Profile",
        if (_wait)
          Center(child: Container(child: Loader7(color: theme.mainColor,))),
      ],
    );
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

  _getList() {
    List<Widget> list = [];

    list.add(textElement(strings.get(310) + ":", "", _controllerName)); /// "User Name:",
    list.add(SizedBox(height: 20,));
    list.add(Row(
      children: [
        SelectableText(strings.get(311), style: theme.style14W800,), /// "User avatar",
        SizedBox(width: 30,),
        button2b(strings.get(75), _avatar), /// "Select image",
        if (pickedImage != null)
          Expanded(child: Container(
            width: 200,
            height: 200,
            child: Image.memory(pickedImage!)))
      ],
    ));

    list.add(SizedBox(height: 50,));
    list.add(Center(child: button2b(strings.get(9), _save))); /// "Save"
    list.add(SizedBox(height: 100,));

    return list;
  }

  Uint8List? pickedImage;
  _avatar() async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        pickedImage = await pickedFile.readAsBytes();
        _redraw();
      }
    } catch (e) {
      messageError(context, e.toString());
    }
  }

  _save() async {
    if (_controllerName.text.isEmpty)
      return messageError(context, strings.get(91)); /// "Please Enter Name",
    _waits(true);
    var ret = await _mainModel.setUserData(pickedImage, _controllerName.text);
    if (ret == null){
      messageOk(context, strings.get(81)); /// "Data saved",
      _mainModel.allRedraw();
    }else
      messageError(context, ret);
    _waits(false);
  }
}


