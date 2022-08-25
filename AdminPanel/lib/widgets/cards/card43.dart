// import 'package:flutter/material.dart';
//
// class Card43 extends StatelessWidget {
//   final String image;
//   final String text1;
//   final TextStyle style1;
//   final String text2;
//   final TextStyle style2;
//   final String text3;
//   final TextStyle style3;
//   final String text4;
//   final TextStyle style4;
//   final bool shadow;
//   final Color bkgColor;
//   final double radius;
//   final double imageRadius;
//   final double padding;
//   final Widget icon;
//
//   const Card43({Key? key, required this.image, required this.text1, required this.style1, required this.text2, required this.style2,
//     required this.text3, required this.style3, required this.text4, required this.style4,
//     required this.icon,
//     this.shadow = false, this.bkgColor = Colors.white, this.radius = 10, this.imageRadius = 50,
//     this.padding = 5, }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: EdgeInsets.all(padding),
//         decoration: BoxDecoration(
//           color: bkgColor,
//           borderRadius: BorderRadius.circular(radius),
//           boxShadow: (shadow) ? [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               spreadRadius: 3,
//               blurRadius: 5,
//               offset: Offset(3, 3),
//             ),
//           ] : null,
//         ),
//         child: Container(
//           padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
//
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//
//               Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(text1, style: style1,),
//                       SizedBox(height: 5,),
//                       Text(text2, style: style2,),
//                       SizedBox(height: 15,),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           icon,
//                           SizedBox(width: 5,),
//                           Text(text3, style: style3,),
//                           SizedBox(width: 5,),
//                           Container(
//                             height: 15,
//                               alignment: Alignment.center,
//                               child: Container(
//                             width: 5,
//                             height: 5,
//                             decoration: BoxDecoration(
//                               color: Colors.grey,
//                               shape: BoxShape.circle,
//                             ),
//                           )),
//                           SizedBox(width: 5,),
//                           Flexible(child: FittedBox(child: Text(text4, style: style4,))),
//                         ],
//                       )
//                     ],)),
//               SizedBox(width: 20,),
//               Container(
//                 height: 60,
//                 width: 60,
//                 //padding: EdgeInsets.only(left: 10, right: 10),
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(imageRadius),
//                     child: image.isNotEmpty ? Image.network(image, fit: BoxFit.cover,
//                             ) : Container(),
//                     ),
//               ),
//               SizedBox(width: 10,),
//             ],
//           ),
//
//         ));
//   }
// }
