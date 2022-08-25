// import 'package:flutter/material.dart';
// import 'package:ondemand_admin/mainModel/model.dart';
// import '../../strings.dart';
// import '../theme.dart';
// import '../utils.dart';
//
// pricingTable(BuildContext context, MainModel _mainModel){
//
//   List<Widget> list = [];
//   list.add(SizedBox(height: 5,));
//   list.add(Divider(color: (darkMode) ? Colors.white : Colors.black, thickness: 0.5,));
//   list.add(SizedBox(height: 5,));
//   list.add(Text(strings.get(23), style: theme.style14W400,),); /// "Addons",
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
//               Expanded(child: Text("${getTextByLocale(item.name)} ${item.needCount}x${appSettings.getPriceString(item.price)}",
//                 style: theme.style14W400,)),
//               SizedBox(width: 5,),
//               Text("${appSettings.getPriceString(item.needCount*item.price)}",
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
//       color: (darkMode) ? Colors.black : Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(strings.get(109), /// "Pricing",
//               style: theme.style14W800),
//           Divider(color: (darkMode) ? Colors.white : Colors.black, thickness: 0.5),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(getTextByLocale(_mainModel.price.name), style: theme.style14W400)),
//               SizedBox(width: 10,),
//               Text(_mainModel.price.getPriceString(_mainModel), style: theme.style14W800,)
//             ],
//           ),
//           SizedBox(height: 5,),
//           Divider(color: (darkMode) ? Colors.white : Colors.black, thickness: 0.5),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(strings.get(108), /// "Quantity",
//                 style: theme.style14W400,)),
//               Text(_mainModel.count.toString(), style: theme.style14W800,)
//             ],
//           ),
//
//           if (_found)
//             _addons,
//
//           SizedBox(height: 5,),
//           Divider(color: (darkMode) ? Colors.white : Colors.black, thickness: 0.5),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(strings.get(110), /// "Coupon",
//                 style: theme.style14W400,)),
//               Text(_mainModel.coupon == null ? strings.get(111) : _mainModel.getCouponString(),
//                 style: theme.style14W800,) /// no
//             ],
//           ),
//           Divider(color: (darkMode) ? Colors.white : Colors.black, thickness: 0.5),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(strings.get(112), /// "Tax amount",
//                   style: theme.style14W400)),
//               Text("(${_mainModel.currentService.tax}%) "
//                   "${_mainModel.getTaxString()}", style: theme.style14W800,)
//             ],
//           ),
//           SizedBox(height: 5,),
//           Divider(color: (darkMode) ? Colors.white : Colors.black, thickness: 0.5),
//           SizedBox(height: 5,),
//           Row(
//             children: [
//               Expanded(child: Text(strings.get(113), /// "Total",
//                   style: theme.style14W800)),
//               Text(_mainModel.getTotalString(), style: theme.style16W800Orange,)
//             ],
//           ),
//         ],
//       )
//   );
// }