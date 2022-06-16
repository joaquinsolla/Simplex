/// APP DESIGNED AND CODED BY:
/// Joaquin Solla Vazquez
/// App repository: https://github.com/joaquinsolla/Simplex

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simplex/services/login_service.dart';
import 'package:simplex/services/signup_service.dart';

import 'common/vars.dart';
import 'pages/all_pages.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
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
      '/login_service': (context) => const LogInService(),
      '/signup_service': (context) => const SignUpService(),
      '/home': (context) => const Home(),
      '/events/add_event': (context) => const AddEvent(),
      '/events/event_details': (context) => const EventDetails(),
      '/events/edit_event': (context) => const EditEvent(),
    },
  ));

}
