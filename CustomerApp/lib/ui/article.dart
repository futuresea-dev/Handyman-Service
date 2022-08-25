import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'strings.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

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
    currentArticle.countProduct = 1;
    super.initState();
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
              child: _body2(),
            )));
  }

  _body2(){
    return Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10, left: 10, right: 10, bottom: 20),
              child: ListView(
                children: getBodyArticleDialog(_redraw, (){goBack();}, windowWidth, _mainModel, context),
              )
            ),

          appbar1(Colors.transparent,
              (!theme.darkMode) ? Colors.black : Colors.white,
              "", context, () {
                goBack();
              }),

        ]);
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  List<Widget> getBodyArticleDialog(Function() _redraw, Function() _close, double windowWidth,
      MainModel _mainModel, BuildContext context){

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

    var _tag = UniqueKey().toString();
    articleGetInStock();

    return [
        Container(
            height: windowWidth*0.3,
            child:
            IntrinsicHeight(child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), bottomLeft: Radius.circular(theme.radius)),
                        child: InkWell(
                            onTap: (){
                              if (currentArticle.gallery.isNotEmpty)
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GalleryScreen(item: currentArticle.gallery[0], gallery: currentArticle.gallery,
                                        tag: _tag, textDirection: strings.direction,),
                                    )
                                );
                            },
                            child: Stack(
                              children: [
                                Hero(
                                    tag: _tag,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(getTextByLocale(currentArticle.name, strings.locale),
                            style: theme.style11W600, textAlign: TextAlign.start, maxLines: 5, overflow: TextOverflow.ellipsis,),

                          Row(
                            children: [
                              Text(textPrice, style: textDiscPrice.isEmpty ? theme.style13W800 : theme.style12W400D,),
                              SizedBox(width: 3,),
                              Text(textDiscPrice, style: theme.style13W800Red,),
                              Expanded(child: SizedBox(width: 3,)),
                            ],
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

        SizedBox(height: 10,),

        ..._groupList(_redraw),

        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(child: Text(strings.get(75), /// "Quantity",
                style: theme.style12W800)),
            plusMinus(currentArticle.id, currentArticle.countProduct, (String id, int count) {
              if (count <= articleGetInStock())
                currentArticle.countProduct = count;
              _redraw();
            }, ),
            SizedBox(width: 10,),
            Text("${articleGetInStock()} ${currentArticle.unit} ${strings.get(266)}") ///  in stock
          ],
        ),
        SizedBox(height: 10,),
        // if (item.addon.isNotEmpty)
        //   Text(strings.get(93), /// "Addons",
        //       style: theme.style12W800),
        // SizedBox(height: 10,),
        // _listAddons(windowWidth, _redraw, item, _mainModel),
        // SizedBox(height: 20,),

        Row(
          children: [
            Text(strings.get(263), /// "Total amount",
                style: theme.style12W800),
            SizedBox(width: 10,),
            Text(_price != null ? getPriceString(_price*currentArticle.countProduct) : strings.get(265), /// Please select variant
                style: theme.style13W800Red),
          ],
        ),

        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(flex: 2, child: button2(strings.get(264), /// "Add to cart",
                theme.mainColor, (){
                  var ret = addToCart(currentArticle, strings.get(274)); // This product already in the cart
                  if (ret != null)
                    messageError(context, ret);
                  else
                    messageOk(context, strings.get(267)); /// Product added to cart
                  redrawMainWindow();
                }, enable: _price != null && currentArticle.countProduct != 0
            ))
          ],
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
            // height: windowHeight,
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

