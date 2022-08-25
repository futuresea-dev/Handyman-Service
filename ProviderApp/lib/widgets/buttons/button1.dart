import 'package:flutter/material.dart';

button1a(String text, TextStyle style, Color color, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 15, bottom: 15),
          color: (enable) ? color : Colors.grey.withOpacity(0.5),
          child: Text(text, style: style, textAlign: TextAlign.center,)
      ),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
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
