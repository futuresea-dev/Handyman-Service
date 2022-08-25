import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ondemandservice/ui/main.dart';
import 'package:ondemandservice/ui/splash.dart';
import 'package:ondemandservice/ui/theme.dart';
import 'ui/strings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' as ui;
import 'model/model.dart';

bool enableGooglePay = true;
bool enableApplePay = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getTheme();
  await getLocalSettings();
  theme = AppTheme(localSettings.darkMode);
  //
  needStat = true;
  initStat("customer1", "2.8.1");

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainModel()),
        ChangeNotifierProvider(create: (_) => LanguageChangeNotifierProvider()),
      ],
      child: OnDemandApp()
  ));
}

class OnDemandApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: strings.get(0),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const ui.Locale('en'),
        const ui.Locale('it'),
        const ui.Locale('de'),
        const ui.Locale('es'),
        const ui.Locale('fr'),
        const ui.Locale('ar'),
        const ui.Locale('pt'),
        const ui.Locale('ru'),
        const ui.Locale('hi'),
      ],
      locale: Provider.of<LanguageChangeNotifierProvider>(context, listen: true).currentLocale,
      theme: ThemeData(
        //fontFamily: "Tajawal",
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        //
        // On Demand Home Service
        //
        '/splash': (BuildContext context) => SplashScreen(),
        '/ondemandservice_main': (BuildContext context) => MainScreen(),
      },
    );
  }
}

class LanguageChangeNotifierProvider with ChangeNotifier, DiagnosticableTreeMixin {

  ui.Locale _currentLocale = ui.Locale(strings.locale);

  ui.Locale get currentLocale => _currentLocale;

  void changeLocale(String _locale){
    _currentLocale = ui.Locale(_locale);
    notifyListeners();
  }
}