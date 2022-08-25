import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/dialogs/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import '../../../utils.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class ProvidersRequestScreen extends StatefulWidget {
  final Function() openProvidersScreen;
  const ProvidersRequestScreen({Key? key, required this.openProvidersScreen,}) : super(key: key);

  @override
  _ProvidersRequestScreenState createState() => _ProvidersRequestScreenState();
}

class _ProvidersRequestScreenState extends State<ProvidersRequestScreen> {

  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
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
      waitInMainWindow(true);
      var ret = await _mainModel.provider.loadRequest();
      if (ret != null)
        messageError(context, ret);
      waitInMainWindow(false);
    });
    super.initState();
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
        Expanded(child: SelectableText(strings.get(246),                       /// "Providers Request",
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);
    pagingStart();

    List<DataRow> _cells = [];
    for (var item in _mainModel.provider.providersRequest){
      if (!item.name.toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (isNotInPagingRange())
        continue;
      _cells.add(DataRow(cells: [
        // name
        DataCell(Container(child: Text(item.providerName,
          overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
        // email
        DataCell(Container(child: Text(item.email, overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        // action
        DataCell(Center(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                if (item.providerName.isNotEmpty)
                  button2small(strings.get(406), (){        /// "View",
                    _mainModel.currentProviderRequest = item;
                    showDialogViewProviderRequestInfo();
                  }, color: theme.mainColor.withAlpha(150)),
                if (item.providerName.isEmpty)
                  button2small(strings.get(247), (){        /// "Assign",
                    _mainModel.provider.createNewProvider(item);
                    widget.openProvidersScreen();
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
      DataColumn(label: Expanded(child: Text(strings.get(54), style: theme.style14W600Grey))), /// name
      DataColumn(label: Expanded(child: Text(strings.get(86), style: theme.style14W600Grey))), /// Email
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
    list.add(SizedBox(height: 150));
    return list;
  }

  _openDialogDelete(UserData value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      // demo mode
      if (appSettings.demo)
        return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
      var ret = await Provider.of<MainModel>(context,listen:false).provider.deleteRequest(value);
      if (ret == null)
        messageOk(context, strings.get(69)); // "Data deleted",
      else
        messageError(context, ret);
      setState(() {});
    }, context);
  }

  _copy(){
    _mainModel.provider.copyRequest();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.provider.csvRequest(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "request.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
