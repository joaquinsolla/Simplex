import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

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

  String timeHintText = '00:00 (Por defecto)';
  String dateHintText = 'Hoy (Por defecto)';
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
    if (format24Hours == false) timeHintText = '12:00 AM (Por defecto)';
    dateController.text = dateToString(selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(
          null,
          PageHeader(context, 'Nuevo evento'),
          FooterEmpty(),
          [
            FormSwitchButton('Una vez', 'Rutina', routineEvent, (){
              setState(() {
                routineEvent = !routineEvent;
              });
            }),
            FormSeparator(),
            FormContainer([
              FormTextField(
                  nameController, 'Nombre:', '(Obligatorio)', nameFocusNode, false),
              FormTextField(descriptionController, 'Descripción:', '(Opcional)',
                  descriptionFocusNode, true),
            ]),
            FormSeparator(),
            FormContainer([
              if(!routineEvent) FormDateTimeSelector(
                  dateController,
                  'Fecha:',
                  dateHintText,
                  dateFocusNode,
                    () => _dateSelector(context),
                  false
              ),
              FormDateTimeSelector(
                  timeController,
                  'Hora:',
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
                  'Color:',
                  'Color del evento:',
                  color,
                  [
                    Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: colorThirdBackground,
                          disabledColor: colorThirdBackground,
                        ),
                        child: RadioListTile(
                          title: Text('Por defecto', style: TextStyle(color: colorMainText),),
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
                        title: Text('Rojo', style: TextStyle(color: colorMainText)),
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
                        title: Text('Naranja', style: TextStyle(color: colorMainText)),
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
                        title: Text('Amarillo', style: TextStyle(color: colorMainText)),
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
                        title: Text('Verde', style: TextStyle(color: colorMainText)),
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
                        title: Text('Azul', style: TextStyle(color: colorMainText)),
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
                        title: Text('Violeta', style: TextStyle(color: colorMainText)),
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
                      'Días de la rutina:',
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
                                    Text('Lunes',
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
                                    Text('Martes',
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
                                    Text('Miércoles',
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
                                    Text('Jueves',
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
                                    Text('Viernes',
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
                                    Text('Sábado',
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
                                    Text('Domingo',
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
                                  Text(' Gestionar días ', style: TextStyle(
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
                                    'Días de la rutina:',
                                    weekValues,
                                    'Listo',
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
                  'Notificaciones',
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
                          Text('Sin notificaciones',
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
                          Text(' Añadir notificación ', style: TextStyle(
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
                ' Crear evento ',
                    () {
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
                        showInfoSnackBar(context, 'Evento creado.');
                      } on Exception catch (e) {
                        debugPrint('[ERR] Could not create event: $e');
                        showErrorSnackBar(context, 'Ha ocurrido un error');
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
        time = DateTime(1900, 01, 01, selected.hour, selected.minute);
        timeController.text = timeFormat.format(time);
      });
    }
  }

  _buildAllEventNotifications(){
    String notificationTitle = 'Evento: ' + nameController.text;
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
