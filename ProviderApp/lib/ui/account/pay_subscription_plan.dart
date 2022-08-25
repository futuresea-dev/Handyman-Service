import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/account/payment.dart';
import '../strings.dart';
import '../theme.dart';

class PaySubscriptionPlanScreen extends StatefulWidget {
  @override
  _PaySubscriptionPlanScreenState createState() => _PaySubscriptionPlanScreenState();
}

class _PaySubscriptionPlanScreenState extends State<PaySubscriptionPlanScreen>  with TickerProviderStateMixin{

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
            textDirection: strings.direction,
            child: Stack(
              children: <Widget>[

                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20,),
                  child: ListView(
                    children: _getList(),
                  ),
                ),

                appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black, "", context, () {
                  goBack();
                }),
              ],
            ))

    );
  }

  _getList(){
    List<Widget> list = [];

    list.add(Container(
      margin: EdgeInsets.all(15),
      child: Text(strings.get(286) + " ${getPriceString(currentSubscription.price)}?", /// "Confirm Subscription. Do you want to subscribe for Two month for"
        style: theme.style14W400,
        textAlign: TextAlign.center,)
    ));

    paymmentsList(list, _redraw, context);

    list.add(SizedBox(height: 100,));

    return list;
  }
}
