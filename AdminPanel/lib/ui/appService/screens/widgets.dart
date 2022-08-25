import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/ui/appService/screens/theme.dart';

getPriceText(PriceData item, List<Widget> list2, BuildContext context){
  if (item.discPrice == 0)
    list2.add(Column(
      children: [
        Text(getPriceString(item.price), style: theme.style20W800Green),
        Text((item.priceUnit == "fixed") ? strings.get(130) : strings.get(131), style: theme.style12W800), /// "fixed", - "hourly",
      ],));
  else{
    list2.add(Column(
      children: [
        Text(getPriceString(item.discPrice), style: theme.style20W800Red),
        Text((item.priceUnit == "fixed") ? strings.get(130) : strings.get(131), style: theme.style12W800), /// "fixed", - "hourly",
      ],
    ));
    list2.add(SizedBox(width: 5,));
    list2.add(Text(getPriceString(item.price), style: theme.style16W400U),);
  }
}

