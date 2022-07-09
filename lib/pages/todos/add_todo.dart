import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/todo.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final limitDateController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode limitDateFocusNode = FocusNode();

  int id = int.parse((DateTime.now().millisecondsSinceEpoch).toString().substring(6));
  bool limitedTodo = false;
  DateTime limitDate = DateTime(3000);
  double priority = 1;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    limitDateController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dateHintText = 'Sin fecha límite (Por defecto)';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: homeArea([
        pageHeader(context, 'Nueva Tarea'),
        formContainer([
          formTextField(
              nameController, 'Nombre', '(Obligatorio)', nameFocusNode),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descripción', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.045, fontWeight: FontWeight.bold),),
              SizedBox(height: deviceHeight*0.005),
              TextField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLines: null,
                focusNode: descriptionFocusNode,
                style: TextStyle(color: colorMainText),
                controller: descriptionController,
                decoration: InputDecoration(
                  fillColor: colorThirdBackground,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorThirdBackground, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: colorSpecialItem, width: 2),
                  ),

                  hintText: '(Opcional)',
                  hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          )
        ]),
        SizedBox(height: deviceHeight * 0.025),
        formContainer([
          Text(
            'Prioridad',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.045,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.015),

          Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '-',
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.03,
                  fontWeight: FontWeight.bold),
            ),
            if (priority == 1) Container(
              width: deviceWidth*0.675,
              child: Slider(
              value: priority,
              max: 3,
              min: 1,
              divisions: 2,
              activeColor: colorSpecialItem,
              label: 'Baja',
              onChanged: (val) {
                setState(() {
                  priority = val;
                });
              },
            ),
            ),
            if (priority == 2) Container(
                width: deviceWidth*0.675,
                child: Slider(
              value: priority,
              max: 3,
              min: 1,
              divisions: 2,
              activeColor: Color(0xff2164f3),
              label: 'Media',
              onChanged: (val) {
                setState(() {
                  priority = val;
                });
              },
            )),
            if (priority == 3) Container(
              width: deviceWidth*0.675,
              child: Slider(
              value: priority,
              max: 3,
              min: 1,
              divisions: 2,
              activeColor: Color(0xff1828d7),
              label: 'Alta',
              onChanged: (val) {
                setState(() {
                  priority = val;
                });
              },
            )),
            Text(
              '+',
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.03,
                  fontWeight: FontWeight.bold),
            ),
          ],),

          SizedBox(height: deviceHeight * 0.005),

          Text(
            'Las tareas de mayor prioridad aparecerán sobre las que tengan una prioridad inferior.',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.03,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic),
          ),

        ]),
        SizedBox(height: deviceHeight * 0.025),
        formContainer([
          Text(
            'Fecha límite',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.045,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          CheckboxListTile(
            activeColor: colorSpecialItem,
            title: Text(
              'Tiene fecha límite',
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),
            ),
            value: limitedTodo,
            onChanged: (val) {
              setState(() {
                limitedTodo = val!;
                limitDateController.clear();
                if (val==false) limitDate = DateTime(3000);
                else limitDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          if (limitedTodo) SizedBox(height: deviceHeight * 0.005),
          if (limitedTodo) TextField(
            focusNode: limitDateFocusNode,
            controller: limitDateController,
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
        ]),
        SizedBox(height: deviceHeight * 0.025),
        actionsButton(
            Icons.check_rounded,
            colorSpecialItem,
            ' Crear tarea ',
                () {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Debes indicar un nombre"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ));
                nameFocusNode.requestFocus();
              } else {
                try {
                  Todo newTodo = Todo(
                    id: id,
                    name: nameController.text,
                    description: descriptionController.text,
                    done: false,
                    limitDate: limitDate,
                    priority: priority.round(),
                  );
                  createTodo(newTodo);
                  if (limitDate!=DateTime(3000)) buildTodoNotifications(id, 'Tarea: ' + nameController.text, limitDate);
                  Navigator.pop(context);
                } on Exception catch (e) {
                  debugPrint('[ERR] Could not create todo: $e');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Ha ocurrido un error"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ));
                }
              }
            }
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
    );
    if (selected != null && selected != DateTime.now()) {
      setState(() {
        limitDate=selected;
        limitDateController.text = dateFormat.format(selected);
      });
    }
  }

}
