import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';

import '../strings.dart';

String _addressValue = "select";

comboBoxInitAddress(MainModel _mainModel){
  var _address = getCurrentAddress();
  if (_address.id.isEmpty)
    _addressValue = "select";
  else
    _addressValue = _address.id;
}

comboBoxAddress(MainModel _mainModel){
  List<DropdownMenuItem<String>> menuItems = [];

  for (var item in userAccountData.userAddress)
    menuItems.add(DropdownMenuItem(
      child: Text(item.address, style: theme.style14W400, maxLines: 1,),
      value: item.id,
    ),);

  menuItems.add(DropdownMenuItem(
    child: Text(strings.get(120), style: theme.style14W400, maxLines: 1,), /// "Select Address"
    value: "select",
  ),);

  return Container(
      width: windowWidth,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              dropdownColor: theme.darkMode ? Colors.black : Colors.white,
              isExpanded: true,
              value: _addressValue,
              items: menuItems,
              onChanged: (value) {
                _addressValue = value as String;
                if (value == "select")
                  route("address_list");
                else {
                  setCurrentAddress(_addressValue);
                  initProviderDistances();
                  redrawMainWindow();
                }
              })
          )));
}