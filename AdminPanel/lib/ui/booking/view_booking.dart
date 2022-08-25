import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';

class BookingViewItem extends StatefulWidget {
  final Function() goBack;
  const BookingViewItem({required this.goBack});

  @override
  _BookingViewItemState createState() => _BookingViewItemState();
}

class _BookingViewItemState extends State<BookingViewItem> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Directionality(
        textDirection: strings.direction,
        child: Container(
        margin: EdgeInsets.all(20),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
    color: (theme.darkMode) ? Colors.black : Colors.white,
    borderRadius: BorderRadius.circular(theme.radius),
    ),
    child: ListView(
      children: _getList(),
    )));
  }

  _item(OrderData item){
    List<Widget> _addons = [];
    _addons.add(SizedBox(height: 5,));
    _addons.add(Container(
      margin: EdgeInsets.only(right: 100),
        child: Text(strings.get(347), style: theme.style14W400,)),); /// "Addons",
    _addons.add(SizedBox(height: 10,));
    bool _found = false;
    if (item.addon.isNotEmpty) {
      for (var item in item.addon) {
        if (!item.selected)
          continue;
        _addons.add(Container(
            margin: strings.direction == TextDirection.ltr ? EdgeInsets.only(left: 20) : EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Text("${getTextByLocale(item.name, strings.locale)} ${item.needCount}x${getPriceString(item.price)}",
                  style: theme.style14W400,),
                SizedBox(width: 10,),
                Text(getPriceString(item.needCount*item.price),
                  style: theme.style14W800,)
              ],
            )
        ));
        _addons.add(SizedBox(height: 5,));
        _found = true;
      }
    }
    if (!_found)
      _addons = [];

    //
    //
    //
    List<Widget> _statuses = [];
    var _style = theme.style13W800;
    var _first = true;
    for (var item2 in appSettings.statuses){
      if (_style == theme.style13W800Green)
        _style = theme.style13W600Grey;
      if (item2.id == item.status)
        _style = theme.style13W800Green;
      if (!_first)
        //_statuses.add(_circles());
        _statuses.add(Text("|", style: theme.style13W800,));
      else
        _first = false;
      _statuses.add(Text(getTextByLocale(item2.name, strings.locale), style: _style));
    }

    var _styleName = theme.style13W600Grey;
    var _dataName = theme.style13W400;

    setDataToCalculate(item, null);

    return Container(
      width: windowWidth,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 80,
                  width: 80,
                  child: (item.customerAvatar.isEmpty) ? CircleAvatar(backgroundImage: AssetImage("assets/avatar.png"), radius: 5,) :
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                          item.customerAvatar,
                          height: 80,
                          fit: BoxFit.cover))),
              SizedBox(width: 20,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(item.customer, style: theme.style14W800),
                    SizedBox(width: 10,),
                    Expanded(child: Text(item.id + " ${appSettings.getDateTimeString(item.time)}", style: _dataName, textAlign: TextAlign.center,)) /// Id
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(children: [
                    SelectableText(strings.get(183) + ":", style: _styleName,), /// "Booking At",
                    SizedBox(width: 10,),
                    Text(item.anyTime ? strings.get(280) : appSettings.getDateTimeString(item.selectTime), style: _dataName) /// Any time
                  ]),
                  SizedBox(height: 10,),
                  Row(children: [
                    Text(strings.get(178) + ":", style: _styleName), /// "Provider",
                    SizedBox(width: 8,),
                    Expanded(child: Text(getTextByLocale(item.provider, strings.locale), style: _dataName, maxLines: 3,
                      overflow: TextOverflow.ellipsis,)),
                  ],),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(strings.get(159) + ":", style: _styleName), /// "Service",
                      SizedBox(width: 8,),
                      Expanded(child: Text(getTextByLocale(item.service, strings.locale)
                          + getTextByLocale(item.priceName, strings.locale), style: _dataName, maxLines: 3,
                        overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(children: [
                    Text(strings.get(97) + ":", style: _styleName,), /// "Address",
                    SizedBox(width: 8,),
                    Expanded(child: Text(item.address, style: _dataName, maxLines: 4)),
                  ],),
                  SizedBox(height: 10,),
                  Row(children: [
                    Text(strings.get(284) + ":", style: _styleName,), /// "Payment method",
                    SizedBox(width: 8,),
                    Expanded(child: Text(item.paymentMethod, style: _dataName, maxLines: 1)),
                  ],),
                  SizedBox(height: 10,),
                  Row(children: [
                    Text(strings.get(180) + ":", style: _styleName), /// "Comment"
                    SizedBox(width: 8,),
                    Expanded(child: Text(item.comment, style: _dataName,)),
                  ],),
                ],
              )),
              Expanded(child: pricingTable(
                      (String code){
                    if (code == "addons") return strings.get(347);  /// "Addons",
                    if (code == "direction") return strings.direction;
                    if (code == "locale") return strings.locale;
                    if (code == "pricing") return strings.get(410);  /// "Pricing",
                    if (code == "quantity") return strings.get(411);  /// "Quantity",
                    if (code == "taxAmount") return strings.get(412);  /// "Tax amount",
                    if (code == "total") return strings.get(177);  /// "Total",
                    if (code == "subtotal") return strings.get(413);  /// "Subtotal",
                    if (code == "discount") return strings.get(164);  /// "Discount"
                    return "";
                  }
              )),
            ],
          ),
          SizedBox(height: 10,),
          Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,),
          SizedBox(height: 10,),

          Row(
            children: [
              Expanded(child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 20.0,
                  spacing: 20, children: _statuses
              )),

              SizedBox(width: 40),
              // button2b(item == _mainModel.booking.current ? strings.get(184) : strings.get(68), /// "Close", "Edit",
              //      (){_edit(item);}),
            ],
          ),


        ],
      ),
    );
  }

  _itemV4(OrderData item){
    List<Widget> _statuses = [];
    var _style = theme.style13W800;
    var _first = true;
    for (var item2 in appSettings.statuses){
      if (_style == theme.style13W800Green)
        _style = theme.style13W600Grey;
      if (item2.id == item.status)
        _style = theme.style13W800Green;
      if (!_first)
        _statuses.add(Text("|", style: theme.style13W800,));
      else
        _first = false;
      _statuses.add(Text(getTextByLocale(item2.name, strings.locale), style: _style));
    }

    var _styleName = theme.style13W600Grey;
    var _dataName = theme.style13W400;

    cart = item.products;
    cartCurrentProvider = ProviderData.createEmpty()..id = item.providerId;

    Color color = Colors.grey.withAlpha(40);
    var _font = theme.style14W400;

    List<Widget> listPrices = [];
    listPrices.add(Row(
        children: [
          Container(
            width: 100,
            color: color,
            padding: EdgeInsets.all(5),
            child: Text("", style: _font)
          ),
          Expanded(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.all(5),
                  color: color,
                  child: Text(strings.get(459), style: _font) /// Product name
              )
          ),
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.all(5),
                  color: color,
                  child: Text(strings.get(460), style: _font) /// Qty
              )
          ),
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.all(5),
                  color: color,
                  child: Text(strings.get(461), style: _font) /// Unit price
              )
          ),
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.all(5),
                  color: color,
                  child: Text(strings.get(347), style: _font) /// "Addons",
              )
          ),
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.all(5),
                  color: color,
                  child: Text(strings.get(412), style: _font) /// "Tax amount",
              )
          ),
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.all(5),
                  color: color,
                  child: Text(strings.get(462), style: _font) /// "Sub Total",
              )
          )
        ]
    ),
    );
    for (var item in cartGetPriceForAllServices()){
      listPrices.add(Row(
                children: [
                  Container(
                    width: 100,
                    padding: EdgeInsets.all(10),
                      child: item.image.isNotEmpty ? Image.network(item.image, fit: BoxFit.contain,) : Container(),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Text(item.name, style: _font) // Product name
                          ),
                          SizedBox(height: 5,),
                          if (item.addonText.isNotEmpty)
                            Container(
                                padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                                child: Text(item.addonText, style: _font) // Product name
                            ),
                        ],
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(item.count.toString(), style: _font) // Qty
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(getPriceString(item.priceWithoutCount), style: _font) // Unit price
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(getPriceString(item.priceAddons), style: _font) // Add on
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text("(${item.taxPercentage.toStringAsFixed(0)}%) ${getPriceString(item.tax)}", style: _font) // Tax
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(item.subTotalString, style: _font) // Total
                      )
                  )
                ]
          )
      );

      listPrices.add(SizedBox(height: 5),);
      listPrices.add(Divider(color: color),);
      listPrices.add(SizedBox(height: 5),);
    }

    var _totalPrice = cartGetTotalForAllServices();

    return Container(
      width: windowWidth,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 80,
                  width: 80,
                  child: (item.customerAvatar.isEmpty) ? CircleAvatar(backgroundImage: AssetImage("assets/avatar.png"), radius: 5,) :
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                          item.customerAvatar,
                          height: 80,
                          fit: BoxFit.cover))),
              SizedBox(width: 20,),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(item.customer, style: theme.style14W800),
                        SizedBox(width: 10,),
                        Expanded(child: Text(item.id + " ${appSettings.getDateTimeString(item.time)}", style: _dataName, textAlign: TextAlign.center,)) /// Id
                      ],
                      ),
                      SizedBox(height: 10,),
                      Row(children: [
                        SelectableText(strings.get(183) + ":", style: _styleName,), /// "Booking At",
                        SizedBox(width: 10,),
                        Text(item.anyTime ? strings.get(280) : appSettings.getDateTimeString(item.selectTime), style: _dataName) /// Any time
                      ]),
                      SizedBox(height: 10,),
                      Row(children: [
                        Text(strings.get(178) + ":", style: _styleName), /// "Provider",
                        SizedBox(width: 8,),
                        Expanded(child: Text(item.providerId == "root" ? strings.get(468) /// "Not provider. Administration"
                            : getTextByLocale(item.provider, strings.locale), style: _dataName, maxLines: 3,
                          overflow: TextOverflow.ellipsis,)),
                      ],),
                      SizedBox(height: 10,),
                      Row(children: [
                        Text(strings.get(97) + ":", style: _styleName,), /// "Address",
                        SizedBox(width: 8,),
                        Expanded(child: Text(item.address, style: _dataName, maxLines: 4)),
                      ],),
                      SizedBox(height: 10,),
                      Row(children: [
                        Text(strings.get(284) + ":", style: _styleName,), /// "Payment method",
                        SizedBox(width: 8,),
                        Expanded(child: Text(item.paymentMethod, style: _dataName, maxLines: 1)),
                      ],),
                      SizedBox(height: 10,),
                      Row(children: [
                        Text(strings.get(180) + ":", style: _styleName), /// "Comment"
                        SizedBox(width: 8,),
                        Expanded(child: Text(item.comment, style: _dataName,)),
                      ],),
                    ],
                  )),],
          ),
          SizedBox(height: 10,),
          Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,),
          SizedBox(height: 10,),

          Row(
            children: [
              Expanded(child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 20.0,
                  spacing: 20, children: _statuses
              )),

              SizedBox(width: 40),
            ],
          ),

          SizedBox(height: 20),

          ...listPrices,

          /////////////////////////////////////
          Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                        children: [
                          Row(
                              children: [
                                Expanded(child: Text(strings.get(462), style: _font)), /// Sub Total
                                SizedBox(width: 10),
                                Text(getPriceString(_totalPrice.subtotal), style: _font)
                              ]
                          ),
                          SizedBox(height: 5),
                          Row(
                              children: [
                                Expanded(child: Text(strings.get(463), style: _font)), /// Total Tax
                                SizedBox(width: 10),
                                Text(getPriceString(_totalPrice.tax), style: _font)
                              ]
                          ),
                          SizedBox(height: 5),
                          Divider(color: color),
                          SizedBox(height: 2),
                          Row(
                              children: [
                                Expanded(child: Text(strings.get(464), style: _font)), /// Coupon Discount
                                SizedBox(width: 10),
                                Text(getPriceString(_totalPrice.discount), style: _font)
                              ]
                          ),
                          SizedBox(height: 2),
                          Divider(color: color),
                          SizedBox(height: 5),
                          Row(
                              children: [
                                Expanded(child: Text(strings.get(467), style: _font)), /// Grand Total
                                SizedBox(width: 10),
                                Text(getPriceString(_totalPrice.total), style: _font)
                              ]
                          ),
                        ]
                    )
                ),
              ]
          )

        ],
      ),
    );
  }

  _getList(){

    List<Widget> list = [];

    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(181), // Booking list
          style: theme.style25W800,)),
        button2b(strings.get(366), (){widget.goBack();}) /// "Back to list",
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    list.add(currentOrder.ver4 ? _itemV4(currentOrder) : _item(currentOrder));

    list.add(SizedBox(height: 40));

    return list;
  }
}
