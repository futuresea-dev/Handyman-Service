import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/appService/emulator.dart';
import 'package:ondemand_admin/model/serviceappsettings.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import '../../../utils.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'edit.dart';

class BannersScreen extends StatefulWidget {
  @override
  _BannersScreenState createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {

  var _notEditorCreate = true;
  late MainModel _mainModel;
  final _currentEditWindowKey = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
    _mainModel.banner.current = BannerData.createEmpty();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      _mainModel.serviceApp.select = Screen("banner", "banner", []);
      var ret = await _mainModel.banner.load();
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
        Expanded(child: SelectableText(strings.get(328), /// "Banners",
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);
    list.add(SizedBox(height: 10,));

    pagingStart();

    List<DataRow> _cells = [];
    for (var item in _mainModel.banner.banners){
      if (!item.name.toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (isNotInPagingRange())
        continue;

      _cells.add(DataRow(cells: [
        // name
        DataCell(Container(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.name,
              overflow: TextOverflow.ellipsis, style: theme.style14W400,),
        ],
        ))),
        // type
        DataCell(Container(child: Text(item.type,
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        // status
        DataCell(Container(child: Text("",
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        // action
        DataCell(Center(child:Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 5,),
            button2small(strings.get(68), (){ /// "Edit",
              _notEditorCreate = false;
              redrawMainWindow();
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _mainModel.banner.select(item);
                var currentContext = _currentEditWindowKey.currentContext;
                if (currentContext != null)
                  Scrollable.ensureVisible(currentContext, duration: Duration(seconds: 1));
              });
            }, color: theme.mainColor.withAlpha(150)),
            SizedBox(width: 5,),
            button2small(strings.get(62),  /// "Delete",
                (){_openDialogDelete(item);}, color: dashboardErrorColor.withAlpha(150)),
            SizedBox(width: 5,),
          ],
        )))

        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: Expanded(child: Text(strings.get(54), style: theme.style14W600Grey))), // Name
      DataColumn(label: Expanded(child: Text(strings.get(329), style: theme.style14W600Grey))), // Banner type
      DataColumn(label: Expanded(child: Text(strings.get(182), style: theme.style14W600Grey))), // Status
      DataColumn(label: Expanded(child: Text(strings.get(66), style: theme.style14W600Grey))), // Action
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
        list.add(Container(
          key: _currentEditWindowKey,
          child: EditInBanner()));
      else
        list.add(Center(child: button2b(strings.get(333), (){ /// "Create new banner",
          _notEditorCreate = false;
          _redraw();
        })));
      list.add(SizedBox(height: 10),);
      list.add(EmulatorServiceScreen());
    }else
      list.add(Row(
          children: [
            EmulatorServiceScreen(),
            SizedBox(width: 20),
            Expanded(child: Column(
              children: [
                if (!_notEditorCreate)
                  Container(
                      key: _currentEditWindowKey,
                      child: EditInBanner()),
                if (_notEditorCreate)
                  Center(child: button2small(strings.get(333), (){ /// "Create new banner",
                    _notEditorCreate = false;
                    _redraw();
                  })),
              ],
            ))
          ],
        )
    );
    return list;
  }

  _copy(){
    _mainModel.banner.copy();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.banner.csv(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "banners.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }

  _openDialogDelete(BannerData value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      var ret = await _mainModel.banner.delete(value);
      if (ret == null)
        messageOk(context, strings.get(69)); /// "Data deleted",
      else
        messageError(context, ret);
      setState(() {});
    }, context);
  }
}
