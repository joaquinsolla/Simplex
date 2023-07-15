import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/todo.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    String dateHintText = AppLocalizations.of(context)!.dateHintDefaultToday;

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, AppLocalizations.of(context)!.newToDo),
          FooterEmpty(),
          [
            FormContainer([
              FormTextField(
                  nameController, AppLocalizations.of(context)!.name + ':', AppLocalizations.of(context)!.mandatory, nameFocusNode, false),
              FormTextField(
                  descriptionController, AppLocalizations.of(context)!.description + ':', AppLocalizations.of(context)!.optional, descriptionFocusNode, true),
            ]),
            FormSeparator(),
            FormContainer([
              FormCustomField(
                  AppLocalizations.of(context)!.priority + ':',
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
                            label: AppLocalizations.of(context)!.low,
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
                              label: AppLocalizations.of(context)!.medium,
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
                              label: AppLocalizations.of(context)!.high,
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
                  AppLocalizations.of(context)!.dueDate + ':',
                  [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.dueDateExplanation,
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
                          AppLocalizations.of(context)!.toDoWithDueDate,
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
                ' ' + AppLocalizations.of(context)!.createToDo + ' ',
                    () {
                  if (nameController.text.trim().isEmpty) {
                    showErrorSnackBar(context, AppLocalizations.of(context)!.errorTypeName);
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
                      if (limited) buildTodoNotifications(id, AppLocalizations.of(context)!.pendingToDo +': ' + nameController.text, limitDate, context);
                      Navigator.pop(context);
                      showInfoSnackBar(context, AppLocalizations.of(context)!.toDoCreated);
                    } on Exception catch (e) {
                      debugPrint('[ERR] Could not create todo: $e');
                      showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
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
      helpText: AppLocalizations.of(context)!.calendarSelectDueDate,
      cancelText: AppLocalizations.of(context)!.calendarCancel,
      confirmText: AppLocalizations.of(context)!.calendarConfirm,
      fieldHintText: AppLocalizations.of(context)!.calendarHintDDMMYYYY,
      fieldLabelText: AppLocalizations.of(context)!.dueDate,
      errorFormatText: AppLocalizations.of(context)!.calendarErrorDate,
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
