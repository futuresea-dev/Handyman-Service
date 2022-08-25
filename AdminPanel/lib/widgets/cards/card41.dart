import 'package:flutter/material.dart';

import '../../ui/theme.dart';

class Card41 extends StatelessWidget {
  final String image;
  final String name;
  final String email;
  final String lastMessage;
  final String lastMessageTime;
  final bool shadow;
  final Color bkgColor;
  final double imageRadius;
  final double padding;
  final int all;
  final int unread;

  const Card41({Key? key, required this.image, required this.name, required this.lastMessage,
    required this.lastMessageTime, this.shadow = false, this.bkgColor = Colors.white, this.imageRadius = 50,
    this.padding = 5, this.all = 0, this.unread = 0, this.email = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: bkgColor,
          borderRadius: BorderRadius.circular(theme.radius),
          boxShadow: (shadow) ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ] : null,
        ),
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Row(children: [
                            Text(name, style: theme.style14W800, maxLines: 1, overflow: TextOverflow.ellipsis,),
                            SizedBox(width: 6,),
                            Expanded(child: Text(email, style: theme.style12W600Grey, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                          ],
                          )),
                          SizedBox(width: 10,),
                          if (unread != 0)
                            Container(
                                alignment: Alignment.topRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                      padding: EdgeInsets.all(4),
                                      child: Text(unread.toString(), style: theme.style12W600White,)
                                  ),
                                )),
                          SizedBox(width: 5,),
                          if (all != 0)
                            Container(
                                alignment: Alignment.topRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                      padding: EdgeInsets.all(4),
                                      child: Text(all.toString(), style: theme.style12W600White,)
                                  ),
                                )),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(child: Text(lastMessage, style: theme.style12W600Grey, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                          SizedBox(width: 10,),
                          Expanded(child: Text(lastMessageTime, style: theme.style12W600Grey,)),
                        ],
                      ),
                      SizedBox(height: 5,),
                    ],)),
              SizedBox(width: 20,),
              if (image.isNotEmpty)
                Container(
                  height: 45,
                  width: 45,
                  //padding: EdgeInsets.only(left: 10, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(imageRadius),
                    child:

                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Container(
                        child: Image.network(image, fit: BoxFit.cover,),
                      ),
                    ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         image: //AssetImage(image),
                    //         fit: BoxFit.cover
                    //     ),
                    //   ),
                    // )
                  ),
                ),
              SizedBox(width: 10,),
            ],
          ),

        ));
  }
}
