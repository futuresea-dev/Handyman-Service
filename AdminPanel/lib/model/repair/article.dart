import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> repairGetArticles() async {
  try{
    String _str = "";
    var querySnapshot = await FirebaseFirestore.instance.collection("article").get();
    for (var result in querySnapshot.docs) {
      var _data = result.data();
      var t = ProductData.fromJson(result.id, _data);

      String _gallery = "";
      for (var item in t.gallery)
        _gallery += '''
            ImageData(serverPath: "${item.serverPath}", localFile: ""), 
        ''';

      String _group = "";
      for (var item in t.group){
        String _price = "";
        for (var item2 in item.price)
          _price += '''
            PriceData(
                  [StringData(code: "en", text: "${item2.name[0].text}")],
                  ${item2.price}, ${item2.discPrice}, "${item2.priceUnit}",
                  ImageData(serverPath: "${item2.image.serverPath}", localFile: ""),   
                  ), 
          ''';

        _group += '''
            GroupData(id: "${item.id}", name: [StringData(code: "en", text: "${item.name[0].text}")], 
              price: [$_price], 
              ), 
        ''';
      }

      if (t.name.isNotEmpty)
        _str = '''
          var t = ProductData(
          "${t.id}", 
          [StringData(code: "en", text: "${t.name[0].text}")],
          descTitle: [StringData(code: "en", text: "${t.descTitle[0].text}")],
          desc: [StringData(code: "en", text: \'\'\'${t.desc[0].text}\'\'\')],
          tax: ${t.tax},
          taxAdmin: ${t.taxAdmin}, 
          providers: ["${t.providers[0]}"], 
          gallery: [$_gallery],
          group: [$_group],
          discPriceProduct: ${t.discPriceProduct},
         
          assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
          category: [],
          ), 
        ''';

      dprint(_str.toString());
    }

  }catch(ex){
    return "repairGetArticles " + ex.toString();
  }
  return null;
}


Future<String?> repairArticles() async{
  try{
    double percentage = 0;
    var oneStep = 100/_articles.length;

    for (var item in _articles){

      var _data = item.toJson();
      var t = await FirebaseFirestore.instance.collection("article").doc(item.id).get();

      dprint("set id=${item.id}");
      await FirebaseFirestore.instance.collection("article").doc(item.id).set(_data);
      await articleSaveInCache(item);

      if (!t.exists){
        dprint("Not exist. +1");
        await FirebaseFirestore.instance.collection("settings").doc("main")
            .set({"article_count": FieldValue.increment(1)}, SetOptions(merge:true));
      }
      percentage += oneStep;
      dprint("успешно ${percentage.toStringAsFixed(0)}%");
    }
  }catch(ex){
    return "repairOneArticle " + ex.toString();
  }
  return null;
}

var _happyHouse = "cBRYvyykvJvs34U0FGAL";
var _cleaningServicesLondon = "8fweWFLzESY0ht6TzLJb";
var _blowLTD = "Msxe6kYI9P348hAh0Alv";

