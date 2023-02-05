import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';


void showSnackBar(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
  ));
}

DateTime dateTimeToDateOnly(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

String dateToString(DateTime dateTime) {
  if (formatDates == true)
    return DateFormat('dd/MM/yyyy').format(dateTime);
  else
    return DateFormat('MM/dd/yyyy').format(dateTime);
}

String timeToString(DateTime dateTime) {
  if (format24Hours == true)
    return DateFormat('HH:mm').format(dateTime);
  else
    return DateFormat('h:mm aa').format(dateTime);
}

String millisecondsTimeToString(int millis) {
  DateTime date = DateTime.fromMicrosecondsSinceEpoch(millis * 1000);

  return timeToString(date);
}

void buildEventNotification(int id, String title, DateTime notificationDateTime,
    DateTime eventDateTime) {
  String body = 'Es el ';
  if (formatDates == true)
    body = body + DateFormat('dd/MM/yyyy').format(eventDateTime);
  else
    body = body + DateFormat('MM/dd/yyyy').format(eventDateTime);
  body = body + ' a las ';
  if (format24Hours == true)
    body = body + DateFormat('H:mm').format(eventDateTime);
  else
    body = body + DateFormat('K:mm aa').format(eventDateTime);

  if (notificationDateTime.isBefore(eventDateTime) &&
      notificationDateTime.isAfter(DateTime.now())) {
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    tz.initializeTimeZones();

    NotificationService()
        .showNotification(id, title, body, notificationDateTime);
    debugPrint('[OK] Notification ready: $id');
  } else {
    debugPrint('[WRN] Cannot show notification $id: Time out of range');
  }
}

void buildTodoNotifications(int id, String title, DateTime todoLimitDate) {
  int id1 = int.parse("1" + "$id");
  int id2 = int.parse("2" + "$id");
  String body1 = 'La fecha límite es hoy';
  String body2 = 'Ha vencido la fecha límite';

  if (todoLimitDate.isAfter(DateTime.now())) {
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    tz.initializeTimeZones();

    NotificationService().showNotification(id1, title, body1, todoLimitDate);
    debugPrint('[OK] Notification ready: $id1');
  } else {
    debugPrint('[WRN] Cannot show notification $id1: Time out of range');
  }

  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  NotificationService().showNotification(
      id2, title, body2, todoLimitDate.add(Duration(days: 1)));
  debugPrint('[OK] Notification ready: $id2');
}

void buildNoteNotification(int id, String noteName, DateTime calendarDate) {
  String title = 'Tienes una nota';
  String body = 'Echa un vistazo a: $noteName';

  if (calendarDate.isAfter(DateTime.now())) {
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    tz.initializeTimeZones();

    NotificationService().showNotification(id, title, body, calendarDate);
    debugPrint('[OK] Notification ready: $id');
  } else {
    debugPrint('[WRN] Cannot show notification $id: Time out of range');
  }
}

cancelAllEventNotifications(int eventId) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int not1 = int.parse("1" + "$eventId");
  int not2 = int.parse("2" + "$eventId");
  int not3 = int.parse("3" + "$eventId");
  int not4 = int.parse("4" + "$eventId");
  int not5 = int.parse("5" + "$eventId");

  await flutterLocalNotificationsPlugin.cancel(not1);
  await flutterLocalNotificationsPlugin.cancel(not2);
  await flutterLocalNotificationsPlugin.cancel(not3);
  await flutterLocalNotificationsPlugin.cancel(not4);
  await flutterLocalNotificationsPlugin.cancel(not5);

  debugPrint('[OK] All notifications canceled for event $eventId');
}

cancelAllTodoNotifications(int todoId) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int not1 = int.parse("1" + "$todoId");
  int not2 = int.parse("2" + "$todoId");

  await flutterLocalNotificationsPlugin.cancel(not1);
  await flutterLocalNotificationsPlugin.cancel(not2);

  debugPrint('[OK] All notifications canceled for todo $todoId');
}

cancelNoteNotification(int noteId) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.cancel(noteId);

  debugPrint('[OK] All notifications canceled for note $noteId');
}

String formatEventNotificationDate(DateTime dateTime) {
  String formattedDate = 'El ';
  if (formatDates == true)
    formattedDate = formattedDate + DateFormat('dd/MM/yyyy').format(dateTime);
  else
    formattedDate = formattedDate + DateFormat('MM/dd/yyyy').format(dateTime);

  formattedDate = formattedDate + ' a las ';

  if (format24Hours == true)
    formattedDate = formattedDate + DateFormat('H:mm').format(dateTime);
  else
    formattedDate = formattedDate + DateFormat('K:mm aa').format(dateTime);

  return formattedDate;
}

void tryLaunchUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw "[ERR] Cannot launch URL: $url";
  }
}
