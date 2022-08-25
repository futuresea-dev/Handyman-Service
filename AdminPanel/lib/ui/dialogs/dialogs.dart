import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/dialogs/variants_in_group.dart';
import 'package:ondemand_admin/ui/dialogs/group_variants.dart';
import 'package:ondemand_admin/ui/dialogs/view_privider_request_info.dart';

import 'add_image_url.dart';
import 'add_variants.dart';
import 'edit_order.dart';

bool _dialogAddVariants = false;
bool _dialogViewProviderRequestInfo = false;
bool _dialogAddImageUrl = false;
bool _dialogShowDialogVariantsGroup = false;
bool _dialogShowDialogVariants = false;
bool _dialogEditOrder = false;

showDialogEditOrder(){
  _dialogEditOrder = true;
  redrawMainWindow();
}

showDialogAddVImageUrl(){
  _dialogAddImageUrl = true;
  redrawMainWindow();
}

showDialogAddVariants(){
  _dialogAddVariants = true;
  redrawMainWindow();
}

showDialogViewProviderRequestInfo(){
  _dialogViewProviderRequestInfo = true;
  redrawMainWindow();
}

showDialogVariantsGroup(){
  _dialogShowDialogVariantsGroup = true;
  redrawMainWindow();
}

showDialogVariants(){
  _dialogShowDialogVariants = true;
  redrawMainWindow();
}

List<Widget> getDialogs(Function() openProvidersScreen){
  List<Widget> list = [];
  if (_dialogEditOrder)
    list.add(DialogEditOrder(close: (){
      _dialogEditOrder = false;
      redrawMainWindow();
    }));
  if (_dialogShowDialogVariants)
    list.add(DialogVariants(close: (){
      _dialogShowDialogVariants = false;
      redrawMainWindow();
    }));
  if (_dialogShowDialogVariantsGroup)
    list.add(DialogVariantsGroup(close: (){
      _dialogShowDialogVariantsGroup = false;
      redrawMainWindow();
    }));
  if (_dialogAddImageUrl)
    list.add(DialogAddImageUrl(close: (){
      _dialogAddImageUrl = false;
      redrawMainWindow();
    }));
  if (_dialogAddVariants)
    list.add(DialogAddVariants(close: (){
    _dialogAddVariants = false;
    redrawMainWindow();
    }));
  if (_dialogViewProviderRequestInfo)
    list.add(DialogViewProviderRequestInfo(close: (){
    _dialogViewProviderRequestInfo = false;
    redrawMainWindow();
    }, openProvidersScreen: openProvidersScreen));
  return list;
}