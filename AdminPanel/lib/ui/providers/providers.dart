import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/appService/emulator.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import '../../../utils.dart';
import 'edit.dart';

import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class ProvidersScreen extends StatefulWidget {
  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {

  var _notEditorCreate = true;
  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();
  final ScrollController _controllerScroll2 = ScrollController();
  final dataKey = GlobalKey();
  String _sortBy = "nameAsc";

  @override
  void dispose() {
    _controllerScroll2.dispose();
    _controllerScroll.dispose();
    _mainModel.provider.newProvider = null;
    currentProvider = ProviderData.createEmpty();
    _mainModel.providerSortFilter = null;
    super.dispose();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      for (var item in _mainModel.serviceApp.screens)
        if (item.id == "provider")
          _mainModel.serviceApp.selectScreen(item);
      _sortFilter(null);
    });
    if (_mainModel.provider.newProvider != null)
      _notEditorCreate = false;
    _mainModel.providerSortFilter = _sortFilter;
    super.initState();
  }

  _sortFilter(String? val){
    if (val != null)
      _sortBy = val;
    switch(_sortBy){
      case "visibleDesc":
        providers.sort((a, b) => b.compareToAvailable(a));
        break;
      case "visibleAsc":
        providers.sort((a, b) => a.compareToAvailable(b));
        break;
      case "nameDesc":
        providers.sort((a, b) => getTextByLocale(b.name, strings.locale).compareTo(getTextByLocale(a.name, strings.locale)));
        break;
      case "nameAsc":
        providers.sort((a, b) => getTextByLocale(a.name, strings.locale).compareTo(getTextByLocale(b.name, strings.locale)));
        break;
      case "emailDesc":
        providers.sort((a, b) => b.login.compareTo(a.login));
        break;
      case "emailAsc":
        providers.sort((a, b) => a.login.compareTo(b.login));
        break;
      case "taxDesc":
        providers.sort((a, b) => b.tax.compareTo(a.tax));
        break;
      case "taxAsc":
        providers.sort((a, b) => a.tax.compareTo(b.tax));
        break;
    }
    _redraw();
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
            controller: _controllerScroll2,
            shrinkWrap: true,
            children: _getList(),
          ),
    );
  }

  _getList(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(96),                       /// "Providers",
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);
    pagingStart();

    List<DataRow> _cells = [];
    for (var item in providers){
      if (!_mainModel.getTextByLocale(item.name).toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (isNotInPagingRange())
        continue;
      // var _subscription = strings.get(501); /// "Expired",
      // if (item.subscriptions.isNotEmpty)
      //   _subscription =  /// "Not subscribed",

      currentProvider = item;
      _cells.add(DataRow(cells: [
        // Available
        DataCell(Text(item.available ? strings.get(473) : strings.get(61), /// "Available", "No",
          overflow: TextOverflow.ellipsis, style: item.available ? theme.style13W800Green
              : theme.style13W800Red, )
        ),
        // name
        DataCell(Container(child: Text(_mainModel.getTextByLocale(item.name),
          overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
        // email
        DataCell(Container(child: Text(item.login,
          overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
        // tax
        if (!appSettings.enableSubscriptions)
          DataCell(Container(child: Text("${item.tax.toStringAsFixed(0)}%",
            overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
        if (appSettings.enableSubscriptions)
          DataCell(Container(child: Text(item.subscriptions.isEmpty ? strings.get(505) ///  "Not subscribed",
                    : getSubscriptionExpiredDateString(),
            overflow: TextOverflow.ellipsis, style: item.subscriptions.isEmpty ? theme.style14W400
                    : isSubscriptionDateExpired() ? theme.style13W800Red : theme.style13W800Green
            ))),
        // action
        DataCell(Center(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                button2small(strings.get(68), (){        /// "Edit",
                  _notEditorCreate = false;
                  redrawMainWindow();
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _mainModel.provider.select(item);
                    if (_mainModel.initEditorInProvidersScreen != null)
                      _mainModel.initEditorInProvidersScreen!();
                    var currentContext = dataKey.currentContext;
                    if (currentContext != null)
                      Scrollable.ensureVisible(currentContext, duration: Duration(seconds: 1));
                  });
                }, color: theme.mainColor.withAlpha(150)),
                SizedBox(width: 5,),
                button2small(strings.get(62), (){_openDialogDelete(item);}, color: dashboardErrorColor.withAlpha(150)), /// "Delete",
                SizedBox(width: 5,),
              ],
            )
        ))
        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: itemColumnWithSort(_sortBy, "visibleAsc", "visibleDesc", strings.get(70), _sortFilter)), /// Visible
      DataColumn(label: itemColumnWithSort(_sortBy, "nameAsc", "nameDesc", strings.get(54), _sortFilter)), /// name
      DataColumn(label: itemColumnWithSort(_sortBy, "emailAsc", "emailDesc", strings.get(86), _sortFilter)), /// "Email",
      if (!appSettings.enableSubscriptions)
        DataColumn(label: itemColumnWithSort(_sortBy, "taxAsc", "taxDesc", strings.get(130), _sortFilter)), /// "Tax",
      if (appSettings.enableSubscriptions)
        DataColumn(label: itemColumnWithSort(_sortBy, "subsAsc", "subsВуыс", strings.get(506), _sortFilter)), /// "Subscription expired at",
      DataColumn(label: Expanded(child: Center(child: Text(strings.get(66), style: theme.style14W600Grey)))), /// action
    ];

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        child: horizontalScroll(DataTable(
            columns: _column,
            rows: _cells,
        ), _controllerScroll)
      )
    );

    paginationLine(list, _redraw, strings.get(88)); /// from
    list.add(SizedBox(height: 40));

    if (isMobile()){
      if (!_notEditorCreate)
        list.add(EditInProvider(keyM: dataKey));
      else
        list.add(Center(child: button2b(strings.get(121), (){ /// "Create new provider",
          _notEditorCreate = false;
          _redraw();
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            if (_mainModel.initEditorInProvidersScreen != null)
              _mainModel.initEditorInProvidersScreen!();
          });
          redrawMainWindow();
        })));
      list.add(SizedBox(height: 10),);
      list.add(EmulatorServiceScreen());
    }
    else
      list.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmulatorServiceScreen(),
            SizedBox(width: 20),
            if (!_notEditorCreate)
              Expanded(child: EditInProvider(keyM: dataKey)),
            if (_notEditorCreate)
              Center(child: button2b(strings.get(121), (){ /// "Create new provider",
                _notEditorCreate = false;
                _redraw();
              })),
          ],
        )
    );

    return list;
  }

  _openDialogDelete(ProviderData value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      // demo mode
      if (appSettings.demo)
        return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
      var ret = await deleteProvider(value);
      if (ret == null)
        messageOk(context, strings.get(69)); /// "Data deleted",
      else
        messageError(context, ret);
      if (_mainModel.initEditorInProvidersScreen != null)
        _mainModel.initEditorInProvidersScreen!();
      redrawMainWindow();
    }, context);
  }

  _copy(){
    _mainModel.provider.copy();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.provider.csv(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "providers.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
