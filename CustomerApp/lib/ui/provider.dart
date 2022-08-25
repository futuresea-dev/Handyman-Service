import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/service_item.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'package:ondemandservice/widgets/horizontal_articles.dart';
import 'package:provider/provider.dart';
import 'strings.dart';

class ProvidersScreen extends StatefulWidget {
  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
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
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
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
              (theme.darkMode) ? Colors.black : Colors.white,
              (theme.darkMode) ? Colors.white : Colors.black,
              (_scroller > 5) ? "" : getTextByLocale(_mainModel.currentProvider.name, strings.locale), context,
              () {
                goBack();
          }),

          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: IconButton(icon: userAccountData.userFavoritesProviders.contains(_mainModel.currentProvider.id)
                ? Icon(Icons.favorite, size: 30,)
                : Icon(Icons.favorite_border, size: 30), color: Colors.orange,
              onPressed: (){
                changeFavoritesProviders(_mainModel.currentProvider);
                _redraw();
              }, ),
          )

        ]);
  }

  _title() {
    var imageUpperServerPath = _mainModel.currentProvider.imageUpperServerPath;
    return Container(
      color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Container(
          width: windowWidth,
          margin: EdgeInsets.only(bottom: 10),
          child: imageUpperServerPath.isNotEmpty ? CachedNetworkImage(
              imageUrl: imageUpperServerPath,
              imageBuilder: (context, imageProvider) => Container(
                child: Container(
                  width: windowHeight * 0.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )),
                ),
              )
          ) : Container()
      ),
    );
  }

  _body(){
    List<Widget> list = [];

    list.add(Container(
        width: windowWidth,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Card50forProvider(
          direction: strings.direction,
          locale: strings.locale,
          category: categories,
          provider: _mainModel.currentProvider,
        )
    ));

    list.add(SizedBox(height: 20,));

    List<Widget> list2 = [];
    if (_mainModel.currentProvider.phone.isNotEmpty)
      list2.add(InkWell(
          onTap: () {
            callMobile(_mainModel.currentProvider.phone);
          }, // needed
          child: UnconstrainedBox(
            child: Container(
                width: 40,
                height: 40,
                child: Image.asset("assets/phone.png",
                    fit: BoxFit.contain
                )
            ),
          )),);

    if (_mainModel.currentProvider.www.isNotEmpty)
      list2.add(InkWell(
          onTap: () {
            openUrl(_mainModel.currentProvider.www);
          }, // needed
          child: UnconstrainedBox(
            child: Container(
                width: 40,
                height: 40,
                child: Image.asset("assets/www.png",
                    fit: BoxFit.contain
                )
            ),
          )),);

    if (_mainModel.currentProvider.instagram.isNotEmpty)
      list2.add(InkWell(
          onTap: () {
            openUrl(_mainModel.currentProvider.instagram);
          }, // needed
          child: UnconstrainedBox(
            child: Container(
                width: 40,
                height: 40,
                child: Image.asset("assets/insta.png",
                    fit: BoxFit.contain
                )
            ),
          )),);

    if (_mainModel.currentProvider.telegram.isNotEmpty)
      list2.add(InkWell(
          onTap: () {
            openUrl(_mainModel.currentProvider.telegram);
          }, // needed
          child: UnconstrainedBox(
            child: Container(
                width: 40,
                height: 40,
                child: Image.asset("assets/tg.png",
                    fit: BoxFit.contain
                )
            ),
          )),);

    if (list2.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        height: 40,
        width: windowWidth - 20,
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 20,
          spacing: 20,
          children: list2,
        ),
      ));

    list.add(SizedBox(height: 20,),);

    if (_mainModel.currentProvider.descTitle.isNotEmpty)
      list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getTextByLocale(_mainModel.currentProvider.descTitle, strings.locale),
                style: theme.style16W800, textAlign: TextAlign.start,),   // "Description",
              Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
              SizedBox(height: 5,),
              Text(getTextByLocale(_mainModel.currentProvider.desc, strings.locale), style: theme.style14W400),
              SizedBox(height: 5,),
              Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
            ],
          )
      ));

    list.add(SizedBox(height: 20,),);

    var index = 0;
    for (var item in _mainModel.currentProvider.workTime){
      if (item.weekend)
        continue;
      list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(child: Text(strings.get(123+index), style: theme.style14W800,),),
              Text(item.openTime, style: theme.style14W400),
              Text("-"),
              Text(item.closeTime, style: theme.style14W400),
            ],
          )));
      list.add(SizedBox(height: 5,));
      index++;
    }
    list.add(SizedBox(height: 20,));

    list.add(Container(
        color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(child: Text(strings.get(100), // "Galleries",
              style: theme.style14W800,)),
            Container(
                width: windowWidth/3,
                height: windowWidth/3,
                child: theme.providerGLogoAsset ? Image.asset("assets/ondemands/ondemand20.png", fit: BoxFit.contain) :
                CachedNetworkImage(
                    imageUrl: theme.providerGLogo,
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
          ],
        )));

    list.add(SizedBox(height: 10,));

    if (_mainModel.currentProvider.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _mainModel.currentProvider.gallery.map((e){
            var _tag = UniqueKey().toString();
            return InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryScreen(item: e, gallery: _mainModel.currentProvider.gallery,
                          tag: _tag, textDirection: strings.direction,),
                      )
                  );
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
                      // )
                    )));
          }).toList(),
        ),
      ));

    list.add(SizedBox(height: 20,));

    // list.add(Container(
    //     color: (darkMode) ? blackColorTitleBkg : colorBackground,
    //     padding: EdgeInsets.only(left: 20, right: 20),
    //     child: Row(
    //       children: [
    //         Expanded(child: Column(
    //           children: [
    //             Text(strings.get(101), // "Reviews & Ratings"
    //               style: theme.style14W800,),
    //             SizedBox(height: 20,),
    //             Row(children: [
    //               card51(4, Colors.orange, 20),
    //               Text("4.0", style: theme.style12W600Orange, textAlign: TextAlign.center,),
    //               SizedBox(width: 5,),
    //               Text("(1)", style: theme.style14W800, textAlign: TextAlign.center,),
    //             ],),
    //           ],
    //         )),
    //         Container(
    //             width: windowSize*0.4,
    //             child: Image.asset("assets/ondemands/ondemand19.png",
    //                 fit: BoxFit.contain
    //             )
    //         ),
    //       ],
    //     )));
    //
    // list.add(SizedBox(height: 10,));

    // list.add(Container(
    //     margin: EdgeInsets.only(left: 10, right: 10),
    //     child: Column(
    //       children: [
    //
    //         card47("assets/user1.jpg",
    //             "Carter Anne", theme.style16W800,
    //             "20 Dec 2021", theme.style12W600Grey,
    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ",
    //             theme.style14W400,
    //             false, (darkMode) ? blackColorTitleBkg : colorBackground,
    //             ["assets/barber/1.jpg", "assets/barber/2.jpg", "assets/barber/3.jpg",],
    //             3, Colors.orange
    //         ),
    //
    //       ],
    //     )));

    if (ifProviderHaveArticles(_mainModel.currentProvider.id)){
      list.add(Container(
          color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
          padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
          child: Row(
            children: [
              Expanded(child: Text(strings.get(261), /// "Provider products",
                style: theme.style13W800,)),
            ],
          )));
      list.add(SizedBox(height: 20,));
      list.add(articleHorizontalBar(_mainModel.currentProvider.id,
          windowWidth, context, _mainModel));
    }


    list.add(Container(
        color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Text(strings.get(260), /// "Services",
              style: theme.style14W800,),
    ));

    list.add(SizedBox(height: 10,));

    for (var item in product) {
      print("item.id=${item.id} != _mainModel.currentProvider.id=${_mainModel.currentProvider.id}");
      if (!item.providers.contains(_mainModel.currentProvider.id))
        continue;
      list.add(serviceItem(item, _mainModel, windowWidth));
      list.add(Container(
        height: 5,
        color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      ));
    }

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  void _redraw() {
    if (mounted)
      setState(() {
      });
  }
}

