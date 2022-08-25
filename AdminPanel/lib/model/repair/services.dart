import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> repairService() async{
  try{
    double percentage = 0;
    var oneStep = 100/_service.length;

    for (var item in _service){

      var _data = item.toJson();
      var t = await FirebaseFirestore.instance.collection("service").doc(item.id).get();

      dprint("set id=${item.id}");
      await FirebaseFirestore.instance.collection("service").doc(item.id).set(_data);

      if (!t.exists){
        dprint("Not exist. +1");
        await FirebaseFirestore.instance.collection("settings").doc("main")
            .set({"service_count": FieldValue.increment(1)}, SetOptions(merge:true));
      }
      percentage += oneStep;
      dprint("успешно ${percentage.toStringAsFixed(0)}%");
    }
  }catch(ex){
    return "repairService " + ex.toString();
  }
  return null;
}

List<ProductData> _service = [

  ProductData("jzJ0xWa6ZzrZiHXUgthO", [StringData(code: "en", text: "KERASTASE BLOW DRY + MAKEUP")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "From super sleek to bouncy blow dries and a flawless day makeup look to match, we'll create the perfect look for you using premium Kérastase products. To dial up your makeup look for the evening, select the ‘Upgrade to Glam’ add-on at checkout.")],
    // assetsGallery: ["assets/ondemands/p39.jpg", "assets/ondemands/p37.jpg", "assets/ondemands/p38.jpg"],
    price: [PriceData([StringData(code: "en", text: "KERASTASE BLOW DRY + MAKEUP")], 84, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    // assetsCategory: ["Hair & Beauty"],
    // assetsProvider: ["Blow LTD"],
    tax: 12,
    category: [
      "78ZYVdPDeCqjRBPtbvDF"
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv"
    ],
    gallery: [
      ImageData(localFile: "service/baac8374-9a6b-40a7-8540-762ae85507d3.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fbaac8374-9a6b-40a7-8540-762ae85507d3.jpg?alt=media&token=d73f930e-01b1-4312-aa8c-e8b69ad776b3"
      ),
      ImageData(localFile: "service/97cd6d35-2e23-4009-b461-2c40ceb1f566.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F97cd6d35-2e23-4009-b461-2c40ceb1f566.jpg?alt=media&token=06ecdaa1-96fe-400b-9c8a-2179ea00e269"
      ),
      ImageData(localFile: "service/dbdf0e15-4390-40d4-b6c2-8a0409f93ba3.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fdbdf0e15-4390-40d4-b6c2-8a0409f93ba3.jpg?alt=media&token=81bea19b-fbc0-401c-a25c-492d9eb15a5f"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2252", [StringData(code: "en", text: "painting")], 20),
      AddonData("2253", [StringData(code: "en", text: "keratin")], 20),
    ],
    timeModify: DateTime.now(), group: [],
  ),


  ProductData("bAureZ38kryvVNR66P3s", [StringData(code: "en", text: "Balcony Garden Design")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Balcony garden is a nw concept in urban areas to give lively look with natural plants and design elements.")],
    // assetsGallery: ["assets/ondemands/p22.jpg", "assets/ondemands/p23.jpg", "assets/ondemands/p24.jpg"],
    price: [PriceData([StringData(code: "en", text: "Balcony Garden Design")], 15, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Gardening"],
    // assetsProvider: ["Blow LTD"],
    tax: 12,
    category: [
      "7DIUCsVr6Nstlg4BPCbI"
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv"
    ],
    gallery: [
      ImageData(localFile: "service/08d0e85a-0469-4081-b6db-101302aaafa6.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F08d0e85a-0469-4081-b6db-101302aaafa6.jpg?alt=media&token=473133c2-e887-4665-96e1-cc8c83f617ab"
      ),
      ImageData(localFile: "service/14c23b7d-44ca-4cf6-8ea3-bfc6138daef4.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F14c23b7d-44ca-4cf6-8ea3-bfc6138daef4.jpg?alt=media&token=a20325d8-98a5-4c01-83a9-bbf5637b231d"
      ),
      ImageData(localFile: "service/aaa550d9-3432-4453-9577-957b3605d623.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Faaa550d9-3432-4453-9577-957b3605d623.jpg?alt=media&token=4f4310f3-f651-417e-9941-0f87a37475ed"
      ),
    ],
    taxAdmin: 15,
    addon: [
      AddonData("2233", [StringData(code: "en", text: "visualization")], 10),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("geMtkvWwtS2MoEQxKKO4", [StringData(code: "en", text: "KERASTASE UPDO + MAKEUP")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "From elegant to undone updos and a flawless day makeup look to match, we'll create the perfect look for you using premium Kérastase products. To dial up your makeup look for the evening, select the ‘Upgrade to Glam’ add-on at checkout.")],
    // assetsGallery: ["assets/ondemands/p38.jpg", "assets/ondemands/p37.jpg", "assets/ondemands/p39.jpg"],
    price: [PriceData([StringData(code: "en", text: "KERASTASE UPDO + MAKEUP")], 84, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    // assetsCategory: ["Hair & Beauty"],
    // assetsProvider: ["Blow LTD"],
    tax: 12,
    category: [
      "78ZYVdPDeCqjRBPtbvDF"
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv"
    ],
    gallery: [
      ImageData(localFile: "service/c1c56a2e-62a9-42e5-b0a6-13341c3d941e.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fc1c56a2e-62a9-42e5-b0a6-13341c3d941e.jpg?alt=media&token=d5ee1b9b-e053-4c93-9ed3-34d6aa540eb5"
      ),
      ImageData(localFile: "service/e51d86f8-7f29-4729-9b3a-adffd829ccd8.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fe51d86f8-7f29-4729-9b3a-adffd829ccd8.jpg?alt=media&token=f2f44aee-939b-4b04-a263-a867420409ff"
      ),
      ImageData(localFile: "service/7e8e7e11-031e-4d2e-99d0-f247c783fe91.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F7e8e7e11-031e-4d2e-99d0-f247c783fe91.jpg?alt=media&token=63e23ad4-aeeb-400a-86d8-8ea87ac649de"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2252", [StringData(code: "en", text: "painting")], 20),
      AddonData("2253", [StringData(code: "en", text: "keratin")], 20),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("tumfLTSPSBx2M2Oc8T9A", [StringData(code: "en", text: "Office Sanitization")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "The Corona virus can survive on a surface for up to 14 days or more. That is why having a trusted professional to clean and disinfect your office space is important. At Zorgers, we believe in maintaining complete health protection which is why our office or workspace sanitation procedure follows strict guidelines as mentioned by the Health Ministry.")],
    // assetsGallery: ["assets/ondemands/p41.jpg", "assets/ondemands/p40.jpg", "assets/ondemands/p42.jpg"],
    price: [PriceData([StringData(code: "en", text: "Office Sanitization")], 13, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    // assetsCategory: ["Home Sanitize"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "N0oJyNp9RpV0m5OcZJR8"
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "service/216fe11c-2648-4d0e-8fb8-b529a0b77ea2.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F216fe11c-2648-4d0e-8fb8-b529a0b77ea2.jpg?alt=media&token=7ee8ba75-9ae3-4461-bf86-921c292fa932"
      ),
      ImageData(localFile: "service/824c8246-d2fc-41ba-b281-94b9d1bc4787.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F824c8246-d2fc-41ba-b281-94b9d1bc4787.jpg?alt=media&token=f25a86a7-33bb-4540-8aa2-f3fd34bf35a6"
      ),
      ImageData(localFile: "service/6a530bbf-d000-4133-9442-605d41108b7f.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F6a530bbf-d000-4133-9442-605d41108b7f.jpg?alt=media&token=45b239c8-acf3-42ef-a35b-1106feb318a4"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2231", [StringData(code: "en", text: "taking out the trash")], 10),
      AddonData("2232", [StringData(code: "en", text: "trip to the store")], 50)
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("hnghzjg1aTTciOOhVCWm", [StringData(code: "en", text: "Wooden doors and windows repair")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Considering the amount of exposure to the elements wooden doors and windows get, wood door and window repair becomes a necessary requirement. Especially exterior wood door repair, since doors on the outside of our homes are worked the hardest and have to put up with all weather conditions. Enter HomeGenie – your answer to all wood door and window repair issues. ")],
    // assetsGallery: ["assets/ondemands/p27.jpg", "assets/ondemands/p26.jpg", "assets/ondemands/p25.jpg"],
    price: [PriceData([StringData(code: "en", text: "plus")], 300, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Carpenter"],
    // assetsProvider: ["Happy House"],
    tax: 12,
    category: [
      "7DIUCsVr6Nstlg4BP001"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/e3625471-077c-417b-adea-1e5ae8d1ae05.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fe3625471-077c-417b-adea-1e5ae8d1ae05.jpg?alt=media&token=50fed181-5a4b-48e1-a407-11c4482e4918"
      ),
      ImageData(localFile: "service/01eafebf-575d-473f-8dc6-4abce4706504.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F01eafebf-575d-473f-8dc6-4abce4706504.jpg?alt=media&token=dea09522-5d47-4989-b7a1-96ed63b8573d"
      ),
      ImageData(localFile: "service/d7b4f509-87e7-4123-8010-8b023c2b38d5.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fd7b4f509-87e7-4123-8010-8b023c2b38d5.jpg?alt=media&token=7114c197-1690-4924-9b3f-f06d3ffdfcce"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2240", [StringData(code: "en", text: "deleting old")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("MTt3IcFyuXqZ0a7HlJjL", [StringData(code: "en", text: "Vehicle / Car Sanitization")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Disinfecting your vehicle to safeguard yourself your family from COVID-19 disease. Our Vehicle sanitization services through pumping disinfectant solution inside your car will kill the germs on surfaces and objects. Fogging technic for vehicle sanitization is available only in case of power supply access.")],
    // assetsGallery: ["assets/ondemands/p41.jpg", "assets/ondemands/p40.jpg", "assets/ondemands/p42.jpg"],
    price: [PriceData([StringData(code: "en", text: "Vehicle / Car Sanitization")], 13, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    // assetsCategory: ["Home Sanitize"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "N0oJyNp9RpV0m5OcZJR8"
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "service/630250ca-e446-466a-90de-264ee321ba83.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F630250ca-e446-466a-90de-264ee321ba83.jpg?alt=media&token=fa819cdc-14e0-4dc1-88f1-31cf3cb0c4dd"
      ),
      ImageData(localFile: "service/93661e04-19a9-4ae1-b437-389a82fdb153.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F93661e04-19a9-4ae1-b437-389a82fdb153.jpg?alt=media&token=3528f493-f270-4eb3-aeb1-5500e22fa326"
      ),
      ImageData(localFile: "service/ce78800c-37bb-4dde-b263-da3a43586b8a.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fce78800c-37bb-4dde-b263-da3a43586b8a.jpg?alt=media&token=f96140a3-c479-413d-8e89-5ad4bd32aa9e"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2231", [StringData(code: "en", text: "taking out the trash")], 10),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("SNikx7XX6j3sYqE0CLAi", [StringData(code: "en", text: "Hair + Makeup")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Why not combine professional hairstyling with expert makeup application to achieve the perfect look? Our hair and makeup artists are the best in London with years of experience between them. Wherever you are in London, or whatever look you need, we have you covered.")],
    // assetsGallery: ["assets/ondemands/p37.jpg", "assets/ondemands/p38.jpg", "assets/ondemands/p39.jpg"],
    price: [PriceData([StringData(code: "en", text: "Hair + Makeup")], 10, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 10),
    // assetsCategory: ["Hair & Beauty"],
    // assetsProvider: ["Blow LTD"],
    tax: 12,
    category: [
      "78ZYVdPDeCqjRBPtbvDF"
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv"
    ],
    gallery: [
      ImageData(localFile: "service/cc2b0e36-0074-4760-a010-6d511d8b0c2c.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fcc2b0e36-0074-4760-a010-6d511d8b0c2c.jpg?alt=media&token=fc6c842a-3491-4b3d-b59e-b5900200a011"
      ),
      ImageData(localFile: "service/027b892e-26d4-4138-abbf-d29f234b8c6a.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F027b892e-26d4-4138-abbf-d29f234b8c6a.jpg?alt=media&token=fef79dcb-fb12-4fab-9952-dc1439ee8a57"
      ),
      ImageData(localFile: "service/56a16cce-5cc4-43e8-adb8-23fa8c7b926a.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F56a16cce-5cc4-43e8-adb8-23fa8c7b926a.jpg?alt=media&token=519ae87e-e736-4a75-a9ba-ad1fdf3ded7d"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2252", [StringData(code: "en", text: "painting")], 20),
      AddonData("2253", [StringData(code: "en", text: "keratin")], 20),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("tOZ0Xig66ai54Y3OldC8", [StringData(code: "en", text: "WATER HEATER MAINTENANCE")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Many homeowners don’t realize how important water heater maintenance is. Your water heater should be drained and cleaned out once a year. Minerals in the water build up and create sediment in the bottom of your tank. This sediment makes the water heat up slower and use more energy to keep the water in the tank warm. Not only will you have less hot water, your energy bills will be higher as well. ")],
    // assetsGallery: ["assets/ondemands/p33.jpg", "assets/ondemands/p31.jpg", "assets/ondemands/p32.jpg"],
    price: [PriceData([StringData(code: "en", text: "WATER HEATER MAINTENANCE")], 50, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Plumber"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "AyTkCVzNKj4G95fnacp5"
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "service/8397dbae-1a26-4b8a-9ff8-8c1ac72313b3.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F8397dbae-1a26-4b8a-9ff8-8c1ac72313b3.jpg?alt=media&token=b42e91b2-507f-4713-bcb1-510f21304e05"
      ),
      ImageData(localFile: "service/21519df7-5aef-4638-8eaa-22797ef6d80d.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F21519df7-5aef-4638-8eaa-22797ef6d80d.jpg?alt=media&token=a653090e-cead-4190-8925-df8c4b6c1085"
      ),
      ImageData(localFile: "service/4cade551-4064-4ad8-b75d-80ad6b7a5f2d.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F4cade551-4064-4ad8-b75d-80ad6b7a5f2d.jpg?alt=media&token=2a456503-9afe-4fc8-bbd1-a92d1bfd42bc"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2248", [StringData(code: "en", text: "garbage removal")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("zJu4mmmtMXeLWg9gDuzh", [StringData(code: "en", text: "Smart Meter Replacement")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Effective from 1 July 2016, Smart Meter Roll Out in NSW has been initiated by the Australian Government. Up until 1 December 2017, having a smart meter installed is voluntary for customers. From 1 December 2017, all new meters installed must be smart meters. ")],
    // assetsGallery: ["assets/ondemands/p21.jpg", "assets/ondemands/p20.jpg", "assets/ondemands/p19.jpg"],
    price: [PriceData([StringData(code: "en", text: "Smart Meter Replacement")], 20, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Electrician"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "S3vt97Lztg45uYcHzxDI"
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "service/261993cc-b260-4533-94fd-bcfe643b5344.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F261993cc-b260-4533-94fd-bcfe643b5344.jpg?alt=media&token=d84cdbb1-4bde-48f6-843e-a7a9405ab7b5"
      ),
      ImageData(localFile: "service/24383b7d-3d1a-4a58-b358-060453140fba.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F24383b7d-3d1a-4a58-b358-060453140fba.jpg?alt=media&token=868086be-5b73-4bff-b610-4bb0df2834ba"
      ),
      ImageData(localFile: "service/e8daaf87-8ba6-4dbe-8846-581d6f004e69.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fe8daaf87-8ba6-4dbe-8846-581d6f004e69.jpg?alt=media&token=cb30dc56-95ff-46fd-9502-9e12654a057c"
      ),
    ],
    taxAdmin: 15,
    addon: [
      AddonData("2231", [StringData(code: "en", text: "taking out the trash")], 10),
      AddonData("2232", [StringData(code: "en", text: "trip to the store")], 50)
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("hAv4bYSuJDWuHCuDqIVB", [StringData(code: "en", text: "Outdoor wooden storage fabrication")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Custom made wooden storage fabrication can help you add some storage space to your outdoor. However, it is not easy to find the carpenter who could provide you with the service you deserve.")],
    // assetsGallery: ["assets/ondemands/p26.jpg", "assets/ondemands/p25.jpg", "assets/ondemands/p27.jpg"],
    price: [PriceData([StringData(code: "en", text: "Outdoor wooden storage fabrication")], 300, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Carpenter"],
    // assetsProvider: ["Happy House"],
    tax: 12,
    category: [
      "7DIUCsVr6Nstlg4BP001"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/f3854f43-c9ff-4642-b4a6-c774d81972ce.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Ff3854f43-c9ff-4642-b4a6-c774d81972ce.jpg?alt=media&token=e8513eda-845d-490f-a85e-29c86ace899c"
      ),
      ImageData(localFile: "service/c6a319a5-e26d-478c-bba4-eeb21ba1f732.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fc6a319a5-e26d-478c-bba4-eeb21ba1f732.jpg?alt=media&token=fe830cce-09a8-40b0-9a4f-cfca60ed86b8"
      ),
      ImageData(localFile: "service/74b0734d-0e2f-4d44-999c-7a0520142b0c.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F74b0734d-0e2f-4d44-999c-7a0520142b0c.jpg?alt=media&token=793de3e0-2e40-4cba-a8c0-a992748c61d8"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2238", [StringData(code: "en", text: "garbage removal")], 50),
      AddonData("2239", [StringData(code: "en", text: "clearing the territory")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),
  ProductData("2z8zHMN9ZLPi0HUYzZ3F", [StringData(code: "en", text: "Heavy Furniture & Specialty Moves")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Find local movers to help with any oversized or specialty items you may need moved. You can find providers ready to safely move pianos, gun safes, large appliances, and more! Incorrectly moved oversized items, like safes and pianos, can pose a serious danger to you and your home. Let the experts take charge without breaking the bank or your back.")],
    // assetsGallery: ["assets/ondemands/p36.png", "assets/ondemands/p35.jpg", "assets/ondemands/p34.jpg"],
    price: [PriceData([StringData(code: "en", text: "Heavy Furniture & Specialty Moves")], 12, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Movers"],
    // assetsProvider: ["Blow LTD"],
    tax: 12,
    category: [
      "2Lw7StfmJJtr0nyQcdbo"
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv"
    ],
    gallery: [
      ImageData(localFile: "service/7c6f7a30-db28-4a54-93d7-7b50cfaadde8.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F7c6f7a30-db28-4a54-93d7-7b50cfaadde8.jpg?alt=media&token=3a4c3930-60e7-4737-8d2b-0c694f867e20"
      ),
      ImageData(localFile: "service/bb5c8f0a-a233-451e-8f47-1331fd380b00.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fbb5c8f0a-a233-451e-8f47-1331fd380b00.jpg?alt=media&token=4bb359a9-5b63-4141-9230-8c3dc8abcecb"
      ),
      ImageData(localFile: "service/d6723266-5956-413b-ad92-bbe30be7312e.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fd6723266-5956-413b-ad92-bbe30be7312e.jpg?alt=media&token=a3fcdda0-ec74-446a-b6a5-4e4202b0b683"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2251", [StringData(code: "en", text: "truck")], 250),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("MTS1cwF5EXGrHBrgoxrZ", [StringData(code: "en", text: "Home Sanitization")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "We are bringing quality disinfection and sanitization services in your area to your doorstep. Our goal is to keep your home safe from virus, bacteria, and germs through certified disinfectant chemicals through best technic of fogging. Our Sanitization expert comes under PPE kit and take around 30 to 60 minutes to clear your residence from all harmful germs, bacteria and virus.")],
    // assetsGallery: ["assets/ondemands/p40.jpg", "assets/ondemands/p41.jpg", "assets/ondemands/p42.jpg"],
    price: [PriceData([StringData(code: "en", text: "Home Sanitization")], 13, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 40),
    // assetsCategory: ["Home Sanitize"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "N0oJyNp9RpV0m5OcZJR8"
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "service/911acf2e-e96a-4df6-9e91-7feaa04df6d6.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F911acf2e-e96a-4df6-9e91-7feaa04df6d6.jpg?alt=media&token=7585b88a-528d-4a41-bc92-5eaea8ba100b"
      ),
      ImageData(localFile: "service/d74c7800-09e7-49b1-9008-dbb3b8819bb8.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fd74c7800-09e7-49b1-9008-dbb3b8819bb8.jpg?alt=media&token=7963d896-d0be-406a-9bfc-0d72c01b2294"
      ),
      ImageData(localFile: "service/06017618-2c46-4c05-b15c-c92f7d0e4c62.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F06017618-2c46-4c05-b15c-c92f7d0e4c62.jpg?alt=media&token=fe7f5bb8-e319-4637-a658-682f6ec044d5"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2231", [StringData(code: "en", text: "taking out the trash")], 10),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData(
    "rdONvG9tClE4y8ogNOpm",
    [StringData(code: "en", text: "Tree Surgery")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Entrust us with the well being of your woody plants, we guarantee you won’t regret it. The tree surgeons we send on site can help you with anything, ")],
    // assetsGallery: ["assets/ondemands/p23.jpg", "assets/ondemands/p22.jpg", "assets/ondemands/p24.jpg"],
    price: [PriceData([StringData(code: "en", text: "Tree Surgery")], 15, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    tax: 12,
    taxAdmin: 15,
    category: [
      "7DIUCsVr6Nstlg4BPCbI" // Gardening
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv" // "Blow LTD"
    ],
    gallery: [
      ImageData(localFile: "service/2347d52e-2c08-479f-986d-f6774198a9f1.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F2347d52e-2c08-479f-986d-f6774198a9f1.jpg?alt=media&token=99209b14-0eaf-4843-b332-bb6322a46276"
      ),
      ImageData(localFile: "service/550d10b0-7f2b-4df6-a83e-269a3d51ffc4.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F550d10b0-7f2b-4df6-a83e-269a3d51ffc4.jpg?alt=media&token=3e70bbef-c9a4-4eca-9c91-30631317cf34"
      ),
      ImageData(localFile: "service/11ea9e02-bac5-4406-a73d-67e12432385e.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F11ea9e02-bac5-4406-a73d-67e12432385e.jpg?alt=media&token=948562ab-4138-4e6f-807b-57de4fa08ebd"
      ),
    ],
    addon: [
      AddonData("2234", [StringData(code: "en", text: "garbage removal")], 50),
      AddonData("2235", [StringData(code: "en", text: "garbage collection by truck")], 500),
    ],
    timeModify: DateTime.now(), group: [],
  ),
  ProductData("s8gDZAA7iLUYrUhpQQPp", [StringData(code: "en", text: "EMERGENCY PLUMBING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Plumber Pro Service in Athens, GA provides full service plumbing maintenance & full service plumbing repairs to the entire Athens, Georgia region 24 hours a day, 7 days a week. Our licensed and insured Athens plumbers are available 24 hours a day to handle every type of plumbing emergency.")],
    // assetsGallery: ["assets/ondemands/p32.jpg", "assets/ondemands/p31.jpg", "assets/ondemands/p33.jpg"],
    price: [PriceData([StringData(code: "en", text: "EMERGENCY PLUMBING")], 50, 0, "fixed", ImageData()),],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Plumber"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "AyTkCVzNKj4G95fnacp5",  // Plumber
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "service/74f874aa-e96d-462f-9ea0-e2c8bb952d7c.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F74f874aa-e96d-462f-9ea0-e2c8bb952d7c.jpg?alt=media&token=a3d44fd5-9441-4334-acc8-30d96dc18acc"
      ),
      ImageData(localFile: "service/1b62adeb-8d6e-421a-9311-e4cd75aad6c0.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F1b62adeb-8d6e-421a-9311-e4cd75aad6c0.jpg?alt=media&token=435ae49d-2d64-4edd-a2eb-5c6045267beb"
      ),
      ImageData(localFile: "service/f5151084-bb95-4905-91c7-1be9a98a5517.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Ff5151084-bb95-4905-91c7-1be9a98a5517.jpg?alt=media&token=126980f7-cf29-4b56-89b9-6971b5ba46cc"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2248", [StringData(code: "en", text: "garbage removal")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),
  ProductData("kqND5tqfWOqOigscnOnn", [StringData(code: "en", text: "Loading & Unloading")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Get the most out of your U-Haul® truck rental, U-Box® storage container, or storage unit when you have your boxes, furniture, and appliances expertly loaded, leaving no wasted space. Moving Help® Service Providers will safely load and unload your items ensuring they arrive safely in your new home.")],
    // assetsGallery: ["assets/ondemands/p34.jpg", "assets/ondemands/p35.jpg", "assets/ondemands/p36.png"],
    price: [PriceData([StringData(code: "en", text: "Loading & Unloading")], 12, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Movers"],
    // assetsProvider: ["Blow LTD"],
    tax: 12,
    category: [
      "2Lw7StfmJJtr0nyQcdbo"
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv"
    ],
    gallery: [
      ImageData(localFile: "service/cf43635c-988f-4e03-9c30-5479efac5b11.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fcf43635c-988f-4e03-9c30-5479efac5b11.jpg?alt=media&token=d228b54f-e2d9-4f09-804b-3fc64986c173"
      ),
      ImageData(localFile: "service/19457ccd-58a7-4ddd-959c-c5754677cd9e.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F19457ccd-58a7-4ddd-959c-c5754677cd9e.jpg?alt=media&token=5ffa67ab-8c02-4c7a-b062-6339d3b1db70"
      ),
      ImageData(localFile: "service/1e5f0034-f37e-4414-bebe-cb977adcb3e3.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F1e5f0034-f37e-4414-bebe-cb977adcb3e3.jpg?alt=media&token=1b89e5c6-9fb0-4364-8b9a-6f2d45b00c9b"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2249", [StringData(code: "en", text: "boxes")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("FXNy5w12MlvMK6xjlEwZ", [StringData(code: "en", text: "Jet Washing")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Hire a jet cleaning service in London whether you are a landlord, leasing agent, householder or even part of an agency. As part of our pressure washing service, we remove dirt")],
    // assetsGallery: ["assets/ondemands/p24.jpg", "assets/ondemands/p23.jpg", "assets/ondemands/p22.jpg"],
    price: [PriceData([StringData(code: "en", text: "Jet Washing square meter")], 3, 0, "fixed", ImageData()),
      PriceData([StringData(code: "en", text: "Jet Washing more then 200 square meter")], 1, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Gardening"],
    // assetsProvider: ["Blow LTD"],
    tax: 12,
    category: [
      "7DIUCsVr6Nstlg4BPCbI"
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv"
    ], gallery: [
      ImageData(localFile: "service/6f585066-5a18-4783-886d-45721f80aa13.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F6f585066-5a18-4783-886d-45721f80aa13.jpg?alt=media&token=8d692038-04fb-4429-8cc0-eee98b0b6f93"
      ),
      ImageData(localFile: "service/795c5120-f983-4033-be20-64565890879f.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F795c5120-f983-4033-be20-64565890879f.jpg?alt=media&token=7c4a5595-d426-437f-890a-678aa6742080"
      ),
      ImageData(localFile: "service/6343b86f-4f9d-4904-9de2-45f809988d82.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F6343b86f-4f9d-4904-9de2-45f809988d82.jpg?alt=media&token=d00f16fb-3cd8-4e72-8f89-188c754c33b6"
      ),
    ],
    taxAdmin: 15,
    addon: [
      AddonData("2236", [StringData(code: "en", text: "own water")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("Bs73bMthxQhwcyp7KISD", [StringData(code: "en", text: "EXTERIOR HOUSE PAINTING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Never underestimate the impact a fresh, clean coat of paint can make to the outside of your home! It doesn’t matter if we’re working with stucco, brick, wood siding, vinyl, cedar shingles, or wood trim. WOW 1 DAY PAINTING’s expert exterior house painters have years of experience painting every kind of outdoor material:")],
    // assetsGallery: ["assets/ondemands/p28.jpg", "assets/ondemands/p29.jpg", "assets/ondemands/p30.jpg"],
    price: [PriceData([StringData(code: "en", text: "EXTERIOR HOUSE PAINTING")], 10, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Painter"],
    // assetsProvider: ["Happy House"],
    tax: 12,
    category: [
      "tuo114vJC8Lg9YxZyqsp"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/707c7bb0-5a7e-4909-bc06-3c57bde00d61.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F707c7bb0-5a7e-4909-bc06-3c57bde00d61.jpg?alt=media&token=fcbf745d-88a2-4171-9007-029f9d8d50c4"
      ),
      ImageData(localFile: "service/fce64a13-51e6-4e18-9305-bb454925603c.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Ffce64a13-51e6-4e18-9305-bb454925603c.jpg?alt=media&token=dd8a7851-5007-4c71-bb96-ad48820f9e3c"
      ),
      ImageData(localFile: "service/133eedd7-bb70-4f6e-a534-a860cbe5d17c.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F133eedd7-bb70-4f6e-a534-a860cbe5d17c.jpg?alt=media&token=dac23f4d-c7b0-42c5-88ab-fd17f1b0a102"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2240", [StringData(code: "en", text: "deleting old")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("vyb7Z6H5R7ZixQZeu0OX", [StringData(code: "en", text: "INTERIOR HOUSE PAINTING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "From lightening up a living room to a complete color overhaul, the impact a fresh coat of paint can have a huge impact on your home's interior! Taking weeks to try and do it all on your own can also have a huge impact—just not in a good way.")],
    // assetsGallery: ["assets/ondemands/p29.jpg", "assets/ondemands/p28.jpg", "assets/ondemands/p30.jpg"],
    price: [PriceData([StringData(code: "en", text: "INTERIOR HOUSE PAINTING")], 10, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Painter"],
    // assetsProvider: ["Happy House"],
    tax: 12,
    category: [
      "tuo114vJC8Lg9YxZyqsp"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/4871cd7e-1fd8-4ced-a7c8-9e1477fc0b66.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F4871cd7e-1fd8-4ced-a7c8-9e1477fc0b66.jpg?alt=media&token=5f34cd00-4401-4d7d-bb6a-0da45d95aa74"
      ),
      ImageData(localFile: "service/eb669733-5e26-4aba-b002-fdb6c4ec28f5.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Feb669733-5e26-4aba-b002-fdb6c4ec28f5.jpg?alt=media&token=d6617074-b785-441a-9a51-c7eac6d49f9f"
      ),
      ImageData(localFile: "service/04cb93a0-2136-4c1f-b393-dd1e32e1e4d7.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F04cb93a0-2136-4c1f-b393-dd1e32e1e4d7.jpg?alt=media&token=07721648-71a0-4fc2-94f8-e1d596a932ac"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2240", [StringData(code: "en", text: "deleting old")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),



  ProductData("iWQCL6TdhUSNh6zhQV3V", [StringData(code: "en", text: "Wooden cabinets and cupboards repair")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Wooden cabinets and cupboards are very handy in all homes, however, overuse can lead them to breakdown requiring some repair work, from time to time, to prevent any safety issues at home.")],
    // assetsGallery: ["assets/ondemands/p25.jpg", "assets/ondemands/p26.jpg", "assets/ondemands/p27.jpg"],
    price: [PriceData([StringData(code: "en", text: "Wooden cabinets and cupboards repair")], 300, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Carpenter"],
    // assetsProvider: ["Happy House"],
    tax: 12,
    category: [
      "7DIUCsVr6Nstlg4BP001"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/db003a8e-dfe0-4064-a2b7-2606023d3af1.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fdb003a8e-dfe0-4064-a2b7-2606023d3af1.jpg?alt=media&token=cb51433c-8684-40dc-94ae-3d4f7f0eaaab"
      ),
      ImageData(localFile: "service/72cae1c8-8cc9-496c-9e4a-4bba4be1ee19.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F72cae1c8-8cc9-496c-9e4a-4bba4be1ee19.jpg?alt=media&token=c56117cf-5d02-4c27-ae1b-5c9a504bb400"
      ),
      ImageData(localFile: "service/b8a7c89d-d28f-4c1a-a185-2e7513390114.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fb8a7c89d-d28f-4c1a-a185-2e7513390114.jpg?alt=media&token=4fcf3266-42f3-417e-b637-348cf3fc0a49"
      ),
    ],
    taxAdmin: 15,
    addon: [
      AddonData("2237", [StringData(code: "en", text: "varnishing")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("NS9ojhZGpgHo6brFfIPN", [StringData(code: "en", text: "Packing & Unpacking")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Moving Help® Service Providers offer packing services that will save you time and effort on moving day. Your mover will know the most effective and efficient ways to pack your dishware, televisions, books, clothes, and even your most fragile belongings. You can also book your moving company to unpack your moving boxes once you arrive at your destination so you can be fully moved in that much sooner!")],
    // assetsGallery: ["assets/ondemands/p35.jpg", "assets/ondemands/p34.jpg", "assets/ondemands/p36.png"],
    price: [PriceData([StringData(code: "en", text: "Packing & Unpacking")], 12, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Movers"],
    // assetsProvider: ["Blow LTD"],
    tax: 12,
    category: [
      "2Lw7StfmJJtr0nyQcdbo"
    ],
    providers: [
      "Msxe6kYI9P348hAh0Alv"
    ],
    gallery: [
      ImageData(localFile: "service/e2c78817-7d55-4227-a94f-7002e6641265.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fe2c78817-7d55-4227-a94f-7002e6641265.jpg?alt=media&token=b269e909-13ce-49a4-9acb-5e8f413e0c59"
      ),
      ImageData(localFile: "service/dedce11f-49b7-4cad-bd4e-dc16231fa4a6.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fdedce11f-49b7-4cad-bd4e-dc16231fa4a6.jpg?alt=media&token=4d2c8a01-5271-41ec-be5e-d4c9cba7ecae"
      ),
      ImageData(localFile: "service/e4c72adb-f921-48e9-a464-ad2c2a4f6c16.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fe4c72adb-f921-48e9-a464-ad2c2a4f6c16.jpg?alt=media&token=0308c83a-d9a0-4b1b-b614-83a06e2bd834"
      ),

    ],
    taxAdmin: 35,
    addon: [
      AddonData("2249", [StringData(code: "en", text: "boxes")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("CbyuP2hMbw6xBFdtPI61", [StringData(code: "en", text: "Happy House Home clean")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "The Happy House Cleaning provides wide range of cleaning services for domestic and commercial properties of any size and condition.")],
    // assetsGallery: ["assets/ondemands/p3.jpg", "assets/ondemands/p4.jpg", "assets/ondemands/p5.jpg"],
    price: [PriceData([StringData(code: "en", text: "Base price")], 19, 18, "fixed", ImageData())],
    duration: Duration(minutes: 20),
    // assetsCategory: ["Home clean"],
    // assetsProvider: ["Happy House"],
    tax: 10,
    category: [
      "eHkL0jNGXWMXts9yjE8H"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/6977064f-bfb2-4724-a147-6cb5701d0bc2.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F6977064f-bfb2-4724-a147-6cb5701d0bc2.jpg?alt=media&token=e521b56b-bf6c-4562-b25d-15ba74169408"
      ),
      ImageData(localFile: "service/85aa8418-3287-4375-a524-fbe8f2cbf9b2.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F85aa8418-3287-4375-a524-fbe8f2cbf9b2.jpg?alt=media&token=f1139b9a-e47c-45c7-8761-9be2fd8fdb56"
      ),
      ImageData(localFile: "service/8b14e4e8-8b7a-459b-9fa8-85bf62ca93fb.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F8b14e4e8-8b7a-459b-9fa8-85bf62ca93fb.jpg?alt=media&token=27521fc6-86eb-45f8-ae14-5165f4ce7ec2"
      ),
    ],
    taxAdmin: 6,
    addon: [
      AddonData("2223", [StringData(code: "en", text: "bathroom clean")], 10),
      AddonData("2224", [StringData(code: "en", text: "cleaning around the house")], 50)
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("iqRyVcb8MGr2iXC4lN6W", [StringData(code: "en", text: "Popular Cleanings")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Combining the best people with technology is a virtuous circle. Technology helps cleaners focus more on delivering a great experience, so they can do more in less time, which helps them earn more, which makes them happier, which makes clients happier, which helps them earn even more. It is a beautiful thing.")],
    // assetsGallery: ["assets/ondemands/p4.jpg", "assets/ondemands/p3.jpg", "assets/ondemands/p5.jpg"],
    price: [PriceData([StringData(code: "en", text: "1 Cleaner for 1 hour")], 50, 0, "fixed", ImageData()),
      PriceData([StringData(code: "en", text: "1 Cleaner for 2.5 hours")], 200, 0, "fixed", ImageData()),
      PriceData([StringData(code: "en", text: "1 Cleaner for 4 hours")], 300, 0, "fixed", ImageData())
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Home clean"],
    // assetsProvider: ["Happy House"],
    tax: 10,
    category: [
      "eHkL0jNGXWMXts9yjE8H"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/a12c5de5-94b8-49dc-98e3-4195c0c3a43f.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fa12c5de5-94b8-49dc-98e3-4195c0c3a43f.jpg?alt=media&token=4018116c-608d-43cd-86c3-33a3020624e5"
      ),
      ImageData(localFile: "service/4ec6c96d-b63e-485b-9a1a-3eb3c9a659a4.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F4ec6c96d-b63e-485b-9a1a-3eb3c9a659a4.jpg?alt=media&token=697b9c2a-51ed-48b4-b785-2aa4260b1460"
      ),
      ImageData(localFile: "service/3d63e347-3ecc-42b0-b005-7f599d13c552.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F3d63e347-3ecc-42b0-b005-7f599d13c552.jpg?alt=media&token=66975c77-3030-44a0-8bee-02882a927bbd"
      ),
    ],
    taxAdmin: 6,
    addon: [
      AddonData("2223", [StringData(code: "en", text: "bathroom clean")], 10),
      AddonData("2224", [StringData(code: "en", text: "cleaning around the house")], 50)
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("OYAYqFd6PF6IcnS326sY", [StringData(code: "en", text: "Deep Cleaning")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Simply Maid offers deep cleaning services that transform living spaces into immaculate ones! Our services cover all areas of home cleaning with many special, add-on services for a truly, thorough cleaning experience. What’s more, Simply Maid is made up of certified, vetted cleaners that possess the skill, know-how and experience to deep clean homes of all types and sizes!")],
    // assetsGallery: ["assets/ondemands/p16.jpg", "assets/ondemands/p17.jpg", "assets/ondemands/p18.jpg"],
    price: [PriceData([StringData(code: "en", text: "Lounge / Dining room (12x12 feet)")], 46, 40, "fixed", ImageData()),
      PriceData([StringData(code: "en", text: "Hallway (10x4 feet)")], 23, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Home clean"],
    // assetsProvider: ["Happy House"],
    tax: 10,
    category: [
      "eHkL0jNGXWMXts9yjE8H"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/490d55f0-34cf-4aa2-91b7-e1632b7898d3.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F490d55f0-34cf-4aa2-91b7-e1632b7898d3.jpg?alt=media&token=d906ccb7-4f34-4f89-b55b-948c1063cbe8"
      ),
      ImageData(localFile: "service/9942f154-5393-4c32-bc26-5cfbd11b9472.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F9942f154-5393-4c32-bc26-5cfbd11b9472.jpg?alt=media&token=6fc1ae9e-6093-4dae-8870-6707559bde3d"
      ),
      ImageData(localFile: "service/5c80f650-0dc8-4271-addf-e60e45a4973b.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F5c80f650-0dc8-4271-addf-e60e45a4973b.jpg?alt=media&token=1f687884-eb19-480b-a53d-1c0bb33b56ef"
      ),

    ],
    taxAdmin: 6,
    addon: [
      AddonData("2223", [StringData(code: "en", text: "bathroom clean")], 10),
      AddonData("2224", [StringData(code: "en", text: "cleaning around the house")], 50)
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("mOdu4J6QN4DmgPn6gNIT", [StringData(code: "en", text: "Level 2 Electrician")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Eris Electrical is an accredited Level 2 Electrician capable of handling network services that commence from the street and connect to your property. We provide superior electrical level 2 services to residential and commercial properties across Sydney. Eris Electrical is the preferred Level 2 electrical contractor in the western region of Sydney with qualified, trained, highly experienced and specialised level 2 electricians to serve you.")],
    // assetsGallery: ["assets/ondemands/p19.jpg", "assets/ondemands/p20.jpg", "assets/ondemands/p21.jpg"],
    price: [PriceData([StringData(code: "en", text: "Level 2 Electrician")], 20, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Electrician"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "S3vt97Lztg45uYcHzxDI"
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "service/743bd640-961f-4ea8-a396-f5e7f981f841.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F743bd640-961f-4ea8-a396-f5e7f981f841.jpg?alt=media&token=a052a6b5-f9d1-4203-8532-cfc1351e8530"
      ),
      ImageData(localFile: "service/ffecc464-5cea-4828-987a-9ad855e5b295.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fffecc464-5cea-4828-987a-9ad855e5b295.jpg?alt=media&token=a37b5feb-6fbf-4267-8c20-cabfd6926ff9"
      ),
      ImageData(localFile: "service/cd0c049f-b0c5-477e-8cfe-d8c6d4dd77d6.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fcd0c049f-b0c5-477e-8cfe-d8c6d4dd77d6.jpg?alt=media&token=08e34fc9-86ec-43fd-90b5-096c55d045ce"
      ),
    ],
    taxAdmin: 6,
    addon: [
      AddonData("2231", [StringData(code: "en", text: "taking out the trash")], 10),
      AddonData("2232", [StringData(code: "en", text: "trip to the store")], 50)
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("iaQy3oR5PRK7oDrdzLsI", [StringData(code: "en", text: "BRICK PAINTING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "When brick becomes faded or yellowed over time, it can make your home look a bit run down. Or you may not be a fan of the natural color of the brick on your home and want a more updated, modern look. The good news is that you’re not permanently stuck with the color of your brick! If you want to change things up, painting your brick is the best way to do it. ")],
    // assetsGallery: ["assets/ondemands/p30.jpg", "assets/ondemands/p29.jpg", "assets/ondemands/p28.jpg"],
    price: [PriceData([StringData(code: "en", text: "BRICK PAINTING")], 10, 0, "hourly", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Painter"],
    // assetsProvider: ["Happy House"],
    tax: 12,
    category: [
      "tuo114vJC8Lg9YxZyqsp"
    ],
    providers: [
      "cBRYvyykvJvs34U0FGAL"
    ],
    gallery: [
      ImageData(localFile: "service/bf4d7000-66b0-40ea-ae38-fbaadfe29d6a.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fbf4d7000-66b0-40ea-ae38-fbaadfe29d6a.jpg?alt=media&token=e9bd6497-3e5f-42b7-96ef-ae562e40fad9"
      ),
      ImageData(localFile: "service/3cc7d7d3-117a-43f6-ad54-25dce8599493.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2F3cc7d7d3-117a-43f6-ad54-25dce8599493.jpg?alt=media&token=eebc23d5-12a9-4d0f-a61e-0a7b9a80d159"
      ),
      ImageData(localFile: "service/adad15c5-ad57-4e9a-90c9-a65acb7c4c06.jpg",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fadad15c5-ad57-4e9a-90c9-a65acb7c4c06.jpg?alt=media&token=75c31ee3-960c-48ac-9fea-bbc100be2ff4"
      ),

    ],
    taxAdmin: 35,
    addon: [
      AddonData("2240", [StringData(code: "en", text: "deleting old")], 50),
      AddonData("2244", [StringData(code: "en", text: "garbage removal")], 50),
      AddonData("2239", [StringData(code: "en", text: "clearing the territory")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

  ProductData("U0h3QVoYdCtyMkaxdTAO", [StringData(code: "en", text: "Metering Services")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Eris Electrical Services provides customised offerings to energy retailers, electricity authorities, large commercial and industrial customers as well as consultants who form the complete metering value chain. We have a team of professionals who are highly experienced and skilled in mass meter replacements, meter breakdowns, and maintenance services. Our expert team is committed to ensuring the best safety levels are maintained while exceeding customer’s expectations and making sure optimal delivery is rendered.")],
    // assetsGallery: ["assets/ondemands/p20.jpg", "assets/ondemands/p19.jpg", "assets/ondemands/p21.jpg"],
    price: [PriceData([StringData(code: "en", text: "Metering Services")], 20, 0, "hourly", ImageData()),],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Electrician"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "S3vt97Lztg45uYcHzxDI"
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fp20.jpg?alt=media&token=0d7dc46a-afc3-4b0a-83c2-7fbfa7cd4f0e"
      ),
      ImageData(localFile: "",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fp19.jpg?alt=media&token=5a9ae6e7-fc5b-47b4-b625-7cd939a9dce3"
      ),
      ImageData(localFile: "",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fp21.jpg?alt=media&token=fa1c0fd7-f776-41b6-8d88-c8be5664a1a4"
      ),
    ],
    taxAdmin: 6,
    addon: [
      AddonData("2231", [StringData(code: "en", text: "taking out the trash")], 10),
      AddonData("2232", [StringData(code: "en", text: "trip to the store")], 50)
    ],
    timeModify: DateTime.now(), group: [],
  ),


  ProductData("3SIVcS6rbgSQHqTkBBWN", [StringData(code: "en", text: "DRAIN CLEANING")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: "Slow or clogged drains are no match for our team of certified drain cleaning professionals. We’ll clean your drain and make sure it keeps running that way long after we are gone. We have been providing professional drain cleaning services for many years, and we make sure that we clean your drains right, and get to the root of the problem.")],
    // assetsGallery: ["assets/ondemands/p31.jpg", "assets/ondemands/p32.jpg", "assets/ondemands/p33.jpg"],
    price: [PriceData([StringData(code: "en", text: "DRAIN CLEANING")], 50, 0, "fixed", ImageData()),
    ],
    duration: Duration(minutes: 60),
    // assetsCategory: ["Plumber"],
    // assetsProvider: ["Cleaning Services London"],
    tax: 12,
    category: [
      "AyTkCVzNKj4G95fnacp5"
    ],
    providers: [
      "8fweWFLzESY0ht6TzLJb"
    ],
    gallery: [
      ImageData(localFile: "",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fp33.jpg?alt=media&token=7e1a4255-c6e7-4393-bb38-2a6c97ab2b81"
      ),
      ImageData(localFile: "",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fp31.jpg?alt=media&token=904b4262-1173-4c98-9992-f24c109dfb8c"
      ),
      ImageData(localFile: "",
          serverPath: "https://firebasestorage.googleapis.com/v0/b/handymansuperapp123456.appspot.com/o/service%2Fp32.jpg?alt=media&token=41bc33e2-c8ca-4adf-a093-df3f8de2803c"
      ),
    ],
    taxAdmin: 35,
    addon: [
      AddonData("2248", [StringData(code: "en", text: "garbage removal")], 50),
    ],
    timeModify: DateTime.now(), group: [],
  ),

];