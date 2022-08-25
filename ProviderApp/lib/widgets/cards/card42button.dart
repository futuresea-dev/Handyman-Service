import 'package:flutter/material.dart';

card42button(
    String text1, TextStyle text1Style,
    String text2, TextStyle text2Style,
    Widget bkgWidget,
    Widget userWidget,
    double windowWidth, Color bkgColor,
    Function() onClickText2
    ){
  return InkWell(
      onTap: onClickText2,
      child: Container(
      width: windowWidth,
      color: bkgColor,
      padding: EdgeInsets.only(left: 20, top: 0, bottom: 10, right: 20),
      child: Stack(
        children: [
          Container(
              alignment: Alignment.bottomRight,
              height: 130,
              child: Container(
                width: windowWidth/2,
                child: bkgWidget,)
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text1, style: text1Style),
                    Text(text2, style: text2Style),
                  ],
                )),
                Container(
                    width: windowWidth*0.4,
                    padding: EdgeInsets.only(bottom: 10),
                    height: 100,
                    alignment: Alignment.bottomRight,
                    child: userWidget
                )
              ],
            ),
          )
        ],
      )
  ));
}

