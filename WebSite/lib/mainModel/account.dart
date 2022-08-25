import 'dart:async';
import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ondemand_admin/mainModel/pref.dart';
import 'package:ondemand_admin/ui/address.dart';
import '../ui/strings.dart';
import 'model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool _alwaysLogin = false;

class MainModelAccount {
  final MainModel parent;

  MainModelAccount({required this.parent});

  int chatCount = 0;
  int numberOfUnreadMessages = 0;
  // bool needOTPParam = false;
  // String _codeSent = "";

  Future<String?> accountLogin(String _email, String _password, bool _ckeckValues) async {
    User? user;
    try{
      user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,)).user;
    }catch(ex){
      return ex.toString();
    }

    if (user != null){
      if (_ckeckValues){
        var t = 0;
        String email = "";
        do{
          email = pref.get("email$t");
          if (email == _email)
            break;
          t++;
        }while(email.isNotEmpty);
        if (email != _email) {
          int n = toInt(pref.get(Pref.numPasswords));
          pref.set("email$n", _email);
          pref.set("pass$n", _password);
          n++;
          pref.set(Pref.numPasswords, n.toString());
        }
      }

      // print("user login id=${user.uid}");
      try{
        var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
        if (!querySnapshot.exists)
          return strings.get(37); /// "Username or password is incorrect"
        else{
          var _data = querySnapshot.data();
          if (_data != null){
            return null;
          }else{
            return strings.get(37) + "_data = null"; /// "Username or password is incorrect"
          }
        }
      }catch(ex){
        return strings.get(37); /// "Username or password is incorrect"
      }
    }
    return null;
  }

  userListen(BuildContext context){
    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) async {
      if (user == null) {
        _alwaysLogin = false;
        if (listenBookingStream != null)
          listenBookingStream!.cancel();
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
                await FirebaseAuth.instance.signOut();
                return parent.redraw();
              }
          }
        });
        dprint('Main User is signed in!');
        listenChat(user);
        FirebaseFirestore.instance.collection("messages")
            .where('user', isEqualTo: user.uid).where("read", isEqualTo: false )
            .get().then((querySnapshot) {
          numberOfUnreadMessages = querySnapshot.size;
        });
        dprint("user.email=${user.email}");
        dprint("user phone = ${user.phoneNumber}");
        FirebaseFirestore.instance.collection("listusers").doc(user.uid).get().then((querySnapshot) async {
          if (querySnapshot.exists){
            var data = querySnapshot.data();
            if (data != null)
              userAccountData = UserAccountData.fromJson(data, user.email != null ? user.email! : "");
            initProviderDistances();
            comboBoxInitAddress(parent);
            if (product.isNotEmpty)
              await initCart();
            parent.redraw();
          }
        });
      }
    });
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
      print("needOTP t=$t needOTPParam=$needOTPParam");
    }catch(ex){
      print("needOTP " + ex.toString());
    }
  }

  // ignore_for_file: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? _listen;

  disposeChatNotify(){
    if (_listen != null)
      _listen!.cancel();
  }

  listenChat(User? user){
    _listen = FirebaseFirestore.instance.collection("listusers")
        .doc(user!.uid).snapshots().listen((querySnapshot) {
      if (querySnapshot.data() != null) {
        var _data = querySnapshot.data()!;
        print(_data["unread_chat"]);
        chatCount = _data["unread_chat"] != null ? toDouble(_data["unread_chat"].toString()).toInt() : 0;
        if (chatCount < 0) {
          chatCount = 0;
          FirebaseFirestore.instance.collection("listusers").doc(user.uid).set({
            "unread_chat": chatCount,
          }, SetOptions(merge: true));
        }
        // notifyListeners();
      }
    });
  }


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
      address = await getAddressFromLatLng(LatLng(userCurrentLatitude, userCurrentLongitude));
      openAddAddressDialog();
    }
  }

  openAddAddressDialog(){
    _openAddressDialog = true;
    parent.openDialog("addAddress");
  }
}