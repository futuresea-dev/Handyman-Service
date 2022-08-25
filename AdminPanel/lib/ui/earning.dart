import 'package:abg_utils/abg_utils.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import 'package:universal_html/html.dart' as html;

class EarningScreen extends StatefulWidget {
  @override
  _EarningScreenState createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {

  final _controllerPayout = TextEditingController();
  final _controllerComment = TextEditingController();
  var _payOutStage = false;
  var _load = false;
  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
    _controllerPayout.dispose();
    _controllerComment.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      var ret = await loadPayout();
      if (ret != null)
        messageError(context, ret);
      // ret = await _mainModel.provider.load(context);
      // if (ret != null)
      //   messageError(context, ret);
      _load = true;
      waitInMainWindow(false);
      // _redraw();
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
            children: _payOutStage ? _getListPayOut() : _openDetailsScreen ? _getDetailsList() : _getList(),
          ),
    );
  }

  late ProviderData _detailItem;
  bool _openDetailsScreen = false;

  _getDetailsList(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(365), /// Earnings details
          style: theme.style25W800,)),
        SizedBox(width: 10,),
        button2b(strings.get(366), /// "Back to list",
            (){
              _openDetailsScreen = false;
              _redraw();
            }),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);

    List<EarningData> _datas = getEarningData(_detailItem);

    List<DataRow> _cells = [];
    pagingStart();
    for (var _data in _datas){
      if (isNotInPagingRange())
        continue;
      _cells.add(DataRow(cells: [
        // id
        DataCell(Container(child: Text(_data.id,
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // total
        DataCell(Container(child: Text(getPriceString(_data.total),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // admin
        DataCell(Container(child: Text(getPriceString(_data.admin),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // provider
        DataCell(Container(child: Text(getPriceString(_data.provider),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // tax
        DataCell(Container(child: Text(getPriceString(_data.tax),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
      ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: Expanded(child: Text(strings.get(114), style: theme.style12W600Grey))), // id
      DataColumn(label: Expanded(child: Text(strings.get(177), style: theme.style12W600Grey))), // Total
      DataColumn(label: Expanded(child: Text(strings.get(268), style: theme.style12W600Grey))), // Admin
      DataColumn(label: Expanded(child: Text(strings.get(178), style: theme.style12W600Grey))), // Provider
      DataColumn(label: Expanded(child: Text(strings.get(130), style: theme.style12W600Grey))), // Tax
    ];

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        child: horizontalScroll(DataTable(
          columns: _column,
          rows: _cells,
        ), _controllerScroll
        ))
    );

    paginationLine(list, _redraw, strings.get(88)); /// from

    return list;
  }


  _getList(){

    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(263), /// Earnings
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);
    pagingStart();

    List<DataRow> _cells = [];
    if (_load)
    for (var item in providers){
      if (!_mainModel.getTextByLocale(item.name).toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (isNotInPagingRange())
        continue;
      EarningData _data = EarningData();
      List<EarningData> _items = getEarningData(item);
      if (_items.isNotEmpty)
        _data = _items.last;

      _cells.add(DataRow(cells: [
        // name
        DataCell(Container(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Text(_mainModel.getTextByLocale(item.name),
            overflow: TextOverflow.ellipsis, style: theme.style12W400,),
          Text(item.login,
            overflow: TextOverflow.ellipsis, style: theme.style12W600Grey,),
        ],))),
        // booking
        DataCell(Container(child: Text(_data.count.toString(),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // total
        DataCell(Container(child: Text(getPriceString(_data.total),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // admin
        DataCell(Container(child: Text(getPriceString(_data.admin),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // provider
        DataCell(Container(child: Text(getPriceString(_data.provider),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // tax
        DataCell(Container(child: Text(getPriceString(_data.tax),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // To payout
        DataCell(Container(child: Text(getPriceString(_data.payout),
            overflow: TextOverflow.ellipsis, style: theme.style12W400))),
        // action
        DataCell(Center(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                button2small(strings.get(270),
                  (){_payout(item, _data);}, enable: _data.payout > 1, color: dashboardErrorColor.withAlpha(150) ), /// "Payout",
                SizedBox(width: 5,),
                button2small(strings.get(364),
                  (){
                    _detailItem = item;
                    _openDetailsScreen = true;
                    _redraw();
                  }, color: theme.mainColor.withAlpha(150) ), /// "Details",
              ],
            )
        ))
        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: Expanded(child: Text(strings.get(54), style: theme.style12W600Grey))), // name
      DataColumn(label: Expanded(child: Text(strings.get(264), style: theme.style12W600Grey))), // Bookings
      DataColumn(label: Expanded(child: Text(strings.get(177), style: theme.style12W600Grey))), // Total
      DataColumn(label: Expanded(child: Text(strings.get(268), style: theme.style12W600Grey))), // Admin
      DataColumn(label: Expanded(child: Text(strings.get(178), style: theme.style12W600Grey))), // Provider
      DataColumn(label: Expanded(child: Text(strings.get(130), style: theme.style12W600Grey))), // Tax
      DataColumn(label: Expanded(child: Text(strings.get(269), style: theme.style12W600Grey))), // To payout
      DataColumn(label: Expanded(child: Center(child: Text(strings.get(66), style: theme.style12W600Grey)))), // action
    ];

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        child: horizontalScroll(DataTable(
          columns: _column,
          rows: _cells,
        ), _controllerScroll
        ))
    );

    paginationLine(list, _redraw, strings.get(88)); /// from

    return list;
  }

  _copy(){
    if (_openDetailsScreen)
      _mainModel.provider.copyEarningDetails(_detailItem);
    else
      _mainModel.provider.copyEarning();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_openDetailsScreen ? _mainModel.provider.csvEarningDetails(_detailItem)
          : _mainModel.provider.csvEarning(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "earning.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }


  _payout(ProviderData item, EarningData _data){
    _controllerPayout.text = _data.payout.toStringAsFixed(appSettings.digitsAfterComma);
    _payOutStage = true;
    _payOutItem = item;
    _payOutData = _data;
    _redraw();
  }

  ProviderData _payOutItem = ProviderData.createEmpty();
  EarningData _payOutData = EarningData();
  bool _buttonPayout = true;

  _getListPayOut(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));

    list.add(Text(strings.get(270), style: theme.style18W800,)); /// Payout
    list.add(SizedBox(height: 30,));
    list.add(Text(getTextByLocale(_payOutItem.name, strings.locale), style: theme.style14W600,));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        numberElement2Price(strings.get(270), /// Payout
            "", appSettings.symbol, _controllerPayout, (String val){
              var t = toDouble(val);
              if (t != 0 && t < _payOutData.payout)
                _buttonPayout = true;
              else
                _buttonPayout = false;
              _redraw();
            }, appSettings.digitsAfterComma),
        SizedBox(width: 30,),
        Text("${strings.get(271)} ${getPriceString(_payOutData.payout)}", style: theme.style14W400,) /// Max payout
      ],
    ));

    list.add(SizedBox(height: 10,));
    list.add(textElement2(strings.get(180), "", _controllerComment, (String val){}));         /// "Comment",
    list.add(SizedBox(height: 40,));

    list.add(Row(
        children: [
        button2b(strings.get(115), /// "Cancel",
            (){
              _payOutStage = false;
              _redraw();
            }),
        SizedBox(width: 10,),
        button2b(strings.get(270), /// "Payout",
             () async {
              var ret = await _mainModel.provider.createPayout(_payOutItem, toDouble(_controllerPayout.text),
                  _controllerComment.text);
              if (ret != null)
                return messageError(context, ret);
              _payOutStage = false;
              _redraw();
            }, enable: _buttonPayout, color: dashboardErrorColor)
    ]));

    return list;
  }

}
