import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';

import '../../ui/strings.dart';

button202m2(ProviderData item, MainModel _mainModel,
    double height,
    {bool favoriteEnable = true, Function()? callback}){

  String name = getTextByLocale(item.name, strings.locale);
  String address = item.address;
  String categories = getCategoryNames(item.category);
// int stars = 4 ; // item.
//   Color iconStarsColor = Colors.orangeAccent;
  Color color = theme.darkMode ? theme.blackColorTitleBkg : Colors.white;
  String image = item.logoServerPath.isNotEmpty ? item.logoServerPath : "";
  // bool favorite = _mainModel.userFavoritesProviders.contains(item.id);
  // Function(bool) setFavorite = (bool val){
  //   _mainModel.changeFavoritesProviders(item);
  //   _mainModel.redraw();
  // };
  // bool unavailable = false; //item.unavailable;
  // Function() _callback = (){
  //   currentSourceKeyProvider = item.key;
  //   _mainModel.currentProvider = item;
  //   route("provider");
  // };

  Function() _callback = (){};
  if (callback != null)
    _callback = callback;

  return Stack(
    children: <Widget>[

      Container(
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: color,
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
                      borderRadius: BorderRadius.all(Radius.circular(theme.radius)),
                      child: Stack(
                        children: [
                          image.isNotEmpty ? CachedNetworkImage(
                          imageUrl: image,
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
                          // if (unavailable)
                          //   Container(
                          //     height: height-20,
                          //     color: Colors.black.withAlpha(50),
                          //     child: Center(child: Text(strings.get(30), style: theme.style10W800White,
                          //       textAlign: TextAlign.center,)), /// Not available Now
                          //   )
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

                            Text(name, style: theme.style11W600, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 5,),
                            Text(address, style: theme.style12W400, textAlign: TextAlign.start, maxLines: 3, overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 5,),

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
                                Expanded(child: Text(categories, style: theme.style11W600Grey)),
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

      // if (favoriteEnable)
      // Positioned.fill(
      //     child: Container(
      //         alignment: Alignment.centerRight,
      //         child: Container(
      //           margin: EdgeInsets.all(8),
      //           child: InkWell(onTap: (){
      //             setFavorite(!favorite);
      //           },
      //             child: (favorite) ? Icon(Icons.favorite, size: 25, color: Colors.green,)
      //                 : Icon(Icons.favorite_border, size: 22, color: Colors.grey,),
      //           ),
      //         )))

    ],
  );
}
