import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/elements/header.dart';
import 'package:ondemand_admin/ui/strings.dart';
import '../theme.dart';
import 'package:abg_utils/abg_utils.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  final _controllerOtpPrefix = TextEditingController();
  final _controllerOtpNumber = TextEditingController();
  final _controllerTwilioAccountSID = TextEditingController();
  final _controllerTwilioAuthToken = TextEditingController();
  final _controllerTwilioServiceId = TextEditingController();
  final _controllerNexmoFrom = TextEditingController();
  final _controllerNexmoText = TextEditingController();
  final _controllerNexmoApiKey = TextEditingController();
  final _controllerNexmoApiSecret = TextEditingController();
  final _controllerSMSToFrom = TextEditingController();
  final _controllerSMSToText = TextEditingController();
  final _controllerSMSToApiKey = TextEditingController();

  @override
  void initState() {
    _controllerOtpPrefix.text = appSettings.otpPrefix;
    _controllerOtpNumber.text = appSettings.otpNumber.toString();
    _controllerTwilioAccountSID.text = appSettings.twilioAccountSID;
    _controllerTwilioAuthToken.text = appSettings.twilioAuthToken;
    _controllerTwilioServiceId.text = appSettings.twilioServiceId;
    if (appSettings.nexmoFrom.isEmpty)
      appSettings.nexmoFrom = strings.get(0);
    _controllerNexmoFrom.text = appSettings.nexmoFrom;
    if (appSettings.nexmoText.isEmpty)
      appSettings.nexmoText = strings.get(388); /// "Your code is {code}",
    _controllerNexmoText.text = appSettings.nexmoText;
    _controllerNexmoApiKey.text = appSettings.nexmoApiKey;
    _controllerNexmoApiSecret.text = appSettings.nexmoApiSecret;
    if (appSettings.smsToFrom.isEmpty)
      appSettings.smsToFrom = strings.get(0);
    _controllerSMSToFrom.text = appSettings.smsToFrom;
    if (appSettings.smsToText.isEmpty)
      appSettings.smsToText = strings.get(388); /// "Your code is {code}",
    _controllerSMSToText.text = appSettings.smsToText;
    _controllerSMSToApiKey.text = appSettings.smsToApiKey;
    if (appSettings.demo && appSettings.smsToApiKey.isNotEmpty)
      _controllerSMSToApiKey.text = "********************";
    super.initState();
  }

  @override
  void dispose() {
    _controllerOtpPrefix.dispose();
    _controllerOtpNumber.dispose();
    _controllerTwilioAccountSID.dispose();
    _controllerTwilioAuthToken.dispose();
    _controllerTwilioServiceId.dispose();
    _controllerNexmoFrom.dispose();
    _controllerNexmoText.dispose();
    _controllerNexmoApiKey.dispose();
    _controllerNexmoApiSecret.dispose();
    _controllerSMSToFrom.dispose();
    _controllerSMSToText.dispose();
    _controllerSMSToApiKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body(strings.get(52), "assets/dashboard2/dashboard1.png", _getList()); /// "Settings | Firebase OTP",
  }

  _getList() {
    List<Widget> list = [];

    list.add(textElement(strings.get(50), "+091", _controllerOtpPrefix)); // OTP prefix (ex: for India +91)
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.5,));
    list.add(SizedBox(height: 20,));

    list.add(checkBox1a(context, strings.get(309), theme.mainColor, /// "Enable Firebase OTP"
        theme.style14W400, appSettings.otpEnable,
            (val) {
          appSettings.otpEnable = val!;
          if (val) {
            appSettings.otpTwilioEnable = false;
            appSettings.otpNexmoEnable = false;
            appSettings.otpSMSToEnable = false;
          }
          _redraw();
      }));
    list.add(SizedBox(height: 10,));
    list.add(Text(strings.get(369), style: theme.style14W400,)); /// You must settings Firebase OTP in Google Firebase Console

    //
    // twilio
    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.5,));
    list.add(SizedBox(height: 20,));

    list.add(checkBox1a(context, strings.get(370), theme.mainColor, /// "Enable Twilio SMS"
        theme.style14W400, appSettings.otpTwilioEnable,
            (val) {
          appSettings.otpTwilioEnable = val!;
          if (val) {
            appSettings.otpEnable = false;
            appSettings.otpNexmoEnable = false;
            appSettings.otpSMSToEnable = false;
          }
          _redraw();
      }));
    list.add(textElement(strings.get(371), "", _controllerTwilioAccountSID)); /// Account SID
    list.add(textElement(strings.get(372), "", _controllerTwilioAuthToken)); /// Auth token
    list.add(textElement(strings.get(373), "", _controllerTwilioServiceId)); /// Service Id

    //
    // nexmo
    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.5,));
    list.add(SizedBox(height: 20,));

    list.add(checkBox1a(context, strings.get(377), theme.mainColor, /// "Enable Nexmo SMS"
        theme.style14W400, appSettings.otpNexmoEnable,
            (val) {
          appSettings.otpNexmoEnable = val!;
          if (val) {
            appSettings.otpEnable = false;
            appSettings.otpTwilioEnable = false;
            appSettings.otpSMSToEnable = false;
          }
          _redraw();
        }));
    list.add(textElement(strings.get(378), "", _controllerNexmoFrom)); /// From
    list.add(textElement(strings.get(20), "", _controllerNexmoText)); /// "Text of message",
    list.add(textElement(strings.get(379), "", _controllerNexmoApiKey)); /// Api Key
    list.add(textElement(strings.get(380), "", _controllerNexmoApiSecret)); /// Api secret

    //
    // sms to
    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.5,));
    list.add(SizedBox(height: 20,));

    list.add(checkBox1a(context, strings.get(381), theme.mainColor, /// "Enable SMS.to SMS"
        theme.style14W400, appSettings.otpSMSToEnable,
            (val) {
          appSettings.otpSMSToEnable = val!;
          if (val) {
            appSettings.otpEnable = false;
            appSettings.otpTwilioEnable = false;
            appSettings.otpNexmoEnable = false;
          }
          _redraw();
        }));
    list.add(textElement(strings.get(378), "", _controllerSMSToFrom)); /// From
    list.add(textElement(strings.get(20), "", _controllerSMSToText)); /// "Text of message",
    list.add(textElement(strings.get(379), "", _controllerSMSToApiKey)); /// Api Key

    //
    //
    //
    // list.add(textElement(strings.get(51), "7", _controllerOtpNumber)); // Number of digits (without prefix)

    list.add(SizedBox(height: 50,));
    list.add(Center(child: button2b(strings.get(9), _save))); // "Save"
    list.add(SizedBox(height: 100,));

    return list;
  }

  _save() async {
    if (appSettings.otpEnable) {
      if (_controllerOtpPrefix.text.isEmpty)
        return messageError(context, strings.get(198)); /// Please enter OTP prefix
      if (_controllerOtpNumber.text.isEmpty)
        return messageError(context, strings.get(199)); /// Please enter number of digits
    }
    if (appSettings.otpTwilioEnable) {
      if (_controllerTwilioAccountSID.text.isEmpty)
        return messageError(context, strings.get(374)); /// Please enter Account SID
      if (_controllerTwilioAuthToken.text.isEmpty)
        return messageError(context, strings.get(375)); /// Please enter Auth Token
      if (_controllerTwilioServiceId.text.isEmpty)
        return messageError(context, strings.get(376)); /// Please enter Service Id
    }
    if (appSettings.otpNexmoEnable){
      if (_controllerNexmoFrom.text.isEmpty)
        return messageError(context, strings.get(382)); /// Please enter Nexmo From
      if (_controllerNexmoText.text.isEmpty)
        return messageError(context, strings.get(383)); /// Please enter Nexmo Text
      if (_controllerNexmoApiKey.text.isEmpty)
        return messageError(context, strings.get(384)); /// Please enter Nexmo API key
      if (_controllerNexmoApiKey.text.isEmpty)
        return messageError(context, strings.get(385)); /// Please enter Nexmo API Secret
    }
    if (appSettings.otpSMSToEnable){
      if (_controllerSMSToFrom.text.isEmpty)
        return messageError(context, strings.get(386)); /// Please enter SMS.to From
      if (_controllerSMSToText.text.isEmpty)
        return messageError(context, strings.get(387)); /// Please enter SMS.to Text
      if (_controllerSMSToApiKey.text.isEmpty)
        return messageError(context, strings.get(387)); /// Please enter SMS.to Api Key
    }

    var _smsToApiKey = _controllerSMSToApiKey.text;
    if (appSettings.demo && appSettings.smsToApiKey.isNotEmpty){
      if (_smsToApiKey == "********************")
        _smsToApiKey = appSettings.smsToApiKey;
    }

    waitInMainWindow(true);
    var ret = await saveSettingsOTP(_controllerOtpPrefix.text, _controllerOtpNumber.text,
        _controllerTwilioAccountSID.text, _controllerTwilioAuthToken.text, _controllerTwilioServiceId.text,
        _controllerNexmoFrom.text, _controllerNexmoText.text, _controllerNexmoApiKey.text,
        _controllerNexmoApiSecret.text, _controllerSMSToFrom.text, _controllerSMSToText.text, _smsToApiKey
    );
    if (ret == null)
      messageOk(context, strings.get(81)); /// "Data saved",
    else
      messageError(context, ret);
    waitInMainWindow(false);
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }
}


