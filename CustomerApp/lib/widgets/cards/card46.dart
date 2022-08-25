import 'package:flutter/material.dart';

card46(
    String text1, TextStyle text1Style,
    String text2, TextStyle text2Style,
    Widget bkgWidget,
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
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.bottomRight,
            height: 130,
            child: Container(
              width: windowWidth/2,
              child: bkgWidget,)
          ),
          Container(
            height: 150,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(text1, style: text1Style),
                    SizedBox(width: 5,),
                    Container(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Icon(Icons.star, color: Colors.orange, size: 25,),
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Text(text2, style: text2Style),
              ],
            )
          )
        ],
      )
  ));
}

