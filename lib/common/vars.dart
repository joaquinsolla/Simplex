import 'package:flutter/material.dart';
import 'package:simplex/services/sqlite_service.dart';

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
int currentEventFilter = 0;

/// SETTINGS HERE
bool format24Hours = true;
bool formatDates = true;
Locale appLocale = Locale('es', '');
bool darkMode = false;
