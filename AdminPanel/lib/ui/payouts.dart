import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class PayoutsScreen extends StatefulWidget {
  @override
  _PayoutsScreenState createState() => _PayoutsScreenState();
}

class _PayoutsScreenState extends State<PayoutsScreen> {

  final List<ComboData> _sortData = [];
  String _sortDataValue = "";
  final ScrollController _controllerScroll = ScrollController();
  late MainModel _mainModel;

  @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _sortDataValue = "timeDesc";
    _sortData.add(ComboData(strings.get(278), "nameAsc")); /// Name Ascend
    _sortData.add(ComboData(strings.get(279), "nameDesc")); /// Name Descend
    _sortData.add(ComboData(strings.get(274), "timeDesc")); /// Time Descend
    _sortData.add(ComboData(strings.get(275), "timeAsc")); /// Time Ascend
    _sortData.add(ComboData(strings.get(277), "totalAsc")); /// Total Ascend
    _sortData.add(ComboData(strings.get(276), "totalDesc")); /// Total Descend
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      var ret = await loadPayout();
      if (ret != null)
        messageError(context, ret);
      waitInMainWindow(false);
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

  _getList(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(272), /// "Providers Payouts",
          style: theme.style25W800,)),
      ],
    ));
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
                payoutsSort(value);
                setState(() {
                });
              },)),
      ],
    ));

    pagingStart();

    List<DataRow> _cells = [];
    for (var item in payout){
      if (!_mainModel.getTextByLocale(item.providerName).toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (isNotInPagingRange())
        continue;

      _cells.add(DataRow(cells: [
        // name
        DataCell(Container(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_mainModel.getTextByLocale(item.providerName),
              overflow: TextOverflow.ellipsis, style: theme.style14W400,),
            // Text(item.login,
            //   overflow: TextOverflow.ellipsis, style: theme.style12W600Grey,),
        ],
        ))),
        // time
        DataCell(Container(child: Text(appSettings.getDateTimeString(item.time),
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        // total
        DataCell(Container(child: Text(getPriceString(item.total),
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        // comment
        DataCell(Container(width: 200, child: Text(item.comment,
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),

        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: Expanded(child: Text(strings.get(54), style: theme.style14W600Grey))), // name
      DataColumn(label: Expanded(child: Text(strings.get(273), style: theme.style14W600Grey))), // time
      DataColumn(label: Expanded(child: Text(strings.get(177), style: theme.style14W600Grey))), // Total
      DataColumn(label: Expanded(child: Text(strings.get(180), style: theme.style14W600Grey))), // Comment
    ];

    list.add(Container(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: horizontalScroll(DataTable(
              columns: _column,
              rows: _cells,
        ), _controllerScroll))
    );

    paginationLine(list, _redraw, strings.get(88)); /// from
    list.add(SizedBox(height: 140,));

    return list;
  }

  _copy(){
    _mainModel.provider.copyPayouts();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.provider.csvPayouts(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "payouts.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
