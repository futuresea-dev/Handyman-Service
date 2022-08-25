import 'package:flutter/material.dart';

import '../theme.dart';

class Edit37 extends StatefulWidget {
  final String hint;
  final Function(String)? onChangeText;
  final Function()? onTap;
  final TextEditingController controller;
  final TextInputType type;
  final Color iconColor;
  final IconData? icon;
  final int maxLines;

  Edit37({this.hint = "", required this.controller, this.type = TextInputType.text,
    this.onChangeText, this.icon, this.iconColor = Colors.black, this.onTap,
    this.maxLines = 1
  });

  @override
  _Edit37State createState() => _Edit37State();
}

class _Edit37State extends State<Edit37> {

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = widget.iconColor;

    return Container(
        height: widget.maxLines == 1 ? 40 : 150,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          border: Border.all(color: Colors.grey.withAlpha(100),),
          borderRadius: BorderRadius.circular(theme.radius),
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
        maxLines: widget.maxLines,
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
        style: theme.style14W400,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: widget.icon != null ? Icon(
            widget.icon,
            color: _colorDefaultText,
          ) : null,
          hintText: widget.hint,
          hintStyle: theme.style12W600Grey
        )
      ),
    );
  }
}