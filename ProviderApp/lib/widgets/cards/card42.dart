import 'package:flutter/material.dart';

card42(
    String text1, TextStyle text1Style,
    String text2, TextStyle text2Style,
    Widget bkgWidget,
    Widget userWidget,
    double windowWidth, Color bkgColor,
    ){
  return Container(
      width: windowWidth,
      color: bkgColor,
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
      child: Stack(
        children: [
          Container(
              alignment: Alignment.bottomRight,
              height: 70,
              child: Container(
                width: windowWidth/2,
                child: bkgWidget,)
          ),
          Row(
            children: [
              Expanded(child:
              Container(
                  padding: EdgeInsets.only(top: 25),
                child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text1, style: text1Style),
                  Text(text2, style: text2Style, overflow: TextOverflow.ellipsis,),
                ],
              ))),
              Container(
                  //width: windowWidth*0.4,
                  //padding: EdgeInsets.only(bottom: 15),
                  height: 70,
                  width: 70,
                  alignment: Alignment.bottomRight,
                  child: userWidget
              )
            ],
          ),
        ],
      )
  );
}

