import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/appService/screens/strings.dart';
import 'theme.dart';

class AddAddressScreen extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const AddAddressScreen({Key? key, required this.windowWidth, required this.windowHeight}) : super(key: key);
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  // GoogleMapController? _controller;
  //double _currentZoom = 12;
  // CameraPosition _kGooglePlex = CameraPosition(target: LatLng(0, 0), zoom: 12,);
  final _controllerSearch = TextEditingController();
  // var _controllerScroll = ScrollController();
  final _editControllerDesc = TextEditingController();
  final _editControllerAddress = TextEditingController();

  @override
  void initState() {
    // places =  GoogleMapsPlaces(apiKey: Provider.of<MainModel>(context,listen:false).localAppSettings.googleMapApiKey);
    // _kGooglePlex = CameraPosition(target: LatLng(
    //     localSettings.mapLat != 0 ? localSettings.mapLat: 48.846575206328446,
    //     localSettings.mapLng != 0 ? localSettings.mapLng: 2.302420789679285),
    //     zoom: localSettings.mapZoom,); // paris coordinates by default
    super.initState();
  }

  @override
  void dispose() {
    // _controllerScroll.dispose();
    _controllerSearch.dispose();
    _editControllerDesc.dispose();
    _editControllerAddress.dispose();
    // if (_controller != null)
    //   _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = widget.windowWidth;
    windowHeight = widget.windowHeight;
    return Scaffold(
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            _map(),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //_buttonMyLocation(_getCurrentLocation),
                    ],
                  )
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10+MediaQuery.of(context).padding.top+40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                Edit26(
                  hint: strings.get(122), /// "Search",
                  color: (darkMode) ? Colors.black : Colors.white,
                  decor: decor,
                  style: theme.style14W400,
                  suffixIcon: Icons.cancel,
                  useAlpha: false,
                  icon: Icons.search,
                  onChangeText: _onPressSearch,
                  controller: _controllerSearch,
                  onSuffixIconPress: (){
                    // _controllerSearch.text = "";
                    // _searchResult = [];
                    // setState(() {
                    // });
                  }
                ),
                // if (_searchResult.isNotEmpty && _isShow)
                //   Container(
                //     margin: EdgeInsets.only(top: 1),
                //     height: 200,
                //     width: windowWidth,
                //     //color: colorBackgroundDialog,
                //     child: Scrollbar(
                //       isAlwaysShown: true,
                //       controller: _controllerScroll,
                //       child: ListView(
                //         controller: _controllerScroll,
                //         addAutomaticKeepAlives: false,
                //         padding: EdgeInsets.only(top: 0),
                //         children: _searchResult,
                //     )),
                //   )
              ],),
            ),

            Container(
              alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(10),
                    color: (darkMode) ? Colors.black : Colors.white,
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // edit42(strings.get(29), // "Description",
                      //     theme.style14W600Grey, _editControllerDesc,
                      //     strings.get(118), // "My Home",
                      //     theme.style16W400, Colors.grey),
                      SizedBox(height: 10),
                      edit42(strings.get(119), // "Full address",
                          _editControllerAddress,
                          strings.get(120), // "Select address"
                          ),
                      SizedBox(height: 20),
                      Container(
                        width: windowWidth,
                        child: button2(strings.get(121), /// "Pick here",
                            serviceApp.mainColor, (){
                          // if (_editControllerAddress.text.isEmpty)
                          //   return messageError(context, strings.get(133)); /// "Please enter address"
                          // localSettings.addAddress(_editControllerAddress.text);
                          // localSettings.setCurrentAddress(_editControllerAddress.text);
                          // widget.redraw();
                          // Navigator.pop(context);
                        }),
                      ),
                    ]))),

            appbar1((darkMode) ? Colors.black : Colors.white,
                (darkMode) ? Colors.white : Colors.black, strings.get(117), // "Add Address"
                context, () {}, style: theme.style14W800)
          ],
        )
    ));
  }

  _map(){
    return Container();
    // GoogleMap(
    //     mapType: MapType.normal,
    //     zoomGesturesEnabled: true,
    //     zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
    //     myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
    //     myLocationButtonEnabled: true, // This button is used to bring the user location to the center of the camera view.
    //     initialCameraPosition: _kGooglePlex,
    //     markers: Set<Marker>.from(markers),
    //     onCameraMove:(CameraPosition cameraPosition){
    //       localSettings.setMap(cameraPosition.target.latitude, cameraPosition.target.longitude, cameraPosition.zoom);
    //       _currentZoom = cameraPosition.zoom;
    //     },
    //     onLongPress: (LatLng pos) {
    //
    //     },
    //     onTap: (LatLng pos) {
    //       _isShow = false;
    //       _selectPos(pos);
    //       _onMapTap(pos);
    //     },
    //     onMapCreated: (GoogleMapController controller) {
    //        _controller = controller;
    //
    //     });
  }
  // String _textAddress = "";

  // _onMapTap(LatLng pos) async {
  //   PlacesSearchResponse response = await places.searchNearbyWithRadius(new Location(lat: pos.latitude, lng: pos.longitude), 20);
  //   _textAddress = "";
  //   if (response.results.isNotEmpty) {
  //     for (var item in response.results)
  //       if (item.vicinity != null)
  //         if (item.vicinity!.length > _textAddress.length)
  //           _textAddress = item.vicinity!;
  //   }
  //   if (_textAddress.isNotEmpty)
  //     _editControllerAddress.text = _textAddress;
  //   setState(() {
  //   });
  // }
  //
  // Set<Marker> markers = {};

  // _selectPos(LatLng pos){
  //   markers.clear();
  //   //_currentPos = pos;
  //   var _lastMarkerId = MarkerId("addr${pos.latitude}");
  //   final marker = Marker(
  //       markerId: _lastMarkerId,
  //       position: LatLng(pos.latitude, pos.longitude),
  //       onTap: () {
  //
  //       }
  //   );
  //   markers.add(marker);
  //   setState(() {
  //   });
  // }

  // Future<Position> getCurrent() async {
  //   var _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
  //       .timeout(Duration(seconds: 10));
  //   print("MyLocation::_currentPosition $_currentPosition");
  //   return _currentPosition;
  // }
  //
  // _getCurrentLocation() async {
  //   var permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied)
  //       return;
  //   }
  //   var position = await getCurrent();
  //   _controller!.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(position.latitude, position.longitude),
  //         zoom: _currentZoom,
  //       ),
  //     ),
  //   );
  // }

  // _buttonMyLocation(Function _getCurrentLocation){
  //   return Stack(
  //     children: <Widget>[
  //       Container(
  //         height: 60,
  //         width: 60,
  //         child: IBoxCircle(child: Icon(Icons.my_location, size: 30, color: Colors.black.withOpacity(0.5),)),
  //       ),
  //       Container(
  //         height: 60,
  //         width: 60,
  //         child: Material(
  //             color: Colors.transparent,
  //             shape: CircleBorder(),
  //             clipBehavior: Clip.hardEdge,
  //             child: InkWell(
  //               splashColor: Colors.grey[400],
  //               onTap: (){
  //                 _getCurrentLocation();
  //               }, // needed
  //             )),
  //       )
  //     ],
  //   );
  // }

  // bool _isShow = true;
  // late GoogleMapsPlaces places;
  // List<Widget> _searchResult = [];

  _onPressSearch(String val) async {
    // _isShow = true;
    // PlacesSearchResponse response = await places.searchByText(val);
    // print(response.toString());
    // _searchResult = [];
    // for (var ret in response.results) {
    //   if (ret.formattedAddress != null)
    //     _searchResult.add(
    //         Stack(
    //         children: [
    //           Container(
    //               padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
    //               width: windowWidth,
    //               color: (darkMode) ? Colors.black : Colors.white,
    //               child: Text(ret.formattedAddress!, style: theme.style14W400,)
    //           ),
    //           Positioned.fill(
    //             child: Material(
    //                 color: Colors.transparent,
    //                 child: InkWell(
    //                   splashColor: Colors.grey[400],
    //                   onTap: (){
    //                     _onAddressClick(ret);
    //                   }, // needed
    //                 )),
    //           )
    //
    //         ],
    //       )
    //   );
    //   _searchResult.add(
    //       Container(height: 1,
    //         width: windowWidth,
    //         color: Colors.grey,
    //       )
    //   );
    // }
    // setState(() {
    // });
  }

  // _onAddressClick(PlacesSearchResult ret){
  //   _searchResult = [];
  //   if (ret.formattedAddress != null)
  //     _editControllerAddress.text = ret.formattedAddress!;
  //   var pos = LatLng(ret.geometry!.location.lat, ret.geometry!.location.lng);
  //   _controller!.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: pos,
  //         zoom: _currentZoom,
  //       ),
  //     ),
  //   );
  //   _isShow = false;
  //   setState(() {
  //
  //   });
  //   // _selectPos(pos);
  // }


}

class IBoxCircle extends StatelessWidget {
  final Widget child;
  final Color color;
  IBoxCircle({this.color = Colors.white, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(40),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ],
            ),
            child: Container(
                child: child)
        ),
      );
  }
}