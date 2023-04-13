/// APP DESIGNED AND CODED BY:
/// Joaquín Solla Vázquez
/// App repository: https://github.com/joaquinsolla/Simplex

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simplex/pages/all_pages.dart';
import 'package:simplex/common/vars.dart';
import 'package:simplex/services/shared_preferences_service.dart';
import 'package:simplex/services/auth/change_password_service.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await readSettings();

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: true,
    title: "Simplex",
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('es', ''), // Spanish, no country code
      Locale('en', ''), // English, no country code
    ],
    initialRoute: '/auth',
    routes: {
      '/auth': (context) => const Auth(),
      '/home': (context) => const Home(),
      '/services/change_password_service': (context) => const ChangePasswordService(),

      '/settings/settings_font': (context) => const SettingsFont(),

      '/stats/usage': (context) => const StatsUsage(),
      '/stats/reports': (context) => const StatsReports(),

      '/events/add_event': (context) => const AddEvent(),
      '/events/event_details': (context) => const EventDetails(),
      '/events/edit_event': (context) => const EditEvent(),

      '/routines/add_routine_element': (context) => const AddRoutineElement(),

      '/todos/add_todo': (context) => const AddTodo(),
      '/todos/todo_details': (context) => const TodoDetails(),
      '/todos/edit_todo': (context) => const EditTodo(),

      '/notes/add_note': (context) => const AddNote(),
      '/notes/note_details': (context) => const NoteDetails(),
      '/notes/edit_note': (context) => const EditNote(),

      '/help/help_main': (context) => const HelpMainPage(),
      '/help/help_buttons': (context) => const HelpButtons(),
      '/help/help_events': (context) => const HelpEvents(),
      '/help/help_todos': (context) => const HelpTodos(),
      '/help/help_notes': (context) => const HelpNotes(),
      '/help/help_routines': (context) => const HelpRoutines(),
      '/help/help_report': (context) => const HelpReport(),

    },
  ));

}
