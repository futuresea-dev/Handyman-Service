import 'package:abg_utils/abg_utils.dart';
import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'package:ondemandservice/widgets/buttons/button202m2.dart';
import 'package:provider/provider.dart';
import 'strings.dart';

class MapNearByScreen extends StatefulWidget {
  @override
  _MapNearByScreenState createState() => _MapNearByScreenState();
}

class _MapNearByScreenState extends State<MapNearByScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  GoogleMapController? _controller;
  double _currentZoom = 12;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(0, 0), zoom: 12,);
  String? _mapStyle;
  late MainModel _mainModel;
  var scrollController = ScrollController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _initIcons();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _kGooglePlex = CameraPosition(target: LatLng(localSettings.mapLat, localSettings.mapLng), zoom: localSettings.mapZoom,);
    _getCurrentLocation();
    super.initState();
  }

  late BitmapDescriptor _iconDest;

  _initIcons() async {
    final Uint8List markerIcon2 = await getBytesFromAsset('assets/marker2.png', 80);
    _iconDest = BitmapDescriptor.fromBytes(markerIcon2);
    for (var item in providers) {
      if (item.route.isNotEmpty){
        LatLngBounds bounds = boundsFromLatLngList(item.route);
        LatLng location = getCenter(bounds);
        dprint("_initIcons location=${location.toString()}");
        _selectPos(location, item);
      }
    }
    _redraw();
  }

  @override
  void dispose() {
    if (_controller != null)
      _controller!.dispose();
    scrollController.dispose();
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
              child: _horizontalProviders(),
            ),

            appbar1(Colors.transparent,
                (theme.darkMode) ? Colors.white : Colors.black, strings.get(239), /// "Services nearby"
                context, () {goBack();}, style: theme.style14W800)
          ],
        )
    ));
  }

  Widget? _horizontalProviders(){
    List<Widget> list = [];
    list.add(SizedBox(width: 10,));
    bool _found = false;
    double _needShow = 0;
    for (var item in providers){
      list.add(Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: item == _currentSelectProvider ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            padding: EdgeInsets.all(5),
            width: windowWidth*0.9,
            child: button202m2(item, _mainModel, windowWidth*0.26, callback: (){
              _routeInit(item);
            })),
          SizedBox(height: 5,),
          Container(
            width: windowWidth*0.9,
            alignment: Alignment.bottomRight,
              child: button2c(strings.get(240), theme.mainColor, (){ /// Open Provider Page
                // currentSourceKeyProvider = item.key;
                _mainModel.currentProvider = item;
                route("provider");
              })
          )
        ],
      ));
      list.add(SizedBox(width: 10,));
      _found = true;
      if (item == _currentSelectProvider){
        // dprint("scrollController.animateTo _needShow=$_needShow");
        scrollController.animateTo(_needShow, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      }
      _needShow += (windowWidth*0.9+10);
    }
    if (!_found)
      return null;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: windowWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child:
            Row(
              children: list,
            ),
          ),
        ],
      ),
    );
  }

  final String polygonIdVal = 'polygon_id_1';
  List<LatLng> polylineCoordinates = [];
  Set<Polygon> _polygons = HashSet<Polygon>();
  ProviderData? _currentSelectProvider;

  _routeInit(ProviderData item){
    _currentSelectProvider = item;
    polylineCoordinates = item.route;
    if (polylineCoordinates.isEmpty)
      return;
    LatLngBounds bounds = boundsFromLatLngList(polylineCoordinates);
    _initPolygon();
    if (polylineCoordinates.isNotEmpty && _controller != null)
      _controller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: bounds.southwest,
          northeast: bounds.northeast,
        ),
        100
      ));
    _redraw();
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
          //_routeInit();
        });
  }

  Set<Marker> markers = {};

  _selectPos(LatLng pos, ProviderData item){
    var _lastMarkerId = MarkerId("addr${pos.latitude}");
    final marker = Marker(
        markerId: _lastMarkerId,
        position: LatLng(pos.latitude, pos.longitude),
        onTap: () {
          _routeInit(item);
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

