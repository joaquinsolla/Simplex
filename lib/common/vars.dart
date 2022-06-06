import 'package:simplex/services/sqlite_service.dart';

/// COMMON VARIABLES HERE
bool testMode = false;
bool darkMode = false;
late final double deviceHeight;
late final double deviceWidth;
bool deviceChecked = false;
int homeIndex = 0;
bool expiredEventsDeleted = false;
Event? selectedEvent;