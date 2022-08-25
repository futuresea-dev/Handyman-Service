import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  var _state = "";

  final _controllerName = TextEditingController();
  final _controllerText2 = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerDays = TextEditingController();
  final _controllerResizer = ScrollerResizerController();
  final _controllerMultiText = TextEditingController();
  final _controllerPromotion = TextEditingController();
  // final _controllerDaysFreeTrial = TextEditingController();
  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
    _controllerName.dispose();
    _controllerText2.dispose();
    _controllerPrice.dispose();
    _controllerDays.dispose();
    _controllerMultiText.dispose();
    _controllerPromotion.dispose();
    // _controllerDaysFreeTrial.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _controllerResizer.select = 0;
    // _controllerDays.text = appSettings.subscriptionsFreeTrialDays.toString();
    // _controllerDaysFreeTrial.text = appSettings.subscriptionsFreeTrialDays.toString();
    _controllerPromotion.text = appSettings.subscriptionsPromotionText;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      var ret = await loadSubscriptions();
      if (ret != null)
        messageError(context, ret);
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
        controller: _controllerScroll,
        children: _getList(),
      ),
    );
  }

  _getList(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(490), /// "Subscriptions",
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    Widget _enable = checkBox1a(context, strings.get(497), /// "Enable subscriptions for all providers",
        theme.mainColor, theme.style14W400, appSettings.enableSubscriptions,
            (val) {
          if (val == null) return;
          appSettings.enableSubscriptions = val;
          _redraw();
        });

    list.add(_enable);
    list.add(SizedBox(height: 10,));

    // Widget _enableTrial = checkBox1a(context, strings.get(499), /// "Enable free trial",
    //     theme.mainColor, theme.style14W400, appSettings.enableSubscriptionsFreeTrial,
    //         (val) {
    //       if (val == null) return;
    //       appSettings.enableSubscriptionsFreeTrial = val;
    //       _redraw();
    //     });

    // if (appSettings.enableSubscriptions)
    // list.add(Row(
    //   children: [
    //     _enableTrial,
    //     SizedBox(width: 30,),
    //     if (appSettings.enableSubscriptionsFreeTrial)
    //         numberElement2(strings.get(493), /// Days
    //         "31", "", _controllerDaysFreeTrial, (String val){
    //           //currentSubscription.days = toInt(val);
    //         })
    //   ],
    // ));


    if (appSettings.enableSubscriptions){
      list.add(SizedBox(height: 10,));
      list.add(documentBlock(strings.get(498) + ":" + strings.get(200),
          _controllerPromotion, "", (){setState(() {});}, strings.get(25))); /// "Promotion text",  "You can use HTML tags (<p>, <br>, <h1> and other)" // "Preview",
      list.add(SizedBox(height: 10,));
      list.add(Row(
        children: [
          button2b(strings.get(9), (){        /// "Save"
            appSettings.subscriptionsPromotionText = _controllerPromotion.text;
            // appSettings.subscriptionsFreeTrialDays = toInt(_controllerDaysFreeTrial.text);
            saveSettings();
          }),
        ],
      ));
    }

    list.add(SizedBox(height: 30,));
    _buildSubscriptions();

    list.add(Opacity(
        opacity: appSettings.enableSubscriptions ? 1 : 0.2,
        child: Row(
          children: [
            Container(
                color: Colors.grey.withAlpha(20),
                child: ScrollerResizer(
                  windowWidth: _mainModel.getWorkspaceWidth()-80,
                  childWidth: 210,
                  controller: _controllerResizer,
                )
            )
          ],
        ))
    );

    if (appSettings.enableSubscriptions){
      list.add(SizedBox(height: 20,));
      list.add(Row(
        children: [
          button2b(strings.get(491), (){        /// "Create new subscription",
            currentSubscription = SubscriptionData.createEmpty();
            _state = "edit";
            _init();
            _redraw();
          }),
        ],
      ));
    }

    if (_state == "edit"){
      list.add(SizedBox(height: 20,));
      list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
      list.add(SizedBox(height: 10,));

      Widget _visible = checkBox1a(context, strings.get(70), /// "Visible",
          theme.mainColor, theme.style14W400, currentSubscription.visible,
              (val) {
            if (val == null) return;
            currentSubscription.visible = val;
            _buildSubscriptions();
            _redraw();
          });
      Widget _default = checkBox1a(context, strings.get(132), /// "Default",
          theme.mainColor, theme.style14W400, currentSubscription.defaultItem,
              (val) {
            if (val == null) return;
            for (var item in subscriptions)
              item.defaultItem = false;
            currentSubscription.defaultItem = val;
            _redraw();
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

      var _name = textElement2(strings.get(54), "", _controllerName, (String val){         /// "Name",
        subscriptionSetText(val, _mainModel.langEditDataComboValue);
        _buildSubscriptions();
        _redraw();
      });
      var _text2 = textElement2(strings.get(492), "", _controllerText2, (String val){         /// "Text",
        subscriptionSetText2(val, _mainModel.langEditDataComboValue);
        _buildSubscriptions();
        _redraw();
      });
      Widget _price = Column(
        children: [
          numberElement2Price(strings.get(144), /// Price
              "123", appSettings.symbol, _controllerPrice, (String val){
                currentSubscription.price = toDouble(val);
                _buildSubscriptions();
                _redraw();
                _redraw();
              }, appSettings.digitsAfterComma),
          SizedBox(height: 5,),
          Text(strings.get(502), style: theme.style12W400,) /// If price is 0, it means that this period will be free, i.e. "Free trial"
        ],
      );

      Widget _days = numberElement2(strings.get(493), /// Days
          "31", "", _controllerDays, (String val){ /// pcs
            currentSubscription.days = toInt(val);
          });

      Widget _multiText = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectableText(strings.get(494), style: aTheme.style14W400), /// "Multiline text",
          SizedBox(width: 10,),
          Expanded(child: edit22(_controllerMultiText,
            "", theme.radius,
              onChange: (String val){
                subscriptionSetDesc(val, _mainModel.langEditDataComboValue);
                _buildSubscriptions();
                _redraw();
              }
          ))
        ],
      );

      Widget _color = Row(
          children: [
            SelectableText(strings.get(72), style: theme.style14W400,), /// "Select color",
            SizedBox(width: 10,),
            Container(
              width: 150,
              child: ElementSelectColor(getColor: (){return currentSubscription.color;}, setColor: (Color color) {
                currentSubscription.color = color;
                _buildSubscriptions();
                _redraw();
              },),
            ),]
      );

      //
      // show
      //
      webMobileGrid(windowWidth, list,
          [
            _visible, _default, _selectLanguage,
            _name, _text2,
            _price, _days, _multiText,
            _color
          ],
          [
            1, 1, 2,
            2, 2,
            1, 1, 2,
            1
          ]
      );

      list.add(SizedBox(height: 10,));

      //
      // save
      //
      list.add(SizedBox(height: 20,));
      list.add(Row(
          children: [
            button2b(strings.get(495), () async {  /// "Save current subscription",
              var ret = dataIntegrityCheck();
              if (ret != null)
                return messageError(context, ret);
              if (currentSubscription.id.isEmpty) {
                currentSubscription.id = "1";
                subscriptions.add(currentSubscription);
              }
              ret = await saveSubscriptions();
              if (ret == null)
                messageOk(context, strings.get(81)); /// "Data saved",
              else
                messageError(context, ret);
              _buildSubscriptions();
              _redraw();
            })
          ],
        )
      );

    }
    return list;
  }

  List<Widget> w = [];
  _buildSubscriptions(){
    w = [];
    for (var item in subscriptions) {
      var _opacity = 1.0;
      if (!item.visible)
        _opacity = 0.3;
      w.add(Opacity(opacity: _opacity,
      child: Column(
        children: [
          subscriptionItem(210, item, item.price == 0 ? strings.get(503) : strings.get(504), /// "Start Free Trial Now", /// "Start",
              strings.get(499), /// Free Trial
              () async {}
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              button2b(strings.get(62), () { /// "Delete"
                if (!appSettings.enableSubscriptions)
                  return;
                openDialog(dialogYesNoBody((String val) async {
                  if (val == "text2"){
                    if (subscriptions.length == 1)
                      return messageError(context, strings.get(500)); /// "You can't delete all subscriptions. For delete this, add new subscription before.",
                    waitInMainWindow(true);
                    if (item == currentSubscription) {
                      currentSubscription = SubscriptionData.createEmpty();
                      _init();
                    }
                    var ret = await deleteSubscription(item);
                    if (ret != null)
                      messageError(context, ret);
                    _redraw();
                    waitInMainWindow(false);
                  }
                },
                  strings.get(63), /// "Do you want to delete this item? You will can't recover this item."
                      strings.get(61), /// "No",
                      strings.get(62), /// "Delete",
                    ));
              }, color: Colors.red),
              SizedBox(width: 10,),
              button2b(strings.get(68), () { /// "Edit"
                if (!appSettings.enableSubscriptions)
                  return;
                currentSubscription = item;
                _state = "edit";
                _init();
                _redraw();
              })
            ],
          )
        ],
      )));
    }
    _controllerResizer.childs = w;
    _controllerResizer.update();
  }

  String? dataIntegrityCheck(){
    if (currentSubscription.text.isEmpty)
      return strings.get(91); /// "Please Enter Name",
    if (currentSubscription.text2.isEmpty)
      return strings.get(357); /// "Please Enter Text",
    // if (currentSubscription.price == 0)
    //   return strings.get(342); /// "Please Enter Price",
    if (currentSubscription.days == 0)
      return strings.get(496); /// "Please enter number of days",
    return null;
  }

  _init(){
    if (currentSubscription.id.isNotEmpty){
      _controllerName.text = getTextByLocale(currentSubscription.text, _mainModel.langEditDataComboValue);
      _controllerText2.text = getTextByLocale(currentSubscription.text2, _mainModel.langEditDataComboValue);
      _controllerPrice.text = currentSubscription.price.toString();
      _controllerDays.text = currentSubscription.days.toString();
      _controllerMultiText.text = getTextByLocale(currentSubscription.desc, _mainModel.langEditDataComboValue);
    }else{
      _controllerName.text = "";
      _controllerText2.text = "";
      _controllerPrice.text = "";
      _controllerDays.text = "";
      _controllerMultiText.text = "";
    }
  }
}

