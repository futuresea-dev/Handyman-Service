import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'package:provider/provider.dart';
import '../ui/strings.dart';
import '../theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderItem extends StatefulWidget {
  final double width;
  final ProviderData item;

  const ProviderItem({Key? key, required this.width, required this.item}) : super(key: key);

  @override
  _ProviderItemState createState() => _ProviderItemState();
}

class _ProviderItemState extends State<ProviderItem> {

  late MainModel _mainModel;
  bool _isHoveringOnImage = false;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  void _onImageHover(bool hovering) {
    setState(() {
      _isHoveringOnImage = hovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    var text3 = getCategoryNames(widget.item.category);
    User? user = FirebaseAuth.instance.currentUser;

    return MouseRegion(
      onEnter: (e) => _onImageHover(true),
      onExit: (e) => _onImageHover(false),
      child: AnimatedOpacity(
        opacity: _isHoveringOnImage ? 0.75 : 1.0,
        duration: Duration(milliseconds: 300),
        child: InkWell(
          onTap: (){
            _mainModel.currentProvider = widget.item;
            _mainModel.route("provider");
          },
          child: Container(
           color: (theme.darkMode) ? Colors.black : Colors.white,
            padding: EdgeInsets.all(10),
            child: Container(
              width: widget.width,
              height: widget.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(theme.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container(
                    width: widget.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(theme.radius), topRight: Radius.circular(theme.radius)),
                      child: Stack(
                        children: [
                          widget.item.imageUpperServerPath.isNotEmpty
                              ? Image.network(widget.item.imageUpperServerPath, fit: BoxFit.cover,)
                              : Image.asset("assets/noimage.jpg"),
                          if (user != null)
                            Container(
                              margin: EdgeInsets.all(6),
                              alignment: strings.direction == TextDirection.ltr
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: IconButton(
                                icon: userAccountData.userFavoritesProviders.contains(widget.item.id)
                                    ? Icon(Icons.favorite, size: 25,)
                                    : Icon(Icons.favorite_border, size: 25,),
                                color: Colors.orange,
                                onPressed: () {
                                  changeFavoritesProviders(widget.item);
                                  redrawMainWindow();
                                },),
                            )
                        ],
                      )
                    ),
                  )),

                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(getTextByLocale(widget.item.name, strings.locale), style: theme.style14W800,),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text(text3, style: theme.style12W600Grey, maxLines: 2,),
                  ),
                  SizedBox(height: 10,),

                ],
              )
            )
        )))
    );
  }

}