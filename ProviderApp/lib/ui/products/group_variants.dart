import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:uuid/uuid.dart';

class DialogVariantsGroup extends StatefulWidget {
  const DialogVariantsGroup({Key? key,}) : super(key: key);

  @override
  _DialogVariantsGroupState createState() => _DialogVariantsGroupState();
}

class _DialogVariantsGroupState extends State<DialogVariantsGroup> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerName = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    editAddon = null;

    if (variantGroupEdit != null)
      _controllerName.text = getTextByLocale(variantGroupEdit!.name, _mainModel.customerAppLangsComboValue);
    super.initState();
  }

  @override
  void dispose() {
    editAddon = null;
    _controllerName.dispose();
    super.dispose();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  String _name = "";

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
    body: Directionality(
    textDirection: strings.direction,
    child: Container(
        width: windowWidth,
        height: windowHeight,
        child: Stack(
          children: [

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20),
              width: windowWidth,
              height: windowHeight,
              padding: EdgeInsets.all(20),
              child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(strings.get(244), style: theme.style14W800, textAlign: TextAlign.center,), /// "Group name"
                        SizedBox(width: 10,),
                        Text("(${_mainModel.customerAppLangsComboValue})", style: theme.style13W800Red,)
                      ],
                    ),
                    SizedBox(height: 40,),
                    textElement2(strings.get(16), "", _controllerName, (String val){           /// Name
                      _name = val;
                      _redraw();
                    }),
                    SizedBox(height: 60,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button2b(variantGroupEdit != null ? strings.get(242) : strings.get(243), (){  /// "Save group" "Add group",

                          if (variantGroupEdit == null)
                            currentArticle.group.add(GroupData(id: Uuid().v4(),
                                name: [StringData(code: _mainModel.customerAppLangsComboValue, text: _name)], price: []));
                          else{
                            var _found = false;
                            for (var item in variantGroupEdit!.name)
                              if (item.code == _mainModel.customerAppLangsComboValue) {
                                item.text = _name;
                                _found = true;
                              }
                            if (!_found)
                              variantGroupEdit!.name.add(StringData(code: _mainModel.customerAppLangsComboValue, text: _name));
                          }
                          Navigator.pop(context);
                        }, enable: _name.isNotEmpty),
                        SizedBox(width: 20,),
                        button2b(strings.get(174), () {  /// "Close",
                          Navigator.pop(context);
                        }),
                      ],
                    ),
                  ],
                ),
        ),

        appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
            "", context, () {Navigator.pop(context);}),
      ],
        ))
    ));
  }
}

