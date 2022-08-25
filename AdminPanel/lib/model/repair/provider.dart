import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<String?> repairProviders() async{
  try{
    double percentage = 0;
    var oneStep = 100/_provider.length;

    for (var item in _provider){

      var _data = item.toJson();
      var t = await FirebaseFirestore.instance.collection("provider").doc(item.id).get();

      dprint("set id=${item.id}");
      await FirebaseFirestore.instance.collection("provider").doc(item.id).set(_data);

      if (!t.exists){
        dprint("Not exist. +1");
        await FirebaseFirestore.instance.collection("settings").doc("main")
            .set({"provider_count": FieldValue.increment(1)}, SetOptions(merge:true));
      }
      percentage += oneStep;
      dprint("успешно ${percentage.toStringAsFixed(0)}%");
    }
  }catch(ex){
    return "repairProviders " + ex.toString();
  }
  return null;
}


// v2
List<ProviderData> _provider = [
  ProviderData(
    id: "cBRYvyykvJvs34U0FGAL",
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
    route: [
      LatLng(51.573540158564086, -0.22224733595626844),
      LatLng(51.610226428147165, -0.10551759962814344),
      LatLng(51.599138354995695, 0.015332009746828135),
      LatLng(51.565004221277306, 0.062023904278078135),
      LatLng(51.51888246146264, 0.056530740215578135),
      LatLng(51.4906739264999, -0.034106466815643444),
      LatLng(51.45902540678968, -0.09590456251876844),
      LatLng(51.47784609199277, -0.19890138869064344),
      LatLng(51.49238403179335, -0.26893923048751844),
    ],
    addon: [
      AddonData("2240", [StringData(code: "en", text: "deleting old")], 50),
      AddonData("2238", [StringData(code: "en", text: "garbage removal")], 50),
      AddonData("2239", [StringData(code: "en", text: "clearing the territory")], 50),
      AddonData("2237", [StringData(code: "en", text: "varnishing")], 50),
      AddonData("2223", [StringData(code: "en", text: "bathroom clean")], 10),
      AddonData("2224", [StringData(code: "en", text: "cleaning around the house")], 50),
      AddonData("2244", [StringData(code: "en", text: "garbage removal")], 50),
    ],
    workTime: [
      WorkTimeData(id: 0, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 1, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 2, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 3, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 4, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 5, openTime: "09:00", closeTime: "16:00", weekend: true),
      WorkTimeData(id: 6, openTime: "09:00", closeTime: "16:00", weekend: true),
    ],
    imageUpperLocalFile: "provider/547771f7-d651-4691-94a9-57bd90636881.jpg",
    imageUpperServerPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F547771f7-d651-4691-94a9-57bd90636881.jpg?alt=media&token=4007d1b6-ef0d-4bc3-8803-7a87e99a1a6c",
    logoLocalFile: "provider/b95bf320-543a-4733-a65d-281824371351.jpg",
    logoServerPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2Fb95bf320-543a-4733-a65d-281824371351.jpg?alt=media&token=523d0bf0-5ed0-4694-8a20-feb0b843a772",
    gallery: [
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F10583eac-0a62-44f5-8b7d-613b4cf06547.jpg?alt=media&token=b75c3773-8c65-4dd5-bf35-b0fa02bee6c5",
          localFile: "provider/10583eac-0a62-44f5-8b7d-613b4cf06547.jpg"),
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2Fb2c01c66-73b7-420f-ab37-738f8bfa5b32.jpg?alt=media&token=92a07435-673b-475b-99a4-42a705820a81",
          localFile: "provider/b2c01c66-73b7-420f-ab37-738f8bfa5b32.jpg"),
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F8c7cb5db-372b-4f32-9e4e-8997014ad467.jpg?alt=media&token=9913892f-1d24-4e13-ab3d-1dc98de953ec",
          localFile: "provider/8c7cb5db-372b-4f32-9e4e-8997014ad467.jpg"),
    ],
    category: [
      "eHkL0jNGXWMXts9yjE8H", // "Home clean",
      "7DIUCsVr6Nstlg4BP001", // "Carpenter",
      "tuo114vJC8Lg9YxZyqsp"  // "Painter"
    ], articles: [], subscriptions: [],
  ),
  ProviderData(
    id: "8fweWFLzESY0ht6TzLJb",
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
    route: [
      LatLng(51.54323032645531, -0.3949826023437595),
      LatLng(51.56628471404341, -0.5432980320312595),
      LatLng(51.634525421748265, -0.5158322117187595),
      LatLng(51.666903841018005, -0.4801266453125095),
      LatLng(51.69415194217143, -0.4348080417968845),
      LatLng(51.68649007097469, -0.3798764011718845),
      LatLng(51.65838544660496, -0.3414242527343845),
      LatLng(51.62790656036647, -0.2607232233891068),
      LatLng(51.59038138777104, -0.2167779108891068),
      LatLng(51.572460710336536, -0.1371270319828568),
      LatLng(51.52634651201806, -0.1082879206547318),
      LatLng(51.521219826655944, -0.0753289362797318),
      LatLng(51.48104082000022, -0.1124077937016068),
      LatLng(51.45366462865792, -0.1893120905766068),
      LatLng(51.44852976410385, -0.3513604304203568),
      LatLng(51.48702717248105, -0.4076653620609818),
    ],
    addon: [
      AddonData("2231", [StringData(code: "en", text: "taking out the trash")], 10),
      AddonData("2232", [StringData(code: "en", text: "trip to the store")], 50),
      AddonData("2248", [StringData(code: "en", text: "garbage removal")], 50),
    ],
    workTime: [
      WorkTimeData(id: 0, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 1, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 2, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 3, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 4, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 5, openTime: "09:00", closeTime: "16:00", weekend: true),
      WorkTimeData(id: 6, openTime: "09:00", closeTime: "16:00", weekend: true),
    ],
    gallery: [
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2Ff4a7a22f-ce42-40c6-9c37-456023d41db5.jpg?alt=media&token=269d4030-3764-4ac6-86f8-7457f995cc84",
          localFile: "provider/f4a7a22f-ce42-40c6-9c37-456023d41db5.jpg"),
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2Fcaccf7dd-a591-46f1-9734-e74fa591e57f.jpg?alt=media&token=04cde322-e2ff-41ef-acbc-0e731e3b7ced",
          localFile: "provider/caccf7dd-a591-46f1-9734-e74fa591e57f.jpg"),
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F3d0ac6bc-415b-41a2-b923-398d8ce865df.jpg?alt=media&token=e059e7b6-9300-45a1-99c1-5d95aa9a17db",
          localFile: "provider/3d0ac6bc-415b-41a2-b923-398d8ce865df.jpg"),
    ],
    category: [
      "S3vt97Lztg45uYcHzxDI", // "Electrician",
      "AyTkCVzNKj4G95fnacp5", // "Plumber",
      "N0oJyNp9RpV0m5OcZJR8" // "Home Sanitize"
    ], articles: [],
    imageUpperLocalFile: "provider/8904ba65-8639-4ba3-bd4b-b73265faef9a.jpg",
    imageUpperServerPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F8904ba65-8639-4ba3-bd4b-b73265faef9a.jpg?alt=media&token=facc2678-a4dd-48b8-a98e-e0d0c4b2ab7d",
    logoLocalFile: "provider/128f1ce0-b41d-4cd7-812d-3ac6e6cd17db.jpg",
    logoServerPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F128f1ce0-b41d-4cd7-812d-3ac6e6cd17db.jpg?alt=media&token=f9a4a5f8-7bf6-4cc7-9871-207b872d56d6", subscriptions: [],
  ),
  ProviderData(
    id: "Msxe6kYI9P348hAh0Alv",
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
    route: [
      LatLng(51.52908051863877, -0.1069146296391068),
      LatLng(51.59396468563542, -0.2057915827641068),
      LatLng(51.61187688315437, -0.0821953913578568),
      LatLng(51.60420109229279, -0.030010332764106806),
      LatLng(51.582872641218714, 0.053760419189018194),
      LatLng(51.5743384564701, 0.1375311711421432),
      LatLng(51.570924333838995, 0.2927130559077682),
      LatLng(51.49232872456664, 0.2789801457515182),
      LatLng(51.42473069792831, 0.2377814152827682),
      LatLng(51.38703774794196, 0.1979559758296432),
    ],
    addon: [
      AddonData("2252", [StringData(code: "en", text: "painting")], 20),
      AddonData("2253", [StringData(code: "en", text: "keratin")], 20),
      AddonData("2233", [StringData(code: "en", text: "visualization")], 10),
      AddonData("2251", [StringData(code: "en", text: "truck")], 250),
      AddonData("2234", [StringData(code: "en", text: "garbage removal")], 50),
      AddonData("2235", [StringData(code: "en", text: "garbage collection by truck")], 500),
      AddonData("2249", [StringData(code: "en", text: "boxes")], 50),
      AddonData("2236", [StringData(code: "en", text: "own water")], 50),
    ],
    workTime: [
      WorkTimeData(id: 0, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 1, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 2, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 3, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 4, openTime: "09:00", closeTime: "16:00", weekend: false),
      WorkTimeData(id: 5, openTime: "09:00", closeTime: "16:00", weekend: true),
      WorkTimeData(id: 6, openTime: "09:00", closeTime: "16:00", weekend: true),
    ],
    gallery: [
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F4db8c28e-a050-41ab-b0c6-44482be8d01b.jpg?alt=media&token=f4394d17-6c3b-4b90-ba70-5c63f1634e54",
          localFile: "provider/4db8c28e-a050-41ab-b0c6-44482be8d01b.jpg"),
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F86dc331a-3d67-48d2-a805-87c2a62e4dc8.jpg?alt=media&token=ba9fea8d-f0a1-490a-a0ee-476fd916f7f0",
          localFile: "provider/86dc331a-3d67-48d2-a805-87c2a62e4dc8.jpg"),
      ImageData(serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2Fe065c81a-d08d-4e71-bd2c-1f96c0b88105.jpg?alt=media&token=bfc32982-12d2-4dc3-88a9-04efa0816296",
          localFile: "provider/e065c81a-d08d-4e71-bd2c-1f96c0b88105.jpg"),
    ],
    imageUpperLocalFile: "provider/8893aadf-3f3f-4c60-b422-5d5778bb4a47.jpg",
    imageUpperServerPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F8893aadf-3f3f-4c60-b422-5d5778bb4a47.jpg?alt=media&token=69ef4163-bdc6-4fad-8b7b-ff5d09336a75",
    logoLocalFile: "provider/5f235fea-1e16-481d-902e-1f5fd29cb0a8.jpg",
    logoServerPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/provider%2F5f235fea-1e16-481d-902e-1f5fd29cb0a8.jpg?alt=media&token=017b9858-b969-47e8-9800-a76ff27ed3e5",
    category: [
      "7DIUCsVr6Nstlg4BPCbI", // "Gardening",
      "78ZYVdPDeCqjRBPtbvDF", // "Hair & Beauty",
      "2Lw7StfmJJtr0nyQcdbo" // "Movers"
    ], articles: [], subscriptions: [],
  ),
];
