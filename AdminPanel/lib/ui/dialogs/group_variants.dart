import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:uuid/uuid.dart';

class DialogVariantsGroup extends StatefulWidget {
  final Function() close;

  const DialogVariantsGroup({Key? key, required this.close,}) : super(key: key);

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
    if (variantGroupEdit != null)
      _controllerName.text = getTextByLocale(variantGroupEdit!.name, _mainModel.langEditDataComboValue);
    super.initState();
  }

  @override
  void dispose() {
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

    return Container(
        width: windowWidth,
        height: windowHeight,
        child: Stack(
          children: [

            InkWell(
              onTap: widget.close,
              child:
              Container(
                width: windowWidth,
                height: windowHeight,
                color: Colors.grey.withAlpha(50),
              ),
            ),


        Center(
            child: Container(
                width: windowWidth*0.8,
                // height: windowHeight*0.6,
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(strings.get(438), style: theme.style14W800, textAlign: TextAlign.center,), /// "Group name"
                            SizedBox(width: 10,),
                            Text("(${_mainModel.langEditDataComboValue})", style: theme.style13W800Red,)
                          ],
                        ),
                        SizedBox(height: 40,),
                        textElement2(strings.get(54), "", _controllerName, (String val){           /// Name
                          _name = val;
                          _redraw();
                        }),
                        SizedBox(height: 60,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button2b(variantGroupEdit != null ? strings.get(445) : strings.get(435), (){  /// "Save group" "Add group",

                              if (variantGroupEdit == null)
                                currentArticle.group.add(GroupData(id: Uuid().v4(),
                                    name: [StringData(code: _mainModel.langEditDataComboValue, text: _name)], price: []));
                              else{
                                var _found = false;
                                for (var item in variantGroupEdit!.name)
                                  if (item.code == _mainModel.langEditDataComboValue) {
                                    item.text = _name;
                                    _found = true;
                                  }
                                if (!_found)
                                  variantGroupEdit!.name.add(StringData(code: _mainModel.langEditDataComboValue, text: _name));
                              }
                              widget.close();
                            }, enable: _name.isNotEmpty),
                            SizedBox(width: 20,),
                            button2b(strings.get(184), () {  /// "Close",
                              widget.close();
                            }),
                          ],
                        )

                      ],
                    ),

            )
        )
      ],
        ));
  }
}

