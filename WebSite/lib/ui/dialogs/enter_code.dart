import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../mainModel/model.dart';
import '../../theme.dart';
import '../strings.dart';

class EnterCodeScreen extends StatefulWidget {
  final Function() close;
  EnterCodeScreen({required this.close});
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
                    width: isMobile() ? windowWidth : windowWidth*0.5,
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child:
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _child(),
                    )
                )
            ),

          ]),
      );
  }

  String _text = " ";

  List<Widget> _child(){
    List<Widget> list = [];

    list.add(Text(strings.get(225),  /// "Your promo code",
        style: theme.style16W800,)
    );

    list.add(SizedBox(height: 20,));

    list.add(Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: edit42("",
        _editControllerCode,
        strings.get(64), /// "Enter code",
        onchange: (String value){
            var ret = isValidCodeForCard(value, _mainModel.cartUser, _mainModel.currentService);
            _text = "";
            if (ret == "not_found")
              _text = strings.get(102); /// "Coupon not found",
            if (ret == "expired")
              _text = strings.get(103); /// "Coupon has expired",
            if (ret == "not_supported_by_this_provider")
              _text = strings.get(104); /// "Coupon not supported by this provider",
            if (ret == "not_support_this_category")
              _text = strings.get(105); /// "Coupon not support this category",
            if (ret == "not_support_this_service")
              _text = strings.get(106); /// "Coupon not support this category",
            if (ret == "not_support_this_product")
              _text = strings.get(223); /// "Coupon not support this product",
            _redraw();
        }
      ),
    ));

    list.add(SizedBox(height: 10,));

    list.add(Center(child: Text(_text, style: theme.style16W800Orange,)));
    list.add(SizedBox(height: 10,));
    list.add(Center(child: Text(lastCouponAdditionTextError, style: theme.style16W800Orange, textAlign: TextAlign.center,)));

    list.add(SizedBox(height: 50,));
    list.add(Center(child: SizedBox(
      width: isMobile() ? windowWidth*0.5 : windowWidth*0.25,
      child: button2(strings.get(224), /// "Apply code"
          theme.mainColor, (){
            activateCoupon(_editControllerCode.text);
            widget.close();
          }, radius: 0, enable: _text.isEmpty),
    )));

    list.add(SizedBox(height: 150,));

    return list;
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }
}
