import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/service_item.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'package:ondemandservice/widgets/buttons/button202m.dart';
import 'package:provider/provider.dart';
import 'strings.dart';
import 'dialogs/filter.dart';

int _lastTabIndex = 0;

class SearchScreen extends StatefulWidget {
  final Function() jump;
  final Function() close;

  const SearchScreen({Key? key, required this.jump, required this.close,}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  late TabController _tabController;
  final FocusNode _focusNode = FocusNode();
  final _controllerSearch = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    filterIsFindInEmpty = false;
    filterShowProviderInFilter = true;
    filterType = 1;
    _controllerSearch.text = serviceSearchText;
    initialFilter(_mainModel);
    _focusNode.requestFocus();
    _tabController = TabController(vsync: this, length: 3, initialIndex: _lastTabIndex);
    _tabController.addListener(() {
      if (_tabController.index+1 == 1) {
        _controllerSearch.text = serviceSearchText;
        filterType = 1;
      }
      if (_tabController.index+1 == 2) {
        _controllerSearch.text = providerSearchText;
        filterType = 2;
      }
      if (_tabController.index+1 == 3) {
        _controllerSearch.text = articleSearchText;
        filterType = 3;
      }
      _redraw();
      _lastTabIndex = _tabController.index;
    });
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    if (_scrollPosition > _scrollController.position.maxScrollExtent/3){
      if (_tabController.index+1 == 3)
        articleSortGetNextPage(false);
      _redraw();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controllerSearch.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          height: windowHeight,
          child: ListView(
            padding: EdgeInsets.only(top: 0),
            children: _searchWidgets(),
          ),
        ),
        appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
            "", context, () {
              widget.close();
            }),
      ],
    );
  }

  _searchWidgets(){
    List<Widget> list = [];

    list.add(Container(
      color: theme.darkMode ? Colors.black : Colors.white,
      height: MediaQuery.of(context).padding.top+50,
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10, left: 50, right: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.get(122), /// "Search",
                style: theme.style16W800,),
              SizedBox(height: 3,),
              Text(strings.get(94), // Find what you need
                  style: theme.style10W600Grey),
            ],
      ),
      ))
    );

    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Expanded(child: Edit26(
            onSuffixIconPress: widget.close,
            suffixIcon: Icons.cancel,
            focusNode: _focusNode,
            decor: decor,
            hint: strings.get(122), /// "Search",
            color: (theme.darkMode) ? Colors.black : Colors.white,
            style: theme.style14W400,
            useAlpha: false,
            icon: Icons.search,
            controller: _controllerSearch,
            onChangeText: (String val){
              if (_tabController.index+1 == 1){ // service
                serviceSearchText = val;
                applyFilter(_mainModel);
              }
              if (_tabController.index+1 == 2){ // provider
                providerSearchText = val;
                applyFilter(_mainModel);
              }
              if (_tabController.index+1 == 3) { // article
                articleSearchText = val;
                applyFilter(_mainModel);
              }
              _redraw();
            },
          )),
          IconButton(onPressed: (){
            filterType = _tabController.index+1;
            initialFilter(_mainModel);
            _mainModel.openDialog("filter");
          }, icon: Icon(Icons.filter_alt, color: theme.mainColor,))
        ],
      ))
    );
    list.add(SizedBox(height: 10,));
    filterParameters(_tabController.index+1, list, _redraw, _mainModel);
    list.add(SizedBox(height: 10,));

    list.add(TabBar(
      indicatorColor: theme.mainColor,
      labelColor: Colors.black,
      tabs: [
        Text(strings.get(177),     /// "Service",
            textAlign: TextAlign.center,
            style: theme.style12W600Grey
        ),
        Text(strings.get(155),     /// "Provider",
            textAlign: TextAlign.center,
            style: theme.style12W600Grey
        ),
        Text(strings.get(278),     /// "Products",
            textAlign: TextAlign.center,
            style: theme.style12W600Grey
        ),
        // Text(strings.get(174),     // "Blog",
        //     textAlign: TextAlign.center,
        //     style: theme.style12W600Grey
        // ),
      ],
      controller: _tabController,
    ),
    );

    list.add(SizedBox(height: 10,));

    list.add(Container(
        height: windowHeight,
        child: TabBarView(
      controller: _tabController,
      children: <Widget>[

        ListView(
          padding: EdgeInsets.only(top: 10),
          children: _getServices(),
        ),

        ListView(
          padding: EdgeInsets.only(top: 10),
          children: _getProviders(),
        ),

        ListView(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 10),
          children: _getProducts(),
        ),
      ],
    )));

    return list;
  }

  _getServices(){
    List<Widget> list = [];

    for (var item in _mainModel.serviceSearch) {
      list.add(serviceItem(item, _mainModel, windowWidth));
      list.add(SizedBox(height: 10,));
    }

    if (_mainModel.serviceSearch.isEmpty){
      list.add(Center(child:
      Container(
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.bookingNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.bookingNotFoundImage,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            )
        ),
      ),
      ));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 300,));

    return list;
  }

  _getProviders(){
    List<Widget> list = [];

    if (providerSearchText.isNotEmpty){
      for (var item in providers) {
        if (!getTextByLocale(item.name, strings.locale).toUpperCase().contains(providerSearchText.toUpperCase()))
          continue;
        list.add(Container(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: button202m(item,
              windowWidth*0.26, _mainModel, _redraw, (){
                _mainModel.currentProvider = item;
                route("provider");
              },))
        );
        list.add(SizedBox(height: 1,));
      }
    }

    if (list.isEmpty){
      list.add(Center(child:
      Container(
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.bookingNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.bookingNotFoundImage,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            )
        ),
      ),
      ));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 300,));

    return list;
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _getProducts(){
    List<Widget> list = [];
    List<Widget> list2 = [];

    for (var item in productDataCacheSort) {
      list2.add(button202n2(item, windowWidth*0.3, strings.locale, strings.get(262), /// Not available Now
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
            spacing: 5,
            children: list2)
    ));

    if (productDataCacheSort.isEmpty){
      list.add(Center(child:
      Container(
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.bookingNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.bookingNotFoundImage,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            )
        ),
      ),
      ));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 300,));

    return list;
  }


}

