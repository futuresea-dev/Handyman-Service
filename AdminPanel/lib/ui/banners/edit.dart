import 'package:abg_utils/abg_utils.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class EditInBanner extends StatefulWidget {
  @override
  _EditInBannerState createState() => _EditInBannerState();
}

class _EditInBannerState extends State<EditInBanner> {

  final ScrollController _controllerTree = ScrollController();
  final _controllerName = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerTree.dispose();
    _controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listener();

    List<Widget> list = [];
    //
    // visible
    //
    list.add(Row(
      children: [
        Expanded(child: checkBox1a(context, strings.get(70), // "Visible",
            theme.mainColor, theme.style14W400, _mainModel.banner.current.visible,
                (val) {
              if (val == null) return;
              _mainModel.banner.setVisible(val);
              _noReceive = true;
            })),
      ],
    ));
    //
    list.add(SizedBox(height: 10,));
    //
    // name
    // image
    //
    list.add(Row(
      children: [
        Expanded(child: textElement2(strings.get(54), "", _controllerName, (String val){  /// "Name",
          _mainModel.banner.setName(val);
          _noReceive = true;
        })),
        SizedBox(width: 10,),
        button2b(strings.get(75), _selectImage) /// "Select image",
      ],
    ));
    list.add(SizedBox(height: 10,));
    if (_mainModel.banner.current.serverImage.isNotEmpty)
      list.add(Container(
        height: 100,
        width: 100,
        child: Image.network(_mainModel.banner.current.serverImage)));

