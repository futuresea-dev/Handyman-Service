import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/strings.dart';
import 'theme.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerMinPurchaseAmount = TextEditingController();
  final _controllerMaxPurchaseAmount = TextEditingController();

  @override
  void initState() {
    _controllerMinPurchaseAmount.text = currentProvider.minPurchaseAmount.toString();
    _controllerMaxPurchaseAmount.text = currentProvider.maxPurchaseAmount.toString();
    super.initState();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    _controllerMinPurchaseAmount.dispose();
    _controllerMaxPurchaseAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
      body: Directionality(
      textDirection: strings.direction,
    child: Stack(
      children: [

        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40, left: 10, right: 10),
          child: ListView(
            padding: EdgeInsets.only(top: 0),
            children: _body(),
          ),
        ),

        appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
            strings.get(269), context, () { /// "Settings",
          Navigator.pop(context);
        }),

      ]),
    ));
  }

  _body(){
    List<Widget> list = [];

    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        CheckBox12((){return currentProvider.useMinPurchaseAmount;},
                (bool value){
              currentProvider.useMinPurchaseAmount = value;
              _redraw();
            }, color: theme.mainColor),
        SizedBox(width: 10,),
        Text(strings.get(267), style: theme.style14W400,),  /// "Minimum order amount",
      ],
    ),);

    if (currentProvider.useMinPurchaseAmount){
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Expanded(child: Edit41web(controller: _controllerMinPurchaseAmount,
              price: true,
              numberOfDigits: appSettings.digitsAfterComma,
              onChange: (String val){
                currentProvider.minPurchaseAmount = toDouble(val);
                _redraw();
              },
              hint: "123",
            ),
          ),
          SizedBox(width: 10,),
          Text(appSettings.symbol, style: theme.style14W400,)
        ],
      ));
    }
    list.add(SizedBox(height: 20,));
    list.add(Divider(color: (theme.darkMode) ? Colors.white : Colors.black),);
    list.add(SizedBox(height: 20,));

    list.add(
        Row(
          children: [
            CheckBox12((){return currentProvider.useMaxPurchaseAmount;},
                    (bool value){
                  currentProvider.useMaxPurchaseAmount = value;
                  _redraw();
                }, color: theme.mainColor),
            SizedBox(width: 10,),
            Text(strings.get(268), style: theme.style14W400,),  /// "Maximum order amount",
          ],
        )
    );

    if (currentProvider.useMaxPurchaseAmount) {
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Expanded(child: Edit41web(controller: _controllerMaxPurchaseAmount,
            price: true,
            numberOfDigits: appSettings.digitsAfterComma,
            onChange: (String val){
              currentProvider.maxPurchaseAmount = toDouble(val);
              _redraw();
            },
            hint: "123",
          ),
          ),
          SizedBox(width: 10,),
          Text(appSettings.symbol, style: theme.style14W400,)
        ],
      ));
    }

    list.add(SizedBox(height: 40,));
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        button2c(strings.get(67), theme.mainColor, () async {  /// "Save",
          if (currentProvider.useMinPurchaseAmount && currentProvider.minPurchaseAmount <= 0)
            return messageError(context, strings.get(271)); /// "Please enter minimum order amount",
          if (currentProvider.useMaxPurchaseAmount && currentProvider.maxPurchaseAmount <= 0)
            return messageError(context, strings.get(272)); /// "Please enter maximum order amount",
          var ret = await providerSaveMinAndMaxAmount(currentProvider);
          if (ret != null)
            messageError(context, ret);
          else
            messageOk(context, strings.get(116)); /// "Data saved",
        })
      ],
    ));

    list.add(SizedBox(height: 10,));
    list.add(Divider(thickness: 0.5,));
    list.add(SizedBox(height: 30,));

    list.add(
        Row(
          children: [
            CheckBox12((){return currentProvider.acceptOnlyInWorkArea;},
                    (bool value){
                  currentProvider.acceptOnlyInWorkArea = value;
                  saveProviderFromAdmin();
                  _redraw();
                }, color: theme.mainColor),
            SizedBox(width: 10,),
            Expanded(child: Text(strings.get(273), /// "Allow booking only if customer located in provider work area",
              style: theme.style14W400,)),
          ],
        )
    );

    list.add(SizedBox(height: 150,));
    return list;
  }

}


