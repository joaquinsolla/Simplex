import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


String monthConversor(DateTime date){

  List months = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'];

  return (months[date.month-1]);
}

String dateToString(DateTime dateTime){
  if (formatDates == true) return DateFormat('dd/MM/yyyy').format(dateTime);
  else return DateFormat('MM/dd/yyyy').format(dateTime);
}

String timeToString(DateTime dateTime){
  if (format24Hours==true) return DateFormat('HH:mm').format(dateTime);
  else return DateFormat('h:mm aa').format(dateTime);
}

String millisecondsToStringTime(int millis){

  DateTime date = DateTime.fromMicrosecondsSinceEpoch(millis*1000);

  return timeToString(date);
}

bool showNotification(BuildContext context, int id, String title, DateTime notificationDateTime, DateTime eventDateTime){

  String body = 'Es el ';
  if (formatDates==true) body = body + DateFormat('dd/MM/yyyy').format(eventDateTime);
  else body = body + DateFormat('MM/dd/yyyy').format(eventDateTime);
  body = body + ' a las ';
  if (format24Hours==true) body = body + DateFormat('H:mm').format(eventDateTime);
  else body = body + DateFormat('K:mm aa').format(eventDateTime);

  if (notificationDateTime.isBefore(eventDateTime)){
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    tz.initializeTimeZones();

    NotificationService().showNotification(id, title, body, notificationDateTime);
    debugPrint('[OK] Notification ready: $id');
    return true;
  } else {
    debugPrint('[WRN] Cannot show notification: Time expired');
    return false;
  }
}

// TODO:update
cancelNotification(int notificationId) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancel(notificationId);
  debugPrint('[OK] Notification $notificationId canceled');
}

// TODO:update
cancelAllNotifications(int eventId) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int not5Min = int.parse("1"+"$eventId");
  int not1Hour = int.parse("2"+"$eventId");
  int not1Day = int.parse("3"+"$eventId");

  await flutterLocalNotificationsPlugin.cancel(not5Min);
  await flutterLocalNotificationsPlugin.cancel(not1Hour);
  await flutterLocalNotificationsPlugin.cancel(not1Day);

  debugPrint('[OK] All notifications canceled for event $eventId');
}

String formatNotificationDate(DateTime dateTime){
  String formattedDate = 'El ';
  if (formatDates==true) formattedDate = formattedDate + DateFormat('dd/MM/yyyy').format(dateTime);
  else formattedDate = formattedDate + DateFormat('MM/dd/yyyy').format(dateTime);

  formattedDate = formattedDate + ' a las ';

  if (format24Hours==true) formattedDate = formattedDate + DateFormat('H:mm').format(dateTime);
  else formattedDate = formattedDate + DateFormat('K:mm aa').format(dateTime);

  return formattedDate;
}