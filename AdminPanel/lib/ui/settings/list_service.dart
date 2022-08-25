import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';

class ListServiceScreen extends StatefulWidget {
  @override
  _ListServiceScreenState createState() => _ListServiceScreenState();
}

class _ListServiceScreenState extends State<ListServiceScreen> {

  final _controllerSearch = TextEditingController();
  late MainModel _mainModel;

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      var ret = await _mainModel.service.load(context);
      if (ret != null)
        messageError(context, ret);
      for (var item in product) {
        if (appSettings.inMainScreenServices.contains(item.id))
          item.select = true;
        else
          item.select = false;
      }
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
    list.add(SelectableText(strings.get(337), style: theme.style25W800,)); /// "List Service",
    list.add(SizedBox(height: 5,));
    list.add(SelectableText(strings.get(338), style: theme.style14W400,)); /// "Select services which will be always show in main screen in customer app.",
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    _service(list);

    return list;
  }

  bool _onlySelected = false;

  _service(List<Widget> list2){

    // List<ProductData> _services = context.watch<MainModel>().service.services;

    list2.add(SizedBox(height: 10,));
    list2.add(Row(
      children: [
        Expanded(child: checkBox1a(context, strings.get(168), /// "Only selected"
            theme.mainColor, theme.style14W400, _onlySelected,
                (val) {
              if (val == null) return;
              _onlySelected = val;
              _redraw();
            })),
        button2b(strings.get(9), _save) /// "Save",
      ],
    ));
    list2.add(SizedBox(height: 10,));

    for (var item in product){
      if (_onlySelected && !item.select)
        continue;
      Widget _image = (item.gallery.isNotEmpty) ? (item.gallery[0].serverPath.isNotEmpty) ?
      Image.network(item.gallery[0].serverPath, fit: BoxFit.contain) : Container() : Container();
      list2.add(Stack(
        children: [
          Container(
              key: item.dataKey,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 0, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: (_mainModel.banner.current.open == item.id)
                    ? theme.mainColor.withAlpha(120) : (theme.darkMode) ? Colors.black : dashboardColorCardGreenGrey,
                borderRadius: BorderRadius.circular(theme.radius),
              ),
              child: Row(children: [
                Container(
                    width: 40,
                    height: 40,
                    child: _image),
                SizedBox(width: 20,),
                Expanded(child: Text(_mainModel.getTextByLocale(item.name), style: theme.style14W400,)),
              ],)),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: (){
                    item.select = !item.select;
                    _redraw();
                  },
                )),
          ),
          Positioned.fill(
              child: Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.centerRight,
                  child: checkBox0(theme.mainColor, item.select, (val) {
                    item.select = val!;
                    _redraw();
                  })
              )
          )
        ],
      )
      );
    }
    return list2;
  }

  _save() async {
    var ret = await _mainModel.service.saveInMainScreenServices();
    if (ret == null)
      messageOk(context, strings.get(81)); /// "Data saved",
    else
      messageError(context, ret);
  }
}
