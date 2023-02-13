import 'package:flutter/material.dart';
import 'package:simplex/classes/all_classes.dart';

/// COMMON VARIABLES
int loginIndex = 0;
int homeIndex = 0;

double deviceHeight = 0;
double deviceWidth = 0;

bool verticalDevice = true;
bool deviceChecked = false;
bool settingsRead = false;
bool isTester = false;
bool showPendingTodos = true;
bool showDoneTodos = false;

DateTime selectedDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

/// SETTINGS
bool format24Hours = true;
bool formatDates = true;
Locale appLocale = Locale('es', '');
bool darkMode = false;
double fontSize = 1;

/// SELECTED CLASSES
Event? selectedEvent;
Todo? selectedTodo;
Note? selectedNote;

/// MATERIAL APP KEY
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
