import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/ui/theme.dart';

button202N(String text,
    String image, double width,
    Function _callback){
  return Stack(
    children: <Widget>[

      Container(
        margin: EdgeInsets.all(10),
          width: width,
          decoration: BoxDecoration(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), topRight: Radius.circular(theme.radius)),
                child: Container(
                  width: width,
                    child: image.isNotEmpty ? CachedNetworkImage(
                        imageUrl: image,
                        imageBuilder: (context, imageProvider) => Container(
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        )
                    ) : Container(),

                ),
              )),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                child: Text(text, style: theme.style13W800, textAlign: TextAlign.start,),
              ),

            ],
          )
      ),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(theme.radius)),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )

    ],
  );
}
