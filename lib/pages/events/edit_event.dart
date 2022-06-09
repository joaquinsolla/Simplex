import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/sqlite_service.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({Key? key}) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();

  int selectedColor = selectedEvent!.color;

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
    nameController.text = selectedEvent!.name;
    descriptionController.text = selectedEvent!.description;
    dateController.text = millisecondsToStringDate(selectedEvent!.date);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: homeArea([
        pageHeader(context, 'Editar evento', '/events/event_details'),
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
              Text(
                'Editar la fecha del evento hará que se desactiven las notificaciones que había asociadas a él.',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.035,
                    fontWeight: FontWeight.normal),
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
                      ' Confirmar cambios ',
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
                      Event newEvent = Event(id: selectedEvent!.id, name: nameController.text, description: descriptionController.text,
                          date: DateTime.parse(stringDateToYMD(dateController.text)).millisecondsSinceEpoch, color: selectedColor,
                          notificationDay: selectedEvent!.notificationDay, notificationWeek: selectedEvent!.notificationWeek,
                          notificationMonth: selectedEvent!.notificationMonth);
                      if(dateController.text != millisecondsToStringDate(selectedEvent!.date)) {
                        if (selectedEvent!.notificationDay != -1) cancelNotification(selectedEvent!.notificationDay);
                        if (selectedEvent!.notificationWeek != -1) cancelNotification(selectedEvent!.notificationWeek);
                        if (selectedEvent!.notificationMonth != -1) cancelNotification(selectedEvent!.notificationMonth);
                        newEvent = Event(id: selectedEvent!.id, name: nameController.text, description: descriptionController.text,
                            date: DateTime.parse(stringDateToYMD(dateController.text)).millisecondsSinceEpoch, color: selectedColor,
                            notificationDay: -1, notificationWeek: -1, notificationMonth: -1);
                      }

                      createEvent(newEvent);
                      Navigator.pushReplacementNamed(context, '/home');

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
              width: deviceWidth*0.8,
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
    final DateTime? selected = await showDatePicker(
        context: context,
        locale: appLocale,
        initialDate: DateTime.fromMicrosecondsSinceEpoch(selectedEvent!.date*1000),
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
        dateController.text = datetimeToString(selected);
      });
    }
  }

}
