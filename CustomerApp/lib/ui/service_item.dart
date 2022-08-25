import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/strings.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

serviceItem(ProductData item, MainModel _mainModel, double windowWidth){

  User? user = FirebaseAuth.instance.currentUser;

  var _prov = getProviderById(item.providers.isNotEmpty ? item.providers[0] : "");
  _prov ??= ProviderData.createEmpty();

  bool available = _prov.available;

  return InkWell(onTap: () {
          if (available) {
            _mainModel.currentService = item;
            route("service");
          }
      },
      child: Container(
              width: windowWidth,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Stack(
                children: [
                  Card50(item: item,
                    locale: strings.locale,
                    direction: strings.direction,
                    category: categories,
                    providerData: _prov,
                  ),
                  if (user != null)
                    Container(
                      margin: EdgeInsets.all(6),
                      alignment: strings.direction == TextDirection.ltr
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: IconButton(
                        icon: userAccountData.userFavorites.contains(item.id)
                            ? Icon(Icons.favorite, size: 25,)
                            : Icon(Icons.favorite_border, size: 25,),
                        color: Colors.orange,
                        onPressed: () {
                          changeFavorites(item);
                        },),
                    ),
                  if (!available)
                    Positioned.fill(child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(aTheme.radius),
                      ),
                      child: Center(child: Text(strings.get(259),
                        style: theme.style10W800White, textAlign: TextAlign.center,)), /// Not available Now
                    ))
                ],
              )
          )
  );
}