import 'dart:collection';
import 'dart:typed_data';

import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class MapDetailsBookingScreen extends StatefulWidget {
  @override
  _MapDetailsBookingScreenState createState() => _MapDetailsBookingScreenState();
}

class _MapDetailsBookingScreenState extends State<MapDetailsBookingScreen> {

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
    _initIcons();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _kGooglePlex = CameraPosition(target: LatLng(localSettings.mapLat, localSettings.mapLng), zoom: localSettings.mapZoom,);
    super.initState();
  }

  late BitmapDescriptor _iconDest;

  _initIcons() async {
    final Uint8List markerIcon2 = await getBytesFromAsset('assets/marker2.png', 80);
    _iconDest = BitmapDescriptor.fromBytes(markerIcon2);
    var _address = getCurrentAddress();
    if (_address.id.isNotEmpty)
      _selectPos(LatLng(_address.lat, _address.lng));
    _redraw();
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
                      // Button197a(
                      //   item: _mainModel.addressData!,
                      //   upIcon: false,
                      //   pressButtonDelete: (){
                      //     _delete();
                      //   },
                      // ),
                      // Row(children: [
                      //   SizedBox(width: 20,),
                      //   Icon(Icons.east_outlined, color: mainColor, size: 15,),
                      //   SizedBox(width: 20,),
                      //   Expanded(child: Text(_mainModel.addressData!.name, style: theme.style12W400,)),
                      //   SizedBox(width: 20,),
                      // ],),
                      // SizedBox(height: 5),
                      // Row(children: [
                      //   SizedBox(width: 20,),
                      //   Icon(Icons.east_outlined, color: mainColor, size: 15,),
                      //   SizedBox(width: 20,),
                      //   Expanded(child: Text(_mainModel.addressData!.phone, style: theme.style12W400,)),
                      //   SizedBox(width: 20,),
                      // ],)
                    ]))),

            appbar1(Colors.transparent,
                (theme.darkMode) ? Colors.white : Colors.black, strings.get(220), /// "Provider Location"
                context, () {goBack();}, style: theme.style14W800)
          ],
        )
    ));
  }

  final String polygonIdVal = 'polygon_id_1';
  List<LatLng> polylineCoordinates = [];
  Set<Polygon> _polygons = HashSet<Polygon>();

  _routeInit(){
    var _route = getProviderRoute(_mainModel.currentService.providers.isNotEmpty ? _mainModel.currentService.providers[0] : "");

    polylineCoordinates = [];
    for (var item in _route) {
      polylineCoordinates.add(item);
      dprint("item = $item");
    }
    _initPolygon();
  //  _redraw();
    if (_route.isNotEmpty && _controller != null)
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_route[0].latitude, _route[0].longitude),
            zoom: 12,
          ),
        ),
      );

  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  _initPolygon(){
    _polygons = HashSet<Polygon>();
    if (polylineCoordinates.isNotEmpty)
      _polygons.add(Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polylineCoordinates,
        strokeWidth: 2,
        strokeColor: Colors.red,
        fillColor: Colors.yellow.withOpacity(0.15),
      ));
    _redraw();
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
        polygons: _polygons,
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
          _routeInit();
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

}
