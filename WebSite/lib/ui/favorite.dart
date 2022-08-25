import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/service_item.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import 'strings.dart';
import '../../theme.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

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

    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(126), style: theme.style18W800,),);  /// "Favorites",
    list.add(SizedBox(height: 20,));

    var _count = 0;

    User? user = FirebaseAuth.instance.currentUser;
    List<Widget> list3 = [];
    for (var item in product) {
      if (!userAccountData.userFavorites.contains(item.id))
        continue;
      var _width = isMobile() ? windowWidth-40 : windowWidth*0.4-40;
      list3.add(serviceItem(_width, -1, _mainModel, item, user));
      _count++;
    }
    list.add(Wrap(
          spacing: 10,
          runSpacing: 10,
          children: list3,
        ));
    list.add(SizedBox(height: 20,));


    if (_count == 0){
      list.add(SizedBox(height: 30,));
      list.add(Container(
          width: 200,
          height: 200,
          child: Image.asset("assets/nofound.png", fit: BoxFit.contain)
      ));
      list.add(SizedBox(height: 50,));
      list.add(Center(child: Text(strings.get(140), /// "Favorites not found",
          style: theme.style14W800)));
    }

    return list;
  }
}
