import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:ondemand_admin/widgets/edit37.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import 'strings.dart';
import '../../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  late MainModel _mainModel;
  final _editControllerReview = TextEditingController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _editControllerReview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(top : 30),
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left : 30, right: 30),
          width: isMobile() ? windowWidth : windowWidth*0.4+60,
          child: Column(children: _getList()),
        ));
  }

  _getList() {
    List<Widget> list = [];

    list.add(SizedBox(height: 20,));
    list.add(BackSiteButton(text: strings.get(155))); /// Back to bookings list
    list.add(SizedBox(height: 20,));

    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(158), style: theme.style18W800,),);  /// "Rate this service",
    list.add(SizedBox(height: 20,));

    list.add(Container(
        width: windowWidth,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Card49(
          image: currentOrder.providerAvatar,
          text: getTextByLocale(currentOrder.provider, strings.locale),
          text2: strings.get(159), /// "Click on the stars to rate this service",
          text3: getTextByLocale(currentOrder.service, strings.locale),
          imageRadius: 50,
          initValue: _stars,
          callback: (int stars) { _setStar(stars); },)
    ));

    list.add(SizedBox(height: 20,));

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Edit37(
          hint: strings.get(160), /// "Tell us something about this service",
          icon: null,
          maxLines: 10,
          type: TextInputType.multiline,
          controller: _editControllerReview,
        )));
        // edit42(strings.get(86), // "Write your review",
        //   _editControllerReview,
        //   strings.get(87), // "Tell us something about this service",
        // )));

    list.add(SizedBox(height: 20,));

    // list.add(Container(
    //     color: (darkMode) ? Colors.black : Colors.white,
    //     padding: EdgeInsets.only(left: 20, right: 20),
    //     child: Row(
    //       children: [
    //         Expanded(child: Text(strings.get(90), // "Add Images",
    //           style: theme.style14W800,)),
    //         Container(
    //             width: windowWidth/2,
    //             child: Image.asset("assets/ondemands/ondemand20.png",
    //                 fit: BoxFit.contain
    //             )
    //         ),
    //       ],
    //     )));
    list.add(Row(
      children: [
        Text(strings.get(164)), /// "You can add images",
        SizedBox(width: 20,),
        button2x(strings.get(161), /// "Add image",
                (){_photo(ImageSource.gallery);})
      ],
    ));

    list.add(SizedBox(height: 20,));

    if (_images.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _images.map((e){
            return Container(
                width: 150,
                child: Image.memory(e, fit: BoxFit.contain,));
          }).toList(),
        ),
      ));

    list.add(SizedBox(height: 20,));
    list.add(Divider());
    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
      child: button2x(strings.get(163), /// "Submit Review",
          (){_confirm();},),
    ));

    list.add(SizedBox(height: 20,));

    return list;
  }

  _confirm() async {
    dprint("rating confirm _stars=$_stars; text=${_editControllerReview.text}");
    if (_editControllerReview.text.isEmpty)
      return messageError(context, strings.get(165)); /// "Please enter text",

    _mainModel.waits(true);
    var ret = await addReview(_stars, _editControllerReview.text, _images, currentOrder);
    _mainModel.waits(false);
    if (ret != null)
      return messageError(context, ret);

    _mainModel.route("jobinfo");
  }

  final List<Uint8List> _images = [];

  _photo(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
        maxWidth: 1000,
        maxHeight: 1000,
        source: source);
    if (pickedFile != null) {
      _images.add(await pickedFile.readAsBytes());
      setState(() {});
    }
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  int _stars = 5;
  _setStar(int stars){
    dprint("start $stars");
    _stars = stars;
    _redraw();
  }
}


/* site
import 'package:flutter/material.dart';
import 'package:abg_utils/abg_utils.dart';

import '../theme.dart';

class Card49 extends StatefulWidget {
  final String text;
  final String text2;
  final String text3;

  final int initValue;
  final String image;
  final double imageRadius;
  final bool shadow;
  final Color starsColor;
  final Function(int stars) callback;

  Card49({
    required this.callback,
    this.imageRadius = 0,
    this.initValue = 5,
    this.starsColor = Colors.orange,
    this.image = "",
    this.text = "",
    this.text2 = "",
    this.text3 = "",
    this.shadow = false,
  });

  @override
  _Card49State createState() => _Card49State();
}

class _Card49State extends State<Card49>{

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(color: Colors.transparent),
            boxShadow: (widget.shadow) ? [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(2, 2), // changes position of shadow
              ),
            ] : null
        ),

        child: Column(
          children: [

            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
              color: Colors.blue.withAlpha(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.text, style: theme.style16W800,),
                          SizedBox(height: 5,),
                          Text(widget.text3, style: theme.style14W400,),
                          SizedBox(height: 15,),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     widget.image,
                          //     SizedBox(width: 5,),
                          //     Text(widget.text3, style: widget.style3,),
                          //     SizedBox(width: 5,),
                          //     Container(
                          //         height: 15,
                          //         alignment: Alignment.center,
                          //         child: Container(
                          //           width: 5,
                          //           height: 5,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey,
                          //             shape: BoxShape.circle,
                          //           ),
                          //         )),
                          //     SizedBox(width: 5,),
                          //     Flexible(child: FittedBox(child: Text(text4, style: style4,))),
                          //   ],
                          // )
                        ],)),
                  SizedBox(width: 20,),
                  Container(
                    height: 60,
                    width: 60,
                    //padding: EdgeInsets.only(left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.imageRadius),
                      child: widget.image.isNotEmpty ? Image.network(widget.image, fit: BoxFit.cover)
                                   : Container(),
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),

            ),
            // Expanded(
            //     child: ClipRRect(
            //       borderRadius: new BorderRadius.only(
            //           topLeft: Radius.circular(widget.radius),
            //           topRight: Radius.circular(widget.radius)),
            //       child: Container(
            //         width: double.maxFinite,
            //         child: Image.asset(widget.image,
            //             fit: BoxFit.cover,
            //           ),
            //     ))),

            SizedBox(height: 10,),
            //Text(widget.text, style: widget.style, textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Text(widget.text2, style: theme.style14W400, textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Slider3(callback: widget.callback,
                initStars: widget.initValue,
                iconStarsColor: widget.starsColor,
                iconSize: 40),
            SizedBox(height: 20,),
          ],
        )
    );
  }
}


 */