import 'dart:ui';

import 'package:simplex/services/sqlite_service.dart';

/// COMMON VARIABLES HERE
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
bool darkMode = false;
Locale appLocale = Locale('es', '');