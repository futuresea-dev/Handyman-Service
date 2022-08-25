import 'package:flutter/material.dart';

button200(String text, TextStyle style, Color color, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
          ),
          child: Text(text, style: style, textAlign: TextAlign.center,)
      ),
      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))),
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