List<SubscriptionData> subscriptionsTemplate = [
  SubscriptionData(
    id: "free",
    text: [StringData(code: "en", text: "Try free")],
    text2: [StringData(code: "en", text: "/month")],
    price: 0,
    days: 30,
    color: Colors.cyanAccent,
    desc: [StringData(code: "en", text: "Try 30 days for free\nMany customers\nUnlimited service count\nUnlimited work\nUnlimited all")],
    defaultItem: false,
  ),
  SubscriptionData(
      id: "1",
      text: [StringData(code: "en", text: "One month")],
      text2: [StringData(code: "en", text: "/month")],
      price: 16.99,
      days: 30,
      color: Colors.blue,
    desc: [StringData(code: "en", text: "Many customers\nUnlimited service count\nUnlimited work\nUnlimited all")],
  ),
  SubscriptionData(
    id: "2",
    text: [StringData(code: "en", text: "Two months")],
    text2: [StringData(code: "en", text: "/month")],
    price: 29.99,
    days: 30,
    color: Colors.red,
    desc: [StringData(code: "en", text: "Many customers\nUnlimited service count\nUnlimited work\nUnlimited all")],
    defaultItem: false,
  ),
  SubscriptionData(
    id: "2",
    text: [StringData(code: "en", text: "One year")],
    text2: [StringData(code: "en", text: "/month")],
    price: 129.99,
    days: 356,
    color: Colors.green,
    desc: [StringData(code: "en", text: "Many customers\nUnlimited service count\nUnlimited work\nUnlimited all")],
    defaultItem: true,
  ),
];




