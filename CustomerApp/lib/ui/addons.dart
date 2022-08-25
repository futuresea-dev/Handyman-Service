import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'strings.dart';

listAddons(List<Widget> list, double windowWidth, Function() _redraw, MainModel _mainModel, bool onlySelected){
  List<Widget> list2 = [];
  for (var item in _mainModel.currentService.addon){
    if (onlySelected)
      if (!item.selected)
        continue;
    list2.add(Container(
        width: windowWidth*0.2,
        child: Column(
          children: [
            button2addon(getTextByLocale(item.name, strings.locale), item.selected ? theme.style11W800W : theme.style11W600,
                getPriceString(item.price), item.selected ? theme.style11W800W : theme.style11W600,
                //
                item.selected ? theme.mainColor : Colors.grey.withAlpha(20), 10,
                    (){
                  item.selected = !item.selected;
                  _redraw();
                }, true),
            SizedBox(height: 5,),
            if (item.selected)
              plusMinus2(_redraw, item),
          ],
        )));
  }
  if (_mainModel.currentService.addon.isNotEmpty) {
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
        child: Text(strings.get(221),/// "Addons",
        style: theme.style12W800)));
    list.add(SizedBox(height: 10,));

    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: list2
    )));

    list.add(SizedBox(height: 20,));
  }
}


button2addon(String text, TextStyle style,
    String text2, TextStyle style2,
    Color color, double _radius, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: Colors.grey.withAlpha(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1),
              ),
            ],
          )
          // BoxDecoration(
          //   color: (enable) ? color : Colors.grey.withOpacity(0.5),
          //   borderRadius: BorderRadius.circular(_radius),
          // )
          ,
          child: Column(
            children: [
              Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
              SizedBox(height: 6,),
              Text(text2, style: style2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1,),
            ],
          )
      ),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(_radius) ),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )
    ],
  );
}


plusMinus2(Function() _redraw, AddonData item, {bool countMayBeNull = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: item.needCount > 1 ? theme.mainColor : Colors.grey,
          shape: BoxShape.circle,
        ),
        child: InkWell(
            onTap: () {
              if (item.needCount > 1){
                item.needCount--;
                _redraw();
              }
              if (countMayBeNull && item.needCount == 1){
                item.needCount--;
                _redraw();
              }
            },
            child: Icon(Icons.exposure_minus_1, size: 15, color: Colors.white,)),
      ),
      SizedBox(width: 5,),
      Text(item.needCount.toString(), style: theme.style14W800),
      SizedBox(width: 5,),
      Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: theme.mainColor,
          shape: BoxShape.circle,
        ),
        child: InkWell(
            onTap: () {
              item.needCount++;
              _redraw();
            },
            child: Icon(Icons.plus_one, size: 15, color: Colors.white,)),
      ),
    ],
  );
}


