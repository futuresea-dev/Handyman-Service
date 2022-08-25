import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import '../theme.dart';
import 'strings.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    if (_scrollPosition > _scrollController.position.maxScrollExtent/3){
      articleSortGetNextPage(true);
      _redraw();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
        width: windowWidth,
        height: windowHeight,
        child: _body(),
      );
  }

  _body(){
    List<Widget> list = [];
    List<Widget> list2 = [];

    // list.add(Container(
    //   margin: EdgeInsets.only(left: 20, right: 20),
    //   child: Row(
    //     children: [
    //       Expanded(child: Edit26(
    //         hint: strings.get(209), /// "Search products",
    //         color: (theme.darkMode) ? Colors.black : Colors.white,
    //         style: theme.style14W400,
    //         // decor: decor,
    //         useAlpha: false,
    //         icon: Icons.search,
    //         controller: _controllerSearch,
    //         onChangeText: (String val){
    //           articleSearchText = val;
    //           articleSort();
    //           _redraw();
    //         },
    //       ),
    //       ),
    //       SizedBox(width: 5,),
    //       IconButton(onPressed: (){
    //         _mainModel.openDialog("filter");
    //       }, icon: Icon(Icons.filter_alt_outlined))
    //     ],
    //   )),
    // );

    list.add(SizedBox(height: 10,));
    //filterParameters(3, list, _redraw, _mainModel);
    // if (articleSortByProvider != "not_select")
    //   list.add(Row(
    //     children: [
    //       Text(strings.get(280), style: theme.style12W600Red,), /// Sort by provider
    //       SizedBox(width: 6,),
    //       Expanded(child: Text(getProviderNameById(articleSortByProvider, locale), style: theme.style14W800,)),
    //       SizedBox(width: 6,),
    //       IconButton(onPressed: (){
    //         articleSortByProvider = "not_select";
    //         articleSort();
    //         _redraw();
    //       }, icon: Icon(Icons.cancel, color: Colors.red,))
    //     ],
    //   ));
    list.add(SizedBox(height: 10,));

    var _count = 0;
    for (var item in productDataCacheSort) {

      list2.add(button202n2(item, 200, strings.locale, strings.get(262), /// Not available Now
              () async {
            waitInMainWindow(true);
            var ret = await articleGetItemToEdit(item);
            waitInMainWindow(false);
            if (ret != null)
              return messageError(context, ret);
            _mainModel.route("article");
          })
      );
      _count++;
    }

    list.add(Container(
        margin: EdgeInsets.all(10),
        child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children: list2)
    ));

    if (_count == 0){
      list.add(Center(child:
      Container(
        width: 400,
        height: 400,
        child: Image.asset("assets/nofound.png", fit: BoxFit.contain)
      ),
      ));
      list.add(SizedBox(height: 10,));
      list.add(Center(child: Text(strings.get(143), style: theme.style18W800Grey,),)); /// "Not found ...",
    }

    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }
}
