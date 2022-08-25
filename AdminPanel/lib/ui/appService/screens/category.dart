import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'package:ondemand_admin/model/model.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {

  final double windowWidth;
  final double windowHeight;
  const CategoryScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

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
                            color: currentCategory.color,
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
                child: _body(),
              ),
            ),

            appbar1(Colors.transparent, (darkMode) ? Colors.white : Colors.black,
                "", context, () {})

          ]),
      ));
  }

  _title() {
    return Container(
      color: (darkMode) ? serviceApp.blackColorTitleBkg : serviceApp.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Stack(
        children: [

          Container(
                color: currentCategory.color,
                alignment: Alignment.bottomRight,
                child: Container(
                  width: windowWidth*0.3,
                  margin: EdgeInsets.only(bottom: 10),
                  child: currentCategory.serverPath.isNotEmpty ? Image.network(
                    currentCategory.serverPath,
                      fit: BoxFit.contain,
                  ) : Container(),

                  //Image.asset(widget.data.image, fit: BoxFit.cover),
                )),
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
            Text(getTextByLocale(currentProduct.name, _mainModel.currentEmulatorLanguage),
              style: theme.style16W800,),
            SizedBox(height: 10,),
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
        onChangeText: (String val){
            _scrollController.jumpTo(96);
            // _searchText = val;
        },
        onTap: (){
          Future.delayed(const Duration(milliseconds: 500), () {
            _scrollController.jumpTo(96);
          });
        },
      ),),
    );

    list.add(SizedBox(height: 20,));
    var count = 0;
    for (var item in product) {

      var _prov = getProviderById(item.providers[0]);
      _prov ??= ProviderData.createEmpty();

      var _tag = UniqueKey().toString();
      list.add(InkWell(onTap: (){_openDetails(_tag, item);},
          child: Hero(
              tag: _tag,
              child: Container(
                  width: windowWidth,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Card50(item: item,
                    locale: _mainModel.currentEmulatorLanguage,
                    category: categories,
                    direction: strings.direction,
                    providerData: _prov,
                  ),

                  // Card50(
                  //   text: getTextByLocale(item.name, _mainModel.currentEmulatorLanguage),
                  //   style: theme.style16W800,
                  //   text2: item.rating.toStringAsFixed(1),
                  //   style2: theme.style12W600StarsCategory,
                  //   text3: "(${item.count.toString()})",
                  //   style3: theme.style12W800,
                  //   text4: _mainModel.service.getServiceMinPrice(item),
                  //   style4: theme.style18W800Orange,
                  //   text5: _mainModel.provider.getProviderAddress(item.providers.isNotEmpty ? item.providers[0] : ""),
                  //   style5: theme.style12W400,
                  //   icon: Icon(Icons.location_on_outlined, color: serviceApp.categoryStarColor, size: 15,),
                  //   data: _mainModel.category.getServiceCategories(item.category, context),
                  //   styleData: theme.style12W600White,
                  //   color: (darkMode) ? Colors.black : Colors.white,
                  //   shadow: false,
                  //   radius: 10,
                  //   stars: item.rating.toInt(),
                  //   starsColor: serviceApp.categoryStarColor,
                  //   badgetColor: serviceApp.categoryBoardColor,
                  //   image: item.gallery.isNotEmpty ? Image.network(
                  //       item.gallery[0].serverPath,
                  //       fit: BoxFit.cover,
                  //   ) : Container(),
                  //   shadowText: "",
                  // )
              ))));

      list.add(SizedBox(height: 20,));
      count++;
      if (count == 2)
        break;
    }

    // list.add(Container(
    //     width: windowWidth,
    //     margin: EdgeInsets.only(left: 10, right: 10),
    //     child: Card50(
    //         text: "Thai Massage Service",
    //         style: theme.style16W800,
    //         text2: "2.0",
    //         style2: theme.style12W600Orange,
    //         text3: "(1)",
    //         style3: theme.style12W800,
    //         text4: "\$12",
    //         style4: theme.style18W800Orange,
    //         text5: "6878 Gregory Street",
    //         style5: theme.style12W400,
    //         icon: Icon(Icons.location_on_outlined, color: Colors.orange, size: 15,),
    //         data: ["Electrician", "Gardening", "Carpenter", "Painter"],
    //         styleData: theme.style12W600White,
    //         color: (onDemandDarkMode) ? Colors.black : Colors.white,
    //         shadow: false,
    //         radius: 10,
    //         stars: 2,
    //         starsColor: Colors.orange,
    //         badgetColor: Colors.green,
    //         image: "assets/ondemands/ondemand22.jpg",
    //         shadowText: "offline",
    //         shadowTextStyle: theme.style12W600White,
    //         shadowColor: Colors.black
    //     )));
    //
    // list.add(SizedBox(height: 20,));
    //
    // list.add(Container(
    //     width: windowWidth,
    //     margin: EdgeInsets.only(left: 10, right: 10),
    //     child: Card50(
    //         text: "Movers Mans",
    //         style: theme.style16W800,
    //         text2: "5.0",
    //         style2: theme.style12W600Orange,
    //         text3: "(4)",
    //         style3: theme.style12W800,
    //         text4: "\$25",
    //         style4: theme.style18W800Orange,
    //         text5: "6878 Gregory Street",
    //         style5: theme.style12W400,
    //         icon: Icon(Icons.location_on_outlined, color: Colors.orange, size: 15,),
    //         data: ["Electrician", "Carpenter", "Painter"],
    //         styleData: theme.style12W600White,
    //         color: (onDemandDarkMode) ? Colors.black : Colors.white,
    //         shadow: false,
    //         radius: 10,
    //         stars: 2,
    //         starsColor: Colors.orange,
    //         badgetColor: Colors.green,
    //         image: "assets/ondemands/ondemand23.jpg",
    //         shadowText: "",
    //     )));
    //
    // list.add(SizedBox(height: 20,));
    //
    // list.add(Container(
    //     width: windowWidth,
    //     margin: EdgeInsets.only(left: 10, right: 10),
    //     child: Card50(
    //         text: "Thai Massage Service",
    //         style: theme.style16W800,
    //         text2: "2.0",
    //         style2: theme.style12W600Orange,
    //         text3: "(1)",
    //         style3: theme.style12W800,
    //         text4: "\$12",
    //         style4: theme.style18W800Orange,
    //         text5: "6878 Gregory Street",
    //         style5: theme.style12W400,
    //         icon: Icon(Icons.location_on_outlined, color: Colors.orange, size: 15,),
    //         data: ["Electrician", "Gardening", "Carpenter", "Painter"],
    //         styleData: theme.style12W600White,
    //         color: (onDemandDarkMode) ? Colors.black : Colors.white,
    //         shadow: false,
    //         radius: 10,
    //         stars: 2,
    //         starsColor: Colors.orange,
    //         badgetColor: Colors.green,
    //         image: "assets/ondemands/ondemand22.jpg",
    //         shadowText: "",
    //     )));

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  _openDetails(String _tag, ProductData item){

  }
}
