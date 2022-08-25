import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/strings.dart';
import 'edit_service.dart';
import '../theme.dart';

class ServicesAllScreen extends StatefulWidget {
  @override
  _ServicesAllScreenState createState() => _ServicesAllScreenState();
}

class _ServicesAllScreenState extends State<ServicesAllScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerSearch = TextEditingController();
  String _searchText = "";

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      body: Directionality(
      textDirection: strings.direction,
    child: Stack(
      children: [

        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40),
          child: _body(),
        ),

        appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
            strings.get(142), context, () {  /// "My Services",
          goBack();
        }),

        IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
          getBody: _getDialogBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),

      ]),
    ));
  }

  ProductData? _itemToDelete;
  String _dialogName = "";

  Widget _getDialogBody(){
    if (_dialogName == "too_many_services")
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          Icon(Icons.info_outline, color: Colors.red, size: 50,),
          SizedBox(height: 20,),
          Text(strings.get(262), /// "You have exceeded the limit on the number of services. Contact support for more information."
              textAlign: TextAlign.center, style: theme.style14W800),
          SizedBox(height: 40,),
          button2c(strings.get(261), /// "Cancel",
              theme.mainColor, (){
                _show = 0;
                _redraw();
              }),
          SizedBox(height: 20,),
        ],
      );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(strings.get(145), /// "Do you want to delete this item? You will can't recover this item.",
            textAlign: TextAlign.center, style: theme.style14W800),
        SizedBox(height: 40,),
        Row(children: [
          Expanded(child: button2(strings.get(146), /// "No",
              theme.mainColor, (){
                _show = 0;
                _redraw();
              })),
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(86), /// "Delete",
                Colors.red, () async {
              _show = 0;
              _redraw();
              if (_itemToDelete != null) {
                var ret = await deleteProduct(_itemToDelete!);
                if (ret != null)
                  messageError(context, ret);
                _redraw();
              }
            },))
        ],),
      ],
    );
  }

  double _show = 0;

  _body(){
    List<Widget> list = [];

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Edit26(
        hint: strings.get(144), /// "Search service",
        color: (theme.darkMode) ? Colors.black : Colors.white,
        style: theme.style14W400,
        decor: decor,
        useAlpha: false,
        icon: Icons.search,
        controller: _controllerSearch,
        onChangeText: (String val){
          _searchText = val;
          _redraw();
        },
      ),),
    );

    list.add(SizedBox(height: 10,));
    list.add(Container(
      margin: EdgeInsets.all(10),
        child: button2(strings.get(178), theme.mainColor, (){ /// "Create new service"
          if (currentProvider.useMaximumServices
              && currentProvider.maxServices <= product.length){
            _dialogName = "too_many_services";
            _show = 1;
            _redraw();
            return;
          }
      currentProduct = ProductData.createEmpty();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditServiceScreen(),
        ),
      );
    })));
    list.add(Divider());
    list.add(SizedBox(height: 10,));

    for (var item in product) {
      if (_searchText.isNotEmpty)
        if (!getTextByLocale(item.name, strings.locale).toUpperCase().contains(_searchText.toUpperCase()))
          continue;

      list.add(InkWell(onTap: (){_openDetails(item);},
        child: Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Card50(item: item,
            providerData: currentProvider,
            locale: strings.locale,
            direction: strings.direction,
            category: categories,
          ),
      )));

      list.add(SizedBox(height: 5,),);
      list.add(Row(
        children: [
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(133), theme.mainColor, (){ /// "Edit"
            currentProduct = item;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditServiceScreen(),
              ),
            );
          })),
          SizedBox(width: 10,),
          Expanded(child: button2(strings.get(86), Colors.red, (){ /// "Delete"
            _show = 1;
            _dialogName = "";
            _itemToDelete = item;
            _redraw();
          })),
          SizedBox(width: 10,),
        ],
      ));

      list.add(SizedBox(height: 20,));
    }

    list.add(SizedBox(height: 150,));
    return ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
    );
  }

  _openDetails(ProductData item) async {
    // localSettings.callbackStack1 = "category";
    // _mainModel.currentService = item;
  //  localSettings.serviceScreenTag = _tag;
    // _mainModel.route("service");
  }
}
