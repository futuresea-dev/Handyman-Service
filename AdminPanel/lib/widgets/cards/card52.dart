import 'package:flutter/material.dart';

class Card52 extends StatelessWidget {
  final String image;
  final String text1;
  final TextStyle style1;
  final String text2;
  final TextStyle style2;
  final bool shadow;
  final Color bkgColor;
  final double radius;
  final double imageRadius;
  final double padding;
  final String text3;
  final String text4;

  const Card52(
      {Key? key, required this.image, required this.text1, required this.style1, required this.text2, required this.style2,
        this.shadow = false, this.bkgColor = Colors
          .white, this.radius = 10, this.imageRadius = 50,
        this.padding = 5, this.text3 = "", this.text4 = "",}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
      decoration: BoxDecoration(
        color: bkgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: (shadow) ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Container(
            height: 50,
            width: 50,
            //padding: EdgeInsets.only(left: 10, right: 10),
            child: (image.isEmpty) ? CircleAvatar(backgroundImage: AssetImage("assets/avatar.png"), radius: 50,) :
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                    image,
                    height: 40,
                    fit: BoxFit.cover))),

          SizedBox(width: 20,),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text1, style: style1,),
                  SizedBox(height: 5,),
                  Text(text2, style: style2,),
                  SizedBox(height: 5,),
                ],)),


          if (text3.isNotEmpty)
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(text3, style: TextStyle(color: Colors.white, fontSize: 12)),
                )),
          SizedBox(width: 5,),
          if (text4.isNotEmpty)
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(text4, style: TextStyle(color: Colors.white, fontSize: 12)),
                )),
          SizedBox(width: 5,),
        ],
      ),

    );
  }
}
