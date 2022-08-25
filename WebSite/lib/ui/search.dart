import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/filter.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:ondemand_admin/widgets/button202m.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import 'strings.dart';
import '../../theme.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    filterType = 1;
    initialFilter(_mainModel);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    if (_scrollPosition > _scrollController.position.maxScrollExtent/3){
      if (filterType == 3)
        articleSortGetNextPage(false);
      _redraw();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.  of(context).size.height;
    //print("redraw search");

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: isMobile() ?
        ListView(
              controller: _scrollController,
              children: [
                ..._getList()
              ]
        )
        : Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: windowWidth*0.7-20,
            child: ListView(
              controller: _scrollController,
                children: _getList())
          ),
          Container(
            width: windowWidth*0.3,
            margin: EdgeInsets.only(left: windowWidth*0.7),
            child: ListView(
              children: getBodyFilterDialog(_redraw, (){}, _mainModel),
            )
          ),
          // Expanded(flex: 2, child: ListView(children: _getList())),
          // SizedBox(width: 20,),
          // Expanded(child: Container(
          //   margin: EdgeInsets.all(20),
          //   child: getBodyFilterDialog(_redraw, (){}, _mainModel)),
          // )
        ],
    ));

  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    if (isMobile()){
      list.add(Row(
        children: [
          Text(strings.get(166), style: theme.style14W800,), /// "Search on ",
          SizedBox(width: 20,),
          button2x(strings.get(16), /// "Services",
                  (){
                filterType = 1;
                _mainModel.controllerSearch.text = serviceSearchText;
                applyFilter(_mainModel);
                _redraw();
              }, enable: true, color: filterType == 1 ? theme.mainColor : theme.mainColor.withAlpha(80)),
        ],
      ));
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Text(strings.get(167), style: theme.style14W800,), /// " or ",
          SizedBox(width: 20,),
          button2x(strings.get(2), /// "Providers",
                  (){
                filterType = 2;
                _mainModel.controllerSearch.text = providerSearchText;

                //   _controllerSearch.text = articleSearchText;
                applyFilter(_mainModel);
                _redraw();
              }, enable: true, color: filterType == 2 ? theme.mainColor : theme.mainColor.withAlpha(80)),
          SizedBox(width: 20,),
          Text(strings.get(167), style: theme.style14W800,), /// " or ",
          SizedBox(width: 20,),
          button2x(strings.get(193), /// "Products",
                  (){
                filterType = 3;
                initialFilter(_mainModel);
                _mainModel.controllerSearch.text = articleSearchText;
                applyFilter(_mainModel);
                _redraw();
              }, enable: true, color: filterType == 3 ? theme.mainColor : theme.mainColor.withAlpha(80)),
        ],
      ));

    }else
      list.add(Row(
        children: [
          Text(strings.get(166), style: theme.style14W800,), /// "Search on ",
          SizedBox(width: 20,),
          button2x(strings.get(16), /// "Services",
              (){
                filterType = 1;
                _mainModel.controllerSearch.text = serviceSearchText;
                applyFilter(_mainModel);
                _redraw();
              }, enable: true, color: filterType == 1 ? theme.mainColor : theme.mainColor.withAlpha(80)),
          SizedBox(width: 20,),
          Text(strings.get(167), style: theme.style14W800,), /// " or ",
          SizedBox(width: 20,),
          button2x(strings.get(2), /// "Providers",
              (){
                filterType = 2;
                _mainModel.controllerSearch.text = providerSearchText;

                //   _controllerSearch.text = articleSearchText;
                applyFilter(_mainModel);
                _redraw();
              }, enable: true, color: filterType == 2 ? theme.mainColor : theme.mainColor.withAlpha(80)),
          SizedBox(width: 20,),
          Text(strings.get(167), style: theme.style14W800,), /// " or ",
          SizedBox(width: 20,),
          button2x(strings.get(193), /// "Products",
                  (){
                filterType = 3;
                initialFilter(_mainModel);
                _mainModel.controllerSearch.text = articleSearchText;
                applyFilter(_mainModel);
                _redraw();
              }, enable: true, color: filterType == 3 ? theme.mainColor : theme.mainColor.withAlpha(80)),
        ],
      ));

    if (isMobile()) {
      list.add(SizedBox(height: 20,));
      list.addAll(getBodyFilterDialog(_redraw, () {}, _mainModel));
    }

    list.add(SizedBox(height: 20,));
    list.add(Divider());
    list.add(SizedBox(height: 20,));

    if (filterType == 1)
      _services(list);
    if (filterType == 2)
      _provider(list);
    if (filterType == 3)
      list.add(_products());

    list.add(SizedBox(height: 20,));

    return list;
  }

  _services(List<Widget> list){
    User? user = FirebaseAuth.instance.currentUser;

    for (var item in _mainModel.serviceSearch) {

      var _prov = getProviderById(item.providers.isNotEmpty ? item.providers[0] : "");
      _prov ??= ProviderData.createEmpty();

      var _tag = UniqueKey().toString();
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: InkWell(onTap: (){
        _mainModel.currentService = item;
        _mainModel.route("service");
      },
          borderRadius: BorderRadius.circular(aTheme.radius),
          child: Hero(
              tag: _tag,
              child: Container(
                  width: windowWidth,
                  child: Stack(
                    children: [
                      Card50(item: item,
                        direction: strings.direction,
                        locale: strings.locale,
                        category: categories,
                        color: Colors.blue.withAlpha(10),
                        providerData: _prov,),
                      if (user != null)
                        Container(
                          margin: EdgeInsets.all(6),
                          alignment: strings.direction == TextDirection.ltr ? Alignment.topRight : Alignment.topLeft,
                          child: IconButton(icon: userAccountData.userFavorites.contains(item.id)
                              ? Icon(Icons.favorite, size: 25,)
                              : Icon(Icons.favorite_border, size: 25,), color: Colors.orange,
                            onPressed: (){changeFavorites(item);}, ),
                        )
                    ],
                  )
              )))));
      list.add(SizedBox(height: 10,));
    }

    if (_mainModel.serviceSearch.isEmpty)
      _notFound(list);

    return list;
  }

  _provider(List<Widget> list){

    var _count = 0;
    if (providerSearchText.isNotEmpty)
      for (var item in providers) {
          if (!getTextByLocale(item.name, strings.locale).toUpperCase().contains(providerSearchText.toUpperCase()))
            continue;
        list.add(Container(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: button202m(item,
              200, _mainModel, (){
                _mainModel.currentProvider = item;
                _mainModel.route("provider");
              },))
        );
        list.add(SizedBox(height: 1,));
        _count++;
      }

    if (_count == 0)
      _notFound(list);

    list.add(SizedBox(height: 300,));

    return list;
  }

  _notFound(List<Widget> list){
    list.add(Center(child:
    Container(
        width: 400,
        height: 400,
        child: Image.asset("assets/nofound.png", fit: BoxFit.contain)
    ),
    ));
    list.add(SizedBox(height: 10,));
    list.add(Center(child: Text(strings.get(143), style: theme.style18W800Grey,),)); /// "Not found ...",
  }

  Widget _products(){
    List<Widget> list = [];
    List<Widget> list2 = [];

    for (var item in productDataCacheSort) {
      list2.add(button202n2(item, 200, strings.locale, strings.get(186), /// Not available Now
                () async {
              waitInMainWindow(true);
              var ret = await articleGetItemToEdit(item);
              waitInMainWindow(false);
              if (ret != null)
                return messageError(context, ret);
              route("article");
            })
      );
    }

    list.add(Container(
        margin: EdgeInsets.all(10),
        child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children: list2)
    ));

    if (productDataCacheSort.isEmpty)
      _notFound(list);

    list.add(SizedBox(height: 300,));

    return Column(
      children: list,
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }
  //
  // _filter(){
  //   double _min = _mainModel.filter.getMinPrice();
  //   double _max = _mainModel.filter.getMaxPrice();
  //   User? user = FirebaseAuth.instance.currentUser;
  //   return Container(
  //     padding: EdgeInsets.all(20),
  //     color: Colors.blue.withAlpha(20),
  //     child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Center(child: Text(strings.get(168), /// "Filter",
  //           textAlign: TextAlign.center, style: theme.style14W800)),
  //       SizedBox(height: 10,),
  //       Text(strings.get(169), /// "Sort by",
  //           textAlign: TextAlign.start, style: theme.style13W800),
  //       SizedBox(height: 5,),
  //       Row(
  //         children: [
  //           Expanded(child: button2x(strings.get(170), /// "Ascending (A-Z)",
  //               (){
  //                 _mainModel.ascDesc = 1;
  //                 _redraw();
  //               },
  //             style: _mainModel.ascDesc == 1 ? theme.style14W800W : theme.style14W800,
  //             color: _mainModel.ascDesc == 1 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20),
  //           )),
  //           SizedBox(width: 10,),
  //           Expanded(child: button2x(strings.get(171), /// "Descending (Z-A)",
  //               (){
  //                 _mainModel.ascDesc = 2;
  //                 _redraw();
  //               },
  //               style: _mainModel.ascDesc == 2 ? theme.style14W800W : theme.style14W800,
  //               color: _mainModel.ascDesc == 2 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20),
  //           )),
  //         ],
  //       ),
  //       SizedBox(height: 5,),
  //     if (user != null && _mainModel.searchOnService)
  //       Row(
  //         children: [
  //           Expanded(child: button2x(strings.get(172), /// "Nearby you",
  //               (){
  //                 _mainModel.ascDesc = 3;
  //                 _redraw();
  //               },
  //             style: _mainModel.ascDesc == 3 ? theme.style14W800W : theme.style14W800,
  //             color: _mainModel.ascDesc == 3 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20),
  //           )),
  //           SizedBox(width: 10,),
  //           Expanded(child: button2x(strings.get(173), /// "Far",
  //               (){
  //                 _mainModel.ascDesc = 4;
  //                 _redraw();
  //               },
  //             style: _mainModel.ascDesc == 4 ? theme.style14W800W : theme.style14W800,
  //             color: _mainModel.ascDesc == 4 ? theme.mainColor : theme.darkMode ? Colors.grey : Colors.grey.withAlpha(20),
  //           )),
  //         ],
  //       ),
  //       SizedBox(height: 10,),
  //     if (_mainModel.searchOnService)
  //       Text(strings.get(174), /// "Price",
  //           textAlign: TextAlign.start, style: theme.style13W800),
  //     if (_min != _max && _mainModel.searchOnService)
  //       SfRangeSlider(
  //         activeColor: theme.mainColor,
  //         inactiveColor: theme.mainColor.withAlpha(100),
  //         tickShape: SfTickShape(),
  //         min: _min,
  //         max: _max,
  //         enableTooltip: true,
  //         interval: (_max-_min)/4,
  //         showTicks: true,
  //         showDividers: true,
  //         enableIntervalSelection: true,
  //         showLabels: true,
  //         numberFormat: intl.NumberFormat("\$"),
  //         onChanged: (SfRangeValues newValue) {
  //           _mainModel.filterPrice = newValue;
  //           _redraw();
  //         },
  //         values: _mainModel.filterPrice,
  //       ),
  //       SizedBox(height: 40,),
  //       Row(
  //         children: [
  //           Expanded(child: button134(strings.get(175), (){ /// "Reset Filter",
  //             _mainModel.applyFilter = false;
  //             _mainModel.redraw();
  //           }, style: theme.style14W800)),
  //           SizedBox(width: 10,),
  //           Expanded(child: button2x(strings.get(176), /// "Apply Filter",
  //               (){
  //                 _mainModel.filter.applyFilter();
  //               }))
  //         ],
  //       ),
  //     ],
  //   ));
  // }


}