filterParameters(int type, List<Widget> list, Function() _redraw, MainModel _mainModel){
  if (type == 1){ // service
    if (ascDescService == 1 || ascDescService == 2)
      list.add(filterItem(strings.get(182), /// "Sort by",
          ascDescService == 1 ? strings.get(183) : strings.get(184),  /// "Ascending (A-Z)", "Descending (Z-A)",
              (){
            ascDescService = 0;
            applyFilter(_mainModel);
            _redraw();
          }
      ));
    if (ascDescService == 3 || ascDescService == 4)
      list.add(filterItem(strings.get(182), /// "Sort by",
          ascDescService == 3 ? strings.get(222) : strings.get(223),  /// "Nearby you", "Far",
              (){
                ascDescService = 0;
            applyFilter(_mainModel);
            _redraw();
          }
      ));
    if (filterServiceProvider != "not_select")
      list.add(filterItem(strings.get(155), /// "Provider",
          getProviderNameById(filterServiceProvider, locale),
              (){
            filterServiceProvider = "not_select";
            applyFilter(_mainModel);
            _redraw();
          }
      ));
    if (isFilterPriceServiceModify())
      list.add(filterItem(strings.get(185), /// "Price",
          getFilterServicePriceString(),
              (){
            setPriceRangeForService(_mainModel);
            applyFilter(_mainModel);
            _redraw();
          }
      ));
  }
  if (type == 2) { // provider
    if (ascDescProvider == 1 || ascDescProvider == 2)
      list.add(filterItem(strings.get(182), /// "Sort by",
          ascDescProvider == 1 ? strings.get(183) : strings.get(184),  /// "Ascending (A-Z)", "Descending (Z-A)",
              (){
            ascDescProvider = 0;
            applyFilter(_mainModel);
            _redraw();
          }
      ));
    if (ascDescProvider == 3 || ascDescProvider == 4)
      list.add(filterItem(strings.get(182), /// "Sort by",
          ascDescProvider == 3 ? strings.get(222) : strings.get(223),  /// "Nearby you", "Far",
              (){
            ascDescProvider = 0;
            applyFilter(_mainModel);
            _redraw();
          }
      ));
  }
  if (type == 3) { // article
    if (articleAscDesc == 1 || articleAscDesc == 2)
      list.add(filterItem(strings.get(182), /// "Sort by",
          articleAscDesc == 1 ? strings.get(183) : strings.get(184),  /// "Ascending (A-Z)", "Descending (Z-A)",
              (){
            articleAscDesc = 0;
            applyFilter(_mainModel);
            _redraw();
          }
      ));
    if (articleAscDesc == 3 || articleAscDesc == 4)
      list.add(filterItem(strings.get(182), /// "Sort by",
          articleAscDesc == 3 ? strings.get(222) : strings.get(223),  /// "Nearby you", "Far",
              (){
            articleAscDesc = 0;
            applyFilter(_mainModel);
            _redraw();
          }
      ));
    if (articleSortByProvider != "not_select")
      list.add(filterItem(strings.get(155), /// "Provider",
          getProviderNameById(articleSortByProvider, locale),
              (){
            articleSortByProvider = "not_select";
            applyFilter(_mainModel);
            _redraw();
          }
      ));
    if (isFilterPriceArticleModify())
      list.add(filterItem(strings.get(185), /// "Price",
          getFilterArticlePriceString(),
              (){
            setPriceRangeForArticle(_mainModel);
            applyFilter(_mainModel);
            _redraw();
          }
      ));

  }
}

Widget filterItem(String text2, String text, Function() callback){
  return Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    child: Row(
      children: [
        Text(text2 + ":", style: theme.style12W600Red,),
        SizedBox(width: 6,),
        Expanded(child: Text(text, style: theme.style14W800,)),
        SizedBox(width: 6,),
        SizedBox(height: 30, child: IconButton(onPressed: (){
          callback();
        }, icon: Icon(Icons.cancel, color: Colors.red,)
        )),
      ],
    ),
  );
}