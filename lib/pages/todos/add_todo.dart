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
  int selectedColor = -1;
  bool limitedTodo = false;
  DateTime limitDate = DateTime(3000);

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

                  //TODO: notification

                  Todo newTodo = Todo(id: id,
                    name: nameController.text,
                    description: descriptionController.text,
                    color: selectedColor,
                    done: false,
                    limitDate: limitDate,
                  );

                  createTodo(newTodo);
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
        limitDate=selected;
        limitDateController.text = dateFormat.format(selected);
      });
    }
  }

}
