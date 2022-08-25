import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../../theme.dart';
import '../strings.dart';
import 'dialogs.dart';

class DialogCouponsList extends StatefulWidget {
  final Function() close;

  const DialogCouponsList({Key? key, required this.close,}) : super(key: key);

  @override
  _DialogCouponsListState createState() => _DialogCouponsListState();
}

class _DialogCouponsListState extends State<DialogCouponsList> {

  List<OfferData> coupons = [];

  @override
  void initState() {
    var _mainModel = Provider.of<MainModel>(context,listen:false);
    coupons = getVisibleCoupons(_mainModel.cartUser, _mainModel.currentService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: windowWidth,
      height: windowHeight,
      child: Stack(
              children: [

                InkWell(
                  onTap: widget.close,
                  child: Container(
                    width: windowWidth,
                    height: windowHeight,
                    color: Colors.grey.withAlpha(50),
                  ),
                ),

                Center(
                    child: Container(
                       width: isMobile() ? windowWidth: windowWidth*0.4,
                        margin: EdgeInsets.only(top: 50, bottom: 50),
                        color: Colors.white,
                        padding: EdgeInsets.all(20),
                        child:
                        ListView(
                          shrinkWrap: true,
                          children: _child(),
                        )
                    )
                ),

              ]),
        );
  }

  List<Widget> _child(){
    List<Widget> list = [];

    list.add(
        Row(
          children: [
            Expanded(child: Text(strings.get(218),  /// "My rewards",
              style: theme.style16W800,)),
            InkWell(
                onTap: (){
                  showDialogEnterCode();
                },
                child: Row(children: [
                  Text(strings.get(219),  /// "Enter code",
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
              widget.close();
            }
          },
          child: Opacity(opacity: item.state.isEmpty ? 1 : 0.2,
              child: offerWidget(item.color, strings.get(220), /// "Special offer"
                  theme.style12W600White, item.image,
                  disc, theme.style14W800,
                  isMobile() ? windowWidth*0.8 : windowWidth*0.25,
                  isMobile() ? windowWidth*0.8*0.4 : windowWidth*0.25*0.4,
                  strings.get(221), theme.style14W600White, /// "Use now"
                  "${strings.get(222)} ${appSettings.getDateTimeString(item.expired)}", theme.style12W800)  /// "Valid until",
          )));
      if (item.state.isNotEmpty){
        list.add(SizedBox(height: 10,));
        var _text = "";
        if (item.state == "not_found")
          _text = strings.get(102); /// "Coupon not found",
        if (item.state == "expired")
          _text = strings.get(103); /// "Coupon has expired",
        if (item.state == "not_supported_by_this_provider")
          _text = strings.get(104); /// "Coupon not supported by this provider",
        if (item.state == "not_support_this_category")
          _text = strings.get(105); /// "Coupon not support this category",
        if (item.state == "not_support_this_service")
          _text = strings.get(106); /// "Coupon not support this category",
        if (item.state == "not_support_this_product")
          _text = strings.get(223); /// "Coupon not support this product",
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

