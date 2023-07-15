import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/classes/note.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddRoutineElement extends StatefulWidget {
  const AddRoutineElement({Key? key}) : super(key: key);

  @override
  _AddRoutineElementState createState() => _AddRoutineElementState();
}

class _AddRoutineElementState extends State<AddRoutineElement> {

  bool isNote = false;  // if false, it is an event

  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventTimeController = TextEditingController();

  final noteNameController = TextEditingController();
  final noteContentController = TextEditingController();
  final noteCalendarDateController = TextEditingController();

  FocusNode eventNameFocusNode = FocusNode();
  FocusNode eventDescriptionFocusNode = FocusNode();
  FocusNode eventTimeFocusNode = FocusNode();

  FocusNode noteNameFocusNode = FocusNode();
  FocusNode noteContentFocusNode = FocusNode();

  int id = int.parse((DateTime.now().millisecondsSinceEpoch).toString().substring(6));
  DateTime eventTime = DateTime(1900, 1, 1, 0, 0);
  int eventColor = -1;

  List<dynamic> routinesList = [];
  List<bool> weekValues = [false, false, false, false, false, false, false];

  Color errorColor = colorSecondBackground;
  bool daysSelected = false;

  bool noteOnCalendar = false;
  DateTime noteCalendarDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);


  @override
  void dispose() {
    super.dispose();
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventTimeController.dispose();

    noteNameController.dispose();
    noteContentController.dispose();
    noteCalendarDateController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String eventTimeHintText = AppLocalizations.of(context)!.timeHintDefault0000;
    String noteDateHintText = AppLocalizations.of(context)!.dateHintDefaultToday;
    if (format24Hours == false) eventTimeHintText = AppLocalizations.of(context)!.timeHintDefault1200AM;

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(
          null,
          PageHeader(context, AppLocalizations.of(context)!.toAddToRoutine),
          FooterEmpty(),
          [
            FormSwitchButton(AppLocalizations.of(context)!.event, AppLocalizations.of(context)!.note, isNote, (){
              setState(() {
                isNote = !isNote;
              });
            }),
            FormSeparator(),

            if(!isNote) FormContainer([
              FormTextField(
                  eventNameController, AppLocalizations.of(context)!.name + ':', AppLocalizations.of(context)!.mandatory, eventNameFocusNode, false),
              FormTextField(eventDescriptionController, AppLocalizations.of(context)!.description, AppLocalizations.of(context)!.optional,
                  eventDescriptionFocusNode, true),
            ]),
            if(isNote) FormContainer([
              FormTextField(
                  noteNameController, AppLocalizations.of(context)!.title + ':', AppLocalizations.of(context)!.optional, noteNameFocusNode, false),
              FormTextFieldMultiline(
                  noteContentController, AppLocalizations.of(context)!.content + ':', AppLocalizations.of(context)!.optional, noteContentFocusNode, true),
            ]),
            FormSeparator(),

            if(!isNote) FormContainer([
              FormDateTimeSelector(
                eventTimeController,
                AppLocalizations.of(context)!.time + ':',
                eventTimeHintText,
                eventTimeFocusNode,
                    () => _eventTimeSelector(context),
                true,
              ),
            ]),
            if(isNote) FormContainer([
              FormCustomField(
                  AppLocalizations.of(context)!.onTheCalendar + ':',
                  [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.willReceiveNotification,
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.03,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: colorMainText),
                      child: CheckboxListTile(
                        activeColor: colorSpecialItem,
                        title: Text(
                          AppLocalizations.of(context)!.showOnCalendar,
                          style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal),
                        ),
                        value: noteOnCalendar,
                        onChanged: (val) {
                          setState(() {
                            noteOnCalendar = val!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    if (noteOnCalendar) SizedBox(height: deviceHeight * 0.005),
                    if (noteOnCalendar) TextField(
                      controller: noteCalendarDateController,
                      style: TextStyle(color: colorMainText),
                      readOnly: true,
                      decoration: InputDecoration(
                        fillColor: colorThirdBackground,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: colorThirdBackground, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorSpecialItem, width: 2),
                        ),
                        hintText: noteDateHintText,
                        hintStyle: TextStyle(
                            color: colorThirdText, fontStyle: FontStyle.italic),
                      ),
                      onTap: () => _noteDateSelector(context),
                    ),
                  ],
                  true
              ),
            ]),
            FormSeparator(),

            if(!isNote) FormContainer([
              FormColorPicker(
                  context,
                  AppLocalizations.of(context)!.colour + ':',
                  AppLocalizations.of(context)!.eventColour + ':',
                  eventColor,
                  [
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: colorThirdBackground,
                        disabledColor: colorThirdBackground,
                      ),
                      child: RadioListTile(
                        title: Text(AppLocalizations.of(context)!.byDefault, style: TextStyle(color: colorMainText),),
                        value: -1,
                        groupValue: eventColor,
                        activeColor: colorThirdBackground,
                        onChanged: (val) {
                          setState(() {
                            eventColor = val as int;
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
                        groupValue: eventColor,
                        activeColor: const Color(0xffF44336),
                        onChanged: (val) {
                          setState(() {
                            eventColor = val as int;
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
                        groupValue: eventColor,
                        activeColor: const Color(0xffFF9800),
                        onChanged: (val) {
                          setState(() {
                            eventColor = val as int;
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
                        groupValue: eventColor,
                        activeColor: const Color(0xffFFCC00),
                        onChanged: (val) {
                          setState(() {
                            eventColor = val as int;
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
                        groupValue: eventColor,
                        activeColor: const Color(0xff4CAF50),
                        onChanged: (val) {
                          setState(() {
                            eventColor = val as int;
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
                        groupValue: eventColor,
                        activeColor: const Color(0xff448AFF),
                        onChanged: (val) {
                          setState(() {
                            eventColor = val as int;
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
                        groupValue: eventColor,
                        activeColor: const Color(0xff7C4DFF),
                        onChanged: (val) {
                          setState(() {
                            eventColor = val as int;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                  true
              ),
            ]),
            if(!isNote) FormSeparator(),
            FormContainerWithBorder(
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
            FormSeparator(),
            if(!isNote) MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' ' + AppLocalizations.of(context)!.createEvent + ' ',
                    () {
                  if (eventNameController.text.trim().isEmpty) {
                    showErrorSnackBar(context, AppLocalizations.of(context)!.errorTypeName);
                    eventNameFocusNode.requestFocus();
                  } else {
                    weekValues.forEach((value) {
                      if (value==true) daysSelected=true;
                    });
                    if (daysSelected==false){
                      showErrorSnackBar(context, AppLocalizations.of(context)!.errorSelectRoutineDays);
                      setState(() {
                        errorColor = Colors.red;
                      });
                    } else {
                      try {
                        DateTime date = DateTime.now();
                        _addRoutines();
                        Event newEvent = Event(
                          id: id,
                          name: eventNameController.text.trim(),
                          description: eventDescriptionController.text.trim(),
                          date: date,
                          time: eventTime,
                          color: eventColor,
                          notificationsList: [],
                          routinesList: routinesList,
                          routineEvent: true,
                        );
                        createEvent(newEvent);
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
            if(isNote) MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' ' + AppLocalizations.of(context)!.toCreateNote + ' ',
                    () {
                  weekValues.forEach((value) {
                    if (value == true) daysSelected = true;
                  });
                  if (daysSelected == false) {
                    showErrorSnackBar(context,
                        AppLocalizations.of(context)!.errorSelectRoutineDays);
                    setState(() {
                      errorColor = Colors.red;
                    });
                  } else {
                    _addRoutines();
                    try {
                      Note newNote = Note(
                        id: id,
                        name: noteNameController.text.trim(),
                        content: noteContentController.text.trim(),
                        onCalendar: noteOnCalendar,
                        calendarDate: noteCalendarDate,
                        modificationDate: DateTime.now(),
                        routinesList: routinesList,
                        routineNote: true,
                      );
                      createNote(newNote);
                      if (noteOnCalendar) buildNoteNotification(
                          id, noteNameController.text, noteCalendarDate, context);
                      Navigator.pop(context);
                      showInfoSnackBar(context, AppLocalizations.of(context)!.noteCreated);
                    } on Exception catch (e) {
                      debugPrint('[ERR] Could not create note: $e');
                      showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
                    }
                  }
                }),
          ]
      ),
    );
  }

  _eventTimeSelector(BuildContext context) async {
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
        eventTime = DateTime(1900, 01, 01, selected.hour, selected.minute);
        eventTimeController.text = timeFormat.format(eventTime);
      });
    }
  }

  _noteDateSelector(BuildContext context) async {
    var dateFormat = DateFormat('dd/MM/yyyy');
    if (formatDates == false) dateFormat = DateFormat('MM/dd/yyyy');

    final DateTime? selected = await showDatePicker(
      context: context,
      locale: appLocale,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2099, 12, 31),
      helpText: AppLocalizations.of(context)!.calendarSelectNoteDate,
      cancelText: AppLocalizations.of(context)!.calendarCancel,
      confirmText: AppLocalizations.of(context)!.calendarConfirm,
      fieldHintText: AppLocalizations.of(context)!.calendarHintDDMMYYYY,
      fieldLabelText: AppLocalizations.of(context)!.noteDate,
      errorFormatText: AppLocalizations.of(context)!.calendarErrorDate,
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
    if (selected != null && selected != DateTime.now()) {
      setState(() {
        noteCalendarDate=selected;
        noteCalendarDateController.text = dateFormat.format(selected);
      });
    }
  }

  _addRoutines(){
    for(int i=0; i<7; i++){
      if (weekValues[i]==true) routinesList.add(i+1);
    }
  }

}
