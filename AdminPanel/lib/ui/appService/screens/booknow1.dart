
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/ui/appService/screens/widgets.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/model/service.dart';
import 'package:ondemand_admin/widgets/buttons/button1.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class BookNowScreen1 extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;
  const BookNowScreen1({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

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

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _scrollController.addListener(_scrollListener);
    //_editControllerCoupon.text = localSettings.couponCode;
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
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
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

            Container(
              alignment: Alignment.bottomCenter,
              child: button1a(strings.get(46), /// "CONTINUE"
                  theme.style16W800White,
                  serviceApp.mainColor, (){

                  }, true),
            ),

          ])),
    );
  }

  _title() {
    //var _data = Provider.of<MainModel>(context,listen:false).getTitleImage();
    //if (_data.serverPath.isEmpty)
      //return Container();
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
                child: Container()
              )),
        ],
      ),
    );
  }

  _body(){
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    for (var item in currentTestService.price){
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
      list2.add(Expanded(child: Text(getTextByLocale(item.name, _mainModel.currentEmulatorLanguage), style: theme.style14W400)));
      list2.add(SizedBox(width: 5,));
      getPriceText(item, list2, context);
      list.add(InkWell(
          onTap: (){

          },
          child: Container(
              color: (item.selected) ? Colors.grey.withAlpha(60) : Colors.transparent,
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              child: Row(children: list2))
      ));
    }

    list.add(SizedBox(height: 10,));

    list.add(Container(
      color: (darkMode) ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        children: [
          edit42(strings.get(107), // "Coupon Code",
            _editControllerCoupon,
            "COUPON1",
          ),
        // if (localSettings.couponCode.isNotEmpty)
          SizedBox(height: 10,),
        // if (localSettings.couponCode.isNotEmpty)
          Center(child: Text(strings.get(169), /// "Coupon has expired",
            style: theme.style16W800, textAlign: TextAlign.center,))
        ],
      )));

    list.add(SizedBox(height: 20,));

    list.add(Container(
        color: (darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(child: Text(strings.get(75), // "Quantity",
                style: theme.style14W600Grey,)),
            button206(2, TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.red),
                Colors.transparent, (darkMode) ? Colors.white : Colors.black, Colors.blue.withAlpha(50),
                    (int value){})
          ],
        )));

    list.add(SizedBox(height: 20,));

    // list.add(pricingTable(context));

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }
}
