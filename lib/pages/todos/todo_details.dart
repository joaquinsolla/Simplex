import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';


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
      limitFormattedDate = 'Sin fecha límite';
      limitFontStyle = FontStyle.italic;
    }
    else if (formatDates==true) limitFormattedDate = DateFormat('dd/MM/yyyy').format(selectedTodo!.limitDate);
    else limitFormattedDate = DateFormat('MM/dd/yyyy').format(selectedTodo!.limitDate);

    late IconData stateIcon;
    late String stateText;
    if (selectedTodo!.done == true) {
      stateIcon = Icons.done_all_rounded;
      stateText = 'Hecho';
    }
    else {
      stateIcon = Icons.remove_done_rounded;
      stateText = 'Pendiente';
    }


    late IconData priorityIcon;
    late String priorityText;
    if (selectedTodo!.priority == 1) {
      priorityIcon = Icons.star_border_rounded;
      priorityText = 'Baja';
    }
    else if (selectedTodo!.priority == 2) {
      priorityIcon = Icons.star_half_rounded;
      priorityText = 'Media';
    }
    else {
      priorityIcon = Icons.star_rounded;
      priorityText = 'Alta';
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
          PageHeader(context, 'Tarea'),
          FooterEmpty(),
          [
        FormContainer([
          Text(
            selectedTodo!.name,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.065,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.01),
          if (selectedTodo!.description == '') Container(
            width: deviceHeight,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text('Sin descripción',
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
        SizedBox(height: deviceHeight * 0.025),
        FormContainer([
          Text(
            'Estado: ',
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
          SizedBox(height: deviceHeight * 0.025),
          Text(
            'Prioridad: ',
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
        SizedBox(height: deviceHeight * 0.025),
        FormContainer([
          Text(
            'Fecha límite: ',
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

        SizedBox(height: deviceHeight * 0.025),
        MainButton(Icons.edit, colorSpecialItem, ' Editar tarea ', (){
          Navigator.pushNamed(context, '/todos/edit_todo');
        }),
        SizedBox(height: deviceHeight * 0.025),
        MainButton(Icons.delete_outline_rounded, Colors.red, ' Eliminar tarea ', (){
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('Eliminar tarea'),
                  content: Text('Una vez eliminada no podrás restaurarla.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () async {
                          await cancelAllTodoNotifications(selectedTodo!.id);
                          await deleteTodoById(selectedTodo!.id);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          showSnackBar(context, 'Tarea eliminada', Colors.green);
                        },
                        child: Text('Eliminar', style: TextStyle(color: colorSpecialItem),)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar', style: TextStyle(color: Colors.red),),
                    )
                  ],
                );
              });
        }),
          ]
      ),
    );
  }

}

