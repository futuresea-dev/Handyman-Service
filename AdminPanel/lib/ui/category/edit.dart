import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:ondemand_admin/ui/dialogs/dialogs.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class EditInCategory extends StatefulWidget {
  final GlobalKey keyM;

  const EditInCategory({Key? key, required this.keyM}) : super(key: key);
  @override
  _EditInCategoryState createState() => _EditInCategoryState();
}

class _EditInCategoryState extends State<EditInCategory> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerName = TextEditingController();
  final _controllerDesc = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _mainModel.initEditorInCategoryScreen = _init;
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    List<Widget> list = [];

    // language
    list.add(Container(key: widget.keyM));
    list.add(Row(
      children: [
        Text(strings.get(108), style: theme.style14W400,), /// "Select language",
        Expanded(child: Container(
            width: 120,
            child: Combo(inRow: true, text: "",
              data: _mainModel.langDataCombo,
              value: _mainModel.langEditDataComboValue,
              onChange: (String value){
                _mainModel.langEditDataComboValue = value;
                redrawMainWindow();
              },))),
      ],
    ));
    list.add(SizedBox(height: 10,));
    //
    // visible
    //
    list.add(Row(
      children: [
        Expanded(child: checkBox1a(context, strings.get(70), // "Visible",
            theme.mainColor, theme.style14W400, currentCategory.visible,
                (val) {
              if (val == null) return;
              currentCategory.visible = val;
              redrawMainWindow();
            })),
        SizedBox(width: 10,),
        Expanded(flex: 3, child: Combo(inRow: true, text: strings.get(74), /// "Select parent category",
          data: _mainModel.category.parentsData,
          value: currentCategory.parent,
          onChange: (String value){
            currentCategory.parent = value;
            redrawMainWindow();
          },))
        // Expanded(child: checkBox1a(context, strings.get(71), // "Show Category Details in Main Screen",
        //     theme.mainColor, theme.style14W400, currentCategory.visibleCategoryDetails,
        //         (val) {
        //       if (val == null) return;
        //       currentCategory.visibleCategoryDetails = val;
        //       redrawMainWindow();
        //     }))
      ],
    ));
    //
    list.add(SizedBox(height: 10,));
    //
    // name
    //
    list.add(textElement2(strings.get(54), "", _controllerName, (String val){
      categorySetName(val, _mainModel.langEditDataComboValue);
      redrawMainWindow();
    })); // "Name",
    list.add(SizedBox(height: 10,));
    //
    // color & description
    //
    _setColor(Color color) {
      currentCategory.color = color;
      redrawMainWindow();
    }
    if (isMobile()){
      list.add(Row(
          children: [
          SelectableText(strings.get(72), style: theme.style14W400,), /// "Select color",
          SizedBox(width: 10,),
          Container(
          width: 150,
          child: ElementSelectColor(getColor: (){return currentCategory.color;}, setColor: _setColor,),
        ),])
      );
      list.add(SizedBox(height: 10));
      list.add(textElement2(strings.get(73), "", _controllerDesc, (String val){ // Description
        categorySetDesc(val, _mainModel.langEditDataComboValue);
        redrawMainWindow();
      }));
    }else
      list.add(Row(
        children: [
          SelectableText(strings.get(72), style: theme.style14W400,), // "Select color",
          SizedBox(width: 10,),
          Container(
            width: 150,
            child: ElementSelectColor(getColor: (){return currentCategory.color;}, setColor: _setColor,),
          ),
          SizedBox(width: 10,),
          Expanded(child:textElement2(strings.get(73), "", _controllerDesc, (String val){ // Description
            categorySetDesc(val, _mainModel.langEditDataComboValue);
            redrawMainWindow();
          }))
        ],
      ));
    //
    // image
    //
    Widget addImage = button2b(strings.get(430), (){        /// "Add image URL",
      _mainModel.addImageType = "category_image";
      showDialogAddVImageUrl();
    });
    list.add(SizedBox(height: 10,));
    if (isMobile()){
      list.add(addImage);
      list.add(SizedBox(height: 20,));
      list.add(button2b(strings.get(75), _selectImage)); /// "Select image",
    }else
      list.add(Row(
        children: [
          addImage,
          SizedBox(width: 20,),
          button2b(strings.get(75), _selectImage) /// "Select image",
        ],
      ));
    list.add(SizedBox(height: 10,));
    list.add(Text(strings.get(231), style: theme.style14W800,)); /// "Current image",
    list.add(SizedBox(height: 10,));
    list.add(SelectableText(currentCategory.serverPath, style: theme.style14W400,),);

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));
    //
    // save
    //
    list.add(SizedBox(height: 20,));
    if (currentCategory.id.isEmpty)
      list.add(button2b(strings.get(77), () async {        /// "Create new category",
        var ret = await categoryCreate();
        _mainModel.category.parentListMake();
        if (ret == null)
          messageOk(context, strings.get(81)); /// "Data saved",
        else
          messageError(context, ret);
        redrawMainWindow();
      }));
    else
      list.add(Row(
        children: [
          Expanded(child: button2b(strings.get(76), () async {
            var ret = await categorySave();
            _mainModel.category.parentListMake();
            if (ret == null)
              messageOk(context, strings.get(81)); /// "Data saved",
            else
              messageError(context, ret);
            redrawMainWindow();
          })), /// "Save current category",
          button2b(strings.get(57), (){                 /// "Add New Category",
            currentCategory = CategoryData.createEmpty();
            if (_mainModel.initEditorInCategoryScreen != null)
              _mainModel.initEditorInCategoryScreen!();
            redrawMainWindow();
          })
        ],
      ));

    return Stack(
      children: [
        Container(
            width: (windowWidth/2 < 600) ? 600 : windowWidth/2,
            decoration: BoxDecoration(
              color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: Stack(
            children: [
              Positioned.fill(child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: (_select) ? Colors.grey.withAlpha(100) : Colors.transparent,
                    borderRadius: BorderRadius.circular(theme.radius),
                  ),
                  duration: Duration(seconds: 1))),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                children: list,
              )),
            ],
            )
        ),
        if (_wait)
          Positioned.fill(
            child: Center(child: Container(child: Loader7(color: theme.mainColor,)))),
      ],
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

  _selectImage() async {
    XFile? pickedFile;
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null){
      _waits(true);
      var ret = await categorySetImage(await pickedFile.readAsBytes());
      if (ret == null)
        messageOk(context, strings.get(363)); /// "Image saved",
      else
        messageError(context, ret);
      _waits(false);
      redrawMainWindow();
    }
  }

  bool _select = false;

  _init(){
    _select = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      _select = false;
      _redraw();
    });
    //
    bool _found = false;
    for (var item in _mainModel.category.parentsData)
      if (item.id == currentCategory.parent)
        _found = true;
    if (!_found)
      currentCategory.parent = "";

    _controllerName.text = _mainModel.getTextByLocale(currentCategory.name);
    textFieldToEnd(_controllerName);
    _controllerDesc.text = _mainModel.getTextByLocale(currentCategory.desc);
    textFieldToEnd(_controllerDesc);
  }
}