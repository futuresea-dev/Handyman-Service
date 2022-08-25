import 'package:abg_utils/abg_utils.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../ui/strings.dart';
import 'model.dart';

class MainDataOffer with DiagnosticableTreeMixin {

  final MainModel parent;
  MainDataOffer({required this.parent});

  //
  // Discount Type
  //
  List<ComboData> discountTypeCombo = [
    ComboData(strings.get(165), "percentage"),
    ComboData(strings.get(150), "fixed"),
  ];

  copy(){
    var text = "";
    for (var item in offers){
      text = "$text${item.code}\t${getDiscountText(item)}"
          "\t${appSettings.getDateTimeString(item.expired)}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csv(){
    List<List> t2 = [];
    t2.add([
      strings.get(163), /// "CODE",
      strings.get(164), /// "Discount",
      strings.get(167), /// "Expire",
    ]);
    for (var item in offers){
      t2.add([item.code, getDiscountText(item),
        appSettings.getDateTimeString(item.expired)
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }
}
