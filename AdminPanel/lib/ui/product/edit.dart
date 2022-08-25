import 'package:abg_utils/abg_utils.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/dialogs/dialogs.dart';
import 'package:provider/provider.dart';
import '../../utils.dart';
import '../strings.dart';
import '../theme.dart';

class EditInProduct extends StatefulWidget {
  final GlobalKey keyM;
  EditInProduct({required this.keyM});
  @override
  _EditInProductState createState() => _EditInProductState();
}

class _EditInProductState extends State<EditInProduct> {

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
    _mainModel.initEditorInProductScreen = _init;
    super.initState();
  }

  _init(){
    _mainModel.provider.providersComboValueForProduct = "root";
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
      _controllerName.text = getTextByLocale(currentArticle.name, _mainModel.langEditDataComboValue);
      _controllerDescTitle.text = getTextByLocale(currentArticle.descTitle, _mainModel.langEditDataComboValue);
      _controllerDesc.text = getTextByLocale(currentArticle.desc, _mainModel.langEditDataComboValue);
      _controllerTax.text = currentArticle.tax.toString();
      _controllerTaxAdmin.text = currentArticle.taxAdmin.toString();
      _controllerPrice.text = currentArticle.priceProduct.toString();
      _controllerDiscPrice.text = currentArticle.discPriceProduct.toString();
      _controllerUnit.text = currentArticle.unit.toString();
      _controllerStock.text = currentArticle.stock.toString();
      //
      if (currentArticle.providers.isNotEmpty){
        for (var item in _mainModel.provider.providersComboForProducts)
          if (item.id == currentArticle.providers[0])
            _mainModel.provider.providersComboValueForProduct = currentArticle.providers[0];
      }

    }
  }

  String? dataIntegrityCheck(){
    if (currentArticle.priceProduct == 0)
      return strings.get(472); /// "Price can't be 0",
    if (currentArticle.name.isEmpty)
      return strings.get(91); /// "Please Enter Name",
    if (currentArticle.priceProduct == 0)
      return strings.get(342); /// "Please enter price",
    if (currentArticle.gallery.isEmpty)
      return strings.get(428); /// "Please upload image",
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
    List<Widget> list = [];
    //
    // visible and language
    //
    Widget _visible = checkBox1a(context, strings.get(70), /// "Visible",
        theme.mainColor, theme.style14W400, currentArticle.visible,
            (val) {
          if (val == null) return;
          currentArticle.visible = val;
          _redraw();
        });
    Widget _selectLanguage = Expanded(child: Container(
        width: 120,
        child: Combo(inRow: true, text: "",
          data: _mainModel.langDataCombo,
          value: _mainModel.langEditDataComboValue,
          onChange: (String value){
            _mainModel.langEditDataComboValue = value;
            WidgetsBinding.instance!.addPostFrameCallback((_) async {
              _init();
            });
            _redraw();
          },)));

    if (isMobile()){
      list.add(_visible);
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          Text(strings.get(108), style: theme.style14W400,), /// "Select language",
          _selectLanguage,
        ],
      ));
    }else
      list.add(Row(
        children: [
          Expanded(child: _visible),
          Expanded(child: SizedBox(width: 10,)),
          Text(strings.get(108), style: theme.style14W400,), /// "Select language",
          _selectLanguage
          ],
      ));
    //
    list.add(SizedBox(height: 10,));
    //
    // name
    //
    list.add(textElement2(strings.get(54), "", _controllerName, (String val){         /// "Name",
          articleSetName(val, _mainModel.langEditDataComboValue);
        })
    );
    list.add(SizedBox(height: 10,));
    //
    if (isMobile()){
      list.add(numberElement2Percentage(strings.get(130), "", _controllerTax, (String val){         /// "Tax",
        currentArticle.tax = toDouble(val);
      }));
      list.add(SizedBox(height: 10,));
      list.add(numberElement2Percentage(strings.get(266), "", _controllerTaxAdmin, (String val){         /// "Tax for administration",
        currentArticle.taxAdmin = toDouble(val);
      }));
    }else
    list.add(Row(
      children: [
        Expanded(child: numberElement2Percentage(strings.get(130), "", _controllerTax, (String val){         /// "Tax",
          currentArticle.tax = toDouble(val);
        })),
        SizedBox(width: 10,),
        Expanded(child: numberElement2Percentage(strings.get(266), "", _controllerTaxAdmin, (String val){         /// "Tax for administration",
          currentArticle.taxAdmin = toDouble(val);
        })),
      ],
    )
    );

    //
    // price
    //
    list.add(_price());

    //
    // Provider
    //
    list.add(SizedBox(height: 10,));
    list.add(Column(
      children: [
        Text(strings.get(178), style: theme.style14W800,), /// "Provider",
        SizedBox(height: 5,),
        Combo(inRow: true, text: "",
          data: _mainModel.provider.providersComboForProducts,
          value: _mainModel.provider.providersComboValueForProduct,
          onChange: (String value){
            currentArticle.providers = [];
            if (value != "root")
              currentArticle.providers.add(value);
            _mainModel.provider.providersComboValueForProduct = value;
            _redraw();
          },)
      ],
    ));

    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // Gallery
    //
    list.add(Container(key: widget.keyM));
    list.add(Text(strings.get(128), style: theme.style16W800));                 /// Gallery
    list.add(SizedBox(height: 10,));
    if (currentArticle.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: currentArticle.gallery.map((e){
            return displayImageWithCloseButton(100, 100, e.serverPath, (){
              openGalleryScreen(currentArticle.gallery, e);
            },() async {
              var ret = await articleDeleteImageFromGallery(e);
              if (ret == null)
                messageOk(context, strings.get(219)); /// "Image deleted",
              else
                messageError(context, ret);
              if (currentArticle.id.isNotEmpty){
                ret = await articleSave();
                if (ret == null)
                  messageOk(context, strings.get(81)); /// "Data saved",
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
    list.add(Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        button2b(strings.get(129), (){        /// "Add image to gallery",
          _selectImageToGallery();
        }),
        SizedBox(width: 10,),
        button2b(strings.get(430), (){        /// "Add image URL",
          _mainModel.addImageType = "article_gallery";
          showDialogAddVImageUrl();
        }),
      ],
    ));
    //
    list.add(SizedBox(height: 10,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //

    list.add(SizedBox(height: 20,));
    list.add(buttonExpand(strings.get(73), _expandDescription, (){ /// "Description",
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
      list.add(textElement2(strings.get(120), "", _controllerDescTitle, (String val){           /// Description Title
        articleSetDescTitle(val, _mainModel.langEditDataComboValue);
      }));
      list.add(SizedBox(height: 10,));
      //
      // description
      //
      list.add(documentBlock(strings.get(73) + ":" + strings.get(200), _controllerDesc,  /// "Description:",  "You can use HTML tags (<p>, <br>, <h1> and other)"
          "", (){
            articleSetDesc(_controllerDesc.text, _mainModel.langEditDataComboValue);
            setState(() {});}, strings.get(25))
      );
      list.add(SizedBox(height: 10,));
    }

    //
    // VARIANTS
    //
    list.add(SizedBox(height: 20,));
    list.add(buttonExpand(strings.get(433), _expandVariants, (){ /// "Variants",
      _expandVariants = !_expandVariants;
      _redraw();
    }, ));

    if (_expandVariants){
      list.add(SizedBox(height: 20,));
      list.add(button2b(strings.get(434), (){        /// "Add new group",
        variantGroupEdit = null;
        showDialogVariantsGroup();
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
            _nameVariant = getTextByLocale(item2.name, _mainModel.langEditDataComboValue);
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
              variantButton(_redraw, _mainModel.langEditDataComboValue, item, item2),
              SizedBox(height: 5,),
              button2small(strings.get(68), /// "Edit",
                  (){
                    variantEdit = item2;
                    groupToEdit = item.id;
                    showDialogVariants();
                  }),
              SizedBox(height: 5,),
              button2small(strings.get(62), /// "Delete",
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
                Text(getTextByLocale(item.name, _mainModel.langEditDataComboValue), style: theme.style14W800,),
                SizedBox(width: 2,),
                Text(": $_nameVariant", style: theme.style13W400,),
                SizedBox(width: 30,),
                button2small(strings.get(68), (){ /// "Edit",
                  variantGroupEdit = item;
                  showDialogVariantsGroup();
                }, color: Colors.green.withAlpha(100)),
                Expanded(child: SizedBox(width: 10,)),
                button2small(strings.get(62), (){ /// "Delete",
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
            button2b(strings.get(437), (){        /// "Add new variant",
              groupToEdit = item.id;
              variantEdit = null;
              showDialogVariants();
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

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // save
    //
    list.add(SizedBox(height: 20,));
    if (currentArticle.id.isEmpty)
      list.add(button2b(strings.get(425), () async {        /// "Create new product",
        var ret = dataIntegrityCheck();
        if (ret != null)
          return messageError(context, ret);
        var _provider = currentArticle.providers.isNotEmpty ? getProviderById(currentArticle.providers[0]) : null;
        ret = await createArticle(_provider);
        if (ret == null)
          messageOk(context, strings.get(81)); /// "Data saved",
        else
          messageError(context, ret);
        _redraw();
      }));
    else
      list.add(Row(
        children: [
          Expanded(child: button2b(strings.get(427), () async {  /// "Save current product",
            var ret = dataIntegrityCheck();
            if (ret != null)
              return messageError(context, ret);
            ret = await articleSave();
            if (ret == null)
              messageOk(context, strings.get(81)); /// "Data saved",
            else
              messageError(context, ret);
            redrawMainWindow();
          })),
          button2b(strings.get(426), () async { /// "Add New Product",
            var ret = await articleEmptyCurrent();
            if (ret != null)
              return messageError(context, ret);
            redrawMainWindow();
            _init();
          })
        ],
      ));
    return Stack(
      children: [
        Container(
            width: _mainModel.getEditWorkspaceWidth(),
            decoration: BoxDecoration(
              color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: Stack(
            children: [
              Positioned.fill(child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(theme.radius),
                  ),
                  duration: Duration(seconds: 1))),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: list,
              )),

              if (_wait)
                Positioned.fill(
                  child: Center(child: Container(child: Loader7(color: theme.mainColor,))),
                ),

            ],
            )
        ),
      ],
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

  _selectImageToGallery() async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
    Widget _price = numberElement2Price(strings.get(144), /// Price
        "123", appSettings.symbol, _controllerPrice, (String val){
          currentArticle.priceProduct = toDouble(val);
          _redraw();
        }, appSettings.digitsAfterComma);
    Widget _discPrice = numberElement2Price(strings.get(145), /// Discount price
        "123", appSettings.symbol, _controllerDiscPrice, (String val){
          currentArticle.discPriceProduct = toDouble(val);
          _redraw();
        }, appSettings.digitsAfterComma);
    Widget _unit = textElement2(strings.get(452), /// Unit
        strings.get(447), _controllerUnit, (String val){ /// pcs
          currentArticle.unit = val;
        });
    Widget _stock = numberElement2(strings.get(446), /// In Stock
        "9999", strings.get(447), _controllerStock, (String val){ /// pcs
          currentArticle.stock = toInt(val);
        });
    if (currentArticle.group.isNotEmpty)
      _stock = Container();

    if (isMobile())
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

    return Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: _price),
                SizedBox(width: 20,),
                Expanded(child: _discPrice),
              ],),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: _unit),
                SizedBox(width: 20,),
                Expanded(child: _stock)
              ],),
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
          Expanded(child: Text(strings.get(449), style: theme.style14W400,)), /// "Please select variant"
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




