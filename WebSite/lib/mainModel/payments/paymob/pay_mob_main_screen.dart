import 'dart:core';
import 'package:flutter/material.dart';
import '../../../theme.dart';
import 'pay_mob_payment.dart';
import 'package:abg_utils/abg_utils.dart';

class PayMobMainScreen extends StatefulWidget {
  final String userFirstName;
  final String userEmail;
  final String payAmount;
  final String userPhone;
  final String apiKey;
  final String frame;
  final String integrationId;

  PayMobMainScreen({required this.userFirstName,
    required this.userEmail, required this.payAmount,
        required this.apiKey, required this.frame, required this.integrationId, required this.userPhone});

  @override
  State<StatefulWidget> createState() {
    return PayMobMainScreenState();
  }
}

class PayMobMainScreenState extends State<PayMobMainScreen> {

  double windowWidth = 0;
  double windowHeight = 0;
  final editControllerCity = TextEditingController();
  final editControllerCountry = TextEditingController();
  final editControllerPostalCode = TextEditingController();
  final editControllerState = TextEditingController();
  final editControllerFirstName = TextEditingController();
  final editControllerLastName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerStreet = TextEditingController();
  final editControllerBuilding = TextEditingController();
  final editControllerFloor = TextEditingController();
  final editControllerApartment = TextEditingController();

  @override
  void dispose() {
    editControllerCity.dispose();
    editControllerCountry.dispose();
    editControllerPostalCode.dispose();
    editControllerState.dispose();
    editControllerFirstName.dispose();
    editControllerLastName.dispose();
    editControllerEmail.dispose();
    editControllerPhone.dispose();
    editControllerStreet.dispose();
    editControllerBuilding.dispose();
    editControllerFloor.dispose();
    editControllerApartment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: appBar("PayMob"),
        body: Stack(
          children: <Widget>[

            Container (
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: _getList(),
              ),),

          ],
        )
    );
  }

  appBar(title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=> Navigator.pop(context)),
      backgroundColor: Colors.white,
      title: Text(
        title,
      ),
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(Container(
      alignment: Alignment.center,
      child: Text("Provide the following information for payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,))
    );

    list.add(SizedBox(height: 20,));

    // editControllerCountry.text = "Egypt";
    list.add(Text("Country",));
    list.add(IInputField2(hint : "Enter country",
      controller : editControllerCountry,
      type : TextInputType.text,
    ));

    list.add(Text("Postal code",));
    list.add(IInputField2(hint : "Enter Postal code",
      controller : editControllerPostalCode,
      type : TextInputType.number,
    ));

    list.add(Text("State",));
    list.add(IInputField2(hint : "Enter State",
      controller : editControllerState,
      type : TextInputType.text,
    ));

    list.add(Text("City",));
    list.add(IInputField2(hint : "Enter city",
        controller : editControllerCity,
        type : TextInputType.text,
    ));

    list.add(Text("Street",));
    list.add(IInputField2(hint : "Enter Street",
      controller : editControllerStreet,
      type : TextInputType.text,
    ));

    list.add(Text("Building",));
    list.add(IInputField2(hint : "Enter building",
      controller : editControllerBuilding,
      type : TextInputType.text,
    ));

    list.add(Text("Floor",));
    list.add(IInputField2(hint : "Enter floor",
      controller : editControllerFloor,
      type : TextInputType.number,
    ));

    list.add(Text("Apartment",));
    list.add(IInputField2(hint : "Enter apartment",
      controller : editControllerApartment,
      type : TextInputType.text,
    ));

    list.add(Text("First Name",));
    list.add(IInputField2(hint : "Enter First Name",
      controller : editControllerFirstName,
      type : TextInputType.text,
    ));

    list.add(Text("Last Name",));
    list.add(IInputField2(hint : "Enter Last Name",
      controller : editControllerLastName,
      type : TextInputType.text,
    ));

    list.add(Text("Email",));
    list.add(IInputField2(hint : "Enter email",
      controller : editControllerEmail,
      type : TextInputType.text,
    ));

    list.add(Text("Phone",));
    list.add(IInputField2(hint : "Enter phone",
      controller : editControllerPhone,
      type : TextInputType.text,
    ));

    list.add(SizedBox(height: 20,));

    list.add(Container(
      alignment: Alignment.center,
      child: button2("Next", theme.mainColor, _next),
    ),);

    list.add(SizedBox(height: 100,));

    return list;
  }

  _next(){
    // editControllerCountry.text = "Egypt";
    // editControllerPostalCode.text = "121212";
    // editControllerState.text = "d";
    // editControllerCity.text = "Bani Sweif";
    // editControllerStreet.text = "Qism Bani Sweif";
    // editControllerBuilding.text = "1";
    // editControllerFloor.text = "1";
    // editControllerApartment.text = "1";
    // editControllerFirstName.text = "Abdul";
    // editControllerLastName.text = "salai";
    // editControllerEmail.text = "s@m.ru";
    // editControllerPhone.text = "+20822207098";

    if (editControllerCountry.text.isEmpty)
      return messageError(context, "Need enter country");
    if (editControllerPostalCode.text.isEmpty)
      return messageError(context, "Need enter postal code");
    if (editControllerState.text.isEmpty)
      return messageError(context, "Need enter State");
    if (editControllerCity.text.isEmpty)
      return messageError(context, "Need enter City");
    if (editControllerStreet.text.isEmpty)
      return messageError(context, "Need enter Street");
    if (editControllerBuilding.text.isEmpty)
      return messageError(context, "Need enter Building");
    if (editControllerFloor.text.isEmpty)
      return messageError(context, "Need enter Floor");
    if (editControllerApartment.text.isEmpty)
      return messageError(context, "Need enter Apartment");
    if (editControllerFirstName.text.isEmpty)
      return messageError(context, "Need enter First Name");
    if (editControllerLastName.text.isEmpty)
      return messageError(context, "Need enter Last Name");
    if (editControllerEmail.text.isEmpty)
      return messageError(context, "Need enter Email");
    if (editControllerPhone.text.isEmpty)
      return messageError(context, "Need enter Phone");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayMobPayment(
            userFirstName: userAccountData.userName,
            userEmail: userAccountData.userEmail,
            userPhone: userAccountData.userPhone,
            payAmount: widget.payAmount,
            apiKey: widget.apiKey,
            frame: widget.frame,
            integrationId: widget.integrationId,
            //
            country: editControllerCountry.text,
            postalCode: editControllerPostalCode.text,
            state: editControllerState.text,
            city: editControllerCity.text,
            street: editControllerStreet.text,
            building: editControllerBuilding.text,
            floor: editControllerFloor.text,
            apartment: editControllerApartment.text,
            firstName: editControllerFirstName.text,
            lastName: editControllerLastName.text,
            email: editControllerEmail.text,
            phoneNumber: editControllerPhone.text,
        ),
      ),
    );
  }

}

