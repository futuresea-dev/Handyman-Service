import 'package:html_editor_enhanced/html_editor.dart';
import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme.dart';

blogWidget(HtmlEditorController _controller, double windowHeight){
  return HtmlEditor(
    controller: _controller, //required
    htmlToolbarOptions: HtmlToolbarOptions(
        toolbarType: ToolbarType.nativeGrid,
        // mediaUploadInterceptor: (file, InsertFileType type) async{
        //   print("type ${type.toString()}");
        //   print("type ${file.toString()}");
        //   return true;
        // }
      buttonColor: theme.darkMode ? Colors.white : Colors.black,
      //dropdownBackgroundColor: Colors.grey
        dropdownIconColor: Colors.grey,
        textStyle: theme.style14W400

    ),
    htmlEditorOptions: HtmlEditorOptions(
      autoAdjustHeight: false,
      hint: strings.get(356), /// "Your text here..."
      darkMode: theme.darkMode,

      //initalText: "text content initial, if any",
    ),
    otherOptions: OtherOptions(
      height: windowHeight*0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(theme.radius)),
          border:
          Border.fromBorderSide(BorderSide(color: Colors.red, width: 1)),
        )
    ),
  );
}