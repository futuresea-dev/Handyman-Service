import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class EditInOffers extends StatefulWidget {
  @override
  _EditInOffersState createState() => _EditInOffersState();
}

class _EditInOffersState extends State<EditInOffers> {
  final _controllerCode = TextEditingController();
  final _controllerDesc = TextEditingController();
  final _controllerDiscount = TextEditingController();
  final _controllerUrl = TextEditingController();
  //
  late MainModel _mainModel;
  late ComboData2 _providersComboData;
  late ComboData2 _categoryComboData;
  late ComboData2 _serviceComboData;
  late ComboData2 _articleComboData;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _init();
    _mainModel.initEditorInOfferScreen = _init;
    super.initState();
  }

  final GlobalKey _popupKey = GlobalKey();
  final GlobalKey _popupKey2 = GlobalKey();
  final GlobalKey _popupKey3 = GlobalKey();
  final GlobalKey _popupKey4 = GlobalKey();

  @override
  void dispose() {
    _controllerUrl.dispose();
    _controllerCode.dispose();
    _controllerDesc.dispose();
    _controllerDiscount.dispose();
    _mainModel.initEditorInOfferScreen = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    //
    // visible and language
    //
    Widget _visible = checkBox1a(context, strings.get(70), /// "Visible",
        theme.mainColor, theme.style14W400, currentOffer.visible,
            (val) {
          if (val == null) return;
          currentOffer.visible = val;
          redrawMainWindow();
        });

    Widget _selectLanguage = Row(children: [
      Text(strings.get(108), style: theme.style14W400,), /// "Select language",
      Expanded(child: Container(
        // width: 120,
          child: Combo(inRow: true, text: "",
            data: _mainModel.langDataCombo,
            value: _mainModel.langEditDataComboValue,
            onChange: (String value){
              _mainModel.langEditDataComboValue = value;
              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                _init();
              });
              _redraw();
            },)))
    ]);

    Widget _code = textElement2(strings.get(163), "", _controllerCode, (String val){         /// "CODE",
      currentOffer.code = val;
      redrawMainWindow();
    });

    Widget _desc = textElement2(strings.get(73), "", _controllerDesc, (String val){           /// Description
      currentOffer.setDesc(val, _mainModel.langEditDataComboValue);
      redrawMainWindow();
    });

    Widget _discount = numberElement2Percentage(strings.get(164), /// Discount
        "123",
        _controllerDiscount, (String val){
          currentOffer.discount = double.parse(val);
          redrawMainWindow();
        });
    if (currentOffer.discountType == "fixed")
      _discount = numberElement2Price(strings.get(164), /// Discount
          "123", appSettings.symbol,
          _controllerDiscount, (String val){
            currentOffer.discount = double.parse(val);
            redrawMainWindow();
          }, appSettings.digitsAfterComma);

    Widget _discountType = Row(
      children: [
        SelectableText(strings.get(166), style: theme.style14W400,), /// "Discount type",
        SizedBox(width: 10,),
        Expanded(child: Combo(inRow: true, text: "",
          data: _mainModel.offer.discountTypeCombo,
          value: currentOffer.discountType,
          onChange: (String value){
            if (value == "percentage")
              if (toInt(_controllerDiscount.text) > 100)
                _controllerDiscount.text = "100";
            currentOffer.discountType = value;
            redrawMainWindow();
          },)),
      ],
    );

    Widget _expire = Row(
      children: [
        SelectableText(strings.get(167), style: theme.style14W400,), /// "Expire",
        SizedBox(width: 10,),
        Expanded(child: Container(
            height: 200,
            child: CupertinoDatePicker(
              key: UniqueKey(),
              initialDateTime: currentOffer.expired,
              onDateTimeChanged: (DateTime val) {
                currentOffer.expired = val;
              },
              use24hFormat: true,
              mode: CupertinoDatePickerMode.dateAndTime,
            )
        )),
      ],
    );

    Widget _visibleInApp = Column(
      children: [
        checkBox1a(context, strings.get(507), /// "Visible in app. (If uncheck: in app offer don't showing. Customer can only enter text code)",
            theme.mainColor, theme.style14W400, currentOffer.visibleForUser,
                (val) {
              if (val == null) return;
              currentOffer.visibleForUser = val;
              redrawMainWindow();
            }),
        SizedBox(height: 10,),
        textElement2(strings.get(441), "", _controllerUrl, (String val){           /// "Add image URL (optional)",
          currentOffer.image = val;
          _redraw();
        }),
        SizedBox(height: 10,),
        Row(
            children: [
              SelectableText(strings.get(72), style: theme.style14W400,), /// "Select color",
              SizedBox(width: 10,),
              Container(
                width: 150,
                child: ElementSelectColor(getColor: (){return currentOffer.color;}, setColor: (Color val){
                  currentOffer.color = val;
                  _redraw();
                },),
              ),]
        )
      ],
    );

    Widget _inAppPreview = Container();
    if (DateTime.now().isAfter(currentOffer.expired)) {
      _inAppPreview = Center(child: Text(strings.get(167), style: TextStyle(fontSize: 40, color: Colors.red.withAlpha(100)),)); /// "Expire"
    }else{
      var disc = "";
      var desc = getTextByLocale(currentOffer.desc, _mainModel.langEditDataComboValue);
      if (currentOffer.discountType == "fixed")
        disc = "-${getPriceString(currentOffer.discount)} $desc";
      else
        disc = "-${currentOffer.discount}% $desc";

      _inAppPreview = currentOffer.visibleForUser ?
      offerWidget(currentOffer.color, strings.get(510), /// "Special offer"
          theme.style12W600White, currentOffer.image,
          disc, theme.style14W800,
          400, 200,
        strings.get(508), theme.style14W600White, /// "Use now"
        "${strings.get(509)} ${appSettings.getDateTimeString(currentOffer.expired)}", theme.style12W800)  /// "Valid until",
        : Container();
    }
    //
    // show
    //
    webMobileGrid(windowWidth, list,
        [
          _visible, _selectLanguage,
          _code, _expire,
          _discount, _discountType,
          _desc,
          _visibleInApp, _inAppPreview
        ],
        [
          2, 2,
          2, 2,
          2, 2,
          4,
          2, 2
        ]
    );


    list.add(SizedBox(height: 10,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    list.add(Row(
      children: [
        Text("${strings.get(96)}:", style: theme.style14W400,), /// Providers
        SizedBox(width: 10,),
        Expanded(child: popupWidget(_popupKey, _providersComboData,
                (String value){
              _providersComboData.value = value;
              _serviceComboData = getComboData("service", strings.get(254), /// All
                  providersForServices: _providersComboData);
              _redraw();
            }, strings.get(60), selectMany: true)) /// "Search",
      ],
    ));

    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Text("${strings.get(158)}:", style: theme.style14W400,), /// Category
        SizedBox(width: 10,),
        Expanded(child: popupWidget(_popupKey2, _categoryComboData,
                (String value){
              _categoryComboData.value = value;
            }, strings.get(60), selectMany: true)) /// "Search",
      ],
    ));

    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Text("${strings.get(142)}:", style: theme.style14W400,), /// Services
        SizedBox(width: 10,),
        Expanded(child: popupWidget(_popupKey3, _serviceComboData,
                (String value){
              _serviceComboData.value = value;
            }, strings.get(60), selectMany: true)) /// "Search",
      ],
    ));

    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Text("${strings.get(423)}:", style: theme.style14W400,), /// "Products",
        SizedBox(width: 10,),
        Expanded(child: popupWidget(_popupKey4, _articleComboData,
                (String value){
              _articleComboData.value = value;
            }, strings.get(60), selectMany: true)) /// "Search",
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
    if (currentOffer.id.isEmpty)
      list.add(button2b(strings.get(169), () async {        /// "Create new offer",
        var ret = dataIntegrityCheck();
        if (ret != null)
          return messageError(context, ret);
        ret = await offerSave();
        if (ret == null)
          messageOk(context, strings.get(81)); /// "Data saved",
        else
          messageError(context, ret);
        redrawMainWindow();
      }));
    else
      list.add(Row(
        children: [
          Expanded(child: button2b(strings.get(170), () async {  /// "Save current offer",
            var ret = dataIntegrityCheck();
            if (ret != null)
              return messageError(context, ret);
            ret = await offerSave();
            if (ret == null)
              messageOk(context, strings.get(81)); /// "Data saved",
            else
              messageError(context, ret);
            redrawMainWindow();
          })),
          button2b(strings.get(171), (){                 /// "Add New offer",
            currentOffer = OfferData.createEmpty();
            redrawMainWindow();
          })
        ],
      ));
    return Stack(
      children: [
        Container(
            width: (windowWidth < 900) ? 900 : (windowWidth > 1200) ? windowWidth-400 : windowWidth-80,
            decoration: BoxDecoration(
              color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: list,
                    ))
              ],
            )
        ),
      ],
    );
  }

  String? dataIntegrityCheck(){
    if (currentOffer.code.isEmpty)
      return strings.get(341); /// Please enter code
    if (currentOffer.discount == 0)
      return strings.get(507); /// Please enter discount

    currentOffer.providers = [];
    for (var item in _providersComboData.data)
      if (item.checkSelected)
        currentOffer.providers.add(item.id);

    currentOffer.services = [];
    for (var item in _serviceComboData.data)
      if (item.checkSelected)
        currentOffer.services.add(item.id);

    currentOffer.category = [];
    for (var item in _categoryComboData.data)
      if (item.checkSelected)
        currentOffer.category.add(item.id);

    currentOffer.article = [];
    for (var item in _articleComboData.data)
      if (item.checkSelected)
        currentOffer.article.add(item.id);

    return null;
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _init(){

    _providersComboData = getComboData("providers", strings.get(254)); /// All
    _categoryComboData = getComboData("category", strings.get(254)); /// All
    _serviceComboData = getComboData("service", strings.get(254)); /// All
    _articleComboData = getComboData("article", strings.get(254), );

    if (currentOffer.id.isNotEmpty){
      _controllerCode.text = currentOffer.code;
      textFieldToEnd(_controllerCode);
      _controllerDesc.text = getTextByLocale(currentOffer.desc, _mainModel.langEditDataComboValue);
      textFieldToEnd(_controllerDesc);
      _controllerDiscount.text = currentOffer.discount.toString();
      textFieldToEnd(_controllerDiscount);

      for (var item in currentOffer.providers)
        for (var item2 in _providersComboData.data)
          if (item2.id == item)
            item2.checkSelected = true;

      for (var item in currentOffer.category)
        for (var item2 in _categoryComboData.data)
          if (item2.id == item)
            item2.checkSelected = true;

      for (var item in currentOffer.services)
        for (var item2 in _serviceComboData.data)
          if (item2.id == item)
            item2.checkSelected = true;

      for (var item in currentOffer.article)
        for (var item2 in _articleComboData.data)
          if (item2.id == item)
            item2.checkSelected = true;

    }else{
      _controllerCode.text = "";
      _controllerDesc.text = "";
      _controllerDiscount.text = "";

    }
  }
}