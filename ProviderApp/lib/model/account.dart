import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondprovider/ui/strings.dart';
import 'model.dart';

bool _alwaysLogin = false;

class MainDataAccount {

  final MainModel parent;

  MainDataAccount({required this.parent});

  userAndNotifyListen(Function() _redraw, BuildContext context){

    // setNotifyCallback((RemoteMessage message){
    //   dprint("message.notification=${message.notification!.title}");
    //   if (message.notification != null) {
    //     dprint("setNotifyCallback ${message.notification!.title}");
    //     parent.numberOfUnreadMessages++;
    //     parent.notify();
    //     if (parent.state == "notify"){
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
        if (listenProductsStream != null)
          listenProductsStream!.cancel();
        _alwaysLogin = false;
        disposeChatNotify();
        //
        product = [];
        productDeleteLocal();
      } else {
        if (_alwaysLogin)
          return;
        _alwaysLogin = true;
        // await needOTP();
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
        // FirebaseFirestore.instance.collection("messages")
        //     .where('user', isEqualTo: user.uid).where("read", isEqualTo: false )
        //     .get().then((querySnapshot) {
        //   parent.numberOfUnreadMessages = querySnapshot.size;
        // });
        // dprint("user.email=${user.email}");
        // dprint("user phone = ${user.phoneNumber}");
        var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
        if (querySnapshot.exists){
          var data = querySnapshot.data();
          if (data != null)
            userAccountData = UserAccountData.fromJson(data, user.email != null ? user.email! : "");

          var t = await getProviderData(userAccountData.userEmail);
          if (t == null){
            messageError(context, strings.get(145)); /// Provider Information not found
            return logout();
          }
          initBookings("providerId", userAccountData.userEmail);
          currentProvider = t;
          _redraw();
          var ret = await loadBookingCache("providerId", currentProvider.id);
          if (ret != null)
            messageError(context, ret);
          _redraw();
          //
          ret = await initService("providers", currentProvider.id, (){});
          if (ret != null)
            messageError(context, ret);
          _redraw();

          if (isSubscriptionDateExpired()){
            currentProvider.available = false;
            saveProviderFromAdmin();
          }

        }

      }
    });
  }
}