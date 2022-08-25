import 'package:flutter/material.dart';

edit32(TextEditingController _controller, String _hint, Color color){
  bool _obscure = false;
  return
      Container(
        height: 40,
        child: TextField(
          controller: _controller,
          onChanged: (String value) async {
          },
          cursorColor: Colors.black,
          style: TextStyle(fontSize: 14),
          cursorWidth: 1,
          obscureText: _obscure,
          textAlign: TextAlign.left,
          maxLines: 1,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: color),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: color),
              ),
              hintText: _hint,
              hintStyle: TextStyle(fontSize: 14, color: color),
          ),
        ),
  );
}