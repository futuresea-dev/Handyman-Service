import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/dialogs/filter.dart';
import 'package:ondemandservice/ui/strings.dart';

Widget articleHorizontalBar(String providerId, double windowWidth, BuildContext context,
    MainModel _mainModel){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));

  List<ProductDataCache> _products = getProductsByProvider(providerId);
  var _providerImage = getProviderImageById(providerId);

  int _count = 0;
  for (var item in _products){
    list.add(button202n2(item, windowWidth*0.33, strings.locale, strings.get(262), /// Not available Now
            () async {
              waitInMainWindow(true);
              var ret = await articleGetItemToEdit(item);
              waitInMainWindow(false);
              if (ret != null)
                return messageError(context, ret);
              route("article");
        }));
    list.add(SizedBox(width: 10,));
    _count++;
    if (_count == 8)
      break;
  }
  if (_count == 0)
    return Container();
  if (_count != _products.length){
    list.add(button202n2Count(windowWidth*0.33, _providerImage,
        strings.get(277),  /// See more
        _products.length.toString(),
            () async {
          articleSortByProvider = providerId;
          filterType = 3;
          filterIsFindInEmpty = true;
          initialFilter(_mainModel);
          filterShowProviderInFilter = false;
          setPriceRangeForArticle(_mainModel);
          route("products");
        }));
    list.add(SizedBox(width: 10,));
    }

  return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list,
        )
      )
    ]
  );
}

