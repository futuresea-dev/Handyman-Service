import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:abg_utils/abg_utils.dart';
import 'package:ondemand_admin/widgets/button2.dart';
import 'package:ondemand_admin/widgets/edit37.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mainModel/model.dart';
import '../strings.dart';
import '../../theme.dart';
import '../bottom.dart';

class AddressAddMapScreen extends StatefulWidget {
  @override
  _AddressAddMapScreenState createState() => _AddressAddMapScreenState();
}

class _AddressAddMapScreenState extends State<AddressAddMapScreen> {

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
    // places = GoogleMapsPlaces(apiKey: _mainModel.localAppSettings.googleMapApiKey);
    double _zoom = toDouble(pref.get("zoom"));
    if (_zoom == 0)
      _zoom = 13;
    _kGooglePlex = CameraPosition(target: LatLng(
        toDouble(pref.get("lat")),
        toDouble(pref.get("lng"))),
      zoom: _zoom);

    super.initState();
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
            height: windowHeight-105-150,
            margin: EdgeInsets.only(top: 20),
            child: Stack(
            children: [
              _map(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: buttonMyLocation(_getCurrentLocation),
                ),
              ),
            ]
          ),
        ),

        Container(
            // alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.all(20),
                color: (theme.darkMode) ? Colors.black : Colors.white,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Edit37(
                        hint: strings.get(141), /// "Full address",
                        icon: Icons.map_outlined,
                        controller: _editControllerAddress,
                      ),
                      SizedBox(height: 5),
                      Row(children: [
                        Text("${strings.get(74)} $userCurrentLatitude - " /// "Latitude",
                            "${strings.get(75)} $userCurrentLongitude", style: theme.style10W400,) /// "Longitude",
                      ],),
                      SizedBox(height: 10),
                      Center(child: button2x(strings.get(76), /// "Pick here",
                              (){
                                if (userCurrentLatitude == 0 || userCurrentLongitude == 0)
                                  return messageError(context, strings.get(142)); /// "Please tap on map for select location"

                                if (_editControllerAddress.text.isEmpty)
                              return messageError(context, strings.get(77)); /// "Please enter address"
                            _mainModel.account.address = _editControllerAddress.text;
                            _mainModel.account.openAddAddressDialog();
                          })
                      ),
                      getBottomWidget(_mainModel)
        ]))),

      ],
    );
  }

  double _currentZoom = 12;

  _getCurrentLocation() async {
    if (await getCurrentLocation()) {
      var pos = LatLng(userCurrentLatitude, userCurrentLongitude);
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: pos,
            zoom: _currentZoom,
          ),
        ),
      );
      _selectPos(pos);
      _onMapTap(pos);
    }
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
          _currentZoom = cameraPosition.zoom;
          // _currentZoom = cameraPosition.zoom;
        },
        onLongPress: (LatLng pos) {

        },
        onTap: (LatLng pos) {
          userCurrentLatitude = pos.latitude;
          userCurrentLongitude = pos.longitude;
          _selectPos(pos);
          _onMapTap(pos);
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          // if (darkMode)
          //   controller.setMapStyle(_mapStyle);
        });
  }
  GoogleMapController? _controller;

  _onMapTap(LatLng pos) async {
    var _textAddress = ""; //await getAddressFromLatLng(pos, _mainModel);
    //if (_textAddress != null && _textAddress.isNotEmpty)
    _editControllerAddress.text = _textAddress;
    _redraw();
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
        }
    );
    markers.add(marker);
    _redraw();
  }
}
