import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/notification_service.dart';
import 'package:social_share/social_share.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/all_classes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
                            AppLocalizations.of(context)!.dayMonday,
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
                            AppLocalizations.of(context)!.dayTuesday,
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
                            AppLocalizations.of(context)!.dayWednesday,
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
                            AppLocalizations.of(context)!.dayThursday,
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
                            AppLocalizations.of(context)!.dayFriday,
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
                            AppLocalizations.of(context)!.daySaturday,
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
                            AppLocalizations.of(context)!.daySunday,
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

int yearToInt(DateTime dateTime) {
  return int.parse(DateFormat('yyyy').format(dateTime));
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
    DateTime eventDate, DateTime eventTime, BuildContext context) {
  final dt = DateTime(eventDate.year, eventDate.month, eventDate.day, eventTime.hour, eventTime.minute);

  String body = AppLocalizations.of(context)!.isOn;
  if (formatDates == true)
    body = body + DateFormat('dd/MM/yyyy').format(dt);
  else
    body = body + DateFormat('MM/dd/yyyy').format(dt);
  body = body + AppLocalizations.of(context)!.at;
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

void buildTodoNotifications(int id, String title, DateTime todoLimitDate, BuildContext context) {
  int id1 = int.parse("1" + "$id");
  int id2 = int.parse("2" + "$id");
  String body1 = AppLocalizations.of(context)!.dueDateToday;
  String body2 = AppLocalizations.of(context)!.dueDateExpired;

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

void buildNoteNotification(int id, String noteName, DateTime calendarDate, BuildContext context) {

  if (noteName == '') noteName = AppLocalizations.of(context)!.noTitle;
  String title = AppLocalizations.of(context)!.haveANote;
  String body = noteName;

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

String formatEventNotificationDate(DateTime dateTime, BuildContext context) {
  String formattedDate = AppLocalizations.of(context)!.on;
  if (formatDates == true)
    formattedDate = formattedDate + DateFormat('dd/MM/yyyy').format(dateTime);
  else
    formattedDate = formattedDate + DateFormat('MM/dd/yyyy').format(dateTime);

  formattedDate = formattedDate + AppLocalizations.of(context)!.at;

  if (format24Hours == true)
    formattedDate = formattedDate + DateFormat('H:mm').format(dateTime);
  else
    formattedDate = formattedDate + DateFormat('K:mm aa').format(dateTime);

  return formattedDate;
}

String dayIdToString(int day, BuildContext context) {
  List<String> strings = [
    '[Index 0]',
    AppLocalizations.of(context)!.dayMonday,
    AppLocalizations.of(context)!.dayTuesday,
    AppLocalizations.of(context)!.dayWednesday,
    AppLocalizations.of(context)!.dayThursday,
    AppLocalizations.of(context)!.dayFriday,
    AppLocalizations.of(context)!.daySaturday,
    AppLocalizations.of(context)!.daySunday
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

String buildEventShareText(Event event, BuildContext context) {
  String text = AppLocalizations.of(context)!.event + ': ';
  text += (event.name + "\n");
  if (event.description != "") text += (event.description + "\n");
  text += "\n";
  if (!event.routineEvent) text += (AppLocalizations.of(context)!.on + dateToString(event.date) + "\n");
  text += (AppLocalizations.of(context)!.atCapital + timeToString(event.time));

  if (event.routineEvent){
    text += "\n\n" + AppLocalizations.of(context)!.routineDays + ': ';
    if (event.routinesList.contains(1)) text += "\n • " + dayToString(1, context);
    if (event.routinesList.contains(2)) text += "\n • " + dayToString(2, context);
    if (event.routinesList.contains(3)) text += "\n • " + dayToString(3, context);
    if (event.routinesList.contains(4)) text += "\n • " + dayToString(4, context);
    if (event.routinesList.contains(5)) text += "\n • " + dayToString(5, context);
    if (event.routinesList.contains(6)) text += "\n • " + dayToString(6, context);
    if (event.routinesList.contains(7)) text += "\n • " + dayToString(7, context);
  }

  return text;
}

String buildTodoShareText(Todo todo, BuildContext context) {
  String text = AppLocalizations.of(context)!.toDo + ': ';
  text += (todo.name + "\n");
  if (todo.description != "") text += (todo.description + "\n");
  text += "\n";
  if (todo.limited) text += (AppLocalizations.of(context)!.dueDate + ': ' + dateToString(todo.limitDate) + "\n");
  text += AppLocalizations.of(context)!.priority + ': ';
  if (todo.priority == 1) text+= AppLocalizations.of(context)!.low + '\n';
  else if (todo.priority == 2) text+= AppLocalizations.of(context)!.medium + '\n';
  else text += AppLocalizations.of(context)!.high + '\n';
  text += "\n";
  text += AppLocalizations.of(context)!.status + ': ';
  if (todo.done) text += AppLocalizations.of(context)!.completed;
  else text += AppLocalizations.of(context)!.pending;

  return text;
}

String buildNoteShareText(Note note, BuildContext context) {
  String text = AppLocalizations.of(context)!.note;
  if (note.name != "") text += (": " + note.name + "\n\n");
  else text += (": " + AppLocalizations.of(context)!.noTitle + ".\n\n");

  if (note.content != "") text += note.content;
  else text += AppLocalizations.of(context)!.noContent + '.';

  return text;
}

String buildRoutineShareText(int day, BuildContext context) {

  String dayText = dayToString(day, context);
  String text = AppLocalizations.of(context)!.routine + ": $dayText\n";

  if (selectedRoutineEvents.length > 0){
    for(int i=0; i<selectedRoutineEvents.length; i++){
      text += ("\n" + timeToString(selectedRoutineEvents[i].time) + " - "
          + selectedRoutineEvents[i].name);
    }
  } else text += AppLocalizations.of(context)!.noEvents + '.';

  return text;
}

Future<void> socialShare(dynamic element, BuildContext context) async {
  late String text;

  if (element is Event) text = buildEventShareText(element, context);
  else if (element is Todo) text = buildTodoShareText(element, context);
  else if (element is Note) text = buildNoteShareText(element, context);
  else if (element is int) text = buildRoutineShareText(element, context);
  else debugPrint("[ERR] 'element' type didn't match.");

  text += "\n\n" + AppLocalizations.of(context)!.createdSimplex;

  debugPrint("[OK] Generated text:\n" + text + "\n");

  await SocialShare.shareOptions(text);
}

String dayToString(int day, BuildContext context){

  if (day == 1) return AppLocalizations.of(context)!.dayMonday;
  else if (day == 2) return AppLocalizations.of(context)!.dayTuesday;
  else if (day == 3) return AppLocalizations.of(context)!.dayWednesday;
  else if (day == 4) return AppLocalizations.of(context)!.dayThursday;
  else if (day == 5) return AppLocalizations.of(context)!.dayFriday;
  else if (day == 6) return AppLocalizations.of(context)!.daySaturday;
  else return AppLocalizations.of(context)!.daySunday;

}

String dayToChar(int day, BuildContext context){

  if (day == 1) return AppLocalizations.of(context)!.charMonday;
  else if (day == 2) return AppLocalizations.of(context)!.charTuesday;
  else if (day == 3) return AppLocalizations.of(context)!.charWednesday;
  else if (day == 4) return AppLocalizations.of(context)!.charThursday;
  else if (day == 5) return AppLocalizations.of(context)!.charFriday;
  else if (day == 6) return AppLocalizations.of(context)!.charSaturday;
  else return AppLocalizations.of(context)!.charSunday;

}
