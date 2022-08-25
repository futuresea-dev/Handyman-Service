import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';

import '../strings.dart';
import '../theme.dart';

class DialogAddVariants extends StatefulWidget {
  final Function() close;

  const DialogAddVariants({Key? key, required this.close}) : super(key: key);


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
        width: windowWidth,
        height: windowHeight,
        child: Stack(
          children: [

            InkWell(
              onTap: widget.close,
              child:
              Container(
                width: windowWidth,
                height: windowHeight,
                color: Colors.grey.withAlpha(50),
              ),
            ),


        Center(
            child: Container(
                width: windowWidth*0.8,
                height: windowHeight*0.6,
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [

                    Container(
                      margin: EdgeInsets.only(top: 130, bottom: 50),
                      color: Colors.grey.withAlpha(20),
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: Scrollbar(
                          isAlwaysShown: true,
                          controller: _controllerScroll,
                          child: ListView(
                            controller: _controllerScroll,
                            children: _list(),
                      )),
                    )),

                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(strings.get(347), style: theme.style14W800,), /// "Addons"
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text(strings.get(108), style: theme.style14W400,), /// "Select language",
                            Expanded(child: Container(
                                width: 120,
                                child: Combo(inRow: true, text: "",
                                  data: _mainModel.langDataCombo,
                                  value: _mainModel.langEditDataComboValue,
                                  onChange: (String value){
                                    _mainModel.langEditDataComboValue = value;
                                    if (editAddon != null)
                                      _controllerName.text = getTextByLocale(editAddon!.name, _mainModel.langEditDataComboValue);
                                    _redraw();
                                  },))),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(children: [
                          Expanded(child: textElement2(strings.get(54), "", _controllerName, (String val){         /// "Name",
                          })),
                          SizedBox(width: 10,),
                          numberElement2Price(strings.get(144), /// Price
                              "123", appSettings.symbol, _controllerPrice, (String val){
                              }, appSettings.digitsAfterComma),
                          SizedBox(width: 10,),
                          button2small(editAddon == null ? strings.get(348) : strings.get(351), /// "Add addon",  "Save addon",
                              () async {
                            var ret = await productAddAddon(_controllerName.text, toDouble(_controllerPrice.text), _mainModel.langEditDataComboValue,
                              null,
                              strings.get(91), /// "Please Enter Name",
                              strings.get(342), /// "Please enter price",
                            );
                            if (ret != null)
                              return messageError(context, ret);
                            _controllerPrice.text = "";
                            _controllerName.text = "";
                            _redraw();
                          })
                        ],),
                        SizedBox(height: 20,),
                      ],
                    ),

                    Container(
                      alignment: Alignment.bottomCenter,
                      child: button2small(strings.get(184), () {  /// "Close",
                        widget.close();
                      }),
                    )

                  ],
                )

            )
        )
      ],
        ));
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
            child: Center(child: Text(strings.get(54), style: theme.style12W800, ))), /// "Name",
        ),
        SizedBox(width: 2,),
        Expanded(
          flex: 2,
          child: Container(
              color: Colors.grey.withAlpha(150),
              padding: EdgeInsets.all(10),
              child: Center(child: Text(strings.get(144), style: theme.style12W800, ))), /// "Price",
        ),
        SizedBox(width: 2,),
        Expanded(
          child: Container(
              color: Colors.grey.withAlpha(150),
              padding: EdgeInsets.all(10),
              child: Center(child: Text(strings.get(68), style: theme.style12W800, ))), /// "Edit",
        ),
        SizedBox(width: 2,),
        Expanded(
          child: Container(
              color: Colors.grey.withAlpha(150),
              padding: EdgeInsets.all(10),
              child: Center(child: Text(strings.get(62), style: theme.style12W800, ))), /// "Delete",
        ),
        SizedBox(width: 2,),
        Expanded(
          child: Container(
              color: Colors.grey.withAlpha(150),
              padding: EdgeInsets.all(10),
              child: Center(child: Text(strings.get(349), style: theme.style12W800, ))), /// "Select",
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

    var _providerAddons = _mainModel.service.getProviderAddons();
    if (_providerAddons != null)
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

    list.add(SizedBox(height: 200,));

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
                child: Text(getTextByLocale(item.name, _mainModel.langEditDataComboValue))
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
          button134(strings.get(68), /// "Edit",
              (){
                editAddon = item;
                _controllerPrice.text = item.price.toString();
                _controllerName.text = getTextByLocale(item.name, _mainModel.langEditDataComboValue);
                _redraw();
              }, style: theme.style13W800Green),
        )
        ),
        SizedBox(width: 2,),
        Expanded(child: Container(
          alignment: Alignment.center,
          color: _grey ? Colors.grey.withAlpha(80) : Colors.transparent,
          padding: EdgeInsets.all(5),
          child: button134(strings.get(62), /// "Delete",
                  () {
                openDialogDelete(item);
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
              selectAddon(item, val);
              item.selected = !item.selected;
              _redraw();
            }))
        )),

      ],
    ));
  }

  openDialogDelete(AddonData item){
    EasyDialog(
        colorBackground: Colors.white,
        body: Column(
          children: [
            Text(strings.get(350)), /// "Addon will be deleted from all services in current Provider. Do you want to delete this item? You will can't recover this item. "
            SizedBox(height: 40,),
            Row(
              children: [
                Flexible(child: button2(strings.get(61), /// "No",
                    theme.mainColor,
                        (){
                      print("button pressed");
                      Navigator.pop(context); // close dialog
                    })),
                SizedBox(width: 10,),
                Flexible(child: button2(strings.get(62), /// "Delete",
                    dashboardErrorColor, () async {
                      Navigator.pop(context); // close dialog
                      var ret = await deleteAddon(item.id);
                      if (ret != null)
                        return messageError(context, ret);
                      else
                        messageOk(context, strings.get(64)); /// "Data deleted",
                      _redraw();
                    })),
              ],
            )
          ],
        )
    ).show(context);
  }


}

