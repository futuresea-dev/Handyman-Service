import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/booking/view_booking.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../utils.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import '../dialogs/dialogs.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  final _controllerSearch = TextEditingController();
  late MainModel _mainModel;
  String _sortBy = "modifyDesc";
  final ScrollController _controllerScroll = ScrollController();
  bool _showViewPage = false;

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      // var ret = await _mainModel.provider.load(context);
      // if (ret != null)
      //   messageError(context, ret);
      var ret = await _mainModel.notifyModel.loadUsers2();
      if (ret != null)
        messageError(context, ret);
      ret = await _mainModel.service.load(context);
      if (ret != null)
        messageError(context, ret);

      setBookingViewByAdminToNull();

      waitInMainWindow(false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerSearch.dispose();
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showViewPage)
      return BookingViewItem(goBack: (){
        _showViewPage = false;
        _redraw();
        },);
    return Directionality(
        textDirection: strings.direction,
        child: ListView(
      children: _getListBookings(),
    ));
  }

  _sortFilter(String? val){
    if (val != null)
      _sortBy = val;
    switch(_sortBy){
      case "orderDesc":
        ordersDataCache.sort((a, b) => b.id.compareTo(a.id));
        break;
      case "orderAsc":
        ordersDataCache.sort((a, b) => a.id.compareTo(b.id));
        break;
      case "customerNameDesc":
        ordersDataCache.sort((a, b) => b.customerName.compareTo(a.customerName));
        break;
      case "customerNameAsc":
        ordersDataCache.sort((a, b) => a.customerName.compareTo(b.customerName));
        break;
      case "providerNameDesc":
        ordersDataCache.sort((a, b) => getTextByLocale(b.providerName, locale).compareTo(getTextByLocale(a.providerName, locale)));
        break;
      case "providerNameAsc":
        ordersDataCache.sort((a, b) => getTextByLocale(a.providerName, locale).compareTo(getTextByLocale(b.providerName, locale)));
        break;
      case "countDesc":
        ordersDataCache.sort((a, b) => b.countProducts.compareTo(a.countProducts));
        break;
      case "countAsc":
        ordersDataCache.sort((a, b) => a.countProducts.compareTo(b.countProducts));
        break;
      case "priceDesc":
        ordersDataCache.sort((a, b) => b.total.compareTo(a.total));
        break;
      case "priceAsc":
        ordersDataCache.sort((a, b) => a.total.compareTo(b.total));
        break;
      case "modifyDesc":
        ordersDataCache.sort((a, b) => b.time.compareTo(a.time));
        break;
      case "modifyAsc":
        ordersDataCache.sort((a, b) => a.time.compareTo(b.time));
        break;
    }
    _redraw();
  }

  _getListBookings(){

    List<Widget> list = [];

    List<Widget> list3 = [];
    list3.add(SizedBox(height: 10,));
    list3.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(181), /// Booking list
          style: theme.style25W800,)),
      ],
    ));
    list3.add(SizedBox(height: 20,));
    list3.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list3.add(SizedBox(height: 10,));
    addButtonsCopyExportSearch(list3, _copy, _csv, strings.langCopyExportSearch, _onSearch);

    list.add(Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Column(
          children: list3
        )));

    list.add(Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: (isMobile())
            ? Column(
              children: [
                _sortBy1(),
                SizedBox(height: 10,),
                // _sortBy1a(),
                // SizedBox(height: 10,),
                _sortBy2(),
                SizedBox(height: 10,),
                _sortBy2a(),
              ],
            )
            : (isDesktopMore1300()) ?
                Row(
                    children: [
                      Expanded(child: _sortBy1()),
                      // SizedBox(width: 10,),
                      // Expanded(child: _sortBy1a()),
                      SizedBox(width: 10,),
                      Expanded(child: _sortBy2()),
                      SizedBox(width: 10,),
                      Expanded(child: _sortBy2a()),
                    ]
                )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _sortBy1()),
                      // SizedBox(width: 10,),
                      // Expanded(child: _sortBy1a()),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child: _sortBy2()),
                      SizedBox(width: 10,),
                      Expanded(child: _sortBy2a()),
                    ],
                  ),
                ],
              )
      )
    );

    pagingStart();
    List<DataRow> _cells = [];

    for (var item in ordersDataCache){
      if (_searchedValue.isNotEmpty)
        if (!item.customerName.toUpperCase().contains(_searchedValue.toUpperCase())
            &&
            !getTextByLocale(item.providerName, strings.locale).toUpperCase().contains(_searchedValue.toUpperCase())
            &&
            !item.id.toUpperCase().contains(_searchedValue.toUpperCase())
          )
          continue;
      if (_mainModel.provider.providersComboValue != "1")
        if (_mainModel.provider.providersComboValue != item.providerId)
          continue;
      if (_mainModel.notifyModel.userSelected != "-1")
        if (_mainModel.notifyModel.userSelected != item.customerId)
          continue;
      // if (_mainModel.service.serviceSelected != "-1")
      //   if (_mainModel.service.serviceSelected != item.serviceId)
      //     continue;
      if (_mainModel.statusesComboValueBookingSearch != "-1")
        if (_mainModel.statusesComboValueBookingSearch != item.status)
          continue;

      if (isNotInPagingRange())
        continue;

      _cells.add(DataRow(
          selected: item.id == currentArticle.id,
          cells: [
            // Order id
            DataCell(Container(child: SelectableText(item.id, style: theme.style14W400,))),
            // customer
            DataCell(SelectableText(item.customerName, style: theme.style14W400,)),
            // status
            DataCell(Container(child: Text(appSettings.getStatusName(item.status, strings.locale),
              overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
            // provider
            DataCell(SelectableText(getTextByLocale(item.providerName, strings.locale), style: theme.style14W400,)),
            // count Products
            DataCell(SelectableText(item.countProducts.toString(), style: theme.style14W400,)),
            // total
            DataCell(Text(getPriceString(item.total),
              overflow: TextOverflow.ellipsis, style: theme.style14W400,)),
            // modify
            DataCell(Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(timeago.format(item.time, locale: strings.locale),
                    overflow: TextOverflow.ellipsis, style: theme.style13W800Green),
                Text(appSettings.getDateTimeString(item.time),
                    overflow: TextOverflow.ellipsis, style: theme.style12W600Grey)
              ],
            )),
            // action
            DataCell(Center(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                button2small(strings.get(68), () async {   /// "Edit",
                  waitInMainWindow(true);
                  var ret = await bookingGetItem(item);
                  waitInMainWindow(false);
                  if (ret != null)
                    return messageError(context, ret);
                  showDialogEditOrder();
                  _redraw();
                }, color: theme.mainColor.withAlpha(150)),
                SizedBox(width: 5,),
                button2small(strings.get(406), () async {   /// "View",
                  waitInMainWindow(true);
                  var ret = await bookingGetItem(item);
                  waitInMainWindow(false);
                  if (ret != null)
                    return messageError(context, ret);
                  _showViewPage = true;
                  _redraw();
                }, color: theme.mainColor.withAlpha(150)),
                SizedBox(width: 5,),
                button2small(strings.get(455), () async {   /// "Invoice",
                  waitInMainWindow(true);
                  var ret = await bookingGetItem(item);
                  waitInMainWindow(false);
                  if (ret != null)
                    return messageError(context, ret);
                  Uint8List _file =  await importCurrentBookingToPDF(
                    strings.get(465), /// INVOICE
                    strings.get(0),
                    strings.get(86), /// Email
                    strings.get(456), /// Order ID
                    strings.get(124), /// Phone
                    strings.get(466), /// Order Date:
                    strings.get(458), /// "Bill to"
                    strings.get(459), /// Product name
                    strings.get(460), /// Qty
                    strings.get(461), /// Unit price
                    strings.get(130), /// Tax
                    strings.get(177), /// Total
                    strings.get(462), /// Sub Total
                    strings.get(463), /// Total Tax
                    strings.get(464), /// Coupon Discount
                    strings.get(464), /// Grand Total
                    strings.get(347), /// "Addons",
                  );

                  html.AnchorElement()
                    ..href = '${Uri.dataFromBytes(_file)}'
                    ..download = "invoice_${currentOrder.id}.pdf"
                    ..style.display = 'none'
                    ..click();

                  _redraw();
                }, color: theme.mainColor.withAlpha(150)),
                SizedBox(width: 5,),
                button2small(strings.get(62),  /// "Delete",
                        (){
                          _openDialogDelete(item);
                          redrawMainWindow();
                  }, color: dashboardErrorColor.withAlpha(150)),
                SizedBox(width: 5,),
              ],
            )
            ))
          ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: itemColumnWithSort(_sortBy, "orderAsc", "orderDesc", strings.get(456), _sortFilter)), /// Order ID
      DataColumn(label: itemColumnWithSort(_sortBy, "customerNameAsc", "customerNameDesc", strings.get(281), _sortFilter)), /// "Customer",
      DataColumn(label: Expanded(child: Center(child: Text(strings.get(182), style: theme.style14W600Grey)))), /// Status
      DataColumn(label: itemColumnWithSort(_sortBy, "providerNameAsc", "providerNameDesc", strings.get(178), _sortFilter)), /// "Provider",
      DataColumn(label: itemColumnWithSort(_sortBy, "countAsc", "countDesc", strings.get(457), _sortFilter)),  /// "Count products",
      DataColumn(label: itemColumnWithSort(_sortBy, "priceAsc", "priceDesc", strings.get(144), _sortFilter)), /// "Price",
      DataColumn(label: itemColumnWithSort(_sortBy, "modifyAsc", "modifyDesc", strings.get(209), _sortFilter)), /// "Create",
      DataColumn(label: Expanded(child: Center(child: Text(strings.get(66), style: theme.style14W600Grey)))), /// action
    ];

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: horizontalScroll(DataTable(
          columns: _column,
          rows: _cells,
        ), _controllerScroll))
    );

    paginationLine(list, _redraw, strings.get(88)); /// from

    list.add(SizedBox(height: 40));

    return list;
  }

  _openDialogDelete(OrderDataCache value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      var ret = await bookingDeleteV2(value);
      if (ret == null) {
        messageOk(context, strings.get(69)); // "Data deleted",
      }else
        messageError(context, ret);
      setState(() {});
    }, context);
  }

  _copy(){
    bookingCopy();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    var _text = bookingCsv(
        [strings.get(456), /// "Order ID",
          strings.get(281), /// "Customer",
          strings.get(182), /// "Status",
          strings.get(178), /// "Provider",
          strings.get(457), /// "Count products",
          strings.get(144), /// "Price",
        ]
    );

    html.AnchorElement()
      ..href = '${Uri.dataFromString(_text, mimeType: 'text/plain', encoding: utf8)}'
      ..download = "booking.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }

  _sortBy1(){
    return Row(
      children: [
        Text(strings.get(253) + ":", style: theme.style14W800,), /// "Sort by",
        SizedBox(width: 10,),
        Text(strings.get(96) + ":", style: theme.style14W400,), /// "Providers",
        if (_mainModel.provider.providersComboValue.isNotEmpty)
          Expanded(child: Container(
              child: Combo(inRow: true, text: "",
                data: _mainModel.provider.providersCombo,
                value: _mainModel.provider.providersComboValue,
                onChange: (String value){
                  _mainModel.provider.providersComboValue = value;
                  _redraw();
                },))),
      ],
    );
  }

  // _sortBy1a(){
  //   return Row(
  //     children: [
  //       Text(strings.get(159) + ":", style: theme.style14W400,), /// "Service",
  //       if (_mainModel.provider.providersComboValue.isNotEmpty)
  //         Expanded(child: Container(
  //             child: Combo(inRow: true, text: "",
  //               data: _mainModel.service.serviceData,
  //               value: _mainModel.service.serviceSelected,
  //               onChange: (String value){
  //                 _mainModel.service.serviceSelected = value;
  //                 _redraw();
  //               },))),
  //     ]
  //   );
  // }

  _sortBy2(){
    return Row(
      children: [
        Text(strings.get(179) + ":", style: theme.style14W400,), /// "User",
        if (_mainModel.provider.providersComboValue.isNotEmpty)
          Expanded(child: Container(
              child: Combo(inRow: true, text: "",
                data: _mainModel.notifyModel.userData,
                value: _mainModel.notifyModel.userSelected,
                onChange: (String value){
                  _mainModel.notifyModel.userSelected = value;
                  _redraw();
                },))),
      ],
    );
  }

  _sortBy2a() {
    return Row(
        children: [
          Text(strings.get(182) + ":", style: theme.style14W400,), /// "Status",
          if (_mainModel.statusesComboForBookingSearch.isNotEmpty)
            Expanded(child: Container(
                child: Combo(inRow: true, text: "",
                  data: _mainModel.statusesComboForBookingSearch,
                  value: _mainModel.statusesComboValueBookingSearch,
                  onChange: (String value){
                    _mainModel.statusesComboValueBookingSearch = value;
                    _redraw();
                  },))),
        ]
    );
  }

}
