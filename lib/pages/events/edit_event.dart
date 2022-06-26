import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/common/all_common.dart';
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

  int selectedColor = selectedEvent!.color;
  DateTime fullDateTime = selectedEvent!.dateTime;
  late DateTime date;
  late TimeOfDay time;

  List<dynamic> notificationsList = [];
  Map<String?, DateTime?> not1 = {null: null};
  Map<String?, DateTime?> not2 = {null: null};
  Map<String?, DateTime?> not3 = {null: null};
  Map<String?, DateTime?> not4 = {null: null};
  Map<String?, DateTime?> not5 = {null: null};

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    dateController.dispose();
  }

  @override
  void initState() {
    super.initState();
    date = DateTime(fullDateTime.year, fullDateTime.month, fullDateTime.day);
    time = TimeOfDay(hour: fullDateTime.hour, minute: fullDateTime.minute);
    nameController.text = selectedEvent!.name;
    descriptionController.text = selectedEvent!.description;
    dateController.text = dateToString(selectedEvent!.dateTime);
    timeController.text = timeToString(selectedEvent!.dateTime);
    for (var i = 0; i < selectedEvent!.notificationsList.length; i++) {
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

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: homeArea([
        pageHeader(context, 'Editar evento'),
        alternativeFormContainer([
          formTextField(nameController, 'Nombre', '(Obligatorio)', nameFocusNode),
          formTextField(descriptionController, 'Descripción', '(Opcional)', descriptionFocusNode),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fecha',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: deviceHeight * 0.005),
              TextField(
                focusNode: dateFocusNode,
                controller: dateController,
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
                  hintText: 'dd/mm/aaaa (Obligatorio)',
                  hintStyle: TextStyle(color: colorThirdText),
                ),
                onTap: () => _dateSelector(context),
              ),
            ],
          ),
          SizedBox(height: deviceHeight*0.025),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hora',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: deviceHeight * 0.005),
              TextField(
                focusNode: timeFocusNode,
                controller: timeController,
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
                  hintText: '00:00 (Por defecto)',
                  hintStyle: TextStyle(color: colorThirdText),
                ),
                onTap: () => _timeSelector(context),
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.01),


        ]),
        SizedBox(height: deviceHeight * 0.025),
        alternativeFormContainer([
          Text(
            'Color',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.045,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.015),
          Container(
            alignment: Alignment.center,
            child: Wrap(children: [
              Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: colorThirdBackground,
                    disabledColor: colorThirdBackground,
                  ),
                  child: Radio(
                    value: -1,
                    groupValue: selectedColor,
                    activeColor: colorThirdBackground,
                    onChanged: (val) {
                      setState(() {
                        selectedColor = val as int;
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
                  groupValue: selectedColor,
                  activeColor: const Color(0xffF44336),
                  onChanged: (val) {
                    setState(() {
                      selectedColor = val as int;
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
                  groupValue: selectedColor,
                  activeColor: const Color(0xffFF9800),
                  onChanged: (val) {
                    setState(() {
                      selectedColor = val as int;
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
                  groupValue: selectedColor,
                  activeColor: const Color(0xff4CAF50),
                  onChanged: (val) {
                    setState(() {
                      selectedColor = val as int;
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
                  groupValue: selectedColor,
                  activeColor: const Color(0xff448AFF),
                  onChanged: (val) {
                    setState(() {
                      selectedColor = val as int;
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
                  groupValue: selectedColor,
                  activeColor: const Color(0xff7C4DFF),
                  onChanged: (val) {
                    setState(() {
                      selectedColor = val as int;
                    });
                  },
                ),
              ),
            ],),
          ),
        ]),

        SizedBox(height: deviceHeight * 0.025),
        alternativeFormContainer([
          Text(
            'Notificaciones',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.045,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.015),

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
                        Text(formatNotificationDate(notificationsList[index].values.first),
                          style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * 0.04,
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
                    fontSize: deviceWidth * 0.04,
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
        ]),

        SizedBox(height: deviceHeight * 0.025),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorSecondBackground,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ SizedBox(
              width: deviceWidth*0.9,
              height: deviceHeight*0.07,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.check_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                    Text(
                      ' Confirmar cambios ',
                      style: TextStyle(
                          color: colorSpecialItem,
                          fontSize: deviceWidth * 0.05,
                          fontWeight: FontWeight.normal),
                    ),
                    Icon(Icons.check_rounded, color: Colors.transparent, size: deviceWidth * 0.06),
                  ],
                ),
                onPressed: () async {
                  if (nameController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Debes indicar un nombre"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                    nameFocusNode.requestFocus();
                  } else {
                    DateTime newFullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    try {
                      Event newEvent = Event(id: selectedEvent!.id,
                          name: nameController.text,
                          description: descriptionController.text,
                          dateTime: newFullDateTime,
                          color: selectedColor,
                          notificationsList: notificationsList,
                      );

                      await updateEvent(newEvent);
                      await cancelAllNotifications(selectedEvent!.id);
                      if (not1.keys.first != null) showNotification(context, int.parse(not1.keys.first!), nameController.text, not1.values.first!, newFullDateTime);
                      if (not2.keys.first != null) showNotification(context, int.parse(not2.keys.first!), nameController.text, not2.values.first!, newFullDateTime);
                      if (not3.keys.first != null) showNotification(context, int.parse(not3.keys.first!), nameController.text, not3.values.first!, newFullDateTime);
                      if (not4.keys.first != null) showNotification(context, int.parse(not4.keys.first!), nameController.text, not4.values.first!, newFullDateTime);
                      if (not5.keys.first != null) showNotification(context, int.parse(not5.keys.first!), nameController.text, not5.values.first!, newFullDateTime);

                      Navigator.of(context).popUntil((route) => route.isFirst);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Evento actualizado"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ));

                    } on Exception catch (e) {
                      debugPrint('[ERR] Could not edit event: $e');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Ha ocurrido un error"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ));
                    }
                  }
                },
              ),
            ),],
          ),
        ),
        SizedBox(height: deviceHeight * 0.025),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorSecondBackground,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ SizedBox(
              width: deviceWidth*0.9,
              height: deviceHeight*0.07,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.close_rounded, color: Colors.red, size: deviceWidth * 0.06),
                    Text(
                      ' Cancelar ',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: deviceWidth * 0.05,
                          fontWeight: FontWeight.normal),
                    ),
                    Icon(Icons.close_rounded, color: Colors.transparent, size: deviceWidth * 0.06),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),],
          ),
        ),
        SizedBox(height: deviceHeight * 0.025),
      ]),
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
        errorInvalidText: "La fecha debe ser posterior a hoy");
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
    );
    if (selected != null) {
      setState(() {
        time=selected;
        DateTime auxDateTime = DateTime(2000, 1, 1, selected.hour, selected.minute);
        timeController.text = timeFormat.format(auxDateTime);
      });
    }
  }

}
