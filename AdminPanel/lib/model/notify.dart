import 'package:abg_utils/abg_utils.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../ui/strings.dart';
import 'model.dart';

class MainDataNotify with DiagnosticableTreeMixin {

  final MainModel parent;

  MainDataNotify({required this.parent});

  String userSelectedWithProviders = "-1";
  List<ComboData> userDataWithProviders = [];
  String userSelected = "-1";
  List<ComboData> userData = [];

  Future<String?> loadUsers2() async {
    var ret = await loadUsers();
    if (ret != null)
      return ret;

    try{
      // var querySnapshot = await FirebaseFirestore.instance.collection("listusers").get();
      // users = [];
      userDataWithProviders = [];
      userDataWithProviders.add(ComboData(strings.get(14), "-1", selected: true));  /// "All users"
      userDataWithProviders.add(ComboData("", "", divider: true));
      userData = [];
      userData.add(ComboData(strings.get(254), "-1"));  // "All"
    //  addStat("(admin) users", querySnapshot.docs.length);
      for (var _user in users){
    //   for (var result in querySnapshot.docs) {
    //     var data = result.data();
        // print("user: $data");
        // var _user = UserData.fromJson(result.id, data);
        // users.add(_user);
        if (_user.role.isEmpty) {
          userDataWithProviders.add(ComboData(_user.name, _user.id, email: _user.email));
          if (!_user.providerApp)
            userData.add(ComboData(_user.name, _user.id));
        }
      }
    }catch(ex){
      return "model loadUsers " + ex.toString();
    }
    return null;
  }

  copyCustomers(){
    var text = "";
    for (var item in users){
      if (item.providerApp)
        continue;
      if (item.role.isNotEmpty)
        continue;
      text = "$text${item.id}\t${item.name}"
          "\t${item.email}\t${item.visible}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csvCustomers(){
    List<List> t2 = [];
    t2.add([
      strings.get(114), /// "Id",
      strings.get(54), /// "Name",
      strings.get(86), /// "Email",
      strings.get(70), /// "Visible",
    ]);
    for (var item in users){
      if (item.providerApp)
        continue;
      if (item.role.isNotEmpty)
        continue;
      t2.add([item.id, item.name,
        item.email, item.visible.toString()
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }
}
