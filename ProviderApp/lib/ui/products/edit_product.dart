import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondprovider/model/model.dart';
import 'package:ondprovider/ui/products/variants_in_group.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/ui/theme.dart';
import 'package:provider/provider.dart';

import '../dialog_delete.dart';
import 'add_image_url.dart';
import 'group_variants.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  bool _expandDescription = false;
  bool _expandVariants = false;

  final _controllerName = TextEditingController();
  final _controllerDescTitle = TextEditingController();
  final _controllerDesc = TextEditingController();
  final _controllerTax = TextEditingController();
  final _controllerTaxAdmin = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerDiscPrice = TextEditingController();
  final _controllerUnit = TextEditingController();
  final _controllerStock = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    // _mainModel.initEditorInProductScreen = _init;
    _init();
    super.initState();
  }

  _init(){
    if (currentArticle.id.isEmpty){
      _controllerTaxAdmin.text = appSettings.defaultAdminComission.toString();
      _controllerName.text = "";
      _controllerDescTitle.text = "";
      _controllerDesc.text = "";
      _controllerTax.text = "";
      _controllerPrice.text = "";
      _controllerDiscPrice.text = "";
      _controllerUnit.text = strings.get(447); /// pcs
      _controllerStock.text = "";
    }else{
      _controllerName.text = getTextByLocale(currentArticle.name, _mainModel.customerAppLangsComboValue);
      _controllerDescTitle.text = getTextByLocale(currentArticle.descTitle, _mainModel.customerAppLangsComboValue);
      _controllerDesc.text = getTextByLocale(currentArticle.desc, _mainModel.customerAppLangsComboValue);
      _controllerTax.text = currentArticle.tax.toString();
      _controllerTaxAdmin.text = currentArticle.taxAdmin.toString();
      _controllerPrice.text = currentArticle.priceProduct.toString();
      _controllerDiscPrice.text = currentArticle.discPriceProduct.toString();
      _controllerUnit.text = currentArticle.unit.toString();
      _controllerStock.text = currentArticle.stock.toString();
    }
  }

  String? dataIntegrityCheck(){
    if (currentArticle.name.isEmpty)
      return strings.get(115); /// "Please Enter Name",
    if (currentArticle.priceProduct == 0)
      return strings.get(170); /// "Please enter price",
    if (currentArticle.gallery.isEmpty)
      return strings.get(260); /// "Please upload image",
    return null;
  }

  @override
  void dispose() {
    _controllerPrice.dispose();
    _controllerDiscPrice.dispose();
    _controllerDescTitle.dispose();
    _controllerName.dispose();
    _controllerDesc.dispose();
    _controllerTax.dispose();
    _controllerTaxAdmin.dispose();
    _controllerStock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          // if (_openDialogVariants){
          //   _openDialogVariants = false;
          //   _redraw();
          //   return false;
          // }
          return true;
    },
        child: Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: [

          _body(),

          appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
              "", context, () {Navigator.pop(context);}),

          if (_wait)
            Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

    ]),
    )));
  }


  Widget _body() {

    List<Widget> list = [];
    //
    // visible and language
    //
    list.add(SizedBox(height: 10,));
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
    list.add(checkBox1a(context, strings.get(149), /// "Visible",
        theme.mainColor, theme.style14W400, currentArticle.visible,
            (val) {
          if (val == null) return;
          currentArticle.visible = val;
          _redraw();
        }));
    //
    list.add(SizedBox(height: 10,));
    //
    // name
    //
    list.add(Row(
      children: [
        Expanded(child: textElement2(strings.get(16), "", _controllerName, (String val){         /// "Name",
          articleSetName(val, _mainModel.customerAppLangsComboValue);
        })),
      ],
    )
    );
    list.add(SizedBox(height: 10,));
    //

    list.add(numberElement2Percentage(strings.get(151), "", _controllerTax, (String val){         /// "Tax",
      currentArticle.tax = toDouble(val);
    }));
    // list.add(SizedBox(height: 10,));
    // list.add(numberElement2Percentage(strings.get(266), "", _controllerTaxAdmin, (String val){         /// "Tax for administration",
    //   currentArticle.taxAdmin = toDouble(val);
    // }));

    //
    // price
    //
    list.add(_price());

    //
    // Provider
    //
    // list.add(SizedBox(height: 10,));
    // list.add(Column(
    //   children: [
    //     Text(strings.get(178), style: theme.style14W800,), /// "Provider",
    //     SizedBox(height: 5,),
    //     Combo(inRow: true, text: "",
    //       data: _mainModel.provider.providersComboForProducts,
    //       value: _mainModel.provider.providersComboValueForProduct,
    //       onChange: (String value){
    //         currentArticle.providers = [];
    //         currentArticle.providers.add(value);
    //         _mainModel.provider.providersComboValueForProduct = value;
    //         _redraw();
    //       },)
    //   ],
    // ));

    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // Gallery
    //
    // list.add(Container(key: widget.keyM));
    list.add(Text(strings.get(161), style: theme.style16W800));                 /// Gallery
    list.add(SizedBox(height: 10,));
    if (currentArticle.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: currentArticle.gallery.map((e){
            return displayImageWithCloseButton(100, 100, e.serverPath, (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryScreen(item: e, gallery: currentArticle.gallery,
                      tag: "", textDirection: strings.direction,),
                  )
              );
            },() async {
              var ret = await articleDeleteImageFromGallery(e);
              if (ret == null)
                messageOk(context, strings.get(162)); /// "Image deleted",
              else
                messageError(context, ret);
              if (currentArticle.id.isNotEmpty){
                ret = await articleSave();
                if (ret == null)
                  messageOk(context, strings.get(116)); /// "Data saved",
                else
                  messageError(context, ret);
              }
              _redraw();
            }
            );
          }).toList(),
        ),
      ));
    //
    list.add(SizedBox(height: 10,));
    list.add(button2b(strings.get(163), (){        /// "Add image from gallery",
      _selectImageToGallery(ImageSource.gallery);
    }),);
    list.add(SizedBox(height: 10,));
    list.add(button2b(strings.get(258), (){        /// "Add image from camera",
      _selectImageToGallery(ImageSource.camera);
    }),);
    list.add(SizedBox(height: 10,));
    list.add(button2b(strings.get(230), (){        /// "Add image URL",
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DialogAddImageUrl(),
        ),
      );
      //showDialogAddVImageUrl();
    }),);

    // list.add(SizedBox(height: 10,));
    // list.add(Row(
    //   mainAxisSize: MainAxisSize.min,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     button2b(strings.get(163), (){        /// "Add image from gallery",
    //       _selectImageToGallery(ImageSource.gallery);
    //     }),
    //     SizedBox(width: 10,),
    //     button2b(strings.get(230), (){        /// "Add image URL",
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => DialogAddImageUrl(),
    //         ),
    //       );
    //       //showDialogAddVImageUrl();
    //     }),
    //   ],
    // ));
    // list.add(SizedBox(height: 10,));
    // list.add(Row(
    //   mainAxisSize: MainAxisSize.min,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     button2b(strings.get(258), (){        /// "Add image from camera",
    //       _selectImageToGallery(ImageSource.camera);
    //     }),
    //   ],
    // ));
    //
    list.add(SizedBox(height: 10,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //

    list.add(SizedBox(height: 20,));
    list.add(buttonExpand(strings.get(65), _expandDescription, (){ /// "Description",
      if (_expandDescription)
        _init();
      _expandDescription = !_expandDescription;
      _redraw();
    }, ));

    if (_expandDescription){
      //
      // description title
      //
      list.add(SizedBox(height: 10,));
      list.add(textElement2(strings.get(152), "", _controllerDescTitle, (String val){           /// Description Title
        articleSetDescTitle(val, _mainModel.customerAppLangsComboValue);
      }));
      list.add(SizedBox(height: 10,));
      //
      // description
      //
      list.add(documentBlock(strings.get(231) + ":" + strings.get(232), _controllerDesc,  /// "Description:",  "You can use HTML tags (<p>, <br>, <h1> and other)"
          "", (){
            articleSetDesc(_controllerDesc.text, _mainModel.customerAppLangsComboValue);
            setState(() {});}, strings.get(245)) /// "Preview",
      );
      list.add(SizedBox(height: 10,));
    }

    //
    // VARIANTS
    //
    list.add(SizedBox(height: 20,));
    list.add(buttonExpand(strings.get(233), _expandVariants, (){ /// "Variants",
      _expandVariants = !_expandVariants;
      _redraw();
    }, ));

    if (_expandVariants){
      list.add(SizedBox(height: 20,));
      list.add(button2b(strings.get(234), (){        /// "Add new group",
        variantGroupEdit = null;
        // showDialogVariantsGroup();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DialogVariantsGroup(),
          ),
        );
      }));
      list.add(SizedBox(height: 20,));

      bool _bkgColor = true;
      //
      // group
      //
      _clearPrice();
      list.add(_priceSumma());

      for (var item in currentArticle.group){
        // variants
        var _nameVariant = "";
        List<Widget> _variants = [];
        _selectedVariant = false;
        for (var item2 in item.price){
          if (item2.selected) {
            _nameVariant = getTextByLocale(item2.name, _mainModel.customerAppLangsComboValue);
            _selectedVariant = true;
            if (item2.priceUnit == "-")
              _plusMinus = -item2.price;
            else
              _plusMinus = item2.price;
          }
          _variants.add(Column(
            children: [
              Text(item2.priceUnit+getPriceString(item2.price), style: theme.style12W400,),
              SizedBox(height: 5,),
              Text("${item2.stock} ${currentArticle.unit}", style: theme.style12W400,),
              SizedBox(height: 5,),
              variantButton(_redraw, _mainModel.customerAppLangsComboValue, item, item2),
              SizedBox(height: 5,),
              button2small(strings.get(133), /// "Edit",
                      (){
                    variantEdit = item2;
                    groupToEdit = item.id;
                    // showDialogVariants();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DialogVariants(),
                      ),
                    );
                  }),
              SizedBox(height: 5,),
              button2small(strings.get(86), /// "Delete",
                      (){
                    item.price.remove(item2);
                    _redraw();
                  }, color: Colors.red),
            ],
          ));
        }

        list.add(Container(
            padding: EdgeInsets.all(10),
            color: _bkgColor ? Colors.blue.withAlpha(30) : Colors.yellow.withAlpha(30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(getTextByLocale(item.name, _mainModel.customerAppLangsComboValue), style: theme.style14W800,),
                    SizedBox(width: 2,),
                    Text(": $_nameVariant", style: theme.style13W400,),
                    SizedBox(width: 30,),
                    button2small(strings.get(133), (){ /// "Edit",
                      variantGroupEdit = item;
                      //showDialogVariantsGroup();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DialogVariantsGroup(),
                        ),
                      );
                    }, color: Colors.green.withAlpha(100)),
                    Expanded(child: SizedBox(width: 10,)),
                    button2small(strings.get(86), (){ /// "Delete",
                      openDialogDelete(() {
                        Navigator.pop(context); // close dialog
                        currentArticle.group.remove(item);
                        _redraw();
                      }, context);
                    }, color: Colors.red.withAlpha(100)),
                  ],
                ),
                //
                // variants
                //
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 10,
                  children: _variants,
                ),

                SizedBox(height: 20,),
                button2b(strings.get(235), (){        /// "Add new variant",
                  groupToEdit = item.id;
                  variantEdit = null;
                  // showDialogVariants();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DialogVariants(),
                    ),
                  );
                }),
                SizedBox(height: 20,),
                _priceSumma(),
              ],
            ))
        );
        _bkgColor = !_bkgColor;
      }

      list.add(SizedBox(height: 20,));
    }

    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // save
    //
    list.add(SizedBox(height: 20,));
    if (currentArticle.id.isEmpty)
      list.add(button2b(strings.get(228), () async {        /// "Create new product",
        var ret = dataIntegrityCheck();
        if (ret != null)
          return messageError(context, ret);
        currentArticle.providers.add(currentProvider.id);
        //var _provider = currentArticle.providers.isNotEmpty ? getProviderById(currentArticle.providers[0]) : null;
        ret = await createArticle(currentProvider);
        if (ret == null)
          messageOk(context, strings.get(116)); /// "Data saved",
        else
          messageError(context, ret);
        _redraw();
      }));
    else
      list.add(Row(
        children: [
          Expanded(child: button2b(strings.get(236), () async {  /// "Save current product",
            var ret = dataIntegrityCheck();
            if (ret != null)
              return messageError(context, ret);
            ret = await articleSave();
            if (ret == null)
              messageOk(context, strings.get(116)); /// "Data saved",
            else
              messageError(context, ret);
            redrawMainWindow();
          })),
          SizedBox(width: 10,),
          button2b(strings.get(237), () async { /// "Add New Product",
            var ret = await articleEmptyCurrent();
            if (ret != null)
              return messageError(context, ret);
            redrawMainWindow();
            _init();
          })
        ],
      ));
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        children: list,
      ),
    );
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _selectImageToGallery(ImageSource source) async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: source);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null){
      _waits(true);
      var ret = await articleAddImageToGallery(await pickedFile.readAsBytes());
      if (ret != null)
        messageError(context, ret);
      _waits(false);
    }
  }

  _price(){
    Widget _price = numberElement2Price(strings.get(153), /// Price
        "123", appSettings.symbol, _controllerPrice, (String val){
          currentArticle.priceProduct = toDouble(val);
          _redraw();
        }, appSettings.digitsAfterComma);
    Widget _discPrice = numberElement2Price(strings.get(154), /// Discount price
        "123", appSettings.symbol, _controllerDiscPrice, (String val){
          currentArticle.discPriceProduct = toDouble(val);
          _redraw();
        }, appSettings.digitsAfterComma);
    Widget _unit = textElement2(strings.get(238), /// Unit
        strings.get(240), _controllerUnit, (String val){ /// pcs
          currentArticle.unit = val;
        });
    Widget _stock = numberElement2(strings.get(239), /// In Stock
        "9999", strings.get(240), _controllerStock, (String val){ /// pcs
          currentArticle.stock = toInt(val);
        });
    if (currentArticle.group.isNotEmpty)
      _stock = Container();


      return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _price,
              SizedBox(height: 10,),
              _discPrice,
              SizedBox(height: 10,),
              _unit,
              SizedBox(height: 10,),
              _stock
            ],
          )
      );
  }

  _clearPrice(){
    _plusMinus = 0;
    _allPlusMinus = 0;
    _selectedVariant = true;
    _priceVariants = "";
    _oneNotSelected = false;
    _first = true;
  }

  double _allPlusMinus = 0;
  double _plusMinus = 0;
  bool _selectedVariant = true;
  String _priceVariants = "";
  bool _oneNotSelected = false;
  bool _first = true;

  Widget _priceSumma(){
    if (!_selectedVariant || _oneNotSelected){
      _oneNotSelected = true;
      return Row(
        children: [
          Expanded(child: Text(strings.get(241), style: theme.style14W400,)), /// "Please select variant"
        ],
      );
    }
    if (currentArticle.discPriceProduct != 0) {
      if (_selectedVariant && !_first)
        _priceVariants += " + (${getPriceString(_plusMinus)}) = ${getPriceString(currentArticle.discPriceProduct+_plusMinus+_allPlusMinus)} ";
      _allPlusMinus = _plusMinus;
      _first = false;
      return Row(
        children: [
          Text(getPriceString(currentArticle.priceProduct), style: theme.style14W400U,),
          SizedBox(width: 10,),
          Text(getPriceString(currentArticle.discPriceProduct), style: theme.style14W400,),
          // if (_plusMinus != 0)
          Text(_priceVariants, style: theme.style14W400,),
        ],
      );
    }else {
      if (_selectedVariant && !_first)
        _priceVariants += " + (${getPriceString(_plusMinus)}) = ${getPriceString(currentArticle.priceProduct+_plusMinus+_allPlusMinus)} ";
      _allPlusMinus = _plusMinus;
      _first = false;
      return Text(getPriceString(currentArticle.priceProduct + _plusMinus), style: theme.style12W400,);
    }
  }

}