import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:abg_utils/abg_utils.dart';
import 'package:ondprovider/model/model.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/ui/theme.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class MapCustomerScreen extends StatefulWidget {
  @override
  _MapCustomerScreenState createState() => _MapCustomerScreenState();
}

class _MapCustomerScreenState extends State<MapCustomerScreen> {

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
    if (_mainModel.customerAddress.isNotEmpty)
      _kGooglePlex = CameraPosition(target: LatLng(_mainModel.customerAddress[0].lat, _mainModel.customerAddress[0].lng),
          zoom: localSettings.mapZoom,);
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
    for (var item in _mainModel.customerAddress)
      _selectPos(LatLng(item.lat, item.lng), item.address);
    setState(() {});
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
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

            appbar1(Colors.transparent,
                (theme.darkMode) ? Colors.white : Colors.black, strings.get(210), /// "Customer location"
                context, () {goBack();}, style: theme.style14W800)
          ],
        )
    ));
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

  _selectPos(LatLng pos, String text){
    markers.clear();
    var _lastMarkerId = MarkerId("addr${pos.latitude}");
    final marker = Marker(
        infoWindow: InfoWindow(
            title: strings.get(211), /// "Customer address",
            snippet: text,
            onTap: () {
              dprint("tap on marker");
            },
        ),
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
    dprint("MyLocation::_currentPosition $_currentPosition");
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
}
