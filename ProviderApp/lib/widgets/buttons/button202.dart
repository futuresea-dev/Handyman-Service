import 'package:flutter/material.dart';

button202(String text, TextStyle style,
    String text2, TextStyle style2,
    String text3, TextStyle style3,
    int stars, Color iconStarsColor,
    Color color, String image, double width, double height,
    double radius, Function _callback){
  return Stack(
    children: <Widget>[

      Container(
        margin: EdgeInsets.all(5),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          //   boxShadow: [
              // BoxShadow(
              //   color: Colors.grey.withOpacity(0.3),
              //   spreadRadius: 3,
              //   blurRadius: 5,
              //   offset: Offset(3, 3),
              // ),
            // ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
                child: Container(
                  width: width,
                    height: height,
                    child: Image.asset(image,
                      fit: BoxFit.cover,
                    )),
              )),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(text, style: style, textAlign: TextAlign.start,),

                    Row(children: [
                      if (stars >= 1)
                        Icon(Icons.star, color: iconStarsColor, size: 16,),
                      if (stars < 1)
                        Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                      if (stars >= 2)
                        Icon(Icons.star, color: iconStarsColor, size: 16,),
                      if (stars < 2)
                        Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                      if (stars >= 3)
                        Icon(Icons.star, color: iconStarsColor, size: 16,),
                      if (stars < 3)
                        Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                      if (stars >= 4)
                        Icon(Icons.star, color: iconStarsColor, size: 16,),
                      if (stars < 4)
                        Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                      if (stars >= 5)
                        Icon(Icons.star, color: iconStarsColor, size: 16,),
                      if (stars < 5)
                        Icon(Icons.star_border, color: iconStarsColor, size: 16,),
                    ]
                    ),

                    Row(children: [
                          Expanded(child: Text(text2, style: style2, textAlign: TextAlign.start,)),
                          SizedBox(width: 10,),
                          Text(text3, style: style3,),
                        ],),
                  ],
                ),
              ),


            ],
          )
      ),

        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(radius)),
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
