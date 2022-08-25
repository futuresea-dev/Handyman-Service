import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondprovider/model/model.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/ui/theme.dart';
import 'package:provider/provider.dart';
import 'add_variants.dart';

class EditServiceScreen extends StatefulWidget {
  @override
  _EditServiceScreenState createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  int _currentPriceLevel = 0;
  final _editControllerName = TextEditingController();
  final _controllerTax = TextEditingController();
  final _controllerDuration = TextEditingController();
  final _controllerDescTitle = TextEditingController();
  final _controllerDesc = TextEditingController();
  final List<TextEditingController> _controllerPrice = [];
  final List<TextEditingController> _controllerDiscPrice = [];
  final List<TextEditingController> _controllerNamePrice = [];
  late MainModel _mainModel;
  bool _openDialogAddons = false;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context, listen: false);
    for (var i = 0; i < 10; i++){
      _controllerPrice.add(TextEditingController());
      _controllerDiscPrice.add(TextEditingController());
      _controllerNamePrice.add(TextEditingController());
    }

    _init();
    super.initState();
  }

  _init(){
      for (var i = 0; i < 10; i++){
        _controllerPrice[i].text = "";
        _controllerDiscPrice[i].text = "";
        _controllerNamePrice[i].text = "";
      }

      for (var item in categories)
        if (currentProduct.category.contains(item.id))
          item.select = true;
        else
          item.select = false;

      var index = 0;
      for (var item in currentProduct.price){
        _controllerPrice[index].text = item.price.toString();
        textFieldToEnd(_controllerPrice[index]);
        _controllerDiscPrice[index].text = item.discPrice.toString();
        textFieldToEnd(_controllerDiscPrice[index]);
        _controllerNamePrice[index].text = getTextByLocale(item.name, _mainModel.customerAppLangsComboValue);
        textFieldToEnd(_controllerNamePrice[index]);
        index++;
      }
      _currentPriceLevel = index;

      _editControllerName.text = getTextByLocale(currentProduct.name, _mainModel.customerAppLangsComboValue);
      textFieldToEnd(_editControllerName);
      _controllerDescTitle.text = getTextByLocale(currentProduct.descTitle, _mainModel.customerAppLangsComboValue);
      textFieldToEnd(_controllerDescTitle);
      _controllerDesc.text = getTextByLocale(currentProduct.desc, _mainModel.customerAppLangsComboValue);
      textFieldToEnd(_controllerDesc);
      _controllerTax.text = currentProduct.tax.toString();
      textFieldToEnd(_controllerTax);
      _controllerDuration.text = currentProduct.duration.inMinutes.toString();
      textFieldToEnd(_controllerDuration);
  }

  @override
  void dispose() {
    _editControllerName.dispose();
    _controllerTax.dispose();
    _controllerDuration.dispose();
    _controllerDescTitle.dispose();
    _controllerDesc.dispose();
    for (var i = 0; i < 10; i++){
      _controllerPrice[i].dispose();
      _controllerDiscPrice[i].dispose();
      _controllerNamePrice[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          if (_openDialogAddons){
            _openDialogAddons = false;
            _redraw();
            return false;
          }
          return true;
    },
        child: Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: [

          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40, left: 10, right: 10),
            child: !_openDialogAddons
                ? ListView(
                    children: _body(),
                  )
            : DialogAddVariants(close: (){
              _openDialogAddons = false;
              _redraw();
            }, openDialogDelete: (AddonData item) {
              _itemToDelete = item;
              _show = 1;
              _redraw();
            },),
          ),

        appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
            strings.get(148), context, () {
          if (_openDialogAddons){
            _openDialogAddons = false;
            _redraw();
          }else
            Navigator.pop(context);
        }), /// "Edit Service",

        IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
          getBody: _getDialogBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),

          if (_wait)
            Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

    ]),
    )));
  }

  double _show = 0;

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _body() {
    List<Widget> list = [];

    list.add(Text(strings.get(150), style: theme.style14W400,)); /// "Select Language",
    list.add(SizedBox(height: 5,));
    list.add(Combo(inRow: true, text: "",
          data: _mainModel.customerAppLangsCombo,
          value: _mainModel.customerAppLangsComboValue,
          onChange: (String value){
            _mainModel.customerAppLangsComboValue = value;
            _init();
            _redraw();
          },),);

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.get(16), style: theme.style14W400)); /// "Name",
    list.add(SizedBox(height: 5,));
    list.add(Edit41web(controller: _editControllerName, onChange: (String val){
      productSetName(val, _mainModel.customerAppLangsComboValue);
    }, ));
    list.add(SizedBox(height: 10,));
    list.add(checkBox1a(context, strings.get(149), /// "Visible",
        theme.mainColor, theme.style14W400, currentProduct.visible,
            (val) {
          if (val == null) return;
          currentProduct.visible = val;
          _redraw();
        }));
    list.add(SizedBox(height: 10,));

    list.add(numberElement2Percentage(strings.get(151), "", _controllerTax, (String val){         /// "Tax",
      currentProduct.tax = toDouble(val);
      _redraw();
    }));

    list.add(SizedBox(height: 10,));
    list.add(Text(strings.get(152), style: theme.style14W400)); /// Description Title
    list.add(SizedBox(height: 5,));
    list.add(Edit41web(controller: _controllerDescTitle,
      onChange: (String val){
        productSetDescTitle(val, _mainModel.customerAppLangsComboValue);
        _redraw();
      },
    ));
    list.add(SizedBox(height: 10,));
    //
    // description
    //
    list.add(Text(strings.get(65), style: theme.style14W400,)); /// Description
    list.add(SizedBox(height: 5,));
    list.add(Edit41web(controller: _controllerDesc,
      onChange: (String val){
        productSetDesc(val, _mainModel.customerAppLangsComboValue);
      _redraw();
    }));
    list.add(SizedBox(height: 10,));

    //
    // price
    //
    Color _color = Colors.green.withAlpha(20);
    for (var i = 0; i <= _currentPriceLevel; i++) {
      list.add(_price(i, _color));
      if (_color == Colors.green.withAlpha(20))
        _color = Colors.blue.withAlpha(20);
      else
        _color = Colors.green.withAlpha(20);
    }

    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: Text(strings.get(159), style: theme.style14W400,), ), /// "Addons",
        SizedBox(width: 10,),
        Expanded(child: button2(strings.get(160), theme.mainColor, (){  /// "Add addon",
          _openDialogAddons = true;
          _redraw();
        }))
      ],
    ));
    list.add(SizedBox(height: 10,));
    list.add(_listAddons());

    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // Gallery
    //
    list.add(Text(strings.get(161), style: theme.style16W800));                 /// Gallery
    list.add(SizedBox(height: 10,));
    if (currentProduct.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: currentProduct.gallery.map((e){
            var _tag = UniqueKey().toString();
            return InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryScreen(item: e, gallery: currentProduct.gallery,
                          tag: _tag, textDirection: strings.direction,),
                      )
                  );
                },
                child: Container(
                    width: 100,
                    height: 100,
                    child: Hero(
                        tag: _tag,
                        child: Stack(
                          children: [
                            showImage(e.serverPath),
                            GestureDetector(
                              onTap: () async {
                                var ret = await deleteImageFromGallery(e);
                                if (ret == null)
                                  messageOk(context, strings.get(162)); /// "Image deleted",
                                else
                                  messageError(context, ret);
                                _redraw();
                              },
                              child: Icon(Icons.cancel, color: Colors.red,),
                            )
                          ],
                        )))
            );
          }).toList(),
        ),
      ));
    //
    list.add(SizedBox(height: 10,));
    list.add(button2(strings.get(163), theme.mainColor, (){        /// "Add image to gallery",
      _selectImageToGallery();
    }));
    //
    list.add(SizedBox(height: 10,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    list.add(SizedBox(height: 10,));
    list.add(
        Row(
          children: [
            Expanded(child: Text(strings.get(164) + ":", style: theme.style16W800, overflow: TextOverflow.ellipsis,)), /// "Service duration",
            SizedBox(height: 10,),
            numberElement2("", "10", strings.get(165), _controllerDuration, (String val){  /// "min",
              currentProduct.duration = Duration(minutes: int.parse(val));
              _redraw();
            })
          ],
        )
    );
    list.add(SizedBox(height: 10,));
    list.add(Column(
      children: [
        Text(strings.get(167), style: theme.style14W800,), /// "Categories",
        SizedBox(height: 5,),
        TreeInCategory(
          stringCategoryTree: strings.get(263), /// "Category tree",
          select: (CategoryData item) {
            if (currentProduct.category.contains(item.id))
              currentProduct.category.remove(item.id);
            else
              currentProduct.category.add(item.id);
            _redraw();
          },
          showDelete: false,
          showCheckBoxes: true,
          permittedList: currentProvider.category,
          stringOnlySelected: strings.get(166), /// "Only selected",
          getSelectList: (){
            return currentProduct.category;
          },
        )
      ],
    ));
    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // save
    //
    list.add(SizedBox(height: 20,));
    list.add(Row(
      children: [
        Expanded(child: button2(strings.get(169), theme.mainColor, () async {  /// "Save current service",
          currentProduct.providers = [];
          currentProduct.providers.add(currentProvider.id);
          var ret = _checkData();
          if (ret != null)
            return messageError(context, ret);
          ret = await saveProduct(currentProvider);
          if (ret == null)
            messageOk(context, strings.get(116)); /// "Data saved",
          else
            messageError(context, ret);
        })),
      ],
    ));

    list.add(SizedBox(height: 200,));

    return list;
  }

  String? _checkData(){
    if (getMinAmountInProduct(currentProduct.price) <= 0)
      return strings.get(264); /// "Price can't be 0",
    if (currentProduct.name.isEmpty)
      return strings.get(115); /// "Please Enter Name",
    if (currentProduct.price.isEmpty)
      return strings.get(170); /// "Please enter price",
    if (currentProduct.providers.isEmpty)
      return strings.get(171); /// Please select provider
    if (currentProduct.category.isEmpty)
      return strings.get(172); /// "Please enter category",
    return null;
  }

  _price(int level, Color _color){
    if (level > 9)
      return Container();
    return Container(
        color: _color,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            numberElement2Price(strings.get(153), /// Price
                "123", appSettings.symbol, _controllerPrice[level], (String val){
                  productSetPrice(val, level);
                  if (_currentPriceLevel == level) _currentPriceLevel++;
                  _redraw();
                }, appSettings.digitsAfterComma),
            SizedBox(height: 10,),
            numberElement2Price(strings.get(154), /// Discount price
                "123", appSettings.symbol, _controllerDiscPrice[level], (String val){
                  productSetDiscPrice(val, level);
                  if (_currentPriceLevel == level) _currentPriceLevel++;
                  _redraw();
                }, appSettings.digitsAfterComma),
            SizedBox(height: 5,),
            Row(children: [
              Expanded(child: Combo(inRow: true, text: strings.get(155), /// Price Unit
                data: _mainModel.service.priceUnitCombo,
                value: productGetPriceUnitCombo(level),
                onChange: (String value){
                  productSetPriceUnitCombo(value, level);
                  _redraw();
                },)),
            ],),

            SizedBox(height: 5,),
            Text(strings.get(16), style: theme.style14W400,), /// "Name",
            SizedBox(height: 5,),
            textElement2("", "", _controllerNamePrice[level], (String val){
              productSetNamePrice(val, level, _mainModel.customerAppLangsComboValue);
              if (_currentPriceLevel == level) _currentPriceLevel++;
              _redraw();
            }),
            SizedBox(height: 10,),
            button2(strings.get(158), theme.mainColor, (){_selectImageForPrice(level);}), /// "Select image",
          ],
        )
    );


  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    _redraw();
  }

  _selectImageForPrice(int level) async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null){
      _waits(true);
      var ret = await productSetPriceImageData(await pickedFile.readAsBytes(), level);
      if (ret != null)
        messageError(context, ret);
      _waits(false);
    }
  }

  _listAddons(){
    List<Widget> list = [];
    for (var item in currentProduct.addon)
      list.add(Container(
          width: windowWidth*0.2,
          child: Column(
            children: [
              button2twoLine(getTextByLocale(item.name, _mainModel.customerAppLangsComboValue),
                  "\$${item.price.toStringAsFixed(0)}", true,
                      (){}),
            ],
          )));

    return Wrap(
        runSpacing: 10,
        spacing: 10,
        children: list
    );
  }

  _selectImageToGallery() async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null){
      _waits(true);
      var ret = await addImageToGallery(await pickedFile.readAsBytes());
      if (ret != null)
        messageError(context, ret);
      _waits(false);
    }
  }

  AddonData? _itemToDelete;

  Widget _getDialogBody(){
    return Column(
          children: [
            Text(strings.get(176)), /// "Addon will be deleted from all services in current Provider. Do you want to delete this item? You will can't recover this item. "
            SizedBox(height: 40,),
            Row(
              children: [
                Expanded(child: button2(strings.get(146), /// "No",
                    theme.mainColor,
                        (){
                      _show = 0;
                      _redraw();
                    })),
                SizedBox(width: 10,),
                Expanded(child: button2(strings.get(86), /// "Delete",
                    Colors.red, () async {
                      _show = 0;
                      _redraw();
                      var ret = await deleteAddon(_itemToDelete!.id);
                      if (ret != null)
                        return messageError(context, ret);
                      else
                        messageOk(context, strings.get(177)); /// "Data deleted",
                      _redraw();
                    })),
              ],
            )
          ],
        );
  }


}