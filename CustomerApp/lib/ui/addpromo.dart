import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import 'strings.dart';
import 'theme.dart';

class AddPromoScreen extends StatefulWidget {
  @override
  _AddPromoScreenState createState() => _AddPromoScreenState();
}

class _AddPromoScreenState extends State<AddPromoScreen> {

  List<OfferData> coupons = [];

  @override
  void initState() {
    var _mainModel = Provider.of<MainModel>(context,listen:false);
    coupons = getVisibleCoupons(_mainModel.cartUser, _mainModel.currentService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
      body: Directionality(
      textDirection: strings.direction,
    child: Stack(
          children: [

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50, left: 15, right: 15),
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: _child(),
              ),
            ),

            appbar1((theme.darkMode) ? Colors.black : Colors.white,
                (theme.darkMode) ? Colors.white : Colors.black, "",
                context, () {
                  goBack();
                }, style: theme.style14W800)


          ]),
      ));
  }

  List<Widget> _child(){
    List<Widget> list = [];

    list.add(
      Row(
        children: [
          Expanded(child: Text(strings.get(291),  /// "My rewards",
              style: theme.style16W800,)),
          InkWell(
            onTap: (){
              route("enter_code");
            },
            child: Row(children: [
            Text(strings.get(292),  /// "Enter code",
              style: theme.style14W800,),
            SizedBox(width: 5,),
            Icon(Icons.arrow_forward_ios, size: 15,)
          ],)
          )
        ],
      )
    );

    list.add(SizedBox(height: 20,));

    for (var item in coupons){
      var disc = "";
      var desc = getTextByLocale(item.desc, locale);
      if (item.discountType == "fixed")
        disc = "-${getPriceString(item.discount)} $desc";
      else
        disc = "-${item.discount}% $desc";

      list.add(InkWell(
        onTap: (){
          if (item.state.isEmpty){
            activateCoupon(item.code);
            goBack();
          }
        },
          child: Opacity(opacity: item.state.isEmpty ? 1 : 0.2,
          child: offerWidget(item.color, strings.get(293), /// "Special offer"
          theme.style12W600White, item.image,
          disc, theme.style14W800,
          windowWidth-30, windowWidth*0.4,
          strings.get(294), theme.style14W600White, /// "Use now"
          "${strings.get(295)} ${appSettings.getDateTimeString(item.expired)}", theme.style12W800)  /// "Valid until",
      )));
      if (item.state.isNotEmpty){
        list.add(SizedBox(height: 10,));
        var _text = "";
        if (item.state == "not_found")
          _text = strings.get(162); /// "Coupon not found",
        if (item.state == "expired")
          _text = strings.get(169); /// "Coupon has expired",
        if (item.state == "not_supported_by_this_provider")
          _text = strings.get(164); /// "Coupon not supported by this provider",
        if (item.state == "not_support_this_category")
          _text = strings.get(165); /// "Coupon not support this category",
        if (item.state == "not_support_this_service")
          _text = strings.get(166); /// "Coupon not support this category",
        if (item.state == "not_support_this_product")
          _text = strings.get(298); /// "Coupon not support this product",
        list.add(Center(child: Text(_text, style: theme.style12W600Red, textAlign: TextAlign.center,)));
      }
      list.add(SizedBox(height: 10,));
      list.add(Divider(color: Colors.grey,));
      list.add(SizedBox(height: 10,));
    }

    list.add(SizedBox(height: 150,));

    return list;
  }
}
