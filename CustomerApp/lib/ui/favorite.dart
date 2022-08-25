import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/service_item.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  String _searchText = "";
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

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {goBack();})

          ]),
      ));
  }

  _title() {
    return Container(
      color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Stack(
        children: [
          Container(
                color: (theme.darkMode) ? Colors.black : Colors.white,
                alignment: Alignment.bottomRight,
                child: Container(
                  width: windowWidth*0.3,
                  margin: EdgeInsets.only(bottom: 10),
                  child: _mainModel.categoryData.serverPath.isNotEmpty ? CachedNetworkImage(
                      imageUrl: _mainModel.categoryData.serverPath,
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.maxFinite,
                        alignment: Alignment.bottomRight,
                        child: Container(
                          //width: height,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              )),
                        ),
                      )
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
            Text(strings.get(170), /// "Your Favorites",
              style: theme.style16W800,),
            //SizedBox(height: 10,),
            // Text(strings.get(171), /// "View your favorite services",
            //   style: theme.style12W400,),
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
        color: (theme.darkMode) ? Colors.black : Colors.white,
        style: theme.style14W400,
        decor: decor,
        useAlpha: false,
        icon: Icons.search,
        controller: _controllerSearch,
        onChangeText: (String val){
            _scrollController.jumpTo(96);
            _searchText = val;
        },
        onTap: (){
          Future.delayed(const Duration(milliseconds: 500), () {
            _scrollController.jumpTo(96);
          });
        },
      ),),
    );

    list.add(SizedBox(height: 20,));

    var _count = 0;
    for (var item in product) {
      if (!userAccountData.userFavorites.contains(item.id))
        continue;
      if (_searchText.isNotEmpty)
        if (!getTextByLocale(item.name, strings.locale).toUpperCase().contains(_searchText.toUpperCase()))
          continue;

      list.add(serviceItem(item, _mainModel, windowWidth));

      // var _prov = getProviderById(item.providers[0]);
      // _prov ??= ProviderData.createEmpty();
      //
      // var _tag = UniqueKey().toString();
      // list.add(InkWell(onTap: (){
      //   _mainModel.currentService = item;
      //   route("service");
      //   },
      //     child: Hero(
      //         tag: _tag,
      //         child: Container(
      //             width: windowWidth,
      //             margin: EdgeInsets.only(left: 10, right: 10),
      //             child: Stack(
      //               children: [
      //                 Card50(item: item,
      //                   locale: strings.locale,
      //                   category: _mainModel.categories,
      //                   direction: strings.direction,
      //                   providerData: _prov,
      //                 ),
      //                 if (user != null)
      //                   Container(
      //                     margin: EdgeInsets.all(6),
      //                     alignment: strings.direction == TextDirection.ltr ? Alignment.topRight : Alignment.topLeft,
      //                     child: IconButton(icon: userAccountData.userFavorites.contains(item.id)
      //                         ? Icon(Icons.favorite, size: 25,)
      //                         : Icon(Icons.favorite_border, size: 25,), color: Colors.orange,
      //                       onPressed: (){changeFavorites(item);}, ),
      //                   )
      //           ],
      //       )
      // ))));

      list.add(SizedBox(height: 20,));
      _count++;
    }

    if (_count == 0){
      list.add(Center(child:
      Container(
        width: windowWidth*0.7,
        height: windowWidth*0.7,
        child: theme.bookingNotFoundImageAsset ? Image.asset("assets/nofound.png", fit: BoxFit.contain) :
        CachedNetworkImage(
            imageUrl: theme.bookingNotFoundImage,
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

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

}
