// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
//
// // List<UserData> users = [
// //   UserData(id: "1", salons: [], name: "Martines", role: "manager", email: ''),
// //   UserData(id: "2", salons: [], name: "Olderveley", role: "owner", email: ''),
// //
// //   UserData(id: "1", salons: [], name: "3 Martines", role: "manager", email: ''),
// //   UserData(id: "2", salons: [], name: "4 Olderveley", role: "owner", email: ''),
// //   UserData(id: "3", salons: [], name: "5 Martines", role: "manager", email: ''),
// //   UserData(id: "4", salons: [], name: "6 Olderveley", role: "owner", email: ''),
// //   UserData(id: "15", salons: [], name: "7 Martines", role: "manager", email: ''),
// //   UserData(id: "6", salons: [], name: "8 Olderveley", role: "owner", email: ''),
// //   UserData(id: "7", salons: [], name: "9 Martines", role: "manager", email: ''),
// //   UserData(id: "2", salons: [], name: "10 Olderveley", role: "owner", email: ''),
// //   UserData(id: "1", salons: [], name: "11 Martines", role: "manager", email: ''),
// //   UserData(id: "2", salons: [], name: "12 Olderveley", role: "owner", email: ''),
// // ];
//
// // class UserData {
// //   UserData({required this.id, required this.name, required this.email, required this.role, required this.salons});
// //   String id;
// //   String email;
// //   String name;
// //   String role;
// //   List<String> salons;
// //
// //   factory UserData.fromJson(String id, Map<String, dynamic> data){
// //     List<String> _salons = [];
// //     if (data['salons'] != null)
// //       for (dynamic key in data['salons'])
// //         _salons.add(key.toString());
// //     return UserData(
// //       id: id,
// //       name : (data["name"] != null) ? data["name"]: "",
// //       email : (data["email"] != null) ? data["email"]: "",
// //       role : (data["role"] != null) ? data["role"]: "",
// //       salons: _salons
// //     );
// //   }
// //
// //   factory UserData.createEmpty(){
// //     return UserData(
// //         id: "",
// //         name : "",
// //         email : "",
// //         role : "owner",
// //         salons: []
// //     );
// //   }
// //
// //   int compareTo(UserData b){
// //     return b.name.compareTo(name);
// //   }
// //
// //   String copy(){
// //     return "$id\t$name\t$email\t$role\n";
// //   }
// //
// //   List<String> csv(){
// //     return [id, name, email, role];
// //   }
// // }
//
//
// class UserModel with ChangeNotifier, DiagnosticableTreeMixin {
//   UserData current = UserData.createEmpty();
//   bool selected = false;
//   List<UserData> users = [];
//   String ensureVisible = "";
//
//   setList(List<UserData> _data){
//     users = _data;
//     notifyListeners();
//   }
//
//   setSelection(UserData _data){
//     current = _data;
//     selected = true;
//     notifyListeners();
//   }
//
//   setData(String name, String email, String role){
//     current.name = name;
//     current.email = email;
//     current.role = role;
//     notifyListeners();
//   }
//
//   create(){
//     current.id = UniqueKey().toString();
//     users.add(current);
//     notifyListeners();
//     ensureVisible = current.id;
//   }
//
//   emptyCurrent(){
//     current = UserData.createEmpty();
//     selected = true;
//     notifyListeners();
//   }
// }