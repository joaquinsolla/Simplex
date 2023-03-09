import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';


void showTextDialog(BuildContext context, Widget icon, String title, String content,
    String textAccept, String textCancel, Function() actionsAccept,
    Function() actionsCancel) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorSecondBackground,
          title: Wrap(children: [
            icon,
            Text(' '+title, style: TextStyle(color: colorMainText))
          ],),
          content: Text(content, style: TextStyle(color: colorMainText)),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    colorMainText.withOpacity(0.1)),
              ),
              onPressed: actionsAccept,
              child: Text(textAccept, style: TextStyle(color: colorMainText),),
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    Colors.red.withOpacity(0.1)),
              ),
              onPressed: actionsCancel,
              child: Text(textCancel, style: TextStyle(color: Colors.red),),
            )
          ],
        );
      });
}

void showWidgetDialog(BuildContext context, String title, List<Widget> content,
    String textAccept, Function() actionsAccept) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorSecondBackground,
          title: Text(title, style: TextStyle(color: colorMainText)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: content,
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    colorMainText.withOpacity(0.1)),
              ),
              onPressed: actionsAccept,
              child: Text(textAccept, style: TextStyle(color: colorMainText),),
            ),
          ],
        );
      });
}

void showErrorSnackBar(BuildContext context, String content) {

  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(milliseconds: 2000),
  ));

}

void showInfoSnackBar(BuildContext context, String content) {

  // MAX: 0.1 on length 35
  // MIN: 0.425 on length 1
  late double sideMarginProportion;

  if (content.length<35){
    sideMarginProportion = 0.425 - (content.length * 0.0098 * fontSize);
  } else {
    sideMarginProportion = 0.1;
  }

  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child:Image.asset('assets/icon_rounded.png', width: 20*fontSize, height: 20*fontSize,),
          ),
          Container(
            width: deviceWidth - (deviceWidth*sideMarginProportion*2) - (20*fontSize + 30),
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(content,
              style: TextStyle(
                fontSize: 14*fontSize,
              ),
            ),
          )
        ],
      ),
      duration: const Duration(milliseconds: 2000),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.fromLTRB(deviceWidth*sideMarginProportion, 0,
          deviceWidth*sideMarginProportion, deviceHeight*0.15),
    ),
  );

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

// TODO: review UTC
String timeToString(DateTime time) {
  if (format24Hours == true)
    return DateFormat('HH:mm').format(time);
  else
    return DateFormat('h:mm aa').format(time);
}

String timeOfDayToSpecificString(TimeOfDay time, String timeFormat) {
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute).toUtc();

  return DateFormat(timeFormat).format(dt);
}

void buildEventNotification(int id, String title, DateTime notificationDateTime,
    DateTime eventDate, DateTime eventTime) {
  final dt = DateTime(eventDate.year, eventDate.month, eventDate.day, eventTime.hour, eventTime.minute);

  String body = 'Es el ';
  if (formatDates == true)
    body = body + DateFormat('dd/MM/yyyy').format(dt);
  else
    body = body + DateFormat('MM/dd/yyyy').format(dt);
  body = body + ' a las ';
  if (format24Hours == true)
    body = body + DateFormat('H:mm').format(dt);
  else
    body = body + DateFormat('K:mm aa').format(dt);

  if (notificationDateTime.isBefore(dt) &&
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

  if (noteName == '') noteName = 'Sin título';
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

void buildNotificationNow() {
  /// TESTING METHOD

  DateTime dateTime = DateTime.now().add(const Duration(seconds: 5));
  int id = dateTime.millisecondsSinceEpoch;
  String title = '[TEST] Notificación';
  String body = 'Mostrada el ' + dateToString(dateTime) +
      ' a las ' + timeToString(dateTime);

  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  NotificationService().showNotification(id, title, body, dateTime);
  debugPrint('[OK] Testing notification ready: $id');

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

String dayIdToString(int day) {
  List<String> strings = [
    '[Index 0]',
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  return strings[day];
}

int timeOfDayToMilliseconds(TimeOfDay time) {
  return time.hour * 3600000 + time.minute * 60000;
}

TimeOfDay millisecondsToTimeOfDay(int milliseconds) {
  return TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(milliseconds));
}

void tryLaunchUrl(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw "[ERR] Cannot launch URL: $url";
  }
}
