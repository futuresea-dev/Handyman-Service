import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/ui/strings.dart';

class LanguageChangeNotifierProvider with ChangeNotifier, DiagnosticableTreeMixin {

  Locale  _currentLocale = Locale(strings.locale);

  Locale get currentLocale => _currentLocale;

  void changeLocale(String _locale){
    _currentLocale = Locale(_locale);
    notifyListeners();
  }
}