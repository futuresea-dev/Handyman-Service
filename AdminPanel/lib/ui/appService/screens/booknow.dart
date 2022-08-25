
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/widgets/buttons/button1.dart';
import 'theme.dart';

class BookNowScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const BookNowScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  final _editControllerHint = TextEditingController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    // _editControllerHint.text = localSettings.hint;
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
                "", context,
                    () {}),

            Container(
              alignment: Alignment.bottomCenter,
              child: button1a(strings.get(46), // "CONTINUE"
                  theme.style16W800White,
                  serviceApp.mainColor, _book, true),
            ),

          ])),
    );
  }

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
                  margin: EdgeInsets.only(bottom: 10),
                  // child: CachedNetworkImage(
                  //     imageUrl: _data.serverPath,
                  //     imageBuilder: (context, imageProvider) => Container(
                  //       width: double.maxFinite,
                  //       alignment: Alignment.bottomRight,
                  //       child: Container(
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(strings.get(103), /// "Your address",
                  style: theme.style16W800, textAlign: TextAlign.start,)),
                Container(
                  width: 100,
                  child: button2(strings.get(104), // "Add new",
                      serviceApp.mainColor, _addnew),
                ),
              ],
            ),
            Divider(color: (darkMode) ? Colors.white : Colors.black),
            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.orange),
                SizedBox(width: 10,),
                Expanded(child: _addresses())
              ],
            ),
            //SizedBox(height: 10,),
          ],
        )
    ));

    list.add(SizedBox(height: 10,));

    list.add(Container(
      color: (darkMode) ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: edit42(strings.get(105), /// "Hint",
          _editControllerHint,
          strings.get(106), /// "Is there anything else",
          ),
    ));

    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: (darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: checkBox43(strings.get(109), /// "Any Time",
          serviceApp.booking1CheckBoxColor, "",
          theme.style14W800, false, (val) {

          }),
    ));

    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: (darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: checkBox43(strings.get(110), /// "Schedule an Order",
          serviceApp.booking1CheckBoxColor, "",
          theme.style14W800, true, (val) {
            // localSettings.scheduleTime = val;
            // if (localSettings.scheduleTime)
            //   localSettings.anyTime = false;
            // setState(() {
            // });
          }),
    ));

    list.add(SizedBox(height: 20,));

    // if (localSettings.scheduleTime)
      list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
        children: [
          Expanded(child: button2(strings.get(112), // "Select a Date & Time",
              serviceApp.mainColor, _dateTime)),
        ],
      )));

    list.add(SizedBox(height: 10,));

    // if (localSettings.scheduleTime)
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Column(
          children: [
            Text(strings.get(111), style: theme.style14W800,), /// "Requested Service on",
            SizedBox(height: 10,),
            Text(DateTime.now().toString(),
              style: theme.style18W800,),
          ],
        ),
      ));

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  _dateTime(){
    // var widget = CupertinoDatePicker(
    //   onDateTimeChanged: (DateTime picked) {
    //     localSettings.selectTime = picked;
    //     setState(() {
    //     });
    //   },
    //   mode: CupertinoDatePickerMode.dateAndTime,
    //   use24hFormat: Provider.of<MainModel>(context,listen:false).localAppSettings.timeFormat == "24h",
    //   initialDateTime: DateTime.now().add(Duration(minutes: 1)),
    //   minimumDate: DateTime.now()
    // );
    //
    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext builder) {
    //       return widget;
    //     });
  }

  _addnew(){
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddAddressScreen(redraw: _redraw2,),
    //   ),
    // );
  }

  // _redraw2(){
  //   // _redraw();
  //   // _scrollController2.animateTo(_scrollController2.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeOut,);
  // }
  //
  // _redraw(){
  //   if (mounted)
  //     setState(() {
  //     });
  // }

  Widget _addresses(){
    // if (localSettings.currentAddress.isEmpty && localSettings.address.isNotEmpty)
    //   localSettings.currentAddress = localSettings.address[0];
    List<Widget> list = [];
    // for (var item in localSettings.address) {
      list.add(
          InkWell(onTap: (){
            // localSettings.setCurrentAddress(item);
            // _redraw();
          },
          child: Container(
          color: Colors.blue.withAlpha(50),
        width: windowWidth*0.6,
        padding: EdgeInsets.all(10),
        child: Text("address", style: theme.style14W400,),
      )));
    // }
    list.add(SizedBox(width: 10,));
    return Container(
      height: 40,
      child: ListView(
        controller: _scrollController2,
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _book(){

    // if (localSettings.currentAddress.isEmpty)
    //   return messageError(context, strings.get(134));  /// "Please select address",
    //
    // localSettings.setHint(_editControllerHint.text);
    //
    // widget.callback("book1");
  }

}
