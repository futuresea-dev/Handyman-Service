import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/widgets/provider_item.dart';
import 'strings.dart';
import '../theme.dart';
import 'main.dart';

class ProvidersAllScreen extends StatefulWidget {
  @override
  _ProvidersAllScreenState createState() => _ProvidersAllScreenState();
}

class _ProvidersAllScreenState extends State<ProvidersAllScreen> {

  double windowWidth = 0;
  double windowHeight = 0;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_rowKey.currentContext != null){
        _rowHeight = _rowKey.currentContext!.size!.height;
        setState(() {});
        _rowHeight = windowHeight-_rowHeight-280;
        if (_rowHeight < 0)
          _rowHeight = 0;
      }
    });
    super.initState();
  }

  final GlobalKey _rowKey = GlobalKey();
  double _rowHeight = 0;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Column(children : _getList());
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(47))); /// "Go back",
    list.add(SizedBox(height: 20,));

    list.add(Container(
        child: Row(
          children: [
            Expanded(child: Text(strings.get(2), style: theme.style18W800,)), /// "Providers",
          ],
        )));
    list.add(SizedBox(height: 10,));

    double _count = 0;

    double _width = isMobile() ? windowWidth*0.8-30: windowWidth*0.8/5-30;
    if (isTable())
      _width = windowWidth*0.8/3-35;
    List<Widget> list2 = [];
    for (var item in providers) {
      list2.add(ProviderItem(width: _width, item: item));
      _count++;
    }

    list.add(Wrap(
      children: list2,
    ));

    if (_count == 0) {
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

    return list;
  }

}
