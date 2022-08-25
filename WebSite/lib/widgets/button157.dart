// import 'package:flutter/material.dart';
// import '../../strings.dart';
// import '../theme.dart';
//
// Widget button157(String text, Color color, String icon, Function _callback, double width, double height){
//   return InkWell(
//       onTap: (){
//     _callback();
//   },
//   child: Stack(
//     children: <Widget>[
//
//         Container(
//           width: width,
//             height: height,
//           margin: EdgeInsets.only(top: 20),
//           child: Stack(
//               children: <Widget>[
//
//                 Container(
//                     decoration: BoxDecoration(
//                       color: color,
//                       borderRadius: BorderRadius.circular(theme.radius),
//                     ),
//                     padding: EdgeInsets.only(right: 10, left: 10),
//               ),
//
//               ])
//       ),
//
//         Positioned.fill(
//           child: Container(
//             width: double.maxFinite,
//               margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//               // alignment: strings.direction == TextDirection.ltr ? Alignment.centerRight : Alignment.centerLeft,
//                 child: Stack(
//                   children: [
//                     Container(
//                       alignment: strings.direction == TextDirection.ltr ? Alignment.bottomRight : Alignment.bottomLeft,
//                       child: icon.isNotEmpty ? Image.network(icon, fit: BoxFit.contain) : Container(),
//                       // Image.asset(icon,
//                       //   fit: BoxFit.contain,
//                       // )
//                     ),
//
//                     Container(
//                       margin: strings.direction == TextDirection.ltr ? EdgeInsets.only(right: width*0.4, top: 20)
//                           : EdgeInsets.only(left: width*0.4, top: 20),
//                       alignment: strings.direction == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight,
//                       child: Text(text, style: theme.style12W800W, maxLines: 2, overflow: TextOverflow.ellipsis,
//                         textAlign: strings.direction == TextDirection.ltr ? TextAlign.left : TextAlign.right,),
//                     )
//
//                   ],
//                 )
//         )),
//
//     ],
//   ));
// }
