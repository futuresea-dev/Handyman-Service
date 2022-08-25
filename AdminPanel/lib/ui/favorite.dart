import 'package:abg_utils/abg_utils.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  late MainModel _mainModel;
  final List<ComboData> _sortData = [];
  String _sortDataValue = "";
  List<ProductData> _services = [];
  final ScrollController _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _sortDataValue = "countAsc";
    _sortData.add(ComboData(strings.get(278), "nameAsc")); /// Name Ascend
    _sortData.add(ComboData(strings.get(279), "nameDesc")); /// Name Descend
    _sortData.add(ComboData(strings.get(323), "catAsc")); /// Category Ascend
    _sortData.add(ComboData(strings.get(324), "catDesc")); /// Category Descend
    _sortData.add(ComboData(strings.get(325), "proAsc")); /// Provider Ascend
    _sortData.add(ComboData(strings.get(326), "proDesc")); /// Provider Descend
    _sortData.add(ComboData(strings.get(321), "countAsc")); /// Count Ascend
    _sortData.add(ComboData(strings.get(322), "countDesc")); /// Count Descend
    _init();
    super.initState();
  }

  _init() async {
    var ret = await _mainModel.service.load(context);
    if (ret != null)
      messageError(context, ret);
    _resort();
  }

  _resort(){
    _services = [];
    for (var item in product)
      if (item.favoritesCount != 0)
        _services.add(item);
    if (_sortDataValue == "countAsc")
      _services.sort((a, b) => a.favoritesCount.compareTo(b.favoritesCount));
    if (_sortDataValue == "countDesc")
      _services.sort((a, b) => b.favoritesCount.compareTo(a.favoritesCount));
    if (_sortDataValue == "nameAsc")
      _services.sort((a, b) => getTextByLocale(a.name, strings.locale).compareTo(getTextByLocale(b.name, strings.locale)));
    if (_sortDataValue == "nameDesc")
      _services.sort((a, b) => getTextByLocale(b.name, strings.locale).compareTo(getTextByLocale(a.name, strings.locale)));
    if (_sortDataValue == "catAsc")
      _services.sort((a, b) => getCategoryNameById(a.category.isNotEmpty ? a.category[0] : "")
          .compareTo(getCategoryNameById(b.category.isNotEmpty ? b.category[0] : "")));
    if (_sortDataValue == "catDesc")
      _services.sort((a, b) => getCategoryNameById(b.category.isNotEmpty ? b.category[0] : "")
          .compareTo(getCategoryNameById(a.category.isNotEmpty ? a.category[0] : "")));
    if (_sortDataValue == "proAsc")
      _services.sort((a, b) => getProviderNameById(a.providers.isNotEmpty ? a.providers[0] : "", locale)
          .compareTo(getProviderNameById(b.providers.isNotEmpty ? b.providers[0] : "", locale)));
    if (_sortDataValue == "proDesc")
      _services.sort((a, b) => getProviderNameById(b.providers.isNotEmpty ? b.providers[0] : "", locale)
          .compareTo(getProviderNameById(a.providers.isNotEmpty ? a.providers[0] : "", locale)));
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

  _getList(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(320), /// "Favorites",
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 8,));
    list.add(SelectableText(strings.get(327), /// "This list includes services that users add to favorites in their applications. The count is how many users have added this service to their favorites.
      style: theme.style12W400,));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);

    list.add(SizedBox(height: 10,));
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(strings.get(253), style: theme.style14W400,), /// "Sort by",
        Container(
            width: 200,
            child: Combo(inRow: true, text: "",
              data: _sortData,
              value: _sortDataValue,
              onChange: (String value){
                _sortDataValue = value;
                _resort();
                _redraw();
              },)),
      ],
    ));

    pagingStart();

    List<DataRow> _cells = [];
    for (var item in _services){
      if (!_mainModel.getTextByLocale(item.name).toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (isNotInPagingRange())
        continue;

      _cells.add(DataRow(cells: [
        // name
        DataCell(Container(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_mainModel.getTextByLocale(item.name),
              overflow: TextOverflow.ellipsis, style: theme.style14W400,),
            // Text(item.login,
            //   overflow: TextOverflow.ellipsis, style: theme.style12W600Grey,),
        ],
        ))),
        // category
        DataCell(Container(child: Text(item.category.isNotEmpty ? getCategoryNameById(item.category[0]) : "",
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        // provider
        DataCell(Container(child: Text(item.providers.isNotEmpty ? getProviderNameById(item.providers[0], locale) : "",
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        // count
        DataCell(Container(width: 200, child: Text(item.favoritesCount.toString(),
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),

        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: Expanded(child: Text(strings.get(54), style: theme.style14W600Grey))), // Name
      DataColumn(label: Expanded(child: Text(strings.get(158), style: theme.style14W600Grey))), // Category
      DataColumn(label: Expanded(child: Text(strings.get(178), style: theme.style14W600Grey))), // Provider
      DataColumn(label: Expanded(child: Text(strings.get(283), style: theme.style14W600Grey))), // Count
    ];

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        child: horizontalScroll(DataTable(
              columns: _column,
              rows: _cells,
        ), _controllerScroll))
    );

    paginationLine(list, _redraw, strings.get(88)); /// from

    return list;
  }

  _copy(){
    var text = "";
    for (var item in _services){
      var _cat = "";
      if (item.category.isNotEmpty)
        _cat = getCategoryNameById(item.category[0]);
      var _pro = "";
      if (item.providers.isNotEmpty)
        _pro = getProviderNameById(item.providers[0], locale);
      text = "$text${_mainModel.getTextByLocale(item.name)}\t$_cat\t$_pro\t${item.favoritesCount}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    List<List> t2 = [];
    t2.add([
      strings.get(54), // Name
      strings.get(158), // Category
      strings.get(178), // Provider
      strings.get(283), // Count
    ]);
    for (var item in _services){
      var _cat = "";
      if (item.category.isNotEmpty)
        _cat = getCategoryNameById(item.category[0]);
      var _pro = "";
      if (item.providers.isNotEmpty)
        _pro = getProviderNameById(item.providers[0], locale);
      t2.add([
        _mainModel.getTextByLocale(item.name),
        _cat,
        _pro,
        item.favoritesCount
      ]);
    }
    var _data = ListToCsvConverter().convert(t2);

    html.AnchorElement()
      ..href = '${Uri.dataFromString(_data, mimeType: 'text/plain', encoding: utf8)}'
      ..download = "favorites.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
