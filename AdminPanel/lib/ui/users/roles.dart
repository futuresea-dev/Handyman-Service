//
// import 'package:flutter/material.dart';
// import 'package:abg_utils/abg_utils.dart';
// import '../strings.dart';
// import '../theme.dart';
// import 'model.dart';
//
// class RolesScreen extends StatefulWidget {
//   @override
//   _RolesScreenState createState() => _RolesScreenState();
// }
//
// class _RolesScreenState extends State<RolesScreen> {
//
//   final _controllerText = TextEditingController();
//
//   @override
//   void dispose() {
//     _controllerText.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           margin: EdgeInsets.all(20),
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: (theme.darkMode) ? Colors.black : Colors.white,
//             borderRadius: BorderRadius.circular(theme.radius),
//           ),
//           child: ListView(
//             children: _getList(),
//           ),),
//       ],
//     );
//   }
//
//   _getList(){
//     List<Widget> list = [];
//     list.add(SizedBox(height: 10,));
//     list.add(SelectableText(strings.get(79), style: theme.style25W800,)); // Roles
//
//     list.add(SizedBox(height: 20,));
//     list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
//     list.add(SizedBox(height: 10,));
//     list.add(Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Expanded(flex: 1, child: button2(strings.get(58), // "Copy",
//             theme.mainColor, (){_copy();})),
//         SizedBox(width: 10,),
//         Expanded(flex: 1, child: button2(strings.get(59), // "Export to CSV",
//             theme.mainColor, (){_csv();})),
//         Expanded(flex: (windowWidth <= 700) ? 1 : 4, child: Container(),),
//         Container(width: 200,
//             child: textElement2(strings.get(83), "", _controllerText, (String val){   // "Role name",
//             })
//         ),
//         SizedBox(width: 20,),
//         UnconstrainedBox(child: SizedBox(width: 120, child: button2(strings.get(84), // "Add Role",
//             theme.mainColor, _addRole)))
//       ],
//     ));
//     list.add(SizedBox(height: 40,));
//     list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
//     list.add(SizedBox(height: 20,));
//
//     //
//     for (var _data in roles){
//       List<Widget> list2 = [];
//       for (var item in rolesList){
//           list2.add(Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue.withAlpha(100),
//                 borderRadius: BorderRadius.circular(theme.radius),
//               ),
//               padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Checkbox(
//                       value: (_data.permissions.contains(item)),
//                       activeColor: theme.mainColor,
//                       onChanged: (bool? val){
//                         if (val == null)
//                           return;
//                         if (val){
//                           _data.permissions.add(item);
//                         }else{
//                           _data.permissions.remove(item);
//                         }
//                         setState(() {
//                         });
//                       }
//                   ),
//                   SizedBox(width: 10,),
//                   Text(item, style: theme.style12W800,),
//                 ],
//               )));
//       }
//       list.add(Container(
//         child: Row(
//           children: [
//             Container(width: 150,
//               child: Center(child: Text(_data.name, style: theme.style16W800,),)),
//             Expanded(child: Wrap(
//                 runSpacing: 20.0,
//                 spacing: 20, children: list2)),
//           ],
//         ),
//       ));
//       list.add(SizedBox(height: 20,));
//       list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
//       list.add(SizedBox(height: 40,));
//
//     }
//
//     list.add(Row(
//       children: [
//         button2small(strings.get(82), _saveRoles) /// "Save All",
//       ],
//     ));
//
//     return list;
//   }
//
//   _saveRoles() async {
//     String? ret;
//     if (ret == null)
//       messageOk(context, strings.get(81)); // "Data saved",
//     else
//       messageError(context, ret);
//   }
//
//   _addRole() async {
//     if (_controllerText.text.isEmpty)
//       return messageError(context, strings.get(80)); // "Please Enter Role name",
//     // var ret = await addNewRole(_controllerText.text);
//     // if (ret != null)
//     //   return messageError(context, ret);
//     // setState(() {
//     // });
//   }
//
//   _copy(){
//     messageOk(context, strings.get(53)); // "Data copied to clipboard"
//   }
//
//   _csv(){
//   }
// }
//
//
