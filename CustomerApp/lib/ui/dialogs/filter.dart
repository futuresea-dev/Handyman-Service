import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../strings.dart';

int filterType = 1; // 1 service - 2 provider - 3 article
bool filterIsFindInEmpty = false;
// service
String serviceSearchText = "";
int ascDescService = 0;
SfRangeValues _priceService = SfRangeValues(-1.0, 0.0);
SfRangeValues _priceServiceSource = SfRangeValues(-1.0, 0.0);
String filterServiceProvider = "not_select";
// provider
String providerSearchText = "";
int ascDescProvider = 0;
// article in abg_utils
SfRangeValues _priceArticle = SfRangeValues(-1.0, 0.0);
SfRangeValues _priceArticleSource = SfRangeValues(-1.0, 0.0);
bool filterShowProviderInFilter = true;

_resetFilter(MainModel _mainModel){
  if (filterType == 1) { // service
    ascDescService = 0;
    filterServiceProvider = "not_select";
    setPriceRangeForService(_mainModel);
    applyFilter(_mainModel);
  }
  if (filterType == 2) { // provider
    ascDescProvider = 0;
    applyFilter(_mainModel);
  }
  if (filterType == 3) { // article
    articleSortByProvider = "not_select";
    articleAscDesc = 0;
    setPriceRangeForArticle(_mainModel);
    applyFilter(_mainModel);
  }
}

initialFilter(MainModel _mainModel){
  if (filterType == 1){ // service
    if (_priceServiceSource.start == -1 && _priceServiceSource.end == 0)
      setPriceRangeForService(_mainModel);
    providerComboBoxValue = filterServiceProvider;
  }
  if (filterType == 3){ // article
    if (_priceArticleSource.start == -1 && _priceArticleSource.end == 0)
      setPriceRangeForArticle(_mainModel);
    providerComboBoxValue = articleSortByProvider;
    filterShowProviderInFilter = true;
  }
  applyFilter(_mainModel);
}

setPriceRangeForService(MainModel _mainModel){
  _priceService = SfRangeValues(filterGetMinPrice(product), filterGetMaxPrice(product));
  _priceServiceSource = SfRangeValues(filterGetMinPrice(product), filterGetMaxPrice(product));
}

setPriceRangeForArticle(MainModel _mainModel){
  var _min = articlesGetMinPrice();
  var _max = articlesGetMaxPrice();
  articleMinPrice = _min;
  articleMaxPrice = _max;
  _priceArticle = SfRangeValues(_min, _max);
  _priceArticleSource = SfRangeValues(_min, _max);
}

double getFilterMinPrice(){
  return _priceService.start;
}

double getFilterMaxPrice(){
  return _priceService.end;
}

bool isFilterPriceServiceModify(){
  if (_priceServiceSource.start == _priceService.start && _priceServiceSource.end == _priceService.end)
    return false;
  return true;
}

bool isFilterPriceArticleModify(){
  if (_priceArticleSource.start == _priceArticle.start && _priceArticleSource.end == _priceArticle.end)
    return false;
  return true;
}

String getFilterServicePriceString(){
  return "${getPriceString(_priceService.start)} - ${getPriceString(_priceService.end)}";
}

String getFilterArticlePriceString(){
  return "${getPriceString(_priceArticle.start)} - ${getPriceString(_priceArticle.end)}";
}

