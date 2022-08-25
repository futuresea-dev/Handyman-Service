import 'package:flutter/material.dart';

import '../../ui/theme.dart';

button2a(String text, TextStyle style, Color color, double _radius, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)
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

// button2small(String text, TextStyle style, Color color, double _radius, Function _callback, bool enable){
//   return Stack(
//     children: <Widget>[
//       Container(
//         //width: double.maxFinite,
//           padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
//           decoration: BoxDecoration(
//             color: (enable) ? color : Colors.grey.withOpacity(0.5),
//             borderRadius: BorderRadius.circular(_radius),
//           ),
//           child: Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)
//       ),
//       if (enable)
//         Positioned.fill(
//           child: Material(
//               color: Colors.transparent,
//               clipBehavior: Clip.hardEdge,
//               shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(_radius) ),
//               child: InkWell(
//                 splashColor: Colors.black.withOpacity(0.2),
//                 onTap: (){
//                   _callback();
//                 }, // needed
//               )),
//         )
//     ],
//   );
// }


button2s(String text, TextStyle style, Color color, double _radius, Function _callback, bool enable){
  return Stack(
    children: <Widget>[
      Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: (enable) ? color : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)
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


button2ac(String text, TextStyle style,
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
          ),
          child: Column(
            children: [
              Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2,),
              SizedBox(height: 6,),
              Text(text2, style: style2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1,),
            ],
          )
      ),
    ],
  );
}


