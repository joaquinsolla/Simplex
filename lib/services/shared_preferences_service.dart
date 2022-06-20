import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplex/common/colors.dart';
import 'package:simplex/common/vars.dart';

readSettings() async {
  final prefs = await SharedPreferences.getInstance();

  final format24HoursKey = 'format24Hours';
  final formatDatesKey = 'formatDates';
  final appLocaleKey = 'appLocale';
  final darkModeKey = 'darkMode';

  format24Hours = prefs.getBool(format24HoursKey) ?? true;
  formatDates = prefs.getBool(formatDatesKey) ?? true;
  if (prefs.getBool(appLocaleKey) ?? true){
    appLocale = Locale('es', '');
  } else {
    appLocale = Locale('en', '');
  }
  darkMode = prefs.getBool(darkModeKey) ?? (SchedulerBinding.instance!.window.platformBrightness == Brightness.dark);
  if (darkMode) {
    colorMainBackground = Colors.black;
    colorSecondBackground = const Color(0xff1c1c1f);
    colorThirdBackground = const Color(0xff706e74);
    colorButtonText = const Color(0xff1c1c1f);
    colorNavigationBarBackground = const Color(0xff1c1c1f);
    colorNavigationBarText = const Color(0xff3a393e);
    colorMainText = Colors.white;
    colorSecondText = const Color(0xff706e74);
    colorThirdText = const Color(0xff3a393e);
  }

  debugPrint('[OK] Read settings');
}

saveSetting(String key, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
  debugPrint('[OK] Saved setting $key to $value');
}