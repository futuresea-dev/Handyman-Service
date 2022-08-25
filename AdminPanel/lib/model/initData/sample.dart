import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../ui/strings.dart';
import '../model.dart';

Future<String?> uploadSampleData(Function(String) callback, BuildContext context) async{

  callback(strings.get(251)); /// "Starting upload ...",

  late FirebaseAuth auth;
  late FirebaseApp secondaryApp;
  try {
    await Firebase.initializeApp(name: "SecondaryApp", options: Firebase.app().options);
    secondaryApp = Firebase.app('SecondaryApp');
    auth = FirebaseAuth.instanceFor(app: secondaryApp);
  }catch(ex){
    print("secondaryApp $ex");
    return ex.toString();
  }

  await _createUser(auth, "provider1");
  await _createUser(auth, "provider2");
  await _createUser(auth, "provider3");

  await secondaryApp.delete();

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null)
    return "User = null";

  //
  // CATEGORY
  //
  callback(strings.get(241)); /// "Delete categories ...",
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("category").get();
    for (var result in querySnapshot.docs) {
      result.reference.delete();
    }
  }catch(ex){
    return ex.toString();
  }

  try{
    await dbDeleteAllFilesInFolder('category');
  }catch(ex){
    print("Sample - delete category files - " + ex.toString());
  }

  callback(strings.get(239)); /// "Upload categories ...",
  double percentage = 0;
  var oneStep = 100/_cat.length;
  for (var item in _cat){
    try{
      await _uploadCategoryImage(item);
      var _data = item.toJson();
      item.id = (await FirebaseFirestore.instance.collection("category").add(_data)).id;
    }catch(ex){
      return ex.toString();
    }
    percentage += oneStep;
    callback(strings.get(239) + " ${percentage.toStringAsFixed(0)}%"); /// "Upload categories ... %%",
  }

  await FirebaseFirestore.instance.collection("settings").doc("main")
      .set({"category_count": _cat.length}, SetOptions(merge:true));

  //
  // PROVIDER
  //

  callback(strings.get(242)); /// "Delete providers ...",
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("provider").get();
    for (var result in querySnapshot.docs) {
      result.reference.delete();
    }
  }catch(ex){
    return ex.toString();
  }

  try{
    await dbDeleteAllFilesInFolder('provider');
  }catch(ex){
    print("Sample - delete provider  file - " + ex.toString());
  }

  percentage = 0;
  oneStep = 100/_provider.length;
  for (var item in _provider){

    try{
      await _uploadProviderImage(item, "assetUpperImage");
      await _uploadProviderImage(item, "assetsLogo");
      await _uploadProviderGalleryImage(item);
      List<String> _category = [];
      for (var item2 in item.assetsCategory)
        _category.add(_catGetIdByName(item2));
      item.category = _category;
      var _data = item.toJson();
      item.id = (await FirebaseFirestore.instance.collection("provider").add(_data)).id;
    }catch(ex){
      return ex.toString();
    }
    percentage += oneStep;
    callback(strings.get(244) + " ${percentage.toStringAsFixed(0)}%"); /// "Upload providers  ... %%",
  }

  await FirebaseFirestore.instance.collection("settings").doc("main")
      .set({"provider_count": _provider.length}, SetOptions(merge:true));

  //
  // SERVICE
  //
  callback(strings.get(243)); /// "Delete services ...",
  try{
    var querySnapshot = await FirebaseFirestore.instance.collection("service").get();
    for (var result in querySnapshot.docs) {
      result.reference.delete();
    }
  }catch(ex){
    return ex.toString();
  }

  try{
    await dbDeleteAllFilesInFolder('service');
  }catch(ex){
    print("Sample - delete service files - " + ex.toString());
  }

  percentage = 0;
  oneStep = 100/_service.length;
  for (var item in _service){
    try{
      await _uploadServiceGalleryImage(item);
      List<String> _category = [];
      for (var item2 in item.assetsCategory)
        _category.add(_catGetIdByName(item2));
      item.category = _category;
      List<String> _providers = [];
      for (var item2 in item.assetsProvider)
        _providers.add(_providerGetIdByName(item2));
      item.providers = _providers;
      var _data = item.toJson();
      item.id = (await FirebaseFirestore.instance.collection("service").add(_data)).id;
    }catch(ex){
      return ex.toString();
    }
    percentage += oneStep;
    callback(strings.get(245) + " ${percentage.toStringAsFixed(0)}%"); /// "Upload services  ... %%",
  }

  await FirebaseFirestore.instance.collection("settings").doc("main")
      .set({"service_count": _service.length}, SetOptions(merge:true));

  //
  callback(strings.get(202)); /// "Loading data ...",
  var ret = await Provider.of<MainModel>(context,listen:false).init(callback, context, null);
  if (ret != null)
    return ret;
  return null;
}

