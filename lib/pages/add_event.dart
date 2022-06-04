import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  bool dayNotification = false;
  bool weekNotification = false;
  bool monthNotification = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
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
        addHeader(context, 'Nuevo evento', [
          formTextField(nameController, 'Nombre', '(Obligatorio)'),
          formTextField(descriptionController, 'Descripción', '(Opcional)'),
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
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: colorSpecialItem, // Text Color
          ),
          onPressed: () {},
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_rounded,
                  color: colorButtonText, size: deviceWidth * 0.085),
              Text(
                ' Crear evento      ',
                style: TextStyle(
                    color: colorButtonText,
                    fontSize: deviceWidth * 0.05,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ),
      ]),
    );
  }

  _dateSelector(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2099),
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
