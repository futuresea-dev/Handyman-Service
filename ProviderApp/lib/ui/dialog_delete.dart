import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/ui/theme.dart';

openDialogDelete(Function() callback, BuildContext context){
  EasyDialog(
      colorBackground: Colors.white,
      body: Column(
        children: [
          Text(strings.get(145)), /// "Do you want to delete this item? You will can't recover this item."
          SizedBox(height: 40,),
          Row(
            children: [
              Flexible(child: button2(strings.get(146), /// "No",
                  theme.mainColor,
                      (){
                    // print("button pressed");
                    Navigator.pop(context); // close dialog
                  })),
              SizedBox(width: 10,),
              Flexible(child: button2(strings.get(86), /// "Delete",
                  Colors.red, callback)),
            ],
          )
        ],
      )
  ).show(context);
}