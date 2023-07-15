import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
          PageHeader(context, AppLocalizations.of(context)!.note),
          FooterEmpty(),
          [
            FormContainer([
              if (selectedNote!.name == '') ExpandedRow(
                Text(
                  AppLocalizations.of(context)!.noTitle,
                  style: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.065, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                ShareButton((){
                  socialShare(selectedNote);
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
                  socialShare(selectedNote);
                }),
              ),
              if (selectedNote!.content == '') Container(
                width: deviceHeight,
                padding: EdgeInsets.all(deviceWidth * 0.025),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorThirdBackground,
                ),
                child: Text(AppLocalizations.of(context)!.noContent,
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
                  AppLocalizations.of(context)!.lastEdit + ':',
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
                  AppLocalizations.of(context)!.onTheCalendar + ':',
                  [
                    if (selectedNote!.onCalendar==false) Row(children: [
                      Icon(Icons.calendar_month_rounded, color: colorSecondText, size: deviceWidth * 0.05),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        AppLocalizations.of(context)!.no,
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
                  AppLocalizations.of(context)!.onMyRoutines + ':',
                  [
                    if (selectedNote!.routineNote==false) Row(children: [
                      Icon(Icons.sync_disabled_rounded, color: colorSecondText, size: deviceWidth*0.05,),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        AppLocalizations.of(context)!.no,
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
            MainButton(Icons.edit, colorSpecialItem, ' ' + AppLocalizations.of(context)!.toEditNote + ' ', (){
              Navigator.pushNamed(context, '/notes/edit_note');
            }),
            FormSeparator(),
            MainButton(Icons.delete_outline_rounded, Colors.red, ' ' + AppLocalizations.of(context)!.deleteNote + ' ', (){
              showTextDialog(
                  context,
                  Icons.delete_outline_outlined,
                  AppLocalizations.of(context)!.deleteNote,
                  AppLocalizations.of(context)!.deleteNoteExplanation,
                  AppLocalizations.of(context)!.delete,
                  AppLocalizations.of(context)!.cancel,
                      () async {
                    await cancelNoteNotification(selectedNote!.id);
                    await deleteNoteById(selectedNote!.id);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    showInfoSnackBar(context, AppLocalizations.of(context)!.noteDeleted);
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

