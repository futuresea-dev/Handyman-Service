import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import '../../../utils.dart';
import 'edit.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class ArticlesScreen extends StatefulWidget {
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {

  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();
  String _sortBy = "modifyAsc";
  final dataKey = GlobalKey();

  @override
  void dispose() {
    _controllerScroll.dispose();
    currentProduct = ProductData.createEmpty();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    productDataCache.sort((a, b) => a.timeModify.compareTo(b.timeModify));
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _sortFilter(null);
    });
    super.initState();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: ListView(
        children: _getList(),
      ),
    );
  }

  _sortFilter(String? val){
    if (val != null)
      _sortBy = val;
    switch(_sortBy){
      case "visibleAsc":
        productDataCache.sort((a, b) => a.compareToVisible(b));
        break;
      case "visibleDesc":
        productDataCache.sort((a, b) => b.compareToVisible(a));
        break;
      case "nameDesc":
        productDataCache.sort((a, b) => getTextByLocale(b.name, strings.locale).compareTo(getTextByLocale(a.name, strings.locale)));
        break;
      case "nameAsc":
        productDataCache.sort((a, b) => getTextByLocale(a.name, strings.locale).compareTo(getTextByLocale(b.name, strings.locale)));
        break;
      case "priceDesc":
        productDataCache.sort((a, b) => b.price.compareTo(a.price));
        break;
      case "priceAsc":
        productDataCache.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "discPriceDesc":
        productDataCache.sort((a, b) => b.discPrice.compareTo(a.discPrice));
        break;
      case "discPriceAsc":
        productDataCache.sort((a, b) => a.discPrice.compareTo(b.discPrice));
        break;
      case "providerDesc":
        productDataCache.sort((a, b) => getProviderNameById(b.providers.isNotEmpty ? b.providers[0] : "", locale)
            .compareTo(getProviderNameById(a.providers.isNotEmpty ? a.providers[0] : "", locale)));
        break;
      case "providerAsc":
        productDataCache.sort((a, b) => getProviderNameById(a.providers.isNotEmpty ? a.providers[0] : "", locale)
            .compareTo(getProviderNameById(b.providers.isNotEmpty ? b.providers[0] : "", locale)));
        break;
      case "modifyDesc":
        productDataCache.sort((a, b) => b.timeModify.compareTo(a.timeModify));
        break;
      case "modifyAsc":
        productDataCache.sort((a, b) => a.timeModify.compareTo(b.timeModify));
        break;
    }
    _redraw();
  }

  _getList(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(423),                       /// "Products",
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);

    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Text(strings.get(253) + ":", style: theme.style14W800,), /// "Sort by",
        SizedBox(width: 10,),
        Text(strings.get(96) + ":", style: theme.style14W400,), /// "Providers",
        if (_mainModel.provider.providersComboForProducts.isNotEmpty)
          Expanded(child: Container(
              child: Combo(inRow: true, text: "",
                data: _mainModel.provider.providersComboForProductsSort,
                value: _mainModel.provider.providersComboValueForProductSort,
                onChange: (String value){
                  _mainModel.provider.providersComboValueForProductSort = value;
                  _redraw();
                },))),
      ],
    ));
    // }

    pagingStart();

    List<DataRow> _cells = [];
    for (var item in productDataCache){
      if (!_mainModel.getTextByLocale(item.name).toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (_mainModel.provider.providersComboValueForProductSort == "root") { // owner
        if (item.providers.isNotEmpty)
          continue;
      }else{
        if (_mainModel.provider.providersComboValueForProductSort != "all") { // not all
          if (item.providers.isEmpty)
            continue;
          if (item.providers[0] != _mainModel.provider.providersComboValueForProductSort)
            continue;
        }
      }
      if (isNotInPagingRange())
        continue;
      _cells.add(DataRow(
          selected: item.id == currentArticle.id,
          cells: [
        // visible
        DataCell(Text(item.visible ? strings.get(70) : strings.get(61), /// "Visible", "No",
          overflow: TextOverflow.ellipsis, style: item.visible ? theme.style13W800Green
              : theme.style13W800Red, )
        ),
        // name
        DataCell(Container(child: Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
            child: SelectableText(getTextByLocale(item.name, strings.locale), style: theme.style14W400,)))),
        // price
        DataCell(Container(child: Text(getPriceString(item.price),
          overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
        // discount price
        DataCell(Container(child: Text(item.discPrice != 0 ? getPriceString(item.discPrice) : strings.get(61), /// no
          overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
        // image
        DataCell(Container(
            width: 50,
            height: 50,
            child: Image.network(item.image)
        )),
        // provider
        DataCell(Container(child: SelectableText(item.providers.isNotEmpty ? getProviderNameById(item.providers[0], locale)
            : strings.get(424), /// "Global (owner) item",
          style: theme.style14W400,))),
        // modify
        DataCell(Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(timeago.format(item.timeModify, locale: strings.locale),
                overflow: TextOverflow.ellipsis, style: theme.style13W800Green),
            Text(appSettings.getDateTimeString(item.timeModify),
                overflow: TextOverflow.ellipsis, style: theme.style12W600Grey)
          ],
        )),
        // action
        DataCell(Center(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                button2small(strings.get(68), () async {   /// "Edit",
                  waitInMainWindow(true);
                  var ret = await articleGetItemToEdit(item);
                  waitInMainWindow(false);
                  if (ret != null)
                    return messageError(context, ret);
                  _notEditorCreate = false;
                  _redraw();
                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                    if (_mainModel.initEditorInProductScreen != null)
                      _mainModel.initEditorInProductScreen!();
                    var currentContext = dataKey.currentContext;
                    if (currentContext != null)
                      Scrollable.ensureVisible(currentContext, duration: Duration(seconds: 1));
                    redrawMainWindow();
                  });


                }, color: theme.mainColor.withAlpha(150)),
                SizedBox(width: 5,),
                button2small(strings.get(62),  /// "Delete",
                    (){_openDialogDelete(item);}, color: dashboardErrorColor.withAlpha(150)),
                SizedBox(width: 5,),
              ],
            )
        ))
        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: itemColumnWithSort(_sortBy, "visibleAsc", "visibleDesc", strings.get(70), _sortFilter)), /// Visible
      DataColumn(label: itemColumnWithSort(_sortBy, "nameAsc", "nameDesc", strings.get(54), _sortFilter)),  /// name
      DataColumn(label: itemColumnWithSort(_sortBy, "priceAsc", "priceDesc", strings.get(144), _sortFilter)), /// "Price",
      DataColumn(label: itemColumnWithSort(_sortBy, "discPriceAsc", "discPriceDesc", strings.get(145), _sortFilter)), /// "Discount Price",
      DataColumn(label: Expanded(child: Text(strings.get(215), style: theme.style14W600Grey))), /// "Image",
      DataColumn(label: itemColumnWithSort(_sortBy, "providerAsc", "providerDesc", strings.get(178), _sortFilter)), /// "Provider",
      DataColumn(label: itemColumnWithSort(_sortBy, "modifyAsc", "modifyDesc", strings.get(429), _sortFilter)), /// "Modify",
      DataColumn(label: Expanded(child: Center(child: Text(strings.get(66), style: theme.style14W600Grey)))), /// action
    ];

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        child: horizontalScroll(DataTable(
          columns: _column,
          rows: _cells,
      ), _controllerScroll))
    );

    paginationLine(list, _redraw, strings.get(88)); /// from

    list.add(SizedBox(height: 40));

    if (!_notEditorCreate) {
      list.add(EditInProduct(keyM: dataKey));
    }else
      list.add(Center(child: button2b(strings.get(425), (){ /// "Create new product",
        _notEditorCreate = false;
        currentArticle = ProductData.createEmpty();
        _redraw();
        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          if (_mainModel.initEditorInProductScreen != null)
            _mainModel.initEditorInProductScreen!();
        });
      })));


    return list;
  }

  var _notEditorCreate = true;

  _openDialogDelete(ProductDataCache value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      var ret = await articleDelete(value);
      if (ret == null)
        messageOk(context, strings.get(69)); /// "Data deleted",
      else
        messageError(context, ret);
      if (_mainModel.initEditorInProductScreen != null)
        _mainModel.initEditorInProductScreen!();
      redrawMainWindow();
    }, context);
  }

  _copy(){
    _mainModel.provider.articleCopy();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.provider.articleCsv(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "articles.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }

}

