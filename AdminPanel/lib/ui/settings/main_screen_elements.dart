import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/ui/strings.dart';
import '../theme.dart';

class ElementPositionScreen extends StatefulWidget {
  @override
  _ElementPositionScreenState createState() => _ElementPositionScreenState();
}

class _ElementPositionScreenState extends State<ElementPositionScreen> {

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    return body(strings.get(340), "assets/dashboard2/dashboard2.png", _getList()); /// "Customer App Main Screen - Elements position",
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 30,));

    for (var item in appSettings.customerAppElements) {
      list.add(Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Container(
            child: Text(item, style: theme.style14W800),
          )),
          SizedBox(width: 10,),
          CircleAvatar(
              radius: 20,
              backgroundColor: theme.mainColor,
              child: IconButton(icon: Icon(Icons.arrow_upward_rounded, color: Colors.white,), onPressed: (){
                _moveUp(item);
              },)),
          SizedBox(width: 10,),
          CircleAvatar(
              radius: 20,
              backgroundColor: theme.mainColor,
              child: IconButton(icon: Icon(Icons.arrow_downward_rounded, color: Colors.white,), onPressed: (){
                _moveDown(item);
              },)),
          SizedBox(width: 30,),
          Expanded(
            child: checkBox1a(context, strings.get(70), /// "Visible",
                theme.mainColor, theme.style14W400, !appSettings.customerAppElementsDisabled.contains(item),
                    (val) {
                  if (val == null) return;
                  if (appSettings.customerAppElementsDisabled.contains(item))
                    appSettings.customerAppElementsDisabled.remove(item);
                  else
                    appSettings.customerAppElementsDisabled.add(item);
                  _redraw();
                }))
        ],
      )));
      list.add(SizedBox(height: 15,));
    }
    list.add(SizedBox(height: 20,));
    list.add(Container(
      margin: EdgeInsets.only(left: 30, right: 30),
        child: button2b(strings.get(9), () async {  /// "Save"
      var ret = await saveElementsList();
      if (ret == null)
        messageOk(context, strings.get(81)); /// "Data saved",
      else
        messageError(context, ret);
    })));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _moveUp(String item){
    var _index = appSettings.customerAppElements.indexOf(item);
    if (_index != 0)
      appSettings.customerAppElements.replaceRange(_index-1, _index+1,
          [item, appSettings.customerAppElements[_index-1]]);
    _redraw();
  }

  _moveDown(String item){
    var _index = appSettings.customerAppElements.indexOf(item);
    if (_index != appSettings.customerAppElements.length)
      appSettings.customerAppElements.replaceRange(_index, _index+2,
          [appSettings.customerAppElements[_index+1], item]);
    _redraw();
  }

}


