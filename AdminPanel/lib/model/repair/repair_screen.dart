import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/repair/provider.dart';
import 'package:ondemand_admin/model/repair/services.dart';
import 'package:ondemand_admin/model/repair/settings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import 'article.dart';
import 'blog.dart';
import 'category.dart';

class RepairScreen extends StatefulWidget {
  @override
  _RepairScreenState createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: ListView(
            children: _getList(),
          ),
    );
  }

  _getList(){
    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(SelectableText("Repair", style: theme.style25W800,));
    list.add(SizedBox(height: 5,));

    list.add(SizedBox(height: 30,));
    list.add(button2b("Get articles", () async {
      var ret = await repairGetArticles();
      if (ret != null)
        messageError(context, ret);
    }));

    list.add(SizedBox(height: 30,));
    list.add(button2b("Repair Articles", () async {
      var ret = await repairArticles();
      if (ret != null)
        messageError(context, ret);
    }));

    list.add(SizedBox(height: 30,));
    list.add(button2b("Repair Categories", () async {
      var ret = await repairCategories();
      if (ret != null)
        messageError(context, ret);
    }));

    list.add(SizedBox(height: 30,));
    list.add(button2b("Repair Providers", () async {
      var ret = await repairProviders();
      if (ret != null)
        messageError(context, ret);
    }));

    list.add(SizedBox(height: 30,));
    list.add(button2b("Repair Services", () async {
      var ret = await repairService();
      if (ret != null)
        messageError(context, ret);
    }));

    list.add(SizedBox(height: 30,));
    list.add(button2b("Repair Blog", () async {
      var ret = await repairBlog();
      if (ret != null)
        messageError(context, ret);
    }));


    list.add(SizedBox(height: 30,));
    list.add(button2b("Repair Settings", () async {
      var ret = await repairSettings();
      if (ret != null)
        messageError(context, ret);
    }));

    return list;
  }
}


