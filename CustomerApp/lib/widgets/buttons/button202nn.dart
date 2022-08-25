import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';

import '../../ui/strings.dart';

button202N(ProductData item, MainModel _mainModel,
    double width, double height,
    Function _callback){

  var ratingColor = Colors.orangeAccent;

  return Stack(
    children: <Widget>[

      Container(
        margin: EdgeInsets.all(5),
          height: height,
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
                    height: height,
                    child: item.gallery.isNotEmpty ? CachedNetworkImage(
                        imageUrl: item.gallery[0].serverPath,
                        imageBuilder: (context, imageProvider) => Container(
                          child: Container(
                            width: height,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(getTextByLocale(item.name, strings.locale), style: theme.style12W800, textAlign: TextAlign.start,),

                    Row(children: [
                      if (item.rating >= 1)
                        Icon(Icons.star, color: ratingColor, size: 16,),
                      if (item.rating < 1)
                        Icon(Icons.star_border, color: ratingColor, size: 16,),
                      if (item.rating >= 2)
                        Icon(Icons.star, color: ratingColor, size: 16,),
                      if (item.rating < 2)
                        Icon(Icons.star_border, color: ratingColor, size: 16,),
                      if (item.rating >= 3)
                        Icon(Icons.star, color: ratingColor, size: 16,),
                      if (item.rating < 3)
                        Icon(Icons.star_border, color: ratingColor, size: 16,),
                      if (item.rating >= 4)
                        Icon(Icons.star, color: ratingColor, size: 16,),
                      if (item.rating < 4)
                        Icon(Icons.star_border, color: ratingColor, size: 16,),
                      if (item.rating >= 5)
                        Icon(Icons.star, color: ratingColor, size: 16,),
                      if (item.rating < 5)
                        Icon(Icons.star_border, color: ratingColor, size: 16,),
                    ]
                    ),

                    Row(children: [
                      if (item.providers.isNotEmpty)
                          Expanded(child: Text(getStringDistanceByProviderId(item.providers[0]),
                            style: theme.style10W600Grey, textAlign: TextAlign.start,)),
                          SizedBox(width: 10,),
                          Text(getPriceString(item.getMinPrice()),
                            style: theme.style16W800Orange,),
                        ],),
                  ],
                ),
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
