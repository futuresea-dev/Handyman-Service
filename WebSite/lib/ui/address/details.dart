import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondemand_admin/widgets/button197a.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import '../bottom.dart';

class AddressDetailsMapScreen extends StatefulWidget {
  @override
  _AddressDetailsMapScreenState createState() => _AddressDetailsMapScreenState();
}

class _AddressDetailsMapScreenState extends State<AddressDetailsMapScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final _controllerCode = TextEditingController();
  late MainModel _mainModel;
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(0, 0), zoom: 12,);
  // late GoogleMapsPlaces places;
  Set<Marker> markers = {};
  final _editControllerAddress = TextEditingController();

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    double _zoom = toDouble(pref.get("zoom"));
    if (_zoom == 0)
      _zoom = 13;
    _kGooglePlex = CameraPosition(target: LatLng(_mainModel.addressData!.lat, _mainModel.addressData!.lng),
      zoom: _zoom);
    _initIcons();
    super.initState();
  }

  late BitmapDescriptor _iconDest;

  _initIcons() async {
    final Uint8List markerIcon2 = await getBytesFromAsset('assets/marker2.png', 80);
    _iconDest = BitmapDescriptor.fromBytes(markerIcon2);
    _selectPos(LatLng(_mainModel.addressData!.lat, _mainModel.addressData!.lng));
    _redraw();
  }

  @override
  void dispose() {
    _editControllerAddress.dispose();
    _controllerCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return ListView(
      children: [

        SizedBox(height: 20,),
        Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: BackSiteButton(text: strings.get(47)), /// "Go back",
        ),

        Container(
          // margin: EdgeInsets.only(bottom: 130),
          height: windowHeight-105-150,
          margin: EdgeInsets.only(top: 20),
          child: _map(),
        ),

        Container(
            // alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.all(20),
                // margin: EdgeInsets.only(bottom: 30),
                color: (theme.darkMode) ? Colors.black : Colors.white,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Button197a(
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
        getBottomWidget(_mainModel)
      ],
    );
  }

  _delete() async {
    var ret = await deleteLocation(_mainModel.addressData!);
    if (ret != null)
      return messageError(context, ret);
    goBack();
  }

  _map(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        indoorViewEnabled: true,
        mapToolbarEnabled: true,
        zoomControlsEnabled: true, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: true, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.from(markers),
        onCameraMove:(CameraPosition cameraPosition){
          pref.set("lat", cameraPosition.target.latitude.toString());
          pref.set("lng", cameraPosition.target.longitude.toString());
          pref.set("zoom", cameraPosition.zoom.toString());
          // _currentZoom = cameraPosition.zoom;
        },
        onLongPress: (LatLng pos) {

        },
        onTap: (LatLng pos) {
        },
        onMapCreated: (GoogleMapController controller) {
          // _controller = controller;
          // if (darkMode)
          //   controller.setMapStyle(_mapStyle);
        });
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

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
}