getBodyFilterDialog(Function() _redraw, Function() _close, MainModel _mainModel){
  double _min = filterGetMinPrice(product);
  double _max = filterGetMaxPrice(product);
  if (filterType == 3) { // article
    _min = articlesGetMinPrice();
    _max = articlesGetMaxPrice();
  }

  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text(strings.get(181), /// "Filter",
            textAlign: TextAlign.center, style: theme.style14W800)),
        SizedBox(height: 10,),
        Text(strings.get(182), /// "Sort by",
            textAlign: TextAlign.start, style: theme.style13W800),
        SizedBox(height: 5,),

        if (filterType == 1)
          _ascDescServiceItems(_redraw),
        if (filterType == 2)
          _ascDescProviderItems(_redraw),
        if (filterType == 3)
          _ascDescArticleItems(_redraw),

        if (filterType != 2 && filterShowProviderInFilter)
        Row(
          children: [
            Text(strings.get(280), style: theme.style14W800,), /// Sort by provider
            Expanded(child: comboBoxProvider(
                strings.get(281), /// "Not select"
                (String value){
                  if (filterType == 1)
                    filterServiceProvider = value;
                  if (filterType == 3)
                    articleSortByProvider = value;
                    //articleSort();
                  _redraw();
                }
            ))
          ],
        ),
        SizedBox(height: 10,),
        if (filterType != 2)
        Text(strings.get(185), /// "Price",
            textAlign: TextAlign.start, style: theme.style13W800),
        if (filterType != 2)
        SfRangeSlider(
          activeColor: theme.mainColor,
          inactiveColor: theme.mainColor.withAlpha(100),
          tickShape: SfTickShape(),
          min: _min,
          max: _max,
          enableTooltip: true,
          interval: (_max-_min)/4,
          showTicks: true,
          showDividers: true,
          enableIntervalSelection: true,
          showLabels: true,
          numberFormat: NumberFormat(appSettings.symbol),
          onChanged: (SfRangeValues newValue) {
            if (filterType == 1)
              _priceService = newValue;
            if (filterType == 3)
              _priceArticle = newValue;
            _redraw();
          },
          values: filterType == 1 ? _priceService : _priceArticle,
        ),
        SizedBox(height: 40,),
        Row(
          children: [
            Expanded(child: button134(strings.get(186), (){ /// "Reset Filter",
              _resetFilter(_mainModel);
              _close();
              redrawMainWindow();
            }, style: theme.style14W800)),
            SizedBox(width: 10,),
            Expanded(child: button2(strings.get(187), /// "Apply Filter",
                  theme.mainColor, (){
                    applyFilter(_mainModel);
                    _close();
              }))
          ],
        ),
      ],
    );
}

_ascDescServiceItems(Function() _redraw){
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: button2(strings.get(183), /// "Ascending (A-Z)",
            ascDescService == 1 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              ascDescService = 1;
              _redraw();
            }, style: ascDescService == 1 ? theme.style14W800W : theme.style14W800,
          )),
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(184), /// "Descending (Z-A)",
            ascDescService == 2 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              ascDescService = 2;
              _redraw();
            },
            style: ascDescService == 2 ? theme.style14W800W : theme.style14W800,
          )),
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          Expanded(child: button2(strings.get(222), /// "Nearby you",
            ascDescService == 3 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              ascDescService = 3;
              _redraw();
            },
            style: ascDescService == 3 ? theme.style14W800W : theme.style14W800,
          )),
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(223), /// "Far",
            ascDescService == 4 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              ascDescService = 4;
              _redraw();
            },
            style: ascDescService == 4 ? theme.style14W800W : theme.style14W800,
          )),
        ],
      ),
      SizedBox(height: 10,),
    ],
  );
}

_ascDescProviderItems(Function() _redraw){
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: button2(strings.get(183), /// "Ascending (A-Z)",
            ascDescProvider == 1 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              ascDescProvider = 1;
              _redraw();
            },
            style: ascDescProvider == 1 ? theme.style14W800W : theme.style14W800,
          )),
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(184), /// "Descending (Z-A)",
            ascDescProvider == 2 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              ascDescProvider = 2;
              _redraw();
            },
            style: ascDescProvider == 2 ? theme.style14W800W : theme.style14W800,
          )),
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          Expanded(child: button2(strings.get(222), /// "Nearby you",
            ascDescProvider == 3 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              ascDescProvider = 3;
              _redraw();
            },
            style: ascDescProvider == 3 ? theme.style14W800W : theme.style14W800,
          )),
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(223), /// "Far",
            ascDescProvider == 4 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              ascDescProvider = 4;
              _redraw();
            },
            style: ascDescProvider == 4 ? theme.style14W800W : theme.style14W800,
          )),
        ],
      ),
      SizedBox(height: 10,),
    ],
  );
}

