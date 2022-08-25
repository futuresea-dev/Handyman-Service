import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import '../theme.dart';
import '../ui/strings.dart';

serviceItem(double windowWidth, double windowHeight, MainModel _mainModel, ProductData item, User? user, {bool cat = true}){

  var _prov = getProviderById(item.providers.isNotEmpty ? item.providers[0] : "");
  _prov ??= ProviderData.createEmpty();

  bool available = _prov.available;

  return Container(
      width: windowWidth,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: InkWell(onTap: () {
        if (!available)
          return;
        _mainModel.currentService = item;
        _mainModel.route("service");
      },
        borderRadius: BorderRadius.circular(aTheme.radius),
          child: Stack(
            children: [
              Card50(item: item,
                categoryEnable: cat,
                direction: strings.direction,
                locale: strings.locale,
                category: categories,
                color: Colors.blue.withAlpha(10),
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
                      _mainModel.redraw();
                    },),
                ),
              if (!available)
                Positioned.fill(child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: BorderRadius.circular(aTheme.radius),
                  ),
                  child: Center(child: Text(strings.get(186),
                    style: theme.style10W800White, textAlign: TextAlign.center,)), /// Not available Now
                ))
            ],
          )
      ));
}