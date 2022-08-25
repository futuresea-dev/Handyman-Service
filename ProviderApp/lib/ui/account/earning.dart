import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';

class EarningScreen extends StatefulWidget {
  @override
  _EarningScreenState createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  List<EarningData> _earning = [];

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _init();
    super.initState();
  }

  _init() async {
    var ret = await loadPayoutForProvider(currentProvider.id);
    if (ret != null)
      messageError(context, ret);
    _earning = getEarningData(currentProvider);
    _redraw();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
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
                              color: (theme.darkMode) ? Colors.black : Colors.white,
                              child: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: _title(),
                            titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                            title: _titleSmall()
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

                appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                    "", context, () {Navigator.pop(context);}),

              ]),
        ));
  }

  _title() {
    return Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      height: windowHeight * 0.3,
      width: windowWidth/2,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              width: windowWidth*0.3,
              child: Image.asset("assets/ondemand/ondemand16.png", fit: BoxFit.cover),
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          ),
        ],
      ),
    );
  }

  _titleSmall(){
    EarningData? _data;
    if (_earning.isNotEmpty)
      _data = _earning.last;
    return Container(
      padding: EdgeInsets.only(bottom: _scroller, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_data != null ? getPriceString(_data.payout) : "",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(88), // "Available Balance",
                style: theme.style10W600Grey),
          ],
        )
    );
  }


  _body(){
    List<Widget> list = [];

    if (_earning.isNotEmpty){
      list.add(Text(strings.get(223), style: theme.style13W800,)); /// "Balance",
      list.add(SizedBox(height: 10,));

      EarningData _data = _earning.last;
      list.add(CardEarningTotal(
        backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
        data: _data,
        stringToAdmin: strings.get(219), /// "To Admin",
        stringToProvider: strings.get(220), /// "To Provider",
        stringTax: strings.get(221), /// "TAX/VAT",
        stringTotal: strings.get(56) /// "Total",
        // price: getPriceString(_data.total),
        //totalString: strings.get(56), /// "Total",
      ));
      list.add(SizedBox(height: 10,));
    }

    // payouts

    if (payout.isNotEmpty){
      list.add(Text(strings.get(222), style: theme.style13W800,)); /// "Payouts",
      list.add(SizedBox(height: 10,));
    }
    for (var item in payout)
      list.add(
          payoutCard((theme.darkMode) ? Colors.black : Colors.white, item.time, item.total));
    list.add(SizedBox(height: 10,));

    // orders
    if (_earning.isNotEmpty){
      list.add(Text(strings.get(224), style: theme.style13W800,)); /// "Orders",
      list.add(SizedBox(height: 10,));
    }

    for (var item in _earning) {
      if (item != _earning.last)
       list.add(
        CardEarning(
          backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
          name: item.name,
          id: item.id,
          price: getPriceString(item.total),
          customerName: item.customerName,
          time: appSettings.getDateTimeString(item.time),
          stringCustomerName: strings.get(218), /// "Customer name",
          stringBookingId: strings.get(44) /// "Booking ID",
        ));
        list.add(SizedBox(height: 6,));
    }

    list.add(SizedBox(height: 120,));

    return Container(
      margin: EdgeInsets.only(left: 6, right: 6),
      padding: EdgeInsets.only(top: 0),
      child: ListView(
        children: list,
      ),
    );
  }
}

