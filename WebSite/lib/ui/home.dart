import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/filter.dart';
import 'package:ondemand_admin/ui/main.dart';
import 'package:ondemand_admin/widgets/provider_item.dart';
import 'package:ondemand_admin/widgets/service_item.dart';
import 'package:ondemand_admin/widgets/shimmer.dart';
import 'package:provider/provider.dart';
import '../mainModel/model.dart';
import 'article.dart';
import 'strings.dart';
import '../theme.dart';
import 'bottom.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  double windowWidth = 0;
  double windowHeight = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _animationController = AnimationController(duration: Duration(seconds: 1), vsync: this)..repeat();
    _animation =
        Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(curve: Curves.easeInOutSine, parent: _animationController));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return
      Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top : 0),
            child: ListView(
              children: _getList(),
            ),)
      ],
    );
  }

  _getList() {
    List<Widget> list = [];

    User? user = FirebaseAuth.instance.currentUser;

    //
    // banner
    //
    if (banners.isNotEmpty)
      list.add(Container(
          color: Colors.grey.withAlpha(30),
          padding: EdgeInsets.only(top: 30, bottom: 30),
          //padding: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1, top: 30, bottom: 30),
          child: IBanner(
            banners,
            width: windowWidth, //isMobile() ? windowWidth : windowWidth*0.5,
            height: isMobile() ? windowWidth*0.35 : windowWidth * 0.5*0.35,
            colorActive: theme.mainColor,
            colorProgressBar: theme.mainColor,
            radius: theme.radius,
            shadow: 0,
            style: theme.style16W400,
            callback: _openBanner,
            seconds: 3,
          )));
    list.add(SizedBox(height: 10,));

    //
    // Category
    //
    list.add(SizedBox(height: 20,));
    list.add(Container(
      margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
      child: Text(strings.get(20),
        style: theme.style18W800,),));  /// "Category",
    list.add(SizedBox(height: 20,));

    if (categories.isEmpty){
      if (!_mainModel.initComplete) {
        list.add(rowCategory(windowWidth, _animation));
        list.add(SizedBox(height: 20,));
        list.add(rowCategory(windowWidth, _animation));
      }
    } else{
      List<Widget> listCat = [];
      for (var item in categories) {
        if (item.parent.isNotEmpty)
          continue;
        listCat.add(button157(
            getTextByLocale(item.name, strings.locale),
            item.color,
            item.serverPath, () {
          _mainModel.currentCategory = item;
          _mainModel.route("category");
        }, isMobile() ? windowWidth* 0.8/2-10 : windowWidth * 0.8 /5-10,
            isMobile() ? windowWidth* 0.8/2*0.5 : windowWidth * 0.8 /5 * 0.5
        ));
      }

      list.add(Container(
        margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: listCat,
        )));
      }
    list.add(SizedBox(height: 20,));

    //
    // Top Services
    //
    if (appSettings.inMainScreenServices.isNotEmpty) {
      list.add(SizedBox(height: 20,));
      list.add(Container(
        margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
        child: Text(strings.get(18), style: theme.style18W800,),));  /// "Top Services",
      list.add(SizedBox(height: 20,));

      List<Widget> list3 = [];
      for (var item in product) {
        if (!appSettings.inMainScreenServices.contains(item.id))
          continue;
        var _width = isMobile() ? windowWidth*0.9 : windowWidth*0.4-40;
        list3.add(serviceItem(_width, -1, _mainModel, item, user));
      }
      list.add(Container(
          margin: isMobile() ? EdgeInsets.only(left: 10, right: 10)
              : EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
          child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: list3,
      )));
      list.add(SizedBox(height: 20,));
    } else{
      if (!_mainModel.initComplete) {
        list.add(rowTopService(windowWidth, _animation));
        list.add(SizedBox(height: 20,));
        list.add(rowTopService(windowWidth, _animation));
      }
    }

    //
    // Providers
    //
    var t = _addProviders();
    if (t != null){
      list.add(Container(
          margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
          child: Row(
            children: [
              Expanded(child: Text(strings.get(2), style: theme.style18W800,)), /// "Providers",
              InkWell(
                  onTap: () {
                    _mainModel.route("providers_all");
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(strings.get(1), style: theme.style12W600Blue,) /// View all
                  ))
            ],
          )));
      list.add(SizedBox(height: 10,));
      list.add(t);
      list.add(SizedBox(height: 10,));
    }

    //
    // related products
    //
    _addProducts(list);
    list.add(SizedBox(height: 10,));

    //
    // blog
    //
    if (blog.isNotEmpty){
      list.add(SizedBox(height: 20,));
      list.add(Container(
          margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
          child: Row(
            children: [
              Expanded(
                  child: Text(strings.get(19), style: theme.style18W800,)), /// "Blog",
              InkWell(
                  onTap: () {
                    _mainModel.route("blog_all");
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        strings.get(1), style: theme.style12W600Blue,) /// View all
                  ))
            ],
          )));
      list.add(SizedBox(height: 20,));
      _addBlog(list);
      list.add(SizedBox(height: 10,));
    }

    //
    // Category Details
    //
    for (var item in categories) {
      list.add(Container(
          margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
          child: Row(
            children: [
              Expanded(child: Text(getTextByLocale(item.name, strings.locale), style: theme.style18W800,)),
              InkWell(
                  onTap: () {
                    _mainModel.currentCategory = item;
                    _mainModel.route("category");
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(strings.get(1), style: theme.style12W600Blue,) /// View all
                  ))
            ],
          )));
      list.add(SizedBox(height: 10,));
      if (!_addCategoryDetails(list, item)){
        list.removeLast();
        list.removeLast();
      }
      list.add(SizedBox(height: 10,));
    }




    list.add(getBottomWidget(_mainModel));

    return list;
  }

  Widget? _addProviders() {
    var _width = isMobile() ? windowWidth*0.8-50 : windowWidth*0.8/5-26;
    if (isTable())
      _width = windowWidth*0.8/3-30;

    List<Widget> list = [];
    if (providers.isNotEmpty) {
      for (var item in providers)
        list.add(ProviderItem(width: _width, item: item));
    }else{
      if (!_mainModel.initComplete) {
        list.add(oneProviderItem(windowWidth, _animation));
        list.add(oneProviderItem(windowWidth, _animation));
        list.add(oneProviderItem(windowWidth, _animation));
        list.add(oneProviderItem(windowWidth, _animation));
        list.add(oneProviderItem(windowWidth, _animation));
      }
    }
    if (list.isEmpty)
      return null;

    return Container(
      margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
      child: Rotator(width: _width, list: list,)
    );
  }

  _addProducts(List<Widget> list2){
    var _width = isMobile() ? windowWidth*0.8-50 : windowWidth*0.8/5-26;
    if (isTable())
      _width = windowWidth*0.8/3-30;

    // var _width = isMobile() ? windowWidth*0.8-50 : windowWidth*0.8/3-30;
    // if (isTable())
    //   _width = windowWidth*0.8/2-35;
    //
    List<ProductDataCache> _products = getProductsByProvider("");
    var _providerImage = getProviderImageById("");

    if (_products.isEmpty)
      return;

    List<Widget> list = [];
    int _count = 0;
    for (var item in _products){
      list.add(Container(height: 200,
          child: button202n2(item, _width, strings.locale, strings.get(262), /// Not available Now
              () {
                openArticle = item;
                _mainModel.route("article");
          }))
      );
      list.add(SizedBox(width: 10,));
      _count++;
      if (_count == 8)
        break;
    }
    list2.add(Container(
        padding: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1, bottom: 8, top: 10),
        child: Row(
          children: [
            Expanded(child: Text(strings.get(187), /// "Related products",
              style: theme.style18W800,)),
          ],
        )));
    list2.add(SizedBox(height: 20,));

    if (_count != _products.length){
      list.add(Container(height: 200,
          child: button202n2Count(_width, _providerImage,
          strings.get(188),  /// See more
          _products.length.toString(),
              () async {
            articleSortByProvider = "not_select";
            filterType = 3;
            filterIsFindInEmpty = true;
            initialFilter(_mainModel);
            filterIsFindInEmpty = false;
            filterShowProviderInFilter = false;
            setPriceRangeForArticle(_mainModel);
            _mainModel.route("products");
          })));
      list.add(SizedBox(width: 20,));
    }
    //
    // User? user = FirebaseAuth.instance.currentUser;
    // for (var item in _mainModel.service) {
    //   if (!item.category.contains(catItem.id))
    //     continue;
    //   list.add(serviceItem(_width, 200, _mainModel, item, user, cat: false));
    // }
    // if (list.isEmpty)
    //   return false;
    list2.add(Container(
        margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
        child: Rotator(width: _width, list: list,)
    ));
    return true;
  }

  _addBlog(List<Widget> list2) {
    var _width = isMobile() ? windowWidth*0.8-50 : windowWidth*0.8/2-35;
    List<Widget> list = [];
    var _count = 0;
    if (blog.isNotEmpty) {
      for (var item in blog) {
        list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: button202Blog(item, Colors.transparent,
              _width,
              250,
              () {
                _mainModel.openBlog = item;
                _mainModel.route("blog_details");
              }),
        ));
        _count++;
        if (_count == 10)
          break;
      }
    }else{
      list.add(oneProviderItem(windowWidth, _animation));
      list.add(oneProviderItem(windowWidth, _animation));
      list.add(oneProviderItem(windowWidth, _animation));
      list.add(oneProviderItem(windowWidth, _animation));
      list.add(oneProviderItem(windowWidth, _animation));
    }

    list2.add(Container(
        margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
        child: Rotator(width: _width, list: list,)));
  }

  _openBanner(String id, String heroId, String image) {
    for (var item in banners)
      if (item.id == id) {
        if (item.type == "provider") {
          for (var pr in providers)
            if (pr.id == item.open) {
              _mainModel.currentProvider = pr;
              _mainModel.route("provider");
            }
        }
        if (item.type == "category") {
          for (var cat in categories)
            if (cat.id == item.open) {
              _mainModel.currentCategory = cat;
              _mainModel.route("category");
            }
        }
        if (item.type == "service") {
          for (var ser in product)
            if (ser.id == item.open) {
              _mainModel.currentService = ser;
              _mainModel.route("service");
            }
        }
      }
  }

  // 1 - 50
  // 2 - 35
  // 3 - 30
  // 5 - 25
  bool _addCategoryDetails(List<Widget> list2, CategoryData catItem) {
    var _width = isMobile() ? windowWidth*0.8-50 : windowWidth*0.8/3-30;
    if (isTable())
      _width = windowWidth*0.8/2-35;
    //
    List<Widget> list = [];
    User? user = FirebaseAuth.instance.currentUser;
    for (var item in product) {
      if (!item.category.contains(catItem.id))
        continue;
      list.add(serviceItem(_width, 200, _mainModel, item, user, cat: false));
    }
    if (list.isEmpty)
      return false;
    list2.add(Container(
        margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
        child: Rotator(width: _width, list: list,)
    ));
    return true;
  }

}
