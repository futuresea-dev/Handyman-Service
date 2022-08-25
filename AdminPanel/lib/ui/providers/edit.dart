import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/dialogs/dialogs.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';
import 'map.dart';

class EditInProvider extends StatefulWidget {
  final GlobalKey keyM;
  EditInProvider({required this.keyM});
  @override
  _EditInProviderState createState() => _EditInProviderState();
}

class _EditInProviderState extends State<EditInProvider> {

  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerDesc = TextEditingController();
  final _controllerAddress = TextEditingController();
  final _controllerDescTitle = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerWww = TextEditingController();
  final _controllerTelegram = TextEditingController();
  final _controllerInstagram = TextEditingController();
  final _controllerTax = TextEditingController();
  //
  final _controllerMaxServices = TextEditingController();
  final _controllerMaxAddonInOneService = TextEditingController();
  final _controllerMaxProducts = TextEditingController();
  final _controllerMinPurchaseAmount = TextEditingController();
  final _controllerMaxPurchaseAmount = TextEditingController();

  final dataKey = GlobalKey();
  late MainModel _mainModel;

  @override
  void dispose() {
    _controllerTelegram.dispose();
    _controllerInstagram.dispose();
    _controllerEmail.dispose();
    _controllerPhone.dispose();
    _controllerWww.dispose();
    _controllerDescTitle.dispose();
    _controllerName.dispose();
    _controllerDesc.dispose();
    _controllerAddress.dispose();
    _controllerTax.dispose();
    //
    _controllerMaxServices.dispose();
    _controllerMaxAddonInOneService.dispose();
    _controllerMaxProducts.dispose();
    _controllerMinPurchaseAmount.dispose();
    _controllerMaxPurchaseAmount.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (_mainModel.provider.newProvider != null){
        var currentContext = dataKey.currentContext;
        if (currentContext != null)
          Scrollable.ensureVisible(currentContext, duration: Duration(seconds: 1));
        _controllerEmail.text = currentProvider.login;
        _controllerName.text = getTextByLocale(currentProvider.name, strings.locale);
        _controllerAddress.text = currentProvider.address;
        _controllerDesc.text = getTextByLocale(currentProvider.desc, strings.locale);
        _controllerTax.text = appSettings.defaultAdminComission.toString();
      }
    });
    _mainModel.initEditorInProvidersScreen = _init;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    //
    // available and language
    //
    Widget _selectLang = Expanded(child: Container(
        width: 120,
        child: Combo(
          inRow: true, text: "",
          data: _mainModel.langDataCombo,
          value: _mainModel.langEditDataComboValue,
          onChange: (String value){
            _mainModel.langEditDataComboValue = value;
            setState(() {});
          },)));
    Widget _available = checkBox1a(context, strings.get(473), /// "Available",
        theme.mainColor, theme.style14W400, currentProvider.available,
            (val) {
          if (val == null) return;
          currentProvider.available = val;
          redrawMainWindow();
        });

    if (isMobile()){
      list.add(_available);
      list.add(SizedBox(height: 10));
      list.add(Text(strings.get(108), style: theme.style14W400,)); /// "Select language",
      list.add(_selectLang);
    }else
      list.add(Row(
        children: [
          Expanded(child: _available),
          Expanded(child: SizedBox(width: 10,)),
          Text(strings.get(108), style: theme.style14W400,), /// "Select language",
          _selectLang
        ],
      ));
    //
    list.add(SizedBox(height: 10,));
    if (_mainModel.provider.newProvider != null){
      list.add(Center(child: Text(strings.get(249), style: theme.style16W800Red, textAlign: TextAlign.center,))); /// For assign new provider set needed fields...
      list.add(SizedBox(height: 10,));
    }
    //
    // name
    //
    list.add(Container(key: widget.keyM));
    if (isMobile()){
      list.add(textElement2(strings.get(54), "", _controllerName, (String val){         /// "Name",
        providerSetName(val, _mainModel.langEditDataComboValue);
        redrawMainWindow();
      }));
      list.add(SizedBox(height: 10,));
      list.add(textElement2(strings.get(248), "", _controllerEmail, (String val){         /// "Login Email",
        currentProvider.login = val;
        redrawMainWindow();
      }));
    }else
      list.add(Row(
        children: [
          Expanded(child: textElement2(strings.get(54), "", _controllerName, (String val){         /// "Name",
            providerSetName(val, _mainModel.langEditDataComboValue);
            redrawMainWindow();
          })),
          SizedBox(width: 10,),
          Expanded(child: textElement2(strings.get(248), "", _controllerEmail, (String val){         /// "Login Email",
            currentProvider.login = val;
            redrawMainWindow();
          })),
        ],
      ));

    list.add(SizedBox(key: dataKey, height: 10,));
    //
    //
    //
    if (!appSettings.enableSubscriptions)
      list.add(numberElement2Percentage(strings.get(265), "", _controllerTax, (String val){         /// "Default Tax for provider (administration payment)",
        currentProvider.tax = toDouble(val);
        redrawMainWindow();
      }));
    list.add(SizedBox(height: 10,));
    list.add(textElement2(strings.get(120), "", _controllerDescTitle, (String val){           /// Description Title
      providerSetDescTitle(val, _mainModel.langEditDataComboValue);
      redrawMainWindow();
    }));

    list.add(SizedBox(height: 10,));
    //
    // description
    //
    list.add(textElement2(strings.get(73), "", _controllerDesc, (String val){           /// Description
      providerSetDesc(val, _mainModel.langEditDataComboValue);
      redrawMainWindow();
    }));
    list.add(SizedBox(height: 10,));
    //
    // address
    //
    list.add(textElement2(strings.get(97), "", _controllerAddress, (String val){           /// Address
      currentProvider.address = val;
      redrawMainWindow();
    }));
    list.add(SizedBox(height: 10,));
    list.add(SelectableText(strings.get(409), style: theme.style14W400,)); /// Work area
    list.add(SizedBox(height: 10,));
    list.add(MapWithRegionCreation());
    list.add(Divider());
    //
    // Upper image
    //
    list.add(Row(
      children: [
        Text(strings.get(118), style: theme.style14W400,),                                /// Upper image
        SizedBox(width: 15,),
        button2b(strings.get(75), _selectUpperImage), /// "Select image",
        SizedBox(width: 10,),
        Text(strings.get(442), style: theme.style14W400,),                                /// "or",
        SizedBox(width: 10,),
        button2b(strings.get(430), (){        /// "Add image URL",
          _mainModel.addImageType = "provider_upper_image";
          showDialogAddVImageUrl();
        }),
      ],
    ));
    if (currentProvider.imageUpperServerPath.isNotEmpty)
    list.add(SizedBox(height: 5,));
    if (currentProvider.imageUpperServerPath.isNotEmpty)
    list.add(Text(strings.get(231), style: theme.style14W400,)); /// "Current image",
    list.add(SizedBox(height: 5,));
    list.add(SelectableText(currentProvider.imageUpperServerPath, style: theme.style14W400,));
    list.add(SizedBox(height: 5,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // Logo image
    //
    list.add(Row(
      children: [
        Text(strings.get(119), style: theme.style14W400,),                                ///  Logo image
        SizedBox(width: 15,),
        button2b(strings.get(75), _selectLogoImage), /// "Select image",
        SizedBox(width: 10,),
        Text(strings.get(442), style: theme.style14W400,),                                /// "or",
        SizedBox(width: 10,),
        button2b(strings.get(430), (){        /// "Add image URL",
          _mainModel.addImageType = "provider_logo_image";
          showDialogAddVImageUrl();
        }),
      ],
    ));
    if (currentProvider.logoServerPath.isNotEmpty)
      list.add(SizedBox(height: 5,));
    if (currentProvider.logoServerPath.isNotEmpty)
      list.add(Text(strings.get(231), style: theme.style14W400,)); /// "Current image",
    list.add(SizedBox(height: 5,));
    list.add(SelectableText(currentProvider.logoServerPath, style: theme.style14W400,));
    list.add(SizedBox(height: 5,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    list.add(SizedBox(height: 10,));
    //
    // category
    //
    list.add(TreeInCategory(
      showDelete: false,
      showCheckBoxes: true,
      getSelectList: (){
        return currentProvider.category;
      },
      select: (CategoryData item){
        if (currentProvider.category.contains(item.id))
          currentProvider.category.remove(item.id);
        else
          currentProvider.category.add(item.id);
        redrawMainWindow();
      },
      stringCategoryTree: strings.get(232), /// Category tree
    ));
    list.add(SizedBox(height: 10,));
    //
    // phone + web page
    //
    list.add(Row(
      children: [
        Expanded(child: textElement2(strings.get(124), "", _controllerPhone, (String val){         /// "Phone",
          currentProvider.phone = val;
          redrawMainWindow();
        })),
        SizedBox(width: 10,),
        Expanded(child: textElement2(strings.get(125), "", _controllerWww, (String val){         /// "Web Page",
          currentProvider.www = val;
          redrawMainWindow();
        })),
      ],
    ));
    list.add(SizedBox(height: 10,));
    //
    // telegram + instagram
    //
    list.add(Row(
      children: [
        Expanded(child: textElement2(strings.get(126), "", _controllerTelegram, (String val){         /// "Telegram",
          currentProvider.telegram = val;
          redrawMainWindow();
        })),
        SizedBox(width: 10,),
        Expanded(child: textElement2(strings.get(127), "", _controllerInstagram, (String val){         /// "Instagram",
          currentProvider.instagram = val;
          redrawMainWindow();
        })),
      ],
    ));
    list.add(SizedBox(height: 10,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // Gallery
    //
    list.add(Text(strings.get(128), style: theme.style16W800)); /// Gallery
    list.add(SizedBox(height: 10,));
    if (currentProvider.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: currentProvider.gallery.map((e){
            var _tag = UniqueKey().toString();
            return InkWell(
                onTap: (){
                  openGalleryScreen(currentProvider.gallery, e);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: Hero(
                    tag: _tag,
                    child: Stack(
                          children: [
                            Container(
                              child:  Image.network(e.serverPath, fit: BoxFit.cover,)
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.topRight,
                              child: IconButton(icon: Icon(Icons.cancel, color: Colors.red,),
                                onPressed: () async {
                                  var ret = await providerDeleteImage(e);
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
    list.add(SizedBox(height: 10,));
    list.add(button2b(strings.get(129), _selectImageToGallery));        /// "Add image to gallery",
    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    list.add(Text(strings.get(133), style: theme.style16W800,));                /// "Working time",
    list.add(SizedBox(height: 10,));
    if (isMobile()){
      list.add(_time1());
      list.add(SizedBox(height: 10,));
      list.add(_time2());
    }else
      list.add(Row(
        children: [
              Expanded(child: _time1()),
              SizedBox(width: 10,),
              Expanded(child: _time2())
              ],
            )
        );

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    //
    list.add(Row(
      children: [
        CheckBox12((){return currentProvider.useMaximumServices;},
              (bool value){
            currentProvider.useMaximumServices = value;
            _redraw();
          }, color: theme.mainColor,),
        SizedBox(width: 10,),
        Text(strings.get(474), style: theme.style14W400,),  /// Maximum services count for this provider
        SizedBox(width: 10,),
        if (currentProvider.useMaximumServices)
          Container(
              width: 150,
              child: Edit41Number(controller: _controllerMaxServices,
                radius: aTheme.radius,
                style: aTheme.style14W400,
                onChange: (String val){
                  currentProvider.maxServices = toInt(val);
                  _redraw();
                },
                backgroundColor: (aTheme.darkMode) ? aTheme.blackColorTitleBkg : Colors.white,
                hint: "123",
                color: Colors.grey, )
          ),
      ],
    ));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        CheckBox12((){return currentProvider.useMaxAddonInOneService;},
                (bool value){
              currentProvider.useMaxAddonInOneService = value;
              _redraw();
            }, color: theme.mainColor),
        SizedBox(width: 10,),
        Text(strings.get(475), style: theme.style14W400,),  /// Maximum addons count for each service
        SizedBox(width: 10,),
        if (currentProvider.useMaxAddonInOneService)
          Container(
              width: 150,
              child: Edit41Number(controller: _controllerMaxAddonInOneService,
                radius: aTheme.radius,
                style: aTheme.style14W400,
                onChange: (String val){
                  currentProvider.maxAddonInOneService = toInt(val);
                  _redraw();
                },
                backgroundColor: (aTheme.darkMode) ? aTheme.blackColorTitleBkg : Colors.white,
                hint: "123",
                color: Colors.grey, )
          ),
      ],
    ));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        CheckBox12((){return currentProvider.useMaximumProducts;},
                (bool value){
              currentProvider.useMaximumProducts = value;
              _redraw();
            }, color: theme.mainColor),
        SizedBox(width: 10,),
        Text(strings.get(476), style: theme.style14W400,),  /// "Maximum products count for this provider",
        SizedBox(width: 10,),
        if (currentProvider.useMaximumProducts)
          Container(
              width: 150,
              child: Edit41Number(controller: _controllerMaxProducts,
                radius: aTheme.radius,
                style: aTheme.style14W400,
                onChange: (String val){
                  currentProvider.maxProducts = toInt(val);
                  _redraw();
                },
                backgroundColor: (aTheme.darkMode) ? aTheme.blackColorTitleBkg : Colors.white,
                hint: "123",
                color: Colors.grey, )
          ),
      ],
    ));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        CheckBox12((){return currentProvider.useMinPurchaseAmount;},
                (bool value){
              currentProvider.useMinPurchaseAmount = value;
              _redraw();
            }, color: theme.mainColor),
        SizedBox(width: 10,),
        Text(strings.get(477), style: theme.style14W400,),  /// "Minimum order amount",
        SizedBox(width: 10,),
        if (currentProvider.useMinPurchaseAmount)
          Container(
            width: 150,
            child: Edit41web(controller: _controllerMinPurchaseAmount,
              price: true,
              numberOfDigits: appSettings.digitsAfterComma,
              onChange: (String val){
                currentProvider.minPurchaseAmount = toDouble(val);
                _redraw();
              },
              hint: "123",
            ),
          ),
        SizedBox(width: 10,),
        Text(appSettings.symbol, style: theme.style14W400,),
      ],
    ));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        CheckBox12((){return currentProvider.useMaxPurchaseAmount;},
                (bool value){
              currentProvider.useMaxPurchaseAmount = value;
              _redraw();
            }, color: theme.mainColor),
        SizedBox(width: 10,),
        Text(strings.get(478), style: theme.style14W400,),  /// "Maximum order amount",
        SizedBox(width: 10,),
        if (currentProvider.useMaxPurchaseAmount)
          Container(
            width: 150,
            child: Edit41web(controller: _controllerMaxPurchaseAmount,
              price: true,
              numberOfDigits: appSettings.digitsAfterComma,
              onChange: (String val){
                currentProvider.maxPurchaseAmount = toDouble(val);
                _redraw();
              },
              hint: "123",
            ),
          ),
        SizedBox(width: 10,),
        Text(appSettings.symbol, style: theme.style14W400,),
      ],
    ));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        CheckBox12((){return currentProvider.acceptPaymentInCash;},
                (bool value){
              currentProvider.acceptPaymentInCash = value;
              _redraw();
            }, color: theme.mainColor),
        SizedBox(width: 10,),
        Text(strings.get(479), style: theme.style14W400,),  /// "Enable payment in cache for this provider",
      ],
    ));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        CheckBox12((){
          return currentProvider.acceptOnlyInWorkArea;
          },
          (bool value){
              currentProvider.acceptOnlyInWorkArea = value;
              _redraw();
            }, color: theme.mainColor),
        SizedBox(width: 10,),
        Text(strings.get(489), style: theme.style14W400,),  /// "Allow booking only if customer located in provider work area",
      ],
    ));

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));


    //
    // save
    //
    list.add(SizedBox(height: 20,));
    if (currentProvider.id.isEmpty)
      list.add(button2b(strings.get(121), () async {        /// "Create new provider",
        var ret = _checkData();
        if (ret != null)
          return messageError(context, ret);
        ret = await createProviderFromAdmin(_mainModel.provider.newProvider, _mainModel.provider.providersRequest);
        if (ret == null)
          messageOk(context, strings.get(81)); /// "Data saved",
        else
          messageError(context, ret);
        redrawMainWindow();
      }));
    else
      list.add(Row(
        children: [
          Expanded(child: button2b(strings.get(122), () async {  /// "Save current provider",
            var ret = _checkData();
            if (ret != null)
              return messageError(context, ret);
            ret = await saveProviderFromAdmin();
            if (ret == null)
              messageOk(context, strings.get(81)); /// "Data saved",
            else
              messageError(context, ret);
            redrawMainWindow();
          })),
          button2b(strings.get(123), (){ /// "Add New Provider",
            currentProvider = ProviderData.createEmpty();
            _init();
          })
        ],
      ));

    return Stack(
      children: [
        Container(
            width: (windowWidth/2 < 600) ? 600 : windowWidth/2,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
    if (currentProvider.name.isEmpty)
      return strings.get(91); /// "Please Enter Name",
    if (currentProvider.login.isEmpty)
      return strings.get(480); /// "Please Enter Login Email",
    if (currentProvider.address.isEmpty)
      return strings.get(481); /// "Please Enter Address",
    if (currentProvider.route.isEmpty)
      return strings.get(482); /// "Please Enter Work Area",
    if (currentProvider.logoServerPath.isEmpty)
      return strings.get(483); /// "Please upload Logo image",
    if (currentProvider.useMinPurchaseAmount && currentProvider.minPurchaseAmount <= 0)
      return strings.get(487); /// "Please enter minimum order amount",
    if (currentProvider.useMaxPurchaseAmount && currentProvider.maxPurchaseAmount <= 0)
      return strings.get(488); /// "Please enter maximum order amount",
    if (currentProvider.useMinPurchaseAmount && currentProvider.useMaxPurchaseAmount){
      if (currentProvider.minPurchaseAmount > currentProvider.maxPurchaseAmount)
        return strings.get(484); /// "Minimum purchase amount must be smaller then maximum purchase amount ",
      if (currentProvider.minPurchaseAmount == currentProvider.maxPurchaseAmount)
        return strings.get(485); /// "Minimum and maximum purchase amount must be different",
    }
    if (currentProvider.category.isEmpty)
      return strings.get(486); /// "Please select categories",
    return null;
  }

  _time1(){
    return Row(
      children: [
        Expanded(child: Combo(inRow: true, text: "",
              data: _mainModel.provider.weekDataCombo,
              value: _mainModel.provider.weekDataComboValue,
              onChange: (String value){
                _mainModel.provider.weekDataComboValue = value;
                redrawMainWindow();
              },)),
        SizedBox(width: 10,),
        Expanded(child: checkBox1a(context, strings.get(141), /// "Weekend",
            theme.mainColor, theme.style14W400, getWeekend(_mainModel.provider.weekDataComboValue),
                (val) {
              if (val == null) return;
              setWeekend(val, _mainModel.provider.weekDataComboValue);
              redrawMainWindow();
            })),
      ],
    );
  }

  _time2(){
    return Row(
        children: [
          InkWell(
              onTap: () async {
                await selectOpenDate(context, _mainModel.provider.weekDataComboValue);
                redrawMainWindow();
              },
              child: Container(
                  width: 100,
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(theme.radius),
                    border: Border.all(
                      color: dashboardColorForEdit,
                      width: 1.0,
                    ),
                  ),
                  child: Center(child: Text(getOpenTime(_mainModel.provider.weekDataComboValue),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),))
              )),
          SizedBox(width: 20,),
          SelectableText(" - ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
          SizedBox(width: 5,),
          InkWell(
              onTap: () async {
                await selectCloseDate(context, _mainModel.provider.weekDataComboValue);
                redrawMainWindow();
              },
              child: Container(
                  width: 100,
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(theme.radius),
                    border: Border.all(
                      color: dashboardColorForEdit,
                      width: 1.0,
                    ),
                  ),
                  child: Center(child: Text(getCloseTime(_mainModel.provider.weekDataComboValue),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),))
              )

          )
        ]
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
      var ret = await providerAddImageToGallery(await pickedFile.readAsBytes());
      if (ret != null)
        messageError(context, ret);
      else
        messageOk(context, strings.get(363)); /// "Image saved",
      _waits(false);
    }
  }

  Future<String?> _selectLogoImage() async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null){
      _waits(true);
      var ret = await providerSetLogoImageData(await pickedFile.readAsBytes());
      if (ret != null)
        messageError(context, ret);
      _waits(false);
    }
    return null;
  }

  _selectUpperImage() async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null){
      _waits(true);
      var ret = await providerSetUpperImageData(await pickedFile.readAsBytes());
      if (ret != null)
        messageError(context, ret);
      _waits(false);
    }
  }

  bool _select = false;

  _init(){
    _select = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      _select = false;
      _redraw();
    });

    if (currentProvider.id.isEmpty)
      _controllerTax.text = appSettings.defaultAdminComission.toString();
    else
      _controllerTax.text = currentProvider.tax.toString();

    _controllerName.text = _mainModel.getTextByLocale(currentProvider.name);
    textFieldToEnd(_controllerName);
    _controllerPhone.text = currentProvider.phone;
    textFieldToEnd(_controllerPhone);
    _controllerEmail.text = currentProvider.login;
    textFieldToEnd(_controllerEmail);
    _controllerDesc.text = _mainModel.getTextByLocale(currentProvider.desc);
    textFieldToEnd(_controllerDesc);
    _controllerDescTitle.text = _mainModel.getTextByLocale(currentProvider.descTitle);
    textFieldToEnd(_controllerDescTitle);
    _controllerTelegram.text = currentProvider.telegram;
    textFieldToEnd(_controllerTelegram);
    _controllerInstagram.text = currentProvider.instagram;
    textFieldToEnd(_controllerInstagram);
    _controllerAddress.text = currentProvider.address;
    textFieldToEnd(_controllerAddress);
    _controllerWww.text = currentProvider.www;
    textFieldToEnd(_controllerWww);

    //
    _controllerMaxServices.text = currentProvider.maxServices.toString();
    _controllerMaxAddonInOneService.text = currentProvider.maxAddonInOneService.toString();
    _controllerMaxProducts.text = currentProvider.maxProducts.toString();
    _controllerMinPurchaseAmount.text = currentProvider.minPurchaseAmount.toString();
    _controllerMaxPurchaseAmount.text = currentProvider.maxPurchaseAmount.toString();
  }

}