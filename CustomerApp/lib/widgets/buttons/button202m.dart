import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';

import '../../ui/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

button202m(ProviderData item,
    double height,
    MainModel _mainModel,
    Function() _redraw,
    Function() _callback, {bool unavailable = false, int stars = 5}){

  var text3 = getCategoryNames(item.category);
  User? user = FirebaseAuth.instance.currentUser;

  return Stack(
    children: <Widget>[

      Container(
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child:
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 20, top: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), bottomLeft: Radius.circular(theme.radius),
                          topRight: Radius.circular(theme.radius), bottomRight: Radius.circular(theme.radius)),
                      child: Stack(
                        children: [
                          item.logoServerPath.isNotEmpty ? CachedNetworkImage(
                          imageUrl: item.logoServerPath,
                          imageBuilder: (context, imageProvider) =>
                            Container(
                              height: height-20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                      ) : Container(),
                          if (unavailable)
                            Container(
                              height: height-20,
                              color: Colors.black.withAlpha(50),
                              child: Center(child: Text(strings.get(30), style: theme.style10W800White,
                                textAlign: TextAlign.center,)), /// Not available Now
                            )
                        ],
                      )
                  ),
                )),

              Expanded(
                  flex: 4,
                  child: Column(
                    children: [


                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(getTextByLocale(item.name, strings.locale), style: theme.style11W600, textAlign:
                            TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 5,),
                            Text(item.address, style: theme.style11W600Grey,
                              textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 5,),

                            // Colors.orangeAccent
                            // Row(children: [
                            //   if (stars >= 1)
                            //     Icon(Icons.star, color: iconStarsColor, size: 16,),
                            //   if (stars < 1)
                            //     Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            //   if (stars >= 2)
                            //     Icon(Icons.star, color: iconStarsColor, size: 16,),
                            //   if (stars < 2)
                            //     Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            //   if (stars >= 3)
                            //     Icon(Icons.star, color: iconStarsColor, size: 16,),
                            //   if (stars < 3)
                            //     Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            //   if (stars >= 4)
                            //     Icon(Icons.star, color: iconStarsColor, size: 16,),
                            //   if (stars < 4)
                            //     Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            //   if (stars >= 5)
                            //     Icon(Icons.star, color: iconStarsColor, size: 16,),
                            //   if (stars < 5)
                            //     Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                            //   Text(stars.toString(), ),
                            // ]
                            // ),

                            SizedBox(height: 5,),

                            Row(
                              children: [
                                Expanded(child: Text(text3, style: theme.style11W600Grey,)),
                                SizedBox(width: 5,),



                              ],
                            ),


                          ],
                        ),
                      ),
                    ],
                  )),


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
      ),

      if (user != null)
      Positioned.fill(
          child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.all(8),
                child: InkWell(onTap: (){
                  changeFavoritesProviders(item);
                  _redraw();
                },
                  child: userAccountData.userFavoritesProviders.contains(item.id)
                      ? Icon(Icons.favorite, size: 25, color: Colors.green,)
                      : Icon(Icons.favorite_border, size: 22, color: Colors.grey,),
                ),
              )))

    ],
  );
}
