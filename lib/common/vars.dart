import 'package:flutter/material.dart';
import 'package:simplex/classes/event.dart';

/// AUTH VARIABLES HERE
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// COMMON VARIABLES HERE
int loginIndex = 0;
double deviceHeight = 0;
double deviceWidth = 0;
bool deviceChecked = false;
bool settingsRead = false;
int homeIndex = 0;
Event? selectedEvent;
bool useEventFilters = false;
bool useTodosFilters = false;
int currentFilter = 0;
bool isTester = false;

/// SETTINGS HERE
bool format24Hours = true;
bool formatDates = true;
Locale appLocale = Locale('es', '');
bool darkMode = false;