var _articles = [
  ProductData(
    "OPwGtKEf85rBkufelQ1Z",
    [StringData(code: "en", text: "Interior decoration natural scenery handmade canvas high-quality oil ")],
    descTitle: [StringData(code: "en", text: "Dear Customer")],
    desc: [StringData(code: "en", text: '''
  <div class="origin-part box-sizing" data-spm-anchor-id="a2g0o.detail.1000023.i2.1cb77a820O4lUk"><h3><span style="color:rgb(244, 78, 59)" data-spm-anchor-id="a2g0o.detail.1000023.i0.1cb77a820O4lUk">Dear Customer:</span></h3><h3 data-spm-anchor-id="a2g0o.detail.1000023.i4.1cb77a820O4lUk"><span style="color:rgb(244, 78, 59)" data-spm-anchor-id="a2g0o.detail.1000023.i1.1cb77a820O4lUk">Welcome to our store !!</span></h3><h3><span style="color:rgb(244, 78, 59)">Very happy that you choose our products.</span></h3><h3><span style="color:rgb(244, 78, 59)">I hope you will have a happy time shopping </span></h3><p><strong>What&nbsp;you&nbsp;see&nbsp;is&nbsp;100%&nbsp;hand-painted&nbsp;oil&nbsp;paintings.&nbsp;</strong></p><p><strong>We&nbsp;have&nbsp;a&nbsp;group&nbsp;of&nbsp;experienced&nbsp;painters&nbsp;who&nbsp;can&nbsp;create&nbsp;more&nbsp;exquisite&nbsp;works&nbsp;for&nbsp;you.<br>What&nbsp;you&nbsp;see&nbsp;is&nbsp;the&nbsp;price&nbsp;of&nbsp;the&nbsp;oil&nbsp;painting,&nbsp;not&nbsp;including&nbsp;the&nbsp;frame.<br>We&nbsp;accept&nbsp;customized&nbsp;service,&nbsp;you&nbsp;can&nbsp;provide&nbsp;us&nbsp;with&nbsp;your&nbsp;picture,&nbsp;we&nbsp;will&nbsp;make&nbsp;it&nbsp;into&nbsp;oil&nbsp;painting&nbsp;according&nbsp;to&nbsp;your&nbsp;requirements.<br>Please&nbsp;contact&nbsp;us,&nbsp;we&nbsp;will&nbsp;try&nbsp;our&nbsp;best&nbsp;to&nbsp;serve&nbsp;you.&nbsp;Thank&nbsp;you&nbsp;very&nbsp;much!</strong></p><h1><span style="color:rgb(0, 98, 177)" data-spm-anchor-id="a2g0o.detail.1000023.i3.1cb77a820O4lUk">About&nbsp;the&nbsp;questions&nbsp;you&nbsp;want&nbsp;to&nbsp;know&nbsp;:</span><br><span style="color:rgb(244, 78, 59)">Material:</span>&nbsp;&nbsp;Oil&nbsp;on&nbsp;Cotton&nbsp;Canvas<br><span style="color:rgb(244, 78, 59)">Frame:</span>&nbsp;&nbsp;&nbsp;&nbsp;No&nbsp;frame(canvas&nbsp;only)<br><span style="color:rgb(211, 49, 21)">Packing:&nbsp;</span>Rolled&nbsp;canvas&nbsp;in&nbsp;tube<br><span style="color:rgb(211, 49, 21)">Type:&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;100%&nbsp;Handpainted<br><span style="color:rgb(211, 49, 21)">Shipping&nbsp;Way:&nbsp;</span>Free&nbsp;Shipping&nbsp;by&nbsp;ePacket/e-EMS/DHL<br><span style="color:rgb(244, 78, 59)">Shipping&nbsp;Time:</span>5-7days</h1><p><img src="https://ae01.alicdn.com/kf/H3efb73de951b4f90ae1a897fa5b58f50O.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H0d7d9d0b566e412793fc0e7d6b2b803bf.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H9951ddf4067f42999fb6d9f3ea81714fQ.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H9ffdcbd42bb6422ab3bea4e01f9ac4cbJ.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H6556dcee1fb84d77a73fa90647f63dd9l.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hbec7ec18ca7d4cab9f7f1d7a133cd1adw.jpg" slate-data-type="image"></p><p><img src="https://ae01.alicdn.com/kf/H94366429ebf748b8b4ab74a06c0c2683L.jpg" slate-data-type="image"></p><p><img width="848" height="741" src="https://ae01.alicdn.com/kf/Hc31735aa745742499fdec0ecb8bb28ceN.jpg" slate-data-type="image"><img width="846" height="846" src="https://ae01.alicdn.com/kf/H0a09386d2fbf4581bf91f91ea071ac0eY.jpg" slate-data-type="image"></p><p><img src="https://ae01.alicdn.com/kf/Hc2186a88427c4c159cd5e84b177978b6k.jpg" slate-data-type="image"><img width="849" height="556" src="https://ae01.alicdn.com/kf/H819185c5b47b4a4388b990be9bcba1feF.jpg" slate-data-type="image"></p><p><img width="834" height="438" src="https://ae01.alicdn.com/kf/Hfb4e8abb685f49c49a3a1cb30542105dN.jpg" slate-data-type="image"></p>
<script>window.adminAccountId=252540503;</script>
</div>
''')],
    tax: 10,
    taxAdmin: 7,
    providers: [_happyHouse],
    gallery: [
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H0d7d9d0b566e412793fc0e7d6b2b803bf/Interior-decoration-natural-scenery-handmade-canvas-high-quality-oil-painting-hanging-in-parlour-bedroom-hotel-restaurant.jpg_Q90.jpg_.webp", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H9951ddf4067f42999fb6d9f3ea81714fQ.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H6556dcee1fb84d77a73fa90647f63dd9l.jpg", localFile: ""),
    ],
    group: [GroupData(id: "dae829f1-7378-4402-a446-3204911788c1", name: [StringData(code: "en", text: "Type")],
      price: [PriceData(
        [StringData(code: "en", text: "1")],
          0, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/H0d7d9d0b566e412793fc0e7d6b2b803bf/Interior-decoration-natural-scenery-handmade-canvas-high-quality-oil-painting-hanging-in-parlour-bedroom-hotel-restaurant.jpg_50x50.jpg_.webp", localFile: ""),
          stock: 10,
        ),
        PriceData(
          [StringData(code: "en", text: "2")],
          5, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/H3efb73de951b4f90ae1a897fa5b58f50O/Interior-decoration-natural-scenery-handmade-canvas-high-quality-oil-painting-hanging-in-parlour-bedroom-hotel-restaurant.jpg_50x50.jpg_.webp", localFile: ""),
          stock: 10,
        ),
        PriceData(
          [StringData(code: "en", text: "3")],
          5, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/H5b1822b512844e94bc2c1d110edc8cc52/Interior-decoration-natural-scenery-handmade-canvas-high-quality-oil-painting-hanging-in-parlour-bedroom-hotel-restaurant.jpg_50x50.jpg_.webp", localFile: ""),
          stock: 20,
        ),
      ],
    ),
      GroupData(id: "5922e6e0-b905-4da0-ab9d-d11ae748e8d3", name: [StringData(code: "en", text: "Size")],
        price: [PriceData(
          [StringData(code: "en", text: "40cmx80cm")],
          0, 0, "+", ImageData(serverPath: "", localFile: ""),
          stock: 20,
        ),
          PriceData(
            [StringData(code: "en", text: "40cmx100cm")],
            4, 0, "+", ImageData(serverPath: "", localFile: ""),
            stock: 20,
          ),
          PriceData(
            [StringData(code: "en", text: "100cmx240cm")],
            12, 0, "+", ImageData(serverPath: "", localFile: ""),
            stock: 20,
          ),
        ],
      ),
    ],
    priceProduct: 33.66,
    discPriceProduct: 21.99,
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),


  // 2
  ProductData(
    "QXr4AJNJGjYd5UbD5VV7",
    [StringData(code: "en", text: "Sleep Game Repeat Gaming Wall Art Poster Prints Gamer Canvas Painting Canva")],
    descTitle: [StringData(code: "en", text: "Remind our customers about something Important")],
    desc: [StringData(code: "en", text: '''<div id="product-description" data-spm="1000023" class="product-description"><div class="origin-part box-sizing"><p style="padding: 0px; margin: 0px; box-sizing: border-box; font-size: 13px; line-height: 16.9px; font-weight: 400; color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); font-family: arial, helvetica, sans-serif; border: 0px; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-size: 22px;"><span data-spm-anchor-id="a2g0o.detail.1000023.i0.d66b1672yM2ldw" style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-style: inherit; font-weight: inherit;">Remind our customers about something Important<br style="padding: 0px; margin: 0px; box-sizing: border-box;">
<br style="padding: 0px; margin: 0px; box-sizing: border-box;">
1.<span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;">&nbsp;</span></span></span><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; color: rgb(255, 255, 255);"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-size: 22px;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;"><span data-spm-anchor-id="a2g0o.detail.1000023.i0.517229c5vYXZhr" style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; background-color: rgb(255, 51, 51);">The poster will come without white border,If you need,please leave a message to us.</span></span></span></span></span></p>

<p style="padding: 0px; margin: 0px; box-sizing: border-box; font-size: 13px; line-height: 16.9px; font-weight: 400; color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); font-family: arial, helvetica, sans-serif; border: 0px; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-size: 22px;"><span data-spm-anchor-id="a2g0o.detail.1000023.i0.d66b1672yM2ldw" style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-style: inherit; font-weight: inherit;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; background-color: rgb(231, 76, 60);"></span></span></span></p>

<p style="padding: 0px; margin: 0px; box-sizing: border-box; font-size: inherit; line-height: inherit; font-weight: inherit; color: rgb(0, 0, 0); font-style: inherit; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); font-family: arial, helvetica, sans-serif; border: 0px; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-size: 22px;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;">2.&nbsp;<span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;">This is unframed canvas rolled, no outside frame and no inside frame.&nbsp;</span></span></span></span></p>

<p style="padding: 0px; margin: 0px; box-sizing: border-box; font-size: inherit; line-height: inherit; font-weight: inherit; color: rgb(0, 0, 0); font-style: inherit; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); font-family: arial, helvetica, sans-serif; border: 0px; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-size: 22px;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;"></span></span></span></p>

<p style="padding: 0px; margin: 0px; box-sizing: content-box; font-size: 13px; line-height: inherit; font-weight: 400; color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); border: 0px; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: 20px; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; font-weight: 700;">3.&nbsp;</span></span><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px none; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;"><span data-spm-anchor-id="a2g0o.detail.1000023.i1.526e6843UHO9ji" style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px none; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;">Due to different lighting effects between computer monitors, cell phone,&nbsp;</span></span></span></span><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px none; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px none; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;">the color of objects will be a little different from show pictures in o</span></span><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;">ur&nbsp;</span><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px none; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;">store.</span></span></span></p>

<p style="padding: 0px; margin: 0px; box-sizing: content-box; font-size: 13px; line-height: inherit; font-weight: 400; color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); border: 0px; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; font-weight: 700;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: 20px; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px none; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;">4.&nbsp;</span></span></span></span><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: 20px; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px none; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;">The painting is not handmade, it is printed by machine.</span></span></span></p>

<p style="padding: 0px; margin: 0px; box-sizing: content-box; font-size: 13px; line-height: inherit; font-weight: 400; color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); border: 0px; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; font-weight: 700;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: 20px; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px none; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; vertical-align: baseline;">5.&nbsp;</span></span></span></span><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: 20px; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; font-family: arial, helvetica, sans-serif; vertical-align: baseline;">If you need other bigger sizes, please contact us.</span></span></p>

<p data-spm-anchor-id="a2g0o.detail.1000023.i0.526e6843UHO9ji" style="padding: 0px; margin: 0px; box-sizing: content-box; font-size: 13px; line-height: inherit; font-weight: 400; color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; background-color: rgb(255, 255, 255); border: 0px; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: 20px; line-height: inherit; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; border: 0px; font-style: inherit; font-weight: inherit; font-size: inherit; line-height: inherit; font-family: arial, helvetica, sans-serif; vertical-align: baseline;"><span style="padding: 0px; margin: 0px; box-sizing: content-box; max-width: 100%; word-break: break-word; font-weight: 700;">6.<span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; color: rgb(51, 51, 51); font-family: arial, verdana, sans-serif; font-size: 22px;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-style: inherit; font-weight: inherit; color: rgb(0, 0, 0); font-family: arial, helvetica, sans-serif;">1 inches=2.54 cm</span></span></span></span></span></p>

<p style="padding: 0px; margin: 0px; box-sizing: border-box; font-size: 14px; line-height: inherit; font-weight: 400; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; text-align: left;">&nbsp;</p>
<span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; color: rgb(0, 0, 0); font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; text-align: left; background-color: rgb(255, 255, 255); font-family: arial, helvetica, sans-serif;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; color: rgb(0, 0, 0);"><strong style="padding: 0px; margin: 0px; box-sizing: border-box; font-weight: 700 !important;"><span data-spm-anchor-id="a2g0o.detail.1000023.i2.41a71236nffRBx" style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-size: 28px;">About Size:</span></strong></span></span>

<p style="text-align: left;margin:0;"><img src="https://ae01.alicdn.com/kf/H2dcd5dafa2434bb09ce672d359805489H.jpg?width=800&amp;height=800&amp;hash=1600"></p>
<strong><span style="font-size:20px;"><span style="font-family:Arial,Helvetica,sans-serif;"><span style="font-size:20px;"><span style="font-family:Arial,Helvetica,sans-serif;"></span></span></span></span></strong>

<p style="text-align: left;margin:0;"><img src="https://ae01.alicdn.com/kf/He24f9bce6d374356b9607865b3a9b02cn.jpg?width=800&amp;height=775&amp;hash=1575"><br>
<span style="font-size:28px;"><strong><span style="font-family:Arial,Helvetica,sans-serif;"><span style="font-family:Arial,Helvetica,sans-serif;"><strong><span style="font-family:Arial,Helvetica,sans-serif;"><span style="font-family:Arial,Helvetica,sans-serif;">Product Show</span></span></strong></span></span></strong> </span><br>
<img src="https://ae01.alicdn.com/kf/H32aec473f26f4429a770995938782193Q.jpg?width=800&amp;height=800&amp;hash=1600" data-spm-anchor-id="a2g0o.detail.1000023.i0.294a5660AMxQTv"><img src="https://ae01.alicdn.com/kf/H622eda65a8e24f6a9ffaae06c127e13ca.jpg?width=800&amp;height=800&amp;hash=1600" data-spm-anchor-id="a2g0o.detail.1000023.i1.294a5660AMxQTv"><img src="https://ae01.alicdn.com/kf/Hf7b804004abc49769f586843afab66921.jpg?width=800&amp;height=800&amp;hash=1600"><img src="https://ae01.alicdn.com/kf/H606993edd6bd46bdadac32fbd794e926W.jpg?width=800&amp;height=800&amp;hash=1600" data-spm-anchor-id="a2g0o.detail.1000023.i2.294a5660AMxQTv"></p>
<span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"></span>

<p style="padding: 0px; margin: 0px; box-sizing: border-box; font-size: 14px; line-height: inherit; font-weight: 400; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; text-align: left;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; font-family: &quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti; font-weight: 700 !important;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-size: 28px;"><span data-spm-anchor-id="a2g0o.detail.1000023.i0.41a71236nffRBx" style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word; font-family: arial, helvetica, sans-serif;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;"><span style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;"><span style="padding: 0px; margin: 0px; box-sizing: border-box;"><span data-spm-anchor-id="a2g0o.detail.1000023.i2.41a71236nffRBx" style="padding: 0px; margin: 0px; box-sizing: border-box; max-width: 100%; word-break: break-word;">About Details:</span></span></span></span></span></span></span></p>
<span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"></span>

<p style="padding: 0px; margin: 0px; box-sizing: border-box; font-size: 14px; line-height: inherit; font-weight: 400; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; text-align: left;"><img src="https://ae01.alicdn.com/kf/H55bda31bdc824371a9578f383854b319S.jpg?width=800&amp;height=800&amp;hash=1600" style="padding: 0px; margin: 0px; box-sizing: border-box; border-style: none; vertical-align: middle; max-width: 100%;"><img src="https://ae01.alicdn.com/kf/Ha52179775a18466d85c52cd40cfae417t.jpg?width=800&amp;height=800&amp;hash=1600" style="padding: 0px; margin: 0px; box-sizing: border-box; border-style: none; vertical-align: middle; max-width: 100%;"><br>
<span style="font-size:28px;"><strong><span style="font-family:Arial,Helvetica,sans-serif;"><span style="font-family:Arial,Helvetica,sans-serif;"><strong><span style="font-family:Arial,Helvetica,sans-serif;"><span style="font-family:Arial,Helvetica,sans-serif;">About Shipping</span></span></strong></span></span></strong> </span></p>
<img src="https://ae01.alicdn.com/kf/H25b645e43c5449228160aecf4f2704f82.jpg?width=800&amp;height=555&amp;hash=1355" style="padding: 0px; margin: 0px; box-sizing: border-box; border-style: none; vertical-align: middle; max-width: 100%; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial;"><br style="padding: 0px; margin: 0px; box-sizing: border-box; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial;">
<img src="https://ae01.alicdn.com/kf/Hefa4b6a6d61947108774ac4e2a5a37ccO.jpg?width=800&amp;height=435&amp;hash=1235" style="padding: 0px; margin: 0px; box-sizing: border-box; border-style: none; vertical-align: middle; max-width: 100%; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial;"><span style="color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"></span>

<p data-spm-anchor-id="a2g0o.detail.1000023.i5.69dc677cb7HjMt" style="padding: 0px; margin: 0px; box-sizing: border-box; font-size: 14px; line-height: inherit; font-weight: 400; color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; font-family: &quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti; background-color: rgb(255, 255, 255); text-align: left;"><img src="https://ae01.alicdn.com/kf/H3253412672da4af28cc63e16e81962b8Z.jpg?width=800&amp;height=410&amp;hash=1210" style="padding: 0px; margin: 0px; box-sizing: border-box; border-style: none; vertical-align: middle; max-width: 100%;"></p>

<script>window.adminAccountId=251214720;</script>
</div></div>''')],
    tax: 10,
    taxAdmin: 6,
    providers: [_happyHouse],
    gallery: [            ImageData(serverPath: "https://ae01.alicdn.com/kf/H32aec473f26f4429a770995938782193Q.jpg?width=800&height=800&hash=1600", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H622eda65a8e24f6a9ffaae06c127e13ca.jpg?width=800&height=800&hash=1600", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H606993edd6bd46bdadac32fbd794e926W.jpg?width=800&height=800&hash=1600", localFile: ""),
    ],
    group: [GroupData(id: "5067e649-930c-4957-970c-146a0aa4db49", name: [StringData(code: "en", text: "Type")],
      price: [PriceData(
        [StringData(code: "en", text: "AC359-20")],
        0, 0, "+",
        ImageData(serverPath: "https://ae01.alicdn.com/kf/H8bd9a9a37cbc4f978de0248480c1d1e4F/Sleep-Game-Repeat-Gaming-Wall-Art-Poster-Prints-Gamer-Canvas-Painting-Canvas-Picture-for-Kids-Boys.jpg_50x50.jpg_.webp", localFile: ""),
        stock: 20,
      ),
        PriceData(
          [StringData(code: "en", text: "AC359-2")],
          0, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/H52f37fafeb124a788c4c755f39cb90369/Sleep-Game-Repeat-Gaming-Wall-Art-Poster-Prints-Gamer-Canvas-Painting-Canvas-Picture-for-Kids-Boys.jpg_50x50.jpg_.webp", localFile: ""),
          stock: 20,
        ),
        PriceData(
          [StringData(code: "en", text: "AC359-3")],
          0, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/H9b3a43a6354a47d6b308692dc2f77d73K/Sleep-Game-Repeat-Gaming-Wall-Art-Poster-Prints-Gamer-Canvas-Painting-Canvas-Picture-for-Kids-Boys.jpg_50x50.jpg_.webp", localFile: ""),
          stock: 20,
        ),
      ],
    ),
      GroupData(id: "fae79900-f5ad-4780-b1a7-2c6725a712cf", name: [StringData(code: "en", text: "Size ")],
        price: [            PriceData(
          [StringData(code: "en", text: "20X30cm Unframed")],
          0, 0, "+",
          ImageData(serverPath: "", localFile: ""),
          stock: 20,
        ),
          PriceData(
            [StringData(code: "en", text: "30X40cm Unframed")],
            5, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 20,
          ),
          PriceData(
            [StringData(code: "en", text: "70X100cm Unframed")],
            7, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 10,
          ),
        ],
      ),
    ],
    priceProduct: 5.66,
    discPriceProduct: 2.88,

    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),

  // 3
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ6nd",
    [StringData(code: "en", text: "240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''<div class="origin-part box-sizing"><p><b data-spm-anchor-id="a2g0o.detail.1000023.i3.4fb272618hTP6g">Description:</b></p><p data-spm-anchor-id="a2g0o.detail.1000023.i4.4fb272618hTP6g">Steel Frame with Chrome plating provides durability with reduced chance for rust<br>Use with foam, Flock, fabric. Any Type of cover imaginable <br>Great For Smaller Areas &amp; Precision Work<br>Length: approx.240mm/9.44 inch Paint Roller Handle<br>Material: Plastic &amp; iron</p><p><b>Specification:</b></p><p>Material: Plastic &amp; iron<br>Color: Red<br>Size(LxW): approx.240x50mm/9.44x1.96 inch</p><p><b>Package Includes:</b></p><p>1 Piece Paint Roller Handle<br></p><p><span style="font-size: 16px;"><img alt="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" height="1024" src="https://ae01.alicdn.com/kf/Hff0460409c854732a8a1691c57eec7653.jpg" width="1024" title="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" data-spm-anchor-id="a2g0o.detail.1000023.i0.4fb272618hTP6g"></span></p><p><span style="font-size: 16px;"><img alt="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" height="1024" src="https://ae01.alicdn.com/kf/Hf0525f6de0b94e8aad701e9251a2534c4.jpg" width="1024" title="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" data-spm-anchor-id="a2g0o.detail.1000023.i1.4fb272618hTP6g"></span></p><p><span style="font-size: 16px;"><img alt="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" height="1024" src="https://ae01.alicdn.com/kf/Hf9be6507699a4e4da1a7656c073f02caH.jpg" width="1024" title="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" data-spm-anchor-id="a2g0o.detail.1000023.i2.4fb272618hTP6g"></span></p><p><span style="font-size: 16px;"><img alt="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" height="1024" src="https://ae01.alicdn.com/kf/Ha966601666b544e485a38d82edeb56e42.jpg" width="1024" title="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame"></span></p><p><span style="font-size: 16px;"><img alt="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" height="1024" src="https://ae01.alicdn.com/kf/He49667e97036473dba84dbb525fd2d52r.jpg" width="1024" title="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame"></span></p><p><span style="font-size: 16px;"><img alt="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame" height="1024" src="https://ae01.alicdn.com/kf/H8bf9ff050b8946d596d49a2f2ccfc6b34.jpg" width="1024" title="240mm Small Paint Roller, Mini Paint Roller, House Painting Supplies, Paint Roller Covers, Roller Frame"></span></p>
<script>window.adminAccountId=238126984;</script>
</div>''')],
    tax: 10,
    taxAdmin: 0,
    providers: [_happyHouse],
    gallery: [            ImageData(serverPath: "https://ae01.alicdn.com/kf/Hff0460409c854732a8a1691c57eec7653.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Hf0525f6de0b94e8aad701e9251a2534c4.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Hf9be6507699a4e4da1a7656c073f02caH.jpg", localFile: ""),
    ],
    group: [],
    priceProduct: 1.12,
    discPriceProduct: 0.6,
    stock: 10,
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
  ),


// 4
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ004",
    [StringData(code: "en", text: "Semi-Circular Woodworking Chisel Set Chrome Vanadium Steel Carpenter")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
    <div class="detail-desc-decorate-richtext"><p><br><span style="background-color:rgb(255, 255, 255);color:rgb(56, 56, 56);font-size:13px;font-family:Tahoma"><strong data-spm-anchor-id="a2g0o.detail.1000023.i0.4c1e201cSajGiz">Features:</strong></span><br></p>
<div style="font-family:Tahoma;font-size:13px;font-weight:400;letter-spacing:normal;text-align:left;white-space:normal;color:rgb(56, 56, 56);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px;z-index:1" align="left">
 <ul style="margin:0px 0px 0px 30px;margin-bottom:0px;margin-top:0px;margin-left:30px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px">
  <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>The semi-circular chisel is forged from high quality chrome vanadium steel with high hardness (HRC58-62 degree)and wear resistance .<br></p></li>
  <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>Ergonomically designed handle, non-slip and comfortable to hold for long hours of work.</p></li>
 </ul>
 <div>
  <br>
 </div>
 <ul style="margin:0px 0px 0px 30px;margin-bottom:0px;margin-top:0px;margin-left:30px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px">
  <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>The tail of the handle is reinforced with steel hoops and is more resistant to gravity.</p></li>
  <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>The semi-circular chisel is designed with a curved shape for better chip removal performance.</p></li>
  <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>The cutting edge is made of high frequency quenching, which is sharp and durable!</p></li>
  <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>Uses: Suitable for woodworking, engraving, wood opening, trimming, etc.</p></li>
 </ul>
</div>
<p style="font-family:Tahoma;font-size:13px;font-weight:400;letter-spacing:normal;text-align:left;white-space:normal;color:rgb(56, 56, 56);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 10px;padding-bottom:10px;padding-top:0px;padding-left:0px;padding-right:0px" align="left"><strong><br></strong></p>
<p style="font-family:Tahoma;font-size:13px;font-weight:400;letter-spacing:normal;text-align:left;white-space:normal;color:rgb(56, 56, 56);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 10px;padding-bottom:10px;padding-top:0px;padding-left:0px;padding-right:0px" align="left"><strong><span style="color:rgb(229, 51, 51)">Notice:</span></strong></p>
<ul style="font-family:Tahoma;font-size:14px;font-weight:400;letter-spacing:normal;text-align:left;white-space:normal;color:rgb(56, 56, 56);background-color:rgb(255, 255, 255);margin:0px 0px 0px 20px;margin-bottom:0px;margin-top:0px;margin-left:20px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px" align="left">
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p><span style="color:rgb(229, 51, 51)">The surface of the semi-circular chisel is coated with a protective paint, the paint will be removed with using but it does not affect normal use.</span></p></li>
</ul>
<br>
<p style="font-family:Tahoma;font-size:13px;font-weight:400;letter-spacing:normal;text-align:left;white-space:normal;color:rgb(56, 56, 56);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 10px;padding-bottom:10px;padding-top:0px;padding-left:0px;padding-right:0px" align="left"><strong>Specifications:</strong></p>
<p><br></p>
<ul style="font-family:Tahoma;font-size:13px;font-weight:400;letter-spacing:normal;text-align:left;white-space:normal;color:rgb(56, 56, 56);background-color:rgb(255, 255, 255);margin:0px 0px 0px 30px;margin-bottom:0px;margin-top:0px;margin-left:30px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px" align="left">
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>Material: Chrome Vanadium Steel</p></li>
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p><br></p></li>
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>Blade Width--Handle Width--Total Length---Net Weight</p></li>
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>001 : 8mm(5/16")----30mm----280mm----0.127kg</p></li>
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>002: 12mm(1/2")-----30mm----280mm----0.141kg</p></li>
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>003: 18mm(3/4")----30mm----300mm----0.206kg</p></li>
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p>004: 25mm(1")----30mm---310mm----0.228kg<br></p></li>
</ul>
<p><br><span style="background-color:rgb(255, 255, 255);color:rgb(56, 56, 56);font-size:13px;font-family:Tahoma"><strong>Package Included:</strong></span><br><br></p>
<ul style="font-family:Tahoma;font-size:13px;font-weight:400;letter-spacing:normal;text-align:left;white-space:normal;color:rgb(56, 56, 56);background-color:rgb(255, 255, 255);margin:0px 0px 0px 30px;margin-bottom:0px;margin-top:0px;margin-left:30px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px" align="left">
 <li style="margin:2px 0px 0px;margin-bottom:0px;margin-top:2px;margin-left:0px;margin-right:0px;padding:2px 2px 2px 2em;padding-bottom:2px;padding-top:2px;padding-left:2em;padding-right:2px"><p style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 10px;padding-bottom:10px;padding-top:0px;padding-left:0px;padding-right:0px" class="MsoNormal"><span>1pc Semi-Circular Woodworking Chisel or 1 sets Semi-Circular Woodworking Chisel</span></p></li>
</ul>
<p style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 10px;padding-bottom:10px;padding-top:0px;padding-left:0px;padding-right:0px" class="MsoNormal"><span></span><img src="https://ae01.alicdn.com/kf/H815d3bd91dbf4ffbba8ec926ef3dcf5fN.jpg" slate-data-type="image"><span></span><img src="https://ae01.alicdn.com/kf/H41fdc9a3c83c43ea85bbce4a3b6d624aF.jpg" slate-data-type="image"><span></span><img src="https://ae01.alicdn.com/kf/Hcbbb679e61f74f82a7edfc0107c11a9dz.jpg" slate-data-type="image"><span></span><img src="https://ae01.alicdn.com/kf/H30e1733fe574442aa4c2e5b49c57e8f7A.jpg" slate-data-type="image"><span></span><img src="https://ae01.alicdn.com/kf/H993e57c66e9e431da210632ad34c0b11w.jpg" slate-data-type="image"><span></span><img src="https://ae01.alicdn.com/kf/Hfa8c1d2030d54035840b9dbdf10b2cdfl.jpg" slate-data-type="image"><span></span><img src="https://ae01.alicdn.com/kf/Ha31b6764d624454ab077861eda103655Q.jpg" slate-data-type="image"><span></span><img src="https://ae01.alicdn.com/kf/H5e97aa52e3f649c8b9d4ee7c9bf4c98fD.jpg" slate-data-type="image"><span></span></p>
<p><br></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_happyHouse],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/H815d3bd91dbf4ffbba8ec926ef3dcf5fN.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H41fdc9a3c83c43ea85bbce4a3b6d624aF.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H30e1733fe574442aa4c2e5b49c57e8f7A.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Blade Type")],
        price: [PriceData(
          [StringData(code: "en", text: "8 mm")],
          0, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/Hcffc544e837d4e81a40c4f8fb51973d3f/Semi-Circular-Woodworking-Chisel-Set-Chrome-Vanadium-Steel-Carpenter-Wood-Carving-Gouge-Chisels-Tool.jpg_50x50.jpg_.webp", localFile: ""),
          stock: 99,
        ),
          PriceData(
            [StringData(code: "en", text: "12 mm")],
            1.22, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H1854ef3fa3fc4775b77cbb7b60fdb0f9B/Semi-Circular-Woodworking-Chisel-Set-Chrome-Vanadium-Steel-Carpenter-Wood-Carving-Gouge-Chisels-Tool.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 39,
          ),
          PriceData(
            [StringData(code: "en", text: "25 mm")],
            2.22, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H8868fa1a87c54ec79129a5c97234a8a5S/Semi-Circular-Woodworking-Chisel-Set-Chrome-Vanadium-Steel-Carpenter-Wood-Carving-Gouge-Chisels-Tool.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 29,
          ),
        ],
      ),
    ],
    priceProduct: 6.46,
    discPriceProduct: 9.09,

    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),


  // 5

  ProductData(
    "jZBgGBJ8Zp5eIGaQQ005",
    [StringData(code: "en", text: "FINDER Carpentry Flat Chisel Set Tpr Plastic Fiber Handle DIY Carpenter ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
    <div class="detailmodule_text-image"><p class="detail-desc-decorate-title" style="text-overflow: ellipsis;font-family: 'OpenSans';color:'#000';word-wrap: break-word;white-space: pre-wrap;font-weight: 900;font-size: 20px;line-height: 28px;color: #000;margin-bottom: 12px;" data-spm-anchor-id="a2g0o.detail.1000023.i0.776d1640lbAaFQ">The wooden handle chisel arbor is made of 6160CrV and its hardness is 57-63 degrees. The wooden handle handle is made of beech woodFINDER trademark stamping on the handle,varnish the surface, crack guard design!</p><img src="//ae01.alicdn.com/kf/H1eb7cff993b54cbe9e86e23ea6087d6cY.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/H2b4607c09d834316b6df6b24712b08c6L.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/H0e5d3e0ab86749e2b3ee6a88f145c9b7e.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/H74c3da95b51740488a48ce289d91ff120.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/Hcac5fc5f39bc4861ae8cb1147b8a8371K.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/H7f907c154bb7456fb449842f44b8952bg.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/H851f08075fc24f37a65ad5aa73c6734bu.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/Ha9c0b2fe57814e1abcdae8776a2bc9a8I.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/H1d0978bbd0ab420b8f4ea7376ec9ed52W.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/Hf11a730b2f5b42c6ab78e7dfee3b097cv.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/H4d77ac7702e54d298c543328cc69083c5.jpg" class="detail-desc-decorate-image"><img src="//ae01.alicdn.com/kf/H746aae3249a942f8a626cca7468293095.jpg" class="detail-desc-decorate-image"></div>
    
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_happyHouse],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/H0e5d3e0ab86749e2b3ee6a88f145c9b7e.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H74c3da95b51740488a48ce289d91ff120.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H7f907c154bb7456fb449842f44b8952bg.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-005-01", name: [StringData(code: "en", text: "Blade Size")],
        price: [PriceData(
          [StringData(code: "en", text: "6 mm")],
          0, 0, "+",
          ImageData(serverPath: "", localFile: ""),
          stock: 99,
        ),
          PriceData(
            [StringData(code: "en", text: "12 mm")],
            1.22, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 29,
          ),
          PriceData(
            [StringData(code: "en", text: "20 mm")],
            2.22, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 39,
          ),
        ],
      ),
    ],
    priceProduct: 5.66,
    discPriceProduct: 4.46,

    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),

  // 6
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ006",
    [StringData(code: "en", text: "Heat gun LCD display industrial electric heat gun shrink packaging heat tool portable 220V/110V")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
    <div class="detail-desc-decorate-richtext"><div class="detailmodule_dynamic"></div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title" data-spm-anchor-id="a2g0o.detail.1000023.i0.6e6d2f6cZh1rOs">Note: 886-A and 886-B do not have LCD display, only 886-C has LCD display.（Follow our free 1PCS nozzle）</p>
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">Specification: Power supply voltage: 220V/110V<br>Wattage:1800- 2000W<br>Temperature: 60 degrees Celsius to 200 degrees Celsius<br>Application: Removal/Peeling of Old Wall Paper/Removing Plastic Floor Tiles/Bent PVC Pipe/Trash in Melting Pipe/Removing Greasy Trash/Used for Shrink Packaging<br>Note: Do not pull out the plug before the motor has completely stopped running for 20 seconds. Do not touch the nozzle. Keep away from children. Do not use it as a hair dryer. Do not direct heat to people or animals. Do not use it in a humid environment.</p>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Reason for choice</p>
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">1. Double heating wire, using double high temperature heating wire, heat collection and heating faster<br>2. Equipped with temperature control overload protector, long service life<br>3. Temperature overload protector, automatic sleep safety protection when the temperature is too high<br>4. Ni-Cr small electric heating wire, triple heating constant temperature adjustment<br>5. Nickel-chromium heating wire, double heating wire design, fast heat absorption, fast heating<br>6. Nickel-chromium wire ceramic skeleton, shock absorption protection, high temperature and heat resistance, stability, long service life<br>7. The hot air pressurizes the nozzle of the spray gun, and the hot air pressurizes the nozzle of the spray gun. The wind speed is faster and the power is greater.</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae04.alicdn.com/kf/H4b7087aefc76499397aeb061dd1ab999X.png" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">1. Stepless temperature regulation<br>2. Display screen<br>3. Temperature adjustment knob</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae04.alicdn.com/kf/H12973e3fae5e47b79b939739d127602be.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">1.Double insulation is reliable and safe<br>2.High temperature anti-scalding nozzle<br>3.Double cooling air inlet Strong wind and low noise</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae04.alicdn.com/kf/Hfbae73450c874fb3b9626aad8baa82696.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">1.Air outlet 2.Air Inlet<br>3.Two speed control switch 4.Display screen<br>5.Anti-scalding 6.Temperature<br>7.adjustment knob 8.Hangable</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H1a01ab78f5324e07924abcc873b118deR.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Can be used with various nozzles</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H66c4bc6ad2254af38fed282dd6619176b.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Three version parameters</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H413a81445f2a4091ae6b2d523d352ec6l.png" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Scene to be used</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H88d95e6b399147468f606a1cdf3e7603I.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Car film</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hedccb35120a2492baa9ce06a7239a91ev.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Heat to remove paint</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H3309792c353449ae82977777706450f29.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Shrink tubes and films</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H9cbc5a16cbb04dfea3f53f8f13f22febV.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Thaw food</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H8716f7d891464f36b5ff37b2bbe65bbdk.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Thaw water pipe</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H5a89f8f2a11940d99b787914c510e62bF.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text-image">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">BBQ Carbon</p>
 <div>
  <img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Heb1e951e8c8d474f967f79659a3c2a5ar.jpg" slate-data-type="image">
 </div>
</div>
<div class="detailmodule_text">
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Follow Shop:Become a member of the store to get exclusive fan discounts.</p>
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">-1 year manufacture warranty;<br>We will offer your free new parts or accessories if item is defective with free shipping during 3 months after your purchase.<br>We will offer your free new parts or accessories if item is defective but you need to pay for some shipping fees when more than 3 months less than 1 year.<br>-Defective problem has to be submitted within 7 business days after product is delivered.<br>-Shipping damage has to be submitted within 5 business days after product is delivered.<br>-Please show us photo or video if problems happen on products.</p>
</div>
<p><br></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_happyHouse],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H12973e3fae5e47b79b939739d127602be.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hfbae73450c874fb3b9626aad8baa82696.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H1a01ab78f5324e07924abcc873b118deR.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [PriceData(
          [StringData(code: "en", text: "886-C")],
          0, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/Hcaf7e9b4d6474c1096a7833f80b1ed26b/Heat-gun-LCD-display-industrial-electric-heat-gun-shrink-packaging-heat-tool-portable-220V-110V.png_50x50.png_.webp", localFile: ""),
          stock: 139,
        ),
          PriceData(
            [StringData(code: "en", text: "886-B")],
            10, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H16d1ce2731854049a343da100ca5fc29b/Heat-gun-LCD-display-industrial-electric-heat-gun-shrink-packaging-heat-tool-portable-220V-110V.png_50x50.png_.webp", localFile: ""),
            stock: 0,
          ),
          PriceData(
            [StringData(code: "en", text: "886-A")],
            20, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H06407be920f44bc1b74bab6ab6879a8e2/Heat-gun-LCD-display-industrial-electric-heat-gun-shrink-packaging-heat-tool-portable-220V-110V.png_50x50.png_.webp", localFile: ""),
            stock: 13,
          ),
        ],
      ),
    ],
    priceProduct: 30.96,
    discPriceProduct: 23.96,

    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),

  // 7

  ProductData(
    "jZBgGBJ8Zp5eIGaQQ007",
    [StringData(code: "en", text: "150 250mm 300mm Steel Wing Divider Pencil Marking Compass-Circle Maker Adjustable Scriber Craftsman Architect ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
    <div class="detail-desc-decorate-richtext"><h1 style="color:rgb(255, 0, 0)" data-spm-anchor-id="a2g0o.detail.1000023.i0.3c4a4a52xFvWbL"><br>100mm 150mm 200mm 250mm 300mm Adjustable Wing Divider Edge Creaser DIY Leather Craft Tool<br></h1><p><br><span style="font-size:28px"><strong><span style="color:rgb(255, 0, 0)">remark：300mm&nbsp;size&nbsp;:&nbsp;290mm or 300mm,&nbsp;ship&nbsp;by&nbsp;random</span></strong></span></p><p><br><span style="font-size:12px">Attention:</span></p><p><br>according to industrial standard<br></p><p><br>Due to different Monitor, the color may have difference<br></p><p><br>Due to hand measure ,Please allow 1-3% difference tolerance<br></p><p><br>Due to long shipping, the item may damage in transit, if the item damage, pls contact us firstly immediately before leave feedback, thanks for your understanding<br></p><p><br><img src="https://ae01.alicdn.com/kf/HTB1yykWrxSYBuNjSspjq6x73VXaf.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1mtEgruuSBuNjSsplq6ze8pXak.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB19XMarpGWBuNjy0Fbq6z4sXXaV.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1VEf6rAKWBuNjy1zjq6AOypXaZ.jpg" slate-data-type="image"></p><p><br><img src="https://ae01.alicdn.com/kf/HTB19MWxagaH3KVjSZFpq6zhKpXa1.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1q2CyaoGF3KVjSZFoq6zmpFXaW.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1JZeyafWG3KVjSZFPq6xaiXXaZ.jpg" slate-data-type="image"></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_happyHouse],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1mtEgruuSBuNjSsplq6ze8pXak.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB19XMarpGWBuNjy0Fbq6z4sXXaV.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1VEf6rAKWBuNjy1zjq6AOypXaZ.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Size")],
        price: [PriceData(
          [StringData(code: "en", text: "150mm")],
          2, 0, "+",
          ImageData(serverPath: "", localFile: ""),
          stock: 0,
        ),
          PriceData(
            [StringData(code: "en", text: "100mm")],
            0, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 139,
          ),
          PriceData(
            [StringData(code: "en", text: "290or300mm")],
            4, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 239,
          ),
        ],
      ),
    ],
    priceProduct: 12.66,
    discPriceProduct: 6.99,
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),

  // 8

  ProductData(
    "jZBgGBJ8Zp5eIGaQQ008",
    [StringData(code: "en", text: "68MM woodworking Desktop clip fast fixed clip clamp Aluminum vise bench can equipped bench drill electric drill")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
    <div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><h1 style="font-size:14px;font-weight:500;line-height:19px;text-align:center;margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px;width:fit-content" class="product-title-text" align="center"><span style="font-size:20px">68MM woodworking Desktop clip fast fixed clip clamp Aluminum vise bench can equipped bench drill electric drill Woodworking tool</span></h1> 
<p><br></p> 
<p><span style="font-size:16px"><strong>Attention:</strong></span></p> 
<p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px" align="start">according to industrial standard</p> 
<p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px" align="start" data-spm-anchor-id="a2g0o.detail.1000023.i0.659954cdBPezT1">Due to different Monitor, the color may have difference</p> 
<p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px" align="start">Due to hand measure ,Please allow 1-3% difference tolerance</p> 
<p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px" align="start">Due to long shipping, the item may damage in transit, if the item damage, pls contact us firstly immediately before leave feedback, thanks for your understanding</p> 
<p><br></p> 
<p><span style="background-color:rgb(250, 255, 0);color:rgb(255, 0, 0);font-size:16px"><strong>Remark: the color of button ship by random, pls noted it when u order it : )</strong></span><br><br></p> 
<p><img src="https://ae04.alicdn.com/kf/H14f8b13f32dc49328c3e286728a42cb7C.jpg" slate-data-type="image"></p> 
<p><img src="https://ae04.alicdn.com/kf/Hbb3a8563ead14500bd0be0f7b6cfb332D.jpg" slate-data-type="image"></p> 
<p><img src="https://ae04.alicdn.com/kf/Hc5b542b87b7b4bbd855dca0babbc15a6K.jpg" slate-data-type="image"></p> 
<p><img src="https://ae04.alicdn.com/kf/Hb69a52a2b8cb434784ce06c1c59e2e72g.jpg" slate-data-type="image"></p> 
<p><img src="https://ae04.alicdn.com/kf/H49c46de17a144c68a148ae7b8ea33f50h.jpg" slate-data-type="image"></p> 
<p><img src="https://ae04.alicdn.com/kf/Hf2fc370ea0a64095b47ca4aabc7bb507g.jpg" slate-data-type="image"></p> 
<p><br><img src="https://ae01.alicdn.com/kf/Hd798f61cba86403b9aa39092c57097075.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H1cf2d8c41d6349ca99f2a469736afc03b.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hc15c2a4447444f7c8b37acdda50d2610O.jpg" slate-data-type="image"><br><br><br><br></p></div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_happyHouse],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H14f8b13f32dc49328c3e286728a42cb7C.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hbb3a8563ead14500bd0be0f7b6cfb332D.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hc5b542b87b7b4bbd855dca0babbc15a6K.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [PriceData(
          [StringData(code: "en", text: "Green")],
          3, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/H65313d58bc4648e5b4c57c344e3f6da6m/68MM-woodworking-Desktop-clip-fast-fixed-clip-clamp-Aluminum-vise-bench-can-equipped-bench-drill-electric.jpg_50x50.jpg_.webp", localFile: ""),
          stock: 239,
        ),
          PriceData(
            [StringData(code: "en", text: "Silver")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/Hf2fc370ea0a64095b47ca4aabc7bb507g/68MM-woodworking-Desktop-clip-fast-fixed-clip-clamp-Aluminum-vise-bench-can-equipped-bench-drill-electric.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 3,
          ),

        ],
      ),
    ],
    priceProduct: 5.90,
    discPriceProduct: 4.13,
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),

  // 9
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ009",
    [StringData(code: "en", text: "Digital Protractor Angle Finder Inclinometer electronic Level 360degree with 4pcs Magnets Level angle slope test Ruler 400mm 16")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
    <div class="origin-part box-sizing"><p>
	<span style="font-size: 12.0px;"><span style="line-height: 27.0px;color: #ff0000;"><span style="line-height: 30.0px;"><span style="font-size: 18.0px;"><strong data-spm-anchor-id="a2g0o.detail.1000023.i0.626f1ad5S0N0gx">400mm 16inch Digital Level 360 Degree Range Angle Finder </strong></span></span></span></span>
</p>
<p>
	<span style="font-size: 12.0px;"><span style="line-height: 27.0px;color: #ff0000;"><span style="line-height: 30.0px;"><span style="font-size: 18.0px;"><strong>Spirit Level Upright 4 Magnets Inclinometer</strong></span></span></span></span>
</p>
<div style="word-wrap: break-word;">
	<p style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;"><strong>Brief Description</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;"><strong>4 X 90° (total 360°) range and resolution 0.1° for wide variety of applications. Compared with traditional protractors,this protractor has bottom plate with 4 strong magnets so that it can firmly attach to metal surfaces. Vertical &amp; horizontal spirit bubbles are also equipped.</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;"><strong>backlight. It is 41.6cm long and more convenient for users to draw strange lines with slope measurements. In addition, the reading is always displayed upright even the protractor is upside down.</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;"><strong>reference surface zero to measure relative angle,then it will give a result of measured slope angle. With absolute angle measurement,you will able to test whether the working surface is on the level. You can use this function to check roof slopes and wheel alignment etc. This meter works great for miter and T able saws,detailed applications are listed as follows.</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		&nbsp;
	</p>
	<h2 style="margin: 0.0px;word-wrap: break-word;">
		<span style="color: #c00000;"><span style="font-size: 12.0px;"><strong>The </strong></span><span style="font-size: 12.0px;"> with or without logo, ship by random! </span></span>
	</h2>
	<h2 style="margin: 0.0px;word-wrap: break-word;">
		<span style="color: #c00000;"><span style="font-size: 12.0px;">Pls note it! </span></span>
	</h2>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		&nbsp;
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;"><strong>Applications</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">Automotive</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">Drive line measurement</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">Race car wing &amp; chassis adjustment</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">Wheel alignment</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">Frame straightening</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Industrial</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Machine tool set up</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Lathe and mill alignment</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Quality assurance verification</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Range of motion measurement</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Drive shaft alignment</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Medical</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Setup of precision machines</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Road or rail-track layout</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Satellite or aerial alignment</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Drainage angles and run-off slopes</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Tool setting on lathes</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Setting blade angle of circular &amp; miter saws</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Setting work piece angle for milling</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Grader and tractor work alignment</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· platform monitoring</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Suitable for built wood and metalwork projects</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Create straight edges when assembling furniture</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Ensure wallpaper and cornices are level for decoration</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Measuring and adjusting alignment of sliding carriages and extension tables to cast saw benches</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Check drill press table setting, table saw, jointer table, band saw, jointer fence or band saw table</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Favored by cabinetmakers &amp; furniture workshops for setting up machinery such as saw benches, </span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">Planer thicknesses, spindle molders and lathes to ensure that they are set true</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		&nbsp;
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;"><strong>Features</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Base plate with <strong>4 built-in magnets</strong> for attaching on metal surfaces</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Portable design &amp; simple operation</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· High accuracy and resolution</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Measuring range of <strong>4 x 90°</strong> <strong>(total 360°)</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Degree and mm/m of slope in conversion</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· <strong>Absolute &amp; relative measurement modes</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Enter absolute angle measurement mode every time being turned on (no matter change the batteries)</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Large and clear LCD with <strong>backlight</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· <strong>Vertical &amp; horizontal spirit bubbles</strong> equipped</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Measured data hold</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Displayed readings remain <strong>upright</strong> to enable easy viewing at all angles</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		&nbsp;
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;"><strong>Specifications</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· 4 magnets on base plate</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Measuring Range: 4 x 90<strong>°</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Resolution: 0.1<strong>°</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Measuring Accuracy: 0.2<strong>°</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Power: 2 x 1.5V LR03 Batteries <span style="line-height: 18.0px;color: #ff0000;"><span style="line-height: 27.0px;">(not included)</span></span></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Dimensions: approx. 416 (L) x 50 (W) x 21 (D) mm (16.22' x 1.95' x 0.82' inch)</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Weight: 330 g</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		&nbsp;
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;"><strong>One Set Included</strong></span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· 1 x Digital Inclinomete</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· 1 x Instruction Manual</span>
	</p>
	<p align="left" style="margin: 0.0px;word-wrap: break-word;">
		<span style="font-size: 12.0px;">· Standard Factory Package</span>
	</p>
</div>
<p>
	&lt; img alt = ''copy _ Copy'' src ='' https://ae01.alicdn.com/kf/Hf339434513ab4fb4bd558ae283bfb3a5Y.jpg ''/&gt;<img src=" https://ae01.alicdn.com/kf/H55aa3f79883c4bd1b727b4b70a40e94ae.jpg "><img src=" https://ae01.alicdn.com/kf/H85bdbc4a4dab420aa755c730d540e9d2v.jpg ">
</p>
<p>
	<img height="516" src=" https://ae01.alicdn.com/kf/HTB1TzggFVXXXXbVXVXXq6xXFXXXG/200475631/HTB1TzggFVXXXXbVXVXXq6xXFXXXG.jpg " width="774"><img height="486" src=" https://ae01.alicdn.com/kf/HTB1ZQksFVXXXXa_XXXXq6xXFXXXS/200475631/HTB1ZQksFVXXXXa_XXXXq6xXFXXXS.jpg " width="762"><img height="455" src=" https://ae01.alicdn.com/kf/HTB1wuWLFVXXXXbvaXXXq6xXFXXXq/200475631/HTB1wuWLFVXXXXbvaXXXq6xXFXXXq.jpg " width="800"><img height="464" src=" https://ae01.alicdn.com/kf/HTB1u._dFVXXXXX.aXXXq6xXFXXXr/200475631/HTB1u._dFVXXXXX.aXXXq6xXFXXXr.jpg " width="800"><img height="510" src=" https://ae01.alicdn.com/kf/HTB1eXwjFVXXXXbBXVXXq6xXFXXXY/200475631/HTB1eXwjFVXXXXbBXVXXq6xXFXXXY.jpg " width="800">
</p>
<p>
	&nbsp;
</p>  
<script>window.adminAccountId=225241483;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_happyHouse],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/H55aa3f79883c4bd1b727b4b70a40e94ae.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H85bdbc4a4dab420aa755c730d540e9d2v.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1TzggFVXXXXbVXVXXq6xXFXXXG/200475631/HTB1TzggFVXXXXbVXVXXq6xXFXXXG.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [PriceData(
          [StringData(code: "en", text: "red")],
          0, 0, "+",
          ImageData(serverPath: "https://ae01.alicdn.com/kf/H93eb78c4ac31478393d8c91abb75c585C/Digital-Protractor-Angle-Finder-Inclinometer-electronic-Level-360degree-with-4pcs-Magnets-Level-angle-slope-test-Ruler.jpg_50x50.jpg_.webp", localFile: ""),
          stock: 10,
        ),
          PriceData(
            [StringData(code: "en", text: "white")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H0a553c0deb2a4ac9a7e83fccd78c54cfR/Digital-Protractor-Angle-Finder-Inclinometer-electronic-Level-360degree-with-4pcs-Magnets-Level-angle-slope-test-Ruler.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 239,
          ),
        ],
      ),
    ],
    priceProduct: 16.66,
    discPriceProduct: 12.49,
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),

  //10
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ010",
    [StringData(code: "en", text: "Drill rack gauge 96203 height 400mm, clamping hole diameter 43mm, drilling depth 60mm")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
    <div class="detail-desc-decorate-richtext"><p style="text-align:left" class="MsoNormal" align="left" data-spm-anchor-id="a2g2w.detail.1000023.i0.5e752b10qKcadI">Drill rack caliber article 96203 with vise is used to work with the drill without holding the drill in the hands. With the help of the rack, vertical fastening of the tool is made. The rack can be fixed on the surface of the table with bolts. The kit includes a vise, with which various blanks are fixed.</p><div style="font-family:Roboto, Arial, sans-serif;font-size:20px;font-weight:bold;letter-spacing:normal;text-align:center;white-space:normal;color:rgb(0, 0, 0);margin:30px 0px 0px;margin-bottom:0px;margin-top:30px;margin-left:0px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px;box-sizing:border-box" class="good-specs-title" align="center">Specifications</div><div style="font-family:Roboto, Arial, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:1.3;text-align:start;white-space:normal;color:rgb(0, 0, 0);margin:15px 0px 30px;margin-bottom:30px;margin-top:15px;margin-left:0px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px;box-sizing:border-box" class="good-specs" align="start"><div style="border-bottom:1px dashed rgb(128, 128, 128);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:5px 0px;padding-bottom:5px;padding-top:5px;padding-left:0px;padding-right:0px;display:flex;box-sizing:border-box"><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px;padding-bottom:0px;padding-top:0px;padding-left:10px;padding-right:10px;box-sizing:border-box">Height</div><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px 0px 0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:10px;width:138px;box-sizing:border-box">400mm</div></div><div style="border-bottom:1px dashed rgb(128, 128, 128);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:5px 0px;padding-bottom:5px;padding-top:5px;padding-left:0px;padding-right:0px;display:flex;box-sizing:border-box"><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px;padding-bottom:0px;padding-top:0px;padding-left:10px;padding-right:10px;box-sizing:border-box">Diameter clamping hole</div><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px 0px 0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:10px;width:138px;box-sizing:border-box">43mm</div></div><div style="border-bottom:1px dashed rgb(128, 128, 128);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:5px 0px;padding-bottom:5px;padding-top:5px;padding-left:0px;padding-right:0px;display:flex;box-sizing:border-box"><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px;padding-bottom:0px;padding-top:0px;padding-left:10px;padding-right:10px;box-sizing:border-box">Drilling depth</div><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px 0px 0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:10px;width:138px;box-sizing:border-box">60mm</div></div><div style="border-bottom:1px dashed rgb(128, 128, 128);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:5px 0px;padding-bottom:5px;padding-top:5px;padding-left:0px;padding-right:0px;display:flex;box-sizing:border-box"><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px;padding-bottom:0px;padding-top:0px;padding-left:10px;padding-right:10px;box-sizing:border-box">Item No.</div><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px 0px 0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:10px;width:138px;box-sizing:border-box">96203</div></div><div style="border-bottom:1px dashed rgb(128, 128, 128);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:5px 0px;padding-bottom:5px;padding-top:5px;padding-left:0px;padding-right:0px;display:flex;box-sizing:border-box"><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px;padding-bottom:0px;padding-top:0px;padding-left:10px;padding-right:10px;box-sizing:border-box">The country.</div><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px 0px 0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:10px;width:138px;box-sizing:border-box">China</div></div><div style="border-bottom:1px dashed rgb(128, 128, 128);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:5px 0px;padding-bottom:5px;padding-top:5px;padding-left:0px;padding-right:0px;display:flex;box-sizing:border-box"><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px;padding-bottom:0px;padding-top:0px;padding-left:10px;padding-right:10px;box-sizing:border-box">Home Brand</div><div style="margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 10px 0px 0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:10px;width:138px;box-sizing:border-box">Russia</div></div></div><p><img src="https://ae01.alicdn.com/kf/U42beb25e219c4d3f9caceb2cdf98389cq.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/U4d2a8d21f61348d5a77058462d2949b18.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Ubdb8fad6246d49dbb96376d02795858f6.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/U5dd167702ad840079320032053a7f742z.jpg" slate-data-type="image"></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/U42beb25e219c4d3f9caceb2cdf98389cq.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/U4d2a8d21f61348d5a77058462d2949b18.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Ubdb8fad6246d49dbb96376d02795858f6.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [PriceData(
          [StringData(code: "en", text: "green")],
          0, 0, "+",
          ImageData(serverPath: "", localFile: ""),
          stock: 999,
        ),
        ],
      ),
    ],
    priceProduct: 31.18,
    discPriceProduct: 0,
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    thisIsArticle: true,
  ),

  // 11
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ011",
    [StringData(code: "en", text: "Japanese Samurai Umbrella Strong Windproof Semi Automatic Long Umbrella")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="ProductDescription-module_content__1xpeo"><kse:widget data-widget-type="customText" id="24113120" title="umbrella 1" type="custom"></kse:widget>
<p>
	<img alt="12" src="https://ae01.alicdn.com/kf/HTB1iDEVac_vK1RkSmRyq6xwupXaM.jpg" data-spm-anchor-id="a2g2w.detail.1000023.i0.69d13da4kX5SIc">
</p>
<div>
	<span style="font-size: 16.0px;">Product Name: Japanese Samurai Umbrella</span>
</div>
<div>
	<span style="font-size: 16.0px;">Handle material: plastic</span>
</div>
<div>
	<span style="font-size: 16.0px;">Bar material: steel</span>
</div>
<div>
	<span style="font-size: 16.0px;">Umbrella material: glass fiber</span>
</div>
<div>
	<span style="font-size: 16.0px;">Umbrella material: hit cloth</span>
</div>
<div>
	<span style="font-size: 16.0px;">Size: 24 K：125 * 105 * 95 cm&nbsp;</span>
</div>
<div>
	<span style="font-size: 16.0px;">16K：125 * 103 * 95 cm</span>
</div>
<div>
	<span style="font-size: 16.0px;">8K：120*103*94 cm</span>
</div>
<div>
	<span style="font-size: 16.0px;">Colour: Black</span>
</div>
<div>
	<span style="font-size: 16.0px;">Style: long umbrella</span>
</div>
<div>
	<span style="font-size: 16.0px;">Open method: Automatic</span>
</div>
<div>
	<span style="font-size: 16.0px;">Umbrella method: Manual</span>
</div>
<div>
	<span style="font-size: 16.0px;">Feature:</span>
</div>
<div>
	<span style="font-size: 16.0px;">Black coating panel, secure you pefect Sun UV protection</span>
</div>
<div>
	<span style="font-size: 16.0px;">Convenient for carrying and storage</span>
</div>
<div>
	<span style="font-size: 16.0px;">Strong all-steel frame, beautiful, durable&nbsp;</span>
</div>
<div>
	<span style="font-size: 16.0px;">carrying strap has the appearance of a Japanese sword, make you unique</span>
</div>
<div>
	<span style="font-size: 16.0px;">The plastic handle has the look and texture of a samurai sword handle</span>
</div>
<div>
	<span style="font-size: 16.0px;">Easy to open and close in confine spaces unlike traditional umbrellas</span>
</div>
<div>
	<span style="font-size: 16.0px;">8/16/24 Bone Reinforced Umbrella frame</span>
</div>
<div>
	<span style="font-size: 16.0px;">Please note:</span>
</div>
<div>
	<span style="color: rgb(255, 0, 0);"><span style="font-size: 20px;">Due to transport restrictions. Umbrellas need to be assembled by themselves. You need to link up hard</span></span>
</div>
<div>
	<span style="font-size: 16.0px;">Due to hand measure, the size may have 1-2 cm error</span>
</div>
<div>
	<span style="font-size: 16.0px;">Due to Different Monitor, the color may have difference Thanks for your understanding.</span>
</div>
<div>
	<span style="font-size: 16.0px;">Due to long shipping, the item may damage in transit, if the item damage, pls contact us firstly immediately before leave feedback, thanks for your understanding</span>
</div>
<div>
	<span style="font-size: 16.0px;"><img src="https://ae01.alicdn.com/kf/HTB1IKlzxQPoK1RjSZKbq6x1IXXaI.jpg"><img alt="20_01" src="https://ae01.alicdn.com/kf/HTB1ZC7SaiDxK1RjSsphq6zHrpXaw.jpg"><img alt="20_02" src="https://ae01.alicdn.com/kf/HTB1c.7YadzvK1RkSnfoq6zMwVXaK.jpg"><img alt="20_03" src="https://ae01.alicdn.com/kf/HTB1nM7VanjxK1Rjy0Fnq6yBaFXan.jpg"><img alt="20_04" src="https://ae01.alicdn.com/kf/HTB19JMVanHuK1RkSndVq6xVwpXaH.jpg"><img alt="20_05" src="https://ae01.alicdn.com/kf/HTB1pe.PafLsK1Rjy0Fbq6xSEXXaQ.jpg"><img alt="20_06" src="https://ae01.alicdn.com/kf/HTB1xZgUaizxK1RkSnaVq6xn9VXar.jpg"><img alt="20_07" src="https://ae01.alicdn.com/kf/HTB1WtgNairxK1RkHFCcq6AQCVXaS.jpg"><img alt="20_08" src="https://ae01.alicdn.com/kf/HTB1lMo0acrrK1Rjy1zeq6xalFXa4.jpg"> <kse:widget data-widget-type="customText" id="1000000234417" title="jie wei" type="custom"></kse:widget></span>
</div>
<script>window.adminAccountId=233005265;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1lu.Tac_vK1Rjy0Foq6xIxVXal/Japanese-Samurai-Umbrella-Strong-Windproof-Semi-Automatic-Long-Umbrella-Large-Man-And-Women-s-Business-Umbrellas.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1.84UxNjaK1RjSZKzq6xVwXXa2/Japanese-Samurai-Umbrella-Strong-Windproof-Semi-Automatic-Long-Umbrella-Large-Man-And-Women-s-Business-Umbrellas.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1GsEUaoLrK1Rjy1zbq6AenFXat/Japanese-Samurai-Umbrella-Strong-Windproof-Semi-Automatic-Long-Umbrella-Large-Man-And-Women-s-Business-Umbrellas.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
              StringData(code: "en", text: "8K")],
              0, 0, "+",
              ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1cnMOae6sK1RjSsrbq6xbDXXaa/Japanese-Samurai-Umbrella-Strong-Windproof-Semi-Automatic-Long-Umbrella-Large-Man-And-Women-s-Business-Umbrellas.jpg_50x50.jpg", localFile: ""),
               stock: 99,
            ),
          PriceData([
            StringData(code: "en", text: "16K")],
            2, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1g_AVac_vK1RkSmRyq6xwupXaF/Japanese-Samurai-Umbrella-Strong-Windproof-Semi-Automatic-Long-Umbrella-Large-Man-And-Women-s-Business-Umbrellas.jpg_50x50.jpg", localFile: ""),
             stock: 99,
          ),
          PriceData([
            StringData(code: "en", text: "24K")],
            4, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1OMMZaffsK1RjSszgq6yXzpXaY/Japanese-Samurai-Umbrella-Strong-Windproof-Semi-Automatic-Long-Umbrella-Large-Man-And-Women-s-Business-Umbrellas.jpg_50x50.jpg", localFile: ""),
            stock: 99,
          ),
        ],
      ),
    ],
    priceProduct: 18.72,
    discPriceProduct: 12.36,
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/3911963242/p/1/e/6/t/10301/309474679584.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 12
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ012",
    [StringData(code: "en", text: "3 In 1 Outdoor Military Waterproof Raincoat Rain Coat Men Raincoat Women Awning")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="ProductDescription-module_content__1xpeo"><div class="detailmodule_text"><p style="font-size:20px;color:rgb(255, 0, 0)"><kse:widget data-widget-type="customText" id="1005000000034183" type="relation"></kse:widget></p><p style="font-size:20px;color:rgb(255, 0, 0)" data-spm-anchor-id="a2g2w.detail.1000023.i0.5be3520b2HmRpY">About Ship:</p></div><div class="detailmodule_text"><p style="font-size:20px;color:rgb(255, 0, 0)">1.We have full stock, will ship out in 24-48 hours about your orders.We have dropshipping service, please contact us if you do dropship ! ! !</p></div><div class="detailmodule_text"><p style="font-size:20px;color:rgb(255, 0, 0)">2.We keep high quality and cheaper price. Welcome to New and Old Customers.</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Product description</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Multi-Use Military Tactical Waterproof Ripstop Hooded Camouflage Rain coat Rain Poncho for Men Women</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Military Hooded Camouflage Rain coat made of high quality waterproof ripstop nylon. This ripstop poncho is 100% waterproof and called ripstop because of the special weave that runs through the material. It's originally a military designed material weave that is used in many fabrics and applications.It also allows the material to be lighter without losing any strength. A multi-function item has eyelets on the hem for use as a shelter or ground sheet, and press stud poppers on the sides allowing you to use it as a sleeping bag cover or even a poncho.</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Package List:</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">1x Rain Poncho</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">1 x Matching Bag</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Material: 210T lattice fabric</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">size: length:220cm,width:140cm(when fully spread out)</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">FEATURES:</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Use As Emergency Shelter Or Sleeping Bag When Used as A Military Poncho,Protects you and your backpack from heavy wind and rain, all-in-one easy-to-wear raincoat</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Multi Purpose. it can not only be used as a raincoat, is a tent, moisture-proof mats, rain raincoat, shelter not get wet, change mats sunny, with a rope to do a small canopy, avoid the sun.</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Environmentally friendly, non-toxic, wear-resistant, comfortable, no delamination, in eventually becoming aging, waterproof performance, camouflage effect is obvious.</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Various Application. The waterproof poncho is ideal for Survival, Camping, Fishing, Hunting, Military, Tactical, and all other outdoor activities as well as Halloween costumes!</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Warm Reminder</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">There might be a little color difference due to the monitor, camera or other factors, please refer to the physical item.</p></div><div class="detailmodule_text"><p style="color:rgb(0, 0, 0)">Please refer to the measurement. Tiny measuring error is allowable in normal range.</p></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Ha4130f1117584718a28216383ec7d93eJ.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/He58d782b135f40918a55337e501af02aL.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H4006556f8c1a42968a27bf340018283fI.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H3feb5028a64940f1bae22336cb885bf3D.jpg" slate-data-type="image"></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H96cfe12f353a4fd79459a2d01fb7edd62.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H4d962cdcfe2d4e499ab5658a216ff1c8R.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H0e5ebe2297ae4af8ad7972d8d322a944E.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hb64e0b1743a9482c803f7d3b02e68ee7w.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hfb028581884345d4a2ce3454a5d8af39K.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hc07095044e34422793fe2bbb1ab42b838.jpg" slate-data-type="image"></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hfd854f3aa2de47a69e4a0ea52f8125dfX.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hec006cd1f05d42dcafe5604dcb07f410E.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H84d106a97f2e44cd95bfa146c01aaf9bB.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hb21d62066a844f829be18d85f9894732w.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hebc2e41ca49c4b5da6b70ad21c68f8edO.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hdff78961e3c244cfaf932c8b04838d15u.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H31afc227e5c84aadae5040b6b9012e1cJ.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H4476890d66354d81b02d6c2f3fee5704U.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H6b8001b845934229a54567df49db855bJ.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H2b3ed03ffd32476eb4fc5688aa8d400cB.jpg" slate-data-type="image"></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hc15ba64ac1244d23b43984de30ba69dcV.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hf595d105b4d345529bb80d1f5375385aO.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H22a7d024a01d4b8790d892433a4fe3e5y.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hb9d2c40826604b0e9036773ed51b48can.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H7fc788a280bc46efb2d577670d4426afa.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H6a2779fc4c384b7b814b14476c103de7W.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H7fbad1e3481446feb3555e822c1b3d134.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hdeb439a4c08340769eb2dfa53383f397n.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/He932bc17b7b645caaec347ab0d0b0dc2Z.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H38d2a768993e4d82846f3939eac11b97l.jpg" slate-data-type="image"></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hc6bc84a5acdd43bc8489229afe866250D.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H5737b0aeb553442f82e8d7d60b4a0d19l.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H5a845e9318c44dda8e7b3636fc869c477.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H07621028f26b4e968a7a4ead313777a3Z.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Ha1a98b0026954238927e7683fc49f3c9v.jpg" slate-data-type="image"></div><p><br></p>
<script>window.adminAccountId=239826886;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/H3feb5028a64940f1bae22336cb885bf3D.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H96cfe12f353a4fd79459a2d01fb7edd62.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H4d962cdcfe2d4e499ab5658a216ff1c8R.jpg", localFile: ""),
    ],
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "Red")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H72e986f86d204bb099251b63ea2190e01/3-In-1-Outdoor-Military-Waterproof-Raincoat-Rain-Coat-Men-Raincoat-Women-Awning-From-The-Rain.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "Green")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H33ef9cf605d140728f319e5168171918X/3-In-1-Outdoor-Military-Waterproof-Raincoat-Rain-Coat-Men-Raincoat-Women-Awning-From-The-Rain.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "Purple")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/Hd4dbab8fed8b43d3ade24903da39a556j/3-In-1-Outdoor-Military-Waterproof-Raincoat-Rain-Coat-Men-Raincoat-Women-Awning-From-The-Rain.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    priceProduct: 5.45,
    discPriceProduct: 3.6,
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/2206811958118/p/1/e/6/t/10301/326028037916.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 13
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ013",
    [StringData(code: "en", text: "YADA Outdoor Umbrella Hat Novelty Foldable Sun&Rainy Day Hands Free ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="ProductDescription-module_content__1xpeo"><p><kse:widget data-widget-type="customText" id="33832877" type="custom"></kse:widget></p><p><img src="https://ae01.alicdn.com/kf/HTB1HxLjigKTBuNkSne1q6yJoXXaV.jpg" slate-data-type="image" data-spm-anchor-id="a2g2w.detail.1000023.i0.4029543bxfUA91"><img src="https://ae01.alicdn.com/kf/HTB1E1zUfjQnBKNjSZSgq6xHGXXaJ.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1k4Zsqv5TBuNjSspcq6znGFXaH.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1ySjZqAKWBuNjy1zjq6AOypXaI.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1Pg_HinXYBeNkHFrdq6AiuVXac.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1Q5s1qER1BeNjy0Fmq6z0wVXaE.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1kA7Hqr5YBuNjSspoq6zeNFXa9.jpg" slate-data-type="image"></p><br><p><img src="https://ae01.alicdn.com/kf/HTB1Xb_Ajb1YBuNjSszhq6AUsFXag.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB11NRwc4uTBuNkHFNRq6A9qpXaJ.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1adwAcIUrBKNjSZPxq6x00pXap.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1mB0Pc5QnBKNjSZFmq6AApVXam.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/HTB1xBQbkKySBuNjy1zdq6xPxFXan.jpg" slate-data-type="image"></p><p><kse:widget data-widget-type="customText" id="23890353" type="custom"></kse:widget></p>  
<script>window.adminAccountId=232936903;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1zwZ8qv1TBuNjy0Fjq6yjyXXam/YADA-Outdoor-Umbrella-Hat-Novelty-Foldable-Sun-Rainy-Day-Hands-Free-Rainbow-Folding-Waterproof-Multicolor-Hat.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1BDXlfAUmBKNjSZFOq6yb2XXaH/YADA-Outdoor-Umbrella-Hat-Novelty-Foldable-Sun-Rainy-Day-Hands-Free-Rainbow-Folding-Waterproof-Multicolor-Hat.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1TxNaqNGYBuNjy0Fnq6x5lpXao/YADA-Outdoor-Umbrella-Hat-Novelty-Foldable-Sun-Rainy-Day-Hands-Free-Rainbow-Folding-Waterproof-Multicolor-Hat.jpg", localFile: ""),
    ],
    priceProduct: 5.76,
    discPriceProduct: 3.4,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "50cmA")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1.0uZob1YBuNjSszeq6yblFXay/YADA-Outdoor-Umbrella-Hat-Novelty-Foldable-Sun-Rainy-Day-Hands-Free-Rainbow-Folding-Waterproof-Multicolor-Hat.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "50cmB")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/HTB1JH15oeSSBuNjy0Flq6zBpVXaL/YADA-Outdoor-Umbrella-Hat-Novelty-Foldable-Sun-Rainy-Day-Hands-Free-Rainbow-Folding-Waterproof-Multicolor-Hat.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/3875164901/p/1/e/6/t/10301/249974541201.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 14
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ014",
    [StringData(code: "en", text: "Automatic Disposable Shoe Cover Waterproof Overshoes Dispenser Portable ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><div></div></div>
<div class="detailmodule_dynamic"><kse:widget data-widget-type="customText" id="1005000000879680" title="" type="custom"></kse:widget></div>
<div class="detailmodule_html"><div class="detail-desc-decorate-richtext"></div>
&nbsp;

<div>
<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" data-spm-anchor-id="a2g2w.detail.1000023.i0.5dac6f8bwP26ms">Automatic Shoe Cover Dispense Hand-Free Shoe Covers Machine Portable Waterproof for Home, Office, Supermarket, Factory, Hospital</p>
</div>

<p>&nbsp;</p>

<div>
<div>
<div data-previewurl="https://img.alicdn.com/imgextra/i3/6000000001201/O1CN01aLSwRi1Kk6IxYxPju_!!6000000001201-0-tbvideo.jpg" id="283814790645">&nbsp;</div>
</div>
</div>

<p>&nbsp;</p>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">【PLEASE READ THE MANUAL CAREFULLY BEFORE USE】</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Follow the instructions in the manual, check and install the shoe covers on the shoe cover dispenser. Be sure to check the four corner buttons as shown as in the manual. The first button and the entire row of buttons below must be pulled out 1mm.</p>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">【Protect You In An Instant】</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Our shoe cover dispenser is hand-free and fast, Get it done in only 2 steps. Our shoe cover machine works by mechanical spring, when you stand on the center of the machine, it will automatically releases a waterproof disposable plastic shoe cover onto your shoe, save your valuable time, energy-saving and ec-friendly. No battery or power cord needed.</p>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">【WIDELY USE】</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Our shoe covers are disposable plastic waterproof shoe covers for indoors. It is suitable for most types of shoes. Shoe Cover Dispenser's size is 16.8 x 8.9 x 5.3 inch and the internal length is 13.3 inch. Widely use for home, office, lab, supermarket and so on. Perfect for use by companies that need to have shoe covers available for workers and guests. It is designed to be used at the doorway. Simply place it on the ground on front of the door to start using.</p>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">【STURDY &amp; DURABLE】</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">The highlight is the thickened spring and the stable hooks which increased durability and stability. Non-slip bottom and premium abs material which increased safety and sturdy, it can be used for years.</p>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">【NO NEED TO CLEAN】</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Automatic shoe cover dispenser can keep your floor and carpets clean and neat, so you need not to clean everyday. You can use at the doorway that is occupied and convenient to use.</p>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">【SHOE COVER DISPENSER SET】</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">1 automatic shoe cover dispenser, 100pcs shoe covers.</p>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">STURDY &amp; DURABLE</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Made of premium ABS featured with thickened spring, non-slip bottom and the stable hooks which increased durability and stability; High quality material with great technology&amp;craft made this machine durable</p>

<div><img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/H6183164d03804c68acbf97fb984381b54.jpg"></div>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">AUTOMATICIALLY &amp; CORDLESS</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Battery and elactric free shoe cover dispenser which works on a mechanical spring; Automatically releases a bootie around your shoe when you stand up the center of the dispenser, energy-saving and eco-friendly</p>

<div><img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/H50cf277fb9144ba2b0f2fed5efe9b326z.jpg" style="margin-bottom:10px"></div>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">INSTALLATION METHOD</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">1. Extend shoe covers &amp; pay attention to the directionality of toe and instep of cover; 2. Put bottom into the position of corner; 3. Pull off the rubber band and ensure put in hook of machine; 4. Installtion completed</p>

<div><img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/H51f126ab35984b9c8efc4b90927bb419o.jpg" style="margin-bottom:10px"></div>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">MULTI-USAGES</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Great choice for companies which are in need of shoe covers for employees and visiters; No need to clean the floor at all, shoe cover dispenser keep floor clean and neat; Perfect for home, office, lab, supermarket, workshop, museum, hotel, hall, exhibition and other places which need this shoe covers machine</p>

<div><img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hcde2063016b44db08ac9029f8f7d5f41F.jpg"></div>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Hands-free</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Disposable shoe cover dispenser automatically releases a bootie around your shoe when you stand up the center of the dispenser. No bending down! An excellent design for the elder, the fat and the lazy, etc.</p>

<div><img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hba56e46139124b9ea8d79d09e7a09974Q.jpg"></div>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">overshoe disposable</p>
</div>

<div>
<p class="detail-desc-decorate-title" style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Keep clean</p>

<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Keep your floor clean and neat. It is convenient for you need not clean. Shoe covers disposable machine is also used to protect floors and carpets.</p>

<div><img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/H4a882224ea2644149c6086422178cd15z.jpg"> <img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/H2ee07da409414d6496d6e5d67d2bece0U.jpg" style="margin-bottom:10px"> <img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/H7e440acd438a4fd28d36c36fedc74c7bo.jpg"> <img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hcfe5d90a3c22401e8368c437cf8558fcd.jpg"> <img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hcaa766ef627c47e19f375deed0443bb16.jpg"> <img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hc71a141411c041c79ae3f9f7ec8d5b58f.jpg"> <img class="detail-desc-decorate-image" slate-data-type="image" src="https://ae01.alicdn.com/kf/H85c48ecf4be844a885460faa5181ccbdY.jpg"></div>
</div>

<div>
<p class="detail-desc-decorate-content" style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px">Automatic Shoe Cover Dispense Hand-Free Shoe Covers Machine Portable Waterproof for Home, Office, Supermarket, Factory, Hospital</p>
</div>
</div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H22daad4c42ba431aada435820e01652cb/Automatic-Disposable-Shoe-Cover-Waterproof-Overshoes-Dispenser-Portable-Hand-Free-Machine-for-Home-Office-Supermarket-Factory.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hbfc39cf384634262a19864009628c977s/Automatic-Disposable-Shoe-Cover-Waterproof-Overshoes-Dispenser-Portable-Hand-Free-Machine-for-Home-Office-Supermarket-Factory.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hf5342f82c52244b19ab40959ad609988b/Automatic-Disposable-Shoe-Cover-Waterproof-Overshoes-Dispenser-Portable-Hand-Free-Machine-for-Home-Office-Supermarket-Factory.jpg", localFile: ""),
    ],
    priceProduct: 9.34,
    discPriceProduct: 6.34,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "100pcs shoe cover")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H5db49bfd104d4532956cb65dc84d989cx/Automatic-Disposable-Shoe-Cover-Waterproof-Overshoes-Dispenser-Portable-Hand-Free-Machine-for-Home-Office-Supermarket-Factory.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "200pcs shoe cover")],
            4, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H64c9cd31837846468b7b68101cb5d1d95/Automatic-Disposable-Shoe-Cover-Waterproof-Overshoes-Dispenser-Portable-Hand-Free-Machine-for-Home-Office-Supermarket-Factory.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/2208361815413/p/1/e/6/t/10301/283569233172.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 15
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ015",
    [StringData(code: "en", text: "Foldable Handmade Seagrass Flower Pot Storage Wicker Basket Rattan ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detailmodule_html"><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif" data-spm-anchor-id="a2g2w.detail.1000023.i0.19ccaf114Gyc8P">Item Type:&nbsp; Bamboo Storage&nbsp;Basket</span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif">Color: Beige/Blue</span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif">Material: Tropical Sea Grass</span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif">Size 23cm: Diameter 23cm x Height 20cm</span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif"><span>Size 27cm: Diameter 27cm x Height 23cm</span></span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif"><span>Size 31cm: Diameter 31cm x Height 27cm</span></span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:22px"><span style="color:rgb(255, 0, 0)"><span style="font-family:arial, helvetica, sans-serif"><span>Note:</span></span></span></span><span style="font-size:22px"><span style="color:rgb(255, 0, 0)"><span style="font-family:arial, helvetica, sans-serif">The widest diameter of the basket is 23 cm/ 27cm/ 31cm.</span></span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="color:rgb(255, 0, 0)"><span style="font-size:22px"><span><span style="font-family:arial, helvetica, sans-serif">The blue part is made of plastic.</span></span></span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif"><span>It can accommodate blanket, clothing, books.</span></span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif"><span>It can be used as a hamper, flowerpot, handbag, essential home decorations.</span></span></span></div><div style="font-family:arial;color:rgb(0, 0, 0)"><span style="color:rgb(255, 0, 0)"><span style="font-size:18px"><span style="font-family:arial, helvetica, sans-serif"><span>Please note before you buy it: Itis a pure hand-woven product, so there may be extra joints and slight color difference, these are normal phenomenon.</span></span></span></span></div><p style="text-align:center" align="center"><img src="https://ae01.alicdn.com/kf/H78e772d6ae554ee2acced044cd2ff5a2b.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hc365762c3c444bc8a9a243aecdd4c7b4r.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H693340b8fad94c7e80166b7279f3de6eL.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H59d3284bfeeb479b8a4357099ec6e23bz.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/He361158381334876b417a8249d8947aeY.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H8f674231478e4022ba6c0c6f5e86e170O.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hbde024da1f2b4296a1e690100dd99c12Z.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H74feceaa28454b0191514acfdab0db0c0.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hdad41908413c4164a0d0ed4036dc9b85g.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hc9bd810c21a3401aa74f2612e21c1bbf9.jpg" slate-data-type="image"></p><div><br><br><br><br></div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/Hd92e47a6e14c41b783ac1797839fdc3a8/Foldable-Handmade-Seagrass-Flower-Pot-Storage-Wicker-Basket-Rattan-Straw-Home-Garden-Wave-Pattern-Planter-pots.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H5f27a23f9e4b4779a380434e0aa68c7cA/Foldable-Handmade-Seagrass-Flower-Pot-Storage-Wicker-Basket-Rattan-Straw-Home-Garden-Wave-Pattern-Planter-pots.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H2ccdd145c83a45a7b7c4cf184e1c02bah/Foldable-Handmade-Seagrass-Flower-Pot-Storage-Wicker-Basket-Rattan-Straw-Home-Garden-Wave-Pattern-Planter-pots.jpg", localFile: ""),
    ],
    priceProduct: 18.66,
    discPriceProduct: 15.16,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "Beige 1PCS")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H9b8694487f2c4685904b1cd0b05c5a9a6/Foldable-Handmade-Seagrass-Flower-Pot-Storage-Wicker-Basket-Rattan-Straw-Home-Garden-Wave-Pattern-Planter-pots.jpg_50x50.jpg", localFile: ""),
            stock: 99,
          ),
          PriceData([
            StringData(code: "en", text: "Blue 1PCS")],
            2, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H17f87f7051894a61b476a6204b76e64fd/Foldable-Handmade-Seagrass-Flower-Pot-Storage-Wicker-Basket-Rattan-Straw-Home-Garden-Wave-Pattern-Planter-pots.jpg_50x50.jpg", localFile: ""),
            stock: 99,
          ),
        ],
      ),
      GroupData(id: "5067e649-930c-4957-004-02", name: [StringData(code: "en", text: "Sheet Size")],
        price: [
          PriceData([
            StringData(code: "en", text: "23cm")],
            0, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 99,
          ),
          PriceData([
            StringData(code: "en", text: "27cm")],
            2, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 99,
          ),
          PriceData([
            StringData(code: "en", text: "31cm")],
            4, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 99,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/2207617615125/p/1/e/6/t/10301/309896907443.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 16
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ016",
    [StringData(code: "en", text: "Seaweed Wicker Basket Rattan Hanging Flowerpot Flowerpot Dirty")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div>
<div>
<div>
<div>
<div>
<p><strong><span style="font-size:14px;" data-spm-anchor-id="a2g0o.detail.1000023.i0.17d89ba0xv5Psz">Features:<br>
Made by seagrass, natural environmental friendly.<br>
Pure hand-woven drying, can fold and save space.<br>
Beautiful and practical, fresh wild, hanging in any place you like.<br>
Multi-purpose, decor, grocery baskets, plant pot covers, toy organizer, etc.<br>
Perfect for every corner of the house, corridor, living room, children's room, bathroom, balcony space.<br>
<br>
Descriptions:<br>
Each selected wicker has been carefully screened for quality assurance.<br>
Convertible, use the baskets with the handles out or folded down as bowl-style baskets.<br>
Can be washed directly with water, or wipe with a damp cloth.<br>
<br>
Color: natural color<br>
Material: vine<br>
Packing: basketx1<br>
Size: see&nbsp; picture<br>
<br>
<br>
Please note:<br>
Due to manual measurement, the size may have an error of 1-2 cm<br>
Color may vary due to different displays<br>
Due to the long transit time, the item may be damaged during transportation. If the item is damaged, please contact us before leaving the feedback. Thank you for your understanding.</span></strong><br>
<img referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/HTB1edRzKCzqK1RjSZFjq6zlCFXaF.jpg" style="width:600px;"></p>

<p><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/H0d0a87c934ec41098674425e95975308Y.jpg?width=564&amp;height=564&amp;hash=1128" style="max-width: 750.0px;"></p>

<p><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/Hadff25aefdcc45d096c14f294b67bb5dD.jpg?width=800&amp;height=800&amp;hash=1600" style="max-width: 750.0px;"><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/Hd6ab5c6f94104aefa9e88c7a0d06520cB.jpg?width=750&amp;height=543&amp;hash=1293" style="max-width: 750.0px;"></p>

<p>&nbsp;</p>

<p><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/H0f53524d0db743dbb18d4f9c1ca8961e2.jpg?width=750&amp;height=472&amp;hash=1222" style="max-width: 750.0px;"><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/Hefbab91d21aa4923b6759066814cfc17e.jpg?width=750&amp;height=500&amp;hash=1250" style="max-width: 750.0px;"></p>

<p><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/H59602e87429843f3b3b877579ef77ffcX.jpg?width=750&amp;height=500&amp;hash=1250" style="max-width: 750.0px;"><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/H151221e905894492918e9a1f1f33e8cck.jpg?width=750&amp;height=500&amp;hash=1250" style="max-width: 750.0px;"></p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p><span style="text-align: start;color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span><span style="text-align: start;color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span><span style="text-align: start;color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span><span style="text-align: start;color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span><span style="text-align: start;color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span></p>

<p><span style="font-family: microsoft yahei;"><span style="color: #93c47d;"><span style="font-size: 60.0px;">越南进口版</span></span></span></p>

<p><span style="font-family: microsoft yahei;"><span style="color: #93c47d;"><span style="font-size: 60.0px;"><span style="font-size: 24.0px;">(宜家同款,北欧正品,ins各网站出现的出口款)</span></span></span></span></p>

<p><span style="font-family: microsoft yahei;"><span style="color: #93c47d;"><span style="font-size: 60.0px;"><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/Ha9a19816fd7c4bca8410a2e9661e8274z.jpg?width=750&amp;height=608&amp;hash=1358" style="max-width: 750.0px;"><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/H9254cba5aa564a65b0d4f4b774e6490eg.jpg?width=800&amp;height=800&amp;hash=1600" style="max-width: 750.0px;"></span></span></span></p>

<p><span style="font-family: microsoft yahei;"><span style="color: #93c47d;"><span style="font-size: 60.0px;"><img align="absmiddle" referrerpolicy="no-referrer" src="https://ae01.alicdn.com/kf/H95a563d6253b4eebb007630fb391208bw.jpg?width=750&amp;height=1311&amp;hash=2061" style="max-width: 750.0px;"></span></span></span></p>

<p><span style="color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span><span style="color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span></p>

<div style="font-size: 0.0px;">Template protection code 0528</div>

<p><span style="color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span></p>

<p><span style="color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span></p>

<p><span style="color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span><span style="color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span></p>

<div><span style="color: white;line-height: 0.0px;font-size: 0.0px;">- -_- -</span></div>
</div>
</div>
</div>
</div>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/Hadff25aefdcc45d096c14f294b67bb5dD.jpg?width=800&height=800&hash=1600", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Hd6ab5c6f94104aefa9e88c7a0d06520cB.jpg?width=750&height=543&hash=1293", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H0f53524d0db743dbb18d4f9c1ca8961e2.jpg?width=750&height=472&hash=1222", localFile: ""),
    ],
    priceProduct: 2.06,
    discPriceProduct: 1.6,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "11CM XXS")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/Hbeb7d4524c984441a8eea28f83a07e599/Seaweed-Wicker-Basket-Rattan-Hanging-Flowerpot-Flowerpot-Dirty-Clothes-Dirty-Clothes-Basket-Storage-Basket-WF1015.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 99,
          ),
          PriceData([
            StringData(code: "en", text: "16CM XS")],
            1.22, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H987f5f5000cd42b889f7f86ff1f667baC/Seaweed-Wicker-Basket-Rattan-Hanging-Flowerpot-Flowerpot-Dirty-Clothes-Dirty-Clothes-Basket-Storage-Basket-WF1015.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 99,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 17
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ017",
    [StringData(code: "en", text: "Garden vacuum cleaner Cub Cadet CSV 050")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="ProductDescription-module_content__1xpeo"><h1 style="font-size:medium;font-weight:400;letter-spacing:normal;text-align:start;white-space:normal;color:rgb(0, 0, 0)"><strong>Garden vacuum cleaner Cub Cadet CSV 050</strong> </h1><p style="font-size:medium;font-weight:400;letter-spacing:normal;text-align:start;white-space:normal;color:rgb(0, 0, 0)" data-spm-anchor-id="a2g2w.detail.1000023.i0.26632a83KMRjuX">Designed for cleaning the garden territory from foliage, beveled grass, fine wood chips and other debris.<br>Based on engine cubcadet 173 cm3<br>Combines several tools: a vacuum cleaner and a branch chopper.<br>Diameter of shredded branches up to 3,8 cm. (1.5dm), the download is carried out in a separate hole.<br>Grinding System: steel knives<br>Total grinding 8:1<br>5-speed individual adjustment of front wheels in height (from 16 to 104mm.) allows you to fit the suction height.<br>Propeller blower made of aviation aluminum, diameter 37 cm<br>A special corrugated hose will allow you to clean hard-to-reach places.<br>Front wheels: tires 8 "x 2" DM<br>Rear wheels 12 "x 2" DM<br>Garden vacuum cleaner Cub Cadet CSV 060 has a large built-in garbage bin, which allows you to work more time without stops. Wheels with ball bearings ensure smooth operation and minimal backlash even after many years of operation.</p><p>3 years warranty</p><p></p><h1>Specifications</h1><p>Fuel gasoline AI 92-95</p><p>Power HP</p><p>Engine 173 cm3</p><p>Air flow rate 320 m/s</p><p>Net weight 37 kg</p><img width="750" height="750" src="https://ae01.alicdn.com/kf/Ub2ced8055f7c4e88bd94c9ec845c1a54h.jpg" slate-data-type="image"><img width="750" height="750" src="https://ae01.alicdn.com/kf/Ub2648565832446c5b3075fb37c2f572fw.jpg" slate-data-type="image"><img width="750" height="422.16494845360825" src="https://ae01.alicdn.com/kf/Ua6dee16ea75747e49447d4fb5a8a5291s.jpg" slate-data-type="image"><img width="750" height="500.25" src="https://ae01.alicdn.com/kf/U3e21a910ada24ababa102cf148737d81r.jpg" slate-data-type="image"><img width="750" height="645.6241032998565" src="https://ae01.alicdn.com/kf/Uc8fe399de9bf4e80a0b9e90c10fee57bL.jpg" slate-data-type="image"><img width="750" height="750" src="https://ae01.alicdn.com/kf/U94497c9e753b456a80ac2d65169199220.jpg" slate-data-type="image"><p></p>
<script>window.adminAccountId=1013712628;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/Ub2ced8055f7c4e88bd94c9ec845c1a54h/Garden-vacuum-cleaner-Cub-Cadet-CSV-050.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Ub2648565832446c5b3075fb37c2f572fw/Garden-vacuum-cleaner-Cub-Cadet-CSV-050.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/U3e21a910ada24ababa102cf148737d81r/Garden-vacuum-cleaner-Cub-Cadet-CSV-050.jpg", localFile: ""),
    ],
    priceProduct: 503,
    discPriceProduct: 0,
    stock: 10,
    group: [],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 18
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ018",
    [StringData(code: "en", text: "High Powerful ZOOM Sensor Headlamp XHP50 Super Bright Outdoor Headlight torch Flashlight USB Rechargeable ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div>
<div>
<div>
<div>
<div>
<div></div></div>
<div class="detailmodule_dynamic"><kse:widget data-widget-type="customText" id="1005000000470149" title="" type="custom"><div style="clear: both;"><p><a href="https://nl.aliexpress.com/item/1005003219501076.html?spm=a2g0o.detail.1000023.15.7c9010da2lFgqb" target="_self" data-spm-anchor-id="a2g0o.detail.1000023.15"><img width="944" height="472" src="https://ae01.alicdn.com/kf/H37a704c219ac43c5bdfab5145b83c0721.jpg" data-spm-anchor-id="a2g0o.detail.1000023.i0.7c9010da2lFgqb"></a><a href="https://www.aliexpress.com/item/1005002505719031.html?spm=a2g0o.detail.1000023.16.7c9010da2lFgqb" target="_self" data-spm-anchor-id="a2g0o.detail.1000023.16"><img width="944" height="472" src="https://ae01.alicdn.com/kf/H2865b317ff694f678eef24358b81b734b.jpg"></a><a href="https://www.aliexpress.com/item/1005002082329323.html?spm=a2g0o.detail.1000023.17.7c9010da2lFgqb" target="_self" data-spm-anchor-id="a2g0o.detail.1000023.17"><img width="900" height="450" src="https://ae01.alicdn.com/kf/H2407d0c19b7e456982ad60e96649723fl.jpg"></a></p></div></kse:widget></div>
<div class="detailmodule_html"><div class="detail-desc-decorate-richtext"></div>
</div>
</div>
</div>
</div>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/H6ddbbeac8951431d9806dac73620dd7bW.jpg?width=1000&height=1000&hash=2000", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H1a545f91aa4a48a7931c1448cac0b556i.jpg?width=790&height=790&hash=1580", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Hec54c1eb708f49c7ad36d36d417ac31cC.jpg?width=790&height=790&hash=1580", localFile: ""),
    ],
    priceProduct: 8.37,
    discPriceProduct: 17.2,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Emitting Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "A Packing")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/Ha0753f583b7f48b2ada8b3d2e9ba82fcA/High-Powerful-ZOOM-Sensor-Headlamp-XHP50-Super-Bright-Outdoor-Headlight-torch-Flashlight-USB-Rechargeable-Light-Fishing.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "B Packing")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H720761b1ad714624aa75fec79722f71dq/High-Powerful-ZOOM-Sensor-Headlamp-XHP50-Super-Bright-Outdoor-Headlight-torch-Flashlight-USB-Rechargeable-Light-Fishing.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 99,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 19
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ019",
    [StringData(code: "en", text: "Portable Powerful LED Lamp XML-T6 Flashlight Linterna Torch Uses 18650 ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div></div></div>
<div class="detailmodule_dynamic"><kse:widget data-widget-type="relatedProduct" id="1005000000435251" title="" type="relation"><div style="max-width: 650.0px;overflow: hidden;font-size: 0;clear: both;"><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/COB-LED-Headlamp-Sensor-Headlight-with-Built-in-Battery-Flashlight-USB-Rechargeable-Head-Lamp-Torch-5/1005002505719031.html?spm=a2g0o.detail.1000023.1.74244b33xiF2oP" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;" data-spm-anchor-id="a2g0o.detail.1000023.1"><img src="//ae01.alicdn.com/kf/H3339a99043a0441a98e741f495e6f766r.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/COB-LED-Headlamp-Sensor-Headlight-with-Built-in-Battery-Flashlight-USB-Rechargeable-Head-Lamp-Torch-5/1005002505719031.html?spm=a2g0o.detail.1000023.2.74244b33xiF2oP" title="COB LED Headlamp Sensor Headlight with Built-in Battery Flashlight USB Rechargeable Head Lamp Torch 5 Lighting Modes Work Light" style="color: #666666;cursor: pointer;" name="productSubject" data-spm-anchor-id="a2g0o.detail.1000023.2">COB LED Headlamp Sensor Headlight with Built-in Battery Flashlight USB Rechargeable Head Lamp Torch 5 Lighting Modes Work Light</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 21.80-26.20</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/New-P50-Flashlight-USB-Rechargeable-Flash-Light-Cob-Led-Multifunctional-Portable-Flashlight-Torch-Light-with-Power/1005003189238698.html?spm=a2g0o.detail.1000023.3.74244b33xiF2oP" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;" data-spm-anchor-id="a2g0o.detail.1000023.3"><img src="//ae01.alicdn.com/kf/H4a98bfd865ed44dead47eeae5e8a2fc7G.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/New-P50-Flashlight-USB-Rechargeable-Flash-Light-Cob-Led-Multifunctional-Portable-Flashlight-Torch-Light-with-Power/1005003189238698.html?spm=a2g0o.detail.1000023.4.74244b33xiF2oP" title="New P50 Flashlight USB Rechargeable Flash Light Cob Led Multifunctional Portable Flashlight Torch Light with Power Bank" style="color: #666666;cursor: pointer;" name="productSubject" data-spm-anchor-id="a2g0o.detail.1000023.4">New P50 Flashlight USB Rechargeable Flash Light Cob Led Multifunctional Portable Flashlight Torch Light with Power Bank</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 9.37-16.48</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/USB-Rechargeable-COB-LED-Headlamps-Head-Torch-Light-Work-Light-3-Modes-Red-Warning-Strobe-Riding/1005003049342400.html?spm=a2g0o.detail.1000023.5.74244b33xiF2oP" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;" data-spm-anchor-id="a2g0o.detail.1000023.5"><img src="//ae01.alicdn.com/kf/H91ed57d09d0f4bb8ad9da028ea01f0bb5.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/USB-Rechargeable-COB-LED-Headlamps-Head-Torch-Light-Work-Light-3-Modes-Red-Warning-Strobe-Riding/1005003049342400.html?spm=a2g0o.detail.1000023.6.74244b33xiF2oP" title="USB Rechargeable COB LED Headlamps Head Torch Light Work Light 3 Modes Red Warning Strobe Riding Headlamp fishing Camping Light" style="color: #666666;cursor: pointer;" name="productSubject" data-spm-anchor-id="a2g0o.detail.1000023.6">USB Rechargeable COB LED Headlamps Head Torch Light Work Light 3 Modes Red Warning Strobe Riding Headlamp fishing Camping Light</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 9.95-14.26</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/High-Powerful-ZOOM-Sensor-Headlamp-XHP50-Super-Bright-Outdoor-Headlight-torch-Flashlight-USB-Rechargeable-Light-Fishing/1005003219501076.html?spm=a2g0o.detail.1000023.7.74244b33xiF2oP" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;" data-spm-anchor-id="a2g0o.detail.1000023.7"><img src="//ae01.alicdn.com/kf/Hf43881cdebae4c1eb293c91bdcf29a59d.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/High-Powerful-ZOOM-Sensor-Headlamp-XHP50-Super-Bright-Outdoor-Headlight-torch-Flashlight-USB-Rechargeable-Light-Fishing/1005003219501076.html?spm=a2g0o.detail.1000023.8.74244b33xiF2oP" title="High Powerful ZOOM Sensor Headlamp XHP50 Super Bright Outdoor Headlight torch Flashlight USB Rechargeable Light Fishing Light" style="color: #666666;cursor: pointer;" name="productSubject" data-spm-anchor-id="a2g0o.detail.1000023.8">High Powerful ZOOM Sensor Headlamp XHP50 Super Bright Outdoor Headlight torch Flashlight USB Rechargeable Light Fishing Light</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 8.37-13.75</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/LED-Induction-Headlamp-COB-Headlight-Built-in-1200mAh-Lithium-Battery-Rechargeable-Portable-5-Modes-Warning-Head/1005003023200000.html?spm=a2g0o.detail.1000023.9.74244b33xiF2oP" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;" data-spm-anchor-id="a2g0o.detail.1000023.9"><img src="//ae01.alicdn.com/kf/Hcf2ae0bde60b40aca5a70bf74cf5b07ca.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/LED-Induction-Headlamp-COB-Headlight-Built-in-1200mAh-Lithium-Battery-Rechargeable-Portable-5-Modes-Warning-Head/1005003023200000.html?spm=a2g0o.detail.1000023.10.74244b33xiF2oP" title="LED Induction Headlamp COB Headlight Built-in 1200mAh Lithium Battery Rechargeable Portable 5 Modes Warning Head Torch" style="color: #666666;cursor: pointer;" name="productSubject" data-spm-anchor-id="a2g0o.detail.1000023.10">LED Induction Headlamp COB Headlight Built-in 1200mAh Lithium Battery Rechargeable Portable 5 Modes Warning Head Torch</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 9.13-22.34</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/Portable-Rechargeable-Zoom-LED-Flashlight-XP-G-Q5-Flash-Light-Torch-Lantern-3-Lighting-Modes-Camping/1005002353286817.html?spm=a2g0o.detail.1000023.11.74244b33xiF2oP" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;" data-spm-anchor-id="a2g0o.detail.1000023.11"><img src="//ae01.alicdn.com/kf/H0b803dea8db9477fa55d756ee3a58771v.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/Portable-Rechargeable-Zoom-LED-Flashlight-XP-G-Q5-Flash-Light-Torch-Lantern-3-Lighting-Modes-Camping/1005002353286817.html?spm=a2g0o.detail.1000023.12.74244b33xiF2oP" title="Portable Rechargeable Zoom LED Flashlight XP-G Q5 Flash Light Torch Lantern 3 Lighting Modes Camping Light Mini Led Flashlight" style="color: #666666;cursor: pointer;" name="productSubject" data-spm-anchor-id="a2g0o.detail.1000023.12">Portable Rechargeable Zoom LED Flashlight XP-G Q5 Flash Light Torch Lantern 3 Lighting Modes Camping Light Mini Led Flashlight</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 2.97-3.94</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/Portable-Powerful-LED-Lamp-XML-T6-Flashlight-Linterna-Torch-Uses-18650-Chargeable-Battery-Outdoor-Camping-Tactics/1005002082329323.html?spm=a2g0o.detail.1000023.13.74244b33xiF2oP" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;" data-spm-anchor-id="a2g0o.detail.1000023.13"><img src="//ae01.alicdn.com/kf/H016ef5d5d5ab4a74b052203c45fecd04q.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/Portable-Powerful-LED-Lamp-XML-T6-Flashlight-Linterna-Torch-Uses-18650-Chargeable-Battery-Outdoor-Camping-Tactics/1005002082329323.html?spm=a2g0o.detail.1000023.14.74244b33xiF2oP" title="Portable Powerful LED Lamp XML-T6  Flashlight Linterna Torch Uses 18650 Chargeable Battery Outdoor Camping Tactics Flash Light" style="color: #666666;cursor: pointer;" name="productSubject" data-spm-anchor-id="a2g0o.detail.1000023.14">Portable Powerful LED Lamp XML-T6  Flashlight Linterna Torch Uses 18650 Chargeable Battery Outdoor Camping Tactics Flash Light</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 3.89-11.44</em>/piece</span></div></div></kse:widget></div>
<div class="detailmodule_html"><div class="detail-desc-decorate-richtext"></div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div></div></div>
<div class="detailmodule_dynamic"><kse:widget data-widget-type="customText" id="1005000000470149" title="" type="custom"><div style="clear: both;"><p><a href="https://nl.aliexpress.com/item/1005003219501076.html?spm=a2g0o.detail.1000023.15.74244b33xiF2oP" target="_self" data-spm-anchor-id="a2g0o.detail.1000023.15"><img width="944" height="472" src="https://ae01.alicdn.com/kf/H37a704c219ac43c5bdfab5145b83c0721.jpg" data-spm-anchor-id="a2g0o.detail.1000023.i0.74244b33xiF2oP"></a><a href="https://www.aliexpress.com/item/1005002505719031.html?spm=a2g0o.detail.1000023.16.74244b33xiF2oP" target="_self" data-spm-anchor-id="a2g0o.detail.1000023.16"><img width="944" height="472" src="https://ae01.alicdn.com/kf/H2865b317ff694f678eef24358b81b734b.jpg"></a><a href="https://www.aliexpress.com/item/1005002082329323.html?spm=a2g0o.detail.1000023.17.74244b33xiF2oP" target="_self" data-spm-anchor-id="a2g0o.detail.1000023.17"><img width="900" height="450" src="https://ae01.alicdn.com/kf/H2407d0c19b7e456982ad60e96649723fl.jpg"></a></p></div></kse:widget></div>
<div class="detailmodule_html"><div class="detail-desc-decorate-richtext"></div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<div><br>
<img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hb2ae7321e6f140b5a043203d2d42b64c0.jpg?width=1000&amp;height=122&amp;hash=1122"></div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<div><span style="font-size:18px">specification:</span><br>
Material: aluminum alloy<br>
Power supply: one 18650 lithium ion battery or 3 AAA batteries<br>
Maximum brightness: 1000LM<br>
Irradiation distance: 200-500m<br>
Waterproof rating: IP65<br>
Size: 12.9cm~32mm~32mm<br>
Net weight: 87 grams<br>
<span style="font-size:18px">battery:</span><br>
Output: 3.7V<br>
Voltage: 3.7V<br>
Battery capacity: 6800mAh (the company's patented battery)<br>
<br>
<br>
<span style="font-size:18px">About LED flashlight</span><br>
<br>
This high-quality waterproof 1000LM LED flashlight/flashlight with dimmer, by adjusting the telescopic head, you can get spot beam and flood beam according to your needs. Ideal for cavers, forest explorers, hunters, fishermen, etc.?<br>
<br>
feature:<br>
<br>
-Using XM-L T6 lamp, the maximum brightness is 1000LM, and the irradiation distance is 200-500m<br>
-Internal wiring provides constant current output, wide working range, and battery can be utilized to the greatest extent.<br>
-One key five modes: for you to choose high light, medium light, low light, strobe and SOS light.<br>
-Zoom in and out<br>
-Aluminum alloy shell and non-slip design, feel more comfortable<br>
-Widely used for outdoor activities such as mountaineering, camping, hiking, forest exploration, or used to repair or find small objects in the family.<br>
<br>
About 18650 battery<br>
-BRC 18650 3.7V 6800mAh rechargeable protection lithium-ion battery<br>
-Overheating and overcurrent protection<br>
-Short circuit protection and environmental protection<br>
-Widely used in flashlights, laser pointers, emergency lighting equipment and other portable equipment</div>

<p align="left" style="text-align:left;margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H4f28905dad3447a8a457eab812eab3c3Z.jpg?width=1000&amp;height=2155&amp;hash=3155"></p>

<div>&nbsp;</div>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/Hf26ff5467aac48a18b1d124b166c5509l.jpg?width=800&height=800&hash=1600", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H685767fac6894d9f8d9bf93d6ef3361eO.jpg?width=800&height=534&hash=1334", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Hce7710c284e140cdb5790254f77b75a5B.jpg?width=800&height=800&hash=1600", localFile: ""),
    ],
    priceProduct: 8.88,
    discPriceProduct: 5.88,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Emitting Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "H Packing")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H38e888001b1f4ecda6aad4a45b989733H/Portable-Powerful-LED-Lamp-XML-T6-Flashlight-Linterna-Torch-Uses-18650-Chargeable-Battery-Outdoor-Camping-Tactics.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "I Packing")],
            2, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/Hdba89b9e625743eb943e67adfc41f51a2/Portable-Powerful-LED-Lamp-XML-T6-Flashlight-Linterna-Torch-Uses-18650-Chargeable-Battery-Outdoor-Camping-Tactics.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 20
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ020",
    [StringData(code: "en", text: "Outdoor survival shovel Military Tactical Multifunction garden tool Shovel C")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<p align="left" style="text-align:left;margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px"><br>
<span style="font-size:20px"><strong data-spm-anchor-id="a2g0o.detail.1000023.i0.715b334b1Aj3ng">Type: Multifunctional Shovel<br>
Material: carbon steel<br>
Model: Tactical folding shovel<br>
Application: camping shovel<br>
Product Category: Outdoor Shovel<br>
Total length: 68cm<br>
Shovel: 13*17cm<br>
Shovel material: manganese steel<br>
Handle material: aluminum alloy<br>
Thickness: 2.5mm<br>
Hardness: 58 HRC<br>
Weight: 1.2kg<br>
Tactical blade length: 8.8cm<br>
<br>
Shovel<br>
1. Shovel surface + G1 tube. Multi-function knife + G2 tube. Screwdriver + G3 tube.<br>
2. Expansion: tactical sticks / climbing sticks (additional extension rods are used as required)<br>
3. Manufacturing process: CNC machining<br>
<br>
Functions:<br>
4. Cut, pierce, get graduated knife, bottle opener, screwdriver, survival whistle, broken conical glass, trekking pole, tactical stick.<br>
5. Accessories: shovel surface, shank * 3, multi-function knife, attack cone, whistle, screwdriver, cloth bag, color box, instruction manual<br>
6. Best use: camping, hiking, autonomous driving equipment, camping, emergency tools.</strong></span><br>
<br>
<img slate-data-type="image" src="https://ae01.alicdn.com/kf/Haa3d3f268fec41f3a05e83a36d5a2845Z.jpg?width=800&amp;height=4364&amp;hash=5164"></p>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/Haa3d3f268fec41f3a05e83a36d5a2845Z.jpg?width=800&height=4364&hash=5164", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Haa3d3f268fec41f3a05e83a36d5a2845Z.jpg?width=800&height=4364&hash=5164", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Haa3d3f268fec41f3a05e83a36d5a2845Z.jpg?width=800&height=4364&hash=5164", localFile: ""),
    ],
    priceProduct: 19.48,
    discPriceProduct: 23.45,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "D15-30")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H4f41cad8a553495e97369cda7f0d003eI/Outdoor-survival-shovel-Military-Tactical-Multifunction-garden-tool-Shovel-Camping-Folding-Spade-Tool-Car-Equipment-Snow.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 21
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ021",
    [StringData(code: "en", text: "2021 New Car-styling Soft Wool Car Wash Washing Gloves Auto Care ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext">
  <p><span style="font-size:16px"><strong>Features:</strong></span><span style="font-size:16px" data-spm-anchor-id="a2g0o.detail.1000023.i0.2776112cniHG9l"><br> High quality wool makes exquisite foam<br> Mitten design to provides better skid resistance<br> Suitable for cleaning car, furniture, glass and etc.<br> <br> </span><span style="font-size:16px"><strong data-spm-anchor-id="a2g0o.detail.1000023.i1.2776112cniHG9l">Specifications:</strong></span><span style="font-size:16px"><br> Material: Artificial Wool<br> Color: Beige<br> Size: 210*140mm<br> <br> </span><span style="font-size:16px"><strong>Package Included:</strong></span><span style="font-size:16px"><br> 1 x Car Washing Gloves</span></p>
  <p><img src="https://ae01.alicdn.com/kf/H8eee120c02894bf68d419de0b9d3408bk.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Ha18179e1539c4a338dec5865bb99f065O.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H082a7fa8da6a4b14b0ba0dea6939a885o.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H685c4a1a0e614fa3a75d747a7c30e332i.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H0855a3883a704aeead73288ae8520f8ax.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H3f3e576c695645b59add2cb82c59ee6cb.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H6f385a5f2e12460a877d8c7982eb9898v.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H526de655fb924cc19e308315bb219d1e9.jpg" slate-data-type="image"></p>
 </div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/H8eee120c02894bf68d419de0b9d3408bk.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Ha18179e1539c4a338dec5865bb99f065O.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H082a7fa8da6a4b14b0ba0dea6939a885o.jpg", localFile: ""),
    ],
    priceProduct: 1.44,
    discPriceProduct: 0.46,
     stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "red")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H4d9b2f0157b049a58d16df86a13e33deg/2021-New-Car-styling-Soft-Wool-Car-Wash-Washing-Gloves-Auto-Care-Car-Cleaning-Microfiber-210X140mm.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "black")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/Hbfaedb1a55de413ea132a8063a391e43d/2021-New-Car-styling-Soft-Wool-Car-Wash-Washing-Gloves-Auto-Care-Car-Cleaning-Microfiber-210X140mm.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 22
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ022",
    [StringData(code: "en", text: "4PCS-31PCS Kitchen Cleaning Brush Kits Power Scrub Pads ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="origin-part box-sizing"><div class="detailmodule_dynamic"><kse:widget data-widget-type="customText" id="1005000000469730" type="undefined"><div style="clear: both;"><p><img src="https://ae01.alicdn.com/kf/H1654774f8625474c8928cfb7c9430992D.png" data-spm-anchor-id="a2g0o.detail.1000023.i0.3d0258a6wdhjJo"><img src="https://ae01.alicdn.com/kf/Hbf7eb92e0a774d38958ce2d81e64c533w.png"><img src="https://ae01.alicdn.com/kf/H3cc0916b7b3d4a768f2c8cceea29c406t.png"><img src="https://ae01.alicdn.com/kf/H3863cdffa2f74251a44af1f3e3ee9bebI.png"></p></div></kse:widget></div><div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><p><span style="font-size:22px"><span style="font-family:verdana, geneva, sans-serif">4PCS-31PCS Power Scrub Pads Scrubber Kitchen Cleaning Brush Kits Multipurpose Cleaner Scrubbing Cordless Electric Drill Brushes</span></span></p><p><br></p><p><span style="font-size:20px"><span style="font-family:&quot;times new roman&quot;, times, serif"><strong>Product Name:</strong></span></span><span style="font-size:20px"><span style="font-family:&quot;times new roman&quot;, times, serif">Drill Brushes（Drill is not included）</span></span></p><p><span style="font-size:20px"><span style="font-family:&quot;times new roman&quot;, times, serif"><strong>Size:</strong></span></span><span style="font-size:20px"><span style="font-family:&quot;times new roman&quot;, times, serif">As picture shows. Each bristles has 1/4'' hex type rod, can easily attach to your drills.</span></span></p><p><span style="font-size:20px"><span style="font-family:&quot;times new roman&quot;, times, serif"><strong>Usage:</strong></span></span><span style="font-size:20px"><span style="font-family:&quot;times new roman&quot;, times, serif">Working with drills, the product can&nbsp;perfectly&nbsp;help&nbsp;with your cleaning work. It could be applied to bathroom, nathtubs, sinks, shower door tracks, tiles, kitchen, auto, etc.</span></span></p><p><span style="font-size:20px"><span style="font-family:&quot;times new roman&quot;, times, serif"><strong>Package:</strong></span></span><span style="font-size:20px"><span style="font-family:&quot;times new roman&quot;, times, serif">The color of the products may be&nbsp;a little different from what the pictures show, but the quantity is absolutely the same! Thank you for your understanding!</span></span></p><p><br></p><div><br></div><p style="text-align:center" align="center"><img src="https://ae01.alicdn.com/kf/Hd9580b0b10cb4124955eeeec21e6f924E.jpg" slate-data-type="image"></p><div><br></div><p style="text-align:center" align="center"><img width="800" height="800" src="https://ae01.alicdn.com/kf/Hea161a1410564734a8dcc4859c562653U.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H9e99248525854ac2aa7b703fefc6fd00c.jpg" slate-data-type="image"><img width="800" height="800" src="https://ae01.alicdn.com/kf/H8880ef1a93ef4897af9a99469b32755dJ.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H2585d5c1ef13444bab9d2abd50913ff1M.jpg" slate-data-type="image"><img width="800" height="800" src="https://ae01.alicdn.com/kf/Hd65e3fe33f6543de909840a46b331a03p.jpg" slate-data-type="image"><img width="800" height="800" src="https://ae01.alicdn.com/kf/Hd11ee1b0db9249e48b2393c13b1c0483e.jpg" slate-data-type="image"><img width="800" height="800" src="https://ae01.alicdn.com/kf/Hf31f6e8061cc41d2a4f7ede292ed0f5ez.jpg" slate-data-type="image"><img width="800" height="800" src="https://ae01.alicdn.com/kf/Hb86a8d0f565a48598ca6f4d4b1081d3aH.jpg" slate-data-type="image"><img width="800" height="800" src="https://ae01.alicdn.com/kf/Hd2d5179aa564418689dda72e5c218f64Z.jpg" slate-data-type="image"><img width="800" height="800" src="https://ae01.alicdn.com/kf/Hd0f4ad817be54eab83b7cc1f4d53a469y.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hd04f20b437094ec0a3eb632d4b8edfefd.jpg" slate-data-type="image"></p><p><br></p></div></div><div class="detailmodule_dynamic"><kse:widget data-widget-type="customText" id="1000000269819" type="undefined"><div style="clear: both;"><p style="text-align: center;"> <img alt="HTB138vaOAzoK1RjSZFlq6yi4VXaL" src="https://ae01.alicdn.com/kf/Hc9c0232de53f425896fa5dc42be37bb12.jpg"><img alt="wowuyul_02" src="https://ae01.alicdn.com/kf/HTB1urnvSXXXXXbJXFXXq6xXFXXXC.jpg?size=107785&amp;height=844&amp;width=960&amp;hash=66d0db1175c74ab4e9e6a87fe4c0b6d2"><img alt="f40b147c302470a206553cef4713a93f_HTB1oPu5SXXXXXbsapXXq6xXFXXXo_size=112020&amp;height=919&amp;width=960&amp;hash=0a6ee50e648328e34e0cadeceb223438" src="https://ae01.alicdn.com/kf/Hf766a948af9b4929822a402150bcb9a1C.jpg"><a href="https://www.aliexpress.com/store/900254310"><img alt="wowuyul_04" src="https://ae01.alicdn.com/kf/HTB1wFzSSXXXXXXNXXXXq6xXFXXX7.jpg?size=6959&amp;height=93&amp;width=960&amp;hash=47f93a7f5f141114f8de8574b5a78a6d"></a></p>
<div>
  &nbsp; 
</div></div></kse:widget></div><p><br></p>
<script>window.adminAccountId=243881915;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/Hd9580b0b10cb4124955eeeec21e6f924E.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Hd9580b0b10cb4124955eeeec21e6f924E.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H9e99248525854ac2aa7b703fefc6fd00c.jpg", localFile: ""),
    ],
    priceProduct: 8.99,
    discPriceProduct: 6.99,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Quantity")],
        price: [
          PriceData([
            StringData(code: "en", text: "4pcs")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H63053d1b6e8b4b5ba4dfb47350bb4344O/4PCS-31PCS-Kitchen-Cleaning-Brush-Kits-Power-Scrub-Pads-Scrubber-Multipurpose-Cleaner-Scrubbing-Cordless-Electric-Drill.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "18pcs")],
            10, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H704474d6e0a74723a64df45cb1091da4y/4PCS-31PCS-Kitchen-Cleaning-Brush-Kits-Power-Scrub-Pads-Scrubber-Multipurpose-Cleaner-Scrubbing-Cordless-Electric-Drill.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 23
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ023",
    [StringData(code: "en", text: "Magnetic Wrist Strap Kit Screw Nail Nut Bolt Drill Bit Repair Kit Organizer ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="ProductDescription-module_content__1xpeo"><p><span style="font-size:24px;font-family:verdana, geneva, sans-serif" data-spm-anchor-id="a2g2w.detail.1000023.i0.38aa1fc4Tnq6BD">Magnetic Wrist Strap Kit Screw Nail Nut Bolt Drill Bit Repair Kit Organizer Magnet Pickup Screw Storage Wristband Portable Tool</span></p><p><br></p><p><strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif">Product:</span></strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif"> Magnetic Wristband Portable Tool Bag</span></p><p><strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif">Origin:</span></strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif"> CN(Origin)</span></p><p><strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif">Display Type:</span></strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif"> Tool Bag</span></p><p><strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif">Feature:</span></strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif"> Portable</span></p><p><br></p><p><strong><span style="font-size:16px;font-family:verdana, geneva, sans-serif">Note：</span></strong></p><p><span style="font-size:16px;font-family:verdana, geneva, sans-serif">1. Please allow 1-2 cm differences due to manual measurement.</span></p><p><span style="font-size:16px;font-family:verdana, geneva, sans-serif">2. Due to differences in shooting light and computer monitors, the picture may not reflect the actual color of the product. Thanks for your understanding.</span></p><p><br></p><p style="text-align:center" align="center"><img src="https://ae01.alicdn.com/kf/H92047eeccfab4f87ab3925294aeaa844N.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hee5902dc9afd464684afd005b79e427bF.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hbf2e71470416476a8b61f9734ba17961h.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H9e1e48aaa9a6412ea9cf6b91800c72bcB.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H9e685594d2e14985af2794e933e2e158s.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H1b620610c853489cbd3fd7c67bbbf709i.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hc44c2cb4a0bb4c73863b6dfe2faaa80ct.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H3fa01934bd4741fba7dc9632af7e78889.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hb6a885b5f089446487916ead1632da89k.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H1f22d171ae984347abb8b1dc87ac4975j.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H51f77878eeb24f73ba9563a23d1a0048V.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H2976327cbe8b4a0fb14ced61b60ec2197.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H955e97a3eecc463e800cb9b57dd8ddf7Z.jpg" slate-data-type="image"></p><p style="text-align:center" align="center"><kse:widget data-widget-type="customText" id="1000000269819" type="custom"></kse:widget></p>
<script>window.adminAccountId=243881915;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H32b971bfa1a04d8eb8a43e77bd91da83B/Magnetic-Wrist-Strap-Kit-Screw-Nail-Nut-Bolt-Drill-Bit-Repair-Kit-Organizer-Magnet-Pickup-Screw.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H834cbc77b01a46d2a1cbf9b5c612a115o/Magnetic-Wrist-Strap-Kit-Screw-Nail-Nut-Bolt-Drill-Bit-Repair-Kit-Organizer-Magnet-Pickup-Screw.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H670d3b8ab3ae4a5b8e5c628c6cf5be92m/Magnetic-Wrist-Strap-Kit-Screw-Nail-Nut-Bolt-Drill-Bit-Repair-Kit-Organizer-Magnet-Pickup-Screw.jpg", localFile: ""),
    ],
    priceProduct: 3.99,
    discPriceProduct: 2.99,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "Red")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H7535055614e649f99626962091950e16s/Magnetic-Wrist-Strap-Kit-Screw-Nail-Nut-Bolt-Drill-Bit-Repair-Kit-Organizer-Magnet-Pickup-Screw.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "Blue")],
            0.6, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/Hd9e1f70a7fed4130928ebdb4692e3bb4M/Magnetic-Wrist-Strap-Kit-Screw-Nail-Nut-Bolt-Drill-Bit-Repair-Kit-Organizer-Magnet-Pickup-Screw.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 24
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ024",
    [StringData(code: "en", text: "Window Screen Cleaning Brush Household Dust Hair Detailing Washing Mesh Cleaner Lint Remover For Clothing Home ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
  <div>
<div><span style="font-size:26px"><strong data-spm-anchor-id="a2g2w.detail.1000023.i0.305c3ae1YvblkR">Multifunctional two-way dust removal brush</strong></span></div>

<div><img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H46bf8b15bbac4ec28f03b84b73a239f9t.jpg?width=790&amp;height=1317&amp;hash=2107"> <img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H8a43ef7e620c44a4a04a89e04e18ff4dQ.jpg?width=790&amp;height=781&amp;hash=1571"><br>
<strong><span style="font-size:26px">Cleaning screen&nbsp;window is easier</span></strong><br>
<img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hbfc19d867cb844bf8e1b44cdfd2fda42e.jpg?width=790&amp;height=1346&amp;hash=2136"><br>
<span style="font-size:26px"><strong>Two kinds of high-density soft bristles to ensure better cleaning effect</strong></span><br>
<img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hbe3b89b66bea49c281f2a5d85117c38fE.jpg?width=790&amp;height=1647&amp;hash=2437"><br>
<span style="font-size:26px"><strong>It can be used in both wet and dry environments, and the effect is more obvious when combined with cleaning agents or water</strong></span><br>
<img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H2803f2751d61415faa6e7511a84aa952V.jpg?width=790&amp;height=1346&amp;hash=2136"> <img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H862312d408134d6f905c96d70540f6e0d.jpg?width=790&amp;height=1346&amp;hash=2136"><br>
<span style="font-size:26px"><strong>The brush head does not need to be disassembled, and it can be cleaned by flushing with water</strong></span><br>
<img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hd15e9678b77b4d17a4b2b59d2646fc92C.jpg?width=790&amp;height=1280&amp;hash=2070"><br>
<span style="font-size:26px"><strong>Removable handle, flexible use</strong></span><br>
<img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hb72660535dcd4a6f959f73d9a946060b0.jpg?width=790&amp;height=1281&amp;hash=2071"><br>
<span style="font-size:26px"><strong>Comes with a small brush, you can use a small brush where the big brush can't reach</strong></span><br>
<img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H05abc90704d24c8bb984ef5b6de81dc5L.jpg?width=790&amp;height=1810&amp;hash=2600"><br>
<span style="font-size:26px"><strong>Slant angle design, the brush head fits the window surface more closely</strong></span><br>
<img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H4e96b0d3ad9c4210ac469b9e43d9cbbau.jpg?width=790&amp;height=1312&amp;hash=2102"></div>

<div><img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H73314a5bc67546be83c191f689b6a2d5M.jpg?width=790&amp;height=1282&amp;hash=2072"><br>
<span style="font-size:26px"><strong>It has a wide range of uses, it can remove dust and hair on glass, sofa, carpet</strong></span><br>
<img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H54cf572aee8946cb9abb21adc71592e7Y.jpg?width=790&amp;height=1409&amp;hash=2199"> <img class="detail-desc-decorate-image" referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H012f9ef7f79b4c92979acabf088236c2y.jpg?width=790&amp;height=1229&amp;hash=2019"></div>

<div><span style="font-size:26px"><strong>A mini multi-function window slot brush is given as a gift, which can be used to clean the gap and dust on the keyboard</strong></span></div>

<p align="left" style="text-align:left;margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H7f87baf9e2a7435d9d49177247fab622K.jpg?width=749&amp;height=571&amp;hash=1320"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H6bc2cf77c03f43ed885c40f11337e7bfU.jpg?width=747&amp;height=538&amp;hash=1285"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Ha73170bb461748c5b6cbfe9ffbf140e9N.jpg?width=750&amp;height=541&amp;hash=1291"></p>

<div>&nbsp;</div>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/Hf3e6dd4fb6444006950044859ee7bb32W/Window-Screen-Cleaning-Brush-Household-Dust-Hair-Detailing-Washing-Mesh-Cleaner-Lint-Remover-For-Clothing-Home.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hd377e92819f6407490399320a26faa6fl/Window-Screen-Cleaning-Brush-Household-Dust-Hair-Detailing-Washing-Mesh-Cleaner-Lint-Remover-For-Clothing-Home.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hb5085bcf0e3748359ae8a92ba460838cA/Window-Screen-Cleaning-Brush-Household-Dust-Hair-Detailing-Washing-Mesh-Cleaner-Lint-Remover-For-Clothing-Home.jpg", localFile: ""),
    ],
    priceProduct: 9.31,
    discPriceProduct: 7.31,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "Blue Brush")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H0a3c9126f19942f0bdd257807e94e3e0C/Window-Screen-Cleaning-Brush-Household-Dust-Hair-Detailing-Washing-Mesh-Cleaner-Lint-Remover-For-Clothing-Home.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "Red Brush")],
            1, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H01206b55354740b9bb8d45428311276cd/Window-Screen-Cleaning-Brush-Household-Dust-Hair-Detailing-Washing-Mesh-Cleaner-Lint-Remover-For-Clothing-Home.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/2212367482430/p/1/e/6/t/10301/328137198197.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 25
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ025",
    [StringData(code: "en", text: "Sanitary disposable gloves Wally plastic, 100 pcs, nitrile vinyl/black")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext"><p><span style="background-color:rgb(255, 255, 255);color:rgb(0, 26, 52);font-size:16px;font-family:GTEestiPro, arial, sans-serif" data-spm-anchor-id="a2g2w.detail.1000023.i0.572460a2lVgu1U">Gloves nitrile high-strength unoppressed, non-sterile, disposable.</span><br><br><span style="background-color:rgb(255, 255, 255);color:rgb(0, 26, 52);font-size:16px;font-family:GTEestiPro, arial, sans-serif">In one pack 100 pieces (50 pairs).</span><br><br><span style="background-color:rgb(255, 255, 255);color:rgb(0, 26, 52);font-size:16px;font-family:GTEestiPro, arial, sans-serif">Gloves perform several functions: protect both the worker and the product. Resistant to alcohol, formaldehyde, phenols, acids, alkali, organic solvents. Recommended for use in various areas: food industry, beauty industry, home use.</span></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/Uf86c69a5a2f4467f94cdfcae04205c22j/Sanitary-disposable-gloves-Wally-plastic-100-pcs-nitrile-vinyl-black.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/U9687f3bb3a5e428ca2a8471077d9fa02V/Sanitary-disposable-gloves-Wally-plastic-100-pcs-nitrile-vinyl-black.jpg", localFile: ""),
    ],
    priceProduct: 5.66,
    discPriceProduct: 0,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Size")],
        price: [
          PriceData([
            StringData(code: "en", text: "S")],
            0, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "M")],
            0, 0, "+",
            ImageData(serverPath: "", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 26
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ026",
    [StringData(code: "en", text: "OYBOS Glass Cleaning Tool Double-sided Telescopic Rod Window Cleaner Mop Squeegee Wiper Long Handle Rotating")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="ProductDescription-module_content__1xpeo"><div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><div id="dxbglyxpre" name="dxbglyxpre" class="dxbglyxpre"><img border="0" src="https://ae01.alicdn.com/kf/H7c8104a9bf684d27b047740e5689a6c24.jpg" usemap="#uNzK9hfSAXgXtX6b8bRqU2kD98mqw1uo" slate-data-type="image" data-spm-anchor-id="a2g2w.detail.1000023.i0.41f0739diPl7Zf"><map name="uNzK9hfSAXgXtX6b8bRqU2kD98mqw1uo"><area shape="rect" coords="18,253,238,553" target="_blank" href="https://www.aliexpress.com/item/1005001565026227.html"><area shape="rect" coords="248,253,468,553" target="_blank" href="https://www.aliexpress.com/item/1005001971845987.html"><area shape="rect" coords="478,253,698,553" target="_blank" href="https://www.aliexpress.com/item/1005002808123873.html"><area shape="rect" coords="708,253,928,553" target="_blank" href="https://www.aliexpress.com/item/1005003302413352.html"><area shape="rect" coords="18,563,238,863" target="_blank" href="https://www.aliexpress.com/item/1005002996656027.html"><area shape="rect" coords="248,563,468,863" target="_blank" href="https://www.aliexpress.com/item/1005003097823232.html"><area shape="rect" coords="478,563,698,863" target="_blank" href="https://www.aliexpress.com/item/1005003116427336.html"><area shape="rect" coords="708,563,928,863" target="_blank" href="https://www.aliexpress.com/item/1005002597903852.html"></map></div></div></div><div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Why do I need a two-in-one glass cleaner?</p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">For most people, cleaning the interior and exterior windows, bathrooms, doors, and rearview mirrors of cars is a problem. This product brought to you by JOYBOS will solve this problem for you</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">What is the difference between our glass cleaner and others?</p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">It includes a retractable pole that you can extend according to your preference to ensure that dirt is cleaned at high places; the retractable pole is easy to assemble and can be disassembled for storage or put in the trunk of a car.</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">What you will get？</p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">2-in-1 window cleaning head<br>Telescopic rod<br>Microfiber cloth x1<br><br>If you need to buy additional fabrics, you can buy them from our store or contact us</p></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H796b5d4766274972a30a7fc7c9e7a77a4.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H3a804b9d8a74455bb41ff1b0a6f6189fj.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H5a4a6158a82e424eb7d8e23babeab2e1H.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H151ded8ceb2945efb4ffdf04c8aceb3an.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hbadf32d8cb064b219c3991aec920df91s.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H4104c444290d4cdcbcf217e90b5cbcdaf.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H4c2fbfaf1e8c48a89557094b5bee776aU.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H932e20930aad41dfb1aeb537558aa2e6V.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/He468e9ebd66649d58d2d37238b1ed73co.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H533438a76ff244058c0b46f588abcbf3y.jpg" slate-data-type="image"></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">Tips:<br>When using the mop for the first time, the gray bendable part of the head needs to be soaked for 30 minutes at 40-50 degrees Celsius.</p></div><p><br></p></div></div><p><br></p>
<script>window.adminAccountId=244021137;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/Hd1c1eaf078214172a386da81a35f8cebM/JOYBOS-Glass-Cleaning-Tool-Double-sided-Telescopic-Rod-Window-Cleaner-Mop-Squeegee-Wiper-Long-Handle-Rotating.jpg_640x640.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H74141676342e482a957a69f356fc9e7fm/JOYBOS-Glass-Cleaning-Tool-Double-sided-Telescopic-Rod-Window-Cleaner-Mop-Squeegee-Wiper-Long-Handle-Rotating.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H42965005a72741d8831b3c180f2bab517/JOYBOS-Glass-Cleaning-Tool-Double-sided-Telescopic-Rod-Window-Cleaner-Mop-Squeegee-Wiper-Long-Handle-Rotating.jpg", localFile: ""),
    ],
    priceProduct: 14.48,
    discPriceProduct: 12.6,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "Base")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/Hd1c1eaf078214172a386da81a35f8cebM/JOYBOS-Glass-Cleaning-Tool-Double-sided-Telescopic-Rod-Window-Cleaner-Mop-Squeegee-Wiper-Long-Handle-Rotating.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "Green")],
            2, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H18a92570b66141e0994db3d7c3e1c9995/JOYBOS-Glass-Cleaning-Tool-Double-sided-Telescopic-Rod-Window-Cleaner-Mop-Squeegee-Wiper-Long-Handle-Rotating.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/2208862929880/p/1/e/6/t/10301/315106982258.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 27
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ027",
    [StringData(code: "en", text: "Automatic Spin Mop With Bucket Flat Squeeze Hand Free Wringing Magic")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext"><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content" data-spm-anchor-id="a2g2w.detail.1000023.i0.2e592bb9mPkoWL">Automatic Spin Mop With Bucket Flat Squeeze Hand Free Wringing Magic Microfiber Mop Home Kitchen Floor Cleaning Home Kitchen</p></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H5b97da68b05d444a8adc86581377972bO.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H7a01eefcaab345418dd0940089714868r.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hf9394e5b209c4ea5a2e7ef8332b0cb02Z.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H11da745e34414a8583c7f0f882272f90g.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H18dedff4bd534cd0939106ca9e8ba83dp.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H178dbea71d3b414687ed74e8b1531284W.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H1cb8536835864c43b38d1e0d83e1a828Q.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H599aa0c4d0dc4062bacbe8d20aa4b65aY.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H9838e849794a4733b4bcb7c13133d727l.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H71713f4f27194003a15b378074eb565ai.jpg" slate-data-type="image"></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H4502fd12e02b4c6a81a7d27bde944edaz.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hc1700768b5464b029c7157122098f345L.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Ha7956c0e4d324e27beadbaa74ad4cddds.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/He5007c25c66a4e7db9015ea85fc75c95b.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H8c7ea4167871459b8181d7ef68eb80c43.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H49756a62e2154a2fba33892a6df0771ap.jpg" slate-data-type="image"></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Product Description:</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Material: Polypropylene (PP)</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Mop bar material: stainless steel</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Mop material: microfiber</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Color: blue / white / purple / green</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Splint size: 33cm * 12cm</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Mop bucket size: 27cm * 23cm * 40cm</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Telescopic length: 127cm</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Features:</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Auto rebound design, more convenient for dehydration</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Dry and wet separation, convenient</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Hand wash free</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● The mop area is large and the decontamination area is large</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Microfiber mop, strong suction of stains, adsorption of hair dust</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Dry and wet, clean and quick to clean</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● 360 ° flexible rotating mop head</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Drain hole design</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Convenient storage, no land occupation</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Polypropylene (PP) plastic, strong, durable</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Convenient drainage hole</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">● Instantly blot dry stains</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">Application: family, office, hotel, etc.</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">How to use? (Instructions)</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">1.Add water</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">2. Push the bucket up and down</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">3.Pull up and down in the bucket</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;text-align:left;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);display:block;width:100%" align="left">4.Unplug the water hole</p></div><p><br></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/He82e3a63c54245ddb533a14f807b9a849/Automatic-Spin-Mop-With-Bucket-Flat-Squeeze-Hand-Free-Wringing-Magic-Microfiber-Mop-Home-Kitchen-Floor.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H7cb7f2c9500142e7b4fd68a6185ad158x/Automatic-Spin-Mop-With-Bucket-Flat-Squeeze-Hand-Free-Wringing-Magic-Microfiber-Mop-Home-Kitchen-Floor.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H6a7b4f91bbb94582b318eb4db12613d7F/Automatic-Spin-Mop-With-Bucket-Flat-Squeeze-Hand-Free-Wringing-Magic-Microfiber-Mop-Home-Kitchen-Floor.jpg", localFile: ""),
    ],
    priceProduct: 16.99,
    discPriceProduct: 14.99,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "8 mop pads Blue")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H07f68be5e7734ad1abfe532540079c7ai/Automatic-Spin-Mop-With-Bucket-Flat-Squeeze-Hand-Free-Wringing-Magic-Microfiber-Mop-Home-Kitchen-Floor.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: " 8 mop pads Green")],
            2, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/He5e1de11f2314643ae3c892be1a9f64aY/Automatic-Spin-Mop-With-Bucket-Flat-Squeeze-Hand-Free-Wringing-Magic-Microfiber-Mop-Home-Kitchen-Floor.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/339478105088/p/1/e/6/t/10301/319967225499.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 28
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ028",
    [StringData(code: "en", text: "SOKOLTEC telescopic squeegee mop, bucket with metal centrifuge For home and kitchen washing with clam")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext"><p><kse:widget data-widget-type="customText" id="1005000000052921" type="custom"></kse:widget></p><p><br></p><p style="font-size:24px;font-weight:bolder;text-align:center;margin-bottom:25px" align="center" data-spm-anchor-id="a2g2w.detail.1000023.i0.293e1138yrS1hn">Sokoltec telescopic spin mop, metal centrifuge bucket</p><p style="font-size:18px;text-align:left;color:rgb(102, 102, 102);margin:15px 20px;margin-bottom:15px;margin-top:15px;margin-left:20px;margin-right:20px" align="left">The most popular cleaning kit, tested by a huge number of customers and perfectly proven itself.</p><p style="font-size:18px;text-align:left;color:rgb(102, 102, 102);margin:15px 20px;margin-bottom:15px;margin-top:15px;margin-left:20px;margin-right:20px" align="left">Bucket with built-in rinsing and pressing system, telescopic mop and microfiber nozzle-everything you need for easy and effective cleaning!</p><p style="font-size:18px;text-align:left;color:rgb(102, 102, 102);margin:15px 20px;margin-bottom:15px;margin-top:15px;margin-left:20px;margin-right:20px" align="left">The length of the mop handle is 120 cm.</p><p><img src="https://ae01.alicdn.com/kf/Ued853278c2c341599ca831dff948a227F.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/U88571b1785cf486290f03d848024c4dbz.jpg" slate-data-type="image"></p><p><br><kse:widget data-widget-type="customText" id="1005000000052149" type="custom"></kse:widget></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/U0010c2a9bd3a4b4a9bab9c87a570d99bW/SOKOLTEC-telescopic-squeegee-mop-bucket-with-metal-centrifuge-For-home-and-kitchen-washing-with-clamp-holder.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/UTB8iYa3PdoSdeJk43Owq6ya4XXao/SOKOLTEC-telescopic-squeegee-mop-bucket-with-metal-centrifuge-For-home-and-kitchen-washing-with-clamp-holder.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/UTB8hE31PyDEXKJk43Oqq6Az3XXaB/SOKOLTEC-telescopic-squeegee-mop-bucket-with-metal-centrifuge-For-home-and-kitchen-washing-with-clamp-holder.jpg", localFile: ""),
    ],
    priceProduct: 16.24,
    discPriceProduct: 14.24,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "Green")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/UTB8cfV7wgnJXKJkSaelq6xUzXXa7/SOKOLTEC-telescopic-squeegee-mop-bucket-with-metal-centrifuge-For-home-and-kitchen-washing-with-clamp-holder.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "Black")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/UTB8xvN7wgnJXKJkSaelq6xUzXXaJ/SOKOLTEC-telescopic-squeegee-mop-bucket-with-metal-centrifuge-For-home-and-kitchen-washing-with-clamp-holder.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 29
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ029",
    [StringData(code: "en", text: "Onine M610 home mop with self-tapping X-Mount (MOP hook + 3 nozzles)")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext"><div style="text-align:left" class="detailmodule_dynamic" align="left"><a href="https://aliexpress.ru/item/1005003222910998.html?spm=a2g2w.detail.1000023.1.50324409bV2LEC" target="_self" class="" data-spm-anchor-id="a2g2w.detail.1000023.1"><img width="790" height="246" src="https://ae01.alicdn.com/kf/H4fa016757e884c1ab3e7688a268d94003.jpg" slate-data-type="image" data-spm-anchor-id="a2g2w.detail.1000023.i0.50324409bV2LEC"></a></div><div style="text-align:left" class="detailmodule_dynamic" align="left"><img src="https://ae01.alicdn.com/kf/H4d64cdae35fd45cea4639dd73d050caei.jpg" slate-data-type="image"></div><div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><p style="text-align:left" align="left"><img src="https://ae01.alicdn.com/kf/H0e93bd63d4ea451d91768038b64fa7c8n.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hbb7c96a973cb41dca269f57e2c1f1c9er.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H4c57054c187f46c5a464ec2cfd8d815dd.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hf5afc2afb33e4ad3894ca394bd7f8973W.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hc34214495aaa467ca273bba498ad447aT.jpg" slate-data-type="image"></p></div></div></div></div><div class="detailmodule_dynamic"><img src="https://ae01.alicdn.com/kf/Hab50f73cf78f49e3a9cb40ffcb9119261.jpg" slate-data-type="image"></div><p><br></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/Ha1e0ad45d65b42c78868d15aa2117c83I/Onine-M610-home-mop-with-self-tapping-X-Mount-MOP-hook-3-nozzles.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H18a77055d8794007a77500ab3fa35ef3Y/Onine-M610-home-mop-with-self-tapping-X-Mount-MOP-hook-3-nozzles.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H6a0bdfc7a0ce4c4cb5878e5e14e06f42v/Onine-M610-home-mop-with-self-tapping-X-Mount-MOP-hook-3-nozzles.jpg", localFile: ""),
    ],
    priceProduct: 19.81,
    discPriceProduct: 20.2,
    stock: 10,
    group: [
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/339608234310/p/1/e/6/t/10301/331770761425.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 30
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ030",
    [StringData(code: "en", text: "Mini Portable Lint Remover Fuzz Fabric Shaver For Carpet Woolen Coat Clothes Fluff Fabric Shaver Brush")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="ProductDescription-module_wrapper__3AwCk"><div class="ProductDescription-module_content__1xpeo"><div class="detailmodule_image"><a href="https://www.aliexpress.com/item/1005002985161122.html?spm=a2g2w.detail.1000023.1.4a41197fQaH0TO&amp;gps-id=pcDetailBottomMoreThisSeller&amp;scm=1007.13339.169870.0&amp;scm_id=1007.13339.169870.0&amp;scm-url=1007.13339.169870.0&amp;pvid=b90d4435-2ebe-4d29-ac22-14d97d093364&amp;_t=gps-id:pcDetailBottomMoreThisSeller,scm-url:1007.13339.169870.0,pvid:b90d4435-2ebe-4d29-ac22-14d97d093364,tpp_buckets:668%232846%238107%231934&amp;pdp_ext_f=%7B&amp;_ga=2.259154954.166729193.1640783541-1023327899.1635155841" target="_self" class="" data-spm-anchor-id="a2g2w.detail.1000023.1"><img style="margin-bottom:10px" class="detail-desc-decorate-image" width="900" height="472" src="https://ae04.alicdn.com/kf/H917c5416a8684168b3d2d99c28d55d74x.jpg" slate-data-type="image" data-spm-anchor-id="a2g2w.detail.1000023.i0.4a41197fQaH0TO"></a><a href="https://www.aliexpress.com/item/1005003183427369.html?spm=a2g2w.detail.1000023.2.4a41197fQaH0TO" target="_self" class="" data-spm-anchor-id="a2g2w.detail.1000023.2"><img style="margin-bottom:10px" class="detail-desc-decorate-image" width="900" height="472" src="https://ae04.alicdn.com/kf/H3ab257e168a244faa8fe7c89721228cai.jpg" slate-data-type="image"></a></div><div class="detailmodule_image"><a href="https://www.aliexpress.com/item/4000576096820.html?spm=a2g2w.detail.1000023.3.4a41197fQaH0TO" target="_self" class="" data-spm-anchor-id="a2g2w.detail.1000023.3"><img style="margin-bottom:10px" class="detail-desc-decorate-image" width="900" height="472" src="https://ae04.alicdn.com/kf/H330a6967417245ccb4ef82584cb35d35O.jpg" slate-data-type="image"></a></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Follow our store get discount and coupon</p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">Promo Code:   MELTSET1111</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Mini Portable Lint Remover Fuzz Fabric Shaver</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Features:</p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">1. Quick shaving without damaging the fabric to bring new life to the old fabric and keep them clean, soft and fresh. Remove pilling and fuzz from, curtains, carpets, upholstery, etc<br>2. Always keep it elegant - restores clothes and fabrics to their new look, perfect for removing fluffy balls from clothes, even on the sofa. Use the money you save on these fuzzy little things to buy yourself some new clothes and make your life easier.<br>3. No batteries -- unlike battery-powered electric razors, which no longer waste batteries because razors can't provide continuous power, this portable lint remover provides stable and constant power to remove lint and ball bearings.<br>4. Fast and easy to use - safe and effective for removing lint, pills and lint from clothes, blankets, curtains, carpets etc without worrying about low power consumption</p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Specifics:</p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">Material: Wood, Copper<br>Size: As pictures show<br>Color: As the picture show<br>Package included: 1x lint remover</p><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title"><span style="color:rgb(244, 78, 59)">Note:</span></p><p><span style="background-color:rgb(255, 255, 255);color:rgb(0, 0, 0);font-size:14px;font-family:OpenSans"><span style="color:rgb(244, 78, 59)">1. This shaving machine is only used for woolen overcoats. Please do not scrape sweaters or knitted sweaters, otherwise it will cause defilament and damage to clothing.<br>2. The product is all sharp copper head. It is only recommended to use the overcoat to shave and remove the ball.<br>3 this product is mainly used in dry cleaners, if you do not know how to use, please consult customer service for your answer.</span></span></p></div></div><div class="detailmodule_image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hefb5dd86fc024d028017eecd0ba93e11J.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H911f52fefeac4a639638305c1a08afcaq.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hab1e605530c24484976d57ea28a34647G.jpg" slate-data-type="image"></div><div class="detailmodule_image"><img src="https://ae01.alicdn.com/kf/Hcee1dcbef3224da4b530fab63657e91cE.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H60213ce343d04f00b16da72a53d351cbY.jpg" slate-data-type="image"></div><div class="detailmodule_image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H5a7606676cc24cb39b0d831f2ddc6c035.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Ha3c2ee71021a4414af37c6922ebb06f26.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hf795e645476d4fc78c5308ca8faaa356A.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H54a18ecd10af4462adb12c6fd213876fL.jpg" slate-data-type="image"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H999a433e9d8448948f2046de57409c6bs.jpg" slate-data-type="image"></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H70604a66a7574ae38772874dfec9f8d8F.jpg" slate-data-type="image"></div><div class="detailmodule_image"><a href="https://www.aliexpress.com/item/4001190043945.html?spm=a2g2w.detail.1000023.4.4a41197fQaH0TO" target="_self" class="" data-spm-anchor-id="a2g2w.detail.1000023.4"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae04.alicdn.com/kf/Hbeb54aebfdd54d8fbfc1d06150660d2a6.jpg" slate-data-type="image"></a><a href="https://fancyhome.aliexpress.com/store/912994/pages/promotion-20211111.html?spm=a2g2w.detail.1000023.5.4a41197fQaH0TO" target="_self" class="" data-spm-anchor-id="a2g2w.detail.1000023.5"><img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H3e9f1327c18a4f7abf4ada55354a23523.png" slate-data-type="image"></a></div><p><br></p>
<script>window.adminAccountId=201616901;</script>
</div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_cleaningServicesLondon],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/Hee4e3cfcaea24bb19fbfa9597ae613dcp/Mini-Portable-Lint-Remover-Fuzz-Fabric-Shaver-For-Carpet-Woolen-Coat-Clothes-Fluff-Fabric-Shaver-Brush.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H7028c1ed9ff243119550ef02b0cea0c5O/Mini-Portable-Lint-Remover-Fuzz-Fabric-Shaver-For-Carpet-Woolen-Coat-Clothes-Fluff-Fabric-Shaver-Brush.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hf271595730594ae78c1d06c35ade9050O/Mini-Portable-Lint-Remover-Fuzz-Fabric-Shaver-For-Carpet-Woolen-Coat-Clothes-Fluff-Fabric-Shaver-Brush.jpg", localFile: ""),
    ],
    priceProduct: 3.19,
    discPriceProduct: 2.49,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "Wood Handle")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/He621ea4deb6147a094cc37f7c5b11d73Y/Mini-Portable-Lint-Remover-Fuzz-Fabric-Shaver-For-Carpet-Woolen-Coat-Clothes-Fluff-Fabric-Shaver-Brush.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "Plus Sliver")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H2a2f64f9097642cb8db2a49fe5209c39p/Mini-Portable-Lint-Remover-Fuzz-Fabric-Shaver-For-Carpet-Woolen-Coat-Clothes-Fluff-Fabric-Shaver-Brush.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/17381486085/p/1/e/6/t/10301/249583564031.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 31
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ031",
    [StringData(code: "en", text: "Reusable Self-Adhesive False Eyelashes Natural Multiple Reversible Glue-free Self-adhesive Pairs Of False Eyelash")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><div><p style="font-family:&quot;Comic Sans MS&quot;, Verdana, Georgia;font-size:16px" data-spm-anchor-id="a2g2w.detail.1000023.i0.7e9e45faoeuevc">Feature:<br>Please note: other accessories are not included.<br>100% brand new quality<br><br>Material: man-made fiber<br>Applicable people: all skin types<br>Stem category: Cotton thread stem<br>Size: 1 pair<br>Feature:<br>1. The hair is soft, comfortable and unassuming<br>2. Small size, light weight, no space, easy to carry<br>3. The thick plastic cotton screws are not easy to fall off, durable and truly unique.<br><br>How to use: 1. Use tweezers to hold both sides of the eyelashes, gently remove the excess eyelash roots, and cut off the excess eyelash roots.<br>2. Paste the self-adhesive strips in the order of the center of the eye-the end of the eye-the end of the eye, adjust the eyelashes, move the eyeball up and the end of the eye down<br>3. Fill the false eyelashes and empty spaces with liquid eyeliner<br><br>Comment:<br>1. Manual measurement tolerance is 2-5g. Please don't mind your substitutes.<br>2. Due to the difference of different monitors, the picture may not reflect the actual color of the product. thank you very much!<br>3. SKU color is product color<br><br>Package Included:<br>1*Self-adhesive false eyelashes<br><img src="https://ae01.alicdn.com/kf/H09436d8931b24c95a8c1e6dfd33ce61eJ.jpg" slate-data-type="image" data-spm-anchor-id="a2g2w.detail.1000023.i1.7e9e45faoeuevc"><img src="https://ae01.alicdn.com/kf/He4d25fbdd8854690ab8ef96c00c94611l.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hc4ab9f9f50254aa69e1e8fc30c47adfdd.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hd67db072a30349a68a205b50299182daC.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H1e5029304f284d6bb7e73a2e0b075761t.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H604db7584a754ead89a3ae76a7daf724F.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hde8eb884003d4ef7a47697547c678578x.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H008842a3cbb84a23a48e349ac2cd220e7.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H41732c13d1224eed903852ce9ff8858cN.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H48b4f49922b44116b62f78de15e63a2aC.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hb4236dc85d6e4d4db73317231fe6bdacs.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hedda96b5a6e94eb68497e05b58ee51bd7.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H44b67cee3fb5435294cdacc2da501effg.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Ha8e5f93c953a4d81b6ae2eba44504162F.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hd5ac7ea05aee40a0bcabc3b0ac680b7f5.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H82f617386003453e93c55d8d1e80dea4R.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H2435183cde4346bb9bbe8b5e09adddc4w.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hbdd1b8df125a431c9ca3ba5f588905d6C.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H53b144041443477994de012b70f3b8f0g.jpg" slate-data-type="image"><br></p><p style="font-family:&quot;Comic Sans MS&quot;, Verdana, Georgia;font-size:16px">hello, guys, thank you for visiting my store.if you want buy more than we listed, please contact us.If you need more this item ,you can contact us.we will give you our best price. Leave your message!</p></div></div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H72c3e672aaba452ab5731be0cc62b8b7u/Reusable-Self-Adhesive-False-Eyelashes-Natural-Multiple-Reversible-Glue-free-Self-adhesive-Pairs-Of-False-Eyelashes.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H81ada2a863aa4448bf746cfd2088a754h/Reusable-Self-Adhesive-False-Eyelashes-Natural-Multiple-Reversible-Glue-free-Self-adhesive-Pairs-Of-False-Eyelashes.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hbadcee98ce724bd79b234e3487c3a1480/Reusable-Self-Adhesive-False-Eyelashes-Natural-Multiple-Reversible-Glue-free-Self-adhesive-Pairs-Of-False-Eyelashes.jpg", localFile: ""),
    ],
    priceProduct: 1.86,
    discPriceProduct: 1.22,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "A")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H58cc7dcf317540d989f7a48ea122703bm/Reusable-Self-Adhesive-False-Eyelashes-Natural-Multiple-Reversible-Glue-free-Self-adhesive-Pairs-Of-False-Eyelashes.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "B")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/Hb1e226c99775442a9ed424b62a5b13fda/Reusable-Self-Adhesive-False-Eyelashes-Natural-Multiple-Reversible-Glue-free-Self-adhesive-Pairs-Of-False-Eyelashes.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/2212783100175/p/1/e/6/t/10301/338032999646.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 32
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ032",
    [StringData(code: "en", text: "RANCAI Professional Makeup Brush Cleaner Fast Washing and Drying Make up Brushes")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div><h1 style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:24px;font-weight:500;line-height:36px;color:rgb(0, 0, 0);margin:0.67em 0px 12px;margin-bottom:12px;margin-top:0.67em;margin-left:0px;margin-right:0px;box-sizing:border-box"><span style="font-size:13px" data-spm-anchor-id="a2g2w.detail.1000023.i0.4dd471778KhfjA">Useful Electric Makeup Brush Cleaner Dryer Set Make Up Brushes Convenient&nbsp; Cleaning Tool In Seconds Makeup Brushes</span></h1><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Specification:</span></span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Material:Plastic</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Color:White/Black</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Size: 15.6*5.4cm</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Basic size: &nbsp;15.9*9.2*3.55cm</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Container size: (H x Bottleneck dia. x Dia.) 9.7cm*9.6cm*11.5cm</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Battery voltage: 3.7 V polymer battery</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">mAh battery capacity: 500 mah + / - 20%</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Charging voltage and current: MAX 5 V / 1 A</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Operating voltage: 3.7 V</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Current operation: no load (16 mAh)</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Maximum power: 7.5W or less</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">Package Included:</span></span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">1 x Makeup brush cleaner</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">1 x Bowl</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">1 x Rubber Holder</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">1 x USB Cable</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">1 x Manual</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">1 x Connector</span></span></div><div style="font-family:&quot;Open Sans&quot;, Arial, Helvetica, sans-serif, Heiti;font-size:14px;color:rgb(0, 0, 0);box-sizing:content-box"><span style="font-size:16px"><span style="font-family:arial, helvetica, sans-serif">1 x Base</span></span></div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H30f2924e27df474380e43c074dabe6eaG/RANCAI-Professional-Makeup-Brush-Cleaner-Fast-Washing-and-Drying-Make-up-Brushes-Cleaning-Makeup-Brush-Tools.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Ha0148ff119f745e9bd81068ec5f8f018s/RANCAI-Professional-Makeup-Brush-Cleaner-Fast-Washing-and-Drying-Make-up-Brushes-Cleaning-Makeup-Brush-Tools.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H4f17db9e5c03483796dc2a1528b284efn/RANCAI-Professional-Makeup-Brush-Cleaner-Fast-Washing-and-Drying-Make-up-Brushes-Cleaning-Makeup-Brush-Tools.jpg", localFile: ""),
    ],
    priceProduct: 19.99,
    discPriceProduct: 21.99,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "black")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H9011072292414a18b8b1a7e4466b9117l/RANCAI-Professional-Makeup-Brush-Cleaner-Fast-Washing-and-Drying-Make-up-Brushes-Cleaning-Makeup-Brush-Tools.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "green")],
            1, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H26d4dfbf843e45938d74b8aacfe5c5d76/RANCAI-Professional-Makeup-Brush-Cleaner-Fast-Washing-and-Drying-Make-up-Brushes-Cleaning-Makeup-Brush-Tools.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/17380982814/p/1/e/6/t/10301/249413576791.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 33
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ033",
    [StringData(code: "en", text: "Flower West Original Florasis Eye Shadow Makeup Palette Natural Handmade Beauty Glazed ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<p style="text-align:center;margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px" align="center"><span class="VIiyi" style="background-color:rgba(254,146,0,255);color:rgb(0, 0, 0);font-size:18px;font-family:Roboto, RobotoDraft, Helvetica, Arial, sans-serif"><span style="background-color:rgba(254,146,0,255)"><span class="JLqJ4b ChMk0b" style="background-color:rgba(254,146,0,255)">Dear friend, thank you very much for visiting my beauty shopThis product is a genuine huaxizi, quality assurance, super high-quality eye shadow, you will definitely like it.</span></span></span><img src="https://ae01.alicdn.com/kf/H9594da0ab0c948b2b0537c141ebee6d7Z.jpg?width=800&amp;height=800&amp;hash=1600" slate-data-type="image" data-spm-anchor-id="a2g2w.detail.1000023.i0.5e676d42lDnpEb"><br><img src="https://ae01.alicdn.com/kf/H6c2e23b89c7e4b46b488c9b1ec2e1423k.jpg?width=1080&amp;height=1080&amp;hash=2160" slate-data-type="image"><br><br><img src="https://ae01.alicdn.com/kf/Ha1f6a6000f96494ebbe7c033301a2602j.jpg?width=1080&amp;height=1439&amp;hash=2519" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H6c0af1aab0e944d5b4ffab28726a8752p.jpg?width=1080&amp;height=1439&amp;hash=2519" slate-data-type="image"></p>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H3c67d965e46f44d293420d27851acee47/Flower-West-Original-Florasis-Eye-Shadow-Makeup-Palette-Natural-Handmade-Beauty-Glazed-Eyeshadow-Pigment-Pallete-China.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H9467515b6c34452d83fd90202ea3266cE/Flower-West-Original-Florasis-Eye-Shadow-Makeup-Palette-Natural-Handmade-Beauty-Glazed-Eyeshadow-Pigment-Pallete-China.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H87ca0ffc2fb7454690b8b0da065c7e3dt/Flower-West-Original-Florasis-Eye-Shadow-Makeup-Palette-Natural-Handmade-Beauty-Glazed-Eyeshadow-Pigment-Pallete-China.jpg", localFile: ""),
    ],
    priceProduct: 56.99,
    discPriceProduct: 70.6,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "9 color gold brown")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H4a0a4275762e4ac1826d120c313a8525t/Flower-West-Original-Florasis-Eye-Shadow-Makeup-Palette-Natural-Handmade-Beauty-Glazed-Eyeshadow-Pigment-Pallete-China.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "9 color orange brown")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H8131a9289d014a3cb6c208c094efef7aF/Flower-West-Original-Florasis-Eye-Shadow-Makeup-Palette-Natural-Handmade-Beauty-Glazed-Eyeshadow-Pigment-Pallete-China.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/2207304003865/p/1/e/6/t/10301/306597454222.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 34
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ034",
    [StringData(code: "en", text: "10pcs Anime Makeup Brushes Set Cosmetic Powder Eyeshadow Eyebrow Lip Make Up Tools Sharingan ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext"><div class="detailmodule_dynamic"></div> 
<div class="detailmodule_text"> 
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Specification</p> 
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content" data-spm-anchor-id="a2g2w.detail.1000023.i0.3ae32477liWcY6">Product name:Anime makeup brush<br><br>Color:as picture<br><br>Gender:Men ,Women, Fans<br><br>Total length：13.5-16.6cm<br><br>Hair Material:Soft Synthetic Hair<br><br>Handle material:Metal<br><br>Used With: <br>Powder/Eyeshadow/Concear/Eyebrow /Eye shadow/Lip brush<br><br>Basic makeup brush.<br><br>Suitable for professional use or home use.<br><br>Easy to use and portable.<br><br>For controlled eye shadow application and also can be used to blend eye shadow make up.<br><br>Package included: 5 Pcs/set makeup brushes *bag<br><br>1.High quality Soft Synthetic Hair provides superb ability to hold powder, soft and pleasing for your skin.<br><br>2.No fading and no hair dropping brushes boost and present your life taste.<br><br>3.Its colorful brush hair is fashionable and attractive, it will not fading or dropping, you can use longer time.<br><br>4.Delicate and small brushes are better for makeups around eyes ,cheeks , lip and other small parts of your face .</p> 
</div> 
<div class="detailmodule_text"> 
 <p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title">Color you can choose ---------</p> 
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">gold color plated</p> 
</div> 
<div class="detailmodule_image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Ha941dfdfce724ffbb3e94d86ac1b1a083.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H721cf04d3d894f37b01139de22906a657.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H1ad2c530059547cbbf662d70353f2cc3g.jpg" slate-data-type="image"> 
</div> 
<div class="detailmodule_text"> 
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">vintage gold plated--------</p> 
</div> 
<div class="detailmodule_image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hb26c4b87bf96465aa2bd3054181b9da8f.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H31e10f453af74c8187edd59d5313f941K.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H4b4b6c09916e495bbcf302a9c0d7ddeez.jpg" slate-data-type="image"> 
</div> 
<div class="detailmodule_text"> 
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">rose gold plated----------</p> 
</div> 
<div class="detailmodule_image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Ha0bd5bbce3c349ee9267d8d17c79d0e1n.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Ha8c3f01900794bc5a944bad3e6135c39c.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H03ef6b8b008f4fbf816b3dfa40b14144t.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H17f3f1e41524482d88bb5dce138854faA.jpg" slate-data-type="image"> 
</div> 
<div class="detailmodule_text"> 
 <p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">Silver plated color----------</p> 
</div> 
<div class="detailmodule_image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/He07bd2748c3d4e07b806149bf8767729g.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hd1f5762846284472b19603a752ff3e35y.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H879c7402f13446578f7243bb8b29ef18v.jpg" slate-data-type="image"> 
</div> 
<div class="detailmodule_image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hf1356870be5f4597b1473788e6f2d158A.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Ha274df9d53fd45bd8be9c363ae139d45O.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hfc1f66b3cf9f44889ccd74b763cef2daq.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H250c702b42d14e5aaac747f6291c205fE.jpg" slate-data-type="image"> 
 <img style="margin-bottom:10px" class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H2aa241b3bdab4ebe8fb0498be3221b3f0.jpg" slate-data-type="image"> 
</div> 
<div class="detailmodule_dynamic"></div> 
<p><br></p></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H524abbd3a51946c389a02f40c254cdb42/10pcs-Anime-Makeup-Brushes-Set-Cosmetic-Powder-Eyeshadow-Eyebrow-Lip-Make-Up-Tools-Sharingan-Akatsukic-For.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hd871f2517fc3484582a6e3959111954fr/10pcs-Anime-Makeup-Brushes-Set-Cosmetic-Powder-Eyeshadow-Eyebrow-Lip-Make-Up-Tools-Sharingan-Akatsukic-For.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H5ff0bebcd9424fd381a7b9a6f8a8c3f08/10pcs-Anime-Makeup-Brushes-Set-Cosmetic-Powder-Eyeshadow-Eyebrow-Lip-Make-Up-Tools-Sharingan-Akatsukic-For.jpg", localFile: ""),
    ],
    priceProduct: 13.96,
    discPriceProduct: 14.06,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Handle Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "rose gold")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H8014fa27ed5243558f8b1cb79e8496ceW/10pcs-Anime-Makeup-Brushes-Set-Cosmetic-Powder-Eyeshadow-Eyebrow-Lip-Make-Up-Tools-Sharingan-Akatsukic-For.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "silver color")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H5a621fdf245949c288bc22c339c0c22bc/10pcs-Anime-Makeup-Brushes-Set-Cosmetic-Powder-Eyeshadow-Eyebrow-Lip-Make-Up-Tools-Sharingan-Akatsukic-For.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/3321325400/p/1/e/6/t/10301/335847630282.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 35
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ035",
    [StringData(code: "en", text: "POPFEEL Gift Surprise - All in One Makeup Bundle - Includes Pro Makeup Brush Set, Eyeshadow")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="ProductDescription-module_content__1xpeo"><div class="detailmodule_text-image"><p style="font-family:OpenSans;font-size:20px;font-weight:900;line-height:28px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-title" data-spm-anchor-id="a2g2w.detail.1000023.i0.46afedcdQ1UngR">POPFEEL Gift Surprise - All in One Makeup Bundle - Includes Pro Makeup Brush Set, Eyeshadow Palette,Makeup Set or Lipgloss Set and etc.</p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">Wight:1200g<br>Box Size:240 x 185 x 150 mm<br><br>1.Combo bundle of all new Beauty Tools and Accessories. Complete girl/teen makeup, perfect gift set for holiday and Christmas gift idea for teen girls, gift for mom, gift for kids, gift for females and Holiday Christmas stocking stuffers<br><br>2.You will receive Eyeshadow palette,Lipstick,Lipgloss,Mascara,Eyeliner,Eyebrow,Concealer,Foundation,Makeup tools,Makeup brushes set.<br><br>3.You WILL receive any item from POPFEEL full line, this could be any item from the old or new catalog, any color, any size. We absolutely do not guarantee the colors or products. These boxes are pre filled based on the season overstock items.<br><br>4.Customer CAN NOT choose the colors. This is a Bundle set pre packaged by manufacturer.<br><br>5.POPFEEL all in one Holiday exclusive Makeup Set  contains all the necessary and basic makeup tools that every girls need. This is a great makeup kit for beginners and teen girls.</p><div><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H94093e818c8441a49fbdd2387268ff28I.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hb4d9e81c6e9e45eb98e14e745bb43559p.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H9d0ed283ae4d4cc9bc16f08f956cb0b8p.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hd5c4f1663c0d433a9eb384443d1c3d14j.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H7b4621f99ad144b78c28b4b452627dbcx.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H62e2f1f2eec14e7282677d6ef06570d3m.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H2addfd2d19694c19888034c26ef368c0q.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hdbf7cb52af8f4959a1c38db8e3645fc2t.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H5fea7c605ebb483c934cfe4d6faffa91i.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H38102453c83b45fa9e4d62dd728c9e98O.jpg" slate-data-type="image"></div></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H51e464645c1a476fb853186ad5e0ef28L.jpg" slate-data-type="image"></div><p><br></p>
<script>window.adminAccountId=239080845;</script>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/He274dc6f1a7d40788674b799d41448a0e/POPFEEL-Gift-Surprise-All-in-One-Makeup-Bundle-Includes-Pro-Makeup-Brush-Set-Eyeshadow-Palette-Makeup.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Had7380c3347d4cef99d5fd98e0de7725l/POPFEEL-Gift-Surprise-All-in-One-Makeup-Bundle-Includes-Pro-Makeup-Brush-Set-Eyeshadow-Palette-Makeup.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hd5d59658a6c04f95ad69ee919c63af35q/POPFEEL-Gift-Surprise-All-in-One-Makeup-Bundle-Includes-Pro-Makeup-Brush-Set-Eyeshadow-Palette-Makeup.jpg", localFile: ""),
    ],
    priceProduct: 42.99,
    discPriceProduct: 46.6,
    stock: 10,
    group: [
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "https://cloud.video.taobao.com/play/u/2204188363777/p/1/e/6/t/10301/329528191717.mp4",
    videoType: "mp4",
    thisIsArticle: true,
  ),

  // 36
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ036",
    [StringData(code: "en", text: "BOXYM Medical Digital LCD Wrist Blood Pressure Monitor Automatic sphygmomanometer Tonometer wrist ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div id="product-description" data-spm="1000023" class="product-description"><div class="origin-part box-sizing"><div class="detailmodule_dynamic"><kse:widget data-widget-type="customText" id="1005000000110904" type="custom"><div style="clear: both;"><p><img src="https://ae01.alicdn.com/kf/H5e19bddf6e0f4163a2012025be97a106F.png"><img src="https://ae01.alicdn.com/kf/H09fdd53d9d044fb5b946aea86d04cb81N.png"><img src="https://ae01.alicdn.com/kf/H78cede9e7cf04d0f90f06a747d01e80f2.png"><img src="https://ae01.alicdn.com/kf/Hf1ff52e780e04ebb9e9ecbb768d60222Y.png"><img src="https://ae01.alicdn.com/kf/Hd7f03b1c976f462baa743c8fb3cc11f9t.png"><br><br><br></p></div></kse:widget></div><div class="detailmodule_html"><div class="detail-desc-decorate-richtext"><div class="detailmodule_dynamic"></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/HTB1xIMNXOLxK1Rjy0Ffq6zYdVXac.jpg" slate-data-type="image"><strong><span style="font-size:20px">Wrist BloodPressure Monitor</span></strong></div><div class="detailmodule_text"></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content"><img src="https://ae01.alicdn.com/kf/H21d9c6c59e624e7ba4383b5952348734c.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i0.eb843798s4gGE0"><img src="https://ae01.alicdn.com/kf/Heffce528d15b499d8ad2965baca90f7cX.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i4.eb843798s4gGE0"><strong><span style="font-size:20px">Dual User 99 Group Memory</span></strong></p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content"><strong><span style="font-size:20px">Automatically store 99 groups of measured values</span></strong></p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content"><img src="https://ae01.alicdn.com/kf/He0041dd7b39d4664b6d8d715900809115.jpg" slate-data-type="image"></p><p><strong><span style="font-size:20px">Accurate Measurement</span></strong></p><p><strong><span style="font-size:20px">Wrist Blood electronic sphygmomanometer</span></strong></p><p><span style="font-size:18px">Normal blood pressure range</span></p><p><span style="font-size:18px">high pressure: 90-140 mm/hg</span></p><p><span style="font-size:18px">low pressure: 60-90 mm/hg</span></p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content"><img src="https://ae01.alicdn.com/kf/He674c9112cb1462eb9f4e1b76a3e438af.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i1.eb843798s4gGE0"></p><p><strong><span style="font-size:20px">Knit Wool Fabric Wrist Strap</span></strong></p><p><strong><span style="font-size:20px">Comfort fit, uniform pressure</span></strong></p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content"><img src="https://ae01.alicdn.com/kf/H94d2477c6a5c43e9ad43e2f0170e5974N.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i2.eb843798s4gGE0"></p><p><strong><span style="font-size:20px">The Body Thickness is Only 2.2cm</span></strong></p><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content"><img src="https://ae01.alicdn.com/kf/H8689317a49434de9812ff326599d58b9R.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i3.eb843798s4gGE0"></p><div><br></div><p><strong><span style="font-size:20px">Heart Rate Arrhythmia PromptsEffective Early</span></strong></p><p><strong><span style="font-size:20px">Warning of Heart Problems</span></strong></p><p><span style="font-size:18px">Heart disease can be effectively warned by simultaneously measuring the heartbeat of users.</span></p><p><span style="font-size:18px">Reducing the incidence of heart disease adds safeguard to health</span></p><div><br></div><p><img src="https://ae01.alicdn.com/kf/H8ccc52a9199d4d3bb739cd0acc802aeej.jpg" slate-data-type="image"></p><p><strong><span style="font-size:20px">Lare Screen Display Data</span></strong></p><p><strong><span style="font-size:20px">Clearly Visible</span></strong></p><p><span style="font-size:18px">LCD display, data clearly visibly favorable for the elderly to see, really</span></p><p><span style="font-size:18px">care for the health of parents</span></p><p><img src="https://ae01.alicdn.com/kf/H8b32a8e4697040749fd87e5c172a32ce7.jpg" slate-data-type="image"></p><p><span style="font-size:20px"><strong>Only 2 PCS AAA Alkaline Batteries</strong></span></p><p><span style="font-size:18px">Automatic shutdown without operation within 2 min</span></p><p><span style="font-size:18px">Energy-saving and power saving</span></p><p><img src="https://ae01.alicdn.com/kf/Hcf5c0d9a4cc446c9a8dded9d8c3c604dg.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H63b76b900e6a4b24855ef57f0e7ff75bu.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H533ffaaaa1b842cb8299aba708d14446N.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H8fa8bfb359df4c30bca8499b3915e861j.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H86e9de40a335459aad9a67de3a1bb507R.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H1168af98c89945ab8ac4d6086d09fccbH.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H7e0b2aaf04c94e47af72fc2386ec83d1W.jpg" slate-data-type="image"></p><p><strong><span style="font-size:20px">The Right Way To Use It</span></strong></p><p><strong><span style="font-size:20px">Measure when you are calm and relaxed</span></strong></p><p><span style="color:rgb(0, 156, 224);font-size:20px"><strong>Note:</strong></span></p><p><span style="color:rgb(0, 156, 224);font-size:20px"><strong>1) Ensure Correct posture</strong></span></p><p><span style="color:rgb(0, 156, 224);font-size:20px"><strong>2) Please Keep quiet during the measurement</strong></span></p><p><span style="color:rgb(0, 156, 224);font-size:20px"><strong>3) Volume wristband correctly</strong></span></p><ul><li><p style="text-align:left" align="left"><span style="color:rgb(0, 0, 0);font-size:18px"><strong>Before measurement, deep breath firstly, relax the body</strong></span></p></li><li><p style="text-align:left" align="left"><span style="color:rgb(0, 0, 0);font-size:18px"><strong>Arm placed on the table, palms up, fingers relaxed</strong></span></p></li><li><p style="text-align:left" align="left"><span style="color:rgb(0, 0, 0);font-size:18px"><strong>Ensure correct posture</strong></span></p></li><li><p style="text-align:left" align="left"><span style="color:rgb(0, 0, 0);font-size:18px"><strong>Mat a towel in the middle of the west and the elbow, make the arm keeps stable</strong></span></p></li><li><p style="text-align:left" align="left"><span style="color:rgb(0, 0, 0);font-size:18px"><strong>Blood pressure and heart make the same height</strong></span></p></li></ul><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content"><img src="https://ae01.alicdn.com/kf/H0670d83c74714eb095b640bed54111082.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H2e0cdce4562a4f999a6291936ce56b9fA.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/HTB1xIMNXOLxK1Rjy0Ffq6zYdVXac.jpg" slate-data-type="image"></p></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">Wrist Blood Pressure Monitor Features:<br>1.Small delicate design<br>2.Clear LCD digital display<br>3.It can store 99 groups of measuring results,display the average of PR readings about the latest three times.<br>4.Automatic compression and decompression<br>5.Voice broadcast function<br>6.Blood pressure classification function provides convenience for users to judge whether their blood pressure value is normal or not<br>7.2 display units: kPa, mmHg<br>8.The product will automatically go into sleep mode in 1 minute after measurement</p></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/HTB12jwMXULrK1Rjy1zbq6AenFXal.jpg" slate-data-type="image"></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">- 1 x Bloodpressuremonitor(without battery)<br>- 1 x User manual<br>- 1 x Retailed Box</p></div><div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/HTB1OgZNXIfrK1RkSnb4q6xHRFXaM.jpg" slate-data-type="image"></div><div class="detailmodule_text"><p style="font-family:OpenSans;font-size:14px;font-weight:300;line-height:20px;white-space:pre-wrap;color:rgb(0, 0, 0);margin-bottom:12px" class="detail-desc-decorate-content">Q: Can I use rechargeable batteries instead of alkaline?<br>A: This bp monitor supports alkaline batteries only.<br><br>Q: Is this bp monitor recommend for use for people over 60 years of age verses using a bp wrist monitor?<br>A: This monitors are suitable for the elders. wrist monitor is convenient and portable.<br><br>Q: Will this fit a child too?<br>A: Yes, while please do not use on neonatal infants, pregnant or pre-eclamptic women.</p></div><div><br></div></div></div><p><br></p>
<script>window.adminAccountId=233052559;</script>
</div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/He674c9112cb1462eb9f4e1b76a3e438af.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H94d2477c6a5c43e9ad43e2f0170e5974N.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H8689317a49434de9812ff326599d58b9R.jpg", localFile: ""),
    ],
    priceProduct: 12.90,
    discPriceProduct: 11.99,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "New model")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/He58166b24e294dc1b585c8071ca25e26s/BOXYM-Medical-Digital-LCD-Wrist-Blood-Pressure-Monitor-Automatic-sphygmomanometer-Tonometer-wrist-Blood-Pressure-Mete-Tonometer.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "Gray")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H57728324b0854a08a6e56b2a2290704bf/BOXYM-Medical-Digital-LCD-Wrist-Blood-Pressure-Monitor-Automatic-sphygmomanometer-Tonometer-wrist-Blood-Pressure-Mete-Tonometer.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 37
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ037",
    [StringData(code: "en", text: "LNWPYH Nail Set UV LED Lamp Dryer With 18/12 pcs Nail Gel Polish Kit Soak Off Manicure ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext"><div>
<div>
<div>
<div>
<div>
<div>&nbsp;</div>

<div>
<div>
<div>
<div>
<div>
<div>
<div>&nbsp;</div>

<div>
<div>
<div></div></div>
<div class="detailmodule_dynamic"><kse:widget data-widget-type="customText" id="23657831" title="" type="custom"><div style="max-width: 650.0px;overflow: hidden;font-size: 0;clear: both;"><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/Nail-Set-54W-UV-Lamp-Nail-drying-With-Multiple-nail-polishes-nail-Gel-Polish-Kit-Manicure/1005001970684062.html" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;"><img src="//ae01.alicdn.com/kf/Hf2b472ef944a4d1d9cbed9eb6adc6b24E.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/Nail-Set-54W-UV-Lamp-Nail-drying-With-Multiple-nail-polishes-nail-Gel-Polish-Kit-Manicure/1005001970684062.html" title="Nail Set 54W UV Lamp Nail drying With Multiple nail polishes nail Gel Polish Kit Manicure Set electric Nail drill Nail Tools Set" style="color: #666666;cursor: pointer;" name="productSubject">Nail Set 54W UV Lamp Nail drying With Multiple nail polishes nail Gel Polish Kit Manicure Set electric Nail drill Nail Tools Set</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 22.67-54.59</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/Nail-Set-54W-nail-Lamp-Nail-Dryer-35000RPM-Nail-drill-Machine-Nail-Extensions-Quick-Building-Gel/1005001907215108.html" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;"><img src="//ae01.alicdn.com/kf/Hdcae2dd5696447b3af61ec78c79210adN.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/Nail-Set-54W-nail-Lamp-Nail-Dryer-35000RPM-Nail-drill-Machine-Nail-Extensions-Quick-Building-Gel/1005001907215108.html" title="Nail Set 54W nail Lamp Nail Dryer 35000RPM Nail drill Machine Nail Extensions Quick Building Gel Polish Set Soak Nail Art kit" style="color: #666666;cursor: pointer;" name="productSubject">Nail Set 54W nail Lamp Nail Dryer 35000RPM Nail drill Machine Nail Extensions Quick Building Gel Polish Set Soak Nail Art kit</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 22.67-71.19</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/Nail-Manicure-Kit-For-Nail-lamp-Dryer-Gel-select-45-36-18-color-Nail-Polish-Set/1005002570041749.html" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;"><img src="//ae01.alicdn.com/kf/S795380e3506045a991a7e66da23a7b6ff.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/Nail-Manicure-Kit-For-Nail-lamp-Dryer-Gel-select-45-36-18-color-Nail-Polish-Set/1005002570041749.html" title="Nail Manicure Kit For Nail lamp Dryer Gel select 45/36/18 color Nail Polish Set &amp; Electric Nail Drill Nail Art Tools nail set" style="color: #666666;cursor: pointer;" name="productSubject">Nail Manicure Kit For Nail lamp Dryer Gel select 45/36/18 color Nail Polish Set &amp; Electric Nail Drill Nail Art Tools nail set</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 20.99-54.03</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/LNWPYH-Poly-UV-Gel-Set-With-Lamp-Pink-Clear-UV-Gel-Varnish-Nail-Polish-Quick-Building/1005003135882147.html" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;"><img src="//ae01.alicdn.com/kf/H6b79241d5f5b42db9609c6071b6e3408P.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/LNWPYH-Poly-UV-Gel-Set-With-Lamp-Pink-Clear-UV-Gel-Varnish-Nail-Polish-Quick-Building/1005003135882147.html" title="LNWPYH Poly UV Gel Set With Lamp Pink Clear UV Gel Varnish Nail Polish Quick Building For Nails Extensions Hard Gel Nail Kit" style="color: #666666;cursor: pointer;" name="productSubject">LNWPYH Poly UV Gel Set With Lamp Pink Clear UV Gel Varnish Nail Polish Quick Building For Nails Extensions Hard Gel Nail Kit</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 20.99-37.03</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/20-18-12-Color-Gel-Nail-Polish-Varnish-nail-Kit-with-36w-54w-114w-Led-Uv/33025109239.html" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;"><img src="//ae01.alicdn.com/kf/Sb709587c496b470da53a43b98442ef8c5.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/20-18-12-Color-Gel-Nail-Polish-Varnish-nail-Kit-with-36w-54w-114w-Led-Uv/33025109239.html" title="20/18/12 Color Gel Nail Polish Varnish nail Kit with 36w/54w/114w Led Uv Nail Lamp Kit for Manicure Set Acrylic Nails Art Tools" style="color: #666666;cursor: pointer;" name="productSubject">20/18/12 Color Gel Nail Polish Varnish nail Kit with 36w/54w/114w Led Uv Nail Lamp Kit for Manicure Set Acrylic Nails Art Tools</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 14.99-47.23</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/Manicure-Set-With-114W-54W-24W-Led-Nail-Lamp-Nail-Set-35000RPM-Nail-drill-Machine-36/1005002583767953.html" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;"><img src="//ae01.alicdn.com/kf/Se3ebb3032e904d15b273ea2cd0da08b6y.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/Manicure-Set-With-114W-54W-24W-Led-Nail-Lamp-Nail-Set-35000RPM-Nail-drill-Machine-36/1005002583767953.html" title="Manicure Set With 114W/54W/24W Led Nail Lamp Nail Set 35000RPM Nail drill Machine 36/18 Color UV Gel Nail Polish Kit Tools Set" style="color: #666666;cursor: pointer;" name="productSubject">Manicure Set With 114W/54W/24W Led Nail Lamp Nail Set 35000RPM Nail drill Machine 36/18 Color UV Gel Nail Polish Kit Tools Set</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 20.99-66.03</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/Poly-Nail-Gel-Kit-Professional-Nail-Set-With-54-36-24W-UV-Lamp-Acrylic-Extension-Gel/1005003228207016.html" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;"><img src="//ae01.alicdn.com/kf/S2fb7cf4b876544bb8768d16301625805v.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/Poly-Nail-Gel-Kit-Professional-Nail-Set-With-54-36-24W-UV-Lamp-Acrylic-Extension-Gel/1005003228207016.html" title="Poly Nail Gel Kit Professional Nail Set With 54/36/24W UV Lamp Acrylic Extension Gel Nail Polish All For Manicure Gel Tools Set" style="color: #666666;cursor: pointer;" name="productSubject">Poly Nail Gel Kit Professional Nail Set With 54/36/24W UV Lamp Acrylic Extension Gel Nail Polish All For Manicure Gel Tools Set</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 20.99-37.03</em>/piece</span></div><div style="border: 1.0px solid #dedede;vertical-align: top;text-align: left;color: #666666;width: 120.0px;padding: 10.0px 15.0px;margin: 10.0px 10.0px 0 0;word-break: break-all;display: inline-block;*display: inline;zoom: 1;"><a href="//www.aliexpress.com/item/LNWPYH-Nail-Set-UV-LED-Lamp-Dryer-With-18-12-pcs-Nail-Gel-Polish-Kit-Soak/32964785488.html" name="productDetailUrl" style="display: table-cell;vertical-align: middle;width: 120.0px;height: 120.0px;text-align: center;cursor: pointer;*display: block;*font-size: 100.0px;*overflow: hidden;"><img src="//ae01.alicdn.com/kf/S7433b210dd86448298c7fee342d4c3edW.jpg_120x120.jpg" style="vertical-align: middle;max-width: 120.0px;max-height: 120.0px;border: 0 none;"></a><span style="display: block;line-height: 14.0px;height: 28.0px;width: 100.0%;overflow: hidden;margin: 4.0px 0;font-size: 11.0px;"><a href="//www.aliexpress.com/item/LNWPYH-Nail-Set-UV-LED-Lamp-Dryer-With-18-12-pcs-Nail-Gel-Polish-Kit-Soak/32964785488.html" title="LNWPYH Nail Set UV LED Lamp Dryer With 18/12 pcs Nail Gel Polish Kit Soak Off Manicure Tools Set electric Nail drill Nail Tools" style="color: #666666;cursor: pointer;" name="productSubject">LNWPYH Nail Set UV LED Lamp Dryer With 18/12 pcs Nail Gel Polish Kit Soak Off Manicure Tools Set electric Nail drill Nail Tools</a></span><span style="color: #999999;font-size: 12.0px;line-height: 1;"><em style="color: #bd1a1d;font-style: normal;font-weight: 700;">USD 20.99-37.03</em>/piece</span></div></div></kse:widget></div>
<div class="detailmodule_html"><div class="detail-desc-decorate-richtext"></div>
</div>
</div>

<div>
<div>&nbsp;</div>
</div>

<div><span style="font-size:18px"><br>
Please choose 18/12 color under the color chart , And then leave a message to me , otherwise we will send you random color, Kit without nail polish can not choose color,</span><span style="color:rgb(255, 0, 0);font-size:18px"><span style="font-size:20px"><strong>(if you need to choose the color of the nail polish, please choose to send from China, Russia or Packages shipped from Spanish overseas warehouses cannot choose the color of nail polish)</strong></span></span><span style="font-size:18px"> thank you!</span></div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<div>
<p align="left" style="text-align:left;margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H315f68662bfd454195f74c96b459e6bfD.jpg?width=800&amp;height=2221&amp;hash=3021" data-spm-anchor-id="a2g0o.detail.1000023.i0.737642beH5aZHI"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hf1aeb6f9a763495085d1cee6040e6aebL.jpg?width=800&amp;height=800&amp;hash=1600" data-spm-anchor-id="a2g0o.detail.1000023.i1.737642beH5aZHI"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H43bcc38e47684160948e69bba7904056c.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H7bd8acc186554d98b733e9ffd4b74844q.jpg?width=800&amp;height=800&amp;hash=1600" data-spm-anchor-id="a2g0o.detail.1000023.i2.737642beH5aZHI"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hdf094c5ee3724e879acd7e3094a527f8X.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hf79b3e47b9d84361abcbc9c4581809adg.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H2d1eb43f7f24488e9d9a0fa2a0ef6966f.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H066093dd397f4fe3af220b6e8878b269Q.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H0a720de355914db1a15c0ef7bf5a0e2f9.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H74105cbf7b064603a2fd28f8ce19b219d.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Ha4a09795d9e24e5798ad30f4ddf1fd1b2.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hed38f988c7654cbc8853f5b0b58e07c2n.jpg?width=800&amp;height=800&amp;hash=1600"><br>
<img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae03.alicdn.com/kf/H2ecf93f2194d42d1853e8978211bab52W.jpg"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Ha622089f866449b48767bb7c95d6bc23k.jpg?width=800&amp;height=800&amp;hash=1600"><br>
<img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H815714a05ca9486bb15d466870362511y.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H4f3cf1157c324bf285147e827d00f66eC.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hf0258618d30b4814aafd6736847a612a6.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hdd55086317b446dabb3315db4e85076el.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H6f0e63b687914a8da5e85711ee3aa923m.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hbb676c77cc16421194591dfa8eabe7f3D.jpg?width=800&amp;height=800&amp;hash=1600"><br>
<img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H231900e505384f2c8415e12fef18b1b2r.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hcaabef1d03a14451ab3dcfea69f84243Q.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H56e16dab475448868788c547f1fa3b67c.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H092fe47e72b9492eba29e57f05fd3f17x.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/Hf3a8dc0947d446598b6fd3abaf50fe026.jpg?width=800&amp;height=800&amp;hash=1600"><br>
<img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H4390d9c402f246edb60d021eba717a0eZ.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H5fa196f9542243a99d850cb2f0521d172.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H0414c293fbd44d27a7d5c0cf0b916866l.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H37cbc3e9056d42d58d43e86bf3153223s.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H470770a1ae54456b94d74147cef9d7cep.jpg?width=800&amp;height=800&amp;hash=1600"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H91e1becf12b0418186017c48f6126d5fm.jpg?width=800&amp;height=800&amp;hash=1600"></p>

<p align="left" style="text-align:left;margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/HTB1hzNsaHH1gK0jSZFwq6A7aXXax.jpg?width=800&amp;height=800&amp;hash=1600"><br>
<img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H72c9c3b5c1304482868ef7abbcf82d67l.jpg?width=800&amp;height=1000&amp;hash=1800"><img referrerpolicy="no-referrer" slate-data-type="image" src="https://ae01.alicdn.com/kf/H1359cf1ca9a246d58d1654def9e19075q.jpg?width=800&amp;height=1804&amp;hash=2604"><br>
<span style="font-size:22px">include :</span> <span style="font-size:18px">1 pieces 24W/48W/54W nail lamp&nbsp; 12/18 Pieces High quality Gel polish 1 pieces Dead skin pusher 2 pieces longer(100*180) buffer&nbsp; 1 pieces nail file 1 pieces cuticle fork 5 pcs/set Plastic Nail Art Off Cap Clip 1 pieces soak off Base gel polish 1 pieces soak off Top coat gel polish 1 x 12 colors of rhinestones 1 x 12 colors of pearl 2 pieces Fashion Nail Sticker 1 Pieces Cuticle Oil (Random Smell) 12 Pair Nail polish Remover 3 Sheet French Tips 1 Pieces Nail clippers 1 Pieces Pink Brush 1 pieces nail glue 2 pieces nail separator 1 x UV gel (pink) 1/2 OZ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 x UV gel (white) 1/2 OZ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 x UV gel (clear) 1/2 OZ &nbsp; 1x &nbsp;brush pen 1x Handpiece Support 6x Drill Bits</span></p>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/S7433b210dd86448298c7fee342d4c3edW/LNWPYH-Nail-Set-UV-LED-Lamp-Dryer-With-18-12-pcs-Nail-Gel-Polish-Kit-Soak.jpg_Q90.jpg_.webp", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Hf1aeb6f9a763495085d1cee6040e6aebL.jpg?width=800&height=800&hash=1600", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H7bd8acc186554d98b733e9ffd4b74844q.jpg?width=800&height=800&hash=1600", localFile: ""),
    ],
    priceProduct: 5.66,
    discPriceProduct: 0.6,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "X4 led lamp12color")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/S69489b67c3204e789fa0390806bf9bf5w/LNWPYH-Nail-Set-UV-LED-Lamp-Dryer-With-18-12-pcs-Nail-Gel-Polish-Kit-Soak.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "54W led lamp 12color")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/S80efa26d544c4b009083e2e2c67ea708A/LNWPYH-Nail-Set-UV-LED-Lamp-Dryer-With-18-12-pcs-Nail-Gel-Polish-Kit-Soak.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 38
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ038",
    [StringData(code: "en", text: "ffp2mask ffp2 masks kn95 certificadas mascarillas ffp2reutilizable mask Approved hygienic security ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="product-overview"><div id="product-description" data-spm="1000023" class="product-description"><div class="origin-part box-sizing"><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px;box-sizing:border-box" align="start"><span style="color:rgb(0, 0, 0);font-size:20px;font-family:OpenSans">Note:The Mask are Printed "</span><span style="color:rgb(255, 0, 0);font-size:14px;font-family:&quot;Open Sans&quot;, sans-serif"><span style="font-size:20px;font-family:OpenSans">FFP2 NR EN 149:2001 +A1:2009 CE 0370</span></span><span style="color:rgb(0, 0, 0);font-size:20px;font-family:OpenSans">" for</span><span style="color:rgb(51, 47, 47);font-size:14px;font-family:&quot;Open Sans&quot;, sans-serif"><span style="color:rgb(51, 47, 47);font-size:20px;font-family:OpenSans">Adult</span></span></p><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px;padding-bottom:0px;padding-top:0px;padding-left:0px;padding-right:0px;box-sizing:border-box" align="start"><br></p><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px;box-sizing:border-box" align="start"><span style="color:rgb(228, 12, 12);font-size:28px"><strong>Advantages&nbsp;of&nbsp;fish&nbsp;masks:</strong></span><span style="font-size:24px"><br></span></p><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px;box-sizing:border-box" align="start"><span style="font-size:24px">①Comfortable&nbsp;to&nbsp;wear.<br>②Good&nbsp;filtering&nbsp;effect,&nbsp;especially&nbsp;for&nbsp;extremely&nbsp;fine&nbsp;particles&nbsp;and&nbsp;dust.<br></span></p><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px;box-sizing:border-box" align="start"><span style="font-size:24px" data-spm-anchor-id="a2g0o.detail.1000023.i0.3aaf5201qYfjMl">③Fits&nbsp;a&nbsp;variety&nbsp;of&nbsp;face&nbsp;shapes.<br></span></p><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px;box-sizing:border-box" align="start"><span style="font-size:24px">④High-quality&nbsp;protective&nbsp;effect.&nbsp;Its&nbsp;protective&nbsp;effect&nbsp;is&nbsp;the&nbsp;same&nbsp;level&nbsp;as&nbsp;KN95&nbsp;mask&nbsp;and&nbsp;European&nbsp;FFP2&nbsp;mask.</span></p><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px;box-sizing:border-box" align="start"><span style="font-size:24px">⑤Applicable&nbsp;to&nbsp;a&nbsp;variety&nbsp;of&nbsp;environments&nbsp;where&nbsp;protective&nbsp;masks&nbsp;need&nbsp;to&nbsp;be&nbsp;worn&nbsp;for&nbsp;a&nbsp;long&nbsp;time,&nbsp;such&nbsp;as&nbsp;factories,&nbsp;schools,&nbsp;companies,&nbsp;shopping&nbsp;malls,&nbsp;sandstorms,&nbsp;construction&nbsp;sites,&nbsp;hospitals,&nbsp;parks,&nbsp;etc.</span></p><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px;box-sizing:border-box" align="start"><br></p><p style="font-family:&quot;Open Sans&quot;, sans-serif;font-size:14px;font-weight:400;letter-spacing:normal;line-height:inherit;text-align:start;white-space:normal;color:rgb(0, 0, 0);background-color:rgb(255, 255, 255);margin:0px;margin-bottom:0px;margin-top:0px;margin-left:0px;margin-right:0px;padding:0px 0px 0px 0em;padding-bottom:0px;padding-top:0px;padding-right:0px;box-sizing:border-box" align="start"><span style="background-color:rgb(255, 255, 255);color:rgb(0, 0, 0);font-size:20px;font-family:OpenSans">Please be kindly noted,the listed product is produced and distributed abroad and subject to the</span><img src="https://ae01.alicdn.com/kf/Hddd3186b4ff645d4ba0d0c5ee31bcceao.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Hefb78a2a3b2c43c08dbafb4cfe6e93b8M.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H5c04f4b285354d2d83a48d81590cb468Q.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H6e99de204e2743be866664e4f03368bbO.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Ha76ec7b8d8e44ad991221f618a3389ca9.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H8abf33cafdc849a0a5cc515139a921872.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H3797cbf378df4864b8875e2b020b9092h.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H1fbead52741f458c890ffcde9d66fb3bz.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H012dd97511a4416b8eb8ca8adb826226H.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H41f5517be1ac4d03beae2e1eb2da4e0ep.jpg" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H454b560993164b6d9a6b90fe518e3341j.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/He2505d3f79c94c1494aebcf98684ca88p.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H6ff593277fe443bc9dca6684bba42c42F.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/Haa59034357b04ac0b5ff93d956cb2ce26.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H370847b5c5c14d12b1cdb2699df72d92v.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/He54397c13d4f4cffb819e50458b9bcfeU.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H38226ad6829c46a2b37aa2c02e8d8c79w.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H8926be1a069f4541b0bcdbe631c61ba6K.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H8cf6d8e9ccf94a179b58d3c67afadbfek.png" slate-data-type="image"><img src="https://ae01.alicdn.com/kf/H8b7222c423524769a1b26cf5651e78b3F.png" slate-data-type="image"></p>
<script>window.adminAccountId=244260847;</script>
</div></div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/H3797cbf378df4864b8875e2b020b9092h.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H41f5517be1ac4d03beae2e1eb2da4e0ep.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H454b560993164b6d9a6b90fe518e3341j.png", localFile: ""),
    ],
    priceProduct: 5.02,
    discPriceProduct: 4.99,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Quantity")],
        price: [
          PriceData([
            StringData(code: "en", text: "10pcs-white")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/Hd7571c5db30b4bdebf9f22eb012ffd06D/ffp2mask-ffp2-masks-kn95-certificadas-mascarillas-ffp2reutilizable-mask-Approved-hygienic-security-protection-mascarilla-fpp2.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "50pcs-white")],
            8, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/H4906051be6e64a528e6db3334ccbaea0W/ffp2mask-ffp2-masks-kn95-certificadas-mascarillas-ffp2reutilizable-mask-Approved-hygienic-security-protection-mascarilla-fpp2.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 39
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ039",
    [StringData(code: "en", text: "1PC Professional Ultimate Black Liquid Eyeliner Long-lasting Waterproof Quick-dry Eye Liner ")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detailmodule_image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hf2b6ce85c836441899b7f44198524987P.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hdf8a5b9eca3d4e47b6dac334671b7778P.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i3.337b1a15b6XkJ7"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hf37a5a9d674547cdb4c0e828febf3fb2C.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i0.337b1a15b6XkJ7"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H1d649868137c4e2b9af2b16dd3330574O.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i2.337b1a15b6XkJ7"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H6a25905ab01d4aaba588ea6dd90d81e4X.jpg" slate-data-type="image" data-spm-anchor-id="a2g0o.detail.1000023.i1.337b1a15b6XkJ7"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H9729b959ee07409687a28803f3c5ad26z.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/Hfc1beb54fc334f77919c17f3f2ca3d20V.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H5e2ad01582a245539d5fe3c1979d2ba1c.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H56352d8dbc3a4a69b6ddd2ad4dea259cj.jpg" slate-data-type="image"><img class="detail-desc-decorate-image" src="https://ae01.alicdn.com/kf/H3f4a3833657643f58f28b3021c808a0dD.jpg" slate-data-type="image"></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1BEI_aOzxK1RjSspjq6AS.pXaj/1PC-Professional-Ultimate-Black-Liquid-Eyeliner-Long-lasting-Waterproof-Quick-dry-Eye-Liner-Marker-Make-up.jpg_Q90.jpg_.webp", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/Hf37a5a9d674547cdb4c0e828febf3fb2C.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/H1d649868137c4e2b9af2b16dd3330574O.jpg", localFile: ""),
    ],
    priceProduct: 1.78,
    discPriceProduct: 0.97,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "black")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1qIlIOpXXXXbKXXXXq6xXFXXX7/1PC-Professional-Ultimate-Black-Liquid-Eyeliner-Long-lasting-Waterproof-Quick-dry-Eye-Liner-Marker-Make-up.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "black Type 1")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/Hf89ad6cd9201433196f2aeec4ed8534eF/1PC-Professional-Ultimate-Black-Liquid-Eyeliner-Long-lasting-Waterproof-Quick-dry-Eye-Liner-Marker-Make-up.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 40
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ040",
    [StringData(code: "en", text: "Natural Curling Eyelash Mascara Waterproof Long-lasting")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext"><div> 
 <span style="color:#00B0F0;font-size:16px;"><span style="font-size:16px;">100% Brand New</span></span> 
</div> 
<div> 
 <span style="color:#00B0F0;font-size:16px;"><span style="font-size:16px;">Pigment Black Waterproof Color Eye Liner Pencil</span></span> 
</div> 
<div> 
 <span style="color:#00B0F0;font-size:16px;"><span style="font-size:16px;">Decorate Your Eyes As You Like</span></span> 
</div> 
<div> 
 <span style="color:#00B0F0;font-size:16px;"><span style="font-size:16px;">Color:13 Colors For Choose</span></span> 
</div> 
<div> 
 <span style="color:#00B0F0;font-size:16px;"><span style="font-size:16px;">Size:Full Size</span></span> 
</div> 
<div> 
 <span style="color:#00B0F0;font-size:16px;"><span style="font-size:16px;">Features:Waterproof,Long lasting</span></span> 
</div> 
<div> 
 <span style="color:#00B0F0;font-size:16px;"><span style="font-size:16px;">Suitable:Eyeline,under eyeline,Eyeshadow pen</span></span> 
</div> 
<div> 
 <div> 
  <span style="color:#FF0000;font-size:16px;"><span style="font-size:16px;">Package include:1 Pc Double-end Eyeliner Pencil</span></span> 
 </div> 
 <div> 
  <span style="font-size:16px;"></span>
  <br> 
 </div> 
 <div> 
  <span style="color:#FF0000;font-size:16px;"><span style="font-size:16px;">Note:</span></span> 
 </div> 
 <div> 
  <span style="color:#FF0000;font-size:16px;"><span style="font-size:16px;">This eyeline pencial can't twist and turn,you can use pencil sharpener.</span></span> 
 </div> 
 <div> 
  <span style="color:#FF0000;font-size:16px;"><span style="font-size:16px;">And the pencil sharpener NOT INCLUDE IN PACKAGE.</span></span> 
 </div> 
 <div> 
  <span style="font-size:16px;">&nbsp;</span> 
 </div> 
 <div> 
  <span style="color:#FF0000;font-size:16px;"><span style="font-size:16px;">CAUTION:</span></span> 
 </div> 
 <div> 
  <span style="color:#FF0000;font-size:16px;"><span style="font-size:16px;">For External Use Only.Avoid Contact With Eyes.</span></span> 
 </div> 
 <div> 
  <span style="color:#FF0000;font-size:16px;"><span style="font-size:16px;">Please Store It Under Shade Environment And Keep Out From Of Children.</span></span> 
 </div> 
 <div> 
  <img alt="72-2" data-kse-saved-src="https://ae01.alicdn.com/kf/Ha3dac6a36d7f45a7925166dd0b200d81R.jpg" src="https://ae01.alicdn.com/kf/Ha3dac6a36d7f45a7925166dd0b200d81R.jpg" style="cursor:default;white-space:normal;background-color:#FFFFFF;color:#FF0000;font-family:&quot;comic sans ms&quot;, cursive;font-size:18px;">
  <span style="font-size:16px;"></span> 
 </div> 
 <div> 
  <span style="font-size:16px;">&nbsp;</span> 
 </div> 
 <div> 
  <img alt="8a9928a36a448e11016a44c2c5b800c1" src="https://ae01.alicdn.com/kf/HTB1x3koTxnaK1RjSZFBq6AW7VXan.jpg" data-spm-anchor-id="a2g0o.detail.1000023.i0.4e3217773UtLfW">
  <img alt="8a9928a36a448e11016a44c2adab00b9" src="https://ae01.alicdn.com/kf/HTB17.cpTxjaK1RjSZKzq6xVwXXag.jpg">
  <img alt="8a9928a36a448e11016a44c2b3ec00bc (1)" src="https://ae01.alicdn.com/kf/HTB1hf20TCzqK1RjSZFjq6zlCFXar.jpg" data-spm-anchor-id="a2g0o.detail.1000023.i1.4e3217773UtLfW">
  <img alt="8a9928a36a448e11016a44c2b37300ba" src="https://ae01.alicdn.com/kf/HTB1par0TrvpK1RjSZPiq6zmwXXaC.jpg">
  <img alt="8a9928a36a448e11016a44c2bd0600bd" src="https://ae01.alicdn.com/kf/HTB1Tm2ZTBLoK1RjSZFuq6xn0XXax.jpg" data-spm-anchor-id="a2g0o.detail.1000023.i2.4e3217773UtLfW">
  <img alt="8a9928a36a448e11016a44c2bde600be" src="https://ae01.alicdn.com/kf/HTB1W1bSTzDpK1RjSZFrq6y78VXag.jpg">
  <img alt="8a9928a36a448e11016a44c2be3d00bf" src="https://ae01.alicdn.com/kf/HTB1fm_UTCzqK1RjSZFLq6An2XXaC.jpg">
  <img alt="8a9928a36a448e11016a44c2c12900c0" src="https://ae01.alicdn.com/kf/HTB1XkY1TxTpK1RjSZFMq6zG_VXaR.jpg">
  <img alt="8a9928a36a448e11016a44c3007700c3" src="https://ae01.alicdn.com/kf/HTB1VWPZTxTpK1RjSZR0q6zEwXXak.jpg">
  <img alt="MRZC7C46-" src="https://ae01.alicdn.com/kf/HTB1OW67TAPoK1RjSZKbq6x1IXXaM.jpg">
  <img alt="MRZC7C46-1" src="https://ae01.alicdn.com/kf/HTB1xeH2TrvpK1RjSZFqq6AXUVXal.jpg">
  <img alt="MRZC7C46-4" src="https://ae01.alicdn.com/kf/HTB1w_r3TpzqK1RjSZFoq6zfcXXal.jpg">
  <img alt="MRZC7C46-12" src="https://ae01.alicdn.com/kf/HTB1zGnVTCzqK1RjSZFLq6An2XXas.jpg">
  <img alt="MRZC7C46-13" src="https://ae01.alicdn.com/kf/HTB1Yqn0TBLoK1RjSZFuq6xn0XXa2.jpg">
  <img alt="MRZC7C46-14" src="https://ae01.alicdn.com/kf/HTB1vTv3TpzqK1RjSZFoq6zfcXXaj.jpg">
  <img alt="MRZC7C46-15" src="https://ae01.alicdn.com/kf/HTB1W7LSTwTqK1RjSZPhq6xfOFXaT.jpg"> 
 </div> 
 <div> 
  <span style="font-size:16px;">&nbsp;</span> 
 </div> 
 <div> 
  <span style="font-size:16px;">&nbsp;</span> 
 </div> 
</div></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1x3koTxnaK1RjSZFBq6AW7VXan.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1hf20TCzqK1RjSZFjq6zlCFXar.jpg", localFile: ""),
      ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1Tm2ZTBLoK1RjSZFuq6xn0XXax.jpg", localFile: ""),
    ],
    priceProduct: 0.9,
    discPriceProduct: 1.6,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Color")],
        price: [
          PriceData([
            StringData(code: "en", text: "1")],
            0.01, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1yfHZTxTpK1RjSZR0q6zEwXXaO/Highlighter-Glitter-Eyeshadow-Eyeliner-Pen-Waterproof-Sweatproof-Double-Ended-Eyes-Pencil-Durable-Women-Beauty-Makeup-Tool.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "3")],
            0, 0, "+",
            ImageData(serverPath: "https://ae01.alicdn.com/kf/HTB1wlD6Tq6qK1RjSZFmq6x0PFXaH/Highlighter-Glitter-Eyeshadow-Eyeliner-Pen-Waterproof-Sweatproof-Double-Ended-Eyes-Pencil-Durable-Women-Beauty-Makeup-Tool.jpg_50x50.jpg_.webp", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

  // 41
  ProductData(
    "jZBgGBJ8Zp5eIGaQQ041",
    [StringData(code: "en", text: "Natural Curling Eyelash Mascara Waterproof Long-lasting Eyelash Raincoat Primer Styling Liquid Non-smudge Mascara")],
    descTitle: [StringData(code: "en", text: "Description")],
    desc: [StringData(code: "en", text: '''
<div class="detail-desc-decorate-richtext"><div class="detailmodule_text">
 <p><span style="font-size:24px">Condition: 100% Brand New and High Quality</span></p>
</div>
<div class="detailmodule_text">
 <p><span style="font-size:24px">Item type:Mascara</span></p>
</div>
<div class="detailmodule_text">
 <p><span style="font-size:24px" data-spm-anchor-id="a2g2w.detail.1000023.i0.34746353WiJsgI">Color:Black,Brown</span></p>
</div>
<div class="detailmodule_text">
 <p><span style="font-size:24px">Quantity: 1PC</span></p>
</div>
<div class="detailmodule_text">
 <p><span style="font-size:24px">Net Content:4G</span></p>
</div>
<div class="detailmodule_text">
 <p><span style="font-size:24px">Package include: 1 PC Mascara</span></p>
</div>
<div class="detailmodule_text">
 <p><span style="font-size:24px">Note:</span></p>
</div>
<div class="detailmodule_text">
 <p><span style="font-size:24px">The colors might exist slight differences due to different displays.</span></p>
</div>
<div class="detailmodule_text">
 <p><span style="font-size:24px">Please allow slight dimension difference due to manual measurement.</span></p>
</div>
<div class="detailmodule_image">
 <img class="detail-desc-decorate-image" src="https://ae03.alicdn.com/kf/H76cd98f1c88646c48cfc7e036ec10d3cj.jpg" slate-data-type="image">
 <img class="detail-desc-decorate-image" src="https://ae03.alicdn.com/kf/Hdcdbd42efc5d48529cb2a66e8db16530y.jpg" slate-data-type="image">
 <img class="detail-desc-decorate-image" src="https://ae03.alicdn.com/kf/H73d76703bc094c45934bd59fd9eb7282P.jpg" slate-data-type="image">
 <img class="detail-desc-decorate-image" src="https://ae03.alicdn.com/kf/H0b81153b4d084ce3a05f47b31bba462cK.jpg" slate-data-type="image">
 <img class="detail-desc-decorate-image" src="https://ae03.alicdn.com/kf/H5da18cb5bfb64719ae32f85ca53f94e4Y.jpg" slate-data-type="image">
 <img class="detail-desc-decorate-image" src="https://ae03.alicdn.com/kf/Hb9fefdcbf985477e8bf8900b871c54e3i.jpg" slate-data-type="image">
 <img class="detail-desc-decorate-image" src="https://ae03.alicdn.com/kf/H881feadc3be34401898f1d3250710350W.jpg" slate-data-type="image">
 <img class="detail-desc-decorate-image" src="https://ae03.alicdn.com/kf/H2945069d758444b29b66b904d95e5585U.jpg" slate-data-type="image">
</div>
<br></div>
    ''')],
    tax: 10,
    taxAdmin: 5,
    providers: [_blowLTD],
    gallery: [ImageData(serverPath: "https://ae04.alicdn.com/kf/H4a406d9a0be84f74af0cb2450dbe380dy/Natural-Curling-Eyelash-Mascara-Waterproof-Long-lasting-Eyelash-Raincoat-Primer-Styling-Liquid-Non-smudge-Mascara-Eye.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/Hc950c70fa4b64bf6b9b63f5417fae8615/Natural-Curling-Eyelash-Mascara-Waterproof-Long-lasting-Eyelash-Raincoat-Primer-Styling-Liquid-Non-smudge-Mascara-Eye.jpg", localFile: ""),
      ImageData(serverPath: "https://ae04.alicdn.com/kf/H77b3d0402ed74a8184f06083183fb5aen/Natural-Curling-Eyelash-Mascara-Waterproof-Long-lasting-Eyelash-Raincoat-Primer-Styling-Liquid-Non-smudge-Mascara-Eye.jpg", localFile: ""),
    ],
    priceProduct: 1.25,
    discPriceProduct: 1.6,
    stock: 10,
    group: [
      GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
        price: [
          PriceData([
            StringData(code: "en", text: "A")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/H0da7d4d272744c1f95e2ac2217bc6a3ct/Natural-Curling-Eyelash-Mascara-Waterproof-Long-lasting-Eyelash-Raincoat-Primer-Styling-Liquid-Non-smudge-Mascara-Eye.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
          PriceData([
            StringData(code: "en", text: "B")],
            0, 0, "+",
            ImageData(serverPath: "https://ae04.alicdn.com/kf/He7417a1842a8455cb131c3ce409dbef55/Natural-Curling-Eyelash-Mascara-Waterproof-Long-lasting-Eyelash-Raincoat-Primer-Styling-Liquid-Non-smudge-Mascara-Eye.jpg_50x50.jpg", localFile: ""),
            stock: 999,
          ),
        ],
      ),
    ],
    assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
    category: [],
    video: "",
    videoType: "",
    thisIsArticle: true,
  ),

// 42
//   ProductData(
//     "jZBgGBJ8Zp5eIGaQQ042",
//     [StringData(code: "en", text: "")],
//     descTitle: [StringData(code: "en", text: "Description")],
//     desc: [StringData(code: "en", text: '''
//
//     ''')],
//     tax: 10,
//     taxAdmin: 5,
//     providers: [_blowLTD],
//     gallery: [ImageData(serverPath: "", localFile: ""),
//       ImageData(serverPath: "", localFile: ""),
//       ImageData(serverPath: "", localFile: ""),
//     ],
//     priceProduct: 5.66,
//     discPriceProduct: 0.6,
//     stock: 10,
//     group: [
//       GroupData(id: "5067e649-930c-4957-004-01", name: [StringData(code: "en", text: "Type")],
//         price: [
//           PriceData([
//             StringData(code: "en", text: "")],
//             0, 0, "+",
//             ImageData(serverPath: "", localFile: ""),
//             stock: 999,
//           ),
//           PriceData([
//             StringData(code: "en", text: "")],
//             0, 0, "+",
//             ImageData(serverPath: "", localFile: ""),
//             stock: 999,
//           ),
//         ],
//       ),
//     ],
//     assetsGallery: [], price: [], duration: Duration(minutes: 0), assetsCategory: [], assetsProvider: [], addon: [], timeModify: DateTime.now(),
//     category: [],
//     video: "",
//     videoType: "",
//     thisIsArticle: true,
//   ),
];
