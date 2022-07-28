import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/note.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final nameController = TextEditingController();
  final contentController = TextEditingController();
  final calendarDateController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode contentFocusNode = FocusNode();

  int id = int.parse((DateTime.now().millisecondsSinceEpoch).toString().substring(6));
  bool onCalendar = false;
  DateTime calendarDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    contentController.dispose();
    calendarDateController.dispose();
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
        pageHeader(context, 'Nueva Nota'),
        formContainer([
          formTextField(
              nameController, 'Título', '(Opcional)', nameFocusNode),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contenido', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.045, fontWeight: FontWeight.bold),),
              SizedBox(height: deviceHeight*0.005),
              TextField(
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                focusNode: contentFocusNode,
                style: TextStyle(color: colorMainText),
                controller: contentController,
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
            'En el calendario',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.045,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          CheckboxListTile(
            activeColor: colorSpecialItem,
            title: Text(
              'Mostrar nota en el calendario',
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),
            ),
            value: onCalendar,
            onChanged: (val) {
              setState(() {
                onCalendar = val!;
                calendarDateController.clear();
                calendarDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          if (onCalendar) SizedBox(height: deviceHeight * 0.005),
          if (onCalendar) TextField(
            controller: calendarDateController,
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
          SizedBox(height: deviceHeight * 0.01),
          Text(
            '[Beta] Las notas aparecerán en el calendario de Simplex en el día indicado.'
                ' También recibirás una notificación en esa fecha.',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.03,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic),
          ),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        actionsButton(
            Icons.check_rounded,
            colorSpecialItem,
            ' Crear nota ',
                () {
                  try {
                    Note newNote = Note(
                      id: id,
                      name: nameController.text.trim(),
                      content: contentController.text.trim(),
                      onCalendar: onCalendar,
                      calendarDate: calendarDate,
                      modificationDate: DateTime.now(),
                    );
                    createNote(newNote);
                    if (onCalendar) buildNoteNotification(id, nameController.text, calendarDate);
                    Navigator.pop(context);
                  } on Exception catch (e) {
                    debugPrint('[ERR] Could not create note: $e');
                    snackBar(context, 'Ha ocurrido un error', Colors.red);
                  }
                }),
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
      helpText: "SELECCIONA LA FECHA PARA LA NOTA",
      cancelText: "CANCELAR",
      confirmText: "CONFIRMAR",
      fieldHintText: "dd/mm/aaaa",
      fieldLabelText: "Fecha para la nota",
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
        calendarDate=selected;
        calendarDateController.text = dateFormat.format(selected);
      });
    }
  }

}
