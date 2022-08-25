
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'strings.dart';
import 'theme.dart';

class HomeScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const HomeScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
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
                                child: Stack(
                                  children: [
                                    FlexibleSpaceBar(
                                        collapseMode: CollapseMode.pin,
                                        background: _title(),
                                        titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                        title: _titleSmall()
                                    )
                                  ],
                                )),
                          ))
                    ];
                  },
                  body: Container(
                      width: windowWidth,
                      height: windowHeight,
                      child: Stack(
                        children: [
                          _body(),
                          // if (_wait)
                          //   Center(child: Container(child: Loader7(color: serviceApp.mainColor,))),
                        ],
                      )),
                ),

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
              child: serviceApp.logoAsset ? Image.asset("assets/ondemands/ondemand23.png", fit: BoxFit.cover) :
              Image.network(
                  serviceApp.logo,
                  fit: BoxFit.cover)
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
        padding: EdgeInsets.only(bottom: _scroller, left: 20, right: 20, top: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(93), /// "Home services",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(94), /// Find what you need
                style: theme.style10W600Grey),
          ],
        )
    );
  }

  _body(){
    List<Widget> list = [];

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Edit26(
        hint: strings.get(95), /// "Search service",
        color: (darkMode) ? Colors.black : Colors.white,
        style: theme.style14W400,
        decor: decor,
        useAlpha: false,
        icon: Icons.search,
        controller: _controllerSearch,
        onTap: (){
          Future.delayed(const Duration(milliseconds: 500), () {
            _scrollController.jumpTo(96);
          });
        },
        onChangeText: (String val){
          _scrollController.jumpTo(96);
        },
      ),),
    );

    list.add(SizedBox(height: 20,));

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((e) {
            var _tag = UniqueKey().toString();
            return Container(
                width: windowWidth/2-20,
                height: windowWidth*0.25,
                child: Hero(
                  tag: _tag,
                  child: button157(getTextByLocale(e.name, _mainModel.currentEmulatorLanguage), e.color, e.serverPath, (){

                  }, windowWidth/2-20, windowWidth*0.25),
                ));
          }).toList(),
        )));

    list.add(SizedBox(height: 30,));

    for (var item in categories) {
      list.add(Container(
          child: Container(
            color: item.color.withAlpha(20),
            width: windowWidth - 20,
            height: 60,
            child: button157(getTextByLocale(item.name, _mainModel.currentEmulatorLanguage), item.color, item.serverPath, () {},
                windowWidth - 20, 60),
          )
      )
      );
      list.add(_horizontal(item));
      list.add(SizedBox(height: 20,));
    }

    list.add(SizedBox(height: 150,));
    return Container(
      child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
      );
  }

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

  //
  // Services
  //
  _horizontal(CategoryData parent) {
    List<Widget> list = [];
    var index = 0;
    for (var item in product) {
      if (!item.category.contains(parent.id))
        continue;
      var _tag = UniqueKey().toString();
      list.add(Hero(
          tag: _tag,
          child: Container(
              width: windowWidth*0.7,
              height: windowWidth*0.7*0.7,
              child: button202(getTextByLocale(item.name, _mainModel.currentEmulatorLanguage), theme.style16W800,
                strings.get(132), theme.style12W600Grey,                                    /// "start from"
                getPriceString(item.getMinPrice()),
                theme.style16W800Orange,
                4, Colors.orangeAccent, (darkMode) ? Colors.black : Colors.white,
                item.gallery.isNotEmpty ? item.gallery[0].serverPath : "", windowWidth-20, windowWidth/2-20, 20, (){

                },))
      ));
      index++;
      if (index >= 10)
        break;
    }
    return Container(
      height: windowWidth*0.7*0.7,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }
}