_catGetIdByName(String name){
  for (var item in _cat)
    if (item.name[0].text == name)
      return item.id;
  return "";
}

_createUser(FirebaseAuth auth, String prefix) async {
  User? user;
  try {
    user = (await auth.createUserWithEmailAndPassword(
      email: "$prefix@ondemand.com",
      password: "123456",
    )).user;
  }catch(ex){
    print("$prefix@ondemand.com $ex");
    try{
      user = (await auth.signInWithEmailAndPassword(
        email: "$prefix@ondemand.com",
        password: "123456",)).user;
      await auth.signOut();
    }catch(ex){
      dprint("_createUser " + ex.toString());
    }
  }
  if (user != null) {
    try {
      await FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
        "visible": true,
        "phoneVerified": false,
        "email": "$prefix@ondemand.com",
        "phone": "",
        "name": prefix,
        "date_create" : FieldValue.serverTimestamp(),
        "socialLogin" : "",
        "providerApp" : true
      }, SetOptions(merge: true));
    }catch(ex){
      print("_createUser " + ex.toString());
    }
  }
}

_providerGetIdByName(String name){
  for (var item in _provider)
    if (item.name[0].text == name)
      return item.id;
  return "";
}

_uploadCategoryImage(CategoryData item) async {
  ByteData byteData = await rootBundle.load(item.assetFile);
  Uint8List _imageData = byteData.buffer.asUint8List();
  var f = Uuid().v4();
  var name = "category/$f.jpg";

  // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
  // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
  item.serverPath = await dbSaveFile(name, _imageData);
  item.localFile = name;
}


List<CategoryData> _cat = [
    CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Home clean")],
      desc: [StringData(code: "en", text: "")], // Maybe you’re hosting out-of-town guests, throwing a party in your home (or recovering from one), or you've simply fallen behind on housekeeping. When your house needs a one-time cleaning, The Maids has your back. Whether we clean your apartment or house one time or on a regular schedule, our deep cleaning services get your home sparkling clean every time.
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.red.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand24.png"
  ),
  CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Electrician")],
      desc: [StringData(code: "en", text: "")], // Are you looking for the best electrician in your area? Handy has you covered. Some jobs should only be undertaken by a professional, and we know you’d rather not fiddle with your electrical wiring or outlets unless you know exactly what you’re doing. When you use the Handy platform to book a professional electrical contractor, you can take all your stress out of the equation. Why run the risk of making an electrical problem even more complicated when you can book a professional electrician to take care of those faulty outlets or run a wire to that new lighting fixture?
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.blue.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand25.png"
  ),
  CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Gardening")],
      desc: [StringData(code: "en", text: "")], // Gardening and landscaping companies provide services for residential lawns as well as company grounds and offer a wide array of services, such as designing and installing landscape features, holiday decorations and more. Services also include basic gardening tasks, such as planting perennials, annuals, shrubs, and trees, lawn and garden maintenance services like mowing, pruning, and fertilizing, as well as disposal services, like removing brush and other debris.
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.green.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand26.png"
  ),
  CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Carpenter")],
      desc: [StringData(code: "en", text: "")], // HY Carpentry has more than 15 years of experience, our aim is to provide quality, affordable carpentry to all our customers. At HY Carpentry, no project is too small and no design is too big. Our expertise will help you create your dream home, bring your ideas with reality. We take pride in presenting new, innovative ideas tailored to your requirements and maintaining the highest standards in design, quality and service.
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.yellow.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand27.png"
  ),
  CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Painter")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.deepOrangeAccent.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand28.png"
  ),
  CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Plumber")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.lightBlue.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand29.png"
  ),
  CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Movers")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.indigoAccent.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand30.png"
  ),
  CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Hair & Beauty")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.green.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand31.png"
  ),
  CategoryData(
      id: "",
      name: [StringData(code: "en", text: "Home Sanitize")],
      desc: [StringData(code: "en", text: "")],
      visible: true,
      visibleCategoryDetails: true,
      localFile: "",
      serverPath: "",
      color: Colors.lightBlue.withAlpha(100),
      parent: "",
      assetFile: "assets/ondemands/ondemand32.png"
  ),
];

