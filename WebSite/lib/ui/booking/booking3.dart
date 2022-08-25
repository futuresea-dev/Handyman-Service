import 'package:abg_utils/abg_utils.dart';
import 'package:abg_utils/payments_web.dart';
import 'package:ondemand_admin/ui/booking/payment.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import '../bottom.dart';

class BookNow3Screen extends StatefulWidget {
  @override
  _BookNow3ScreenState createState() => _BookNow3ScreenState();
}

class _BookNow3ScreenState extends State<BookNow3Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _editControllerCoupon = TextEditingController();
  late MainModel _mainModel;
  bool _razorPayNeed = false;
  //bool _payPalNeed = false;

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
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
          padding: EdgeInsets.only(top : 0),
            child: ListView(
              children: _getList(),
            ),),

        if (_razorPayNeed)
          RazorpayPayment(
            amount: getTotal(), desc: getTextByLocale(price.name, strings.locale),
              success: (String id) async {
                paymentMethodId = "Razorpay $id";
            _mainModel.razorpaySuccess = true;
            dprint("mainModel.paymentMethodId=$paymentMethodId");
            var ret = await _mainModel.finish(false);
            if (ret != null)
              return messageError(context, ret);
            _mainModel.clearBookData();
            _mainModel.route("payment_success");
          },
            close: (){
            _razorPayNeed = false; _redraw();
          }),

      ],
    );
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

    Widget _request = Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Column(
            children: [
              Text(strings.get(114), style: theme.style13W800,), /// "Requested Service on",
              SizedBox(height: 10,),

              Text(cartAnyTime ? strings.get(95) /// "Any Time",
                  : appSettings.getDateTimeString(cartSelectTime),
                style: theme.style14W800,),
            ],
          ),
        ),
        Container(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.get(90), /// "Your address",
                  style: theme.style13W800, textAlign: TextAlign.start,),
                Divider(color: (theme.darkMode) ? Colors.white : Colors.black, thickness: 0.5),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.orange),
                    SizedBox(width: 10,),
                    Expanded(child: Text(getCurrentAddress().address, style: theme.style14W400,))
                  ],
                ),
                // SizedBox(height: 10,),
              ],
            )
        ),
        SizedBox(height: 10,),
        Container(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.get(94), /// "Special Requests",
                  style: theme.style13W800, textAlign: TextAlign.start,),
                Divider(color: (theme.darkMode) ? Colors.white : Colors.black, thickness: 0.5,),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(Icons.comment, color: Colors.orange),
                    SizedBox(width: 10,),
                    Text(cartHint, style: theme.style14W400,)
                  ],
                ),
                SizedBox(height: 10,),
              ],
            )
        ),

      ],
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
          if (code == "total") return  strings.get(113);  /// "Total",
          if (code == "subtotal") return strings.get(181);  /// "Subtotal",
          if (code == "discount") return strings.get(182);  /// "Discount"
          return "";
        }
    );

    if (isMobile()){
      list.add(_request);
      list.add(SizedBox(height: 20,));
      list.add(_pt);
    }else
      list.add(Row(children: [
        Expanded(child: _request),
        SizedBox(width: 10,),
        Expanded(child: _pt),
      ],));

    list.add(SizedBox(height: 10));

    ProviderData _provider = ProviderData.createEmpty();
    if (_mainModel.currentService.providers.isNotEmpty) {
      var provider = getProviderById(_mainModel.currentService.providers[0]);
      if (provider != null)
        _provider = provider;
    }

    paymentsList(_provider, list, _redraw, false);

    //
    //
    //
    list.add(SizedBox(height: 30,));
    list.add(button2x(strings.get(116), (){  /// "CONFIRM & BOOKING NOW"
      if (_mainModel.currentService.providers.isEmpty)
        return messageError(context, "providers == null");
      // cartCurrentProvider = ProviderData.createEmpty()..id = _mainModel.currentService.providers[0];
      _mainModel.cartUser = false;
      paymentProcess(getTotal(), getTextByLocale(price.name, strings.locale), _mainModel, context, (){
        _razorPayNeed = true;
        _redraw();
      });
    }));


    list.add(SizedBox(height: 20,));
    list.add(getBottomWidget(_mainModel));

    return list;
  }



}
