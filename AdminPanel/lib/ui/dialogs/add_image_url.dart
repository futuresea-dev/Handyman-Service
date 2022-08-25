import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class DialogAddImageUrl extends StatefulWidget {
  final Function() close;

  const DialogAddImageUrl({Key? key, required this.close,}) : super(key: key);

  @override
  _DialogAddImageUrlState createState() => _DialogAddImageUrlState();
}

class _DialogAddImageUrlState extends State<DialogAddImageUrl> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerName = TextEditingController();
  final _controllerPrice = TextEditingController();
  final ScrollController _controllerScroll = ScrollController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    // _mainModel.service.editAddon = null;
    super.initState();
  }

  @override
  void dispose() {
    // _mainModel.service.editAddon = null;
    _controllerScroll.dispose();
    _controllerName.dispose();
    _controllerPrice.dispose();
    super.dispose();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  String _url = "";

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

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
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(strings.get(430), style: theme.style14W800, textAlign: TextAlign.center,), /// "Add Image Url"
                        SizedBox(height: 40,),
                        textElement2(strings.get(431), "", null, (String val){           /// URL
                          _url = val;
                          _redraw();
                        }),
                        SizedBox(height: 30,),
                        Container(
                          width: 100,
                          height: 100,
                          child: Image.network(_url,
                            errorBuilder: (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                              ){
                            return Container(child: Image.asset("assets/noimage.png"));
                          }),
                        ),

                        SizedBox(height: 60,),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button2b(strings.get(432), (){        /// "Add image",
                              if (_mainModel.addImageType == "article_gallery"){
                                currentArticle.gallery.add(ImageData(serverPath: _url, localFile: ""));
                                redrawMainWindow();
                              }
                              if (_mainModel.addImageType == "category_image"){
                                currentCategory.serverPath = _url;
                                currentCategory.localFile = "";
                                redrawMainWindow();
                              }
                              if (_mainModel.addImageType == "provider_upper_image"){
                                currentProvider.imageUpperServerPath = _url;
                                currentProvider.imageUpperLocalFile = "";
                                redrawMainWindow();
                              }
                              if (_mainModel.addImageType == "provider_logo_image"){
                                currentProvider.logoServerPath = _url;
                                currentProvider.logoLocalFile = "";
                                redrawMainWindow();
                              }
                              widget.close();
                            }, ),
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
}

