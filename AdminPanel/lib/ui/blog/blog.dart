import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import '../../../../utils.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'blog_widget.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {

  var _notEditorCreate = true;
  final _controllerSearch = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerDesc = TextEditingController();
  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
    _controllerSearch.dispose();
    _controllerName.dispose();
    _controllerDesc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      var ret = await _mainModel.blog.load();
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
        Expanded(child: SelectableText(strings.get(352), /// "Blog",
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
        Text(strings.get(108), style: theme.style14W400,), /// "Select language",
        Expanded(child: Container(
            width: 120,
            child: Combo(inRow: true, text: "",
              data: _mainModel.langDataCombo,
              value: _mainModel.langEditDataComboValue,
              onChange: (String value){
                _mainModel.langEditDataComboValue = value;
                if (!_notEditorCreate){
                  _controllerName.text = getTextByLocale(_mainModel.blog.current.name, _mainModel.langEditDataComboValue);
                  _controllerDesc.text = getTextByLocale(_mainModel.blog.current.desc, _mainModel.langEditDataComboValue);
                  _mainModel.blog.controller.setText(getTextByLocale(_mainModel.blog.current.text, _mainModel.langEditDataComboValue));
                }
                _redraw();
              },))),
      ],
    ));

    pagingStart();

    List<DataRow> _cells = [];
    for (var item in _mainModel.blog.blog){
      if (_searchedValue.isNotEmpty)
        if (!getTextByLocale(item.name, _mainModel.langEditDataComboValue).toUpperCase().contains(_searchedValue.toUpperCase()))
          continue;
      if (isNotInPagingRange())
        continue;

      _cells.add(DataRow(cells: [
        // name
        DataCell(Container(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(getTextByLocale(item.name, _mainModel.langEditDataComboValue),
              overflow: TextOverflow.ellipsis, style: theme.style14W400,),
        ],
        ))),
        // date
        DataCell(Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(timeago.format(item.time, locale: appSettings.currentAdminLanguage),
                overflow: TextOverflow.ellipsis, style: theme.style14W400),
            Text(appSettings.getDateTimeString(item.time),
                overflow: TextOverflow.ellipsis, style: theme.style12W600Grey)
          ],
        )),
        // action
        DataCell(Center(child:Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 5,),
            button2small(strings.get(68), (){ /// "Edit",
              _mainModel.blog.select(item, _notEditorCreate);
              _notEditorCreate = false;
              _controllerName.text = getTextByLocale(item.name, _mainModel.langEditDataComboValue);
              _controllerDesc.text = getTextByLocale(item.desc, _mainModel.langEditDataComboValue);
              _redraw();
              // if (_currentEditWindowKey.currentContext != null)
              //   Scrollable.ensureVisible(_currentEditWindowKey.currentContext!, duration: Duration(seconds: 1));
            }, color: theme.mainColor.withAlpha(150)),
            SizedBox(width: 5,),
            button2small(strings.get(62), /// "Delete",
                (){
                    _openDialogDelete(item);
              }, color: dashboardErrorColor.withAlpha(150)),
            SizedBox(width: 5,),
          ],
        )))

        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: Expanded(child: Text(strings.get(54), style: theme.style14W600Grey))), // Name
      DataColumn(label: Expanded(child: Text(strings.get(353), style: theme.style14W600Grey))), // Date
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


    if (!_notEditorCreate){
      list.add(SizedBox(height: 10,));
      list.add(Center(child: button2b(strings.get(354), (){ /// "Create new post",
        _mainModel.blog.emptyCurrent();
        _controllerName.text = "";
        _controllerDesc.text = "";
        _redraw();
      })));
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Expanded(child: Focus(
              onFocusChange: (hasFocus) {
                // if(hasFocus)
                //   _mainModel.blog.controller.clearFocus();
              },
              child: textElement2(strings.get(54), "", _controllerName, (String val){         /// "Name",
            _mainModel.blog.setName(val);
          }))),
          SizedBox(width: 10,),
          button2b(strings.get(355), () async { /// "Save post",
            _notEditorCreate = false;
            var ret = await _mainModel.blog.save(_controllerName.text, _controllerDesc.text);
            if (ret == null)
              messageOk(context, strings.get(81)); /// "Data saved",
            else
              messageError(context, ret);
            _redraw();
          })
        ],
      ));
      list.add(SizedBox(height: 10,));
      list.add(textElement2(strings.get(359), "", _controllerDesc, (String val){         /// "Short description",
        _mainModel.blog.setDesc(val);
      }));
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Text(strings.get(362) + ":", style: theme.style14W400), /// "Preview image",
          SizedBox(width: 10,),
          button2b(strings.get(75), _selectImage) /// "Select image",
        ],
      ));
      list.add(SizedBox(height: 10,));
      list.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(theme.radius)),
            border: Border.fromBorderSide(BorderSide(color: Colors.grey, width: 1)),
          ),
          child: blogWidget(_mainModel.blog.controller, windowHeight)));
      list.add(SizedBox(height: 10,));
    }else{
      list.add(SizedBox(height: 10,));
      list.add(Center(child: button2b(strings.get(354), (){ /// "Create new post",
        _notEditorCreate = false;
        _redraw();
      })),
      );
    }

    list.add(SizedBox(height: 40));

    return list;
  }

  _copy() async {
    _mainModel.blog.copy();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.blog.csv(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "blog.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }

  _openDialogDelete(BlogData value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      var ret = await _mainModel.blog.delete(value);
      if (ret == null)
        messageOk(context, strings.get(69)); /// "Data deleted",
      else
        messageError(context, ret);
      setState(() {});
    }, context);
  }

  _selectImage() async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null){
      waitInMainWindow(true);
      var ret = await _mainModel.blog.setImageData(await pickedFile.readAsBytes());
      if (ret == null)
        messageOk(context, strings.get(363)); /// "Image saved",
      else
        messageError(context, ret);
      waitInMainWindow(false);
    }
  }
}