_uploadProviderImage(ProviderData item, String type) async {
  ByteData byteData = ByteData(0);
  if (type == "assetUpperImage")
    byteData = await rootBundle.load(item.assetUpperImage);
  if (type == "assetsLogo")
    byteData = await rootBundle.load(item.assetsLogo);
  Uint8List _imageData = byteData.buffer.asUint8List();
  var f = Uuid().v4();
  var name = "provider/$f.jpg";
  // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
  // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
  var _serverPath = await dbSaveFile(name, _imageData);
  if (type == "assetUpperImage") {
    item.imageUpperServerPath = _serverPath;
    item.imageUpperLocalFile = name;
  }
  if (type == "assetsLogo") {
    item.logoServerPath = _serverPath;
    item.logoLocalFile = name;
  }
}

_uploadProviderGalleryImage(ProviderData item) async {
  ByteData byteData = ByteData(0);
  List<ImageData> _gallery = [];
  for (var item2 in item.assetsGallery) {
    byteData = await rootBundle.load(item2);
    Uint8List _imageData = byteData.buffer.asUint8List();
    var f = Uuid().v4();
    var name = "provider/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    _gallery.add(ImageData(serverPath: await dbSaveFile(name, _imageData), localFile: name));
  }
  item.gallery = _gallery;
}

_uploadServiceGalleryImage(ProductData item) async {
  ByteData byteData = ByteData(0);
  List<ImageData> _service = [];
  for (var item2 in item.assetsGallery) {
    byteData = await rootBundle.load(item2);
    Uint8List _imageData = byteData.buffer.asUint8List();
    var f = Uuid().v4();
    var name = "service/$f.jpg";
    // var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
    // TaskSnapshot s = await firebaseStorageRef.putData(_imageData);
    _service.add(ImageData(serverPath: await dbSaveFile(name, _imageData), localFile: name));
  }
  item.gallery = _service;
}

