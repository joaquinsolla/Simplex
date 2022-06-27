import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/common/all_common.dart';
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
  int selectedColor = -1;
  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  TimeOfDay time = TimeOfDay(hour: 00, minute: 00);
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
    String dateHintText = 'Hoy (Por defecto)';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: homeArea([
        pageHeader(context, 'Nuevo evento'),
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
                  hintText: dateHintText,
                  hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
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
                  hintText: timeHintText,
                  hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
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
                      notId = '1'+'$id';
                      not1 = {notId: notDateTime};
                      notificationsList.add(not1);
                    } else if (not2.keys.first == null){
                      notId = ('2'+'$id');
                      not2 = {notId: notDateTime};
                      notificationsList.add(not2);
                    } else if (not3.keys.first == null){
                      notId = ('3'+'$id');
                      not3 = {notId: notDateTime};
                      notificationsList.add(not3);
                    } else if (not4.keys.first == null){
                      notId = ('4'+'$id');
                      not4 = {notId: notDateTime};
                      notificationsList.add(not4);
                    } else {
                      notId = ('5'+'$id');
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
            children: [
              SizedBox(
              width: deviceHeight,
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
                  } else {
                    try {
                      DateTime fullEventDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      Event newEvent = Event(id: id,
                          name: nameController.text,
                          description: descriptionController.text,
                          dateTime: fullEventDateTime,
                          color: selectedColor,
                          notificationsList: notificationsList,
                      );
                      createEvent(newEvent);
                      if (not1.keys.first != null) showNotification(context, int.parse(not1.keys.first!), nameController.text, not1.values.first!, fullEventDateTime);
                      if (not2.keys.first != null) showNotification(context, int.parse(not2.keys.first!), nameController.text, not2.values.first!, fullEventDateTime);
                      if (not3.keys.first != null) showNotification(context, int.parse(not3.keys.first!), nameController.text, not3.values.first!, fullEventDateTime);
                      if (not4.keys.first != null) showNotification(context, int.parse(not4.keys.first!), nameController.text, not4.values.first!, fullEventDateTime);
                      if (not5.keys.first != null) showNotification(context, int.parse(not5.keys.first!), nameController.text, not5.values.first!, fullEventDateTime);
                      Navigator.pop(context);

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
        firstDate: DateTime(2000, 1, 1),
        lastDate: DateTime(2099, 12, 31),
        helpText: "SELECCIONA LA FECHA DEL EVENTO",
        cancelText: "CANCELAR",
        confirmText: "CONFIRMAR",
        fieldHintText: "dd/mm/aaaa",
        fieldLabelText: "Fecha del evento",
        errorFormatText: "Introduce una fecha válida",
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
