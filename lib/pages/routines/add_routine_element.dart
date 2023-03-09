import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/classes/note.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

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

  String eventTimeHintText = '00:00 (Por defecto)';
  String noteDateHintText = 'Hoy (Por defecto)';
  Color errorUnderline = colorSecondBackground;
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
    if (format24Hours == false) eventTimeHintText = '12:00 AM (Por defecto)';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(
          null,
          PageHeader(context, 'Añadir a rutina'),
          FooterEmpty(),
          [
            FormSwitchButton('Evento', 'Nota', isNote, (){
              setState(() {
                isNote = !isNote;
              });
            }),
            FormSeparator(),

            if(!isNote) FormContainer([
              FormTextField(
                  eventNameController, 'Nombre:', '(Obligatorio)', eventNameFocusNode, false),
              FormTextField(eventDescriptionController, 'Descripción:', '(Opcional)',
                  eventDescriptionFocusNode, true),
            ]),
            if(isNote) FormContainer([
              FormTextField(
                  noteNameController, 'Título:', '(Opcional)', noteNameFocusNode, false),
              FormTextFieldMultiline(
                  noteContentController, 'Contenido:', '(Opcional)', noteContentFocusNode, true),
            ]),
            FormSeparator(),

            if(isNote) FormContainer([
              FormCustomField(
                  'En el calendario:',
                  [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'También recibirás una notificación en esa fecha.',
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
                          'Mostrar nota en el calendario',
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
            if(isNote) FormSeparator(),

            if(!isNote) FormContainer([
              FormDateTimeSelector(
                eventTimeController,
                'Hora:',
                eventTimeHintText,
                eventTimeFocusNode,
                    () => _eventTimeSelector(context),
                true,
              ),
            ]),
            if(!isNote) FormSeparator(),

            FormContainer([
              FormCustomField(
                  'Días de la rutina:',
                  [
                    Theme(
                      data: ThemeData(unselectedWidgetColor: colorMainText),
                      child: Column(children: [
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Lunes',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: errorUnderline,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationThickness: 2,
                              shadows: [
                                Shadow(
                                    color: colorMainText,
                                    offset: Offset(0, -1.5))
                              ],
                            ),
                          ),
                          value: weekValues[0],
                          onChanged: (val) {
                            setState(() {
                              weekValues[0] = val!;
                              errorUnderline = colorSecondBackground;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Martes',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: errorUnderline,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationThickness: 2,
                              shadows: [
                                Shadow(
                                    color: colorMainText,
                                    offset: Offset(0, -1.5))
                              ],
                            ),
                          ),
                          value: weekValues[1],
                          onChanged: (val) {
                            setState(() {
                              weekValues[1] = val!;
                              errorUnderline = colorSecondBackground;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Miércoles',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: errorUnderline,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationThickness: 2,
                              shadows: [
                                Shadow(
                                    color: colorMainText,
                                    offset: Offset(0, -1.5))
                              ],
                            ),
                          ),
                          value: weekValues[2],
                          onChanged: (val) {
                            setState(() {
                              weekValues[2] = val!;
                              errorUnderline = colorSecondBackground;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Jueves',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: errorUnderline,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationThickness: 2,
                              shadows: [
                                Shadow(
                                    color: colorMainText,
                                    offset: Offset(0, -1.5))
                              ],
                            ),
                          ),
                          value: weekValues[3],
                          onChanged: (val) {
                            setState(() {
                              weekValues[3] = val!;
                              errorUnderline = colorSecondBackground;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Viernes',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: errorUnderline,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationThickness: 2,
                              shadows: [
                                Shadow(
                                    color: colorMainText,
                                    offset: Offset(0, -1.5))
                              ],
                            ),
                          ),
                          value: weekValues[4],
                          onChanged: (val) {
                            setState(() {
                              weekValues[4] = val!;
                              errorUnderline = colorSecondBackground;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Sábado',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: errorUnderline,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationThickness: 2,
                              shadows: [
                                Shadow(
                                    color: colorMainText,
                                    offset: Offset(0, -1.5))
                              ],
                            ),
                          ),
                          value: weekValues[5],
                          onChanged: (val) {
                            setState(() {
                              weekValues[5] = val!;
                              errorUnderline = colorSecondBackground;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Domingo',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: errorUnderline,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationThickness: 2,
                              shadows: [
                                Shadow(
                                    color: colorMainText,
                                    offset: Offset(0, -1.5))
                              ],
                            ),
                          ),
                          value: weekValues[6],
                          onChanged: (val) {
                            setState(() {
                              weekValues[6] = val!;
                              errorUnderline = colorSecondBackground;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],),
                    ),
                  ],
                  true
              ),
            ]),
            FormSeparator(),

            if(!isNote) FormContainer([
              FormColorPicker(
                  context,
                  'Color:',
                  'Color del evento:',
                  eventColor,
                  [
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: colorThirdBackground,
                        disabledColor: colorThirdBackground,
                      ),
                      child: RadioListTile(
                        title: Text('Por defecto', style: TextStyle(color: colorMainText),),
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
                        title: Text('Rojo', style: TextStyle(color: colorMainText)),
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
                        title: Text('Naranja', style: TextStyle(color: colorMainText)),
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
                        title: Text('Amarillo', style: TextStyle(color: colorMainText)),
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
                        title: Text('Verde', style: TextStyle(color: colorMainText)),
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
                        title: Text('Azul', style: TextStyle(color: colorMainText)),
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
                        title: Text('Violeta', style: TextStyle(color: colorMainText)),
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

            if(!isNote) MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' Crear evento ',
                    () {
                  if (eventNameController.text.trim().isEmpty) {
                    showErrorSnackBar(context, 'Debes indicar un nombre');
                    eventNameFocusNode.requestFocus();
                  } else {
                    weekValues.forEach((value) {
                      if (value==true) daysSelected=true;
                    });
                    if (daysSelected==false){
                      showErrorSnackBar(context, 'Debes seleccionar al menos un día para la rutina');
                      setState(() {
                        errorUnderline = Colors.red;
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
                        showInfoSnackBar(context, 'Evento creado.');
                      } on Exception catch (e) {
                        debugPrint('[ERR] Could not create event: $e');
                        showErrorSnackBar(context, 'Ha ocurrido un error');
                      }
                    }
                  }
                }
            ),
            if(isNote) MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' Crear nota ',
                    () {
                  weekValues.forEach((value) {
                    if (value == true) daysSelected = true;
                  });
                  if (daysSelected == false) {
                    showErrorSnackBar(context,
                        'Debes seleccionar al menos un día para la rutina');
                    setState(() {
                      errorUnderline = Colors.red;
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
                          id, noteNameController.text, noteCalendarDate);
                      Navigator.pop(context);
                      showInfoSnackBar(context, 'Nota creada.');
                    } on Exception catch (e) {
                      debugPrint('[ERR] Could not create note: $e');
                      showErrorSnackBar(context, 'Ha ocurrido un error');
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
      helpText: "SELECCIONA LA HORA DEL EVENTO",
      cancelText: "CANCELAR",
      confirmText: "CONFIRMAR",
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
      helpText: "SELECCIONA LA FECHA PARA LA NOTA",
      cancelText: "CANCELAR",
      confirmText: "CONFIRMAR",
      fieldHintText: "dd/mm/aaaa",
      fieldLabelText: "Fecha para la nota",
      errorFormatText: "Introduce una fecha válida",
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
