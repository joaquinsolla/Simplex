/**
 * APP DESIGNED AND CODED BY:
 * Joaquin Solla Vazquez
 * App repository:
 * */

import 'package:flutter/material.dart';

import 'package:simplex/pages/all_pages.dart';
import 'common/all_common.dart';

Future<void> main() async {

  /** TESTING MODE */
  testMode = true;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simplex",
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
    },
  ));

}
