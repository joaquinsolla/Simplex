import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/note.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  final nameController = TextEditingController();
  final contentController = TextEditingController();
  final calendarDateController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode contentFocusNode = FocusNode();

  int id = int.parse((DateTime.now().millisecondsSinceEpoch).toString().substring(6));

  bool onCalendar = false;
  DateTime calendarDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<dynamic> routinesList = [];
  List<bool> weekValues = [false, false, false, false, false, false, false];

  Color errorColor = colorSecondBackground;
  bool daysSelected = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    contentController.dispose();
    calendarDateController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dateHintText = AppLocalizations.of(context)!.dateHintDefaultToday;

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, AppLocalizations.of(context)!.newNote),
          FooterEmpty(),
          [
            FormContainer([
              FormTextField(
                  nameController, AppLocalizations.of(context)!.title + ':', AppLocalizations.of(context)!.optional, nameFocusNode, false),
              FormTextFieldMultiline(
                  contentController, AppLocalizations.of(context)!.content + ':', AppLocalizations.of(context)!.optional, contentFocusNode, true),
            ]),
            FormSeparator(),
            FormContainer([
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
                        value: onCalendar,
                        onChanged: (val) {
                          setState(() {
                            onCalendar = val!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    if (onCalendar) SizedBox(height: deviceHeight * 0.005),
                    if (onCalendar) TextField(
                      controller: calendarDateController,
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
                        hintText: dateHintText,
                        hintStyle: TextStyle(
                            color: colorThirdText, fontStyle: FontStyle.italic),
                      ),
                      onTap: () => _dateSelector(context),
                    ),
                  ],
                  true
              ),
            ]),
            FormSeparator(),
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
            MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' ' + AppLocalizations.of(context)!.toCreateNote + ' ',
                    () {
                      weekValues.forEach((value) {
                        if (value == true) daysSelected = true;
                      });
                      if (daysSelected) _addNoteRoutines();
                      try {
                        Note newNote = Note(
                          id: id,
                          name: nameController.text.trim(),
                          content: contentController.text.trim(),
                          onCalendar: onCalendar,
                          calendarDate: calendarDate,
                          modificationDate: DateTime.now(),
                          routinesList: routinesList,
                          routineNote: daysSelected,
                        );
                        createNote(newNote);
                        if (onCalendar) buildNoteNotification(
                            id, nameController.text, calendarDate);
                        Navigator.pop(context);
                        showInfoSnackBar(context, AppLocalizations.of(context)!.noteCreated);
                      } on Exception catch (e) {
                        debugPrint('[ERR] Could not create note: $e');
                        showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
                      }
                    }),
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
        calendarDate=selected;
        calendarDateController.text = dateFormat.format(selected);
      });
    }
  }

  _addNoteRoutines(){
    for(int i=0; i<7; i++){
      if (weekValues[i]==true) routinesList.add(i+1);
    }
  }

}
