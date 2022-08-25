import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import 'strings.dart';
import 'theme.dart';

class EnterCodeScreen extends StatefulWidget {
  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {

  final _editControllerCode = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _editControllerCode.text = localSettings.hint;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
      body: Directionality(
      textDirection: strings.direction,
    child: Stack(
          children: [

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50, left: 15, right: 15),
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: _child(),
              ),
            ),

            appbar1((theme.darkMode) ? Colors.black : Colors.white,
                (theme.darkMode) ? Colors.white : Colors.black, "",
                context, () {
                  goBack();
                }, style: theme.style14W800),

            Container(
              alignment: Alignment.bottomCenter,
              child: button2(strings.get(297), /// "Apply code"
                  theme.mainColor, (){
                    activateCoupon(_editControllerCode.text);
                    goBack();
                    goBack();
                  }, radius: 0, enable: _text.isEmpty),
            ),

          ]),
      ));
  }

  String _text = " ";

  List<Widget> _child(){
    List<Widget> list = [];

    list.add(Text(strings.get(296),  /// "Your promo code",
        style: theme.style16W800,)
    );

    list.add(SizedBox(height: 20,));

    list.add(Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: edit42("",
        _editControllerCode,
        strings.get(55), /// "Enter code",
        onchange: (String value){
            var ret = isValidCodeForCard(value, _mainModel.cartUser, _mainModel.currentService);
            _text = "";
            if (ret == "not_found")
              _text = strings.get(162); /// "Coupon not found",
            if (ret == "expired")
              _text = strings.get(169); /// "Coupon has expired",
            if (ret == "not_supported_by_this_provider")
              _text = strings.get(164); /// "Coupon not supported by this provider",
            if (ret == "not_support_this_category")
              _text = strings.get(165); /// "Coupon not support this category",
            if (ret == "not_support_this_service")
              _text = strings.get(166); /// "Coupon not support this category",
            if (ret == "not_support_this_product")
              _text = strings.get(298); /// "Coupon not support this product",
            _redraw();
        }
      ),
    ));

    list.add(SizedBox(height: 10,));

    list.add(Center(child: Text(_text, style: theme.style16W800Red,)));
    list.add(SizedBox(height: 10,));
    list.add(Center(child: Text(lastCouponAdditionTextError, style: theme.style16W800Red, textAlign: TextAlign.center,)));

    list.add(SizedBox(height: 150,));

    return list;
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }
}
