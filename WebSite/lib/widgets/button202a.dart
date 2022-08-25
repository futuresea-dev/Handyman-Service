import 'package:flutter/material.dart';

import '../theme.dart';

button202a(String text,
    String image, double width,
    Function _callback){
  return Container(
        margin: EdgeInsets.all(10),
          width: width,
          decoration: BoxDecoration(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: InkWell(
              onTap: (){
                _callback();
              },
              child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), topRight: Radius.circular(theme.radius)),
                child: Container(
                  width: width,
                    child: image.isNotEmpty ? Image.network(image, fit: BoxFit.cover,) : Container(),

                ),
              )),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                child: Text(text, style: theme.style13W800, textAlign: TextAlign.start,),
              ),

            ],
          )

  ));
}
