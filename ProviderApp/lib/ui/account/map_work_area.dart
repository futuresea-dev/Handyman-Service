import 'dart:collection';

import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../strings.dart';
import '../theme.dart';

class MapWorkAreaScreen extends StatefulWidget {
  @override
  _MapWorkAreaScreenState createState() => _MapWorkAreaScreenState();
}

class _MapWorkAreaScreenState extends State<MapWorkAreaScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  GoogleMapController? _controller;
  double _currentZoom = 12;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(0, 0), zoom: 12,);
  String? _mapStyle;

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _kGooglePlex = CameraPosition(target: LatLng(localSettings.mapLat, localSettings.mapLng), zoom: localSettings.mapZoom,);
    super.initState();
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

    String _text = "";
    for (var item in currentProvider.route){
      if (_text.isNotEmpty)
        _text = "$_text; ";
      _text = "$_text${item.latitude},${item.longitude}";
    }

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
                (theme.darkMode) ? Colors.white : Colors.black, strings.get(180), /// "Edit your work area",
                context, () {Navigator.pop(context);}),

            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                padding: EdgeInsets.all(10),
                color: theme.darkMode ? Colors.black : Colors.white,
                child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 0),
                    children: [
                      Text(_text, style: theme.style12W400)
                    ]
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(child: button2(strings.get(181), Colors.red, (){ /// "Delete current",
                          currentProvider.route = [];
                          _routeInit();
                          _redraw();
                        })),
                        SizedBox(width: 10,),
                        Expanded(child: button2(strings.get(67), theme.mainColor, () async {  /// "Save",
                          var ret = await saveWorkArea(currentProvider);
                          if (ret != null)
                            return messageError(context, ret);
                          Navigator.pop(context);
                        })),
                      ],
                    ),
                  )
                ],
              ),
            )),

          ],
        )
    ));
  }

  final String polygonIdVal = 'polygon_id_1';
  List<LatLng> polylineCoordinates = [];
  Set<Polygon> _polygons = HashSet<Polygon>();

  _routeInit(){
    var _route = currentProvider.route;

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
          _routeAdd(pos);
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (theme.darkMode)
            controller.setMapStyle(_mapStyle);
          _routeInit();
        });
  }

  Set<Marker> markers = {};

  _routeAdd(LatLng pos){
    currentProvider.route.add(pos);
    polylineCoordinates = [];
    if (currentProvider.route.isNotEmpty) {
      for (var item in currentProvider.route)
        polylineCoordinates.add(item);
      polylineCoordinates.add(currentProvider.route[0]);
    }
    _initPolygon();
    // _mainModel.provider.saveArea(_mainModel.getProvider().route);
  }

  // _selectPos(LatLng pos){
  //   markers.clear();
  //   var _lastMarkerId = MarkerId("addr${pos.latitude}");
  //   final marker = Marker(
  //       markerId: _lastMarkerId,
  //       position: LatLng(pos.latitude, pos.longitude),
  //       onTap: () {
  //
  //       },
  //     icon: _iconDest
  //   );
  //   markers.add(marker);
  // }

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
