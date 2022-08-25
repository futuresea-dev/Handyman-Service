import 'package:flutter/material.dart';

import '../theme.dart';

body(String text, String image, List<Widget> list){
  return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: theme.mainColor.withAlpha(50),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), topRight: Radius.circular(theme.radius)),
            ),
            height: 100,
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(child: Container(
                    padding: EdgeInsets.all(15),
                    child: SelectableText(text, style: theme.style25W800))),
                Container(
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.contain
                      ),
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 120),
            child: ListView(
              children: list,
            ),
          )
        ],
      )
  )
    ;
}