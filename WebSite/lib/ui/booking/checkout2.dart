import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:abg_utils/payments_web.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'package:ondemand_admin/ui/booking/payment.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../strings.dart';

class CheckOut2Screen extends StatefulWidget {
  @override
  _CheckOut2ScreenState createState() => _CheckOut2ScreenState();
}

class _CheckOut2ScreenState extends State<CheckOut2Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  bool _razorPayNeed = false;
  // final ScrollController _scrollController = ScrollController();
  final _editControllerCoupon = TextEditingController();
  final _editControllerHint = TextEditingController();
  final ScrollController _scrollController2 = ScrollController();
  // double _show = 0;
  late MainModel _mainModel;
  late PriceTotalForCardData _totalPrice;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _editControllerHint.text = localSettings.hint;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController2.dispose();
    _editControllerHint.dispose();
    _editControllerCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);

    List<Widget> list = [];
    list.add(SizedBox(height: 20,));
    paymentsList(cartCurrentProvider != null ? cartCurrentProvider! : ProviderData.createEmpty(), list, _redraw, true);

    list.add(Container(
      alignment: Alignment.bottomCenter,
      child: button2(strings.get(62), /// "CONTINUE"
          theme.mainColor, (){
            // String _desc = "";
            // if (price.name.isNotEmpty)
            //   _desc = getTextByLocale(price.name, strings.locale);
            _mainModel.cartUser = true;
            String _desc = "none";
            List<PriceForCardData> _t = cartGetPriceForAllServices();
            if (_t.isNotEmpty)
              _desc = _t[0].name;
            paymentProcess(_totalPrice.total, _desc, _mainModel, context, (){
              _razorPayNeed = true;
              _redraw();
            });

          }, radius: 0),
    ));

    String _desc = "none";
    List<PriceForCardData> _t = cartGetPriceForAllServices();
    if (_t.isNotEmpty)
      _desc = _t[0].name;

    return Stack(
      children: [
        ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _body())),
                  SizedBox(width: 20,),
                  Expanded(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: list,
                  )),
                ],
              ),
            ]
        ),
        if (_razorPayNeed)
          Container(
            height: windowHeight,
            child: RazorpayPayment(
                amount: _totalPrice.total,
                desc: _desc,
                success: (String id) async {
                  paymentMethodId = "Razorpay $id";
                  _mainModel.razorpaySuccess = true;
                  dprint("mainModel.paymentMethodId=$paymentMethodId");
                  var ret = await _mainModel.finish(false);
                  if (ret != null)
                    return messageError(context, ret);
                  _mainModel.clearBookData();
                  _mainModel.route("payment_success");
                }, close: (){
              _razorPayNeed = false; _redraw();
            }),)
      ],
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _body(){
    List<Widget> list = [];

    _totalPrice = cartGetTotalForAllServices();
    tablePricesV4(list, cart,
        strings.get(23), /// "Addons"
        strings.get(181), /// "Subtotal"
        strings.get(182), /// "Discount"
        strings.get(208), /// "VAT/TAX"
        strings.get(196)  /// "Total amount"
    );

    list.add(SizedBox(height: 150,));
    return list;
  }
}
