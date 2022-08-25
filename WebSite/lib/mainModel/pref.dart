import 'package:abg_utils/abg_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref{

  SharedPreferences? _prefs;

  static String numPasswords = "numPasswords";

  init() async {
    await _init2();
  }

  _init2() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set(String key, String value)  async {
    if (_prefs == null)
      await _init2();
    _prefs!.setString(key, value);
  }

  String get(String key)  {
    String text = "";
    try{
      var _text = _prefs!.getString(key);
      if (_text == null)
        text = "";
      else
        text = _text;
    }catch(ex){
      dprint(ex.toString());
    }
    return text;
  }
}
