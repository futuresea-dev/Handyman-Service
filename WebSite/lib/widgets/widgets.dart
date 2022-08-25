import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import '../ui/strings.dart';
import '../theme.dart';

getPriceText(PriceData item, List<Widget> list2, MainModel _mainModel){
  if (item.discPrice == 0)
    list2.add(Column(
      children: [
        Text(getPriceString(item.price), style: theme.style20W800Green),
        Text((item.priceUnit == "fixed") ? strings.get(21) : strings.get(22), style: theme.style12W800), /// "fixed", - "hourly",
      ],));
  else{
    list2.add(Column(
      children: [
        Text(getPriceString(item.discPrice), style: theme.style20W800Red),
        Text((item.priceUnit == "fixed") ? strings.get(21) : strings.get(22), style: theme.style12W800), /// "fixed", - "hourly",
      ],
    ));
    list2.add(SizedBox(width: 5,));
    list2.add(Text(getPriceString(item.price), style: theme.style16W400U),);
  }
}

