import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import '../strings.dart';
import '../theme.dart';
import 'package:provider/provider.dart';

class BookNow2Screen extends StatefulWidget {
  @override
  _BookNow2ScreenState createState() => _BookNow2ScreenState();
}

class _BookNow2ScreenState extends State<BookNow2Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  final _editControllerHint = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
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

            Container(
              alignment: Alignment.bottomCenter,
              child: button2(strings.get(46), /// "CONTINUE"
                  theme.mainColor, (){
                    route("book3");
                  }, radius: 0),
            ),

          ]),
    ));
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

    list.add(Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        children: [
          Text(strings.get(111), style: theme.style13W800,), /// "Requested Service on",
          SizedBox(height: 10,),

          Text(_mainModel.anyTime ? strings.get(109) /// "Any Time",
            : appSettings.getDateTimeString(_mainModel.selectTime),
            style: theme.style14W800,),
        ],
      ),
    ));

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(103), /// "Your address",
                  style: theme.style13W800, textAlign: TextAlign.start,),
            Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.orange),
                SizedBox(width: 10,),
                Expanded(child: Text(getCurrentAddress().address, style: theme.style13W400,))
              ],
            ),
            // SizedBox(height: 10,),
          ],
        )
    ));

    list.add(SizedBox(height: 10,));

    list.add(Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.get(219), /// "Special Requests",
            style: theme.style13W800, textAlign: TextAlign.start,),
          Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(Icons.comment, color: Colors.orange),
              SizedBox(width: 10,),
              Text(localSettings.hint, style: theme.style14W400,)
            ],
          ),
          SizedBox(height: 10,),
        ],
      )
    ));

    list.add(SizedBox(height: 10,));

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

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

}
