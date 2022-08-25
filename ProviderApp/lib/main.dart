import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ondprovider/ui/start/forgot.dart';
import 'package:ondprovider/ui/start/login.dart';
import 'package:ondprovider/ui/main.dart';
import 'package:ondprovider/ui/start/otp.dart';
import 'package:ondprovider/ui/start/phone.dart';
import 'package:ondprovider/ui/start/register.dart';
import 'package:ondprovider/ui/start/splash.dart';
import 'package:ondprovider/ui/strings.dart';
import 'package:ondprovider/ui/theme.dart';
import 'package:provider/provider.dart';
import 'model/model.dart';

bool enableGoogleApplePay = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await getTheme();
  await getLocalSettings();
  theme = AppTheme(localSettings.darkMode);

  needStat = true;
  initStat("provider1", "2.8.1");

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainModel()),
        ChangeNotifierProvider(create: (_) => LanguageChangeNotifierProvider()),
      ],
      child: OnDemandApp())
  );
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
        const Locale('en'),
        const Locale('it'),
        const Locale('de'),
        const Locale('es'),
        const Locale('fr'),
        const Locale('ar'),
        const Locale('pt'),
        const Locale('ru'),
        const Locale('hi'),
      ],
      locale: Provider.of<LanguageChangeNotifierProvider>(context, listen: true).currentLocale,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => OnDemandSplashScreen(),
        '/forgot': (BuildContext context) => ForgotScreen(),
        '/ondemand_login': (BuildContext context) => LoginScreen(),
        '/ondemand_otp': (BuildContext context) => OnDemandOTPScreen(),
        '/ondemand_register': (BuildContext context) => OnDemandRegisterCodeScreen(),
        '/ondemand_phone': (BuildContext context) => OnDemandPhoneScreen(),
        '/ondemand_main': (BuildContext context) => OnMainScreen(),
      },
    );
  }
}

class LanguageChangeNotifierProvider with ChangeNotifier, DiagnosticableTreeMixin {

  Locale  _currentLocale = Locale(strings.locale);

  Locale get currentLocale => _currentLocale;

  void changeLocale(String _locale){
    _currentLocale = Locale(_locale);
    notifyListeners();
  }
}