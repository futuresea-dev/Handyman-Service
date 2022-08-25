import 'package:flutter/material.dart';

class Edit37 extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final Function()? onTap;
  final TextEditingController controller;
  final TextInputType type;
  final Color bkgColor;
  final Color iconColor;
  final Color borderColor;
  final IconData icon;
  final double radius;
  Edit37({this.hint = "", required this.controller, this.type = TextInputType.text, this.bkgColor = Colors.black, this.radius = 0,
    this.onChangeText, required this.icon, this.borderColor = Colors.transparent, this.iconColor = Colors.black, this.onTap});

  @override
  _Edit37State createState() => _Edit37State();
}

class _Edit37State extends State<Edit37> {

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = widget.iconColor;

    return Container(
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: widget.bkgColor,
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(widget.radius),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.3),
          //     spreadRadius: 3,
          //     blurRadius: 5,
          //     offset: Offset(3, 3),
          //   ),
          // ],
        ),
      child: TextFormField(
        obscureText: false,
        cursorColor: _colorDefaultText,
        keyboardType: widget.type,
        controller: widget.controller,
        onTap: (){
          if (widget.onTap != null)
            widget.onTap!();
        },
        onChanged: (String value) async {
          if (widget.onChangeText != null)
            widget.onChangeText!(value);
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: _colorDefaultText,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.icon,
            color: _colorDefaultText,
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    );
  }
}