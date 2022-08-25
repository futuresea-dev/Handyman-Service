import 'package:flutter/cupertino.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class BookNow4aScreen extends StatefulWidget {
  @override
  _BookNow4aScreenState createState() => _BookNow4aScreenState();
}

class _BookNow4aScreenState extends State<BookNow4aScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _editControllerCoupon = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _appointment();
    super.initState();
  }

  _appointment() async {
    if (_mainModel.cashSuccess){
      _mainModel.cashSuccess = false;
      return;
    }
    var ret = await finish2(_mainModel.payPalSuccess, _mainModel.payPalPaymentId,
        _mainModel.flutterwave,
        _mainModel.mercadoPagoSuccess, _mainModel.mercadoPagoTransactionId);
    if (ret != null)
      return messageError(context, ret);
    _mainModel.clearBookData();
  }

  @override
  void dispose() {
    _editControllerCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Column(children: _getList());
  }

  _getList() {
    List<Widget> list = [];

    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40,),
        UnconstrainedBox(
            child: Container(
              height: 300,
              width: 300,
              child: image11(
                  Image.asset("assets/ondemand33.png", fit: BoxFit.contain),
                  20),
            )),
        SizedBox(height: 20,),
        Text(strings.get(119), /// "Thank you!",
            textAlign: TextAlign.center, style: theme.style20W800),
        SizedBox(height: 20,),
        Text(strings.get(120), /// "Your booking has been successfully submitted, you will receive a confirmation soon."
            textAlign: TextAlign.center, style: theme.style14W400),
        SizedBox(height: 20,),
        Text(cartLastAddedIdToUser, textAlign: TextAlign.center, style: theme.style14W400),
        SizedBox(height: 20,),
        Container(
            alignment: Alignment.center,
            child: Container(
                width: windowWidth/2,
                child: button2x(strings.get(121), /// "Ok",
                        (){

                        _mainModel.route("home");
                    }))),
        SizedBox(height: 20,),
      ],
    ));

    list.add(SizedBox(height: 150,));

    return list;
  }


}
