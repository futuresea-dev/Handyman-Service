
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'theme.dart';

class BookNow4Screen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const BookNow4Screen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _BookNow4ScreenState createState() => _BookNow4ScreenState();
}

class _BookNow4ScreenState extends State<BookNow4Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  final _editControllerHint = TextEditingController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
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
    _controllerSearch.dispose();
    _editControllerHint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    _init();
    return Scaffold(
      backgroundColor: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
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
                  (darkMode) ? Colors.black : Colors.white,
                (darkMode) ? Colors.white : Colors.black,
                "",
                context, () {}),

            // if (!_booking)
            // Container(
            //   alignment: Alignment.bottomCenter,
            //   child: button1a(strings.get(113), /// "CONFIRM & BOOKING NOW"
            //       theme.style16W800White,
            //       mainColor, _book, true),
            // ),

            IEasyDialog2(setPosition: (double value){_show = value; if (_show == 0) _show = 1;}, getPosition: () {return _show;}, color: Colors.grey,
              backgroundColor: (darkMode) ? Colors.black : Colors.white,
              getBody: () { return _dialogBody; },),

            // if (_wait)
            //   Center(child: Container(child: Loader7(color: mainColor,))),

          ]),
    ));
  }

  // bool _booking = false;
  double _show = 1;
  Widget _dialogBody = Container();

  _init(){
    _dialogBody = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UnconstrainedBox(
            child: Container(
              height: windowWidth/3,
              width: windowWidth/3,
              child: image11(
                  serviceApp.booking5LogoAsset ? Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain) :
                  Image.network(
                      serviceApp.booking5Logo,
                      fit: BoxFit.contain),
                  //Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain),
                  20),
            )),
        SizedBox(height: 20,),
        Text(strings.get(116), // "Thank you!",
            textAlign: TextAlign.center, style: theme.style20W800),
        SizedBox(height: 20,),
        Text(strings.get(115), // "Your booking has been successfully submitted, you will receive a confirmation soon."
            textAlign: TextAlign.center, style: theme.style14W400),
        SizedBox(height: 40,),
        Container(
            alignment: Alignment.center,
            child: Container(
                width: windowWidth/2,
                child: button2(strings.get(114), // "Ok",
                    serviceApp.mainColor,
                        (){
                      //print("button pressed");
                      // setState(() {
                      //   _show = 0;
                      // });
                      // widget.callback("");
                    }))),
        SizedBox(height: 20,),
      ],
    );
  }


  // _book(){
  //   double _total = localSettings.getTotal(context) * 100;
  //   if (localSettings.paymentMethod == 1)
  //     _appointment(strings.get(81)); /// "Cash payment",
  //   if (localSettings.paymentMethod == 2){
  //     StripeModel _stripe = StripeModel();
  //     _waits(true);
  //     try {
  //       _stripe.init(Provider.of<MainModel>(context,listen:false).localAppSettings.stripeKey);
  //       var t = _total.toInt();
  //       _stripe.openCheckoutCard(t, "", "",
  //           Provider.of<MainModel>(context,listen:false).localAppSettings.razorpayName,
  //           Provider.of<MainModel>(context,listen:false).localAppSettings.code,
  //           Provider.of<MainModel>(context,listen:false).localAppSettings.stripeSecretKey, _appointment);
  //     }catch(ex){
  //       _waits(false);
  //       print(ex.toString());
  //       messageError(context, ex.toString());
  //     }
  //   }
  //   if (localSettings.paymentMethod == 3){
  //     _waits(true);
  //     RazorpayModel _razorpayModel = RazorpayModel();
  //     _razorpayModel.init();
  //
  //     var t = _total.toInt();
  //     _razorpayModel.openCheckout(t.toString(), "", "",
  //         Provider.of<MainModel>(context,listen:false).localAppSettings.razorpayName,
  //         Provider.of<MainModel>(context,listen:false).localAppSettings.code,
  //         Provider.of<MainModel>(context,listen:false).localAppSettings.razorpayKey,
  //         _appointment, (String err){messageError(context, err);}
  //     );
  //   }
  //   if (localSettings.paymentMethod == 4){
  //     String _total = localSettings.getTotalString(context);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PaypalPayment(
  //             currency: Provider.of<MainModel>(context,listen:false).localAppSettings.code,
  //             userFirstName: "",
  //             userLastName: "",
  //             userEmail: "",
  //             payAmount: _total,
  //             secret: Provider.of<MainModel>(context,listen:false).localAppSettings.paypalSecretKey,
  //             clientId: Provider.of<MainModel>(context,listen:false).localAppSettings.paypalClientId,
  //             sandBoxMode: "false",
  //             onFinish: (w){
  //               _appointment("PayPal: $w");
  //             }
  //         ),
  //       ),
  //     );
  //   }
  //   _waits(false);
  // }

  // bool _wait = false;
  // _waits(bool value){
  //   _wait = value;
  //   _redraw();
  // }
  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

  // _book2(){
  //   // _booking = true;
  //   _dialogBody = Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       UnconstrainedBox(
  //           child: Container(
  //             height: windowWidth/3,
  //             width: windowWidth/3,
  //             child: image11(Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain), 20),
  //           )),
  //       SizedBox(height: 20,),
  //       Text(strings.get(116), // "Thank you!",
  //           textAlign: TextAlign.center, style: theme.style20W800),
  //       SizedBox(height: 20,),
  //       Text(strings.get(115), // "Your booking has been successfully submitted, you will receive a confirmation soon."
  //           textAlign: TextAlign.center, style: theme.style14W400),
  //       SizedBox(height: 40,),
  //       Container(
  //         alignment: Alignment.center,
  //         child: Container(
  //           width: windowWidth/2,
  //           child: button2(strings.get(114), // "Ok",
  //               serviceApp.mainColor, 10,
  //             (){
  //               print("button pressed");
  //               // setState(() {
  //               //   _show = 0;
  //               // });
  //               // widget.callback("");
  //             }, true))),
  //       SizedBox(height: 20,),
  //     ],
  //   );
  //   setState(() {
  //     _show = 1;
  //   });
  // }

  _title() {
    // var _data = Provider.of<MainModel>(context,listen:false).getTitleImage();
    // if (_data.serverPath.isEmpty)
    //   return Container();
    return Container(
      color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Stack(
        children: [
          Container(
              alignment: Alignment.bottomRight,
              child: Container(
                width: windowWidth,
                margin: EdgeInsets.only(bottom: 10),
                // child: CachedNetworkImage(
                //     imageUrl: _data.serverPath,
                //     imageBuilder: (context, imageProvider) => Container(
                //       width: double.maxFinite,
                //       alignment: Alignment.bottomRight,
                //       child: Container(
                //         //width: height,
                //         decoration: BoxDecoration(
                //             image: DecorationImage(
                //               image: imageProvider,
                //               fit: BoxFit.cover,
                //             )),
                //       ),
                //     )
                // ),
              )),
        ],
      ),
    );
  }

  _body(){
    List<Widget> list = [];

    list.add(SizedBox(height: 10,));

    list.add(Container(
        padding: EdgeInsets.all(20),
        color: (darkMode) ? Colors.black : Colors.white,
        child: Row(
          children: [
            Expanded(child: Text(strings.get(77), // "Total",
                style: theme.style14W400)),
            Text("10", style: theme.style16W800Orange,)
          ],
        ),
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: (darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: checkBox43(strings.get(81), // "Cash payment",
          Colors.orange, "assets/cache.png",
          theme.style14W800,
          true, (val) {
            // if (val) {
            //   localSettings.paymentMethod = 1;
            //   setState(() {});
            // }
          }),
    ));

    // if (Provider.of<MainModel>(context,listen:false).localAppSettings.stripeEnable)
    //   list.add(Container(
    //     margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
    //     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    //     decoration: BoxDecoration(
    //       color: (darkMode) ? Colors.black : Colors.white,
    //       borderRadius: BorderRadius.circular(theme.radius),
    //     ),
    //     child: checkBox43("Stripe", Colors.orange, "assets/stripe.png",
    //         theme.style14W800,
    //         localSettings.paymentMethod == 2, (val) {
    //           if (val) {
    //             localSettings.paymentMethod = 2;
    //             setState(() {});
    //           }
    //         }),
    //   ));
    //
    // if (Provider.of<MainModel>(context,listen:false).localAppSettings.razorpayEnable)
    //   list.add(Container(
    //       margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
    //       padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    //       decoration: BoxDecoration(
    //         color: (darkMode) ? Colors.black : Colors.white,
    //         borderRadius: BorderRadius.circular(theme.radius),
    //       ),
    //       child: checkBox43("Razorpay", Colors.orange, "assets/razorpay.png",
    //           theme.style14W800,
    //           localSettings.paymentMethod == 3, (val) {
    //             if (val) {
    //               localSettings.paymentMethod = 3;
    //               setState(() {});
    //             }
    //           })));
    //
    // if (Provider.of<MainModel>(context,listen:false).localAppSettings.paypalEnable)
    //   list.add(Container(
    //       margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
    //       padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    //       decoration: BoxDecoration(
    //         color: (darkMode) ? Colors.black : Colors.white,
    //         borderRadius: BorderRadius.circular(theme.radius),
    //       ),
    //       child: checkBox43("Pay Pal", Colors.orange, "assets/paypal.png",
    //           theme.style14W800,
    //             localSettings.paymentMethod == 4, (val) {
    //             if (val) {
    //               localSettings.paymentMethod = 4;
    //               setState(() {});
    //             }
    //           })));

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  // _appointment(String paymentMethod) async {
  //   dprint("_appointment $paymentMethod");
  //   var ret = await Provider.of<MainModel>(context,listen:false).finish(paymentMethod, context);
  //   if (ret != null)
  //     return messageError(context, ret);
  //   _book2();
  //   localSettings.clearBookData();
  // }
}
