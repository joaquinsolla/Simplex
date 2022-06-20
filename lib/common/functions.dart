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

bool showNotification(BuildContext context, int id, String title, int notificationType, DateTime nowDateTime, DateTime eventDateTime){

  late Duration duration;
  late String body;
  if (notificationType == 1) {
    duration = Duration(minutes: 5);
    body = 'Es en 5 minutos';
  } else if (notificationType == 2) {
    duration = Duration(hours: 1);
    body = 'Es en 1 hora';
  } else {
    duration = Duration(days: 1);
    body = 'Es mañana';
  }

  int milliNow = nowDateTime.millisecondsSinceEpoch;
  int milliNotification = eventDateTime.subtract(duration).millisecondsSinceEpoch;
  int millisToNotification = milliNotification-milliNow;

  if (millisToNotification>0){
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    tz.initializeTimeZones();

    NotificationService().showNotification(id, title, body, millisToNotification + 1000);
    debugPrint('[OK] Notification with id: $id ready');
    return true;
  } else {
    debugPrint('[OK] Cannot show notification: Time expired');
    return false;
  }
}

cancelNotification(int notificationId) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancel(notificationId);
  debugPrint('[OK] Notification $notificationId canceled');
}

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