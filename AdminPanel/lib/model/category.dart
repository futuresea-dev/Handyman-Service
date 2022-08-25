import 'package:abg_utils/abg_utils.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../ui/strings.dart';
import 'model.dart';

class MainDataCategory with DiagnosticableTreeMixin {

  final MainModel parent;

  MainDataCategory({required this.parent});
  List<ComboData> parentsData = [];

  setList(List<CategoryData> _data){
    categories = _data;
    parentListMake();
    parent.notify();
  }

  select(CategoryData _selectInEmulator){
    currentCategory = _selectInEmulator;
    parentListMake();
    if (parent.initEditorInCategoryScreen != null)
      parent.initEditorInCategoryScreen!();
  }

  parentListMake(){
    // parents category
    parentsData = [];
    parentsData.add(ComboData(strings.get(74), "")); /// Select parent category
    for (var item in categories)
      if (item.id != currentCategory.id) {
        var found = false;
        for (var item2 in categories) {
          if (item2.parent == currentCategory.id)
            found = true;
        }
        if (!found)
          parentsData.add(ComboData(parent.getTextByLocale(item.name), item.id));
      }
    //
  }

  copy(){
    var text = "";
    for (var item in categories){
      text = "$text${item.id}\t${parent.getTextByLocale(item.name)}"
          "\t${parent.getTextByLocale(item.desc)}\t${item.parent}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csv(){
    List<List> t2 = [];
    t2.add([
      strings.get(114), // "Id",
      strings.get(54), // "Name",
      strings.get(73), // "Description",
      strings.get(285), // Parent Id
    ]);
    for (var item in categories){
      t2.add([item.id, parent.getTextByLocale(item.name),
        parent.getTextByLocale(item.desc), item.parent
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }
}

