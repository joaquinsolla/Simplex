/// APP DESIGNED AND CODED BY:
/// Joaquin Solla Vazquez
/// App repository: https://github.com/joaquinsolla/Simplex

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simplex/services/shared_preferences_service.dart';
import 'package:simplex/services/change_password_service.dart';

import 'common/vars.dart';
import 'pages/all_pages.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await readSettings();

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: true,
    title: "Simplex",
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('es', ''), // Spanish, no country code
      Locale('en', ''), // English, no country code
    ],
    initialRoute: '/auth',
    routes: {
      '/auth': (context) => const Auth(),
      '/home': (context) => const Home(),
      '/events/add_event': (context) => const AddEvent(),
      '/events/event_details': (context) => const EventDetails(),
      '/events/edit_event': (context) => const EditEvent(),
      '/services/change_password_service': (context) => const ChangePasswordService(),
    },
  ));

}
