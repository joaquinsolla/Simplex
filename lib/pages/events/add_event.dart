import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode timeFocusNode = FocusNode();

  int id = int.parse((DateTime.now().millisecondsSinceEpoch).toString().substring(6));
  DateTime date = selectedDateTime;
  DateTime time = DateTime(1900, 1, 1, 0, 0);
  int color = -1;

  List<dynamic> notificationsList = [];
  Map<String?, DateTime?> not1 = {null: null};
  Map<String?, DateTime?> not2 = {null: null};
  Map<String?, DateTime?> not3 = {null: null};
  Map<String?, DateTime?> not4 = {null: null};
  Map<String?, DateTime?> not5 = {null: null};

  List<dynamic> routinesList = [];
  List<bool> weekValues = [false, false, false, false, false, false, false];
  bool routineEvent = false;

  Color errorColor = colorSecondBackground;
  bool daysSelected = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    dateController.text = dateToString(selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {

    String timeHintText = AppLocalizations.of(context)!.timeHintDefault0000;
    if (format24Hours == false) timeHintText = AppLocalizations.of(context)!.timeHintDefault1200AM;
    String dateHintText = AppLocalizations.of(context)!.dateHintDefaultToday;

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(
          null,
          PageHeader(context, AppLocalizations.of(context)!.newEvent),
          FooterEmpty(),
          [
            FormSwitchButton(AppLocalizations.of(context)!.once, AppLocalizations.of(context)!.routine, routineEvent, (){
              setState(() {
                routineEvent = !routineEvent;
              });
            }),
            FormSeparator(),
            FormContainer([
              FormTextField(
                  nameController, AppLocalizations.of(context)!.name + ':', AppLocalizations.of(context)!.mandatory, nameFocusNode, false),
              FormTextField(descriptionController, AppLocalizations.of(context)!.description + ':', AppLocalizations.of(context)!.optional,
                  descriptionFocusNode, true),
            ]),
            FormSeparator(),
            FormContainer([
              if(!routineEvent) FormDateTimeSelector(
                  dateController,
                  AppLocalizations.of(context)!.date + ":",
                  dateHintText,
                  dateFocusNode,
                    () => _dateSelector(context),
                  false
              ),
              FormDateTimeSelector(
                  timeController,
                AppLocalizations.of(context)!.time + ":",
                  timeHintText,
                  timeFocusNode,
                    () => _timeSelector(context),
                  true,
              ),
            ]),
            FormSeparator(),
            FormContainer([
              FormColorPicker(
                  context,
                  AppLocalizations.of(context)!.colour + ':',
                  AppLocalizations.of(context)!.eventColour + ':',
                  color,
                  [
                    Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: colorThirdBackground,
                          disabledColor: colorThirdBackground,
                        ),
                        child: RadioListTile(
                          title: Text(AppLocalizations.of(context)!.byDefault, style: TextStyle(color: colorMainText),),
                          value: -1,
                          groupValue: color,
                          activeColor: colorThirdBackground,
                          onChanged: (val) {
                            setState(() {
                              color = val as int;
                            });
                            Navigator.pop(context);
                          },
                        ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: const Color(0xffF44336),
                        disabledColor: const Color(0xffF44336),
                      ),
                      child: RadioListTile(
                        title: Text(AppLocalizations.of(context)!.colourRed, style: TextStyle(color: colorMainText)),
                        value: 0xffF44336,
                        groupValue: color,
                        activeColor: const Color(0xffF44336),
                        onChanged: (val) {
                          setState(() {
                            color = val as int;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: const Color(0xffFF9800),
                        disabledColor: const Color(0xffFF9800),
                      ),
                      child: RadioListTile(
                        title: Text(AppLocalizations.of(context)!.colourOrange, style: TextStyle(color: colorMainText)),
                        value: 0xffFF9800,
                        groupValue: color,
                        activeColor: const Color(0xffFF9800),
                        onChanged: (val) {
                          setState(() {
                            color = val as int;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: const Color(0xffFFCC00),
                        disabledColor: const Color(0xffFFCC00),
                      ),
                      child: RadioListTile(
                        title: Text(AppLocalizations.of(context)!.colourYellow, style: TextStyle(color: colorMainText)),
                        value: 0xffFFCC00,
                        groupValue: color,
                        activeColor: const Color(0xffFFCC00),
                        onChanged: (val) {
                          setState(() {
                            color = val as int;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: const Color(0xff4CAF50),
                        disabledColor: const Color(0xff4CAF50),
                      ),
                      child: RadioListTile(
                        title: Text(AppLocalizations.of(context)!.colourGreen, style: TextStyle(color: colorMainText)),
                        value: 0xff4CAF50,
                        groupValue: color,
                        activeColor: const Color(0xff4CAF50),
                        onChanged: (val) {
                          setState(() {
                            color = val as int;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: const Color(0xff448AFF),
                        disabledColor: const Color(0xff448AFF),
                      ),
                      child: RadioListTile(
                        title: Text(AppLocalizations.of(context)!.colourBlue, style: TextStyle(color: colorMainText)),
                        value: 0xff448AFF,
                        groupValue: color,
                        activeColor: const Color(0xff448AFF),
                        onChanged: (val) {
                          setState(() {
                            color = val as int;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: const Color(0xff7C4DFF),
                        disabledColor: const Color(0xff7C4DFF),
                      ),
                      child: RadioListTile(
                        title: Text(AppLocalizations.of(context)!.colourPurple, style: TextStyle(color: colorMainText)),
                        value: 0xff7C4DFF,
                        groupValue: color,
                        activeColor: const Color(0xff7C4DFF),
                        onChanged: (val) {
                          setState(() {
                            color = val as int;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            if(routineEvent) FormContainerWithBorder(
                errorColor,
                [
                  FormCustomField(
                      AppLocalizations.of(context)!.routineDays + ':',
                      [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              if(weekValues[0]==true) Container(
                                height: deviceHeight*0.035,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check, color: colorSpecialItem, size: deviceWidth*0.05,),
                                    SizedBox(width: deviceWidth*0.025,),
                                    Text(AppLocalizations.of(context)!.dayMonday,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              if(weekValues[0]==true) Divider(color: colorSecondText,),
                              if(weekValues[1]==true) Container(
                                height: deviceHeight*0.035,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check, color: colorSpecialItem, size: deviceWidth*0.05,),
                                    SizedBox(width: deviceWidth*0.025,),
                                    Text(AppLocalizations.of(context)!.dayTuesday,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              if(weekValues[1]==true) Divider(color: colorSecondText,),
                              if(weekValues[2]==true) Container(
                                height: deviceHeight*0.035,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check, color: colorSpecialItem, size: deviceWidth*0.05,),
                                    SizedBox(width: deviceWidth*0.025,),
                                    Text(AppLocalizations.of(context)!.dayWednesday,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              if(weekValues[2]==true) Divider(color: colorSecondText,),
                              if(weekValues[3]==true) Container(
                                height: deviceHeight*0.035,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check, color: colorSpecialItem, size: deviceWidth*0.05,),
                                    SizedBox(width: deviceWidth*0.025,),
                                    Text(AppLocalizations.of(context)!.dayThursday,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              if(weekValues[3]==true) Divider(color: colorSecondText,),
                              if(weekValues[4]==true) Container(
                                height: deviceHeight*0.035,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check, color: colorSpecialItem, size: deviceWidth*0.05,),
                                    SizedBox(width: deviceWidth*0.025,),
                                    Text(AppLocalizations.of(context)!.dayFriday,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              if(weekValues[4]==true) Divider(color: colorSecondText,),
                              if(weekValues[5]==true) Container(
                                height: deviceHeight*0.035,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check, color: colorSpecialItem, size: deviceWidth*0.05,),
                                    SizedBox(width: deviceWidth*0.025,),
                                    Text(AppLocalizations.of(context)!.daySaturday,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              if(weekValues[5]==true) Divider(color: colorSecondText,),
                              if(weekValues[6]==true) Container(
                                height: deviceHeight*0.035,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check, color: colorSpecialItem, size: deviceWidth*0.05,),
                                    SizedBox(width: deviceWidth*0.025,),
                                    Text(AppLocalizations.of(context)!.daySunday,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              if(weekValues[6]==true) Divider(color: colorSecondText,),
                            ],),
                            TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.loop_rounded, color: colorSpecialItem,
                                    size: deviceWidth * 0.055,),
                                  Text(' ' + AppLocalizations.of(context)!.manageDays + ' ', style: TextStyle(
                                      color: colorSpecialItem,
                                      fontSize: deviceWidth * fontSize * 0.04,
                                      fontWeight: FontWeight.normal),),
                                  Icon(Icons.loop_rounded, color: Colors.transparent,
                                    size: deviceWidth * 0.055,),
                                ],
                              ),
                              onPressed: () {
                                showRoutinePickerDialog(
                                    context,
                                    AppLocalizations.of(context)!.routineDays + ':',
                                    weekValues,
                                    AppLocalizations.of(context)!.done,
                                        () {
                                      setState(() {
                                        // Updates the weekDays list
                                        errorColor = colorSecondBackground;
                                      });
                                      Navigator.pop(context);
                                    }
                                );
                              },
                            )
                          ],
                        ),
                      ],
                      true
                  ),
                ]
            ),
            if(routineEvent) FormSeparator(),
            if(!routineEvent) FormContainer([
              FormCustomField(
                  AppLocalizations.of(context)!.notifications,
                  [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(notificationsList.length, (index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(formatEventNotificationDate(
                                      notificationsList[index].values.first),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.04,
                                        fontWeight: FontWeight.normal),),
                                  Expanded(child: Text(''),),
                                  Icon(Icons.delete_outline_rounded, color: Colors.red,
                                    size: deviceWidth * 0.055,),
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  if (not1.keys.first ==
                                      notificationsList[index].keys.first) {
                                    notificationsList.remove(not1);
                                    not1 = {null: null};
                                  } else if (not2.keys.first ==
                                      notificationsList[index].keys.first) {
                                    notificationsList.remove(not2);
                                    not2 = {null: null};
                                  } else if (not3.keys.first ==
                                      notificationsList[index].keys.first) {
                                    notificationsList.remove(not3);
                                    not3 = {null: null};
                                  } else if (not4.keys.first ==
                                      notificationsList[index].keys.first) {
                                    notificationsList.remove(not4);
                                    not4 = {null: null};
                                  } else {
                                    notificationsList.remove(not5);
                                    not5 = {null: null};
                                  }
                                });
                              },
                            ),
                            if (index < 4) Divider(color: colorSecondText,),
                          ],
                        );
                      }),
                    ),
                    if (notificationsList.length == 0) TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.noNotifications,
                            style: TextStyle(
                              color: colorSecondText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),),
                        ],
                      ),
                      onPressed: (){},
                    ),
                    if (notificationsList.length == 0) Divider(color: colorSecondText,),
                    if (notificationsList.length < 5) TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded, color: colorSpecialItem,
                            size: deviceWidth * 0.055,),
                          Text(' ' + AppLocalizations.of(context)!.addNotification + ' ', style: TextStyle(
                              color: colorSpecialItem,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal),),
                          Icon(Icons.add_rounded, color: Colors.transparent,
                            size: deviceWidth * 0.055,),
                        ],
                      ),
                      onPressed: () async {
                        late String notId;
                        late DateTime notDate;
                        late TimeOfDay notTime;
                        late DateTime notDateTime;

                        final DateTime? dateSelected = await showDatePicker(
                          context: context,
                          locale: appLocale,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2099, 12, 31),
                          helpText: AppLocalizations.of(context)!.calendarSelectNotificationDate,
                          cancelText: AppLocalizations.of(context)!.calendarCancel,
                          confirmText: AppLocalizations.of(context)!.calendarConfirm,
                          fieldHintText: AppLocalizations.of(context)!.calendarHintDDMMYYYY,
                          fieldLabelText: AppLocalizations.of(context)!.calendarNotificationDate,
                          errorFormatText: AppLocalizations.of(context)!.calendarErrorDate,
                          builder: (context, child) {
                            if (darkMode) return Theme(
                              data: ThemeData.dark().copyWith(
                                primaryColor: colorSpecialItem,
                                colorScheme: ColorScheme.dark(
                                    primary: colorSpecialItem),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary
                                ),
                              ),
                              child: child!,
                            );
                            else return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: colorSpecialItem,
                                colorScheme: ColorScheme.light(
                                    primary: colorSpecialItem),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (dateSelected != null) {
                          notDate = dateSelected;
                          final TimeOfDay? timeSelected = await showTimePicker(
                            context: context,
                            helpText: AppLocalizations.of(context)!.timePickerSelectNotificationTime,
                            cancelText: AppLocalizations.of(context)!.calendarCancel,
                            confirmText: AppLocalizations.of(context)!.calendarConfirm,
                            initialTime: TimeOfDay(hour: 0, minute: 0),
                            initialEntryMode: TimePickerEntryMode.dial,
                            builder: (context, child) {
                              if (darkMode) return Theme(
                                data: ThemeData.dark().copyWith(
                                  primaryColor: colorSpecialItem,
                                  colorScheme: ColorScheme.dark(
                                    primary: colorSpecialItem,),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary
                                  ),
                                ),
                                child: child!,
                              );
                              else return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: colorSpecialItem,
                                  colorScheme: ColorScheme.light(
                                      primary: colorSpecialItem),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (timeSelected != null) {
                            notTime = timeSelected;
                            notDateTime = DateTime(
                                notDate.year, notDate.month, notDate.day, notTime.hour,
                                notTime.minute);
                            setState(() {
                              if (not1.keys.first == null) {
                                notId = '1' + '$id';
                                not1 = {notId: notDateTime};
                                notificationsList.add(not1);
                              } else if (not2.keys.first == null) {
                                notId = ('2' + '$id');
                                not2 = {notId: notDateTime};
                                notificationsList.add(not2);
                              } else if (not3.keys.first == null) {
                                notId = ('3' + '$id');
                                not3 = {notId: notDateTime};
                                notificationsList.add(not3);
                              } else if (not4.keys.first == null) {
                                notId = ('4' + '$id');
                                not4 = {notId: notDateTime};
                                notificationsList.add(not4);
                              } else {
                                notId = ('5' + '$id');
                                not5 = {notId: notDateTime};
                                notificationsList.add(not5);
                              }
                            });
                          }
                        }
                      },
                    ),
                  ],
                  true),
            ]),
            if(!routineEvent) FormSeparator(),
            MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' ' + AppLocalizations.of(context)!.createEvent + ' ',
                    () {
                  if (nameController.text.trim().isEmpty) {
                    showErrorSnackBar(context, AppLocalizations.of(context)!.errorTypeName);
                    nameFocusNode.requestFocus();
                  } else {
                    weekValues.forEach((value) {
                      if (value==true) daysSelected=true;
                    });
                    if (routineEvent && daysSelected==false){
                      showErrorSnackBar(context, AppLocalizations.of(context)!.errorSelectRoutineDays);
                      setState(() {
                        errorColor = Colors.red;
                      });
                    } else {
                      try {
                        if(routineEvent) _addEventRoutines();
                        Event newEvent = Event(
                          id: id,
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          date: date,
                          time: time,
                          color: color,
                          notificationsList: notificationsList,
                          routinesList: routinesList,
                          routineEvent: routineEvent,
                        );
                        createEvent(newEvent);
                        if(!routineEvent) _buildAllEventNotifications();
                        Navigator.pop(context);
                        showInfoSnackBar(context, AppLocalizations.of(context)!.eventCreated);
                      } on Exception catch (e) {
                        debugPrint('[ERR] Could not create event: $e');
                        showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
                      }
                    }
                  }
                }
            ),
          ]
      ),
    );
  }

  _dateSelector(BuildContext context) async {
    var dateFormat = DateFormat('dd/MM/yyyy');
    if (formatDates == false) dateFormat = DateFormat('MM/dd/yyyy');

    final DateTime? selected = await showDatePicker(
        context: context,
        locale: appLocale,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1, 1),
        lastDate: DateTime(2099, 12, 31),
        helpText: AppLocalizations.of(context)!.calendarSelectEventDate,
        cancelText: AppLocalizations.of(context)!.calendarCancel,
        confirmText: AppLocalizations.of(context)!.calendarConfirm,
        fieldHintText: AppLocalizations.of(context)!.calendarHintDDMMYYYY,
        fieldLabelText: AppLocalizations.of(context)!.calendarEventDate,
        errorFormatText: AppLocalizations.of(context)!.calendarErrorDate,
        builder: (context, child) {
          if (darkMode) return Theme(
            data: ThemeData.dark().copyWith(
              primaryColor: colorSpecialItem,
              colorScheme: ColorScheme.dark(
                  primary: colorSpecialItem),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child!,
          );
          else return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: colorSpecialItem,
              colorScheme: ColorScheme.light(
                  primary: colorSpecialItem),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child!,
          );
        },
    );
    if (selected != null && selected != DateTime.now()) {
      setState(() {
        date=selected;
        dateController.text = dateFormat.format(selected);
      });
    }
  }

  _timeSelector(BuildContext context) async {
    var timeFormat = DateFormat("HH:mm");
    if (format24Hours == false) timeFormat = DateFormat("h:mm aa");

    final TimeOfDay? selected = await showTimePicker(
      context: context,
      helpText: AppLocalizations.of(context)!.timePickerSelectEventTime,
      cancelText: AppLocalizations.of(context)!.calendarCancel,
      confirmText: AppLocalizations.of(context)!.calendarConfirm,
      initialTime: TimeOfDay(hour: 0, minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        if (darkMode) return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: colorSpecialItem,
            colorScheme: ColorScheme.dark(
              primary: colorSpecialItem,),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child!,
        );
        else return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: colorSpecialItem,
            colorScheme: ColorScheme.light(
                primary: colorSpecialItem),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null) {
      setState(() {
        time = DateTime(1900, 01, 01, selected.hour, selected.minute);
        timeController.text = timeFormat.format(time);
      });
    }
  }

  _buildAllEventNotifications(){
    String notificationTitle = AppLocalizations.of(context)!.event + ': ' + nameController.text;
    if (not1.keys.first != null) buildEventNotification(
        int.parse(not1.keys.first!),
        notificationTitle, not1.values.first!,
        date, time);
    if (not2.keys.first != null) buildEventNotification(
        int.parse(not2.keys.first!),
        notificationTitle, not2.values.first!,
        date, time);
    if (not3.keys.first != null) buildEventNotification(
        int.parse(not3.keys.first!),
        notificationTitle, not3.values.first!,
        date, time);
    if (not4.keys.first != null) buildEventNotification(
        int.parse(not4.keys.first!),
        notificationTitle, not4.values.first!,
        date, time);
    if (not5.keys.first != null) buildEventNotification(
        int.parse(not5.keys.first!),
        notificationTitle, not5.values.first!,
        date, time);
  }

  _addEventRoutines(){
    for(int i=0; i<7; i++){
      if (weekValues[i]==true) routinesList.add(i+1);
    }
  }

}
