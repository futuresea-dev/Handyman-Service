import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/elements/widgets.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../addons.dart';
import '../theme.dart';

class BookNowScreen1 extends StatefulWidget {
  @override
  _BookNowScreen1State createState() => _BookNowScreen1State();
}

class _BookNowScreen1State extends State<BookNowScreen1> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  final _editControllerCoupon = TextEditingController();
  final ScrollController _scrollController2 = ScrollController();

  late MainModel _mainModel;
  ProviderData? _provider;
  bool _minAmount = false;
  bool _maxAmount = false;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _scrollController.addListener(_scrollListener);
    if (_mainModel.currentService.providers.isNotEmpty) {
      _provider = getProviderById(_mainModel.currentService.providers[0]);
      if (_provider != null){
        setDataToCalculate(null, _mainModel.currentService);
        if (_provider!.useMinPurchaseAmount && getTotal() < _provider!.minPurchaseAmount)
          _minAmount = true;
        if (_provider!.useMaxPurchaseAmount && getTotal() > _provider!.maxPurchaseAmount)
          _maxAmount = true;
      }
    }
    super.initState();
  }

  double _scroller = 20;
  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    _scroller = 20-(_scrollPosition/(windowHeight*0.1/20));
    if (_scroller < 0)
      _scroller = 0;
    setState(() {
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController2.dispose();
    _controllerSearch.dispose();
    _editControllerCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      body: Directionality(
      textDirection: strings.direction,
      child: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                      expandedHeight: windowHeight*0.2,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: ClipPath(
                        clipper: ClipPathClass23((_scroller < 5) ? 5 : _scroller),
                        child: Container(
                            child: Stack(
                              children: [
                                FlexibleSpaceBar(
                                    collapseMode: CollapseMode.pin,
                                    background: _title(),
                                    titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                )
                              ],
                            )),
                      ))
                ];
              },
              body: Container(
                width: windowWidth,
                height: windowHeight,
                child: _body(),
              ),
            ),

            appbar1((_scroller > 1) ? Colors.transparent :
                  (theme.darkMode) ? Colors.black : Colors.white,
                (theme.darkMode) ? Colors.white : Colors.black,
                (_scroller > 5) ? "" : getTextByLocale(_mainModel.currentService.name, strings.locale),
                context, () {goBack();}),

            if (!_minAmount && !_maxAmount)
            Container(
              alignment: Alignment.bottomCenter,
              child: button2(strings.get(46), /// "CONTINUE"
                  theme.mainColor, (){
                    route("book2");
                  }, radius: 0),
            ),

          ])),
    );
  }

  _title() {
    var _data = _mainModel.service.getTitleImage();
    if (_data.serverPath.isEmpty)
      return Container();
    return Container(
      color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Stack(
        children: [
          Container(
              alignment: Alignment.bottomRight,
              child: Container(
                width: windowWidth,
                margin: EdgeInsets.only(bottom: 10),
                child: CachedNetworkImage(
                    imageUrl: _data.serverPath,
                    imageBuilder: (context, imageProvider) => Container(
                      width: double.maxFinite,
                      alignment: Alignment.bottomRight,
                      child: Container(
                        //width: height,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            )),
                      ),
                    )
                ),
              )),
        ],
      ),
    );
  }

  _body(){
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    for (var item in _mainModel.currentService.price){
      List<Widget> list2 = [];
      list2.add((item.image.serverPath.isNotEmpty) ?
      Container(
          width: 30,
          height: 30,
          child: Image.network(item.image.serverPath, fit: BoxFit.contain))
          : Container(
          width: 30,
          height: 30));
      list2.add(SizedBox(width: 10,));
      list2.add(Expanded(child: Text(getTextByLocale(item.name, strings.locale), style: theme.style14W400)));
      list2.add(SizedBox(width: 5,));
      getPriceText(item, list2, _mainModel);
      list.add(InkWell(
          onTap: (){
            for (var item in _mainModel.currentService.price)
              item.selected = false;
            item.selected = true;
            //localSettings.price = item;
            _redraw();
          },
          child: Container(
              color: (item.selected) ? Colors.grey.withAlpha(60) : Colors.transparent,
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              child: Row(children: list2))
      ));
    }

    list.add(SizedBox(height: 10,));

    if (couponCode.isNotEmpty)
      list.add(Container(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          child: Row(children: [
            Expanded(child: Text("${strings.get(299)}: $couponCode", style: theme.style14W800,), /// "Promo code",
            ),
            InkWell(
                onTap: (){
                  clearCoupon();
                  _redraw();
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(strings.get(300), style: theme.style12W800,), /// "Remove",
                ))
          ],)));
    else
      if (isCouponsPresent(_mainModel.cartUser, _mainModel.currentService))
        list.add(InkWell(
            onTap: (){
              route("add_promo");
            },
            child: Container(
              color: (theme.darkMode) ? Colors.black : Colors.white,
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Text(strings.get(289), style: theme.style14W800,), /// "Add promo",
            )));
      else
        list.add(Container(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Text("${strings.get(289)} | ${strings.get(290)}", style: theme.style14W400Grey,), /// "Promo not found",
        ));

    list.add(SizedBox(height: 20,));

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(child: Text(strings.get(75), /// "Quantity",
                style: theme.style12W600Grey,)),
            button206(countProduct, theme.style20W800Red,
                Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black, Colors.blue.withAlpha(50),
                    (int value){countProduct = value; setState(() {});})
          ],
        )));

    list.add(SizedBox(height: 20,));

    listAddons(list, windowWidth, _redraw, _mainModel, false);

    setDataToCalculate(null, _mainModel.currentService);
    list.add(pricingTable(
            (String code){
          if (code == "addons") return strings.get(221);  /// "Addons",
          if (code == "direction") return strings.direction;
          if (code == "locale") return localSettings.locale;
          if (code == "pricing") return strings.get(74);  /// "Pricing",
          if (code == "quantity") return strings.get(75);  /// "Quantity",
          if (code == "taxAmount") return strings.get(76);  /// "Tax amount",
          if (code == "total") return strings.get(77);  /// "Total",
          if (code == "subtotal") return strings.get(235);  /// "Subtotal",
          if (code == "discount") return strings.get(236);  /// "Discount"
          return "";
        }
    ));

    if (_minAmount){
      list.add(Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        color: (theme.darkMode) ? Colors.black : Colors.white,
        alignment: Alignment.center,
        child: Text(strings.get(285) + getPriceString(_provider!.minPurchaseAmount),
            style: theme.style12W600Red)), /// Minimum purchase amount for this provider:
      );
    }
    if (_maxAmount){
      list.add(Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(top: 10, bottom: 10),
          color: (theme.darkMode) ? Colors.black : Colors.white,
          alignment: Alignment.center,
          child: Text(strings.get(286) + getPriceString(_provider!.maxPurchaseAmount),
              style: theme.style12W600Red)), /// Maximum purchase amount for this provider:
      );
    }

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }
}
