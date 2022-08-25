import 'package:abg_utils/abg_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/main.dart';
import 'model/model.dart';
import 'ui/strings.dart';

String appVersion = "2.8.1";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await pref.init();

  needStat = true;
  initStat("ondemand_admin1", appVersion);

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MainModel()),
            ChangeNotifierProvider(create: (_) => LanguageChangeNotifierProvider()),
          ],
          child: WebApp()
      )
  );
}

class WebApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // String _route = '/dashboard2';
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user == null)
    //   _route = '/login';

    context.watch<LanguageChangeNotifierProvider>().currentLocale;

    return MaterialApp(
      title: strings.get(0), ///  App name
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Tajawal",
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // locale: Provider.of<LanguageChangeNotifierProvider>(context, listen: true).currentLocale,
      initialRoute: '/dashboard2',
      routes: {
        // '/login': (BuildContext context) => Dashboard2Screen(),
        // "/forgot": (BuildContext context) => Dashboard2Screen(),
        '/dashboard2': (BuildContext context) => Dashboard2Screen(),
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