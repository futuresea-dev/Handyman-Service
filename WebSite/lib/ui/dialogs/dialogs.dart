import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';

import 'dialog_coupons_list.dart';
import 'enter_code.dart';

bool _dialogCouponsList = false;
bool _dialogEnterCode = false;

showDialogCouponsList(){
  _dialogEnterCode = false;
  //
  _dialogCouponsList = true;
  redrawMainWindow();
}

showDialogEnterCode(){
  _dialogCouponsList = false;
  //
  _dialogEnterCode = true;
  redrawMainWindow();
}

Widget getWebDialogBodys(){
  if (_dialogCouponsList)
    return DialogCouponsList(close: (){
      _dialogCouponsList = false;
      redrawMainWindow();
    });
  if (_dialogEnterCode)
    return EnterCodeScreen(close: (){
      _dialogEnterCode = false;
      redrawMainWindow();
    });

  return Container();
}