_ascDescArticleItems(Function() _redraw){
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: button2(strings.get(183), /// "Ascending (A-Z)",
            articleAscDesc == 1 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              articleAscDesc = 1;
              _redraw();
            },
            style: articleAscDesc == 1 ? theme.style14W800W : theme.style14W800,
          )),
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(184), /// "Descending (Z-A)",
            articleAscDesc == 2 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              articleAscDesc = 2;
              _redraw();
            },
            style: articleAscDesc == 2 ? theme.style14W800W : theme.style14W800,
          )),
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          Expanded(child: button2(strings.get(222), /// "Nearby you",
            articleAscDesc == 3 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              articleAscDesc = 3;
              _redraw();
            },
            style: articleAscDesc == 3 ? theme.style14W800W : theme.style14W800,
          )),
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(223), /// "Far",
            articleAscDesc == 4 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20), (){
              articleAscDesc = 4;
              _redraw();
            },
            style: articleAscDesc == 4 ? theme.style14W800W : theme.style14W800,
          )),
        ],
      ),
      SizedBox(height: 10,),
    ],
  );
}

applyFilter(MainModel _mainModel){
  if (filterType == 1){ // service
    _mainModel.serviceSearch = [];
    if (serviceSearchText.isEmpty)
      return;
    for (var item in product){
      if (!getTextByLocale(item.name, strings.locale).toUpperCase().contains(serviceSearchText.toUpperCase()))
        continue;
      if (item.providers.isNotEmpty && filterServiceProvider != "not_select")
        if (item.providers[0] != filterServiceProvider)
          continue;
      if (getFilterMinPrice() > getMinAmountInProduct(item.price))
        continue;
      if (getFilterMaxPrice() < getMaxAmountInProduct(item.price))
        continue;
      _mainModel.serviceSearch.add(item);
    }
    if (ascDescService == 1)
      _mainModel.serviceSearch.sort((a, b) => getTextByLocale(a.name, strings.locale).compareTo(getTextByLocale(b.name, strings.locale)));
    if (ascDescService == 2)
      _mainModel.serviceSearch.sort((a, b) => getTextByLocale(b.name, strings.locale).compareTo(getTextByLocale(a.name, strings.locale)));
    if (ascDescService == 3)
      _mainModel.serviceSearch.sort((a, b) => getDistanceByProviderId(a.providers.isNotEmpty ? a.providers[0] : "")
          .compareTo(getDistanceByProviderId(b.providers.isNotEmpty ? b.providers[0] : "")));
    if (ascDescService == 4)
      _mainModel.serviceSearch.sort((a, b) => getDistanceByProviderId(b.providers.isNotEmpty ? b.providers[0] : "")
          .compareTo(getDistanceByProviderId(a.providers.isNotEmpty ? a.providers[0] : "")));
  }
  if (filterType == 2) { // provider
    if (ascDescProvider == 1)
      providers.sort((a, b) => getTextByLocale(a.name, strings.locale).compareTo(getTextByLocale(b.name, strings.locale)));
    if (ascDescProvider == 2)
      providers.sort((a, b) => getTextByLocale(b.name, strings.locale).compareTo(getTextByLocale(a.name, strings.locale)));
    if (ascDescProvider == 3)
      providers.sort((a, b) => getDistanceByProviderId(a.id).compareTo(getDistanceByProviderId(b.id)));
    if (ascDescProvider == 4)
      providers.sort((a, b) => getDistanceByProviderId(b.id).compareTo(getDistanceByProviderId(a.id)));
  }
  if (filterType == 3) { // article
    if (_priceArticle.start == -1 && _priceArticle.end == 0)
      setPriceRangeForArticle(_mainModel);
    articleMinPrice = _priceArticle.start;
    articleMaxPrice = _priceArticle.end;
    articleSort(isFindInEmpty: filterIsFindInEmpty);
  }
}

