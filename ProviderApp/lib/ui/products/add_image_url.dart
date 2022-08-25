import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../theme.dart';

class DialogAddImageUrl extends StatefulWidget {
  const DialogAddImageUrl({Key? key, }) : super(key: key);

  @override
  _DialogAddImageUrlState createState() => _DialogAddImageUrlState();
}

class _DialogAddImageUrlState extends State<DialogAddImageUrl> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerName = TextEditingController();
  final _controllerPrice = TextEditingController();
  final ScrollController _controllerScroll = ScrollController();

  @override
  void initState() {
    //editAddon = null;
    super.initState();
  }

  @override
  void dispose() {
    //editAddon = null;
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

    return Scaffold(
        backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
    body: Directionality(
    textDirection: strings.direction,
    child: Container(
        width: windowWidth,
        height: windowHeight,
        child: Stack(
          children: [

           Container(
             margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                padding: EdgeInsets.all(20),
                child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(strings.get(230), style: theme.style14W800, textAlign: TextAlign.center,), /// "Add Image Url"
                        SizedBox(height: 40,),
                        textElement2(strings.get(246), "", null, (String val){           /// URL
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
                            button2b(strings.get(247), (){        /// "Add image",
                              // if (_mainModel.addImageType == "article_gallery"){
                                currentArticle.gallery.add(ImageData(serverPath: _url, localFile: ""));
                                redrawMainWindow();
                              // }
                                Navigator.pop(context);
                            }, ),
                            SizedBox(width: 20,),
                            button2b(strings.get(257), () {  /// "Close",
                              Navigator.pop(context);
                            }),
                          ],
                        ),
                      ],
                    ),
        ),

            appbar1(Colors.transparent, (theme.darkMode) ? Colors.white : Colors.black,
                "", context, () {Navigator.pop(context);}),
      ],
    ))));
  }
}