List<ProviderData> _provider = [
  ProviderData(
    name: [StringData(code: "en", text: "Happy House")],
    address: "69 Hazelwood Avenue, Morden London, United Kingdom, SM4 5RS",
    descTitle: [StringData(code: "en", text: "About us")],
    desc: [StringData(code: "en", text: "The Happy House Cleaning Services offers professional cleaning services to make your home or apartment look its very best. From cleaning sinks, baths and tiles to polishing windows, our cleaners have the expertise to deal with every cleaning challenge.")],
    phone: "020 7101 4326",
    www: "https://www.housejoy.in/mumbai/home-cleaning-services",
    instagram: "https://www.instagram.com/happy_house65/",
    assetUpperImage: "assets/ondemands/p1.jpg",
    assetsLogo: "assets/ondemands/p2.jpg",
    assetsGallery: ["assets/ondemands/p3.jpg", "assets/ondemands/p4.jpg", "assets/ondemands/p5.jpg"],
    assetsCategory: ["Home clean", "Carpenter", "Painter"],
    login : "provider1@ondemand.com",
    tax: 9,
    route: [],
    addon: [], workTime: [], gallery: [], category: [], articles: [], subscriptions: [],
  ),
  ProviderData(
    name: [StringData(code: "en", text: "Cleaning Services London")],
    address: "Hello Services Ltd 119 Richmond Road Kingston Upon Thames KT2 5BX",
    descTitle: [StringData(code: "en", text: "About us")],
    desc: [StringData(code: "en", text: "Hello Services is a fully accredited company. We provide our customers with a vast range of high-quality Home services that meet their requirements.")],
    phone: "02036334555",
    www: "https://www.housejoy.in/mumbai/home-cleaning-services",
    instagram: "https://www.instagram.com/happy_house65/",
    assetUpperImage: "assets/ondemands/p9.jpg",
    assetsLogo: "assets/ondemands/p10.png",
    assetsGallery: ["assets/ondemands/p6.jpg", "assets/ondemands/p7.jpg", "assets/ondemands/p8.jpg"],
    assetsCategory: ["Electrician", "Plumber", "Home Sanitize"],
    login : "provider2@ondemand.com",
    tax: 10,
    route: [],
    addon: [], workTime: [], gallery: [], category: [], articles: [], subscriptions: [],
  ),
  ProviderData(
    name: [StringData(code: "en", text: "Blow LTD")],
    address: "Hello Services Ltd 119 Richmond Road Kingston Upon Thames KT2 5BX",
    descTitle: [StringData(code: "en", text: "About us")],
    desc: [StringData(code: "en", text: "blow LTD is the UK’s leading on demand beauty business. We are a business designed by women, for women, so we know exactly how to make your lives a little bit easier with beauty services delivered at a time and place that suits you. All booked through our easy, award-winning app.")],
    phone: "02036334555",
    www: "https://www.housejoy.in/mumbai/home-cleaning-services",
    instagram: "https://www.instagram.com/happy_house65/",
    assetUpperImage: "assets/ondemands/p12.jpg",
    assetsLogo: "assets/ondemands/p11.jpg",
    assetsGallery: ["assets/ondemands/p13.jpg", "assets/ondemands/p14.jpg", "assets/ondemands/p15.jpg"],
    assetsCategory: ["Gardening", "Hair & Beauty", "Movers"],
    login : "provider3@ondemand.com",
    tax: 10,
    route: [],
    addon: [], workTime: [], gallery: [], category: [], articles: [], subscriptions: [],
  ),
];

