import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/notification_service.dart';
import 'package:social_share/social_share.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/all_classes.dart';


void showTextDialog(BuildContext context, IconData icon, String title, String content,
    String textAccept, String textCancel, Function() actionsAccept,
    Function() actionsCancel) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorSecondBackground,
          title: Wrap(children: [
            Icon(icon, color: colorMainText),
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

void showRoutinePickerDialog(BuildContext context, String title, List<bool> weekValues,
    String textAccept, Function() actionsAccept) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorSecondBackground,
          title: Text(title, style: TextStyle(color: colorMainText)),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Theme(
                      data: ThemeData(unselectedWidgetColor: colorMainText),
                      child: Column(children: [
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Lunes',
                            style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          value: weekValues[0],
                          onChanged: (val) {
                            setDialogState(() {
                              weekValues[0] = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Martes',
                            style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          value: weekValues[1],
                          onChanged: (val) {
                            setDialogState(() {
                              weekValues[1] = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Miércoles',
                            style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          value: weekValues[2],
                          onChanged: (val) {
                            setDialogState(() {
                              weekValues[2] = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Jueves',
                            style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          value: weekValues[3],
                          onChanged: (val) {
                            setDialogState(() {
                              weekValues[3] = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Viernes',
                            style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          value: weekValues[4],
                          onChanged: (val) {
                            setDialogState(() {
                              weekValues[4] = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Sábado',
                            style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          value: weekValues[5],
                          onChanged: (val) {
                            setDialogState(() {
                              weekValues[5] = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Domingo',
                            style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          value: weekValues[6],
                          onChanged: (val) {
                            setDialogState(() {
                              weekValues[6] = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],),
                    ),
                  ],
                );
              }
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

String buildEventShareText(Event event) {
  String text = "Evento: ";
  text += (event.name + "\n");
  if (event.description != "") text += (event.description + "\n");
  text += "\n";
  if (!event.routineEvent) text += ("El día " + dateToString(event.date) + "\n");
  text += ("A las " + timeToString(event.time));

  if (event.routineEvent){
    text += "\nRutina: ";
    if (event.routinesList.contains(0)) text += "\n - Lunes";
    if (event.routinesList.contains(1)) text += "\n - Martes";
    if (event.routinesList.contains(2)) text += "\n - Miércoles";
    if (event.routinesList.contains(3)) text += "\n - Jueves";
    if (event.routinesList.contains(4)) text += "\n - Viernes";
    if (event.routinesList.contains(5)) text += "\n - Sábado";
    if (event.routinesList.contains(6)) text += "\n - Domingo";
  }

  return text;
}

String buildTodoShareText(Todo todo) {
  String text = "Tarea: ";
  text += (todo.name + "\n");
  if (todo.description != "") text += (todo.description + "\n");
  if (todo.limited) text += ("Fecha límite: " + dateToString(todo.limitDate) + "\n");
  text += "Prioridad: ";
  if (todo.priority == 1) text+= "Baja\n";
  else if (todo.priority == 2) text+= "Media\n";
  else text += "Alta\n";
  text += "\n";
  text += "Estado: ";
  if (todo.done) text += "Completado";
  else text += "Pendiente";

  return text;
}

String buildNoteShareText(Note note) {
  String text = "Nota";
  if (note.name != "") text += (": " + note.name + "\n\n");
  if (note.content != "") text += note.content;
  else text += "Sin contenido.";

  return text;
}

Future<void> socialShare(dynamic element) async {
  String text = "";

  if (element is Event) text = buildEventShareText(element);
  else if (element is Todo) text = buildTodoShareText(element);
  else if (element is Note) text = buildNoteShareText(element);
  else debugPrint("[ERR] Routines share not implemented yet.");

  debugPrint("[OK] Generated text:\n" + text + "\n");

  // TODO: REVIEW
  await SocialShare.shareOptions(text);
}
