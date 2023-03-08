import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/note.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

class EditNote extends StatefulWidget {
  const EditNote({Key? key}) : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  final nameController = TextEditingController();
  final contentController = TextEditingController();
  final calendarDateController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode contentFocusNode = FocusNode();

  int id = selectedNote!.id;

  bool onCalendar = selectedNote!.onCalendar;
  DateTime calendarDate = selectedNote!.calendarDate;

  List<dynamic> routinesList = [];
  List<bool> weekValues = [false, false, false, false, false, false, false];
  late bool routineNote = selectedNote!.routineNote;

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
    nameController.text = selectedNote!.name;
    contentController.text = selectedNote!.content;
    calendarDateController.text = dateToString(selectedNote!.calendarDate);
    for (int i=0; i<selectedNote!.routinesList.length; i++){
      weekValues[selectedNote!.routinesList[i]-1] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateHintText = 'Hoy (Por defecto)';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, 'Editar Nota'),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'También recibirás una notificación en esa fecha.',
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
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            FormContainer([
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
                ' Confirmar cambios ',
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
                        try {
                          if(routineNote) _addNoteRoutines();
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
                          updateNote(newNote);
                          cancelNoteNotification(id);
                          if (onCalendar) buildNoteNotification(
                              id, nameController.text, calendarDate);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          showInfoSnackBar(context, 'Nota actualizada.');
                        } on Exception catch (e) {
                          debugPrint('[ERR] Could not update note: $e');
                          showErrorSnackBar(context, 'Ha ocurrido un error');
                        }
                      }
                }),
            FormSeparator(),
            MainButton(
              Icons.close_rounded,
              Colors.red,
              ' Cancelar ',
                  () => Navigator.pop(context),
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
