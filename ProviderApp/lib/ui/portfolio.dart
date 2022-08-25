import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondprovider/model/model.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/ui/theme.dart';
import 'package:provider/provider.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  double windowWidth = 0;
  double windowHeight = 0;
  final ScrollController _scrollController = ScrollController();
  final _controllerSearch = TextEditingController();
  final _editController = TextEditingController();
  final _editControllerDescTitle = TextEditingController();
  final _editControllerDesc = TextEditingController();
  final _editControllerName = TextEditingController();
  final _editControllerAddress = TextEditingController();
  late MainModel _mainModel;
  String editItem = "";

  @override
  void dispose() {
    _controllerSearch.dispose();
    _editController.dispose();
    _scrollController.dispose();
    _editControllerDescTitle.dispose();
    _editControllerDesc.dispose();
    _editControllerName.dispose();
    _editControllerAddress.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _init();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  String _getHint(){
    if (editItem == "phone")
      return strings.get(135); /// "Enter your Phone",
    if (editItem == "www")
      return strings.get(136); /// "Enter your Web Page address",
    if (editItem == "instagram")
      return strings.get(137); /// "Enter your Instagram address",
    if (editItem == "telegram")
      return strings.get(138); /// "Enter your Telegram address",
    return "";
  }

  _init(){
    _editControllerDesc.text = getTextByLocale(currentProvider.desc, _mainModel.customerAppLangsComboValue);
    _editControllerDescTitle.text = getTextByLocale(currentProvider.descTitle, _mainModel.customerAppLangsComboValue);
    _editControllerName.text = getTextByLocale(currentProvider.name, _mainModel.customerAppLangsComboValue);
    _editControllerAddress.text = currentProvider.address;
  }

  double _scroller = 20;
  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    _scroller = 20-(_scrollPosition/(windowHeight*0.1/20));
    if (_scroller < 0)
      _scroller = 0;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: [
            Container(
              color: (theme.darkMode) ? Colors.black : Colors.white,
              width: windowWidth,
              height: windowHeight,
              child: _body2(),
            ),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),
          ],
        )
    ));
  }

  _body2(){
    return Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                    expandedHeight: windowHeight*0.2,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: ClipPath(
                      clipper: ClipPathClass23((_scroller < 5) ? 5 : _scroller),
                      child: Container(
                          child: Stack(
                            children: [
                              FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                background: _title(),
                                titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                              )
                            ],
                          )),
                    ))
              ];
            },
            body: Container(
              width: windowWidth,
              height: windowHeight,
              child: _body(),
            ),
          ),

          appbar1((_scroller > 1) ? Colors.transparent :
              (theme.darkMode) ? Colors.black : Colors.white,
              (theme.darkMode) ? Colors.white : Colors.black,
              (_scroller > 5) ? "" : getTextByLocale(currentProvider.name, strings.locale), context,
                  () {Navigator.pop(context);}),

          // Container(
          //   alignment: Alignment.bottomCenter,
          //   child: button1a(strings.get(102), /// "Book This Service"
          //       theme.style16W800White,
          //       mainColor, (){}, true),
          // ),

        ]);
  }

  _title() {
    var imageUpperServerPath = currentProvider.imageUpperServerPath;
    return Container(
      color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Stack(
        children: [
          Container(
              alignment: Alignment.bottomRight,
              child: Container(
                  width: windowWidth,
                  margin: EdgeInsets.only(bottom: 10),
                  child: imageUpperServerPath.isNotEmpty ? CachedNetworkImage(
                      imageUrl: imageUpperServerPath,
                      imageBuilder: (context, imageProvider) => Container(
                        child: Container(
                          width: windowHeight * 0.3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )),
                        ),
                      )
                  ) : Container()
              )),
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.all(40),
            child: button2small(strings.get(139), _changeUpperImage),  /// "Change",
          )

        ],
      ),
    );
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _body(){
    List<Widget> list = [];
    var imageUpperServerPath = currentProvider.logoServerPath;
    List<String> _dataCategory = [];
    // for (var item in _mainModel.category)
    //   if (item.select)
    //     _dataCategory.add(getTextByLocale(item.name));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 20),
        child: Combo(inRow: true, text: "",
          data: _mainModel.customerAppLangsCombo,
          value: _mainModel.customerAppLangsComboValue,
          onChange: (String value){
            // save
            providerSetName(_editControllerName.text, _mainModel.customerAppLangsComboValue);
            providerSetDesc(_editControllerDesc.text, _mainModel.customerAppLangsComboValue);
            providerSetDescTitle(_editControllerDescTitle.text, _mainModel.customerAppLangsComboValue);
            _mainModel.customerAppLangsComboValue = value;
            // load
            _init();
            _redraw();
          },)),);

    list.add(SizedBox(height: 10,));

    list.add(Container(
        width: windowWidth,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(theme.radius)),
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: imageUpperServerPath.isNotEmpty ? CachedNetworkImage(
                              imageUrl: imageUpperServerPath,
                              imageBuilder: (context, imageProvider) => Container(
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              )
                          ) : Container(),),
                      ],
                    )),
                SizedBox(height: 5,),
                button2small(strings.get(139), _changeIcon),  /// "Change",
              ],
            ),

            SizedBox(width: 10,),

            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                edit9(_editControllerName, style: theme.style14W800),
                SizedBox(height: 5,),
                Container(alignment: Alignment.bottomRight,
                  child: button2small(strings.get(134), _saveName)),  /// "Save",
                // Text(getTextByLocale(_mainModel.providerInfo.currentProvider.name), style: theme.style16W800, textAlign: TextAlign.start,),
                SizedBox(height: 5,),
                Divider(color: theme.style16W800.color),
                SizedBox(height: 5,),
                // if (widget.text2.isNotEmpty)
                //   Row(children: [
                //     card51(widget.stars, widget.starsColor, 16),
                //     Text(widget.text2, style: widget.style2, textAlign: TextAlign.center,),
                //     SizedBox(width: 5,),
                //     Text(widget.text3, style: widget.style3, textAlign: TextAlign.center,),
                //     Expanded(child: Text(widget.text4, style: widget.style4, textAlign: TextAlign.end, maxLines: 1,)),
                //   ],),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.orange, size: 15,),
                    SizedBox(width: 5,),
                    Expanded(child: edit22(_editControllerAddress, "", theme.radius, style: theme.style14W400)),
                    //Expanded(child: Text(widget.text5, style: widget.style5),)
                  ],
                ),
                SizedBox(height: 5,),
                Container(alignment: Alignment.bottomRight,
                  child: button2small(strings.get(134), _saveAddress)),  /// "Save",
                SizedBox(height: 5,),
                SizedBox(height: 10,),
                Divider(color: theme.style16W800.color),
                SizedBox(height: 10,),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _dataCategory.map((e) {
                    return Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(theme.radius),
                      ),
                      child: Text(e, style: theme.style12W600White,),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10,),
              ],
            ))

          ],
        )
        // Card50(
        //     text: getTextByLocale(_mainModel.providerInfo.currentProvider.name),
        //     style: theme.style16W800,
        //     text2: "",
        //     style2: theme.style12W600Stars,
        //     text3: "",
        //     style3: theme.style12W800,
        //     text4: "",
        //     style4: theme.style18W800Orange,
        //     text5: _mainModel.providerInfo.currentProvider.address,
        //     style5: theme.style12W400,
        //     icon: Icon(Icons.location_on_outlined, color: Colors.orange, size: 15,),
        //     data: _dataCategory,
        //     styleData: theme.style12W600White,
        //     color: (darkMode) ? Colors.black : Colors.white,
        //     shadow: false,
        //     radius: 10,
        //     stars: 0,
        //     starsColor: Colors.orange,
        //     badgetColor: Colors.green,
        //     image: imageUpperServerPath.isNotEmpty ? CachedNetworkImage(
        //         imageUrl: imageUpperServerPath,
        //         imageBuilder: (context, imageProvider) => Container(
        //           child: Container(
        //             decoration: BoxDecoration(
        //                 image: DecorationImage(
        //                   image: imageProvider,
        //                   fit: BoxFit.cover,
        //                 )),
        //           ),
        //         )
        //     ) : Container(),
        //     shadowText: "",
        //     shadowTextStyle: theme.style12W600White,
        //     shadowColor: Colors.black
        // ))
    ));

    list.add(SizedBox(height: 20,));

    List<Widget> list2 = [];

    list2.add(
      Column(
        children: [
          InkWell(
              onTap: () {
                if (currentProvider.phone.isNotEmpty)
                  callMobile(currentProvider.phone);
              }, // needed
              child: UnconstrainedBox(
                child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset("assets/phone.png",
                        fit: BoxFit.contain
                    )
                ),
              )),
          SizedBox(height: 6,),
          button2small(strings.get(133), (){  /// "Edit",
            _editController.text = currentProvider.phone;
            editItem = "phone";
            _redraw();
          })
        ],
      )
    );

    list2.add(Column(
        children: [
          InkWell(
              onTap: () {
                if (currentProvider.www.isNotEmpty)
                  openUrl(currentProvider.www);
              }, // needed
              child: UnconstrainedBox(
                child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset("assets/www.png",
                        fit: BoxFit.contain
                    )
                ),
              )),
          SizedBox(height: 6,),
          button2small(strings.get(133), (){  /// "Edit",
            _editController.text = currentProvider.www;
            editItem = "www";
            _redraw();
          })
        ]
    ));

    list2.add(Column(
        children: [
          InkWell(
              onTap: () {
                if (currentProvider.instagram.isNotEmpty)
                  openUrl(currentProvider.instagram);
              }, // needed
              child: UnconstrainedBox(
                child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset("assets/insta.png",
                        fit: BoxFit.contain
                    )
                ),
              )),
          SizedBox(height: 6,),
          button2small(strings.get(133), (){  /// "Edit",
            _editController.text = currentProvider.instagram;
            editItem = "instagram";
            _redraw();
          })
        ]
    )
    );


    list2.add(Column(
        children: [
          InkWell(
              onTap: () {
                if (currentProvider.telegram.isNotEmpty)
                  openUrl(currentProvider.telegram);
              }, // needed
              child: UnconstrainedBox(
                child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset("assets/tg.png",
                        fit: BoxFit.contain
                    )
                ),
              )),
          SizedBox(height: 6,),
          button2small(strings.get(133), (){  /// "Edit",
            _editController.text = currentProvider.telegram;
            editItem = "telegram";
            _redraw();
          })
        ]
    )
    );

    if (list2.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        // height: 40,
        width: windowWidth - 20,
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 20,
          spacing: 20,
          children: list2,
        ),
      ));

    if (editItem == "phone" || editItem == "www"
        || editItem == "instagram" || editItem == "telegram")
      list.add(Row(
        children: [
          SizedBox(width: 20,),
          Expanded(child: edit42("",
                _editController,
                _getHint(),
                type: TextInputType.phone),
          ),
          SizedBox(width: 10,),
          button2small(strings.get(134), _savePhoneInstaTelega),  /// "Save",
          SizedBox(width: 20,),
        ],
      ));
    list.add(SizedBox(height: 20,),);

    /// description
    list.add(Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: (theme.darkMode) ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              edit9(_editControllerDescTitle, style: theme.style16W800),
              // Text(getTextByLocale(_mainModel.providerInfo.currentProvider.descTitle),
              //   style: theme.style16W800, textAlign: TextAlign.start,),   // "Description",
              Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
              SizedBox(height: 5,),
              edit22(_editControllerDesc, "", theme.radius, style: theme.style14W400),
              //Text(getTextByLocale(_mainModel.providerInfo.currentProvider.desc), style: theme.style14W400),
              SizedBox(height: 5,),
              Divider(color: (theme.darkMode) ? Colors.white : Colors.black),
            ],
          )
    ));
    list.add(Container(
      alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: button2small(strings.get(134), _saveDesc),  /// "Save",
    ));

    list.add(SizedBox(height: 20,),);

    var index = 0;
    for (var item in currentProvider.workTime){
      if (item.weekend)
        continue;
      list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(child: Text(strings.get(125+index), style: theme.style14W800,),),
              Text(item.openTime, style: theme.style14W400),
              Text("-"),
              Text(item.openTime, style: theme.style14W400),
            ],
          )));
      list.add(SizedBox(height: 5,));
      index++;
    }
    list.add(SizedBox(height: 20,));

    list.add(Container(
        color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(child: Text(strings.get(132), /// "Galleries",
              style: theme.style14W800,)),
            Container(
              width: windowWidth/2,
              height: windowWidth/2,
              child: Image.asset("assets/ondemand/ondemand20.png", fit: BoxFit.contain)
            ),
          ],
        )));

    list.add(SizedBox(height: 10,));

    // if (_mainModel.providerInfo.currentProvider.gallery.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: currentProvider.gallery.map((e){
            var _tag = UniqueKey().toString();
            return InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryScreen(item: e, gallery: currentProvider.gallery,
                          tag: _tag, textDirection: strings.direction,),
                      )
                  );
                },
                child: Hero(
                    tag: _tag,
                    child:
                        Container(
                            width: windowWidth/3-20,
                            height: windowWidth/3-20,
                            child: Stack(
                                children: [
                                  Image.network(e.serverPath, fit: BoxFit.cover),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.all(10),
                                    child: button2small(strings.get(86),
                                            (){_delete(e);}),  /// "Delete",
                                  )
                                ],
                          // (e.name != null) ?
                          // Image.asset(e.name!, fit: BoxFit.cover) :
                          // Image.memory(e.image!, fit: BoxFit.cover)
                          // )
                        ),

                    )
            ));
          }).toList(),
        ),
      ));

    list.add(SizedBox(height: 10,));
    list.add(Row(children: [
      Expanded(child: Container(
        alignment: Alignment.bottomRight,
        child: button2small(strings.get(140),
         (){_addToGallery(ImageSource.gallery);}),  /// "Add from galley",
      )),
      SizedBox(width: 10,),
      Expanded(child: button2small(strings.get(141),
           (){_addToGallery(ImageSource.camera);})),  /// "Add from camera",
    ],));


    list.add(SizedBox(height: 20,));

    // list.add(Container(
    //     color: (darkMode) ? blackColorTitleBkg : colorBackground,
    //     padding: EdgeInsets.only(left: 20, right: 20),
    //     child: Row(
    //       children: [
    //         Expanded(child: Column(
    //           children: [
    //             Text(strings.get(101), // "Reviews & Ratings"
    //               style: theme.style14W800,),
    //             SizedBox(height: 20,),
    //             Row(children: [
    //               card51(4, Colors.orange, 20),
    //               Text("4.0", style: theme.style12W600Orange, textAlign: TextAlign.center,),
    //               SizedBox(width: 5,),
    //               Text("(1)", style: theme.style14W800, textAlign: TextAlign.center,),
    //             ],),
    //           ],
    //         )),
    //         Container(
    //             width: windowSize*0.4,
    //             child: Image.asset("assets/ondemands/ondemand19.png",
    //                 fit: BoxFit.contain
    //             )
    //         ),
    //       ],
    //     )));
    //
    // list.add(SizedBox(height: 10,));

    // list.add(Container(
    //     margin: EdgeInsets.only(left: 10, right: 10),
    //     child: Column(
    //       children: [
    //
    //         card47("assets/user1.jpg",
    //             "Carter Anne", theme.style16W800,
    //             "20 Dec 2021", theme.style12W600Grey,
    //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ",
    //             theme.style14W400,
    //             false, (darkMode) ? blackColorTitleBkg : colorBackground,
    //             ["assets/barber/1.jpg", "assets/barber/2.jpg", "assets/barber/3.jpg",],
    //             3, Colors.orange
    //         ),
    //
    //       ],
    //     )));


    list.add(SizedBox(height: 150,));
    return Container(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: list,
        )
    );
  }

  _savePhoneInstaTelega() async {
    String value = _editController.text;
    if (editItem == "phone")
      currentProvider.phone = value;
    if (editItem == "www")
      currentProvider.www = value;
    if (editItem == "instagram")
      currentProvider.instagram = value;
    if (editItem == "telegram")
      currentProvider.telegram = value;
    editItem = "";

    var ret = await saveProviderFromAdmin();
    if (ret != null)
      messageError(context, ret);

    _redraw();
  }

  _saveDesc() async {
    providerSetDesc(_editControllerDesc.text, _mainModel.customerAppLangsComboValue);
    providerSetDescTitle(_editControllerDescTitle.text, _mainModel.customerAppLangsComboValue);
    var ret = await saveProviderFromAdmin();
    if (ret != null)
      messageError(context, ret);
    else
      messageOk(context, strings.get(116)); /// "Data saved",
    _redraw();
  }

  _saveName() async {
    providerSetName(_editControllerName.text, _mainModel.customerAppLangsComboValue);
    var ret = await saveProviderFromAdmin();
    if (ret != null)
      messageError(context, ret);
    else
      messageOk(context, strings.get(116)); /// "Data saved",
    _redraw();
  }

  _saveAddress() async {
    currentProvider.address = _editControllerAddress.text;
    var ret = await saveProviderFromAdmin();
    if (ret != null)
      messageError(context, ret);
    else
      messageOk(context, strings.get(116)); /// "Data saved",
    _redraw();
  }

  _changeIcon() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pickedFile = await ImagePicker().pickImage(
          maxWidth: 400,
          maxHeight: 400,
          source: ImageSource.gallery);
      if (pickedFile != null) {
        dprint("Photo file: ${pickedFile.path}");
        _waits(true);
        var ret = await providerSetLogoImageData(await pickedFile.readAsBytes());
        _waits(false);
        if (ret != null)
          messageError(context, ret);
      }
    }
  }

  _changeUpperImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pickedFile = await ImagePicker().pickImage(
          maxWidth: 1200,
          source: ImageSource.gallery);
      if (pickedFile != null) {
        dprint("Photo file: ${pickedFile.path}");
        _waits(true);
        var ret = await providerSetUpperImageData(await pickedFile.readAsBytes());
        _waits(false);
        if (ret != null)
          messageError(context, ret);
      }
    }
  }

  _delete(ImageData item) async {
    var ret = await providerDeleteImage(item);
    if (ret != null)
      messageError(context, ret);
    ret = await saveProviderFromAdmin();
    if (ret != null)
      messageError(context, ret);
    _redraw();
  }

  _addToGallery(ImageSource source) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pickedFile = await ImagePicker().pickImage(
          maxWidth: 1200,
          source: source);
      if (pickedFile != null) {
        dprint("Photo file: ${pickedFile.path}");
        _waits(true);
        var ret = await providerAddImageToGallery(await pickedFile.readAsBytes());
        _waits(false);
        if (ret != null)
          messageError(context, ret);
      }
    }
  }

}
