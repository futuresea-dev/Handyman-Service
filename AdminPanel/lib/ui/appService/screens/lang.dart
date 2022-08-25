
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/widgets/buttons/button2.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  final bool openLogin;
  final Function()? redraw;
  final double windowWidth;
  final double windowHeight;

  const LanguageScreen({Key? key, this.openLogin = true, this.redraw, required this.windowWidth, required this.windowHeight}) : super(key: key);
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
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
                  body: Container(
                    width: windowWidth,
                    height: windowHeight,
                    child: _body(),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.all(20),
                  child: button2s(strings.get(2), // "SUBMIT",
                      theme.style16W800White, serviceApp.mainColor, 50, (){_submit();}, true),
                )
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
              child: serviceApp.langLogoAsset ? Image.asset("assets/ondemands/ondemand3.png", fit: BoxFit.cover) :
              Image.network(
                  serviceApp.langLogo,
                  fit: BoxFit.cover)
              //Image.asset("assets/ondemands/ondemand3.png", fit: BoxFit.cover),
            ),
            margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          ),
        ],
      ),
    );
  }

  _titleSmall(){
    return Container(
      padding: EdgeInsets.only(bottom: _scroller),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(3), // "Language",
              style: theme.style16W800,),
            SizedBox(height: 3,),
            Text(strings.get(4), // "Preferred Language",
                style: theme.style10W600Grey),
          ],
        )
    );
  }

  _body(){
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
        children: _children(),
      ),
    );
  }

  _children() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(5), // "Select Preferred Language",
         style: theme.style18W800));
    list.add(SizedBox(height: 20,));
    list.add(_radioGroup());
    list.add(SizedBox(height: 200,));
    return list;
  }

  _radioGroup(){
    List<Widget> list = [];

    for (var item in _mainModel.serviceAppLangs)
      list.add(ListTile(
          title: Text(
            item.name, style: theme.style14W800,
          ),
          leading: Radio(
            value: item.locale,
            groupValue: appSettings.defaultServiceAppLanguage,
            activeColor: serviceApp.mainColor,
            onChanged: (String? value) {
              if (value == null)
                return;
              //Provider.of<MainDataModel>(context,listen:false).setLang(value);
              setState(() {
              });
            },
          )));

    return Theme(
        data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.grey
    ),
    child: Column(
      children: list
    ));
  }

  _submit() async {
    if (widget.openLogin)
      Navigator.pushNamed(context, "/ondemandservice_main");
    else
      Navigator.pop(context);
    if (widget.redraw != null)
      widget.redraw!();
  }
}

