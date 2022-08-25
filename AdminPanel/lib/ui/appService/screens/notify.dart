
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class NotifyScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;
  const NotifyScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  // String _searchText = "";
  late MainModel mainModel;
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final _controllerSearch = TextEditingController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    mainModel = Provider.of<MainModel>(context, listen: false);
    super.initState();
  }

  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

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
                              color: (darkMode) ? Colors.black : Colors.white,
                              child: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: _title(),
                            titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                            title: _titleSmall()
                          )),
                        ))
                      ];
                    },
                    body: Stack(
                      children: [
                        Container(
                          width: windowWidth,
                          height: windowHeight,
                          child: _body(),
                        ),

                      ],
                    )
                ),

                appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black,
                    "", context, () {})

              ]),
        ));
  }

  _title() {
    return Container(
      color: (darkMode) ? Colors.black : Colors.white,
      height: windowHeight * 0.3,
      width: windowWidth/2,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              width: windowWidth*0.3,
                child: serviceApp.notifyLogoAsset ? Image.asset("assets/ondemands/ondemand17.png", fit: BoxFit.contain) :
                Image.network(
                    serviceApp.notifyLogo,
                    fit: BoxFit.contain)
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          ),
        ],
      ),
    );
  }

  _titleSmall(){
    return Container(
        alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _scroller, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(19), // "Notifications",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(20), // "Lots of important information",
                style: theme.style10W600Grey),
          ],
        )
    );
  }


  _body(){
    List<Widget> list = [];

    list.add(Edit26(
        hint: strings.get(122), /// "Search",
        color: (darkMode) ? Colors.black : Colors.white,
        style: theme.style14W400,
        decor: decor,
        icon: Icons.search,
        useAlpha: false,
        controller: _controllerSearch,
        onChangeText: (String value){
          // _searchText = value;
          setState(() {
          });
        }
    ));

    list.add(SizedBox(height: 20,));

    //
    //
    //
    bool _empty = true;
    // var _now = DateFormat('dd MMMM').format(DateTime.now());

    // for (var item in Provider.of<MainModel>(context,listen:false).messages){
    //   if (_searchText.isNotEmpty)
    //     if (!item.title.toUpperCase().contains(_searchText.toUpperCase()))
    //       if (!item.body.toUpperCase().contains(_searchText.toUpperCase()))
    //         continue;
    //   var time = DateFormat('dd MMMM').format(item.time);
    //   if (time == _now)
    //     time = strings.get(145); /// Today
    //   list.add(Card48(color: (darkMode) ? Colors.black : Colors.white,
    //     borderColor: (darkMode) ? Colors.black : Colors.white,
    //     text: item.title,
    //     style: theme.style14W800,
    //     text2: Provider.of<MainModel>(context,listen:false).localAppSettings.getDateTimeString(item.time),
    //     style2: theme.style12W600Grey,
    //     text3: item.body,
    //     style3: theme.style14W400,
    //     shadow: false,
    //     callback: () async {
    //       await Provider.of<MainModel>(context,listen:false).deleteMessage(item);
    //       setState(() {
    //       });
    //     },
    //   ),);
    //   list.add(SizedBox(height: 20,));
    //   _empty = false;
    // }

    if (_empty) {
      // list.add(Center(child: Image.asset("assets/nofound.png")));
      // list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
      list.add(Center(child: Container(
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: serviceApp.notifyNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        Image.network(
            serviceApp.notifyNotFoundImage,
            fit: BoxFit.contain),))); //Image.asset("assets/nofound.png")));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 120,));

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ListView(
        children: list,
      ),
    );
  }
}

