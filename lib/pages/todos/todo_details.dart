import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TodoDetails extends StatefulWidget {
  const TodoDetails({Key? key}) : super(key: key);

  @override
  _TodoDetailsState createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime limitDate = DateTime(selectedTodo!.limitDate.year, selectedTodo!.limitDate.month, selectedTodo!.limitDate.day);

    late String limitFormattedDate;
    FontStyle limitFontStyle = FontStyle.normal;
    if (selectedTodo!.limited==false) {
      limitFormattedDate = AppLocalizations.of(context)!.withoutDueDate;
      limitFontStyle = FontStyle.italic;
    }
    else if (formatDates==true) limitFormattedDate = DateFormat('dd/MM/yyyy').format(selectedTodo!.limitDate);
    else limitFormattedDate = DateFormat('MM/dd/yyyy').format(selectedTodo!.limitDate);

    late IconData stateIcon;
    late String stateText;
    if (selectedTodo!.done == true) {
      stateIcon = Icons.done_all_rounded;
      stateText = AppLocalizations.of(context)!.done;
    }
    else {
      stateIcon = Icons.remove_done_rounded;
      stateText = AppLocalizations.of(context)!.pending;
    }


    late IconData priorityIcon;
    late String priorityText;
    if (selectedTodo!.priority == 1) {
      priorityIcon = Icons.star_border_rounded;
      priorityText = AppLocalizations.of(context)!.low;
    }
    else if (selectedTodo!.priority == 2) {
      priorityIcon = Icons.star_half_rounded;
      priorityText = AppLocalizations.of(context)!.medium;
    }
    else {
      priorityIcon = Icons.star_rounded;
      priorityText = AppLocalizations.of(context)!.high;
    }

    late Icon limitFullIcon;
    late Color limitTextColor;
    if (selectedTodo!.limited==false){
      limitFullIcon = Icon(
          Icons.calendar_month_rounded, color: colorSecondText,
          size: deviceWidth * 0.05);
    } else if (todayDate.isAtSameMomentAs(limitDate)){
      limitFullIcon = Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
          size: deviceWidth * 0.05);
    } else if (todayDate.isAfter(limitDate)){
      limitFullIcon = Icon(
          Icons.cancel_outlined, color: Colors.red,
          size: deviceWidth * 0.05);
    } else {
      limitFullIcon = Icon(
          Icons.calendar_month_rounded, color: colorSpecialItem,
          size: deviceWidth * 0.05);
    }

    if (selectedTodo!.limited==false) limitTextColor = colorSecondText;
    else if (todayDate.isAfter(limitDate)) limitTextColor = Colors.red;
    else limitTextColor = colorMainText;

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, AppLocalizations.of(context)!.toDo),
          FooterEmpty(),
          [
        FormContainer([
          ExpandedRow(
            Text(
              selectedTodo!.name,
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * fontSize * 0.065,
                  fontWeight: FontWeight.bold),
            ),
            ShareButton((){
              socialShare(selectedTodo);
            }),
          ),
          if (selectedTodo!.description == '') Container(
            width: deviceHeight,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text(AppLocalizations.of(context)!.noDescription,
              style: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.04, fontStyle: FontStyle.italic),),
          ),
          if (selectedTodo!.description != '') Container(
            width: deviceHeight,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text(selectedTodo!.description,
              style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.04,),),
          ),
        ]),
        FormSeparator(),
        FormContainer([
          Text(
            AppLocalizations.of(context)!.status + ':',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Row(children: [
            Icon(stateIcon, color: colorSpecialItem, size: deviceWidth*0.05,),
            SizedBox(width: deviceWidth*0.025,),
            Text(
              stateText,
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * fontSize * 0.04,
                  fontWeight: FontWeight.normal),
            ),
          ],),
          FormSeparator(),
          Text(
            AppLocalizations.of(context)!.priority + ':',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Row(children: [
            Icon(priorityIcon, color: colorSpecialItem, size: deviceWidth*0.05,),
            SizedBox(width: deviceWidth*0.025,),
            Text(
              priorityText,
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * fontSize * 0.04,
                  fontWeight: FontWeight.normal),
            ),
          ],),
        ]),
        FormSeparator(),
        FormContainer([
          Text(
            AppLocalizations.of(context)!.dueDate + ':',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              limitFullIcon,
              SizedBox(width: deviceWidth*0.025,),
              Text(
                limitFormattedDate,
                style: TextStyle(
                    color: limitTextColor,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal,
                    fontStyle: limitFontStyle),
              ),
            ],
          ),
        ]),

        FormSeparator(),
        MainButton(Icons.edit, colorSpecialItem, ' ' + AppLocalizations.of(context)!.editToDo + ' ', (){
          Navigator.pushNamed(context, '/todos/edit_todo');
        }),
        FormSeparator(),
        MainButton(Icons.delete_outline_rounded, Colors.red, ' ' + AppLocalizations.of(context)!.deleteToDo + ' ', (){
          showTextDialog(
              context,
              Icons.delete_outline_outlined,
              AppLocalizations.of(context)!.deleteToDo,
              AppLocalizations.of(context)!.deleteToDoExplanation,
              AppLocalizations.of(context)!.delete,
              AppLocalizations.of(context)!.cancel,
                  () async {
                await cancelAllTodoNotifications(selectedTodo!.id);
                await deleteTodoById(selectedTodo!.id);
                Navigator.of(context).popUntil((route) => route.isFirst);
                showInfoSnackBar(context, AppLocalizations.of(context)!.toDoDeleted);
              },
                  () {
                Navigator.pop(context);
              }
          );
        }),
          ]
      ),
    );
  }

}

