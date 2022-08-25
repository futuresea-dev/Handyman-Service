import 'package:flutter/material.dart';

class Edit38 extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color bkgColor;
  final Color iconColor;
  final Color borderColor;

  final double radius;
  Edit38({this.hint = "", required this.controller, this.type = TextInputType.text, this.iconColor = Colors.black, this.radius = 0,
    this.onChangeText, this.bkgColor = Colors.white, this.borderColor = Colors.transparent});

  @override
  _Edit38State createState() => _Edit38State();
}

class _Edit38State extends State<Edit38> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = widget.iconColor;

    var _icon = Icons.visibility_off;
    if (!_obscureText)
      _icon = Icons.visibility;

    var _sicon2 = IconButton(
      iconSize: 20,
      icon: Icon(
        _icon, //_icon,
        color: _colorDefaultText,
      ),
      onPressed: () {
        _obscureText = !_obscureText;
        setState(() {
        });
      },
    );

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
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 3,
          //     blurRadius: 5,
          //     offset: Offset(3, 3),
          //   ),
          // ],
        ),
      child: TextFormField(
        obscureText: _obscureText,
        cursorColor: _colorDefaultText,
        keyboardType: widget.type,
        controller: widget.controller,
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
          prefixIcon: _sicon2,
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    );
  }
}