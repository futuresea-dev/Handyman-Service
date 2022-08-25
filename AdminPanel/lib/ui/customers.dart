import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import '../../../utils.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      var ret = await _mainModel.notifyModel.loadUsers2();
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
    return ListView(
      children: _getList(),
    );
  }

  _getList(){

    List<Widget> list = [];

    List<Widget> list3 = [];
    list3.add(SizedBox(height: 10,));
    list3.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(255), /// Customers list
          style: theme.style25W800,)),
      ],
    ));
    list3.add(SizedBox(height: 20,));
    list3.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list3.add(SizedBox(height: 10,));
    addButtonsCopyExportSearch(list3, _copy, _csv, strings.langCopyExportSearch, _onSearch);

    list.add(Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Column(
          children: list3
        )));

    list.add(SizedBox(height: 10,));

    pagingStart();

    for (var item in listUsers){
      if (item.providerApp)
        continue;
      if (item.role.isNotEmpty)
        continue;
      if (!item.name.toUpperCase().contains(_searchedValue.toUpperCase()) &&
          !item.email.toUpperCase().contains(_searchedValue.toUpperCase())
        ) continue;

      if (isNotInPagingRange())
        continue;
      list.add(Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (theme.darkMode) ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: _item(item)
      ));
    }

    paginationLine(list, _redraw, strings.get(88)); /// from
    list.add(SizedBox(height: 40));

    return list;
  }

  _item(UserData item){
    return Container(
      width: windowWidth,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 80,
                  width: 80,
                  child: (item.logoServerPath.isEmpty) ? CircleAvatar(backgroundImage: AssetImage("assets/avatar.png"), radius: 50,) :
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          item.logoServerPath,
                          height: 80,
                          fit: BoxFit.cover))),
              SizedBox(width: 20,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 10,),
                  Row(children: [
                    SelectableText(strings.get(54) + ":", style: theme.style14W600Grey,), /// "Name",
                    SizedBox(width: 10,),
                    Expanded(child: Text(item.name, style: theme.style14W800),)
                  ]),
                  SizedBox(height: 10,),
                  Row(children: [
                    SelectableText(strings.get(86) + ":", style: theme.style14W600Grey,), /// "Email",
                    SizedBox(width: 10,),
                    Expanded(child: Text(item.email, style: theme.style14W800),)
                  ]),
                  SizedBox(height: 10,),
                  Row(children: [
                    SelectableText(strings.get(182) + ":", style: theme.style14W600Grey,), /// "Status",
                    SizedBox(width: 10,),
                    if (item.visible)
                      Expanded(child: Text(strings.get(256), style: theme.style16W800Green),), /// Enabled
                    if (!item.visible)
                      Expanded(child: Text(strings.get(257), style: theme.style16W800Red),) /// "Disabled",
                  ]),
                ],
              )),
              SizedBox(width: 10,),
              if (!isMobile())
                _buttons(item),
              if (!isMobile())
                SizedBox(width: 10,),
            ],
          ),
          if (isMobile())
            SizedBox(height: 10,),
          if (isMobile())
            _buttons(item),
        ],
      ),
    );
  }

  _buttons(UserData item){
    return Column(
      children: [
        button2b(item.visible ? strings.get(258) : strings.get(259), (){_enable(item);}), // "Disable",  "Enable",
        SizedBox(height: 10,),
        button2b(strings.get(62), (){_delete(item);}), // "Delete",
      ],
    );
  }

  _enable(UserData item) async {
    var ret = await userSetEnable(item);
    if (ret != null)
      messageError(context, ret);
    _redraw();
  }

  _delete(UserData item){
      openDialogDelete(() async {
        Navigator.pop(context); // close dialog
        // demo mode
        if (appSettings.demo)
          return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
        var ret = await deleteUser(item);
        if (ret == null) {
          messageOk(context, strings.get(69)); // "Data deleted",
          for (var item2 in _mainModel.notifyModel.userData)
            if (item2.id == item.id) {
              _mainModel.notifyModel.userData.remove(item2);
              break;
            }
          for (var item2 in _mainModel.notifyModel.userDataWithProviders)
            if (item2.id == item.id) {
              _mainModel.notifyModel.userDataWithProviders.remove(item2);
              break;
            }
        }else
          messageError(context, ret);
        setState(() {});
      }, context);
  }

  _copy(){
    _mainModel.notifyModel.copyCustomers();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.notifyModel.csvCustomers(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "customers.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
