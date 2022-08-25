import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/filter.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'package:ondemand_admin/ui/strings.dart';

Widget articleHorizontalBar(String providerId, double windowWidth, BuildContext context,
    MainModel _mainModel, ScrollController scrollController){
  List<Widget> list = [];
  list.add(SizedBox(width: 10,));

  List<ProductDataCache> _products = getProductsByProvider(providerId);
  var _providerImage = getProviderImageById(providerId);

  int _count = 0;
  for (var item in _products){
    list.add(button202n2(item, 200, strings.locale, strings.get(186), /// Not available Now
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
    list.add(button202n2Count(200, _providerImage,
        strings.get(188),  /// See more
        _products.length.toString(),
            () async {
          articleSortByProvider = providerId;
          filterType = 3;
          filterIsFindInEmpty = true;
          initialFilter(_mainModel);
          filterIsFindInEmpty = false;
          filterShowProviderInFilter = false;
          setPriceRangeForArticle(_mainModel);
          _mainModel.route("products");
        }));
    list.add(SizedBox(width: 10,));
    }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child:
        Row(
          children: list,
        ),
      ),
    ],
  );


  //   Container(
  //   height: 220,
  //   child: ListView(
  //     scrollDirection: Axis.horizontal,
  //     children: list,
  //   ),
  // );
}

