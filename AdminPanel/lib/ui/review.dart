import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import '../../../utils.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      var ret = await initReviews();
      if (ret != null)
        messageError(context, ret);
      waitInMainWindow(false);
    });
    super.initState();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _getList(),
    );
  }

  _getList(){

    // ignore: unnecessary_statements
    // context.watch<MainModel>().booking.bookings;

    List<Widget> list = [];

    List<Widget> list3 = [];
    list3.add(SizedBox(height: 10,));
    list3.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(261), /// Service Reviews list
          style: theme.style25W800,)),
      ],
    ));
    list3.add(SizedBox(height: 20,));
    list3.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list3.add(SizedBox(height: 10,));
    addButtonsCopyExportSearch(list3, _copy, _csv, strings.langCopyExportSearch, _onSearch);

    list.add(Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Column(
          children: list3
        )));

    list.add(SizedBox(height: 10,));

    pagingStart();

    for (var item in reviews){
      if (!item.userName.toUpperCase().contains(_searchedValue.toUpperCase()) &&
          !item.text.toUpperCase().contains(_searchedValue.toUpperCase()) &&
          !item.serviceName.toUpperCase().contains(_searchedValue.toUpperCase())
      ) continue;

      if (isNotInPagingRange())
        continue;
      list.add(Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (theme.darkMode) ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: _item(item)
      ));
    }

    paginationLine(list, _redraw, strings.get(88)); /// from
    list.add(SizedBox(height: 40));

    return list;
  }

  _item(ReviewsData item){
    return Container(
      width: windowWidth,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 80,
                  width: 80,
                  child: (item.userAvatar.isEmpty) ? CircleAvatar(backgroundImage: AssetImage("assets/avatar.png"), radius: 50,) :
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          item.userAvatar,
                          height: 80,
                          fit: BoxFit.cover))),
              SizedBox(width: 20,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SelectableText(strings.get(262) + ":", style: theme.style14W600Grey,), /// "User name",
                    SizedBox(width: 10,),
                    Expanded(child: Text(item.userName, style: theme.style14W800),)
                  ]),
                  SizedBox(height: 10,),
                  Row(children: [
                    SelectableText(strings.get(159) + ":", style: theme.style14W600Grey,), /// "Service",
                    SizedBox(width: 10,),
                    Expanded(child: Text(item.serviceName, style: theme.style14W800),)
                  ]),
                  SizedBox(height: 10,),
                  Row(children: [
                    if (item.rating >= 1)
                      Icon(Icons.star, color: Colors.orange, size: 16,),
                    if (item.rating < 1)
                      Icon(Icons.star_border, color: Colors.orange, size: 16,),
                    if (item.rating >= 2)
                      Icon(Icons.star, color: Colors.orange, size: 16,),
                    if (item.rating < 2)
                      Icon(Icons.star_border, color: Colors.orange, size: 16,),
                    if (item.rating >= 3)
                      Icon(Icons.star, color: Colors.orange, size: 16,),
                    if (item.rating < 3)
                      Icon(Icons.star_border, color: Colors.orange, size: 16,),
                    if (item.rating >= 4)
                      Icon(Icons.star, color: Colors.orange, size: 16,),
                    if (item.rating < 4)
                      Icon(Icons.star_border, color: Colors.orange, size: 16,),
                    if (item.rating >= 5)
                      Icon(Icons.star, color: Colors.orange, size: 16,),
                    if (item.rating < 5)
                      Icon(Icons.star_border, color: Colors.orange, size: 16,),
                    SizedBox(width: 10,),
                    SelectableText(item.rating.toString(), style: theme.style14W600Grey,),
                    SizedBox(width: 20,),
                    Text(appSettings.getDateTimeString(item.time), style: theme.style12W400)
                  ]),
                  SizedBox(height: 10,),
                  Text(item.text, style: theme.style12W400),

                  if (item.images.isNotEmpty)
                    Row(children: [
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 10,
                              runSpacing: 10,
                              children: item.images.map((e){
                                return InkWell(
                                  onTap: (){
                                    openGalleryScreen(item.images, e);
                                  },
                                  child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Image.network(e.serverPath,
                                          fit: BoxFit.contain
                                      )),
                                );
                              }).toList(),
                            ),
                          )
                      )
                    ],)

                ],
              )),
              SizedBox(width: 10,),
              button2b(strings.get(62),  /// "Delete",
                  (){_delete(item);}, color: Colors.red),
              SizedBox(width: 10,),
            ],
          ),

        ],
      ),
    );
  }

  _delete(ReviewsData item){
      openDialogDelete(() async {
        Navigator.pop(context); // close dialog
        var ret = await deleteReview(item);
        if (ret == null)
          messageOk(context, strings.get(69)); // "Data deleted",
        else
          messageError(context, ret);
        setState(() {});
      }, context);
  }

  _copy(){
    _mainModel.copyReviews();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.csvReviews(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "reviews.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
