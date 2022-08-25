import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import 'strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class NotifyScreen extends StatefulWidget {
  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadMessages();
    });
    super.initState();
  }

  _loadMessages() async {
    _mainModel.waits(true);
    var ret = await loadMessages();
    if (ret != null)
      messageError(context, ret);
    _mainModel.waits(false);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(top : 30),
        alignment: Alignment.center,
        child: Container(
        margin: EdgeInsets.only(left : 30, right: 30),
        width: isMobile() ? windowWidth*0.9 : windowWidth*0.4+60,
        child: Column(children: _getList()),
    ));
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(127), style: theme.style18W800,),);  /// "Notifications",
    list.add(SizedBox(height: 20,));

    var _count = 0;

    // User? user = FirebaseAuth.instance.currentUser;
    // List<Widget> list3 = [];
    // for (var item in _mainModel.service) {
    //   if (!_mainModel.userFavorites.contains(item.id))
    //     continue;
    //   list3.add(serviceItem(windowWidth*0.4-40, _mainModel, item, user));
    //   _count++;
    // }
    // list.add(Wrap(
    //       spacing: 10,
    //       runSpacing: 10,
    //       children: list3,
    //     ));

    list.add(SizedBox(height: 20,));

    //
    //
    //
    var _now = DateFormat('dd MMMM').format(DateTime.now());

    for (var item in messages){
      // if (_searchText.isNotEmpty)
      //   if (!item.title.toUpperCase().contains(_searchText.toUpperCase()))
      //     if (!item.body.toUpperCase().contains(_searchText.toUpperCase()))
      //       continue;
      var time = DateFormat('dd MMMM').format(item.time);
      if (time == _now)
        time = strings.get(145); /// Today
      list.add(Card48(
        text: item.body,
        text2: appSettings.getDateTimeString(item.time),
        text3: item.title,
        shadow: false,
        callback: () async {
          await deleteMessage(item);
          setState(() {
          });
        },
      ),);
      list.add(SizedBox(height: 20,));
      _count++;
    }
    list.add(SizedBox(height: 20,));


    if (_count == 0){
      list.add(SizedBox(height: 30,));
      list.add(Container(
          width: 200,
          height: 200,
          child: Image.asset("assets/nofound.png", fit: BoxFit.contain)
      ));
      list.add(SizedBox(height: 50,));
      list.add(Center(child: Text(strings.get(129), /// "Notifications not found",
          style: theme.style14W800)));
    }

    return list;
  }
}
