import 'package:abg_utils/abg_utils.dart';
import 'package:ondemand_admin/widgets/addons.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../dialogs/dialogs.dart';
import '../strings.dart';
import '../../theme.dart';

class BookNow2Screen extends StatefulWidget {
  @override
  _BookNow2ScreenState createState() => _BookNow2ScreenState();
}

class _BookNow2ScreenState extends State<BookNow2Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _editControllerCoupon = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    if (price.name.isEmpty)
      if (_mainModel.currentService.price.isNotEmpty)
        price = _mainModel.currentService.price[0];
    super.initState();
  }

  @override
  void dispose() {
    _editControllerCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Column(children: _getList());
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    List<Widget> list5 = [];
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
      list5.add(InkWell(
          onTap: (){
            for (var item in _mainModel.currentService.price)
              item.selected = false;
            item.selected = true;
            //price = item;
            _redraw();
          },
          child: Container(
              color: (item.selected) ? Colors.grey.withAlpha(60) : Colors.transparent,
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              child: Row(children: list2))
      ));
    }

    Widget _quantity = Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          children: [
            Text(strings.get(108), /// "Quantity",
              style: theme.style12W600Grey,),
            SizedBox(width: 30,),
            button206(countProduct, TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.red),
                Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black, Colors.blue.withAlpha(50),
                    (int value){countProduct = value; setState(() {});})
          ],
        ));

    if (isMobile()){
      list.add(Column(children: list5,));
      list.add(SizedBox(height: 20,));
      list.add(_quantity);
    }else
      list.add(Row(
        children: [
          Expanded(child: Column(children: list5,)),
          SizedBox(width: 30,),
          Expanded(child: _quantity),
        ],
      ));

    list.add(SizedBox(height: 30,));

    listAddons(list, windowWidth, _redraw, _mainModel);

    Widget _couponCode = Container();
    if (couponCode.isNotEmpty)
      _couponCode = Container(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          child: Row(children: [
            Expanded(child: Text("${strings.get(214)}: $couponCode", style: theme.style14W800,), /// "Promo code",
            ),
            InkWell(
                onTap: (){
                  clearCoupon();
                  _redraw();
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(strings.get(215), style: theme.style12W800,), /// "Remove",
                ))
          ],));
    else
    if (isCouponsPresent(_mainModel.cartUser, _mainModel.currentService))
      _couponCode = InkWell(
          onTap: (){
            showDialogCouponsList();
          },
          child: Container(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Text(strings.get(216), style: theme.style14W800,), /// "Add promo",
          ));
    else
      _couponCode = Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Text("${strings.get(216)} | ${strings.get(217)}", style: theme.style14W400Grey,), /// "Promo not found",
      );

    setDataToCalculate(null, _mainModel.currentService);
    Widget _pt = pricingTable(
            (String code){
          if (code == "addons") return strings.get(23);  /// "Addons",
          if (code == "direction") return strings.direction;
          if (code == "locale") return strings.locale;
          if (code == "pricing") return strings.get(109);  /// "Pricing",
          if (code == "quantity") return strings.get(108);  /// "Quantity",
          if (code == "taxAmount") return strings.get(112);  /// "Tax amount",
          if (code == "total") return strings.get(113);  /// "Total",
          if (code == "subtotal") return strings.get(181);  /// "Subtotal",
          if (code == "discount") return strings.get(182);  /// "Discount"
          return "";
        }
    );

    if (isMobile()){
      list.add(_couponCode);
      list.add(SizedBox(height: 20,));
      // list.add(pricingTable(context, _mainModel));
      list.add(_pt);
    }else
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Expanded(child: _couponCode),
        Expanded(child: _pt),
      ],));

    bool _minMaxAmount = false;
    if (_mainModel.currentService.providers.isNotEmpty) {
      ProviderData? _provider = getProviderById(_mainModel.currentService.providers[0]);
      if (_provider != null){
        setDataToCalculate(null, _mainModel.currentService);
        if (_provider.useMinPurchaseAmount && getTotal() < _provider.minPurchaseAmount){
          list.add(Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: (theme.darkMode) ? Colors.black : Colors.white,
              alignment: Alignment.center,
              child: Text(strings.get(213) + getPriceString(_provider.minPurchaseAmount),
                  style: theme.style12W600Red)), /// Minimum purchase amount for this provider:
          );
          _minMaxAmount = true;
        }
        if (_provider.useMaxPurchaseAmount && getTotal() > _provider.maxPurchaseAmount){
          list.add(Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: (theme.darkMode) ? Colors.black : Colors.white,
              alignment: Alignment.center,
              child: Text(strings.get(212) + getPriceString(_provider.maxPurchaseAmount),
                  style: theme.style12W600Red)), /// Maximum purchase amount for this provider:
          );
          _minMaxAmount = true;
        }

      }
    }

    list.add(SizedBox(height: 30,));
    if (!_minMaxAmount)
      list.add(button2x(strings.get(62), (){  /// "CONTINUE"
        _mainModel.route("book2");
      }));

    list.add(SizedBox(height: 150,));

    return list;
  }


}
