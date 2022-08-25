import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/elements/widgets.dart';
import 'package:ondemandservice/widgets/buttons/button202n.dart';
import 'package:ondemandservice/widgets/horizontal_articles.dart';
import 'addons.dart';
import 'strings.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var t = routeGetPosition();
      if (t != 0)
      _scrollController2.animateTo(t, duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
    });
    _init();
    for (var item in _mainModel.currentService.addon)
      item.selected = false;

    super.initState();
  }

  _init() async {
    var ret = await loadReviewsForServiceScreen(_mainModel.currentService.id);
    if (ret != null)
      messageError(context, ret);
    _redraw();
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
    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Container(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          width: windowWidth,
          height: windowHeight,
          child: _body2(),
    )));
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
                              ),
                            ],
                          )),
                    ))
              ];
            },
            body: Builder(
              builder: (BuildContext context) {
                _scrollController2 = PrimaryScrollController.of(context)!;
                _scrollController2.addListener(() {
                  routeSavePosition(_scrollController2.position.pixels);
                });

                return Container(
                  width: windowWidth,
                  height: windowHeight,
                  child: _body(),
                );
              },

            ),

          ),

          appbar1((_scroller > 1) ? Colors.transparent :
              (theme.darkMode) ? Colors.black : Colors.white,
              (theme.darkMode) ? Colors.white : Colors.black,
              (_scroller > 5) ? "" : getTextByLocale(_mainModel.currentService.name, strings.locale), context, () {
                goBack();
          }),

          Container(
            margin: EdgeInsets.only(bottom: 5),
            alignment: Alignment.bottomCenter,
            child: Row(
            children: [
              Expanded(child: button2(strings.get(102), /// "Book This Service"
                  theme.mainColor, (){
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      route("login");
                    }else
                      route("book");
                  }, radius: 0,)
              ),
              SizedBox(width: 2,),
              Expanded(child: button2(strings.get(264), /// Add to cart
                theme.mainColor, (){
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    route("login");
                  }else{
                    _mainModel.currentService.countProduct = 1;
                    var ret = addToCart(_mainModel.currentService, strings.get(273)); // This service already in the cart
                    if (ret != null)
                      messageError(context, ret);
                    else
                      messageOk(context, strings.get(275)); /// Service added to cart
                    redrawMainWindow();
                  }
                }, radius: 0,
              ))
            ],
            )
          ),

        ]);
  }

  _title() {
    var _data = _mainModel.service.getTitleImage();
    return Container(
      color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Container(
          width: windowWidth,
          margin: EdgeInsets.only(bottom: 10),
          child: _data.serverPath.isNotEmpty ? CachedNetworkImage(
              imageUrl: _data.serverPath,
              imageBuilder: (context, imageProvider) => Container(
                width: double.maxFinite,
                alignment: Alignment.bottomRight,
                child: Container(
                  //width: height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )),
                ),
              )
          ) : Container()
      )
    );
  }

  _body(){
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));

    List<Widget> list3 = [];
    list3.add(SizedBox(width: 5,));
    list3.add(card51(_mainModel.currentService.rating.toInt(), theme.serviceStarColor, 16),);
    list3.add(SizedBox(width: 5,));
    list3.add(Text(_mainModel.currentService.rating.toStringAsFixed(1),
      style: theme.style14W400, textAlign: TextAlign.center,),);
    list3.add(SizedBox(width: 20,));
    getPriceText(_mainModel.service.getPrice(), list3, _mainModel);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null){
      list3.add(SizedBox(width: 10,));
      list3.add(Container(
          alignment: Alignment.topRight,
          child: IconButton(icon: userAccountData.userFavorites.contains(_mainModel.currentService.id)
                ? Icon(Icons.favorite, size: 30,)
                : Icon(Icons.favorite_border, size: 30), color: Colors.orange,
              onPressed: (){
                changeFavorites(_mainModel.currentService);
              }, ),
          )
      );
    }
    list.add(
        Column(
          children: [
            Text(getTextByLocale(_mainModel.currentService.name, strings.locale), style: theme.style14W800),    /// name
            SizedBox(height: 5,),
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: list3
            )
          ],
        )
    );
    list.add(SizedBox(height: 40,));

    bool yesSelect = false;
    for (var item in _mainModel.currentService.price)
      if (item.selected)
        yesSelect = true;
    if (!yesSelect){
      bool first = true;
      for (var item in _mainModel.currentService.price) {
        if (first) {
          first = false;
          item.selected = true;
          //localSettings.price = item;
        }else
          item.selected = false;
      }
    }

    for (var item in _mainModel.currentService.price){
      List<Widget> list2 = [];
      list2.add((item.image.serverPath.isNotEmpty) 
          ? Container(
            width: 30,
            height: 30,
            child: Image.network(item.image.serverPath, fit: BoxFit.contain))
          : Container(width: 30, height: 30));
      list2.add(SizedBox(width: 10,));
      list2.add(Expanded(child: Text(getTextByLocale(item.name, strings.locale), style: theme.style14W400)));
      list2.add(SizedBox(width: 5,));
      getPriceText(item, list2, _mainModel);
      list.add(InkWell(
          onTap: (){
            for (var item in _mainModel.currentService.price)
              item.selected = false;
            item.selected = true;
            //localSettings.price = item;
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

    if (_mainModel.currentService.price.isNotEmpty) {
      list.add(Divider(color: Colors.grey.withAlpha(100)));
      list.add(SizedBox(height: 10,));
    }

    listAddons(list, windowWidth, _redraw, _mainModel, false);

    if (_mainModel.currentService.descTitle.isNotEmpty){
      list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getTextByLocale(_mainModel.currentService.descTitle, strings.locale),
                style: theme.style14W800, textAlign: TextAlign.start,),   /// "Description",
              Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
              SizedBox(height: 5,),
              Text(getTextByLocale(_mainModel.currentService.desc, strings.locale), style: theme.style12W400),
              SizedBox(height: 5,),
              Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
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
                style: theme.style13W800,),
              Text(strings.get(99),                                                 /// "This service can take up to",
                style: theme.style12W400,)
            ],
          )),
          Text("${_mainModel.currentService.duration.inMinutes} ${strings.get(98)}", style: theme.style16W800,) /// min
        ],
      ),));

    list.add(SizedBox(height: 20,),);

    if (_mainModel.currentService.providers.isNotEmpty)
      list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
              SizedBox(height: 5,),
              Text(strings.get(155), /// "Provider",
                style: theme.style13W800, textAlign: TextAlign.start,),
              SizedBox(height: 5,),
            ],
          )
      ));

    for (var item in _mainModel.currentService.providers){
      for (var item2 in providers){
        if (item == item2.id){
          list.add(Container(
              height: windowWidth*0.9*0.45,
              child: button202N(getTextByLocale(item2.name, strings.locale),
                item2.imageUpperServerPath, windowWidth-20, (){
                  _mainModel.currentProvider = item2;
                  route("provider");
                },)));
          list.add(SizedBox(height: 10,));
        }
      }
    }

    if (ifProviderHaveArticles(_mainModel.currentService.providers.isNotEmpty ? _mainModel.currentService.providers[0] : "")){
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
      list.add(articleHorizontalBar(_mainModel.currentService.providers.isNotEmpty ? _mainModel.currentService.providers[0] : "",
          windowWidth, context, _mainModel));
    }

    list.add(Container(
        color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(child: Text(strings.get(100), /// "Galleries",
              style: theme.style13W800,)),
            Container(
              width: windowWidth*0.4,
              height: windowWidth*0.3,
              child: theme.serviceGLogoAsset
                  ? Image.asset("assets/ondemands/ondemand20.png", fit: BoxFit.contain)
                  : CachedNetworkImage(
                    imageUrl: theme.serviceGLogo,
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

    if (_mainModel.currentService.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _mainModel.currentService.gallery.map((e){
            var _tag = UniqueKey().toString();
            return InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryScreen(item: e, gallery: _mainModel.currentService.gallery,
                          tag: _tag, textDirection: strings.direction,),
                      )
                  );
                },
                child: Hero(
                    tag: _tag,
                    child: Container(
                        width: windowWidth/3-20,
                        height: windowWidth/3-20,
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              UnconstrainedBox(child:
                              Container(
                                alignment: Alignment.center,
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(backgroundColor: Colors.black, ),
                              )),
                          imageUrl: e.serverPath,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          errorWidget: (context,url,error) => Icon(Icons.error),
                        ),
                    )));
          }).toList(),
        ),
      ));

    list.add(SizedBox(height: 20,));

    if (reviews.isNotEmpty)
    list.add(Container(
        color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(child: Column(
              children: [
                Text(strings.get(101), /// "Reviews & Ratings"
                  style: theme.style14W800,),
                SizedBox(height: 20,),
                Row(children: [
                  card51(_mainModel.currentService.rating.toInt(), theme.serviceStarColor, 16),
                  SizedBox(width: 5,),
                  Text(_mainModel.currentService.rating.toStringAsFixed(1),
                      style: theme.style12W600StarsService, textAlign: TextAlign.center,),
                  SizedBox(width: 5,),
                  Text("(${_mainModel.currentService.countProduct.toString()})", style: theme.style14W800, textAlign: TextAlign.center,),
                ],),
              ],
            )),
            Container(
                width: windowWidth*0.4,
              height: windowWidth*0.4,
              child: theme.serviceGLogoAsset ? Image.asset("assets/ondemands/ondemand19.png", fit: BoxFit.contain) :
              CachedNetworkImage(
                  imageUrl: theme.serviceGLogo,
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

    for (var item in reviews){
      list.add(Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: card47(item.userAvatar,
              item.userName,
              appSettings.getDateTimeString(item.time),
              item.text,
              // (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
              item.images,
              item.rating,
              context,
              strings.direction,
              iconStarsColor: theme.serviceStarColor
          ),
        ));

      list.add(SizedBox(height: 20,));
    }

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
         // controller: _scrollController2,
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }
}

