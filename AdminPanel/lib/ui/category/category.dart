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

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();
  final dataKey = GlobalKey();
  String _sortBy = "nameAsc";

  @override
  void dispose() {
    _controllerScroll.dispose();
    currentCategory = CategoryData.createEmpty();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      for (var item in _mainModel.serviceApp.screens)
        if (item.id == "main")
          _mainModel.serviceApp.selectScreen(item);
      _sortFilter(null);
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

  _sortFilter(String? val){
    if (val != null)
      _sortBy = val;
    switch(_sortBy){
      case "visibleAsc":
        categories.sort((a, b) => a.compareToVisible(b));
        break;
      case "visibleDesc":
        categories.sort((a, b) => b.compareToVisible(a));
        break;
      case "nameDesc":
        categories.sort((a, b) => getTextByLocale(b.name, strings.locale).compareTo(getTextByLocale(a.name, strings.locale)));
        break;
      case "nameAsc":
        categories.sort((a, b) => getTextByLocale(a.name, strings.locale).compareTo(getTextByLocale(b.name, strings.locale)));
        break;
      case "descDesc":
        categories.sort((a, b) => getTextByLocale(b.desc, strings.locale).compareTo(getTextByLocale(a.desc, strings.locale)));
        break;
      case "descAsc":
        categories.sort((a, b) => getTextByLocale(a.desc, strings.locale).compareTo(getTextByLocale(b.desc, strings.locale)));
        break;
    }
    _redraw();
  }

  _getList(){

    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(56), /// Categories
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);
    pagingStart();

    List<DataRow> _cells = [];
    for (var item in categories){
      if (!_mainModel.getTextByLocale(item.name).toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
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
            constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
            child: SelectableText(_mainModel.getTextByLocale(item.name), style: theme.style14W400,))),
        // desc
        DataCell(Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
            child: Text(_mainModel.getTextByLocale(item.desc),
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        // image
        DataCell(showImage(item.serverPath, width: 50, height: 50)),
        // action
        DataCell(Center(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                button2small(strings.get(68), (){ /// "Edit",
                  openInEdit(item);
                }, color: theme.mainColor.withAlpha(150)),
                SizedBox(width: 5,),
                button2small(strings.get(62), (){_openDialogDelete(item);},
                    color: dashboardErrorColor.withAlpha(150) ), /// "Delete",
                SizedBox(width: 5,),
              ],
            )
        ))
        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: itemColumnWithSort(_sortBy, "visibleAsc", "visibleDesc", strings.get(70), _sortFilter)), /// Visible
      DataColumn(label: itemColumnWithSort(_sortBy, "nameAsc", "nameDesc", strings.get(54), _sortFilter)), /// name
      DataColumn(label: itemColumnWithSort(_sortBy, "descAsc", "descDesc", strings.get(73), _sortFilter)), /// Description
      DataColumn(label: Expanded(child: Text(strings.get(215), style: theme.style14W600Grey))), /// "Image",
      DataColumn(label: Expanded(child: Center(child: Text(strings.get(66), style: theme.style14W600Grey)))), // action
    ];

    list.add(Container(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      child: horizontalScroll(DataTable(
          columns: _column,
          rows: _cells,
      ), _controllerScroll))
    );

    paginationLine(list, _redraw, strings.get(88)); /// from
    //
    //
    //

    list.add(SizedBox(height: 40));
    Widget _categoryTree = TreeInCategory(deleteDialog: _openDialogDelete,
        select: openInEdit,
        stringCategoryTree: strings.get(232), /// Category tree
        stringDelete: strings.get(62) /// "Delete",
    );

    if (isMobile()){
      list.add(_categoryTree);
      list.add(SizedBox(height: 10,));
      if (!_notEditorCreate)
        list.add(EditInCategory(keyM: dataKey));
      else
        list.add(Center(child: button2b(strings.get(77), (){ /// "Create new category",
          _notEditorCreate = false;
          _redraw();
        })));
      list.add(SizedBox(height: 10,));
      list.add(EmulatorServiceScreen());
    }else
      list.add(Row(
          children: [
            EmulatorServiceScreen(),
            SizedBox(width: 20),
            Expanded(child: Column(
              children: [
                _categoryTree,
                SizedBox(height: 20,),
                if (_notEditorCreate)
                  Center(child: button2b(strings.get(77), (){ /// "Create new category",
                    _notEditorCreate = false;
                    _redraw();
                  })),
                if (!_notEditorCreate)
                  EditInCategory(keyM: dataKey),
              ]
            ))
          ]
    ));
    return list;
  }

  openInEdit(CategoryData item){
    _notEditorCreate = false;
    currentCategory = item;
    redrawMainWindow();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _mainModel.category.select(item);
      var currentContext = dataKey.currentContext;
      if (currentContext != null)
        Scrollable.ensureVisible(currentContext, duration: Duration(seconds: 1));
    });
  }

  var _notEditorCreate = true;

  _openDialogDelete(CategoryData value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      var ret = await categoryDelete(value);
      _mainModel.category.parentListMake();
      if (ret == null)
        messageOk(context, strings.get(69)); // "Data deleted",
      else
        messageError(context, ret);
      setState(() {});
    }, context);
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _copy(){
    _mainModel.category.copy();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.category.csv(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "category.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
