import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({Key? key}) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode timeFocusNode = FocusNode();

  late DateTime date;
  late TimeOfDay time;
  DateTime dateTime = selectedEvent!.dateTime;
  int color = selectedEvent!.color;

  List<dynamic> notificationsList = [];
  Map<String?, DateTime?> not1 = {null: null};
  Map<String?, DateTime?> not2 = {null: null};
  Map<String?, DateTime?> not3 = {null: null};
  Map<String?, DateTime?> not4 = {null: null};
  Map<String?, DateTime?> not5 = {null: null};

  List<dynamic> routinesList = [];
  List<bool> weekValues = [false, false, false, false, false, false, false];
  late bool routineEvent = selectedEvent!.routineEvent;

  Color errorUnderline = colorSecondBackground;
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
    nameController.text = selectedEvent!.name;
    descriptionController.text = selectedEvent!.description;
    date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    dateController.text = dateToString(selectedEvent!.dateTime);
    time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    timeController.text = timeToString(selectedEvent!.dateTime);
    for (int i=0; i<selectedEvent!.notificationsList.length; i++) {
      if (not1.keys.first == null) {
        not1 = {selectedEvent!.notificationsList[i].keys.first: selectedEvent!.notificationsList[i].values.first.toDate()};
        notificationsList.add(not1);
      } else if (not2.keys.first == null) {
        not2 = {selectedEvent!.notificationsList[i].keys.first: selectedEvent!.notificationsList[i].values.first.toDate()};
        notificationsList.add(not2);
      } else if (not3.keys.first == null) {
        not3 = {selectedEvent!.notificationsList[i].keys.first: selectedEvent!.notificationsList[i].values.first.toDate()};
        notificationsList.add(not3);
      } else if (not4.keys.first == null) {
        not4 = {selectedEvent!.notificationsList[i].keys.first: selectedEvent!.notificationsList[i].values.first.toDate()};
        notificationsList.add(not4);
      } else {
        not5 = {selectedEvent!.notificationsList[i].keys.first: selectedEvent!.notificationsList[i].values.first.toDate()};
        notificationsList.add(not5);
      }
    }
    for (int i=0; i<selectedEvent!.routinesList.length; i++){
      weekValues[selectedEvent!.routinesList[i]-1] = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(
          null,
          PageHeader(context, 'Editar evento'),
          FooterEmpty(),
          [
            FormSwitchButton('Una vez', 'Rutina', routineEvent, (){
              setState(() {
                routineEvent = !routineEvent;
              });
            }),
            FormSeparator(),
            FormContainer([
              FormTextField(nameController, 'Nombre:', '(Obligatorio)', nameFocusNode, false),
              FormTextField(descriptionController, 'Descripción:', '(Opcional)', descriptionFocusNode, true),
            ]),
            FormSeparator(),
            FormContainer([
              if(!routineEvent) FormDateTimeSelector(
                  dateController,
                  'Fecha:',
                  '',
                  dateFocusNode,
                      () => _dateSelector(context),
                  false
              ),
              FormDateTimeSelector(
                  timeController,
                  'Hora:',
                  '',
                  timeFocusNode,
                      () => _timeSelector(context),
                  !routineEvent
              ),
              if(routineEvent) FormCustomField(
                  'Días de la rutina:',
                  [
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
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            FormContainer(
                [FormCustomField(
                    'Color',
                    [Container(
                      alignment: Alignment.center,
                      child: Wrap(children: [
                        Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: colorThirdBackground,
                              disabledColor: colorThirdBackground,
                            ),
                            child: Radio(
                              value: -1,
                              groupValue: color,
                              activeColor: colorThirdBackground,
                              onChanged: (val) {
                                setState(() {
                                  color = val as int;
                                });
                              },
                            )
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: const Color(0xffF44336),
                            disabledColor: const Color(0xffF44336),
                          ),
                          child: Radio(
                            value: 0xffF44336,
                            groupValue: color,
                            activeColor: const Color(0xffF44336),
                            onChanged: (val) {
                              setState(() {
                                color = val as int;
                              });
                            },
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: const Color(0xffFF9800),
                            disabledColor: const Color(0xffFF9800),
                          ),
                          child: Radio(
                            value: 0xffFF9800,
                            groupValue: color,
                            activeColor: const Color(0xffFF9800),
                            onChanged: (val) {
                              setState(() {
                                color = val as int;
                              });
                            },
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: const Color(0xff4CAF50),
                            disabledColor: const Color(0xff4CAF50),
                          ),
                          child: Radio(
                            value: 0xff4CAF50,
                            groupValue: color,
                            activeColor: const Color(0xff4CAF50),
                            onChanged: (val) {
                              setState(() {
                                color = val as int;
                              });
                            },
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: const Color(0xff448AFF),
                            disabledColor: const Color(0xff448AFF),
                          ),
                          child: Radio(
                            value: 0xff448AFF,
                            groupValue: color,
                            activeColor: const Color(0xff448AFF),
                            onChanged: (val) {
                              setState(() {
                                color = val as int;
                              });
                            },
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: const Color(0xff7C4DFF),
                            disabledColor: const Color(0xff7C4DFF),
                          ),
                          child: Radio(
                            value: 0xff7C4DFF,
                            groupValue: color,
                            activeColor: const Color(0xff7C4DFF),
                            onChanged: (val) {
                              setState(() {
                                color = val as int;
                              });
                            },
                          ),
                        ),
                      ],),
                    )],
                    true
                ),]
            ),
            if(!routineEvent) FormSeparator(),
            if(!routineEvent) FormContainer([
              FormCustomField(
                  'Notificaciones',
                  [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(notificationsList.length,(index){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(formatEventNotificationDate(notificationsList[index].values.first),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.04,
                                        fontWeight: FontWeight.normal),),
                                  Expanded(child: Text(''),),
                                  Icon(Icons.delete_outline_rounded, color: Colors.red, size: deviceWidth*0.055,),
                                ],
                              ),
                              onPressed: (){
                                setState(() {
                                  if (not1.keys.first == notificationsList[index].keys.first){
                                    notificationsList.remove(not1);
                                    not1 = {null: null};
                                  } else if (not2.keys.first == notificationsList[index].keys.first){
                                    notificationsList.remove(not2);
                                    not2 = {null: null};
                                  } else if (not3.keys.first == notificationsList[index].keys.first){
                                    notificationsList.remove(not3);
                                    not3 = {null: null};
                                  } else if (not4.keys.first == notificationsList[index].keys.first){
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
                    if (notificationsList.length<5) TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded, color: colorSpecialItem, size: deviceWidth*0.055,),
                          Text(' Añadir notificación ', style: TextStyle(
                              color: colorSpecialItem,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal),),
                          Icon(Icons.add_rounded, color: Colors.transparent, size: deviceWidth*0.055,),
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
                          helpText: "SELECCIONA LA FECHA DE NOTIFICACIÓN",
                          cancelText: "CANCELAR",
                          confirmText: "CONFIRMAR",
                          fieldHintText: "dd/mm/aaaa",
                          fieldLabelText: "Fecha de notificación",
                          errorFormatText: "Introduce una fecha válida",
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
                            helpText: "SELECCIONA LA HORA DE NOTIFICACIÓN",
                            cancelText: "CANCELAR",
                            confirmText: "CONFIRMAR",
                            initialTime: TimeOfDay(hour: 0, minute: 0),
                            initialEntryMode: TimePickerEntryMode.dial,
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
                          if (timeSelected != null) {
                            notTime = timeSelected;
                            notDateTime = DateTime(notDate.year, notDate.month, notDate.day, notTime.hour, notTime.minute);
                            setState(() {
                              if (not1.keys.first == null){
                                notId = '1'+selectedEvent!.id.toString();
                                not1 = {notId: notDateTime};
                                notificationsList.add(not1);
                              } else if (not2.keys.first == null){
                                notId = ('2'+selectedEvent!.id.toString());
                                not2 = {notId: notDateTime};
                                notificationsList.add(not2);
                              } else if (not3.keys.first == null){
                                notId = ('3'+selectedEvent!.id.toString());
                                not3 = {notId: notDateTime};
                                notificationsList.add(not3);
                              } else if (not4.keys.first == null){
                                notId = ('4'+selectedEvent!.id.toString());
                                not4 = {notId: notDateTime};
                                notificationsList.add(not4);
                              } else {
                                notId = ('5'+selectedEvent!.id.toString());
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
            FormSeparator(),
            MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' Confirmar cambios ',
                    () async {
                      if (nameController.text.trim().isEmpty) {
                        showErrorSnackBar(context, 'Debes indicar un nombre');
                        nameFocusNode.requestFocus();
                      } else {
                        weekValues.forEach((value) {
                          if (value==true) daysSelected=true;
                        });
                        if (routineEvent && daysSelected==false){
                          showErrorSnackBar(context, 'Debes seleccionar al menos un día para la rutina');
                          setState(() {
                            errorUnderline = Colors.red;
                          });
                        } else {
                          try {
                            if(!routineEvent) dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                            else dateTime = DateTime.now();
                            if(routineEvent) _addEventRoutines();
                            Event newEvent = Event(
                              id: selectedEvent!.id,
                              name: nameController.text.trim(),
                              description: descriptionController.text.trim(),
                              dateTime: dateTime,
                              color: color,
                              notificationsList: notificationsList,
                              routinesList: routinesList,
                              routineEvent: routineEvent,
                            );
                            await updateEvent(newEvent);
                            await cancelAllEventNotifications(selectedEvent!.id);
                            if(!routineEvent) _buildAllEventNotifications();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            showInfoSnackBar(context, 'Evento actualizado.');
                          } on Exception catch (e) {
                            debugPrint('[ERR] Could not edit event: $e');
                            showErrorSnackBar(context, 'Ha ocurrido un error');
                          }
                        }
                      }
                    }
            ),
            FormSeparator(),
            MainButton(
                Icons.close_rounded,
                Colors.red,
                ' Cancelar ',
                () => Navigator.pop(context),
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
        initialDate: selectedEvent!.dateTime,
        firstDate: DateTime(2000, 1, 1),
        lastDate: DateTime(2099, 12, 31),
        helpText: "SELECCIONA LA FECHA DEL EVENTO",
        cancelText: "CANCELAR",
        confirmText: "CONFIRMAR",
        fieldHintText: "dd/mm/aaaa",
        fieldLabelText: "Fecha del evento",
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
        date = selected;
        dateController.text = dateFormat.format(selected);
      });
    }
  }

  _timeSelector(BuildContext context) async {
    var timeFormat = DateFormat("HH:mm");
    if (format24Hours == false) timeFormat = DateFormat("h:mm aa");

    final TimeOfDay? selected = await showTimePicker(
      context: context,
      helpText: "SELECCIONA LA HORA DEL EVENTO",
      cancelText: "CANCELAR",
      confirmText: "CONFIRMAR",
      initialTime: TimeOfDay(hour: selectedEvent!.dateTime.hour, minute: selectedEvent!.dateTime.minute),
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
        time=selected;
        DateTime auxDateTime = DateTime(2000, 1, 1, selected.hour, selected.minute);
        timeController.text = timeFormat.format(auxDateTime);
      });
    }
  }

  _buildAllEventNotifications() async {
    String notificationTitle = 'Evento: ' + nameController.text;
    if (not1.keys.first != null) buildEventNotification(
        int.parse(not1.keys.first!),
        notificationTitle, not1.values.first!,
        dateTime);
    if (not2.keys.first != null) buildEventNotification(
        int.parse(not2.keys.first!),
        notificationTitle, not2.values.first!,
        dateTime);
    if (not3.keys.first != null) buildEventNotification(
        int.parse(not3.keys.first!),
        notificationTitle, not3.values.first!,
        dateTime);
    if (not4.keys.first != null) buildEventNotification(
        int.parse(not4.keys.first!),
        notificationTitle, not4.values.first!,
        dateTime);
    if (not5.keys.first != null) buildEventNotification(
        int.parse(not5.keys.first!),
        notificationTitle, not5.values.first!,
        dateTime);
  }

  _addEventRoutines(){
    for(int i=0; i<7; i++){
      if (weekValues[i]==true) routinesList.add(i+1);
    }
  }

}
