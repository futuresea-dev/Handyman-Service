import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'strings.dart';
import '../theme.dart';

String _addressValue = "select";

comboBoxInitAddress(MainModel _mainModel){
  var _address = getCurrentAddress();
  if (_address.id.isEmpty)
    _addressValue = "select";
  else
    _addressValue = _address.id;
}

comboBoxAddress(MainModel _mainModel, double windowWidth){
  List<DropdownMenuItem<String>> menuItems = [];

  for (var item in userAccountData.userAddress) {
    // print("comboBoxAddress ${item.id} ${item.address}");
    menuItems.add(DropdownMenuItem(
      child: Text(item.address, style: theme.style14W400, maxLines: 1,),
      value: item.id,
    ),);
  }
  // print("comboBoxAddress _addressValue=$_addressValue");

  menuItems.add(DropdownMenuItem(
    child: Text(strings.get(58), style: theme.style14W400, maxLines: 1,), /// "Select Address"
    value: "select",
  ),);

  return Container(
      height: 40,
      width: windowWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(color: Colors.grey.withAlpha(50)),
      ),
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
                if (value == "select") {
                  _mainModel.route("address_list");
                }
                _mainModel.redraw();
                setCurrentAddress(_addressValue);
                initProviderDistances();
              })
          )));
}