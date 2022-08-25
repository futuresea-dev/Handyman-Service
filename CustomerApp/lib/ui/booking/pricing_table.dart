// import 'package:flutter/material.dart';
// import 'package:ondemandservice/model/localSettings.dart';
// import 'package:ondemandservice/model/model.dart';
//
// import '../../strings.dart';
// import '../../util.dart';
// import '../theme.dart';
//
// pricingTable(BuildContext context, MainModel _mainModel){
//
//   List<Widget> list = [];
//   list.add(SizedBox(height: 5,));
//   list.add(Divider(color: (theme.darkMode) ? Colors.white : Colors.black));
//   list.add(SizedBox(height: 5,));
//   list.add(Text(strings.get(221), style: theme.style13W400,),); /// "Addons",
//   list.add(SizedBox(height: 10,));
//   bool _found = false;
//   if (_mainModel.currentService.addon.isNotEmpty) {
//     for (var item in _mainModel.currentService.addon) {
//       if (!item.selected)
//         continue;
//       list.add(Container(
//           margin: strings.direction == TextDirection.ltr ? EdgeInsets.only(left: 20) : EdgeInsets.only(right: 20),
//           child: Row(
//             children: [
//               Expanded(child: Text("${getTextByLocale(item.name)} ${item.needCount}x${_mainModel.localAppSettings.getPriceString(item.price)}",
//                 style: theme.style13W400,)),
//               SizedBox(width: 5,),
//               Text("${_mainModel.localAppSettings.getPriceString(item.needCount*item.price)}",
//                 style: theme.style14W800,)
//             ],
//           )
//       ));
//       _found = true;
//     }
//   }
//   Widget _addons = Column(children: list,);
//
//   return Container(
//       padding: EdgeInsets.all(20),
//       color: (theme.darkMode) ? Colors.black : Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(strings.get(74), /// "Pricing",
//               style: theme.style14W800),
//           Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(getTextByLocale(localSettings.price.name), style: theme.style13W400)),
//               SizedBox(width: 10,),
//               Text(localSettings.price.getPriceString(_mainModel), style: theme.style14W800,)
//             ],
//           ),
//           SizedBox(height: 5,),
//           Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(strings.get(75), /// "Quantity",
//                 style: theme.style13W400,)),
//               Text(localSettings.count.toString(), style: theme.style14W800,)
//             ],
//           ),
//
//           if (_found)
//             _addons,
//
//           SizedBox(height: 5,),
//           Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(strings.get(167), /// "Coupon",
//                 style: theme.style13W400,)),
//               Text(localSettings.coupon == null ? strings.get(168) : localSettings.getCouponString(_mainModel),
//                 style: theme.style14W800,) /// no
//             ],
//           ),
//           Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(strings.get(76), /// "Tax amount",
//                   style: theme.style13W400)),
//               Text("(${_mainModel.currentService.tax}%) "
//                   "${localSettings.getTaxString(_mainModel)}", style: theme.style14W800,)
//             ],
//           ),
//           SizedBox(height: 5,),
//           Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(strings.get(77), /// "Total",
//                   style: theme.style14W800)),
//               Text(localSettings.getTotalString(_mainModel), style: theme.style16W800Orange,)
//             ],
//           ),
//         ],
//       )
//   );
// }