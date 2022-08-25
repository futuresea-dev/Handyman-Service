import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:ondemand_admin/mainModel/model.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import '../theme.dart';
import 'strings.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

ProductDataCache? openArticle;

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;
  bool _expandDescription = true;

  dom.Document document = htmlparser.parse("");
  String _documentId = "";


  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _init();
    });
    super.initState();
  }

  @override
  void dispose() {
    openArticle = null;
    super.dispose();
  }


  _init() async {
    if (openArticle != null) {
      currentArticle = ProductData.createEmpty();
      waitInMainWindow(true);
      var ret = await articleGetItemToEdit(openArticle!);
      waitInMainWindow(false);
      if (ret != null)
        return messageError(context, ret);
      currentArticle.countProduct = 1;
      _redraw();
    }
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: getBodyArticleDialog(),
      ),
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  List<Widget> getBodyArticleDialog(){

    if (currentArticle.id == "")
      return [];

    String textPrice = getPriceString(currentArticle.priceProduct);
    String textDiscPrice = currentArticle.discPriceProduct != 0 ? getPriceString(currentArticle.discPriceProduct) : "";

    double? _price = articleGetTotalPrice();

    if (_documentId != currentArticle.id){
      document = htmlparser.parse("<body>${getTextByLocale(currentArticle.desc, strings.locale)}");
      _documentId = currentArticle.id;
    }

    //
    // bool available = true;
    // var t = currentArticle.providers.isNotEmpty ? getProviderById(currentArticle.providers[0]) : null;
    // if (t != null)
    //   available = t.available;
    //

    articleGetInStock();

    return [
      SizedBox(height: 30,),
        Container(
            // height: windowWidth*0.3,
            child: IntrinsicHeight(child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), bottomLeft: Radius.circular(theme.radius)),
                        child: InkWell(
                            onTap: (){
                              if (currentArticle.gallery.isNotEmpty)
                                openGalleryScreen(currentArticle.gallery, currentArticle.gallery[0]);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => GalleryScreen(item: currentArticle.gallery[0], gallery: currentArticle.gallery,
                                //         tag: _tag, textDirection: strings.direction,),
                                //     )
                                // );
                            },
                            child: Stack(
                              children: [
                                Container(
                                    height: windowWidth*0.3,
                                    child: showImage(currentArticle.gallery.isNotEmpty ? currentArticle.gallery[0].serverPath : "", fit: BoxFit.cover)),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 25,
                                    width: 2000,
                                    color: Colors.black.withAlpha(150),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(left: 3, right: 3,),
                                    child: Icon(Icons.visibility, color: Colors.white)
                                ),
                                // Container(
                                //   margin: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
                                //   child: Icon(Icons.visibility, color: Colors.white, size: 36,),
                                // ),
                                // Container(
                                //   margin: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
                                //   child: Icon(Icons.visibility, color: Colors.black, size: 30,),
                                // ),
                                // Icon(Icons., color: Colors.black)
                              ],
                            )
                        )
                    )),

                Expanded(
                    flex: 3,
                    child:Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 3),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(getTextByLocale(currentArticle.name, strings.locale),
                            style: theme.style14W600, textAlign: TextAlign.start, maxLines: 5, overflow: TextOverflow.ellipsis,),

                          SizedBox(height: 10,),

                          Row(
                            children: [
                              Text(textPrice, style: textDiscPrice.isEmpty ? theme.style13W800 : theme.style12W400D,),
                              SizedBox(width: 3,),
                              Text(textDiscPrice, style: theme.style13W800Red,),
                              Expanded(child: SizedBox(width: 3,)),
                            ],
                          ),

                          SizedBox(height: 10,),

                          ..._groupList(_redraw),

                          SizedBox(height: 20,),
                          if (isMobile())
                            Row(
                              children: [
                                Text(strings.get(108), /// "Quantity",
                                    style: theme.style12W800),
                                SizedBox(width: 30,),
                                plusMinus(currentArticle.id, currentArticle.countProduct, (String id, int count) {
                                  if (count <= articleGetInStock())
                                    currentArticle.countProduct = count;
                                  _redraw();
                                }, ),
                              ],
                            ),
                          if (isMobile())
                            Text("${articleGetInStock()} ${currentArticle.unit} ${strings.get(195)}"), ///  in stock

                          if (!isMobile())
                          Row(
                            children: [
                              Text(strings.get(108), /// "Quantity",
                                  style: theme.style12W800),
                              SizedBox(width: 30,),
                              plusMinus(currentArticle.id, currentArticle.countProduct, (String id, int count) {
                                if (count <= articleGetInStock())
                                  currentArticle.countProduct = count;
                                _redraw();
                              }, ),
                              SizedBox(width: 10,),
                              Text("${articleGetInStock()} ${currentArticle.unit} ${strings.get(195)}") ///  in stock
                            ],
                          ),
                          SizedBox(height: 10,),
                          // if (item.addon.isNotEmpty)
                          //   Text(strings.get(93), /// "Addons",
                          //       style: theme.style12W800),
                          // SizedBox(height: 10,),
                          // _listAddons(windowWidth, _redraw, item, _mainModel),
                          // SizedBox(height: 20,),

                          if (isMobile())
                            Text(strings.get(196), /// "Total amount",
                                style: theme.style12W800),
                          if (isMobile())
                            SizedBox(height: 5,),
                          if (isMobile())
                            Text(_price != null ? getPriceString(_price*currentArticle.countProduct) : strings.get(197), /// Please select variant
                                style: theme.style13W800Red),

                          if (!isMobile())
                          Row(
                            children: [
                              Text(strings.get(196), /// "Total amount",
                                  style: theme.style12W800),
                              SizedBox(width: 10,),
                              Text(_price != null ? getPriceString(_price*currentArticle.countProduct) : strings.get(197), /// Please select variant
                                  style: theme.style13W800Red),
                            ],
                          ),

                          SizedBox(height: 20,),
                          button2x(strings.get(194), /// "Add to cart",
                                  (){
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user == null)
                                  return _mainModel.route("login");
                                var ret = addToCart(currentArticle, strings.get(199)); /// This product already in the cart
                                if (ret != null)
                                  messageError(context, ret);
                                else
                                  messageOk(context, strings.get(198)); /// Product added to cart
                                redrawMainWindow();
                              }, enable: _price != null && currentArticle.countProduct != 0
                          ),

                          // Text(currentArticle.providers.isNotEmpty ? getStringDistanceByProviderId(item.providers[0]) : "",
                          //   style: theme.style10W600Grey, textAlign: TextAlign.end,),

                          SizedBox(height: 5,),

                        ],
                      ),
                    )),


              ],
            )
            )
        ),



        SizedBox(height: 20,),

        buttonExpand(getTextByLocale(currentArticle.descTitle, strings.locale), _expandDescription, (){
          _expandDescription = !_expandDescription;
          _redraw();
        }, color: theme.mainColor.withAlpha(80)),

        if (_expandDescription)
          SizedBox(height: 10,),
        if (_expandDescription)
          Container(
            margin: EdgeInsets.all(10),
            child: Html.fromDom(
              document: document,
              // data: "<body>${getTextByLocale(currentArticle.desc, strings.locale)}",
              style: {
                "body": Style(
                    backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
                    color: (theme.darkMode) ? Colors.white : Colors.black
                ),
              },
            ),
          ),
      ];
  }



  List<Widget> _groupList(Function() _redraw){
    List<Widget> list = [];

    for (var _group in currentArticle.group){
      List<Widget> list2 = [];
      PriceData? _select;
      for (var _variant in _group.price) {
        list2.add(variantButton(_redraw, strings.locale, _group, _variant));
        if (_variant.selected)
          _select = _variant;
      }
      list.add(Text("${getTextByLocale(_group.name, strings.locale)}: "
          "${_select != null ? getTextByLocale(_select.name, strings.locale) : ""}"));
      list.add(SizedBox(height: 10,));

      list.add(Wrap(
          runSpacing: 10,
          spacing: 10,
          children: list2
      ));
    }

    return list;
  }

}

