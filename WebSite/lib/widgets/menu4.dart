// import 'package:flutter/material.dart';
// import 'package:matrix4_transform/matrix4_transform.dart';
//
// import '../../theme.dart';
// import 'package:abg_utils/abg_utils.dart';
//
// class Menu4Data{
//   String id;
//   String text;
//   IconData? icon;
//   List<Menu4Data> child;
//   bool expandChild;
//   int all;
//   int unread;
//   Menu4Data(this.id, this.text, {this.icon, this.expandChild = false, this.child = const [],
//     this.all = 0, this.unread = 0});
// }
//
// class Menu4 extends StatefulWidget {
//   @required final BuildContext context;
//   final Function(String) callback;
//   final List<Menu4Data> data;
//   final bool noPop;
//   final Widget header;
//
//   final TextStyle style;
//   final TextStyle hoverStyle;
//   final Color iconColor;
//   final Color hoverIconColor;
//   final Color bgkColor;
//   final Color hoverBkgColor;
//
//   final String select;
//   final Color bkgColor;
//
//   Menu4({required this.context, required this.data, required this.callback, required this.header, this.noPop = false,
//     this.style = const TextStyle(), this.hoverStyle = const TextStyle(), this.iconColor = Colors.black, this.hoverIconColor = Colors.white,
//     this.bgkColor = Colors.black, this.hoverBkgColor = Colors.black, this.select = "", this.bkgColor = Colors.white});
//
//   @override
//   _Menu4ScreenState createState() => _Menu4ScreenState();
// }
//
// class _Menu4ScreenState extends State<Menu4> {
//
//   final ScrollController _controllerMenu = ScrollController();
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> list = [];
//     list.add(widget.header);
//     for (var item in widget.data) {
//       var select = false;
//       for (var item2 in item.child)
//         if (item2.id == widget.select) {
//           item.expandChild = true;
//           select = true;
//         }
//       //print("item.text ${item.text} select=$select");
//       list.add(_menuItem(item, false, select),);
//       if (item.expandChild){
//         for (var item2 in item.child)
//           list.add(_menuItem(item2, true, false),);
//       }
//     }
//     list.add(SizedBox(height: 150,));
//     return Drawer(
//         child: Container(
//           color: widget.bkgColor,
//           child: ScrollConfiguration(
//         behavior: MyCustomScrollBehavior(),
//         child: SingleChildScrollView(
//         controller: _controllerMenu,
//         child: Column(
//             children: list
//           ))),
//         )
//     );
//   }
//
//   String isHovered = "";
//
//   _menuItem(Menu4Data item, bool _subItem, bool select){
//     if (item.id == "divider")
//       return Divider();
//     bool child = item.child.isNotEmpty;
//     var id = item.id;
//     var name = item.text;
//     var icon = item.icon;
//     bool _select = (isHovered == id || id == widget.select);
//     if (select)
//       _select = true;
//     return Stack(
//       children: <Widget>[
//         InkWell(
//         onTap: () {
//           if (child){
//             item.expandChild = !item.expandChild;
//             setState(() {
//             });
//           }else{
//             if (!widget.noPop)
//               Navigator.pop(context);
//             widget.callback(id);
//           }
//         },
//     onHover: (value) {
//         if (value)
//           isHovered = id;
//         else
//           isHovered = "";
//       setState(() {
//       });
//     },
//     child: Container(
//         padding: (!_subItem) ? EdgeInsets.only(left: 00) : EdgeInsets.only(left: 30),
//         color: (_select) ? widget.hoverBkgColor : widget.bgkColor,
//         child: ListTile(
//           mouseCursor: SystemMouseCursors.click,
//           title: Row(
//             children: [
//               (!_subItem) ?
//               Text("- ", style: (_select) ?
//                     TextStyle(fontFamily: widget.hoverStyle.fontFamily, color: widget.hoverIconColor, fontWeight: FontWeight.w800) :
//                     TextStyle(fontFamily: widget.hoverStyle.fontFamily, color: widget.iconColor, fontWeight: FontWeight.w800))
//                   :  Container(
//                       margin: EdgeInsets.only(right: 5),
//                       width: 5, height: 5,
//                       decoration: BoxDecoration(
//                         color: (_select) ? widget.hoverIconColor : widget.iconColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//
//               Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
//                   style: (_select) ? widget.hoverStyle : widget.style)),
//               if (item.unread != 0)
//                 Align(
//                     alignment: Alignment.topRight,
//                     child: Container(
//                         padding: EdgeInsets.all(3),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(item.unread.toString(),
//                           style: TextStyle(fontSize: 14, color: Colors.white),)
//                     )
//                 ),
//               SizedBox(width: 10,),
//               if (item.all != 0)
//                 Text(item.all.toString(), style: theme.style12W600Grey,)
//             ],
//             ),
//           trailing:
//               (child) ?
//               AnimatedContainer(duration: Duration(milliseconds: 500),
//                   transform: (item.expandChild) ? Matrix4Transform().rotateDegrees(90, origin: Offset(8, 8)).matrix4 :
//                   Matrix4Transform().rotateDegrees(360, origin: Offset(8, 8)).matrix4,
//                 child: Icon(Icons.navigate_next_outlined, size: (_select) ? 16 : 16,
//                 color: (_select) ? widget.hoverStyle.color : widget.style.color,)) : Container(width: 1, height: 1,),
//           leading:  UnconstrainedBox(
//               child: Container(
//                   height: 25,
//                   width: 25,
//                   child: Icon(icon, color: (_select) ? widget.hoverIconColor : widget.iconColor),
//               )),
//         ))),
//       ],
//     );
//   }
//
// }