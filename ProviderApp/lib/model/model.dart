import 'dart:async';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondprovider/model/service.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/ui/theme.dart';
import 'account.dart';
import 'lang.dart';

class MainModel with ChangeNotifier, DiagnosticableTreeMixin {

  List<LangData> appLangs = [];
  List<LangData> customerAppLangs = [];
  List<ComboData> customerAppLangsCombo = [];
  String customerAppLangsComboValue = "en";
  List<LatLng> routeForNewProvider = [];
  String pathToImage = "";

  //
  // Navigation
  //
  List<AddressData> customerAddress = [];

  late MainDataService service;
  late MainDataAccount account;
  late MainDataLang lang;

  Future<String?> init(BuildContext context) async {
    service = MainDataService(parent: this);
    account = MainDataAccount(parent: this);
    lang = MainDataLang(parent: this);

    //
    // Settings
    //
    String? _return;
    _return = await getSettingsFromFile((AppSettings _appSettings){
      appSettings = _appSettings;
    });

    loadSettings(() async {
      // theme
      localSettings.setLogo(appSettings.providerLogoServer);
      localSettings.setMainColor(appSettings.providerMainColor);
      theme = AppTheme(localSettings.darkMode);
      await saveSettingsToLocalFile(appSettings);
    });

    //
    // LANGS
    //
    customerAppLangs = [];
    customerAppLangsCombo = [];
    var ret = await ifNeedLoadNewLanguages(appLangs, "provider", (LangData element){
      if (element.app == "service"){
        dprint("ifNeedLoadNewLanguages service app: ${element.locale}");
        customerAppLangs.add(element);
        customerAppLangsCombo.add(ComboData(element.name, element.locale));
      }
    });
    if (ret != null)
      messageError(context, ret);

    await loadLangsFromLocal(localSettings.locale, appSettings.currentServiceAppLanguage,
            (LangData item){
          strings.setLang(item.data, item.locale, context, item.direction);
        }, (List<LangData> langs){
          appLangs = langs;
        });

    notifyListeners();
    return _return;
  }

  notify(){
    notifyListeners();
  }

  int chatCount = 0;

} // MainModel ends


