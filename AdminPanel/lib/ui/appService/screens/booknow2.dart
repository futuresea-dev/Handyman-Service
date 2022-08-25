
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/widgets/buttons/button1.dart';
import 'theme.dart';

class BookNow2Screen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;
  const BookNow2Screen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _BookNow2ScreenState createState() => _BookNow2ScreenState();
}

class _BookNow2ScreenState extends State<BookNow2Screen> {

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

            if (!_booking)
            Container(
              alignment: Alignment.bottomCenter,
              child: button1a(strings.get(46), /// "CONTINUE"
                  theme.style16W800White,
                  serviceApp.mainColor, (){
                    // widget.callback("book3");
                  }, true),
            ),

            // IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
            //   body: _dialogBody, backgroundColor: (darkMode) ? Colors.black : Colors.white,),


          ]),
    ));
  }

  final bool _booking = false;
  // double _show = 0;
  // Widget _dialogBody = Container();

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
                // margin: EdgeInsets.only(bottom: 10),
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

    list.add(Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        children: [
          Text(strings.get(111), style: theme.style14W800,), // "Requested Service on",
          SizedBox(height: 10,),

          Text(strings.get(109), /// "Any Time",
            // : Provider.of<MainModel>(context,listen:false).localAppSettings.getDateTimeString(localSettings.selectTime),
            style: theme.style18W800,),
        ],
      ),
    ));

    list.add(Container(
        color: (darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(103), /// "Your address",
                  style: theme.style16W800, textAlign: TextAlign.start,),
            Divider(color: (darkMode) ? Colors.white : Colors.black),
            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.orange),
                SizedBox(width: 10,),
                Expanded(child: Text("address", style: theme.style14W400,))
              ],
            ),
            SizedBox(height: 10,),
          ],
        )
    ));

    list.add(SizedBox(height: 10,));

    list.add(Container(
      color: (darkMode) ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.get(105), // "Hint",
            style: theme.style16W800, textAlign: TextAlign.start,),
          Divider(color: (darkMode) ? Colors.white : Colors.black),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(Icons.comment, color: Colors.orange),
              SizedBox(width: 10,),
              Text("hint", style: theme.style14W400,)
            ],
          ),
          SizedBox(height: 10,),
        ],
      )
    ));

    list.add(SizedBox(height: 10,));

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
