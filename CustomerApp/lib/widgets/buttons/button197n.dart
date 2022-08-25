import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/ui/theme.dart';

import '../../ui/strings.dart';

class Button197N extends StatelessWidget {
  final Function()? pressButtonDelete;
  final Function()? pressButton;
  final Function()? pressSetCurrent;
  final AddressData item;
  final bool onlyBorder;
  final bool upIcon;
  Button197N({this.pressButtonDelete, this.pressSetCurrent,
    this.onlyBorder = false, this.upIcon = true, this.pressButton, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : theme.darkMode ? Colors.black : Colors.white,
          border: (onlyBorder) ? Border.all(color: theme.darkMode ? Colors.black : Colors.white) : null,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Stack(children: [

          InkWell(
            onTap: pressButton,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Icon(item.type == 1 ? Icons.home : item.type == 2 ? Icons.account_balance : Icons.devices_other, color: theme.mainColor,),
                    SizedBox(width: 15,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(item.type == 1 ? strings.get(190) : item.type == 2 ? strings.get(191) : strings.get(192), /// home - office - other
                          style: theme.style14W800, textAlign: TextAlign.left,),
                        SizedBox(height: 5,),
                        Text(item.address, style: theme.style12W600Grey, textAlign: TextAlign.left,),
                      ],
                    )),

                      Column(
                        children: [
                          if (upIcon)
                          InkWell(
                            onTap: (){
                              if (pressSetCurrent != null)
                                pressSetCurrent!();
                            },
                            child: Icon(Icons.arrow_upward, color: Colors.green,),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              if (pressButtonDelete != null)
                                pressButtonDelete!();
                            },
                            child: Icon(Icons.delete, color: Colors.red,),
                          ),
                        ],
                      ),
                    SizedBox(width: 10,)
                ],
              ),
              SizedBox(height: 10,),
            ],
          )),
        ],)
    );
  }
}