    list.add(SizedBox(height: 10,));
    //
    // Banner type
    //
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: Combo(inRow: true, text: strings.get(329), /// "Banner type",
          data: _mainModel.banner.bannerTypeData,
          value: _mainModel.banner.current.type,
          onChange: (String value){
            _mainModel.banner.setType(value);
            _noReceive = true;
            _redraw();
          },)),
      ],
    ));
    list.add(SizedBox(height: 10,));
    list.add(childTree());
    //
    // save
    //
    list.add(SizedBox(height: 20,));
    if (_mainModel.banner.current.id.isEmpty)
      list.add(button2b(strings.get(333), () async {        /// "Create new banner",
        var ret = await _mainModel.banner.create();
        if (ret == null)
          messageOk(context, strings.get(81)); /// "Data saved",
        else
          messageError(context, ret);
      }));
    else
      list.add(Row(
        children: [
          Expanded(child: button2b(strings.get(334), () async { /// "Save current banner",
            var ret = await _mainModel.banner.save();
            if (ret == null)
              messageOk(context, strings.get(81)); /// "Data saved",
            else
              messageError(context, ret);
          })),
          button2b(strings.get(335), (){                 /// "Add New banner",
            _mainModel.banner.emptyCurrent();
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
      var ret = await _mainModel.banner.setImageData(await pickedFile.readAsBytes());
      if (ret == null)
        messageOk(context, strings.get(363)); /// "Image saved",
      else
        messageError(context, ret);
      _waits(false);
    }
  }

  _listener(){
    var selectInEmulator = context.watch<MainModel>().banner.current;

    if (_noReceive){
      _noReceive = false;
      return;
    }
    _nowEdit(selectInEmulator);
    if (_initListen){
      _initListen = false;
      return;
    }
    _select = true;
    _initListen = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      _select = false;
      setState(() {
      });
    });

  }

  bool _initListen = false;
  bool _select = false;
  bool _noReceive = false;

  _nowEdit(BannerData data){
    _controllerName.text = data.name;
    textFieldToEnd(_controllerName);
  }

  childTree(){
    return Container(
        decoration: BoxDecoration(
          color: (theme.darkMode) ? dashboardColorCardDark : dashboardColorCardGrey,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        width: (windowWidth/2 < 600) ? 600 : windowWidth/2,
        height: windowHeight*0.4,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Scrollbar(
          controller: _controllerTree,
          isAlwaysShown: true,
          child: ListView(
            controller: _controllerTree,
            children: getChildSelectWindow(),
          ),
        )
    );
  }

  getChildSelectWindow(){
    if (_mainModel.banner.current.type == "service")
      return _service();
    if (_mainModel.banner.current.type == "provider")
      return _provider();
    if (_mainModel.banner.current.type == "category")
      return _category();
  }

  bool _onlySelected = false;

  _service(){
    List<Widget> list2 = [];

    list2.add(SizedBox(height: 10,));
    list2.add(checkBox1a(context, strings.get(168), /// "Only selected"
        theme.mainColor, theme.style14W400, _onlySelected,
            (val) {
          if (val == null) return;
          _onlySelected = val;
          _redraw();
        }));
    list2.add(SizedBox(height: 10,));

    for (var item in product){
      if (_onlySelected && _mainModel.banner.current.open != item.id)
        continue;
      Widget _image = (item.gallery.isNotEmpty) ? (item.gallery[0].serverPath.isNotEmpty) ?
      Image.network(item.gallery[0].serverPath, fit: BoxFit.contain) : Container() : Container();
      list2.add(Stack(
        children: [
          Container(
              key: item.dataKey,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 0, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: (_mainModel.banner.current.open == item.id)
                    ? theme.mainColor.withAlpha(120) : (theme.darkMode) ? Colors.black : dashboardColorCardGreenGrey,
                borderRadius: BorderRadius.circular(theme.radius),
              ),
              child: Row(children: [
                Container(
                    width: 40,
                    height: 40,
                    child: _image),
                SizedBox(width: 20,),
                Expanded(child: Text(_mainModel.getTextByLocale(item.name), style: theme.style14W400,)),
              ],)),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: (){
                    _mainModel.banner.current.open = item.id;
                    _noReceive = true;
                    _redraw();
                  },
                )),
          ),
          Positioned.fill(
              child: Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.centerRight,
                  child: checkBox0(theme.mainColor, _mainModel.banner.current.open == item.id, (val) {
                    _mainModel.banner.current.open = item.id;
                    _noReceive = true;
                    _redraw();
                  })
              )
          )
        ],
      )
      );
      //getListTree(list2, item.id, align+30);
    }
    return list2;
  }

  _provider(){
    List<Widget> list2 = [];

    list2.add(SizedBox(height: 10,));
    list2.add(checkBox1a(context, strings.get(168), /// "Only selected"
        theme.mainColor, theme.style14W400, _onlySelected,
            (val) {
          if (val == null) return;
          _onlySelected = val;
          _redraw();
        }));
    list2.add(SizedBox(height: 10,));

    for (var item in providers){
      if (_onlySelected && _mainModel.banner.current.open != item.id)
        continue;
      Widget _image = item.gallery.isNotEmpty ? (item.gallery[0].serverPath.isNotEmpty) ?
      Image.network(item.gallery[0].serverPath, fit: BoxFit.contain) : Container() : Container();
      list2.add(Stack(
        children: [
          Container(
              key: item.dataKey,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 0, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: (_mainModel.banner.current.open == item.id)
                    ? theme.mainColor.withAlpha(120) : (theme.darkMode) ? Colors.black : dashboardColorCardGreenGrey,
                borderRadius: BorderRadius.circular(theme.radius),
              ),
              child: Row(children: [
                Container(
                    width: 40,
                    height: 40,
                    child: _image),
                SizedBox(width: 20,),
                Expanded(child: Text(_mainModel.getTextByLocale(item.name), style: theme.style14W400,)),
              ],)),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: (){
                    _mainModel.banner.current.open = item.id;
                    _noReceive = true;
                    _redraw();
                  },
                )),
          ),
          Positioned.fill(
              child: Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.centerRight,
                  child: checkBox0(theme.mainColor, _mainModel.banner.current.open == item.id, (val) {
                    _mainModel.banner.current.open = item.id;
                    _noReceive = true;
                    _redraw();
                  })
              )
          )
        ],
      )
      );
    }
    return list2;
  }

  _category(){
    List<Widget> list2 = [];

    list2.add(SizedBox(height: 10,));
    list2.add(checkBox1a(context, strings.get(168), /// "Only selected"
        theme.mainColor, theme.style14W400, _onlySelected,
            (val) {
          if (val == null) return;
          _onlySelected = val;
          _redraw();
        }));
    list2.add(SizedBox(height: 10,));

    getListTree(list2, "", 0,);
    return list2;
  }

  getListTree(List<Widget> list2, String parent, double align){
    for (var item in categories){
      if (item.parent == parent) {
        if (_onlySelected && _mainModel.banner.current.open != item.id) {
          getListTree(list2, item.id, align+30);
          continue;
        }
        Widget _image = (item.serverPath.isNotEmpty) ? Image.network(item.serverPath, fit: BoxFit.contain) : Container();
        list2.add(Stack(
          children: [
            Container(
                key: item.dataKey2,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: align, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: (_mainModel.banner.current.open == item.id)
                      ? theme.mainColor.withAlpha(120) : (theme.darkMode) ? Colors.black : dashboardColorCardGreenGrey,
                  borderRadius: BorderRadius.circular(theme.radius),
                ),
                child: Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      child: _image),
                  SizedBox(width: 20,),
                  Expanded(child: Text(_mainModel.getTextByLocale(item.name), style: theme.style14W400,)),
                ],)),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      _mainModel.banner.current.open = item.id;
                      _noReceive = true;
                      _redraw();
                    },
                  )),
            ),
            Positioned.fill(
                child: Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    alignment: Alignment.centerRight,
                    child: checkBox0(theme.mainColor, _mainModel.banner.current.open == item.id, (val) {
                      _mainModel.banner.current.open = item.id;
                      _noReceive = true;
                      _redraw();
                    })
                )
            )
          ],
        )
        );
        getListTree(list2, item.id, align+30);
      }
    }
  }
}