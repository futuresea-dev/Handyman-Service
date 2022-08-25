import 'package:flutter/material.dart';

import '../theme.dart';

class Card44 extends StatelessWidget {
  final String image;
  final String name;
  final String date;
  final Color bkgColor;
  final Color iconColor;
  final double radius;

  const Card44({Key? key, required this.image, required this.name, required this.date,
    this.bkgColor = Colors.white, this.radius = 10,
    this.iconColor = Colors.green, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (bkgColor != Colors.transparent)
        Container(
          height: 80,
            margin: EdgeInsets.only(left: 10, right: 10,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [bkgColor.withAlpha(100), bkgColor],
              ),
            )),

        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(Icons.verified, color: iconColor,),
                  SizedBox(height: 10),
                  _dot(),
                  SizedBox(height: 10),
                  _dot(),
                  SizedBox(height: 10),
                  _dot(),
                  SizedBox(height: 10),
                  _dot(),
                ],
              ),
              SizedBox(width: 20,),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: theme.style14W800,),
                      SizedBox(height: 5,),
                      Text(date, style: theme.style14W800,),
                      SizedBox(height: 15,),
                    ],)),
              SizedBox(width: 20,),
              Container(
                height: 100,
                width: 100,
                child: Image.network(image, fit: BoxFit.cover,),
              ),
              SizedBox(width: 20,),
            ],
          ),

        )
      ],
    );
  }

  _dot(){
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
