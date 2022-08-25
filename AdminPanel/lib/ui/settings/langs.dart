import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class AppLangScreen extends StatefulWidget {
  @override
  _AppLangScreenState createState() => _AppLangScreenState();
}

class _AppLangScreenState extends State<AppLangScreen> {

  final _controllerText = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerText.dispose();
    super.dispose();
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
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user == null)
    //   return logout(context);

    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(SelectableText(strings.get(107), style: theme.style25W800,)); /// Languages
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    var _selectApp = Row(
      children: [
        Text(strings.get(109), style: theme.style14W400,), /// "Select Application",
        Expanded(child: Container(
            width: 120,
            child: Combo(inRow: true, text: "",
              data: _mainModel.appsDataCombo,
              value: _mainModel.appsDataComboValue,
              onChange: (String value){
                _mainModel.langs.setApp(value);
                _redraw();
              },))),
      ],
    );

    var _defLang = Row(
      children: [
        Text(strings.get(131), style: theme.style14W400,), /// "Default language",
        Expanded(child: Container(
            width: 120,
            child: Combo(inRow: true, text: "",
              data: _mainModel.langDataCombo,
              value: _mainModel.langs.getDefaultLangByApp(),
              onChange: (String value){
                _mainModel.langs.setDefaultLangByApp(value);
                _redraw();
              },))),
      ],
    );

    if (isMobile()){
      list.add(_selectApp);
      list.add(SizedBox(height: 20,));
      list.add(_defLang);
    }else
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: _selectApp),
          SizedBox(width: 20,),
          Expanded(child: _defLang),
        ],
      ));

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    if (isMobile()) {
      list.add(_selectLanguage());
      list.add(SizedBox(height: 10,));
      list.add(_showAndSearch());
    }else
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: _selectLanguage()),
        SizedBox(width: 20,),
        _showAndSearch(),
      ],
    ));
    list.add(SizedBox(height: 10,));

    pagingStart();

    List<DataRow> _cells = [];
    for (var item in _mainModel.listWordsForEdit){
      if (!item.word.toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (isNotInPagingRange())
        continue;
      //
      // print("------------------> -------------> item.controller=${item.controller}");
      _cells.add(DataRow(cells: [
        // id
        DataCell(Container(child: Text(item.id, overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
        // word
        DataCell(Container(child: textElement2("", "", item.controller, (String val){
          item.word = val;
          _mainModel.langs.saveWord(item.id, val);
        })))

      ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: Expanded(child: Text(strings.get(114), style: theme.style14W600Grey))), // id
      DataColumn(label: Expanded(child: Text(strings.get(113), style: theme.style14W600Grey))), // word
    ];

    list.add(SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: (windowWidth/2 < 600) ? 600 : windowWidth-400,
              color: (theme.darkMode) ? Colors.black : Colors.white,
              child: DataTable(
                  columns: _column,
                  rows: _cells,
            )))));

    paginationLine(list, _redraw, strings.get(88)); /// from
    //
    //
    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        button2b(strings.get(9), _save), /// "Save"
      ],
    ));

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(strings.get(207) + ":", style: theme.style14W400,), // "Add new language",
        SizedBox(width: 5,),
        Expanded(child: Container(
            width: 120,
            child: Combo(inRow: true, text: "",
              data: _mainModel.langs.getNewLangList(),
              value: _mainModel.langs.newLandValue,
              onChange: (String value){
                Provider.of<MainModel>(context,listen:false).langs.newLandValue = value;
                setState(() {
                });
              },))),
        SizedBox(width: 20,),
        if (!isMobile())
          button2b(strings.get(209), _create), /// "Create"
      ],
    ));
    if (isMobile()){
      list.add(SizedBox(height: 10,));
      list.add(button2b(strings.get(209), _create)); /// "Create"
    }

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.get(208),  /// "By default all words will be in english language. You must translate all words by himself.",
      style: theme.style16W800Red,),);

    list.add(SizedBox(height: 100,));
    return list;
  }

  _create() async {
    waitInMainWindow(true);
    var ret = await Provider.of<MainModel>(context,listen:false).langs.createNewLanguage();
    if (ret == null)
      messageOk(context, strings.get(210)); /// "Language added",
    else
      messageError(context, ret);
    waitInMainWindow(false);
  }

  _save() async {
    if (appSettings.demo)
      return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
    waitInMainWindow(true);
    var ret = await Provider.of<MainModel>(context,listen:false).langs.saveLanguageWords();
    if (ret == null)
      messageOk(context, "${strings.get(185)} ${_mainModel.editLangNowDataComboValue}"); /// "Data saved for language: ",
    else
      messageError(context, ret);
    waitInMainWindow(false);
  }

  final List<ComboData> _paginData = [ComboData("5", "5"), ComboData("10", "10"), ComboData("15", "15"), ComboData("20", "20"),
    ComboData("30", "30"), ComboData("50", "50"), ComboData("100", "100"),];

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }

  _selectLanguage(){
    if (_mainModel.langDataCombo.isNotEmpty) {
      var _found = false;
      for (var item in _mainModel.langDataCombo)
        if (item.id == _mainModel.editLangNowDataComboValue)
          _found = true;
      if (!_found)
        _mainModel.editLangNowDataComboValue = _mainModel.langDataCombo[0].id;
    }
    return Row(
      children: [
        Text(strings.get(108), style: theme.style14W400, overflow: TextOverflow.ellipsis,), /// "Select language",
        Expanded(child: Container(
            width: 120,
            child: Combo(inRow: true, text: "",
              data: _mainModel.langDataCombo,
              value: _mainModel.editLangNowDataComboValue,
              onChange: (String value) async {
                await Provider.of<MainModel>(context,listen:false).setLang(value);
                setState(() {
                });
              },)))
      ],
    );
  }

  _showAndSearch(){
    if (isMobile())
      return Column(
        children: [
          Row(
            children: [
              Text(strings.get(89), style: theme.style14W400,), // "Show",
              Expanded(child: Container(
                  child: Combo(inRow: true, text: "",
                    data: _paginData,
                    value: pRange.toString(),
                    onChange: (String value){
                      pRange = int.parse(value);
                      setState(() {
                      });
                    },))),
              SizedBox(width: 5,),
              Text(strings.get(90), style: theme.style14W400,), // "entries",
            ],
          ),
          SizedBox(height: 10,),
          Container(child: textElement2(strings.get(60), "", _controllerText, _onSearch))
        ],
      );
    return Row(
      children: [
        Text(strings.get(89), style: theme.style14W400,), // "Show",
        Container(
            width: 120,
            child: Combo(inRow: true, text: "",
              data: _paginData,
              value: pRange.toString(),
              onChange: (String value){
                pRange = int.parse(value);
                setState(() {
                });
              },)),
        SizedBox(width: 5,),
        Text(strings.get(90), style: theme.style14W400,), // "entries",
        SizedBox(width: 20,),
        Container(width: 200, child: textElement2(strings.get(60), "", _controllerText, _onSearch))
      ],
    );
  }
}


