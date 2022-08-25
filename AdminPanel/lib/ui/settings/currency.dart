import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/ui/strings.dart';
import '../../model/model.dart';
import '../theme.dart';
import 'package:provider/provider.dart';

class CurrencyScreen extends StatefulWidget {
  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {

  final _controllerCode = TextEditingController();
  final _controllerSymbol = TextEditingController();

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _controllerCode.text = appSettings.code;
    _controllerSymbol.text = appSettings.symbol;
    super.initState();
  }

  @override
  void dispose() {
    _controllerCode.dispose();
    _controllerSymbol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body(strings.get(34), "assets/dashboard2/dashboard3.png", _getList()); /// "Settings | Currency",
  }

  _getList() {
    List<Widget> list = [];

    if (isMobile()) {
      list.add(textElement(strings.get(35), "USD", _controllerCode)); // "Currency Code:"
      list.add(SizedBox(height: 20,));
      list.add(textElement(strings.get(36), "\$", _controllerSymbol)); // "Currency Symbol:"
    }else{
      list.add(Row(
        children: [
          Expanded(child: textElement(strings.get(35), "USD", _controllerCode)), // "Currency Code:"
          SizedBox(width: 20,),
          Expanded(child: textElement(strings.get(36), "\$", _controllerSymbol)), // "Currency Symbol:"
      ]));
      list.add(SizedBox(height: 20,));
    }
    list.add(Row(
      children: [
        Expanded(child: checkBox1a(context, strings.get(38), // "Currency symbol in right"
            theme.mainColor, theme.style14W400, appSettings.rightSymbol,
                (val) {setState(() {appSettings.rightSymbol = val!;});
        })),
        SizedBox(width: 20,),
        Expanded(child: Combo(text: strings.get(37), // "Digits after comma:",
          data: _mainModel.digitsData,
          value: appSettings.digitsAfterComma.toString(),
          onChange: (String value){
            appSettings.digitsAfterComma = int.parse(value); setState(() {});
          },))
      ],
    ));

    list.add(SizedBox(height: 50,));
    list.add(Center(child: button2b(strings.get(9), _save))); // "Save"

    list.add(SizedBox(height: 100,));

    return list;
  }

  _save() async {
    waitInMainWindow(true);
    var ret = await settingsSaveCurrency(_controllerCode.text, _controllerSymbol.text);
    if (ret == null)
      messageOk(context, strings.get(81)); /// "Data saved",
    else
      messageError(context, ret);
    waitInMainWindow(false);
  }
}


