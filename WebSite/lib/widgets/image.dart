import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class ImageGallery extends StatefulWidget {
  final ImageData item;
  final List<ImageData> gallery;

  const ImageGallery({Key? key, required this.item, required this.gallery}) : super(key: key);

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {

  bool _isHoveringOnImage = false;
  double windowWidth = 0;

  void _onImageHover(bool hovering) {
    setState(() {
      _isHoveringOnImage = hovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    var _tag = UniqueKey().toString();

    return InkWell(
        onTap: (){
          openGalleryScreen(widget.gallery, widget.item);
          // _mainModel.openGallery(widget.item);
        },
        child: Hero(
            tag: _tag,
            child: MouseRegion(
                onEnter: (e) => _onImageHover(true),
                onExit: (e) => _onImageHover(false),
                child: AnimatedOpacity(
                    opacity: _isHoveringOnImage ? 0.75 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                        width: isMobile() ? windowWidth*0.3 : windowWidth*0.8/5-20,
                        height: isMobile() ? windowWidth*0.3 : windowWidth*0.8/5,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(theme.radius)),
                            child:Image.network(widget.item.serverPath, fit: BoxFit.cover)
                        )))))
    );
  }

}