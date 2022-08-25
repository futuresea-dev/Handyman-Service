
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';
import 'emulator.dart';
import 'list_fields.dart';
import 'list_screens.dart';

class AppServiceSettingsScreen extends StatefulWidget {
  @override
  _AppServiceSettingsScreenState createState() => _AppServiceSettingsScreenState();
}

class _AppServiceSettingsScreenState extends State<AppServiceSettingsScreen> {

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      await _mainModel.serviceApp.init(context);
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
    ),);
  }

  _getList(){

    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(99),                       /// Service App Settings
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    Widget _mainColor = Row(
      children: [
        SelectableText(strings.get(103), style: theme.style14W400,),          /// "Main color",
        SizedBox(width: 10,),
        Container(
          width: 150,
          child: ElementSelectColor(getColor: (){return _mainModel.serviceApp.onDemandMainColor2;},
            setColor: (Color value){
              _mainModel.serviceApp.setMainColor(value);
            },),
        )
      ],
    );

    Widget _bkgColor = Row(
      children: [
        SelectableText(strings.get(104), style: theme.style14W400,),          /// "Main background color",
        SizedBox(width: 10,),
        Container(
          width: 150,
          child: ElementSelectColor(getColor: (){return _mainModel.serviceApp.onDemandColorBackground2;},
            setColor: (Color value){
              _mainModel.serviceApp.setonDemandColorBackground(value);
            },),
        ),
      ],
    );

    if (isMobile()){
      list.add(_mainColor);
      list.add(SizedBox(height: 10,));
      list.add(_bkgColor);
    }else
      list.add(Row(
        children: [
          Expanded(child: _mainColor),
          SizedBox(width: 10,),
          Expanded(child: _bkgColor),
        ],
      ));

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));

    list.add(SizedBox(height: 20));

    list.add(SizedBox(height: 20));
    if (isMobile()) {
      list.add(ListScreens());
      list.add(EmulatorServiceScreen());
      list.add(ListFields());
    }else
      list.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmulatorServiceScreen(),
            SizedBox(width: 20),
            Expanded(child: Column(
              children: [
                ListScreens(),
                ListFields(),
              ],
            ))
          ],
        )
    );

    return list;
  }
}
