import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/ui/strings.dart';
import 'package:ondemandservice/ui/theme.dart';

class Card41 extends StatelessWidget {
  final String image;
  final String text1;
  final String text2;
  final TextStyle style2;
  final String text3;
  final TextStyle style3;
  final bool shadow;
  final double imageRadius;
  final double padding;
  final int all;
  final int unread;
  final bool blocked;

  const Card41({Key? key, required this.image, required this.text1, required this.text2, required this.style2,
    required this.text3, required this.style3, this.shadow = false, this.imageRadius = 50,
    this.padding = 5, this.all = 0, this.unread = 0, this.blocked = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: (theme.darkMode) ? Colors.black : Colors.white,
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
                              Expanded(child: Text(text1, style: theme.style14W800, maxLines: 1, overflow: TextOverflow.ellipsis,)),
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
                              Expanded(child: Text(text2, style: style2, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              SizedBox(width: 10,),
                              Text(text3, style: style3,),
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
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  UnconstrainedBox(child:
                                  Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(backgroundColor: Colors.black, ),
                                  )),
                              imageUrl: image,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              errorWidget: (context,url,error) => Icon(Icons.error),
                            ),
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

            )),

        if (blocked)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
                borderRadius: BorderRadius.circular(theme.radius),
              ),
              child: Center(
                child: Text(strings.get(247), style: theme.style16W800White,), /// Blocked
              )
            )
          )
      ],
    );
  }
}
