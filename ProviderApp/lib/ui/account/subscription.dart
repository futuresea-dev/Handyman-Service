import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';

Widget getSubscriptionInfo(){
  List<Widget> list = [];
  list.add(SizedBox(height: 5,));
  list.add(Text(strings.get(274), style: theme.style16W800,)); /// "Subscription Status",
  list.add(SizedBox(height: 10,));
  if (currentProvider.subscriptions.isEmpty){
    list.add(Text(strings.get(277), style: theme.style16W800Red,)); /// "Not Subscribed",
    list.add(SizedBox(height: 15,));
    list.add(button2b(strings.get(278), (){        /// "Subscribe now",
      route("subscription_plan");
    }));
    list.add(SizedBox(height: 10,));
  }else{
    if (isSubscriptionDateExpired())
      list.add(Text(strings.get(285), style: theme.style16W800Red,)); /// "Expired",
    else
      list.add(Text(strings.get(276), style: theme.style16W800Green,)); /// "Subscribed",
    list.add(SizedBox(height: 10,));
    list.add(Text(strings.get(275), style: theme.style14W400,)); /// "Expire date",
    list.add(SizedBox(height: 5,));
    list.add(Text(getSubscriptionExpiredDateString(), style: theme.style14W400,));
    list.add(SizedBox(height: 15,));
    list.add(button2b(strings.get(279), (){        /// "Extend your subscription",
      route("subscription_plan");
    }));
    list.add(SizedBox(height: 15,));
  }

  return Container(
    margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
    decoration: BoxDecoration(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: list
    ),
  );
}