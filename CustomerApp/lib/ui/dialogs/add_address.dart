import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';
import '../strings.dart';

int _type = 1;

getBodyAddressDialog(Function() _close, MainModel _mainModel, TextEditingController _editControllerAddress,
    TextEditingController _editControllerName, TextEditingController _editControllerPhone, BuildContext context){

    _mainModel.account.initAddressEdit(_editControllerAddress, _editControllerName, _editControllerPhone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Center(child: Text(strings.get(198), /// "Add the location",
            textAlign: TextAlign.center, style: theme.style14W800)),
        SizedBox(height: 10,),
        Text(strings.get(199), /// "Label as",
            textAlign: TextAlign.start, style: theme.style12W400),
        SizedBox(height: 10,),
        Row(
          children: [
            Expanded(child: button2b(strings.get(190), /// "Home",
                    (){
                  _type = 1;
                  redrawMainWindow();
                },
              style: _type == 1 ? theme.style12W800W : theme.style12W800,
              color: _type == 1 ? theme.mainColor : Colors.grey.withAlpha(80),
            )),
            SizedBox(width: 10,),
            Expanded(child: button2b(strings.get(191), /// "Office",
                    (){
                  _type = 2;
                  redrawMainWindow();
                },
              style: _type == 2 ? theme.style12W800W : theme.style12W800,
              color: _type == 2 ? theme.mainColor : Colors.grey.withAlpha(80),
            )),
            SizedBox(width: 10,),
            Expanded(child: button2b(strings.get(192), /// "Other",
                    (){
                  _type = 3;
                  redrawMainWindow();
                },
              style: _type == 3 ? theme.style12W800W : theme.style12W800,
              color: _type == 3 ? theme.mainColor : Colors.grey.withAlpha(80),
            )),
          ],
        ),
        SizedBox(height: 10,),
        SizedBox(height: 5,),
        edit42(strings.get(200), /// "Delivery Address",
            _editControllerAddress,
            strings.get(201), /// "Enter Delivery Address",
            ),
        SizedBox(height: 5,),
        Text("${strings.get(207)} ${_mainModel.account.latitude} - " /// "Latitude",
            "${strings.get(208)} ${_mainModel.account.longitude}", style: theme.style10W400,), /// "Longitude",
        SizedBox(height: 15,),
        edit42(strings.get(202), /// "Contact name",
            _editControllerName,
            strings.get(203), /// "Enter Contact name",
            ),
        SizedBox(height: 15,),
        edit42(strings.get(204), /// "Contact phone number",
            _editControllerPhone,
            strings.get(205), /// "Enter Contact phone number",
            ),
        SizedBox(height: 25,),
        Row(
          children: [
            Expanded(child: button2(strings.get(206), /// "Save location",
                theme.mainColor, () async {
                  var ret = await _mainModel.account.saveLocation(_type, _editControllerAddress.text, _editControllerName.text,
                      _editControllerPhone.text);
                  if (ret != null)
                    return messageError(context, ret);
                  _close();
                  goBack();
                  if (currentScreen() == "address_add")
                    goBack();
            }))
          ],
        ),
      ],
    );

}