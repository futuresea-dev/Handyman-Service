import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String?> repairCategories() async{
  try{
    double percentage = 0;
    var oneStep = 100/_cat.length;

    for (var item in _cat){

      var _data = item.toJson();
      var t = await FirebaseFirestore.instance.collection("category").doc(item.id).get();

      dprint("set id=${item.id}");
      await FirebaseFirestore.instance.collection("category").doc(item.id).set(_data);

      if (!t.exists){
        dprint("Not exist. +1");
        await FirebaseFirestore.instance.collection("settings").doc("main")
            .set({"category_count": FieldValue.increment(1)}, SetOptions(merge:true));
      }
      percentage += oneStep;
      dprint("успешно ${percentage.toStringAsFixed(0)}%");
    }
  }catch(ex){
    return "repairCategories " + ex.toString();
  }
  return null;
}

// ver2
List<CategoryData> _cat = [
  CategoryData(
      id: "2Lw7StfmJJtr0nyQcdbo",
      name: [StringData(code: "en", text: "Movers")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2F3de8f633-eae9-42f0-b44d-dcde57faa84b.jpg?alt=media&token=a37373bb-6867-4508-bf23-4a50d26a8cd7",
      color: Colors.indigoAccent.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand30.png"
  ),

  CategoryData(
      id: "eHkL0jNGXWMXts9yjE8H",
      name: [StringData(code: "en", text: "Home clean")],
      desc: [StringData(code: "en", text: "")], // Maybe you’re hosting out-of-town guests, throwing a party in your home (or recovering from one), or you've simply fallen behind on housekeeping. When your house needs a one-time cleaning, The Maids has your back. Whether we clean your apartment or house one time or on a regular schedule, our deep cleaning services get your home sparkling clean every time.
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2Fe555d9a4-65c9-4c0a-b422-a746b78f69ac.jpg?alt=media&token=bc6642f3-3698-45f0-a947-e70d86960a69",
      color: Colors.red.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand24.png"
  ),
  CategoryData(
      id: "S3vt97Lztg45uYcHzxDI",
      name: [StringData(code: "en", text: "Electrician")],
      desc: [StringData(code: "en", text: "")], // Are you looking for the best electrician in your area? Handy has you covered. Some jobs should only be undertaken by a professional, and we know you’d rather not fiddle with your electrical wiring or outlets unless you know exactly what you’re doing. When you use the Handy platform to book a professional electrical contractor, you can take all your stress out of the equation. Why run the risk of making an electrical problem even more complicated when you can book a professional electrician to take care of those faulty outlets or run a wire to that new lighting fixture?
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2F959f93a5-4921-406f-b5e4-ad96e6df529d.jpg?alt=media&token=21c88b3d-6856-48e7-98d0-90a9883e7569",
      color: Colors.blue.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand25.png"
  ),
  CategoryData(
      id: "7DIUCsVr6Nstlg4BPCbI",
      name: [StringData(code: "en", text: "Gardening")],
      desc: [StringData(code: "en", text: "")], // Gardening and landscaping companies provide services for residential lawns as well as company grounds and offer a wide array of services, such as designing and installing landscape features, holiday decorations and more. Services also include basic gardening tasks, such as planting perennials, annuals, shrubs, and trees, lawn and garden maintenance services like mowing, pruning, and fertilizing, as well as disposal services, like removing brush and other debris.
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2Fc23211b7-6297-48a4-a392-99b7f0f493e6.jpg?alt=media&token=a34deb20-953a-49f1-9839-c520f7c86de6",
      color: Colors.green.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand26.png"
  ),
  CategoryData(
      id: "7DIUCsVr6Nstlg4BP001",
      name: [StringData(code: "en", text: "Carpenter")],
      desc: [StringData(code: "en", text: "")], // HY Carpentry has more than 15 years of experience, our aim is to provide quality, affordable carpentry to all our customers. At HY Carpentry, no project is too small and no design is too big. Our expertise will help you create your dream home, bring your ideas with reality. We take pride in presenting new, innovative ideas tailored to your requirements and maintaining the highest standards in design, quality and service.
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2F813b35d4-279f-40f5-b2ee-599a74036b5f.jpg?alt=media&token=32f63909-3d1d-45b1-9fd3-4c847e617441",
      color: Colors.yellow.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand27.png"
  ),
  CategoryData(
      id: "tuo114vJC8Lg9YxZyqsp",
      name: [StringData(code: "en", text: "Painter")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2F20c83d8c-dccd-4404-bb3d-6c800e89f394.jpg?alt=media&token=659503ef-163f-45ab-8374-8f26b5bf6a14",
      color: Colors.deepOrangeAccent.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand28.png"
  ),
  CategoryData(
      id: "AyTkCVzNKj4G95fnacp5",
      name: [StringData(code: "en", text: "Plumber")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2F482cc800-d84e-42db-9e6d-b4bf1aacbe6a.jpg?alt=media&token=52441f1e-c5d5-4c96-9d23-b80e70b667ff",
      color: Colors.lightBlue.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand29.png"
  ),
  CategoryData(
      id: "78ZYVdPDeCqjRBPtbvDF",
      name: [StringData(code: "en", text: "Hair & Beauty")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2F63dfdf46-c650-492f-b11e-be7f918fc857.jpg?alt=media&token=e42a1286-f6b0-49a0-a078-e1f83cc82f83",
      color: Colors.green.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand31.png"
  ),
  CategoryData(
      id: "N0oJyNp9RpV0m5OcZJR8",
      name: [StringData(code: "en", text: "Home Sanitize")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/category%2F29f92b35-ea84-4995-9ef6-9f5e3554f20f.jpg?alt=media&token=9a3c16ab-ee91-4c70-bd19-f1c02acb0499",
      color: Colors.lightBlue.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand32.png"
  ),
];
