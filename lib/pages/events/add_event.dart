import 'package:flutter/material.dart';
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

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();

  bool dayNotification = false;
  bool weekNotification = false;
  bool monthNotification = false;

  int selectedColor = -1;

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
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: homeArea([
        pageHeader(context, 'Nuevo evento', '/home'),
        alternativeFormContainer([formTextField(nameController, 'Nombre', '(Obligatorio)', nameFocusNode),
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
                  hintText: 'dd/mm/aaaa',
                  hintStyle: TextStyle(color: colorThirdText),
                ),
                onTap: () => _dateSelector(context),
              ),
            ],
          ),]),
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
          if (dayNotification==false) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                'Un día antes',
                style: TextStyle(
                    color: colorThirdText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: dayNotification,
              onChanged: (newValue) {
                setState(() {
                  dayNotification = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          if (dayNotification==true) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                'Un día antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: dayNotification,
              onChanged: (newValue) {
                setState(() {
                  dayNotification = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          SizedBox(height: deviceHeight * 0.01),
          if(weekNotification==false) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                'Una semana antes',
                style: TextStyle(
                    color: colorThirdText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: weekNotification,
              onChanged: (newValue) {
                setState(() {
                  weekNotification = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          if(weekNotification==true) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                'Una semana antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: weekNotification,
              onChanged: (newValue) {
                setState(() {
                  weekNotification = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          SizedBox(height: deviceHeight * 0.01),
          if (monthNotification==false) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                'Un mes antes',
                style: TextStyle(
                    color: colorThirdText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: monthNotification,
              onChanged: (newValue) {
                setState(() {
                  monthNotification = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          if (monthNotification==true) checkBoxContainer(
            CheckboxListTile(
              title: Text(
                'Un mes antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.normal),
              ),
              value: monthNotification,
              onChanged: (newValue) {
                setState(() {
                  monthNotification = newValue!;
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

                      DateTime now = DateTime.now();
                      int milliNow = int.parse((now.millisecondsSinceEpoch).toString().substring(6));

                      int notificationDayId = int.parse("1"+"$milliNow");
                      int notificationWeekId = int.parse("7"+"$milliNow");
                      int notificationMonthId = int.parse("30"+"$milliNow");

                      if (dayNotification) dayNotification=showNotification(context, notificationDayId, nameController.text, 1, now, DateTime.parse(stringDateToYMD(dateController.text)));
                      if (weekNotification) weekNotification=showNotification(context, notificationWeekId, nameController.text, 7, now, DateTime.parse(stringDateToYMD(dateController.text)));
                      if (monthNotification) monthNotification=showNotification(context, notificationMonthId, nameController.text, 30, now, DateTime.parse(stringDateToYMD(dateController.text)));

                      if (dayNotification==false) notificationDayId=-1;
                      if (weekNotification==false) notificationWeekId=-1;
                      if (monthNotification==false) notificationMonthId=-1;

                      Event newEvent = Event(id: milliNow, name: nameController.text, description: descriptionController.text,
                          date: DateTime.parse(stringDateToYMD(dateController.text)).millisecondsSinceEpoch, color: selectedColor,
                          notificationDay: notificationDayId, notificationWeek: notificationWeekId, notificationMonth: notificationMonthId);
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
  final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: "SELECCIONA LA FECHA DEL EVENTO",
      cancelText: "CANCELAR",
      confirmText: "CONFIRMAR",
      fieldHintText: "dd/mm/aaaa",
      fieldLabelText: "Fecha del evento",
      errorFormatText: "Introduce una fecha válida",
      errorInvalidText: "La fecha debe ser posterior a hoy");
  if (selected != null && selected != DateTime.now()) {
    setState(() {
      dateController.text = datetimeToString(selected);
    });
  }
}
}
