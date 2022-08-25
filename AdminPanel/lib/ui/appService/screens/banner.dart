import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class BannerScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;
  const BannerScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  // String _searchText = "";
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final _controllerSearch = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _mainModel = Provider.of<MainModel>(context, listen: false);
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

                _body(),

                appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black,
                    "", context, () {})

              ]),
        ));
  }

  List<BannerData> _banners = [];

  _body(){
    List<Widget> list = [];

    list.add(SizedBox(height: 100,));

    if (_mainModel.banner.banners.isNotEmpty){
      _banners = [];
      for (var item in _mainModel.banner.banners)
        if (item.visible)
          _banners.add(item);
      list.add(IBanner(
        _banners,
        key: _mainModel.banner.dataKey,
        width: windowWidth,// * 0.95,
        height: windowWidth*0.5, // * 0.95*0.6,
        colorActive: serviceApp.mainColor,
        colorProgressBar: serviceApp.mainColor,
        radius: 10,
        shadow: 0,
        style: theme.style16W400,
        callback: (String id, String heroId, String image){},
        seconds: 3,
      ));
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

