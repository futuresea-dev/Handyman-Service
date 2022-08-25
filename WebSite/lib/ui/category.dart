import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/service_item.dart';
import 'package:provider/provider.dart';
import '../mainModel/model.dart';
import 'strings.dart';
import '../theme.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Column(children: _getList());
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    list.add(Row(
          children: [
            Expanded(child: Text(strings.get(20), style: theme.style18W800,)), /// "Category",
            SizedBox(width: 10,),
            button157(
                  getTextByLocale(_mainModel.currentCategory.name, strings.locale),
                  _mainModel.currentCategory.color,
                  _mainModel.currentCategory.serverPath, () {
              }, isMobile() ? windowWidth * 0.5 : windowWidth * 0.8 /5-10,
                isMobile() ? windowWidth * 0.5 * 0.5 : windowWidth * 0.8 /5 * 0.25 ),
          ],
        ));
    list.add(SizedBox(height: 30,));

    User? user = FirebaseAuth.instance.currentUser;

    //
    // subcategory
    //
    if (ifCategoryHaveSubcategories(_mainModel.currentCategory.id)){
      list.add(Container(
          padding: EdgeInsets.all(10),
          child: Text(strings.get(183), style: theme.style14W800) /// "Subcategory",
      ));
      List<Widget> list2 = [];
      for (var item in categories) {
        if (item.parent != _mainModel.currentCategory.id)
          continue;
        list2.add(button157(
            getTextByLocale(item.name, strings.locale),
            item.color,
            item.serverPath, () {
          _mainModel.currentCategory = item;
          _mainModel.route("category");
        },
            isMobile() ? windowWidth* 0.8/2-10 : windowWidth * 0.8 /5-10,
            isMobile() ? windowWidth* 0.8/2*0.5 : windowWidth * 0.8 /5 * 0.5,
            direction: strings.direction),
        );
      }
      list.add(Container(
        width: windowWidth,
          margin: EdgeInsets.all(10),
          child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: list2)
      ));
      list.add(SizedBox(height: 30,));
    }

    //
    //
    //

    List<Widget> list3 = [];
    for (var item in product){
      if (!item.category.contains(_mainModel.currentCategory.id))
        continue;
      var _width = isMobile() ? windowWidth*0.8 : windowWidth*0.4-40;
      list3.add(serviceItem(_width, -1, _mainModel, item, user));
    }

    list.add(Wrap(
      spacing: 10,
      runSpacing: 10,
      children: list3,
    ));

    list.add(SizedBox(height: 100,));

    return list;
  }

}
