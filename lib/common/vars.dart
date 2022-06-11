import 'dart:ui';

import 'package:simplex/services/sqlite_service.dart';

/// COMMON VARIABLES HERE
bool testMode = false;
bool darkMode = false;
Locale appLocale = Locale('es', '');
double deviceHeight = 0;
double deviceWidth = 0;
bool deviceChecked = false;
int homeIndex = 0;
bool expiredEventsDeleted = false;
Event? selectedEvent;