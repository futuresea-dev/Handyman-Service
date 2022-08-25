import 'dart:collection';

import 'package:abg_utils/abg_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';

import '../strings.dart';
import '../theme.dart';

class MapWithRegionCreation extends StatefulWidget {
  @override
  _MapWithRegionCreationState createState() => _MapWithRegionCreationState();
}

class _MapWithRegionCreationState extends State<MapWithRegionCreation> {

  late MainModel _mainModel;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(48.846575206328446, 2.302420789679285), zoom: 12,); // paris coordinates
  List<LatLng> _route = [];
  final ScrollController _controllerMap = ScrollController();
  final ScrollController _controllerMap2 = ScrollController();
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controllerMap2.dispose();
    _controllerMap.dispose();
    _mainModel.settings.saveProviderAreaMap();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(strings.get(344), style: theme.style12W400), /// Coordinates (draw your zone area on the map)
        SizedBox(height: 10,),

        Scrollbar(
          controller: _controllerMap2,
          child: SingleChildScrollView(
          controller: _controllerMap,
          scrollDirection: Axis.vertical,
          child: Container(
            width: 800,
            height: 400,
            child: _map(),
        ))),
        SizedBox(height: 10,),
        Text(strings.get(344), style: theme.style12W400), /// Coordinates (draw your zone area on the map)
        SizedBox(height: 8,),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: Row(
            children: [
              Expanded(child: Text(_text, style: theme.style12W400)),
              SizedBox(width: 15,),
              button2small(strings.get(345), _routeClear), /// "Delete current",
            ],
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  Set<Polygon> _polygons = HashSet<Polygon>();
  List<LatLng> polylineCoordinates = [];

  _routeClear(){
    _route = [];
    _polygons = HashSet<Polygon>();
    polylineCoordinates = [];
    _redraw();
  }

  final String polygonIdVal = 'polygon_id_1';

  _routeInit(){
    _mainModel.provider.getArea((List<LatLng> route) {
      _route = route;
      polylineCoordinates = [];
      for (var item in _route)
        polylineCoordinates.add(item);

      _initPolygon();
      _redraw();
      if (_route.isNotEmpty && _controller != null) {
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
        // _controller!.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       target: LatLng(_route[0].latitude, _route[0].longitude),
        //       zoom: appSettings.providerAreaMapZoom,
        //     ),
        //   ),
        // );
      }
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
        compassEnabled: true,
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
          _routeAdd(pos);
        },
        // markers: {}, //Set<Marker>.from(markers),
        onMapCreated: (GoogleMapController controller) {
           _controller = controller;
           _routeInit();
        });
  }
}