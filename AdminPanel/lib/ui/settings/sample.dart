import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/model/initData/sample.dart';
import 'package:ondemand_admin/ui/strings.dart';
import '../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class SampleDataScreen extends StatefulWidget {
  @override
  _SampleDataScreenState createState() => _SampleDataScreenState();
}

class _SampleDataScreenState extends State<SampleDataScreen> {

  final _controllerName = TextEditingController();

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body(strings.get(234), "assets/dashboard2/dashboard2.png", _getList()); /// "Settings | Upload Sample Data",
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  int _stage = 1;
  String _messageText = "";
  String _messageError = "";

  _getList() {
    List<Widget> list = [];
    list.add(SizedBox(height: 20,));

    if (_stage == 1 || _stage == 2){
      list.add(Text(strings.get(235), style: theme.style14W400,)); /// "In this page you can upload sample data."
      list.add(SizedBox(height: 20,));
    }

    if (_stage == 1){
      list.add(button2b(strings.get(237), (){  /// "Upload"
        _stage = 2;
        _redraw();
      }));
    }

    if (_stage == 2){
      list.add(Text(strings.get(238), style: theme.style16W800Red,)); /// "All data in Categories, Services and ...
      list.add(SizedBox(height: 20,));
      list.add(Container(width: 200, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(strings.get(236), style: theme.style14W400),  /// "Enter text",
          SizedBox(height: 5,),
          Edit41web(controller: _controllerName,
            hint: "UPLOAD",
            onChange: (String val){
              _redraw();
            })
        ],
      )));

      list.add(SizedBox(height: 20,));
      list.add(button2b(strings.get(237), _upload, enable: _controllerName.text == "UPLOAD")); /// "Upload"
    }

    if (_stage == 3){
      list.add(Center(child: Text(_messageText, style: theme.style14W800,)));
      list.add(Center(child: Text(_messageError, style: theme.style16W800Red,)));
    }

    list.add(SizedBox(height: 100,));
    return list;
  }

  _upload() async {
    if (appSettings.demo)
      return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
    _stage = 3;
    _redraw();
    // demo mode
    var ret = await uploadSampleData((String msg){
      _messageText = msg;
      _redraw();
    }, context);
    if (ret != null) {
      _messageText = "";
      _messageError = ret;
    }else{
      _messageText = strings.get(240); /// Complete
    }
    _redraw();
  }
}


