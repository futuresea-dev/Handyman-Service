
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'theme.dart';

class DocumentsScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const DocumentsScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Scaffold(
        backgroundColor: (darkMode) ? Colors.black : Colors.white,
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
                              color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
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
                    child: SingleChildScrollView(child: _body(),),
                  ),
                ),
                appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black,
                    "", context, () {}),

              ]),
        ));
  }

  _title() {
    return Container(
      color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth/2,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              width: windowWidth*0.3,
              child: serviceApp.documentsLogoAsset ? Image.asset("assets/ondemands/ondemand15.png", fit: BoxFit.contain) :
              Image.network(
                  serviceApp.documentsLogo,
                  fit: BoxFit.contain)
              // Image.asset("assets/ondemands/ondemand15.png", fit: BoxFit.cover),
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          ),
        ],
      ),
    );
  }

  _titleSmall(){
    var _text1 = strings.get(14); /// "Privacy Policy",
    var _text2 = strings.get(15); /// "Known our Privacy Policy",
    // if (widget.source == "about"){
    //   _text1 = strings.get(146); /// "About Us",
    //   _text2 = strings.get(147); /// "Known About Us",
    // }
    // if (widget.source == "terms"){
    //   _text1 = strings.get(148); /// "Terms & Conditions",
    //   _text2 = strings.get(149); /// "Known Terms & Conditions",
    // }
    return Container(
        alignment: Alignment.bottomLeft,
      width: windowWidth*0.4,
      padding: EdgeInsets.only(bottom: _scroller, left: 15, right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(fit: BoxFit.scaleDown, child: Text(_text1, style: theme.style16W800,)),
          SizedBox(height: 3,),
          FittedBox(fit: BoxFit.scaleDown, child: Text(_text2, style: theme.style10W600Grey)),
      ],
    )
    );
  }

  final String _data = "<h2>Lorem ipsum dolor</h2> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et "
      "dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
      "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
      "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      "<br><br>"
      "<h2>Lorem ipsum dolor</h2> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et "
      "dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
      "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
      "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  _body(){
    //var _data = "";
    // if (widget.source == "policy")
    //   _data = Provider.of<MainModel>(context,listen:false).localAppSettings.policy;
    // if (widget.source == "about")
    //   _data = Provider.of<MainModel>(context,listen:false).localAppSettings.about;
    // if (widget.source == "terms")
    //   _data = Provider.of<MainModel>(context,listen:false).localAppSettings.terms;

    return Container(
      margin: EdgeInsets.all(15),
      child: Html(
        data: "<body>$_data",
        style: {
          "body": Style(
            backgroundColor: (darkMode) ? Colors.black : Colors.white,
            color: (darkMode) ? Colors.white : Colors.black
          ),
           }
      ),
    );
  }
}

