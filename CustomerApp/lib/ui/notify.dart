import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:provider/provider.dart';
import 'strings.dart';
import 'theme.dart';

class NotifyScreen extends StatefulWidget {
  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  String _searchText = "";
  late MainModel _mainModel;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final _controllerSearch = TextEditingController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    updateNotifyPage = _loadMessages;
    _loadMessages();
    userNotificationsSetToRead();
    super.initState();
  }

  _loadMessages() async {
    _waits(true);
    var ret = await loadMessages();
    if (ret != null)
      messageError(context, ret);
    _waits(false);
    setNumberOfUnreadMessages(0);
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
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
    updateNotifyPage = null;
    _scrollController.dispose();
    _controllerSearch.dispose();
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
                    body: Stack(
                      children: [
                        Container(
                          width: windowWidth,
                          height: windowHeight,
                          child: _body(),
                        ),
                        if (_wait)
                          Center(child: Container(child: Loader7v1(color: theme.mainColor,))),
                      ],
                    )
                ),

                if (_mainModel.currentPage != "notify")
                appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                    "", context, () {goBack();})

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
              height: windowWidth*0.3,
              //child: Image.asset("assets/ondemands/ondemand17.png", fit: BoxFit.cover),
              child: theme.notifyLogoAsset ? Image.asset("assets/ondemands/ondemand17.png", fit: BoxFit.contain) :
              CachedNetworkImage(
                  imageUrl: theme.notifyLogo,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
              ),
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
        color: (theme.darkMode) ? Colors.black : Colors.white,
        style: theme.style14W400,
        icon: Icons.search,
        useAlpha: false,
        decor: decor,
        controller: _controllerSearch,
        onChangeText: (String value){
          _searchText = value;
          setState(() {
          });
        }
    ));

    list.add(SizedBox(height: 20,));

    //
    //
    //
    int _count = 0;
    var _now = DateFormat('dd MMMM').format(DateTime.now());

    for (var item in messages){
      if (_searchText.isNotEmpty)
        if (!item.title.toUpperCase().contains(_searchText.toUpperCase()))
          if (!item.body.toUpperCase().contains(_searchText.toUpperCase()))
            continue;
      var time = DateFormat('dd MMMM').format(item.time);
      if (time == _now)
        time = strings.get(145); /// Today
      list.add(Card48(
        text: item.body,
        text2: appSettings.getDateTimeString(item.time),
        text3: item.title,
        callback: () async {
          await deleteMessage(item);
          _redraw();
        },
      ),);
      list.add(SizedBox(height: 20,));
      _count++;
    }

    if (_count == 0) {
      list.add(Center(child:
      Container(
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.notifyNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.notifyNotFoundImage,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            )
        ),
      ),
      ));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(150), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 120,));

    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return _loadMessages();
          },
        child: Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ListView(
        children: list,
      ),
    ));
  }
}