/*

"country": "Egypt",
"postal_code": "2",
"state": "2"
"city": "1",

"street": "2",
"building": "2",
"floor": "1",
"apartment": "1",

"first_name": userFirstName,
"last_name": "2",
"email": email,
"phone_number": "$phone",

?????? "shipping_method": "2",
 */

class IInputField2 extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final IconData? iconRight;
  final Function()? onPressRightIcon;
  final Function(String)? onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final int maxLenght;
  IInputField2({required this.hint, this.icon, required this.controller, required this.type,
    this.iconRight, this.onPressRightIcon, this.onChangeText, this.maxLenght = 100});

  @override
  _IInputField2State createState() => _IInputField2State();
}

class _IInputField2State extends State<IInputField2> {

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = Colors.black;
    Widget? _sicon = Icon(widget.icon, color: _colorDefaultText,);
    if (widget.icon == null)
      _sicon = null;

    Widget? _sicon2;
    if (widget.iconRight != null)
      _sicon2 = InkWell(
          onTap: () {
            if (widget.onPressRightIcon != null)
              widget.onPressRightIcon!();
          }, // needed
          child: Icon(widget.iconRight, color: _colorDefaultText,));

    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(bottom: 10,),
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(theme.radius),
    ),
    child: Container(
      child: TextFormField(
        keyboardType: widget.type,
        cursorColor: _colorDefaultText,
        controller: widget.controller,
        onChanged: (String value) async {
          if (widget.onChangeText != null)
            widget.onChangeText!(value);
        },
        textAlignVertical: TextAlignVertical.center,
        maxLines: 1,
        maxLength: widget.maxLenght,
        style: TextStyle(
          color: _colorDefaultText,
        ),
        decoration: InputDecoration(
          prefixIcon: _sicon,
          suffixIcon: _sicon2,
          counterText: "",
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
    ));
  }
}