import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mainModel/model.dart';
import 'strings.dart';
import '../theme.dart';

class BlogsAllScreen extends StatefulWidget {
  @override
  _BlogsAllScreenState createState() => _BlogsAllScreenState();
}

class _BlogsAllScreenState extends State<BlogsAllScreen> {

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

    list.add(Container(
        child: Row(
          children: [
            Expanded(child: Text(strings.get(19), style: theme.style18W800,)), /// "Blog",
          ],
        )));
    list.add(SizedBox(height: 10,));

    double _count = 0;

    var _width = isMobile() ? windowWidth-20 : windowWidth*0.8/2-35;
    List<Widget> list2 = [];
    for (var item in blog) {
      list2.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: button202Blog(item, Colors.transparent,
            _width,
            250, //isMobile() ? _width*0.6: _width * 0.3,
            () {
              _mainModel.openBlog = item;
              _mainModel.route("blog_details");
            }),
      ));
      _count++;
    }

    list.add(Wrap(
      spacing: 10,
      runSpacing: 10,
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

    list.add(SizedBox(height: 20,));

    return list;
  }

}
