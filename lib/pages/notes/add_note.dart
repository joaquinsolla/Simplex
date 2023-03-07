import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/note.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
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

  List<dynamic> routinesList = [];
  List<bool> weekValues = [false, false, false, false, false, false, false];
  bool routineNote = false;

  String dateHintText = 'Hoy (Por defecto)';
  Color errorUnderline = colorSecondBackground;
  bool daysSelected = false;

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

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, 'Nueva Nota'),
          FooterEmpty(),
          [
            FormContainer([
              FormTextField(
                  nameController, 'Título:', '(Opcional)', nameFocusNode, false),
              FormTextFieldMultiline(
                  contentController, 'Contenido:', '(Opcional)', contentFocusNode, true),
            ]),
            FormSeparator(),
            FormContainer([
              FormCustomField(
                  'En el calendario:',
                  [
                    Theme(
                      data: ThemeData(unselectedWidgetColor: colorMainText),
                      child: CheckboxListTile(
                        activeColor: colorSpecialItem,
                        title: Text(
                          'Mostrar nota en el calendario',
                          style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal),
                        ),
                        value: onCalendar,
                        onChanged: (val) {
                          setState(() {
                            onCalendar = val!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
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
                      'Las notas aparecerán en el calendario de Simplex en el día indicado.'
                          ' También recibirás una notificación en esa fecha.',
                      style: TextStyle(
                          color: colorMainText,
                          fontSize: deviceWidth * fontSize * 0.03,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                  false
              ),
              FormCustomField(
                  'En mis rutinas:',
                  [
                    Theme(
                      data: ThemeData(unselectedWidgetColor: colorMainText),
                      child: Column(children: [
                        CheckboxListTile(
                          activeColor: colorSpecialItem,
                          title: Text(
                            'Mostrar nota en las rutinas:',
                            style: TextStyle(
                                color: colorMainText,
                                fontSize: deviceWidth * fontSize * 0.04,
                                fontWeight: FontWeight.normal),
                          ),
                          value: routineNote,
                          onChanged: (val) {
                            setState(() {
                              routineNote = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        if(routineNote) Container(
                          padding: EdgeInsets.fromLTRB(deviceWidth*0.115, 0, 0, 0),
                          child: Column(children: [
                            CheckboxListTile(
                              activeColor: colorSpecialItem,
                              title: Text(
                                'Lunes',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: deviceWidth * fontSize * 0.04,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                  decorationColor: errorUnderline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  decorationThickness: 2,
                                  shadows: [
                                    Shadow(
                                        color: colorMainText,
                                        offset: Offset(0, -1.5))
                                  ],
                                ),
                              ),
                              value: weekValues[0],
                              onChanged: (val) {
                                setState(() {
                                  weekValues[0] = val!;
                                  errorUnderline = colorSecondBackground;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              activeColor: colorSpecialItem,
                              title: Text(
                                'Martes',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: deviceWidth * fontSize * 0.04,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                  decorationColor: errorUnderline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  decorationThickness: 2,
                                  shadows: [
                                    Shadow(
                                        color: colorMainText,
                                        offset: Offset(0, -1.5))
                                  ],
                                ),
                              ),
                              value: weekValues[1],
                              onChanged: (val) {
                                setState(() {
                                  weekValues[1] = val!;
                                  errorUnderline = colorSecondBackground;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              activeColor: colorSpecialItem,
                              title: Text(
                                'Miércoles',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: deviceWidth * fontSize * 0.04,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                  decorationColor: errorUnderline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  decorationThickness: 2,
                                  shadows: [
                                    Shadow(
                                        color: colorMainText,
                                        offset: Offset(0, -1.5))
                                  ],
                                ),
                              ),
                              value: weekValues[2],
                              onChanged: (val) {
                                setState(() {
                                  weekValues[2] = val!;
                                  errorUnderline = colorSecondBackground;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              activeColor: colorSpecialItem,
                              title: Text(
                                'Jueves',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: deviceWidth * fontSize * 0.04,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                  decorationColor: errorUnderline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  decorationThickness: 2,
                                  shadows: [
                                    Shadow(
                                        color: colorMainText,
                                        offset: Offset(0, -1.5))
                                  ],
                                ),
                              ),
                              value: weekValues[3],
                              onChanged: (val) {
                                setState(() {
                                  weekValues[3] = val!;
                                  errorUnderline = colorSecondBackground;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              activeColor: colorSpecialItem,
                              title: Text(
                                'Viernes',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: deviceWidth * fontSize * 0.04,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                  decorationColor: errorUnderline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  decorationThickness: 2,
                                  shadows: [
                                    Shadow(
                                        color: colorMainText,
                                        offset: Offset(0, -1.5))
                                  ],
                                ),
                              ),
                              value: weekValues[4],
                              onChanged: (val) {
                                setState(() {
                                  weekValues[4] = val!;
                                  errorUnderline = colorSecondBackground;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              activeColor: colorSpecialItem,
                              title: Text(
                                'Sábado',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: deviceWidth * fontSize * 0.04,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                  decorationColor: errorUnderline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  decorationThickness: 2,
                                  shadows: [
                                    Shadow(
                                        color: colorMainText,
                                        offset: Offset(0, -1.5))
                                  ],
                                ),
                              ),
                              value: weekValues[5],
                              onChanged: (val) {
                                setState(() {
                                  weekValues[5] = val!;
                                  errorUnderline = colorSecondBackground;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              activeColor: colorSpecialItem,
                              title: Text(
                                'Domingo',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: deviceWidth * fontSize * 0.04,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline,
                                  decorationColor: errorUnderline,
                                  decorationStyle: TextDecorationStyle.dashed,
                                  decorationThickness: 2,
                                  shadows: [
                                    Shadow(
                                        color: colorMainText,
                                        offset: Offset(0, -1.5))
                                  ],
                                ),
                              ),
                              value: weekValues[6],
                              onChanged: (val) {
                                setState(() {
                                  weekValues[6] = val!;
                                  errorUnderline = colorSecondBackground;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ],),
                        ),
                      ],),
                    ),
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            MainButton(
                Icons.check_rounded,
                colorSpecialItem,
                ' Crear nota ',
                    () {
                      weekValues.forEach((value) {
                        if (value == true) daysSelected = true;
                      });
                      if (routineNote && daysSelected == false) {
                        showErrorSnackBar(context,
                            'Debes seleccionar al menos un día para la rutina');
                        setState(() {
                          errorUnderline = Colors.red;
                        });
                      } else {
                        if(routineNote) _addNoteRoutines();
                        try {
                          Note newNote = Note(
                            id: id,
                            name: nameController.text.trim(),
                            content: contentController.text.trim(),
                            onCalendar: onCalendar,
                            calendarDate: calendarDate,
                            modificationDate: DateTime.now(),
                            routinesList: routinesList,
                            routineNote: routineNote,
                          );
                          createNote(newNote);
                          if (onCalendar) buildNoteNotification(
                              id, nameController.text, calendarDate);
                          Navigator.pop(context);
                          showInfoSnackBar(context, 'Nota creada.');
                        } on Exception catch (e) {
                          debugPrint('[ERR] Could not create note: $e');
                          showErrorSnackBar(context, 'Ha ocurrido un error');
                        }
                      }
                    }),
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

  _addNoteRoutines(){
    for(int i=0; i<7; i++){
      if (weekValues[i]==true) routinesList.add(i+1);
    }
  }

}
