import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';


class NoteDetails extends StatefulWidget {
  const NoteDetails({Key? key}) : super(key: key);

  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {

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

    String calendarDate = DateFormat('dd/MM/yyyy').format(selectedNote!.calendarDate);
    if (formatDates==false) calendarDate = DateFormat('MM/dd/yyyy').format(selectedNote!.calendarDate);
    String modificationDate = DateFormat('dd/MM/yyyy').format(selectedNote!.modificationDate);
    if (formatDates==false) modificationDate = DateFormat('MM/dd/yyyy').format(selectedNote!.modificationDate);

    Icon calendarIcon = Icon(Icons.calendar_month_rounded, color: colorSpecialItem, size: deviceWidth * 0.05);
    if (selectedNote!.onCalendar == false) calendarIcon = Icon(Icons.calendar_month_rounded,
        color: colorSecondText, size: deviceWidth * 0.05);

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: NewHomeArea(null,
          PageHeader(context, 'Nota'),
          FooterEmpty(),
          [
        FormContainer([
          if (selectedNote!.name == '') Text(
            'Sin título',
              style: TextStyle(color: colorThirdText, fontSize: deviceWidth * 0.065, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
          if (selectedNote!.name != '') Text(
            selectedNote!.name,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.065,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.01),
          if (selectedNote!.content == '') Container(
            width: deviceHeight,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text('Sin contenido',
              style: TextStyle(color: colorThirdText, fontSize: deviceWidth * 0.04, fontStyle: FontStyle.italic),),
          ),
          if (selectedNote!.content != '') Container(
            width: deviceHeight,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text(selectedNote!.content,
              style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.04,),),
          ),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        FormContainer([
          Text(
            'En el calendario: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Row(children: [
            calendarIcon,
            SizedBox(width: deviceWidth*0.025,),
            if (selectedNote!.onCalendar==false) Text(
              'No',
              style: TextStyle(
                  color: colorSecondText,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            ),
            if (selectedNote!.onCalendar==true) Text(
              calendarDate,
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),
            ),

          ],),
          SizedBox(height: deviceHeight * 0.025),
          Text(
            'Última edición: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Row(children: [
            Icon(Icons.edit_note_rounded, color: colorSpecialItem, size: deviceWidth * 0.05),
            SizedBox(width: deviceWidth*0.025,),
            Text(
              modificationDate,
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),
            ),
          ],),
        ]),

        SizedBox(height: deviceHeight * 0.025),
        MainButton(Icons.edit, colorSpecialItem, ' Editar nota ', (){
          Navigator.pushNamed(context, '/notes/edit_note');
        }),
        SizedBox(height: deviceHeight * 0.025),
        MainButton(Icons.delete_outline_rounded, Colors.red, ' Eliminar nota ', (){
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('Eliminar nota'),
                  content: Text('Una vez eliminada no podrás restaurarla.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () async {
                          await cancelNoteNotification(selectedNote!.id);
                          await deleteNoteById(selectedNote!.id);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          showSnackBar(context, 'Nota eliminada', Colors.green);
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

