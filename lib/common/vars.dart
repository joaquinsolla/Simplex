import 'package:flutter/material.dart';
import 'package:simplex/classes/all_classes.dart';

/// COMMON VARIABLES
int loginIndex = 0;
int homeIndex = 0;

double deviceHeight = 0;
double deviceWidth = 0;

bool deviceChecked = false;
bool settingsRead = false;
bool isTester = false;
bool showPendingTodos = true;
bool showDoneTodos = false;

/// SETTINGS
bool format24Hours = true;
bool formatDates = true;
Locale appLocale = Locale('es', '');
bool darkMode = false;

/// SELECTED CLASSES
Event? selectedEvent;
Todo? selectedTodo;

/// MATERIAL APP VARIABLES
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
