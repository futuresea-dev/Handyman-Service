// import 'package:abg_utils/abg_utils.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// card47(String image,
//     String title, TextStyle titleStyle,
//     String text2, TextStyle text2Style,
//     String text3, TextStyle style3,
//     bool shadow, Color bkgColor,
//     List<ImageData> images,
//     int stars, Color iconStarsColor,
//     ){
//   return Container(
//       padding: EdgeInsets.only(top: 5, bottom: 5),
//       decoration: BoxDecoration(
//         color: bkgColor,
//         borderRadius: new BorderRadius.circular(10),
//         boxShadow: (shadow) ? [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 3,
//             blurRadius: 5,
//             offset: Offset(3, 3),
//           ),
//         ] : null,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//
//               if (image.isNotEmpty)
//                 Container(
//                   height: 60,
//                   width: 60,
//                   margin: EdgeInsets.all(10),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(40),
//                     child: CachedNetworkImage(
//                         imageUrl: image,
//                         imageBuilder: (context, imageProvider) => Container(
//                           width: double.maxFinite,
//                           alignment: Alignment.bottomRight,
//                           child: Container(
//                             //width: height,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.cover,
//                                 )),
//                           ),
//                         )
//                     ),),
//                 ),
//               SizedBox(width: 20,),
//               Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(title, style: titleStyle,),
//                       SizedBox(height: 5,),
//                       Row(
//                         children: [
//
//                           Expanded(child: Text(text2, style: text2Style,)),
//                           SizedBox(width: 10,),
//
//                           Row(children: [
//                             if (stars >= 1)
//                               Icon(Icons.star, color: iconStarsColor, size: 16,),
//                             if (stars < 1)
//                               Icon(Icons.star_border, color: iconStarsColor, size: 16,),
//                             if (stars >= 2)
//                               Icon(Icons.star, color: iconStarsColor, size: 16,),
//                             if (stars < 2)
//                               Icon(Icons.star_border, color: iconStarsColor, size: 16,),
//                             if (stars >= 3)
//                               Icon(Icons.star, color: iconStarsColor, size: 16,),
//                             if (stars < 3)
//                               Icon(Icons.star_border, color: iconStarsColor, size: 16,),
//                             if (stars >= 4)
//                               Icon(Icons.star, color: iconStarsColor, size: 16,),
//                             if (stars < 4)
//                               Icon(Icons.star_border, color: iconStarsColor, size: 16,),
//                             if (stars >= 5)
//                               Icon(Icons.star, color: iconStarsColor, size: 16,),
//                             if (stars < 5)
//                               Icon(Icons.star_border, color: iconStarsColor, size: 16,),
//                           ]
//                           ),
//
//                           SizedBox(width: 10,),
//
//                         ],
//                       ),
//                       SizedBox(height: 5,),
//                     ],))
//
//             ],
//           ),
//
//           Container(
//             margin: EdgeInsets.all(10),
//             child: Text(text3, style: style3,),
//           ),
//
//           Container(
//             margin: EdgeInsets.all(5),
//             child: Wrap(
//               children: images.map((e) {
//                 return Container(
//                   margin: EdgeInsets.all(5),
//                   child: UnconstrainedBox(
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         child: CachedNetworkImage(
//                             imageUrl: e.serverPath,
//                             imageBuilder: (context, imageProvider) => Container(
//                               width: double.maxFinite,
//                               alignment: Alignment.bottomRight,
//                               child: Container(
//                                 //width: height,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                       image: imageProvider,
//                                       fit: BoxFit.cover,
//                                     )),
//                               ),
//                             )
//                         ),
//                       )),
//                 );
//               }).toList(),
//             ),
//           )
//
//
//         ],
//       )
//
//   );
// }
//
//
