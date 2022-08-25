import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/dialogs/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/widgets/buttons/button2.dart';
import '../strings.dart';
import '../theme.dart';

class EditInServices extends StatefulWidget {
  final GlobalKey keyM;
  const EditInServices({Key? key, required this.keyM}) : super(key: key);
  @override
  _EditInServicesState createState() => _EditInServicesState();
}

class _EditInServicesState extends State<EditInServices> {

  double windowWidth = 0;
  double windowHeight = 0;
  int _currentPriceLevel = 0;

  final _controllerName = TextEditingController();
  final _controllerDescTitle = TextEditingController();
  final _controllerDesc = TextEditingController();
  final _controllerTax = TextEditingController();
  final _controllerTaxAdmin = TextEditingController();
  final _controllerDuration = TextEditingController();
  //
  final List<TextEditingController> _controllerPrice = [];
  final List<TextEditingController> _controllerDiscPrice = [];
  final List<TextEditingController> _controllerNamePrice = [];
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    for (var i = 0; i < 10; i++){
      _controllerPrice.add(TextEditingController());
      _controllerDiscPrice.add(TextEditingController());
      _controllerNamePrice.add(TextEditingController());
    }
    _mainModel.initEditorInServiceScreen = _init;
    super.initState();
  }

  @override
  void dispose() {
    for (var i = 0; i < 10; i++){
      _controllerPrice[i].dispose();
      _controllerDiscPrice[i].dispose();
      _controllerNamePrice[i].dispose();
    }
    _controllerDescTitle.dispose();
    _controllerName.dispose();
    _controllerDesc.dispose();
    _controllerTax.dispose();
    _controllerTaxAdmin.dispose();
    _controllerDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    List<Widget> list = [];
    //
    // visible and language
    //
    Widget visibleWidget = checkBox1a(context, strings.get(70), /// "Visible",
        theme.mainColor, theme.style14W400, currentProduct.visible,
            (val) {
          if (val == null) return;
          currentProduct.visible = val;
          redrawMainWindow();
        });
    List<Widget> langWidget = [
        Text(strings.get(108), style: theme.style14W400,), /// "Select language",
        Expanded(child: Container(
            width: 120,
            child: Combo(inRow: true, text: "",
              data: _mainModel.langDataCombo,
              value: _mainModel.langEditDataComboValue,
              onChange: (String value){
                _mainModel.langEditDataComboValue = value;
                redrawMainWindow();
              },))),
      ];
    if (isMobile()){
      list.add(visibleWidget);
      list.add(SizedBox(height: 10,));
      list.add(Row(children: langWidget,));
    }else
      list.add(Row(
        children: [
          Expanded(child: visibleWidget),
          Expanded(child: SizedBox(width: 10,)),
          ...langWidget
          ],
      ));
    //
    list.add(SizedBox(height: 10,));
    //
    // name
    //
    list.add(Container(key: widget.keyM));
    list.add(Row(
      children: [
        Expanded(child: textElement2(strings.get(54), "", _controllerName, (String val){         /// "Name",
          productSetName(val, _mainModel.langEditDataComboValue);
          redrawMainWindow();
        })),
      ],
    )
    );
    list.add(SizedBox(height: 10,));
    Widget taxWidget = numberElement2Percentage(strings.get(130), "", _controllerTax, (String val){         /// "Tax",
      currentProduct.tax = toDouble(val);
      redrawMainWindow();
    });
    Widget taxAdminWidget = numberElement2Percentage(strings.get(266), "", _controllerTaxAdmin, (String val){         /// "Tax for administration",
      currentProduct.taxAdmin = toDouble(val);
      redrawMainWindow();
    });
    //
    if (isMobile()){
      list.add(taxWidget);
      list.add(SizedBox(height: 10,));
      list.add(taxAdminWidget);
    }else
    list.add(Row(
      children: [
        taxWidget,
        SizedBox(width: 10,),
        Expanded(child: taxAdminWidget),
      ],
    )
    );
    list.add(SizedBox(height: 10,));
    //
    // description title
    //
    list.add(textElement2(strings.get(120), "", _controllerDescTitle, (String val){           /// Description Title
      productSetDescTitle(val, _mainModel.langEditDataComboValue);
      redrawMainWindow();
    }));
    list.add(SizedBox(height: 10,));
    //
    // description
    //
    list.add(textElement2(strings.get(73), "", _controllerDesc, (String val){           /// Description
      productSetDesc(val, _mainModel.langEditDataComboValue);
      redrawMainWindow();
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

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        Expanded(child: Text(strings.get(347), style: theme.style14W400,), ), /// "Addons",
        SizedBox(width: 10,),
        button2b(strings.get(348), (){  /// "Add addon",
          showDialogAddVariants();
        })
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
    list.add(Text(strings.get(128), style: theme.style16W800));                 /// Gallery
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => GalleryScreen(item: e, gallery: images, tag: _tag),
                  //     )
                  // );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: Hero(
                    tag: _tag,
                    child: Stack(
                          children: [
                            Container(
                              child: Image.network(e.serverPath, fit: BoxFit.cover)
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.topRight,
                              child: IconButton(icon: Icon(Icons.cancel, color: Colors.red,),
                                onPressed: () async {
                                  if (appSettings.demo)
                                    return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
                                  var ret = await deleteImageFromGallery(e);
                                  if (ret == null)
                                    messageOk(context, strings.get(219)); /// "Image deleted",
                                  else
                                    messageError(context, ret);
                                  redrawMainWindow();
                                },),
                            )
                    ],
              )))
            );
          }).toList(),
        ),
      ));
    //
    list.add(SizedBox(height: 10,));
    list.add(button2b(strings.get(129), (){        /// "Add image to gallery",
      _selectImageToGallery();
      redrawMainWindow();
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
          Expanded(child: Text(strings.get(220) + ":", style: theme.style16W800, overflow: TextOverflow.ellipsis,)), /// "Service duration",
          SizedBox(height: 10,),
          numberElement2("", "10", strings.get(346), _controllerDuration, (String val){  /// "min",
            currentProduct.duration = Duration(minutes: int.parse(val));
            _mainModel.serviceApp.needRedraw();
            redrawMainWindow();
          })
        ],
      )
        // Theme(
        // data: Theme.of(context).copyWith(
        //     unselectedWidgetColor: Colors.grey,
        //     disabledColor: Colors.grey
        // ),
        // child: DurationPicker(
        //   duration: currentProduct.duration,
        //   onChange: (val) {
        //     // _noReceive = true;
        //     currentProduct.duration = val;
        //     _mainModel.serviceApp.needRedraw();
        //     setState(() {
        //     });
        //   },
        //   snapToMins: 5.0,
        // ))
    );
    list.add(SizedBox(height: 10,));
    list.add(Column(
          children: [
            Text(strings.get(56), style: theme.style14W800,), /// "Categories",
            SizedBox(height: 5,),
            TreeInCategory(
              showDelete: false,
              showCheckBoxes: true,
              stringOnlySelected: strings.get(168), /// "Only selected",
              getSelectList: (){
                return currentProduct.category;
              },
              select: (CategoryData item){
                if (currentProduct.category.contains(item.id))
                  currentProduct.category.remove(item.id);
                else
                  currentProduct.category.add(item.id);
                redrawMainWindow();
              },
              stringCategoryTree: strings.get(232), /// Category tree
            )
          ],
    ));
    list.add(SizedBox(height: 10,));
    list.add(Column(
      children: [
        Text(strings.get(96), style: theme.style14W800,), /// "Providers",
        SizedBox(height: 5,),
        Combo(inRow: true, text: "",
          data: _mainModel.provider.providersComboForService,
          value: _mainModel.provider.providersComboValueForService,
          onChange: (String value){
            currentProduct.providers = [];
            if (value != "1")
              currentProduct.providers.add(value);
            _mainModel.provider.providersComboValueForService = value;
            redrawMainWindow();
          },)
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
    if (currentProduct.id.isEmpty)
      list.add(button2b(strings.get(146), () async {        /// "Create new service",
        var ret = _checkData();
        if (ret != null)
          return messageError(context, ret);
        ret = await saveProduct(ProviderData.createEmpty(), admin: true);
        if (ret == null)
          messageOk(context, strings.get(81)); /// "Data saved",
        else
          messageError(context, ret);
      }));
    else
      list.add(Row(
        children: [
          Expanded(child: button2b(strings.get(147), () async {  /// "Save current service",
            var ret = _checkData();
            if (ret != null)
              return messageError(context, ret);

            ret = await saveProduct(ProviderData.createEmpty(), admin: true);
            if (ret == null)
              messageOk(context, strings.get(81)); /// "Data saved",
            else
              messageError(context, ret);
          })),
          button2b(strings.get(148), _mainModel.service.emptyCurrent)                /// "Add New Service",
        ],
      ));
    return Stack(
      children: [
        Container(
            width: _mainModel.getEditWorkspaceWidthWithEmulator(), //(windowWidth/2 < 600) ? 600 : windowWidth/2,
            decoration: BoxDecoration(
              color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: Stack(
            children: [
              Positioned.fill(child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: (_select) ? Colors.grey.withAlpha(100) : Colors.transparent,
                    borderRadius: BorderRadius.circular(theme.radius),
                  ),
                  duration: Duration(seconds: 1))),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
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

  String? _checkData(){
    if (getMinAmountInProduct(currentProduct.price) <= 0)
      return strings.get(472); /// "Price can't be 0",
    if (currentProduct.name.isEmpty)
      return strings.get(91); /// "Please Enter Name",
    if (currentProduct.price.isEmpty)
      return strings.get(342); /// "Please enter price",
    if (currentProduct.providers.isEmpty)
      return strings.get(221); /// Please select provider
    if (currentProduct.category.isEmpty)
      return strings.get(343); /// "Please enter category",
    return null;
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
      var ret = await addImageToGallery(await pickedFile.readAsBytes());
      if (ret != null)
        messageError(context, ret);
      _waits(false);
    }
  }

  bool _select = false;

  _price(int level, Color _color){
    if (level > 9)
      return Container();
    if (isMobile())
      return Container(
          color: _color,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              numberElement2Price(strings.get(144), /// Price
                  "123", appSettings.symbol, _controllerPrice[level], (String val){
                    productSetPrice(val, level);
                    if (_currentPriceLevel == level) _currentPriceLevel++;
                    redrawMainWindow();
                  }, appSettings.digitsAfterComma),
              SizedBox(height: 10,),
              numberElement2Price(strings.get(145), /// Discount price
                  "123", appSettings.symbol, _controllerDiscPrice[level], (String val){
                    productSetDiscPrice(val, level);
                    if (_currentPriceLevel == level) _currentPriceLevel++;
                    redrawMainWindow();
                  }, appSettings.digitsAfterComma),
              SizedBox(height: 5,),
              Row(children: [
                Expanded(child: Combo(inRow: true, text: strings.get(151), /// Price Unit
                  data: _mainModel.service.priceUnitCombo,
                  value: productGetPriceUnitCombo(level),
                  onChange: (String value){
                    productSetPriceUnitCombo(value, level);
                    redrawMainWindow();
                  },)),
              ],),

              SizedBox(height: 5,),

              textElement2(strings.get(54), "", _controllerNamePrice[level], (String val){         /// "Name",
                productSetNamePrice(val, level, _mainModel.langEditDataComboValue);
                if (_currentPriceLevel == level) _currentPriceLevel++;
                redrawMainWindow();
              }),
              SizedBox(height: 10,),
              button2small(strings.get(75), (){_selectImageForPrice(level);}), /// "Select image",
              SizedBox(height: 10,),
              button2b(strings.get(75), (){_selectImageForPrice(level);}), /// "Select image",
              if (level < currentProduct.price.length)
                button2c(strings.get(62), Colors.red, (){ /// "Delete",
                  if (level >= 0 && level < currentProduct.price.length) {
                    currentProduct.price.removeAt(level);
                    _currentPriceLevel--;
                    _priceInit();
                    redrawMainWindow();
                  }
                })
            ],
          )
      );

    return Container(
        color: _color,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            Row(
              children: [
                numberElement2Price(strings.get(144), /// Price
                    "123", appSettings.symbol, _controllerPrice[level], (String val){
                      productSetPrice(val, level);
                      if (_currentPriceLevel == level) _currentPriceLevel++;
                      redrawMainWindow();
                    }, appSettings.digitsAfterComma),
                SizedBox(width: 20,),
                numberElement2Price(strings.get(145), /// Discount price
                    "123", appSettings.symbol, _controllerDiscPrice[level], (String val){
                      productSetDiscPrice(val, level);
                      if (_currentPriceLevel == level) _currentPriceLevel++;
                      redrawMainWindow();
                    }, appSettings.digitsAfterComma),
                Expanded(child: Container()),
                if (level < currentProduct.price.length)
                  button2c(strings.get(62), Colors.red, (){ /// "Delete",
                    if (level >= 0 && level < currentProduct.price.length) {
                      currentProduct.price.removeAt(level);
                      _currentPriceLevel--;
                      _priceInit();
                      redrawMainWindow();
                    }
                  }),
              ],),
            SizedBox(height: 5,),
            Row(children: [
              Expanded(child: Combo(inRow: true, text: strings.get(151), /// Price Unit
                data: _mainModel.service.priceUnitCombo,
                value: productGetPriceUnitCombo(level),
                onChange: (String value){
                  productSetPriceUnitCombo(value, level);
                  redrawMainWindow();
                },)),
            ],),

            SizedBox(height: 5,),

            Row(
              children: [
                Expanded(child: textElement2(strings.get(54), "", _controllerNamePrice[level], (String val){         /// "Name",
                  productSetNamePrice(val, level, _mainModel.langEditDataComboValue);
                  if (_currentPriceLevel == level) _currentPriceLevel++;
                  redrawMainWindow();
                })),
                SizedBox(width: 10,),
                button2small(strings.get(75), (){_selectImageForPrice(level);}), /// "Select image",
              ],),

          ],
        )
    );
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
      redrawMainWindow();
    }
  }

  // _nowEdit(ProductData select){
  _init(){
    _select = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      _select = false;
      _redraw();
    });

    for (var i = 0; i < 10; i++){
      _controllerPrice[i].text = "";
      _controllerDiscPrice[i].text = "";
      _controllerNamePrice[i].text = "";
    }

    _priceInit();

    _controllerName.text = _mainModel.getTextByLocale(currentProduct.name);
    textFieldToEnd(_controllerName);
    _controllerDescTitle.text = _mainModel.getTextByLocale(currentProduct.descTitle);
    textFieldToEnd(_controllerDescTitle);
    _controllerDesc.text = _mainModel.getTextByLocale(currentProduct.desc);
    textFieldToEnd(_controllerDesc);
    _controllerTax.text = currentProduct.tax.toString();
    textFieldToEnd(_controllerTax);
    _controllerTaxAdmin.text = currentProduct.taxAdmin.toString();
    textFieldToEnd(_controllerTaxAdmin);
    _controllerDuration.text = currentProduct.duration.inMinutes.toString();
    textFieldToEnd(_controllerDuration);

    _mainModel.provider.providersComboValueForService = currentProduct.providers.isNotEmpty ? currentProduct.providers[0] : "1";
  }

  _priceInit(){
    for (var i = 0; i < 10; i++){
      _controllerPrice[i].text = "";
      _controllerDiscPrice[i].text = "";
      _controllerNamePrice[i].text = "";
    }
    var index = 0;
    for (var item in currentProduct.price){
      _controllerPrice[index].text = item.price.toString();
      textFieldToEnd(_controllerPrice[index]);
      _controllerDiscPrice[index].text = item.discPrice.toString();
      textFieldToEnd(_controllerDiscPrice[index]);
      _controllerNamePrice[index].text = _mainModel.getTextByLocale(item.name);
      textFieldToEnd(_controllerNamePrice[index]);
      index++;
    }
    _currentPriceLevel = index;
  }

  _listAddons(){
    List<Widget> list = [];
    for (var item in currentProduct.addon)
      list.add(Container(
          width: windowWidth*0.2,
          child: Column(
            children: [
              button2ac(_mainModel.getTextByLocale(item.name), theme.style12W600White,
                  "\$${item.price.toStringAsFixed(0)}", theme.style12W600White,
                  theme.mainColor, 10,
                      (){}, true),
            ],
          )));

    return Wrap(
        runSpacing: 10,
        spacing: 10,
        children: list
    );
  }

}