List<ProductData> _service = [
  ProductData("", [StringData(code: "en", text: "Happy House Home clean")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "The Happy House Cleaning provides wide range of cleaning services for domestic and commercial properties of any size and condition.")],
    assetsGallery: ["assets/ondemands/p3.jpg", "assets/ondemands/p4.jpg", "assets/ondemands/p5.jpg"],
    price: [PriceData([StringData(code: "en", text: "Base price")], 19, 18, "fixed", ImageData())],
    duration: Duration(minutes: 20),
    assetsCategory: ["Home clean"],
    assetsProvider: ["Happy House"],
    tax: 10, category: [], providers: [], gallery: [],
    taxAdmin: 6,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Popular Cleanings")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Combining the best people with technology is a virtuous circle. Technology helps cleaners focus more on delivering a great experience, so they can do more in less time, which helps them earn more, which makes them happier, which makes clients happier, which helps them earn even more. It is a beautiful thing.")],
    assetsGallery: ["assets/ondemands/p4.jpg", "assets/ondemands/p3.jpg", "assets/ondemands/p5.jpg"],
    price: [PriceData([StringData(code: "en", text: "1 Cleaner for 1 hour")], 50, 0, "fixed", ImageData()),
      PriceData([StringData(code: "en", text: "1 Cleaner for 2.5 hours")], 200, 0, "fixed", ImageData()),
      PriceData([StringData(code: "en", text: "1 Cleaner for 4 hours")], 300, 0, "fixed", ImageData())
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Home clean"],
    assetsProvider: ["Happy House"],
    tax: 10, category: [], providers: [], gallery: [],
    taxAdmin: 6,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Deep Cleaning")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Simply Maid offers deep cleaning services that transform living spaces into immaculate ones! Our services cover all areas of home cleaning with many special, add-on services for a truly, thorough cleaning experience. What’s more, Simply Maid is made up of certified, vetted cleaners that possess the skill, know-how and experience to deep clean homes of all types and sizes!")],
    assetsGallery: ["assets/ondemands/p16.jpg", "assets/ondemands/p17.jpg", "assets/ondemands/p18.jpg"],
    price: [PriceData([StringData(code: "en", text: "Lounge / Dining room (12x12 feet)")], 46, 40, "fixed", ImageData()),
      PriceData([StringData(code: "en", text: "Hallway (10x4 feet)")], 23, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Home clean"],
    assetsProvider: ["Happy House"],
    tax: 10, category: [], providers: [], gallery: [],
    taxAdmin: 6,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  //  Electrician
  ProductData("", [StringData(code: "en", text: "Level 2 Electrician")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Eris Electrical is an accredited Level 2 Electrician capable of handling network services that commence from the street and connect to your property. We provide superior electrical level 2 services to residential and commercial properties across Sydney. Eris Electrical is the preferred Level 2 electrical contractor in the western region of Sydney with qualified, trained, highly experienced and specialised level 2 electricians to serve you.")],
    assetsGallery: ["assets/ondemands/p19.jpg", "assets/ondemands/p20.jpg", "assets/ondemands/p21.jpg"],
    price: [PriceData([StringData(code: "en", text: "Level 2 Electrician")], 20, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    assetsCategory: ["Electrician"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 6,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Metering Services")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Eris Electrical Services provides customised offerings to energy retailers, electricity authorities, large commercial and industrial customers as well as consultants who form the complete metering value chain. We have a team of professionals who are highly experienced and skilled in mass meter replacements, meter breakdowns, and maintenance services. Our expert team is committed to ensuring the best safety levels are maintained while exceeding customer’s expectations and making sure optimal delivery is rendered.")],
    assetsGallery: ["assets/ondemands/p20.jpg", "assets/ondemands/p19.jpg", "assets/ondemands/p21.jpg"],
    price: [PriceData([StringData(code: "en", text: "Metering Services")], 20, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    assetsCategory: ["Electrician"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 6,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Smart Meter Replacement")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Effective from 1 July 2016, Smart Meter Roll Out in NSW has been initiated by the Australian Government. Up until 1 December 2017, having a smart meter installed is voluntary for customers. From 1 December 2017, all new meters installed must be smart meters. ")],
    assetsGallery: ["assets/ondemands/p21.jpg", "assets/ondemands/p20.jpg", "assets/ondemands/p19.jpg"],
    price: [PriceData([StringData(code: "en", text: "Smart Meter Replacement")], 20, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    assetsCategory: ["Electrician"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 15,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  // Gardening
  ProductData("", [StringData(code: "en", text: "Balcony Garden Design")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Balcony garden is a nw concept in urban areas to give lively look with natural plants and design elements.")],
    assetsGallery: ["assets/ondemands/p22.jpg", "assets/ondemands/p23.jpg", "assets/ondemands/p24.jpg"],
    price: [PriceData([StringData(code: "en", text: "Balcony Garden Design")], 15, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    assetsCategory: ["Gardening"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 15,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Tree Surgery")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Entrust us with the well being of your woody plants, we guarantee you won’t regret it. The tree surgeons we send on site can help you with anything, ")],
    assetsGallery: ["assets/ondemands/p23.jpg", "assets/ondemands/p22.jpg", "assets/ondemands/p24.jpg"],
    price: [PriceData([StringData(code: "en", text: "Tree Surgery")], 15, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    assetsCategory: ["Gardening"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 15,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Jet Washing")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Hire a jet cleaning service in London whether you are a landlord, leasing agent, householder or even part of an agency. As part of our pressure washing service, we remove dirt")],
    assetsGallery: ["assets/ondemands/p24.jpg", "assets/ondemands/p23.jpg", "assets/ondemands/p22.jpg"],
    price: [PriceData([StringData(code: "en", text: "Jet Washing square meter")], 3, 0, "fixed", ImageData()),
      PriceData([StringData(code: "en", text: "Jet Washing more then 200 square meter")], 1, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Gardening"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 15,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  // Carpenter
  ProductData("", [StringData(code: "en", text: "Wooden cabinets and cupboards repair")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Wooden cabinets and cupboards are very handy in all homes, however, overuse can lead them to breakdown requiring some repair work, from time to time, to prevent any safety issues at home.")],
    assetsGallery: ["assets/ondemands/p25.jpg", "assets/ondemands/p26.jpg", "assets/ondemands/p27.jpg"],
    price: [PriceData([StringData(code: "en", text: "Wooden cabinets and cupboards repair")], 300, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Carpenter"],
    assetsProvider: ["Happy House"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 15,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Outdoor wooden storage fabrication")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Custom made wooden storage fabrication can help you add some storage space to your outdoor. However, it is not easy to find the carpenter who could provide you with the service you deserve.")],
    assetsGallery: ["assets/ondemands/p26.jpg", "assets/ondemands/p25.jpg", "assets/ondemands/p27.jpg"],
    price: [PriceData([StringData(code: "en", text: "Outdoor wooden storage fabrication")], 300, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Carpenter"],
    assetsProvider: ["Happy House"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Wooden doors and windows repair")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Considering the amount of exposure to the elements wooden doors and windows get, wood door and window repair becomes a necessary requirement. Especially exterior wood door repair, since doors on the outside of our homes are worked the hardest and have to put up with all weather conditions. Enter HomeGenie – your answer to all wood door and window repair issues. ")],
    assetsGallery: ["assets/ondemands/p27.jpg", "assets/ondemands/p26.jpg", "assets/ondemands/p25.jpg"],
    price: [PriceData([StringData(code: "en", text: "Wooden doors and windows repair")], 300, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Carpenter"],
    assetsProvider: ["Happy House"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  // Painter
  ProductData("", [StringData(code: "en", text: "EXTERIOR HOUSE PAINTING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Never underestimate the impact a fresh, clean coat of paint can make to the outside of your home! It doesn’t matter if we’re working with stucco, brick, wood siding, vinyl, cedar shingles, or wood trim. WOW 1 DAY PAINTING’s expert exterior house painters have years of experience painting every kind of outdoor material:")],
    assetsGallery: ["assets/ondemands/p28.jpg", "assets/ondemands/p29.jpg", "assets/ondemands/p30.jpg"],
    price: [PriceData([StringData(code: "en", text: "EXTERIOR HOUSE PAINTING")], 10, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Painter"],
    assetsProvider: ["Happy House"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "INTERIOR HOUSE PAINTING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "From lightening up a living room to a complete color overhaul, the impact a fresh coat of paint can have a huge impact on your home's interior! Taking weeks to try and do it all on your own can also have a huge impact—just not in a good way.")],
    assetsGallery: ["assets/ondemands/p29.jpg", "assets/ondemands/p28.jpg", "assets/ondemands/p30.jpg"],
    price: [PriceData([StringData(code: "en", text: "INTERIOR HOUSE PAINTING")], 10, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Painter"],
    assetsProvider: ["Happy House"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "BRICK PAINTING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "When brick becomes faded or yellowed over time, it can make your home look a bit run down. Or you may not be a fan of the natural color of the brick on your home and want a more updated, modern look. The good news is that you’re not permanently stuck with the color of your brick! If you want to change things up, painting your brick is the best way to do it. ")],
    assetsGallery: ["assets/ondemands/p30.jpg", "assets/ondemands/p29.jpg", "assets/ondemands/p28.jpg"],
    price: [PriceData([StringData(code: "en", text: "BRICK PAINTING")], 10, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Painter"],
    assetsProvider: ["Happy House"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  // Plumber
  ProductData("", [StringData(code: "en", text: "DRAIN CLEANING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Slow or clogged drains are no match for our team of certified drain cleaning professionals. We’ll clean your drain and make sure it keeps running that way long after we are gone. We have been providing professional drain cleaning services for many years, and we make sure that we clean your drains right, and get to the root of the problem.")],
    assetsGallery: ["assets/ondemands/p31.jpg", "assets/ondemands/p32.jpg", "assets/ondemands/p33.jpg"],
    price: [PriceData([StringData(code: "en", text: "DRAIN CLEANING")], 50, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Plumber"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "EMERGENCY PLUMBING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Plumber Pro Service in Athens, GA provides full service plumbing maintenance & full service plumbing repairs to the entire Athens, Georgia region 24 hours a day, 7 days a week. Our licensed and insured Athens plumbers are available 24 hours a day to handle every type of plumbing emergency.")],
    assetsGallery: ["assets/ondemands/p32.jpg", "assets/ondemands/p31.jpg", "assets/ondemands/p33.jpg"],
    price: [PriceData([StringData(code: "en", text: "EMERGENCY PLUMBING")], 50, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Plumber"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "WATER HEATER MAINTENANCE")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Many homeowners don’t realize how important water heater maintenance is. Your water heater should be drained and cleaned out once a year. Minerals in the water build up and create sediment in the bottom of your tank. This sediment makes the water heat up slower and use more energy to keep the water in the tank warm. Not only will you have less hot water, your energy bills will be higher as well. ")],
    assetsGallery: ["assets/ondemands/p33.jpg", "assets/ondemands/p31.jpg", "assets/ondemands/p32.jpg"],
    price: [PriceData([StringData(code: "en", text: "WATER HEATER MAINTENANCE")], 50, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Plumber"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  // Movers
  ProductData("", [StringData(code: "en", text: "Loading & Unloading")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Get the most out of your U-Haul® truck rental, U-Box® storage container, or storage unit when you have your boxes, furniture, and appliances expertly loaded, leaving no wasted space. Moving Help® Service Providers will safely load and unload your items ensuring they arrive safely in your new home.")],
    assetsGallery: ["assets/ondemands/p34.jpg", "assets/ondemands/p35.jpg", "assets/ondemands/p36.png"],
    price: [PriceData([StringData(code: "en", text: "Loading & Unloading")], 12, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Movers"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Packing & Unpacking")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Moving Help® Service Providers offer packing services that will save you time and effort on moving day. Your mover will know the most effective and efficient ways to pack your dishware, televisions, books, clothes, and even your most fragile belongings. You can also book your moving company to unpack your moving boxes once you arrive at your destination so you can be fully moved in that much sooner!")],
    assetsGallery: ["assets/ondemands/p35.jpg", "assets/ondemands/p34.jpg", "assets/ondemands/p36.png"],
    price: [PriceData([StringData(code: "en", text: "Packing & Unpacking")], 12, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Movers"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Heavy Furniture & Specialty Moves")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Find local movers to help with any oversized or specialty items you may need moved. You can find providers ready to safely move pianos, gun safes, large appliances, and more! Incorrectly moved oversized items, like safes and pianos, can pose a serious danger to you and your home. Let the experts take charge without breaking the bank or your back.")],
    assetsGallery: ["assets/ondemands/p36.png", "assets/ondemands/p35.jpg", "assets/ondemands/p34.jpg"],
    price: [PriceData([StringData(code: "en", text: "Heavy Furniture & Specialty Moves")], 12, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    assetsCategory: ["Movers"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  // Hair & Beauty
  ProductData("", [StringData(code: "en", text: "Hair + Makeup")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Why not combine professional hairstyling with expert makeup application to achieve the perfect look? Our hair and makeup artists are the best in London with years of experience between them. Wherever you are in London, or whatever look you need, we have you covered.")],
    assetsGallery: ["assets/ondemands/p37.jpg", "assets/ondemands/p38.jpg", "assets/ondemands/p39.jpg"],
    price: [PriceData([StringData(code: "en", text: "Hair + Makeup")], 10, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 10),
    assetsCategory: ["Hair & Beauty"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "KERASTASE UPDO + MAKEUP")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "From elegant to undone updos and a flawless day makeup look to match, we'll create the perfect look for you using premium Kérastase products. To dial up your makeup look for the evening, select the ‘Upgrade to Glam’ add-on at checkout.")],
    assetsGallery: ["assets/ondemands/p38.jpg", "assets/ondemands/p37.jpg", "assets/ondemands/p39.jpg"],
    price: [PriceData([StringData(code: "en", text: "KERASTASE UPDO + MAKEUP")], 84, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    assetsCategory: ["Hair & Beauty"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "KERASTASE BLOW DRY + MAKEUP")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "From super sleek to bouncy blow dries and a flawless day makeup look to match, we'll create the perfect look for you using premium Kérastase products. To dial up your makeup look for the evening, select the ‘Upgrade to Glam’ add-on at checkout.")],
    assetsGallery: ["assets/ondemands/p39.jpg", "assets/ondemands/p37.jpg", "assets/ondemands/p38.jpg"],
    price: [PriceData([StringData(code: "en", text: "KERASTASE BLOW DRY + MAKEUP")], 84, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    assetsCategory: ["Hair & Beauty"],
    assetsProvider: ["Blow LTD"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  // Home Sanitize
  ProductData("", [StringData(code: "en", text: "Home Sanitization")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "We are bringing quality disinfection and sanitization services in your area to your doorstep. Our goal is to keep your home safe from virus, bacteria, and germs through certified disinfectant chemicals through best technic of fogging. Our Sanitization expert comes under PPE kit and take around 30 to 60 minutes to clear your residence from all harmful germs, bacteria and virus.")],
    assetsGallery: ["assets/ondemands/p40.jpg", "assets/ondemands/p41.jpg", "assets/ondemands/p42.jpg"],
    price: [PriceData([StringData(code: "en", text: "Home Sanitization")], 13, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    assetsCategory: ["Home Sanitize"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Office Sanitization")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "The Corona virus can survive on a surface for up to 14 days or more. That is why having a trusted professional to clean and disinfect your office space is important. At Zorgers, we believe in maintaining complete health protection which is why our office or workspace sanitation procedure follows strict guidelines as mentioned by the Health Ministry.")],
    assetsGallery: ["assets/ondemands/p41.jpg", "assets/ondemands/p40.jpg", "assets/ondemands/p42.jpg"],
    price: [PriceData([StringData(code: "en", text: "Office Sanitization")], 13, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    assetsCategory: ["Home Sanitize"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
  ProductData("", [StringData(code: "en", text: "Vehicle / Car Sanitization")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Disinfecting your vehicle to safeguard yourself your family from COVID-19 disease. Our Vehicle sanitization services through pumping disinfectant solution inside your car will kill the germs on surfaces and objects. Fogging technic for vehicle sanitization is available only in case of power supply access.")],
    assetsGallery: ["assets/ondemands/p41.jpg", "assets/ondemands/p40.jpg", "assets/ondemands/p42.jpg"],
    price: [PriceData([StringData(code: "en", text: "Vehicle / Car Sanitization")], 13, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    assetsCategory: ["Home Sanitize"],
    assetsProvider: ["Cleaning Services London"],
    tax: 12, category: [], providers: [], gallery: [],
    taxAdmin: 35,
    addon: [],
     timeModify: DateTime.now(), group: [],
  ),
];


/*
Categories:     provider
Home clean          1
Electrician         2   Cleaning Services London
Gardening           3
Carpenter           1   Happy House
Painter             1
Plumber             2
Movers              3   Blow LTD
Hair & Beauty       3   Blow LTD
Home Sanitize       2
 */