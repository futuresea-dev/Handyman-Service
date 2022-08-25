
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/appService/screens/theme.dart';
import 'package:ondemand_admin/widgets/buttons/button1.dart';
import '../../../model/model.dart';
import 'strings.dart';

class ServicesScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const ServicesScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  late MainModel _mainModel;

  @override
  void dispose() {
    _controllerSearch.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Container(
      color: (darkMode) ? Colors.black : Colors.white,
      width: windowWidth,
      height: windowHeight,
      child: _body2(),
    );
  }

  _body2(){
    return Stack(
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
              (_scroller > 5) ? "" : getTextByLocale(currentProduct.name, _mainModel.currentEmulatorLanguage), context, () {}),

          Container(
            alignment: Alignment.bottomCenter,
            child: button1a(strings.get(102), /// "Book This Service"
                theme.style16W800White,
                serviceApp.mainColor, (){}, true),
          ),

        ]);
  }

  _title() {
    var _data = currentProduct.gallery.isNotEmpty ? currentProduct.gallery[0] : ImageData();
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
              child: _data.serverPath.isNotEmpty ? Image.network(_data.serverPath, fit: BoxFit.cover) : Container()
            )),
        ],
      ),
    );
  }

  _body(){
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    List<Widget> list3 = [];
    list3.add(card51(4, serviceApp.serviceStarColor, 16),);
    list3.add(SizedBox(width: 20,));
    getPriceText(Provider.of<MainModel>(context,listen:false).service.getPrice(), list3, context);

    list.add(
      Column(
        children: [
          Text(getTextByLocale(currentProduct.name, _mainModel.currentEmulatorLanguage),
              style: theme.style14W800),                       /// name
          SizedBox(height: 5,),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: list3
            // [
              // card51(4, Colors.orange, 16),
              // SizedBox(width: 20,),
              //Text(Provider.of<MainDataModel>(context,listen:false).getPrice(), style: theme.style16W800Green,),
            // ],
          )
        ],
      )
    );
    list.add(SizedBox(height: 40,));

    bool yesSelect = false;
    for (var item in currentProduct.price)
      if (item.selected)
        yesSelect = true;
    if (!yesSelect){
      bool first = true;
      for (var item in currentProduct.price) {
        if (first) {
          first = false;
          item.selected = true;
        }else
          item.selected = false;
      }
    }

    for (var item in currentProduct.price){
      List<Widget> list2 = [];
      list2.add((item.image.serverPath.isNotEmpty) ?
      Container(
          width: 30,
          height: 30,
          child: Image.network(item.image.serverPath, fit: BoxFit.contain))
          : Container(
          width: 30,
          height: 30));
      list2.add(SizedBox(width: 10,));
      list2.add(Expanded(child: Text(getTextByLocale(item.name, _mainModel.currentEmulatorLanguage),
          style: theme.style14W400)));
      list2.add(SizedBox(width: 5,));
      getPriceText(item, list2, context);
      list.add(InkWell(
        onTap: (){
          for (var item in currentProduct.price)
            item.selected = false;
          item.selected = true;
          setState(() {
          });
        },
          child: Container(
        color: (item.selected) ? Colors.grey.withAlpha(60) : Colors.transparent,
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          child: Row(children: list2))
      ));
    }

    if (currentProduct.price.isNotEmpty) {
      list.add(Divider(color: Colors.grey.withAlpha(100)));
      list.add(SizedBox(height: 20,));
    }

    if (currentProduct.descTitle.isNotEmpty){
      list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: (darkMode) ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getTextByLocale(currentProduct.descTitle, _mainModel.currentEmulatorLanguage),
                style: theme.style16W800, textAlign: TextAlign.start,),   /// "Description",
              Divider(color: (darkMode) ? Colors.white : Colors.black),
              SizedBox(height: 5,),
              Text(getTextByLocale(currentProduct.desc, _mainModel.currentEmulatorLanguage), style: theme.style14W400),
              SizedBox(height: 5,),
              Divider(color: (darkMode) ? Colors.white : Colors.black),
            ],
          )
      ));
      list.add(SizedBox(height: 30,));
    }

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
      children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.get(97),                                                 /// "Duration",
              style: theme.style14W800,),
            Text(strings.get(99),                                                 /// "This service can take up to",
              style: theme.style14W400,)
          ],
        )),
        Text("${currentProduct.duration.inMinutes} ${strings.get(98)}", style: theme.style16W800,) /// min
      ],
    ),));

    list.add(SizedBox(height: 20,),);

    list.add(Container(
        color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(child: Text(strings.get(100), /// "Galleries",
              style: theme.style14W800,)),
            Container(
                width: windowWidth/2,
                child: serviceApp.serviceGLogoAsset ? Image.asset("assets/ondemands/ondemand20.png", fit: BoxFit.contain) :
                Image.network(
                    serviceApp.serviceGLogo,
                    fit: BoxFit.contain)
                // Image.asset("assets/ondemands/ondemand20.png",
                //     fit: BoxFit.contain
                // )
            ),
          ],
        )));

    list.add(SizedBox(height: 10,));

    if (currentProduct.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: currentProduct.gallery.map((e){
            var _tag = UniqueKey().toString();
            return InkWell(
                onTap: (){
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => GalleryScreen(item: e, gallery: images, tag: _tag),
                  //     )
                  // );
                },
                child: Hero(
                    tag: _tag,
                    child: Container(
                        width: windowWidth/3-20,
                        height: windowWidth/3-20,
                        child: Image.network(e.serverPath, fit: BoxFit.cover)
                        // (e.name != null) ?
                        // Image.asset(e.name!, fit: BoxFit.cover) :
                        // Image.memory(e.image!, fit: BoxFit.cover)
                    )));
          }).toList(),
        ),
      ));

    list.add(SizedBox(height: 20,));

    list.add(Container(
        color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(child: Column(
              children: [
                Text(strings.get(101), /// "Reviews & Ratings"
                  style: theme.style14W800,),
                SizedBox(height: 20,),
                Row(children: [
                  card51(4, serviceApp.serviceStarColor, 10),
                  Text("4.0", style: theme.style12W600Stars, textAlign: TextAlign.center,),
                  SizedBox(width: 5,),
                  Text("(1)", style: theme.style14W800, textAlign: TextAlign.center,),
                ],),
              ],
            )),
            Container(
                width: windowWidth*0.4,
                child: serviceApp.serviceRLogoAsset ? Image.asset("assets/ondemands/ondemand19.png", fit: BoxFit.contain) :
                    Image.network(
                        serviceApp.serviceRLogo,
                        fit: BoxFit.contain)
                // Image.asset("assets/ondemands/ondemand19.png",
                //     fit: BoxFit.contain
                // )
            ),
          ],
        )));

    list.add(SizedBox(height: 10,));

    // list.add(Container(
    //     margin: EdgeInsets.only(left: 10, right: 10),
    //     child: Column(
    //       children: [
    //         card47("assets/user1.jpg",
    //             "Carter Anne",
    //             "20 Dec 2021",
    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ",
    //             ["assets/1.jpg", "assets/2.jpg", "assets/3.jpg"],
    //             3, color: serviceApp.serviceStarColor
    //         ),
    //       ],
    //     )));


    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

}

