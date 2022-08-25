// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:ondprovider/model/model.dart';
// import 'package:ondprovider/ui/strings.dart';
// import 'package:ondprovider/ui/theme.dart';
//
// class Card43N extends StatelessWidget {
//   final String image;
//   final String customerName;
//   final String serviceName;
//   final String date;
//   final String dateCreating;
//   final String bookingId;
//   final String jobStatus;
//   final bool shadow;
//   final double imageRadius;
//   final double padding;
//   final Widget icon;
//   final String address;
//   final String paymentMethod;
//   final MainModel mainModel;
//
//   const Card43N({Key? key, required this.image, required this.customerName, required this.serviceName,
//     required this.date, required this.jobStatus, required this.mainModel,
//     required this.icon, required this.dateCreating, required this.bookingId,
//     this.shadow = false, this.imageRadius = 50, required this.address, required this.paymentMethod,
//     this.padding = 5, }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: EdgeInsets.all(padding),
//         decoration: BoxDecoration(
//           color: (theme.darkMode) ? Colors.black : Colors.white,
//           borderRadius: BorderRadius.circular(theme.radius),
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
//           padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
//                       Text(customerName, style: theme.style14W800,),
//                       SizedBox(height: 5,),
//                       Text(serviceName, style: theme.style12W600Grey),
//                       SizedBox(height: 5,),
//                       Row(children: [
//                         Text(strings.get(186), style: theme.style12W800), /// Time creation
//                         SizedBox(width: 10,),
//                         Expanded(child: Text(dateCreating, style: theme.style12W400, overflow: TextOverflow.ellipsis))
//                       ],),
//                       SizedBox(height: 5,),
//                       Row(children: [
//                         Text(strings.get(44), style: theme.style12W800), /// "Booking ID",
//                         SizedBox(width: 10,),
//                         Expanded(child: Text(bookingId, style: theme.style12W400, overflow: TextOverflow.ellipsis,)),
//                       ],),
//                       SizedBox(height: 5,),
//                       Row(children: [
//                         Text(strings.get(63), style: theme.style12W800), /// "Address",
//                         SizedBox(width: 10,),
//                         Expanded(child: Text(address, style: theme.style12W400, overflow: TextOverflow.ellipsis, maxLines: 3,)),
//                       ],),
//                       SizedBox(height: 5,),
//                       Row(children: [
//                         Text(strings.get(202), style: theme.style12W800), /// "Payment method",
//                         SizedBox(width: 10,),
//                         Expanded(child: Text(paymentMethod, style: theme.style12W400, overflow: TextOverflow.ellipsis)),
//                       ],),
//
//
//                       SizedBox(height: 15,),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           icon,
//                           SizedBox(width: 5,),
//                           Text(date, style: theme.style12W400,),
//                           SizedBox(width: 5,),
//                           Container(
//                               height: 15,
//                               alignment: Alignment.center,
//                               child: Container(
//                                 width: 5,
//                                 height: 5,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey,
//                                   shape: BoxShape.circle,
//                                 ),
//                               )),
//                           SizedBox(width: 5,),
//                           Flexible(child: FittedBox(child: Text(jobStatus, style: theme.style13W800Blue,))),
//                         ],
//                       )
//                     ],)),
//               if (image.isNotEmpty)
//               SizedBox(width: 20,),
//               if (image.isNotEmpty)
//               Container(
//                 height: 60,
//                 width: 60,
//                 //padding: EdgeInsets.only(left: 10, right: 10),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(imageRadius),
//                   child: image.isNotEmpty ? CachedNetworkImage(
//                       imageUrl: image,
//                       imageBuilder: (context, imageProvider) => Container(
//                         width: double.maxFinite,
//                         alignment: Alignment.bottomRight,
//                         child: Container(
//                           //width: height,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: imageProvider,
//                                 fit: BoxFit.cover,
//                               )),
//                         ),
//                       )
//                   ) : Container(),
//                 ),
//               ),
//               SizedBox(width: 10,),
//             ],
//           ),
//
//         ));
//   }
// }
