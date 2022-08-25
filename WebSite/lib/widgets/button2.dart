import 'package:flutter/material.dart';
import '../theme.dart';

button2x(String text, Function _callback, {bool enable = true, TextStyle? style, Color? color}){
  Color _color = color ?? theme.mainColor;
  return UnconstrainedBox(child: Stack(
    children: <Widget>[

      Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            color: (enable) ? _color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: Center(
            child: Text(text, style: style ?? theme.style12W600White, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
          )

      ),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(theme.radius) ),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )

    ],
  ));
}

button2x2(String text, Function _callback, {bool enable = true, TextStyle? style, Color? color,
  EdgeInsetsGeometry? padding = const EdgeInsets.only(top: 30, bottom: 30, left: 60, right: 60),
}){
  Color _color = color ?? theme.mainColor;
  return UnconstrainedBox(child: Stack(
    children: <Widget>[

      Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (enable) ? _color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: Center(
            child: Text(text, style: style ?? theme.style18W400White, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
          )

      ),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(theme.radius) ),
              child: InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                onTap: (){
                  _callback();
                }, // needed
              )),
        )

    ],
  ));
}

button2ForAppBar(String text, Function _callback, {bool enable = true}){
  return Stack(
    children: <Widget>[
      Container(
        height: 42,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            color: (enable) ? theme.mainColor : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.only(topRight: Radius.circular(theme.radius), bottomRight: Radius.circular(theme.radius)),
          ),
          child: Center(child:
            Text(text, style: theme.style12W600White, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
          )

      ),

      if (enable)
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(theme.radius) ),
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

button2icon(Color color, double _radius, Function _callback){
  return Stack(
    children: <Widget>[
      Container(

          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Icon(Icons.copy, color: Colors.white,)
      ),
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
