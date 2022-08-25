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

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {

  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();
  final dataKey = GlobalKey();
  String _sortBy = "nameAsc";

  @override
  void dispose() {
    _controllerScroll.dispose();
    currentProduct = ProductData.createEmpty();
    _mainModel.serviceSortFilter = null;
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      for (var item in _mainModel.serviceApp.screens)
        if (item.id == "service")
          _mainModel.serviceApp.selectScreen(item);
      waitInMainWindow(true);
      var ret = await _mainModel.service.load(context);
      if (ret != null)
        messageError(context, ret);
      _sortFilter(null);
      waitInMainWindow(false);
    });
    _mainModel.serviceSortFilter = _sortFilter;
    super.initState();
  }

  _sortFilter(String? val){
    if (val != null)
      _sortBy = val;
    switch(_sortBy){
      case "visibleDesc":
        product.sort((a, b) => b.compareToVisible(a));
        break;
      case "visibleAsc":
        product.sort((a, b) => a.compareToVisible(b));
        break;
      case "nameDesc":
        product.sort((a, b) => getTextByLocale(b.name, strings.locale).compareTo(getTextByLocale(a.name, strings.locale)));
        break;
      case "nameAsc":
        product.sort((a, b) => getTextByLocale(a.name, strings.locale).compareTo(getTextByLocale(b.name, strings.locale)));
        break;
      case "priceDesc":
        product.sort((a, b) => getMinAmountInProduct(b.price).compareTo(getMinAmountInProduct(a.price)));
        break;
      case "priceAsc":
        product.sort((a, b) => getMinAmountInProduct(a.price).compareTo(getMinAmountInProduct(b.price)));
        break;
      case "taxDesc":
        product.sort((a, b) => b.taxAdmin.compareTo(a.taxAdmin));
        break;
      case "taxAsc":
        product.sort((a, b) => a.taxAdmin.compareTo(b.taxAdmin));
        break;
      case "providerDesc":
        product.sort((a, b) => getProviderNameById(b.providers.isNotEmpty ? b.providers[0] : "", locale)
            .compareTo(getProviderNameById(a.providers.isNotEmpty ? a.providers[0] : "", locale)));
        break;
      case "providerAsc":
        product.sort((a, b) => getProviderNameById(a.providers.isNotEmpty ? a.providers[0] : "", locale)
            .compareTo(getProviderNameById(b.providers.isNotEmpty ? b.providers[0] : "", locale)));
        break;
    }
    _redraw();
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
        Expanded(child: SelectableText(strings.get(142),                       /// "Services",
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
        if (_mainModel.provider.providersComboValue.isNotEmpty)
          Expanded(child: Container(
              child: Combo(inRow: true, text: "",
                data: _mainModel.provider.providersCombo,
                value: _mainModel.provider.providersComboValue,
                onChange: (String value){
                  _mainModel.provider.providersComboValue = value;
                  paginationSetPage(1);
                  _redraw();
                },))),
      ],
    ));

    pagingStart();

    List<DataRow> _cells = [];
    for (var item in product){
      if (!_mainModel.getTextByLocale(item.name).toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (_mainModel.provider.providersComboValue != "1") {
        if (item.providers.isEmpty)
          continue;
        if (item.providers[0] != _mainModel.provider.providersComboValue)
          continue;
      }

      if (isNotInPagingRange())
        continue;
      _cells.add(DataRow(cells: [
        // visible
        DataCell(Text(item.visible ? strings.get(70) : strings.get(61), /// "Visible", "No",
          overflow: TextOverflow.ellipsis, style: item.visible ? theme.style13W800Green
              : theme.style13W800Red, )
        ),
        // name
        DataCell(Container(
            constraints: BoxConstraints(minWidth: 50, maxWidth: 150),
            child: SelectableText(getTextByLocale(item.name, strings.locale), style: theme.style14W400,))),
        // price
        DataCell(Container(child: SelectableText(getPriceString(getMinAmountInProduct(item.price)) +
          "-" + getPriceString(getMaxAmountInProduct(item.price)), style: theme.style14W400,))),
        // tax admin
        DataCell(Container(child: SelectableText(item.taxAdmin.toStringAsFixed(0) + "%", style: theme.style14W400,))),
        // provider
        DataCell(Container(
            constraints: BoxConstraints(minWidth: 50, maxWidth: 200),
            child: SelectableText(getProviderNameById(item.providers.isNotEmpty ? item.providers[0] : "", locale),
              style: theme.style14W400,))),
        // action
        DataCell(Center(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                button2small(strings.get(68), (){   /// "Edit",
                  _notEditorCreate = false;
                  redrawMainWindow();
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _mainModel.service.select(item);
                    var currentContext = dataKey.currentContext;
                    if (currentContext != null)
                      Scrollable.ensureVisible(currentContext, duration: Duration(seconds: 1));
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
      DataColumn(label: itemColumnWithSort(_sortBy, "taxAsc", "taxDesc", strings.get(226), _sortFilter)), /// "Tax for administration",
      DataColumn(label: itemColumnWithSort(_sortBy, "providerAsc", "providerDesc", strings.get(178), _sortFilter)), /// "Provider",
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

    if (isMobile()){
      if (!_notEditorCreate)
        list.add(EditInServices(keyM: dataKey));
      else
        list.add(Center(child: button2b(strings.get(146), (){ /// "Create new service",
          _notEditorCreate = false;
          currentProduct = ProductData.createEmpty();
          if (_mainModel.initEditorInServiceScreen != null)
            _mainModel.initEditorInServiceScreen!();
          _redraw();
        })));
      list.add(SizedBox(height: 10),);
      list.add(EmulatorServiceScreen());
    }else
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmulatorServiceScreen(),
          SizedBox(width: 20),
          if (!_notEditorCreate)
            Expanded(child: EditInServices(keyM: dataKey)),
          if (_notEditorCreate)
            Center(child: button2b(strings.get(146), (){ /// "Create new service",
              _notEditorCreate = false;
              _redraw();
            })),
        ],
    ));

    return list;
  }

  var _notEditorCreate = true;

  _openDialogDelete(ProductData value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      var ret = await deleteProduct(value);
      if (ret == null) {
        messageOk(context, strings.get(69)); // "Data deleted",
        if (value.id == currentProduct.id)
          currentProduct = ProductData.createEmpty();
      }else
        messageError(context, ret);
      setState(() {});
    }, context);
  }

  _copy(){
    _mainModel.service.copy();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.service.csv(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "service.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
