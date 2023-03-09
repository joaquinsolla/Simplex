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

  String calendarDate = DateFormat('dd/MM/yyyy').format(selectedNote!.calendarDate);
  String modificationDate = DateFormat('dd/MM/yyyy').format(selectedNote!.modificationDate);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (formatDates==false) calendarDate = DateFormat('MM/dd/yyyy').format(selectedNote!.calendarDate);
    if (formatDates==false) modificationDate = DateFormat('MM/dd/yyyy').format(selectedNote!.modificationDate);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, 'Nota'),
          FooterEmpty(),
          [
            FormContainer([
              if (selectedNote!.name == '') ExpandedRow(
                Text(
                  'Sin título',
                  style: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.065, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                ShareButton((){
                  showInfoSnackBar(context, 'En desarollo...');
                }),
              ),
              if (selectedNote!.name != '') ExpandedRow(
                Text(
                  selectedNote!.name,
                  style: TextStyle(
                      color: colorMainText,
                      fontSize: deviceWidth * fontSize * 0.065,
                      fontWeight: FontWeight.bold),
                ),
                ShareButton((){
                  showInfoSnackBar(context, 'En desarollo...');
                }),
              ),
              if (selectedNote!.content == '') Container(
                width: deviceHeight,
                padding: EdgeInsets.all(deviceWidth * 0.025),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorThirdBackground,
                ),
                child: Text('Sin contenido',
                  style: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.04, fontStyle: FontStyle.italic),),
              ),
              if (selectedNote!.content != '') Container(
                width: deviceHeight,
                padding: EdgeInsets.all(deviceWidth * 0.025),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorThirdBackground,
                ),
                child: Text(selectedNote!.content,
                  style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.04,),),
              ),
            ]),
            FormSeparator(),
            FormContainer([
              FormCustomField(
                  'Última edición:',
                  [
                    Row(children: [
                      Icon(Icons.edit_note_rounded, color: colorSpecialItem, size: deviceWidth * 0.05),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        modificationDate,
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.04,
                            fontWeight: FontWeight.normal),
                      ),
                    ],),
                  ],
                  false
              ),
              FormCustomField(
                  'En el calendario:',
                  [
                    if (selectedNote!.onCalendar==false) Row(children: [
                      Icon(Icons.calendar_month_rounded, color: colorSecondText, size: deviceWidth * 0.05),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        'No',
                        style: TextStyle(
                            color: colorSecondText,
                            fontSize: deviceWidth * fontSize * 0.04,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic),
                      ),
                    ],),
                    if (selectedNote!.onCalendar==true) Row(children: [
                      Icon(Icons.calendar_month_rounded, color: colorSpecialItem, size: deviceWidth * 0.05),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        calendarDate,
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.04,
                            fontWeight: FontWeight.normal),
                      ),

                    ],),
                  ],
                  false
              ),
              FormCustomField(
                  'En mis rutinas:',
                  [
                    if (selectedNote!.routineNote==false) Row(children: [
                      Icon(Icons.sync_disabled_rounded, color: colorSecondText, size: deviceWidth*0.05,),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        'No',
                        style: TextStyle(
                            color: colorSecondText,
                            fontSize: deviceWidth * fontSize * 0.04,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic),
                      ),
                    ],),
                    if (selectedNote!.routineNote==true) Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(selectedNote!.routinesList.length,(index){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: deviceHeight*0.035,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.loop_rounded, color: colorSpecialItem, size: deviceWidth*0.05,),
                                  SizedBox(width: deviceWidth*0.025,),
                                  Text(dayIdToString(selectedNote!.routinesList[index]),
                                      style: TextStyle(
                                          color: colorMainText,
                                          fontSize: deviceWidth * fontSize * 0.04,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            if (index < selectedNote!.routinesList.length-1) Divider(color: colorSecondText,),
                          ],
                        );
                      }),
                    ),
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            MainButton(Icons.edit, colorSpecialItem, ' Editar nota ', (){
              Navigator.pushNamed(context, '/notes/edit_note');
            }),
            FormSeparator(),
            MainButton(Icons.delete_outline_rounded, Colors.red, ' Eliminar nota ', (){
              showTextDialog(
                  context,
                  Icon(Icons.delete_outline_outlined),
                  'Eliminar nota',
                  'Una vez eliminada no podrás restaurarla.',
                  'Eliminar',
                  'Cancelar',
                      () async {
                    await cancelNoteNotification(selectedNote!.id);
                    await deleteNoteById(selectedNote!.id);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    showInfoSnackBar(context, 'Nota eliminada.');
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

