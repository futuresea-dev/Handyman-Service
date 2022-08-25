import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';


class BookNowCancelScreen extends StatefulWidget {
  @override
  _BookNowCancelScreenState createState() => _BookNowCancelScreenState();
}

class _BookNowCancelScreenState extends State<BookNowCancelScreen> {

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
    var ret = await finishDelete();
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
        Text(strings.get(177), /// "Payment cancel!",
            textAlign: TextAlign.center, style: theme.style20W800),
        SizedBox(height: 20,),
        Text(strings.get(178), /// "Your booking has been cancelled, you can making booking again."
            textAlign: TextAlign.center, style: theme.style14W400),
        SizedBox(height: 20,),
        // Text(_mainModel.lastBookingForUser, textAlign: TextAlign.center, style: theme.style14W400),
        // SizedBox(height: 20,),
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
