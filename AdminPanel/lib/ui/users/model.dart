// List<String> _managerRoles = [
//   "TIMELINE_VIEW",
//
//   "CATEGORY_VIEW",
//   "SALON_VIEW",
//   "GALLERY_VIEW",
//   "GALLERY_ADD",
//   "GALLERY_DELETE",
//   "WORK_VIEW",
//   "CUSTOMER_VIEW",
//   "EMPLOYEE_VIEW",
//   "OFFERS_VIEW",
//   "CHAT_VIEW",
//   "DOCUMENTS_VIEW",
//   "SETTINGS_VIEW",
//   "GATEWAY_VIEW",
// ];
//
//
// List<Role> roles = [
//   Role(id: "1", name: 'manager', permissions: _managerRoles)
// ];
//
// List<String> rolesList = [
//   "TIMELINE_VIEW",
//
//   "CATEGORY_VIEW",
//   "CATEGORY_CREATE",
//   "CATEGORY_DELETE",
//
//   "SALON_VIEW",
//   "SALON_CREATE",
//   "SALON_DELETE",
//
//   "GALLERY_VIEW",
//   "GALLERY_ADD",
//   "GALLERY_DELETE",
//
//   "WORK_VIEW",
//   "WORK_CREATE",
//   "WORK_DELETE",
//
//   "CUSTOMER_VIEW",
//
//   "EMPLOYEE_VIEW",
//   "EMPLOYEE_ADD",
//   "EMPLOYEE_DELETE",
//
//   "OFFERS_VIEW",
//   "OFFERS_ADD",
//   "OFFERS_DELETE",
//
//   "NOTIFY_SEND",
//
//   "CHAT_VIEW",
//
//   "DOCUMENTS_VIEW",
//   "DOCUMENTS_SAVE",
//
//   "SETTINGS_VIEW",
//   "SETTINGS_SAVE",
//
//   "GATEWAY_VIEW",
//   "GATEWAY_SAVE",
// ];
//
// class Role {
//   Role({required this.id, required this.name, required this.permissions,});
//   final String id;
//   List<String> permissions;
//   String name;
//
//   factory Role.fromJson(String id, Map<String, dynamic> data){
//     List<String> _permissions = [];
//     if (data['permissions'] != null)
//       for (dynamic key in data['permissions'])
//         _permissions.add(key.toString());
//     return Role(
//       id: id,
//       name : (data["name"] != null) ? data["name"]: "",
//       permissions: _permissions,
//     );
//   }
//
//   int compareTo(Role b){
//     return b.name.compareTo(name);
//   }
//
//   String copy(){
//     var text = "$id\t$name";
//     for (var item in permissions)
//       text = "$text\t$item";
//     text = "$text\n";
//     return text;
//   }
//
//   List<String> csv(){
//     var text = "";
//     for (var item in permissions) {
//       if (text.isEmpty)
//         text = item;
//       else
//         text = "$text $item";
//     }
//     return [id, name, text];
//   }
// }
