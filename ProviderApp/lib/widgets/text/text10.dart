import 'package:flutter/material.dart';

class Text10 extends StatefulWidget {
  final Color color;
  final Color borderColor;

  final String text;
  final TextStyle? style;
  final TextAlign? align;

  final String text2;
  final TextStyle? style2;
  final TextAlign? align2;

  final String text3;
  final TextStyle? style3;
  final TextAlign? align3;

  final String text4;
  final TextStyle? style4;
  final TextAlign? align4;

  final bool shadow;
  final double radius;
  final EdgeInsetsGeometry? padding;

  Text10({this.color = Colors.white, this.borderColor = Colors.white,
    this.text = "", this.text2 = "", this.text3 = "", this.text4 = "",
    this.shadow = true, this.style, this.style2, this.style3, this.style4,
    this.align, this.align2, this.align3, this.align4, this.radius = 0.0, this.padding,
  });

  @override
  _Text10State createState() => _Text10State();
}

class _Text10State extends State<Text10>{

  @override
  Widget build(BuildContext context) {

    return InkWell(
        child: Container(
          padding: (widget.padding == null) ? EdgeInsets.all(10) : widget.padding,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.borderColor),
             boxShadow: (widget.shadow) ? [
               BoxShadow(
                 color: Colors.grey.withAlpha(50),
                 spreadRadius: 2,
                 blurRadius: 2,
                 offset: Offset(2, 2), // changes position of shadow
               ),
             ] : null
          ),

          child: Column(
              children: [

                  Row(
                    children: <Widget>[
                      Expanded(child: Text(widget.text, style: widget.style, overflow: TextOverflow.ellipsis, textAlign: widget.align,)),
                      Expanded(child: Text(widget.text2, style: widget.style2, overflow: TextOverflow.ellipsis, textAlign: widget.align2,)),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Expanded(child: Text(widget.text3, style: widget.style3, overflow: TextOverflow.ellipsis, textAlign: widget.align3,)),
                      Expanded(child: Text(widget.text4, style: widget.style4, overflow: TextOverflow.ellipsis, textAlign: widget.align4,)),
                    ],
                  ),

              ],),

          ),
        );
  }

}