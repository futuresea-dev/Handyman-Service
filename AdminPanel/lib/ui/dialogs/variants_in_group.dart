import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class DialogVariants extends StatefulWidget {
  final Function() close;

  const DialogVariants({Key? key, required this.close,}) : super(key: key);

  @override
  _DialogVariantsState createState() => _DialogVariantsState();
}

class _DialogVariantsState extends State<DialogVariants> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerName = TextEditingController();
  final _controllerUrl = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerStock = TextEditingController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);

    _controllerPrice.text = "+0";
    _price = "+0";

    if (variantEdit != null){
      _name = getTextByLocale(variantEdit!.name, _mainModel.langEditDataComboValue);
      _controllerName.text = _name;
      _price = "${variantEdit!.priceUnit}${variantEdit!.price}";
      _controllerPrice.text = _price;
      if (variantEdit!.image.localFile.isEmpty) {
        _url = variantEdit!.image.serverPath;
        _controllerUrl.text = _url;
      }
      _stock = variantEdit!.stock;
      _controllerStock.text = _stock.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerUrl.dispose();
    _controllerPrice.dispose();
    _controllerStock.dispose();
    super.dispose();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  String _name = "";
  String _url = "";
  String _price = "";
  int _stock = -1;
  XFile? pickedFile;
  Uint8List? _imageBytes;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    Widget _image = Container();
    if (_url.isNotEmpty)
      _image = displayImageWithCloseButton(100, 100, _url, (){}, (){
        _url = "";
        _controllerUrl.text = "";
        _redraw();
      });
    else {
      if (_imageBytes != null)
        _image = displayImageWithCloseButton(100, 100, "", (){}, (){
          _imageBytes = null;
          _redraw();
        }, type: "memory", imageBytes: _imageBytes);
      else
        if (variantEdit != null && variantEdit!.image.localFile.isNotEmpty && variantEdit!.image.serverPath.isNotEmpty) // only Firebase hosted files
          _image = displayImageWithCloseButton(100, 100, variantEdit!.image.serverPath, (){}, (){
            variantEdit!.image = ImageData.createEmpty();
            _redraw();
          });
    }

    return Container(
        width: windowWidth,
        height: windowHeight,
        child: Stack(
          children: [

            InkWell(
              onTap: widget.close,
              child:
              Container(
                width: windowWidth,
                height: windowHeight,
                color: Colors.grey.withAlpha(50),
              ),
            ),

        Center(
            child: Container(
                width: windowWidth*0.8,
                // height: windowHeight*0.6,
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(strings.get(436), style: theme.style14W800, textAlign: TextAlign.center,), /// "Variant name"
                            SizedBox(width: 10,),
                            Text("(${_mainModel.langEditDataComboValue})", style: theme.style13W800Red,)
                          ],
                        ),
                        SizedBox(height: 20,),
                        textElement2(strings.get(54), "", _controllerName, (String val){           /// Name
                          _name = val;
                          _redraw();
                        }),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button2b(strings.get(440), (){        /// "Add image (optional)",
                              _selectImageToGallery();
                            }),
                            SizedBox(width: 10,),
                            Text(strings.get(442), style: theme.style16W800,), /// or
                            SizedBox(width: 10,),
                            Expanded(child: textElement2(strings.get(441), "", _controllerUrl, (String val){           /// "Add image URL (optional)",
                              _url = val;
                              _redraw();
                            })),
                          ],
                        ),
                        SizedBox(height: 20,),
                        _image,
                        SizedBox(height: 40,),
                        Row(
                          children: [
                            Text(strings.get(443), style: theme.style14W400,), /// "influence on price +/-",
                            SizedBox(width: 10,),
                            Container(
                                width: 100,
                                child: Edit41web(controller: _controllerPrice,
                                  pricePlusMinus: true,
                                  price: true,
                                  numberOfDigits: appSettings.digitsAfterComma,
                                  onChange: (String value){
                                    _price = value;
                                    _redraw();
                                  },
                                  hint: "+20",
                                )),
                            SizedBox(width: 30,),
                            numberElement2(strings.get(446), /// In Stock
                                  "9999", strings.get(447), _controllerStock, (String val){ /// pcs
                                    _stock = toInt(val);
                                  })
                          ],
                        ),

                        SizedBox(height: 60,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button2b(variantEdit != null ? strings.get(448) : strings.get(439), () async {        /// Save variant "Add variant",
                              if (_stock == -1)
                                return messageError(context, strings.get(451)); /// "Please select stock",
                              if (!_price.startsWith("-") && !_price.startsWith("+"))
                                return messageError(context, strings.get(444)); /// "influence must start with + or -",
                              var _pr = toDouble(_price.substring(1));
                              var _znak = _price.substring(0, 1);

                              for (var item in currentArticle.group){
                                if (item.id == groupToEdit){
                                  if (_imageBytes != null){
                                    waitInMainWindow(true);
                                    var ret = await articleAddImageToVariant(_imageBytes!);
                                    waitInMainWindow(false);
                                    if (ret != null)
                                      return messageError(context, ret);
                                  }

                                  ImageData _image = ImageData.createEmpty();
                                  if (_url.isNotEmpty)
                                    _image = ImageData(serverPath: _url, localFile: "");
                                  else {
                                    if (uploadedImage != null)
                                      _image = uploadedImage!;
                                    else
                                      if (variantEdit != null)
                                        _image = variantEdit!.image;
                                  }

                                  var _new = PriceData(
                                      [StringData(code: _mainModel.langEditDataComboValue, text: _name)],
                                      _pr, 0,
                                      _znak, _image, stock: _stock);
                                  if (variantEdit != null){
                                    var _index = item.price.indexOf(variantEdit!);
                                    item.price.remove(variantEdit!);
                                    item.price.insert(_index, _new);
                                  }else
                                    item.price.add(_new);

                                  uploadedImage = null;
                                }
                              }

                              // currentArticle.group.add(GroupData(, price: []));
                              widget.close();
                            }, enable: _name.isNotEmpty && (_price.startsWith("-") || _price.startsWith("+"))),
                            SizedBox(width: 20,),
                            button2b(strings.get(184), () {  /// "Close",
                              widget.close();
                            }),
                          ],
                        )

                      ],
                    ),

            )
        )
      ],
        ));
  }



  _selectImageToGallery() async {
    try{
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      return messageError(context, e.toString());
    }
    if (pickedFile != null){
      _imageBytes = await pickedFile!.readAsBytes();
      _redraw();
    }
  }
}

