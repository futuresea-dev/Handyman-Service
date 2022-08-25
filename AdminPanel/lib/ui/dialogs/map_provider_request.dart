import 'dart:collection';

import 'package:abg_utils/abg_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';

class MapProviderRequest extends StatefulWidget {
  @override
  _MapProviderRequestState createState() => _MapProviderRequestState();
}

class _MapProviderRequestState extends State<MapProviderRequest> {

  late MainModel _mainModel;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(48.846575206328446, 2.302420789679285), zoom: 12,); // paris coordinates
  List<LatLng> _route = [];
  final ScrollController _controllerMap = ScrollController();
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controllerMap.dispose();
    _mainModel.settings.saveProviderAreaMap();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _route = _mainModel.currentProviderRequest.providerWorkArea;
    _kGooglePlex = CameraPosition(target: LatLng(
        appSettings.providerAreaMapLat != 0 ? appSettings.providerAreaMapLat : 48.846575206328446,
        appSettings.providerAreaMapLng != 0 ? appSettings.providerAreaMapLng: 2.302420789679285),
      zoom: appSettings.providerAreaMapZoom,); // paris coordinates by default
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _text = "";
    for (var item in _route){
      if (_text.isNotEmpty)
        _text = "$_text;";
      _text = "$_text ${item.latitude},${item.longitude}";
    }

    return _map();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  Set<Polygon> _polygons = HashSet<Polygon>();
  List<LatLng> polylineCoordinates = [];

  final String polygonIdVal = 'polygon_id_1';

  _routeInit(){
      print("_route = $_route");
      polylineCoordinates = [];
      for (var item in _route) {
        polylineCoordinates.add(item);
        print("item = $item");
      }
      _initPolygon();
      _redraw();
      if (_route.isNotEmpty && _controller != null)
        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          LatLngBounds bounds = boundsFromLatLngList(polylineCoordinates);
          _controller!.animateCamera(CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: bounds.southwest,
                northeast: bounds.northeast,
              ),
              100
          ));
      });
  }

  _routeAdd(LatLng pos){
    _route.add(pos);
    polylineCoordinates = [];
    if (_route.isNotEmpty) {
      for (var item in _route)
        polylineCoordinates.add(item);
      polylineCoordinates.add(_route[0]);
    }
    _initPolygon();
    currentProvider.route = _route;
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

  _map(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: true, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        polygons: _polygons,
        onCameraMove:(CameraPosition cameraPosition){
          appSettings.providerAreaMapZoom = cameraPosition.zoom;
          appSettings.providerAreaMapLat = cameraPosition.target.latitude;
          appSettings.providerAreaMapLng = cameraPosition.target.longitude;
        },
        onTap: (LatLng pos) {
          print(pos);
          _routeAdd(pos);
        },
        onLongPress: (LatLng pos) {
        },
        // markers: Set<Marker>.from(markers),
        onMapCreated: (GoogleMapController controller) {
           _controller = controller;
           _routeInit();
           // _controller!.animateCamera(
           //   CameraUpdate.newCameraPosition(
           //     CameraPosition(
           //       target: LatLng(_route[0].latitude, _route[0].longitude),
           //       zoom: appSettings.providerAreaMapZoom,
           //     ),
           //   ),
           // );
        });
  }
}