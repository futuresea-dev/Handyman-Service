import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/initData/statuses.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/ui/strings.dart';
import '../theme.dart';

class BookingStatusesScreen extends StatefulWidget {
  @override
  _BookingStatusesScreenState createState() => _BookingStatusesScreenState();
}

class _BookingStatusesScreenState extends State<BookingStatusesScreen> {

  final _controllerName = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }


  @override
  Widget build(BuildContext context) {
    return body(strings.get(173), "assets/dashboard2/dashboard5.png", _getList()); /// "Settings | Booking Statuses",
  }

  _getList() {
    List<Widget> list = [];

    // // ignore: unnecessary_statements
    // context.watch<BookingStatusesModel>().statuses;

    list.add(SizedBox(height: 20,));
    list.add(Row(children: [
      Text(strings.get(108), style: theme.style14W400,), /// "Select language",
      Expanded(child: Container(
         // width: 200,
          child: Combo(
            inRow: true, text: "",
            data: _mainModel.langDataCombo,
            value: _mainModel.langEditDataComboValue,
            onChange: (String value){
              _mainModel.langEditDataComboValue = value;
              // _mainModel.currentEmulatorLanguage = value;
              _controllerName.text = getTextByLocale(_mainModel.currentStatus.name, _mainModel.langEditDataComboValue);
              setState(() {});
            },))),
    ],));
    list.add(SizedBox(height: 30,));

    List<Widget> list2 = [];
    for (var item in appSettings.statuses) {
      list2.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Text(getTextByLocale(item.name, _mainModel.langEditDataComboValue),
                style: theme.style14W800)),
          SizedBox(width: 10,),
          CircleAvatar(
              radius: 20,
              backgroundColor: theme.mainColor,
              child: IconButton(icon: Icon(Icons.arrow_upward_rounded, color: Colors.white,), onPressed: (){
                _mainModel.settings.moveUp(item);
                _redraw();
              },)),
          SizedBox(width: 10,),
          CircleAvatar(
              radius: 20,
              backgroundColor: theme.mainColor,
              child: IconButton(icon: Icon(Icons.arrow_downward_rounded, color: Colors.white,), onPressed: (){
                _mainModel.settings.moveDown(item);
                _redraw();
              },)),
          SizedBox(width: 10,),
          CircleAvatar(
              radius: 20,
              backgroundColor: dashboardErrorColor,
              child: IconButton(icon: Icon(Icons.delete_forever, color: Colors.white,), onPressed: (){
                _mainModel.settings.delete(item, context, _redraw);
                _redraw();
              },)),
          SizedBox(width: 10,),
          CircleAvatar(
              radius: 20,                                       /// edit
              backgroundColor: Colors.green,
              child: IconButton(icon: Icon(Icons.edit, color: Colors.white,), onPressed: (){
                Provider.of<MainModel>(context,listen:false).settings.select(item);
                _controllerName.text = getTextByLocale(item.name, _mainModel.langEditDataComboValue);
                textFieldToEnd(_controllerName);
                _redraw();
              },)),
        ],
      ));
      list2.add(SizedBox(height: 5,));
      list2.add(SizedBox(height: 10,));
    }
    list2.add(SizedBox(height: 20,));
    list2.add(Center(child: button2b(strings.get(9), () async {  /// "Save"
      // demo mode
      if (appSettings.demo)
        return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
      var ret = await _mainModel.settings.saveStatuses();
      if (ret == null)
        messageOk(context, strings.get(81)); /// "Data saved",
      else
        messageError(context, ret);
    })));

    List<Widget> list3 = [];
    //
    // name
    //
    list3.add(textElement2(strings.get(54), "", _controllerName, (String val){         /// "Name",
      Provider.of<MainModel>(context,listen:false).settings.setName(val);
      _redraw();
    }));
    list3.add(SizedBox(height: 30,));
    _checkBoxes(list3, Provider.of<MainModel>(context,listen:false).currentStatus);
    list3.add(SizedBox(height: 30,));

    if (Provider.of<MainModel>(context,listen:false).currentStatus.id.isNotEmpty)
      list3.add(Row(
        children: [
          button2b(strings.get(225), (){}), /// "Save current",
          SizedBox(width: 10,),
          button2b(strings.get(226), (){  /// "Create new",
            _mainModel.currentStatus = StatusData.createEmpty();
            _controllerName.text = "";
            _redraw();
          }),
        ],
      ));
    else
      list3.add(button2b(strings.get(174), (){  /// "Add new",
        _mainModel.settings.create();
        setState(() {});
      }));

    if (isMobile()){
      list.add(Container(
          padding: EdgeInsets.all(20),
          color: theme.mainColor.withAlpha(60),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: list2
          )));
      list.add(SizedBox(height: 10,));
      list.add(Container(
        padding: EdgeInsets.all(20),
        color: theme.mainColor.withAlpha(60),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: list3
        )));
    }else
      list.add(
          Row(
            children: [
              Expanded(child: Container(
                  padding: EdgeInsets.all(20),
                  color: theme.mainColor.withAlpha(60),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: list2
                  ))),
              SizedBox(width: 20,),
              Expanded(child: Container(
                  padding: EdgeInsets.all(20),
                  color: theme.mainColor.withAlpha(60),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: list3
                  ))),
            ],
          ));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _checkBoxes(List<Widget> list2, StatusData item){
    list2.add(Container(
        width: double.maxFinite,
        child: checkBox1a(context, strings.get(228), /// "Managed by Customer App",
            theme.mainColor, theme.style14W400, item.byCustomerApp,
                (val) {
              if (val == null) return;
              item.byCustomerApp = val;
              setState(() {
              });
            })));

    list2.add(SizedBox(height: 8,));

    list2.add(Container(
      width: double.maxFinite,
      child: checkBox1a(context, strings.get(229), /// "Managed by Provider App",
          theme.mainColor, theme.style14W400, item.byProviderApp,
              (val) {
            if (val == null) return;
            item.byProviderApp = val;
            setState(() {
            });
          })));

    list2.add(SizedBox(height: 8,));

    list2.add(
        Container(
            width: double.maxFinite,
            child: checkBox1a(context, strings.get(230), /// "Canceling",
            theme.mainColor, theme.style14W400, item.cancel,
                (val) {
              if (val == null) return;
              item.cancel = val;
              setState(() {
              });
            }))
    );

    list2.add(SizedBox(height: 8,));

    list2.add(
        Row(
          children: [
            Text(strings.get(231) + ":"), /// "Current image",
            SizedBox(width: 10,),
            if (item.serverPath.isNotEmpty)
              Expanded(child: Image.network(item.serverPath, fit: BoxFit.contain,)),
            if (item.serverPath.isNotEmpty)
              SizedBox(width: 10,),
            Expanded(child: button2b(strings.get(75), /// "Select image",
                (){_selectImage(item);})),
          ],
        )
    );
  }

  _selectImage(StatusData item) async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      messageError(context, e.toString());
    }
    if (pickedFile != null){
      waitInMainWindow(true);
      var ret = await uploadStatusImage(item, await pickedFile.readAsBytes());
      waitInMainWindow(false);
      if (ret == null)
        messageOk(context, strings.get(363)); /// "Image saved",
      else
        messageError(context, ret);
      _redraw();
    }
  }
}


