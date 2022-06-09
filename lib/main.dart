/// APP DESIGNED AND CODED BY:
/// Joaquin Solla Vazquez
/// App repository: https://github.com/joaquinsolla/Simplex

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:simplex/pages/all_pages.dart';

Future<void> main() async {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simplex",
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en', ''), // English, no country code
      Locale('es', ''), // Spanish, no country code
    ],
    initialRoute: '/home',
    routes: {
      '/home': (context) => const Home(),
      '/events/add_event': (context) => const AddEvent(),
      '/events/event_details': (context) => const EventDetails(),
      '/events/edit_event': (context) => const EditEvent(),
    },
  ));

}
