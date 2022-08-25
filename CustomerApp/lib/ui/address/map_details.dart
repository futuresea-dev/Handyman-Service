import 'dart:typed_data';

import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/widgets/buttons/button197n.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class MapDetailsScreen extends StatefulWidget {
  @override
  _MapDetailsScreenState createState() => _MapDetailsScreenState();
}

class _MapDetailsScreenState extends State<MapDetailsScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  GoogleMapController? _controller;
  double _currentZoom = 12;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(0, 0), zoom: 12,);
  String? _mapStyle;
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _kGooglePlex = CameraPosition(target: LatLng(_mainModel.addressData!.lat, _mainModel.addressData!.lng),
        zoom: localSettings.mapZoom,); // paris coordinates by default
    _initIcons();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  late BitmapDescriptor _iconDest;

  _initIcons() async {
    final Uint8List markerIcon2 = await getBytesFromAsset('assets/marker2.png', 80);
    _iconDest = BitmapDescriptor.fromBytes(markerIcon2);
    _selectPos(LatLng(_mainModel.addressData!.lat, _mainModel.addressData!.lng));
   _redraw();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    if (_controller != null)
      _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
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
                      buttonMyLocation(_getCurrentLocation),
                      buttonPlus(_onMapPlus),
                      buttonMinus(_onMapMinus),
                    ],
                  )
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(10),
                    color: (theme.darkMode) ? Colors.black : Colors.white,
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Button197N(
                        item: _mainModel.addressData!,
                        upIcon: false,
                        pressButtonDelete: (){
                          _delete();
                        },
                      ),
                      Row(children: [
                        SizedBox(width: 20,),
                        Icon(Icons.east_outlined, color: theme.mainColor, size: 15,),
                        SizedBox(width: 20,),
                        Expanded(child: Text(_mainModel.addressData!.name, style: theme.style12W400,)),
                        SizedBox(width: 20,),
                      ],),
                      SizedBox(height: 5),
                      Row(children: [
                        SizedBox(width: 20,),
                        Icon(Icons.east_outlined, color: theme.mainColor, size: 15,),
                        SizedBox(width: 20,),
                        Expanded(child: Text(_mainModel.addressData!.phone, style: theme.style12W400,)),
                        SizedBox(width: 20,),
                      ],)
                    ]))),

            appbar1(Colors.transparent,
                (theme.darkMode) ? Colors.white : Colors.black, strings.get(216), /// "Location"
                context, () {goBack();}, style: theme.style14W800)
          ],
        )
    ));
  }

  _onMapPlus(){
    _controller?.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  _onMapMinus(){
    _controller?.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  _map() {
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,
        // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: false,
        // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.from(markers),
        onCameraMove: (CameraPosition cameraPosition) {
          localSettings.setMap(
              cameraPosition.target.latitude, cameraPosition.target.longitude,
              cameraPosition.zoom);
          _currentZoom = cameraPosition.zoom;
        },
        onLongPress: (LatLng pos) {

        },
        onTap: (LatLng pos) {
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (theme.darkMode)
            controller.setMapStyle(_mapStyle);
        });
  }

  Set<Marker> markers = {};

  _selectPos(LatLng pos){
    markers.clear();
    var _lastMarkerId = MarkerId("addr${pos.latitude}");
    final marker = Marker(
        markerId: _lastMarkerId,
        position: LatLng(pos.latitude, pos.longitude),
        onTap: () {

        },
      icon: _iconDest
    );
    markers.add(marker);
  }

  Future<Position> getCurrent() async {
    var _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .timeout(Duration(seconds: 10));
    print("MyLocation::_currentPosition $_currentPosition");
    return _currentPosition;
  }

  _getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return;
    }
    var position = await getCurrent();
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
  }

  _delete() async {
    var ret = await deleteLocation(_mainModel.addressData!);
    if (ret != null)
      return messageError(context, ret);
    goBack();
  }

}
