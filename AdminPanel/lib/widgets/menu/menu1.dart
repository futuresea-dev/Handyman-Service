import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../../ui/strings.dart';
import '../../ui/theme.dart';

class Menu1Data{
  String id;
  String text;
  IconData icon;
  Menu1Data(this.id, this.text, this.icon);
}

class Menu1 extends StatelessWidget {
  final BuildContext context;
  final Function(String) callback;
  final List<Menu1Data> data;
  final Function() redraw;
  Menu1({required this.context, required this.data, required this.callback, required this.redraw});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    //
    if (isMobile()){
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Text(strings.get(12), style: theme.style14W800), // "Dark Mode",
            SizedBox(width: 10,),
            Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: CheckBox48(onChanged: (bool value) {
                  theme = AppTheme(value);
                  redraw();
                }, value: theme.darkMode,)),
          ],
        ),
      ));
      list.add(SizedBox(height: 10,));
      list.add(Container(
          padding: EdgeInsets.only(top: 3, bottom: 3, right: 10, left: 10),
          width: 250,
          child: Combo(inRow: true, text: "",
            data: Provider.of<MainModel>(context,listen:false).adminDataCombo,
            value: appSettings.currentAdminLanguage,
            onChange: (String value) async {
              await Provider.of<MainModel>(context,listen:false).langs.setAdminLang(value, context);
              redraw();
              Navigator.pop(context);
            },)));
      list.add(SizedBox(height: 10,));
    }
    //
    for (var item in data)
      list.add(_menuItem(item.id, item.text, item.icon),);

    return Drawer(
        child: Container(
          color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
          child: ListView(
            padding: EdgeInsets.only(top: 50),
            children: list
          ),
        )
    );
  }

  _menuItem(String id, String name, IconData iconData){
    return Stack(
      children: <Widget>[
        ListTile(
          title: Text(name, style: theme.style16W800),
          leading:  UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Icon(iconData,
                  )
              )),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400]!.withAlpha(100),
                onTap: () {
                  Navigator.pop(context);
                  callback(id);
                }, // needed
              )),
        )
      ],
    );
  }

}