import 'dart:io';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondprovider/model/model.dart';
import 'package:ondprovider/ui/start/reg_map_work_area.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class OnDemandRegisterCodeScreen extends StatefulWidget {
  @override
  _OnDemandRegisterCodeScreenState createState() => _OnDemandRegisterCodeScreenState();
}

class _OnDemandRegisterCodeScreenState extends State<OnDemandRegisterCodeScreen> {
  
  final _editControllerName = TextEditingController();
  final _editControllerEmail = TextEditingController();
  final _editControllerPassword1 = TextEditingController();
  final _editControllerPassword2 = TextEditingController();
  final _editControllerProviderName = TextEditingController();
  final _editControllerPhone = TextEditingController();
  final _editControllerDesc = TextEditingController();
  final _editControllerAddress = TextEditingController();
  var _step = 1;
  late MainModel _mainModel;
  List<String> category = [];

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context, listen: false);
    _init();
    super.initState();
  }

  _init() async {
    var ret = await loadCategory(true);
    if (ret != null)
      messageError(context, ret);
    _redraw();
  }

  @override
  void dispose() {
    _editControllerName.dispose();
    _editControllerEmail.dispose();
    _editControllerPassword1.dispose();
    _editControllerPassword2.dispose();
    _editControllerProviderName.dispose();
    _editControllerPhone.dispose();
    _editControllerDesc.dispose();
    _editControllerAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    buildContext = context;
    return Scaffold(
        backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            Container(
              color: (theme.darkMode) ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                child: Column(

                  children: [

                    ClipPath(
                        clipper: ClipPathClass23(20),
                        child: Container(
                          color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
                          width: windowWidth,
                          height: windowHeight*0.3,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20, right: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(strings.get(14), // "Register",
                                              style: theme.style25W800),
                                          SizedBox(height: 10,),
                                          Text(strings.get(15), // "in less than a minute",
                                              style: theme.style16W600Grey),
                                        ],
                                      ))),

                              Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  alignment: Alignment.bottomRight,
                                  width: windowWidth*0.3,
                                  child: Image.asset("assets/ondemand/ondemand5.png",
                                      fit: BoxFit.contain
                                  ))
                            ],


                          ),
                        )),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: _step == 1 ? Column(
                      children: [

                        SizedBox(height: 20,),

                        Text(strings.get(188), /// Please leave information for us to make it easier for us to work with you.
                            style: theme.style14W400, textAlign: TextAlign.center,),
                        SizedBox(height: 10,),
                        Divider(),
                        SizedBox(height: 10,),
                        edit42(strings.get(189), /// "Provider Name",
                          _editControllerProviderName, strings.get(190), // "Home service",
                        ),
                        SizedBox(height: 20,),
                        edit42(strings.get(65), /// "Description",
                          _editControllerDesc, "",
                        ),
                        SizedBox(height: 20,),
                        edit42(strings.get(63), /// "Address",
                          _editControllerAddress, "",
                        ),
                        SizedBox(height: 20,),

                        button2c(strings.get(193), theme.mainColor, (){ /// "Set my Work Area",
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegMapWorkAreaScreen(),
                            ),
                          );
                        }),

                        SizedBox(height: 10,),
                        Divider(),
                        SizedBox(height: 10,),

                        Text(strings.get(167), style: theme.style14W800,), /// "Categories",
                        SizedBox(height: 5,),
                        TreeInCategory(
                          stringCategoryTree: strings.get(263), /// "Category tree",
                          select: (CategoryData item) {
                            if (category.contains(item.id))
                              category.remove(item.id);
                            else
                              category.add(item.id);
                            _redraw();
                          },
                          showDelete: false,
                          useKey: false,
                          showCheckBoxes: true,
                          stringOnlySelected: strings.get(166), /// "Only selected",
                          getSelectList: (){
                            return category;
                          },
                        ),

                        SizedBox(height: 20,),
                        Divider(),

                        Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(theme.radius)),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: _mainModel.pathToImage.isNotEmpty
                                          ? Image.file(File(_mainModel.pathToImage), fit: BoxFit.cover)
                                          : Image.asset("assets/noimage.png", fit: BoxFit.cover),
                                    )
                                  ],
                                )),
                            SizedBox(height: 10,),
                            button2c(strings.get(194), theme.mainColor, _changeIcon),  /// "Set Provider Logo",
                          ],
                        ),

                        SizedBox(height: 10,),
                        Divider(),
                        SizedBox(height: 10,),

                        edit42(strings.get(192), /// "Phone",
                            _editControllerPhone, "", type: TextInputType.phone
                        ),

                        SizedBox(height: 20,),

                        //
                        //
                        //

                        edit42(strings.get(191), /// "Login",
                          _editControllerName, "",
                        ),

                        SizedBox(height: 20,),

                        edit42(strings.get(7), /// "Email",
                            _editControllerEmail,
                            strings.get(8), // "Enter Email",
                            type: TextInputType.emailAddress
                        ),

                        SizedBox(height: 20,),

                        Edit43(
                          text: strings.get(9), /// "Password",
                          controller: _editControllerPassword1,
                          hint: strings.get(10), // "Enter Password",
                        ),

                        SizedBox(height: 20,),

                        Edit43(
                          text: strings.get(18), /// "Confirm Password",
                          controller: _editControllerPassword2,
                          hint: strings.get(10), // "Enter Password",
                        ),

                        SizedBox(height: 40,),

                        button2(strings.get(11), /// "CONTINUE",
                            theme.mainColor, (){_continue();}, style: theme.style16W800White, radius: 50
                        ),

                        SizedBox(height: 20,),

                      ],
                    ) : step2Widget())

                  ],
                ) ,
              ),
            ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {Navigator.pop(context);}),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),

          ],
        )

    ));
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

  _continue() async {

    if (_editControllerProviderName.text.isEmpty)
      return messageError(context, strings.get(195)); /// "Please Enter Provider Name",
    if (_editControllerPhone.text.isEmpty)
      return messageError(context, strings.get(187)); /// "Please Enter Phone",
    if (_editControllerDesc.text.isEmpty)
      return messageError(context, strings.get(196)); /// "Please Enter description",
    if (_editControllerAddress.text.isEmpty)
      return messageError(context, strings.get(197)); /// "Please Enter address",
    if (_mainModel.pathToImage.isEmpty)
      return messageError(context, strings.get(198)); /// "Please upload Provider Logo",
    if (_mainModel.routeForNewProvider.isEmpty)
      return messageError(context, strings.get(199)); /// "Please select work area",
    if (category.isEmpty)
      return messageError(context, strings.get(200)); /// "Please select Category where you will work",
    if (_editControllerName.text.isEmpty)
      return messageError(context, strings.get(201)); /// "Please Enter Login",
    if (_editControllerEmail.text.isEmpty)
      return messageError(context, strings.get(93)); /// "Please Enter Email",
    if (_editControllerPassword1.text.isEmpty || _editControllerPassword2.text.isEmpty)
      return messageError(context, strings.get(94)); /// "Please enter password",
    if (_editControllerPassword1.text != _editControllerPassword2.text)
      return messageError(context, strings.get(97)); /// "Passwords are not equal",
    if (!validateEmail(_editControllerEmail.text))
      return messageError(context, strings.get(98)); /// "Email are wrong",

    _waits(true);
    var ret = await registerProvider(_editControllerEmail.text,
        _editControllerPassword1.text, _editControllerName.text,
        _editControllerProviderName.text, _editControllerPhone.text, _editControllerDesc.text,
        _editControllerAddress.text, category, _mainModel.pathToImage, _mainModel.routeForNewProvider);
    _waits(false);
    if (ret != null)
      return messageError(context, ret);

    _step = 2;
    _redraw();
  }

  step2Widget(){
    return Column(
      children: [
        SizedBox(height: 40,),
        Text(strings.get(100), style: theme.style14W800, textAlign: TextAlign.center,) /// You account created. After moderation your account...
      ],
    );
  }

  _changeIcon() async {
    final pickedFile = await ImagePicker().pickImage(
        maxWidth: 400,
        maxHeight: 400,
        source: ImageSource.gallery);
    if (pickedFile != null) {
      dprint("Photo file: ${pickedFile.path}");
      _mainModel.pathToImage = pickedFile.path;
      _redraw();
    }
  }

}


