import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class DialogAddVariants extends StatefulWidget {
  final Function() close;
  final Function(AddonData item) openDialogDelete;

  const DialogAddVariants({Key? key, required this.close, required this.openDialogDelete}) : super(key: key);

  @override
  _DialogAddVariantsState createState() => _DialogAddVariantsState();
}

class _DialogAddVariantsState extends State<DialogAddVariants> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerName = TextEditingController();
  final _controllerPrice = TextEditingController();
  final ScrollController _controllerScroll = ScrollController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    editAddon = null;
    super.initState();
  }

  @override
  void dispose() {
    editAddon = null;
    _controllerScroll.dispose();
    _controllerName.dispose();
    _controllerPrice.dispose();
    super.dispose();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            ListView(
              children: [

                Text(strings.get(159), style: theme.style14W800,), /// "Addons"
                SizedBox(height: 10,),
                Text(strings.get(150), style: theme.style14W400,), /// "Select language",
                SizedBox(height: 5,),
                Combo(inRow: true, text: "",
                  data: _mainModel.customerAppLangsCombo,
                  value: _mainModel.customerAppLangsComboValue,
                  onChange: (String value){
                    _mainModel.customerAppLangsComboValue = value;
                    if (editAddon != null)
                      _controllerName.text = getTextByLocale(editAddon!.name,
                          _mainModel.customerAppLangsComboValue);
                    _redraw();
                  },),
                SizedBox(height: 10,),
                Divider(),
                SizedBox(height: 10,),
                Text(strings.get(16), style: theme.style14W400,), /// "Name",
                SizedBox(height: 5,),
                textElement2("", "", _controllerName, (String val){}),

                SizedBox(height: 10,),
                numberElement2Price(strings.get(153), /// "Price",
                    "123", appSettings.symbol, _controllerPrice, (String val){
                    }, appSettings.digitsAfterComma),

                SizedBox(height: 10,),
                Divider(),
                SizedBox(height: 10,),

                ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: Scrollbar(
                isAlwaysShown: true,
                controller: _controllerScroll,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _controllerScroll,
                    child: Container(
                  width: 600,
                  color: Colors.grey.withAlpha(20),
                  child: Column(
                    children: _list(),
                ))))),

                SizedBox(height: 200,),
              ],
            ),

            Container(
              alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                button2(editAddon == null ? strings.get(160) : strings.get(173), /// "Add addon",  "Save addon",
                    theme.mainColor, () async {
                      var ret = await productAddAddon(_controllerName.text, toDouble(_controllerPrice.text),
                          _mainModel.customerAppLangsComboValue,
                          currentProvider,
                          strings.get(115), /// "Please Enter Name",
                          strings.get(170) /// "Please enter price",
                      );
                      if (ret != null)
                        return messageError(context, ret);
                      _controllerPrice.text = "";
                      _controllerName.text = "";
                      _redraw();
                    }),
                SizedBox(height: 10,),

                Container(
                  alignment: Alignment.bottomCenter,
                  child: button2(strings.get(174), theme.mainColor, () {  /// "Close",
                    widget.close();
                  }),
                )
              ],
            ))



          ],
        )
      );
  }

  _list(){
    List<Widget> list = [];

    list.add(Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey.withAlpha(150),
            padding: EdgeInsets.all(10),
            child: Center(child: Text(strings.get(16), style: theme.style12W800, ))), /// "Name",
        ),
        SizedBox(width: 2,),
        Expanded(
          flex: 2,
          child: Container(
              color: Colors.grey.withAlpha(150),
              padding: EdgeInsets.all(10),
              child: Center(child: Text(strings.get(153), style: theme.style12W800, ))), /// "Price",
        ),
        SizedBox(width: 2,),
        Expanded(
          child: Container(
              color: Colors.grey.withAlpha(150),
              padding: EdgeInsets.all(10),
              child: Center(child: Text(strings.get(133), style: theme.style12W800, ))), /// "Edit",
        ),
        SizedBox(width: 2,),
        Expanded(
          child: Container(
              color: Colors.grey.withAlpha(150),
              padding: EdgeInsets.all(10),
              child: Center(child: Text(strings.get(86), style: theme.style12W800, ))), /// "Delete",
        ),
        SizedBox(width: 2,),
        Expanded(
          child: Container(
              color: Colors.grey.withAlpha(150),
              padding: EdgeInsets.all(10),
              child: Center(child: Text(strings.get(175), style: theme.style12W800, ))), /// "Select",
        )
      ],
    ));
    list.add(SizedBox(height: 2,));
    bool _grey = false;

    for(var item in currentProduct.addon){
      item.selected = true;
      _oneItem(list, _grey, item);
      _grey = !_grey;
    }

    var _providerAddons = currentProvider.addon;

    for (var item in _providerAddons){
      bool _found = false;
      for (var currentAddon in currentProduct.addon)
        if (currentAddon.id == item.id)
          _found = true;
      if (!_found) {
        item.selected = false;
        _oneItem(list, _grey, item);
        _grey = !_grey;
      }
    }

    return list;
  }

  _oneItem(List<Widget> list, bool _grey, AddonData item){
    list.add(Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
                color: _grey ? Colors.grey.withAlpha(80) : Colors.transparent,
                padding: EdgeInsets.all(10),
                child: Text(getTextByLocale(item.name, _mainModel.customerAppLangsComboValue))
            )
        ),
        SizedBox(width: 2,),
        Expanded(
            flex: 2,
            child: Container(
                color: _grey ? Colors.grey.withAlpha(80) : Colors.transparent,
                padding: EdgeInsets.all(10),
                child: Text(getPriceString(item.price)))
        ),
        SizedBox(width: 2,),
        Expanded(child: Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          color: _grey ? Colors.grey.withAlpha(80) : Colors.transparent,
          child:
          button134(strings.get(133), /// "Edit",
              (){
                editAddon = item;
                _controllerPrice.text = item.price.toString();
                _controllerName.text = getTextByLocale(item.name, strings.locale);
                _redraw();
              }, style: theme.style13W800Green),
        )
        ),
        SizedBox(width: 2,),
        Expanded(child: Container(
          alignment: Alignment.center,
          color: _grey ? Colors.grey.withAlpha(80) : Colors.transparent,
          padding: EdgeInsets.all(5),
          child: button134(strings.get(86), /// "Delete",
                  () {
                widget.openDialogDelete(item);
              }, style: theme.style13W800Red),
        )
        ),
        SizedBox(width: 2,),
        Expanded(child: Container(
            color: _grey ? Colors.grey.withAlpha(80) : Colors.transparent,
            padding: EdgeInsets.all(5),
            child: Center(child: checkBox1a(context, "",
                theme.mainColor, theme.style14W400, item.selected,
                (val) {
              if (val == null) return;
              if (currentProvider.useMaxAddonInOneService && val)
                if (currentProduct.addon.length+1 > currentProvider.maxAddonInOneService)
                  return messageError(context, strings.get(265)); /// "You have exceeded the limit on the number of addons on one service. Contact support for more information.",
              selectAddon(item, val);
              item.selected = !item.selected;
              _redraw();
            }))
        )),

      ],
    ));
  }

}

