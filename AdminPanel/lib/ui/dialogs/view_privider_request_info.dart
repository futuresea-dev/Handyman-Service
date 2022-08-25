import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../../utils.dart';
import '../strings.dart';
import '../theme.dart';
import 'map_provider_request.dart';

class DialogViewProviderRequestInfo extends StatefulWidget {
  final Function() close;
  final Function() openProvidersScreen;
  const DialogViewProviderRequestInfo({Key? key, required this.close,
    required this.openProvidersScreen,}) : super(key: key);


  @override
  _DialogViewProviderRequestInfoState createState() => _DialogViewProviderRequestInfoState();
}

class _DialogViewProviderRequestInfoState extends State<DialogViewProviderRequestInfo> {

  double windowWidth = 0;
  double windowHeight = 0;
  final _controllerName = TextEditingController();
  final _controllerPrice = TextEditingController();
  final ScrollController _controllerScroll = ScrollController();
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerScroll.dispose();
    _controllerName.dispose();
    _controllerPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    String _cat = "";
    for (var item in _mainModel.currentProviderRequest.providerCategory){
      if (_cat.isNotEmpty)
        _cat = "$_cat\n";
      _cat += getCategoryNameById(item);
    }
    print("_mainModel.currentProviderRequest.id " + _mainModel.currentProviderRequest.id);
    print("providerLogoServerPath " + _mainModel.currentProviderRequest.providerLogoServerPath);
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
                height: windowHeight*0.6,
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [

                    // Container(
                    //   margin: EdgeInsets.only(top: 130, bottom: 50),
                    //   color: Colors.grey.withAlpha(20),
                    //   child: ScrollConfiguration(
                    //     behavior: MyCustomScrollBehavior(),
                    //     child: Scrollbar(
                    //       isAlwaysShown: true,
                    //       controller: _controllerScroll,
                    //       child: ListView(
                    //         controller: _controllerScroll,
                    //         children: _list(),
                    //   )),
                    // )),

                    ListView(
                      children: [
                        Text(strings.get(407), style: theme.style14W800, textAlign: TextAlign.center,), /// "New Provider information"
                        SizedBox(height: 10,),
                        Divider(thickness: 0.5,),
                        SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(_mainModel.currentProviderRequest.providerLogoServerPath, fit: BoxFit.contain,),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Text(strings.get(408), style: theme.style12W800,), /// "Provider Name",
                                    SizedBox(width: 10,),
                                    Expanded(child: Text(_mainModel.currentProviderRequest.providerName,
                                      style: theme.style14W400, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text(strings.get(97), style: theme.style12W800,), /// "Address",
                                    SizedBox(width: 10,),
                                    Expanded(child: Text(_mainModel.currentProviderRequest.providerAddress,
                                      style: theme.style14W400, maxLines: 4, overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text(strings.get(73), style: theme.style12W800,), /// "Description",
                                    SizedBox(width: 10,),
                                    Expanded(child: Text(_mainModel.currentProviderRequest.providerDesc,
                                      style: theme.style14W400, maxLines: 5, overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text(strings.get(158), style: theme.style12W800,), /// "Category",
                                    SizedBox(width: 10,),
                                    Expanded(child: Text(_cat,
                                      style: theme.style14W400, maxLines: 10, overflow: TextOverflow.ellipsis,)),
                                  ],
                                )
                              ],
                            )),
                            Expanded(child: Container(
                              height: windowHeight*0.4,
                              child: Column(
                                children: [
                                  Text(strings.get(409), style: theme.style12W400), /// Work Area
                                  SizedBox(height: 10,),
                                  Container(
                                    height: windowHeight*0.4-30,
                                    child: MapProviderRequest(),
                                  )
                                ],
                              ),
                            ),),
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),

                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                              button2b(strings.get(247), (){        /// "Assign",
                                widget.close();
                                _mainModel.provider.createNewProvider(_mainModel.currentProviderRequest);
                                widget.openProvidersScreen();
                              }, color: theme.mainColor.withAlpha(150)),
                              SizedBox(width: 20,),
                              button2b(strings.get(62), (){_openDialogDelete(_mainModel.currentProviderRequest);},
                                  color: dashboardErrorColor.withAlpha(150)), /// "Delete",
                              SizedBox(width: 20,),
                              button2b(strings.get(184), () {  /// "Close",
                                widget.close();
                              }),
                        ],
                      )
                    )

                  ],
                )

            )
        )
      ],
        ));
  }

  _openDialogDelete(UserData value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      // demo mode
      if (appSettings.demo)
        return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
      var ret = await _mainModel.provider.deleteRequest(value);
      if (ret == null)
        messageOk(context, strings.get(69)); // "Data deleted",
      else
        messageError(context, ret);
      setState(() {});
      widget.close();
    }, context);
  }
}

