import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/todo.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
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
  bool limited = false;
  DateTime limitDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
    String dateHintText = 'Hoy (Por defecto)';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, 'Nueva Tarea'),
          FooterEmpty(),
          [
            FormContainer([
              FormTextField(
                  nameController, 'Nombre:', '(Obligatorio)', nameFocusNode, false),
              FormTextField(
                  descriptionController, 'Descripción:', '(Opcional)', descriptionFocusNode, true),
            ]),
            FormSeparator(),
            FormContainer([
              FormCustomField(
                  'Prioridad:',
                  [
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '-',
                          style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.03,
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
                              fontSize: deviceWidth * fontSize * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                      ],),
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            FormContainer([
              FormCustomField(
                  'Fecha límite:',
                  [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'La tarea aparecerá en el calendario y recibirás notificaciones '
                            'cuando se acerque la fecha límite.',
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
                          'Tarea con fecha límite',
                          style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal),
                        ),
                        value: limited,
                        onChanged: (val) {
                          setState(() {
                            limited = val!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    if (limited) SizedBox(height: deviceHeight * 0.005),
                    if (limited) TextField(
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
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' Crear tarea ',
                    () {
                  if (nameController.text.trim().isEmpty) {
                    showErrorSnackBar(context, 'Debes indicar un nombre');
                    nameFocusNode.requestFocus();
                  } else {
                    try {
                      Todo newTodo = Todo(
                        id: id,
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim(),
                        priority: priority,
                        limited: limited,
                        limitDate: limitDate,
                        done: false,
                      );
                      createTodo(newTodo);
                      if (limited) buildTodoNotifications(id, 'Tarea pendiente: ' + nameController.text, limitDate);
                      Navigator.pop(context);
                      showInfoSnackBar(context, 'Tarea creada.');
                    } on Exception catch (e) {
                      debugPrint('[ERR] Could not create todo: $e');
                      showErrorSnackBar(context, 'Ha ocurrido un error');
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2099, 12, 31),
      helpText: "SELECCIONA LA FECHA LÍMITE",
      cancelText: "CANCELAR",
      confirmText: "CONFIRMAR",
      fieldHintText: "dd/mm/aaaa",
      fieldLabelText: "Fecha límite",
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
        limitDate=selected;
        limitDateController.text = dateFormat.format(selected);
      });
    }
  }

}
