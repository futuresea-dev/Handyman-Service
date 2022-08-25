import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondemandservice/ui/elements/address.dart';
import 'package:uuid/uuid.dart';
import '../ui/strings.dart';
import 'model.dart';

bool _alwaysLogin = false;

class MainModelUserAccount{
  final MainModel parent;
  MainModelUserAccount({required this.parent});

  userAndNotifyListen(Function() _redraw, BuildContext context){
    // setNotifyCallback((RemoteMessage message){
    //   dprint("message.notification=${message.notification!.title}");
    //   if (message.notification != null) {
    //     dprint("setNotifyCallback ${message.notification!.title}");
    //     parent.numberOfUnreadMessages++;
    //     parent.notify();
    //     if (parent.currentPage == "notify"){
    //       if (parent.updateNotify != null) {
    //         parent.numberOfUnreadMessages = 0;
    //         parent.updateNotify!();
    //       }
    //     }
    //     dprint("_numberOfUnreadMessages=${parent.numberOfUnreadMessages}");
    //     _redraw();
    //   }
    // });

    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) async {
      if (user == null) {
        dprint("=================listen user log out===============");
        if (listenBookingStream != null)
          listenBookingStream!.cancel();
        _alwaysLogin = false;
        disposeChatNotify();
      } else {
        if (_alwaysLogin)
          return;
        _alwaysLogin = true;
        await needOTP();
        var ret = await initBookings("customerId", "");
        if (ret != null)
          messageError(context, ret);
        ret = await loadBookingCache("customerId", "");
        if (ret != null)
          messageError(context, ret);
        dprint("=================listen user login===============");
        FirebaseFirestore.instance.collection("listusers").doc(user.uid).get().then((querySnapshot) async {
          if (querySnapshot.exists){
            var t = querySnapshot.data()!["visible"];
            if (t != null)
              if (!t){
                dprint("User not visible. Exit...");
                FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
                  "FCB": "",
                }, SetOptions(merge:true)).then((value2) {});
                await FirebaseAuth.instance.signOut();
                return _redraw();
              }
          }
        });
        dprint('Main User is signed in!');
        firebaseInitApp(context);
        firebaseGetToken(context);
        listenChat(user);
        loadMessages();
        FirebaseFirestore.instance.collection("listusers").doc(user.uid).get().then((querySnapshot) async {
          if (querySnapshot.exists){
            var data = querySnapshot.data();
            if (data != null)
              userAccountData = UserAccountData.fromJson(data, user.email != null ? user.email! : "");
            initProviderDistances();
            _redraw();
            comboBoxInitAddress(parent);
            initCart();
          }
        });
      }
    });
  }

  double latitude = 0;
  double longitude = 0;
  String address = "";
  bool _openAddressDialog = false;

  //
  // ADDRESS
  //

  initAddressEdit(TextEditingController _editControllerAddress, TextEditingController _editControllerName,
      TextEditingController _editControllerPhone){
    if (_openAddressDialog){
      _openAddressDialog = false;
      _editControllerAddress.text = address;
      _editControllerName.text = userAccountData.userName;
      _editControllerPhone.text = userAccountData.userPhone;
    }
  }

  addAddressByCurrentPosition() async {
    if (await getCurrentLocation()) {
      address = await getAddressFromLatLng(LatLng(latitude, longitude));
      openAddAddressDialog();
    }
  }

  openAddAddressDialog(){
    _openAddressDialog = true;
    parent.openDialog("addAddress");
  }

  Future<Position> _getCurrent() async {
    var _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .timeout(Duration(seconds: 10));
    return _currentPosition;
  }

  Future<bool> getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return false;
    }
    Position pos = await _getCurrent();
    latitude = pos.latitude;
    longitude = pos.longitude;
    return true;
  }

  //
  // type
  // 1 - home
  // 2 - office
  // 3 - other
  //

   Future<String?> saveLocation(int _type, String _address, String _name, String _phone) async {
    if (_address.isEmpty)
      return strings.get(133); /// "Please enter address",
    if (_name.isEmpty)
      return strings.get(153); /// "Please Enter name",
    if (_phone.isEmpty)
      return strings.get(209); /// "Please enter phone",

    for (var item in userAccountData.userAddress)
      item.current = false;

    userAccountData.userAddress.add(AddressData(
        id: Uuid().v4(),
        address: _address,
        lat: latitude,
        lng: longitude,
        current: true,
        type: _type,
        name: _name,
        phone: _phone,
    ));

    var t = await saveAddress();
    if (t == null){
      latitude = 0;
      longitude = 0;
    }

    initProviderDistances();

    return t;
  }

  needOTP() async {
    try {
      if (!appSettings.isOtpEnable())
        return;

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null)
        return;

      var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
      if (!querySnapshot.exists)
        return;

      var data = querySnapshot.data();
      if (data == null)
        return;

      bool t = (data["phoneVerified"] == null) ? false : data["phoneVerified"];
      needOTPParam = !t;
      dprint("needOTP t=$t needOTPParam=$needOTPParam");
    }catch(ex){
      dprint("needOTP " + ex.toString());
    }
  }
}


