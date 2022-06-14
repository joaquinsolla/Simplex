import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/sqlite_service.dart';

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

  bool notification5Min = false;
  bool notification1Hour = false;
  bool notification1Day = false;

  int selectedColor = -1;
  late DateTime date;
  TimeOfDay time = TimeOfDay(hour: 00, minute: 00);

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
  }

  @override
  Widget build(BuildContext context) {

    String timeHintText = '00:00 (Por defecto)';
    if (format24Hours == false) timeHintText = '12:00 AM (Por defecto)';
    String dateHintText = 'dd/mm/aaaa (Obligatorio)';
    if (formatDates == false) dateHintText = 'mm/dd/aaaa (Obligatorio)';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: homeArea([
        pageHeader(context, 'Nuevo evento', '/home'),
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
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: colorSpecialItem, width: 2),
                  ),
                  hintText: dateHintText,
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
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: colorSpecialItem, width: 2),
                  ),
                  hintText: timeHintText,
                  hintStyle: TextStyle(color: colorThirdText),
                ),
                onTap: () => _timeSelector(context),
              ),
            ],
          ),
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
          if (notification5Min==false) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                '5 minutos antes',
                style: TextStyle(
                    color: colorThirdText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: notification5Min,
              onChanged: (newValue) {
                setState(() {
                  notification5Min = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          if (notification5Min==true) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                '5 minutos antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: notification5Min,
              onChanged: (newValue) {
                setState(() {
                  notification5Min = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          SizedBox(height: deviceHeight * 0.01),
          if(notification1Hour==false) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                '1 hora antes',
                style: TextStyle(
                    color: colorThirdText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: notification1Hour,
              onChanged: (newValue) {
                setState(() {
                  notification1Hour = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          if(notification1Hour==true) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                '1 hora antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: notification1Hour,
              onChanged: (newValue) {
                setState(() {
                  notification1Hour = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          SizedBox(height: deviceHeight * 0.01),
          if (notification1Day==false) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                '1 día antes',
                style: TextStyle(
                    color: colorThirdText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: notification1Day,
              onChanged: (newValue) {
                setState(() {
                  notification1Day = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          if (notification1Day==true) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                '1 día antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: notification1Day,
              onChanged: (newValue) {
                setState(() {
                  notification1Day = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
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
              width: deviceWidth*0.8,
              height: deviceHeight*0.07,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.check_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                    Text(
                      ' Crear evento',
                      style: TextStyle(
                          color: colorSpecialItem,
                          fontSize: deviceWidth * 0.05,
                          fontWeight: FontWeight.normal),
                    ),
                    Icon(Icons.check_rounded, color: Colors.transparent, size: deviceWidth * 0.06),
                  ],
                ),
                onPressed: () {
                  if (nameController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Debes indicar un nombre"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                    nameFocusNode.requestFocus();
                  } else if (dateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Debes indicar una fecha"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                    dateFocusNode.requestFocus();
                  } else {
                    try {

                      DateTime nowDateTime = DateTime.now();
                      int id = int.parse((nowDateTime.millisecondsSinceEpoch).toString().substring(6));

                      int notification5MinId = int.parse("1"+"$id");
                      int notification1HourId = int.parse("2"+"$id");
                      int notification1DayId = int.parse("3"+"$id");

                      DateTime fullEventDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

                      if (notification5Min) notification5Min=showNotification(context, notification5MinId, nameController.text, 1, nowDateTime, fullEventDateTime);
                      if (notification1Hour) notification1Hour=showNotification(context, notification1HourId, nameController.text, 2, nowDateTime, fullEventDateTime);
                      if (notification1Day) notification1Day=showNotification(context, notification1DayId, nameController.text, 3, nowDateTime, fullEventDateTime);

                      if (notification5Min==false) notification5MinId=-1;
                      if (notification1Hour==false) notification1HourId=-1;
                      if (notification1Day==false) notification1DayId=-1;

                      Event newEvent = Event(id: id, name: nameController.text, description: descriptionController.text,
                          dateTime: fullEventDateTime.millisecondsSinceEpoch, color: selectedColor,
                          notification5Min: notification5MinId, notification1Hour: notification1HourId, notification1Day: notification1DayId);
                      createEvent(newEvent);

                      Navigator.pushReplacementNamed(context, '/home');

                    } on Exception catch (e) {
                      debugPrint('[ERR] Could not create event: $e');
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
      ]),
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
        helpText: "SELECCIONA LA FECHA DEL EVENTO",
        cancelText: "CANCELAR",
        confirmText: "CONFIRMAR",
        fieldHintText: "dd/mm/aaaa",
        fieldLabelText: "Fecha del evento",
        errorFormatText: "Introduce una fecha válida",
        errorInvalidText: "La fecha debe ser posterior a hoy");
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
