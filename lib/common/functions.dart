import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/services/notification_service.dart';
import 'package:simplex/services/sqlite_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simplex/common/all_common.dart';


String monthConversor(DateTime date){

  List months = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'];

  return (months[date.month-1]);
}

String datetimeToString(DateTime dateTime){
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

String stringDateToYMD(String date){
  String reversedDate = date.substring(6) + '-' +
  date.substring(3, 5) + '-' +
  date.substring(0, 2);

  return reversedDate;
}

bool showNotification(BuildContext context, int id, String title, int daysBefore, DateTime now, DateTime eventDay){

  int today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  late int notificationDay;
  if (daysBefore!=30) {
    notificationDay = DateTime(eventDay.year, eventDay.month, eventDay.day-daysBefore).millisecondsSinceEpoch;
  } else {
    notificationDay = DateTime(eventDay.year, eventDay.month-1, eventDay.day).millisecondsSinceEpoch;
  }

  if (notificationDay > today){
    int milliNow = now.millisecondsSinceEpoch;
    late String body;

    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    tz.initializeTimeZones();
    if (daysBefore == 1) {
      body = '¡Es mañana!';
    } else if (daysBefore == 7) {
      body = '¡Es en una semana!';
    } else {
      body = '¡Es en un mes!';
    }
    NotificationService().showNotification(id, title, body, notificationDay-milliNow + 1000);
    debugPrint('[OK] Notification with id: $id ready for $daysBefore days before the event');
    return true;
  } else {
    return false;
  }
}

Future<void> cancelNotification(int notificationId) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancel(notificationId);
  debugPrint('[OK] Notification canceled');
}