import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'strings.dart';
import '../theme.dart';

Widget getBottomWidget(MainModel _mainModel){
  User? user = FirebaseAuth.instance.currentUser;

  Widget _policy = Row(
    children: [
      Expanded(child: ButtonTextWeb(text: strings.get(27), onTap: (){  /// "Privacy Policy",
        _mainModel.openDocument = "policy";
        _mainModel.route("documents");
      })),
      SizedBox(width: 10,),

      Expanded(child: ButtonTextWeb(text: strings.get(28), onTap: (){  /// "About Us",
        _mainModel.openDocument = "about";
        _mainModel.route("documents");
      })),
      SizedBox(width: 10,),

      Expanded(child: ButtonTextWeb(text: strings.get(29), onTap: (){  /// "Terms & Conditions",
        _mainModel.openDocument = "terms";
        _mainModel.route("documents");
      })),
    ],
  );


  return Container(
      margin: EdgeInsets.only(top: 20, bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 0.5,
            width: windowWidth,
            color: Colors.grey.withAlpha(50),
          ),
          SizedBox(height: 20,),
          Container(
              margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
              child: Column(
            children: [
              if (user != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ButtonTextWeb(text: strings.get(124), onTap: (){  /// "Booking",
                            _mainModel.route("booking");
                          }),
                          SizedBox(height: 10,),

                          ButtonTextWeb(text: strings.get(125), onTap: (){  /// "Profile",
                            _mainModel.route("profile");
                          }),
                        ],
                      )),

                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          ButtonTextWeb(text: strings.get(126), onTap: (){  /// "Favorites",
                            _mainModel.route("favorite");
                          }),

                          SizedBox(height: 10,),

                          ButtonTextWeb(text: strings.get(127), onTap: (){  /// "Notifications",
                            _mainModel.route("notify");
                          }),
                    ],
                  )),

                  SizedBox(height: 10,),

                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ButtonTextWeb(text: strings.get(128), onTap: (){  /// "My Address",
                        _mainModel.route("address_list");
                      }),

                    ],
                  )),

                ],),

              if (windowWidth <= 1000)
                _policy,

              SizedBox(height: 20,),
              Divider(thickness: 0.5,),
              Row(
                children: [
                  Container(
                    height: 30,
                    child: appSettings.websiteLogoServer.isEmpty ? Image.asset("assets/applogo.png",
                        fit: BoxFit.contain)
                        : Image.network(appSettings.websiteLogoServer, fit: BoxFit.contain,),
                  ),
                  SizedBox(width: 20,),
                  Expanded(child: Text(appSettings.copyright, style: theme.style12W600Grey, overflow: TextOverflow.ellipsis,)),
                  if (windowWidth > 1000)
                    Expanded(child: _policy)
                ],
              )
            ],
          ))

        ],
      ));

}

