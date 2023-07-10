import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  DateTime eventDate = selectedEvent!.date;
  DateTime eventTime = selectedEvent!.time;
  late DateTime eventDateTime;
  String eventDateString = DateFormat('dd/MM/yyyy').format(selectedEvent!.date);
  String eventTimeString = timeToString(selectedEvent!.time);
  int colorCode = selectedEvent!.color;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    eventDateTime = DateTime(eventDate.year, eventDate.month, eventDate.day, eventTime.hour, eventTime.minute);

    if (formatDates == false) eventDateString = DateFormat('MM/dd/yyyy').format(selectedEvent!.date);
  }

  @override
  Widget build(BuildContext context) {
    String colorName = AppLocalizations.of(context)!.byDefault;

    if(colorCode == -1 && darkMode == false) colorCode = 0xffe3e3e9;
    else if(colorCode == -1 && darkMode == true) colorCode = 0xff706e74;

    switch (colorCode) {
      case 0xffF44336:
        colorName = AppLocalizations.of(context)!.colourRed;
        break;
      case 0xffFF9800:
        colorName = AppLocalizations.of(context)!.colourOrange;
        break;
      case 0xffFFCC00:
        colorName = AppLocalizations.of(context)!.colourYellow;
        break;
      case 0xff4CAF50:
        colorName = AppLocalizations.of(context)!.colourGreen;
        break;
      case 0xff448AFF:
        colorName = AppLocalizations.of(context)!.colourBlue;
        break;
      case 0xff7C4DFF:
        colorName = AppLocalizations.of(context)!.colourPurple;
        break;
      default:
        break;
    }

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(
          null,
          PageHeader(context, AppLocalizations.of(context)!.event),
          FooterEmpty(),
          [
            FormContainer([
              ExpandedRow(
                Text(
                selectedEvent!.name,
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * fontSize * 0.065,
                    fontWeight: FontWeight.bold),
              ),
                ShareButton((){
                  socialShare(selectedEvent);
                }),
              ),
              if (selectedEvent!.description == '') Container(
                width: deviceHeight,
                padding: EdgeInsets.all(deviceWidth * 0.025),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorThirdBackground,
                ),
                child: Text(AppLocalizations.of(context)!.noDescription,
                  style: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.04, fontStyle: FontStyle.italic),),
              ),
              if (selectedEvent!.description != '') Container(
                width: deviceHeight,
                padding: EdgeInsets.all(deviceWidth * 0.025),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorThirdBackground,
                ),
                child: Text(selectedEvent!.description,
                  style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.04,),),
              ),
            ]),
            FormSeparator(),
            FormContainer([
              FormCustomField(
                  AppLocalizations.of(context)!.eventType + ':',
                  [
                    if (selectedEvent!.routineEvent==false)Row(children: [
                      Icon(Icons.event_rounded, color: colorSpecialItem, size: deviceWidth*0.05,),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        AppLocalizations.of(context)!.once,
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.04,
                            fontWeight: FontWeight.normal),
                      ),
                    ],),
                    if (selectedEvent!.routineEvent==true)Row(children: [
                      Icon(Icons.event_repeat_rounded, color: colorSpecialItem, size: deviceWidth*0.05,),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        AppLocalizations.of(context)!.routine,
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.04,
                            fontWeight: FontWeight.normal),
                      ),
                    ],),
                  ],
                  false
              ),
              if (selectedEvent!.routineEvent==false) FormCustomField(
                  AppLocalizations.of(context)!.date + ':',
                  [
                    Row(children: [
                      Icon(Icons.calendar_month_rounded, color: colorSpecialItem, size: deviceWidth*0.05,),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        eventDateString,
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.04,
                            fontWeight: FontWeight.normal),
                      ),
                    ]),
                  ],
                  false
              ),
              FormCustomField(
                  AppLocalizations.of(context)!.time + ':',
                  [
                    Row(children: [
                      Icon(Icons.watch_later_outlined, color: colorSpecialItem, size: deviceWidth*0.05,),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        eventTimeString,
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.04,
                            fontWeight: FontWeight.normal),
                      ),
                    ],)
                  ],
                  true
              ),
            ]),
            if (selectedEvent!.routineEvent==true)FormSeparator(),
            if (selectedEvent!.routineEvent==true)FormContainer([
              FormCustomField(
                  AppLocalizations.of(context)!.routineDays + ': ',
                  [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(selectedEvent!.routinesList.length,(index){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: deviceHeight*0.035,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.check, color: colorSpecialItem, size: deviceWidth*0.05,),
                                  SizedBox(width: deviceWidth*0.025,),
                                  Text(dayIdToString(selectedEvent!.routinesList[index]),
                                      style: TextStyle(
                                          color: colorMainText,
                                          fontSize: deviceWidth * fontSize * 0.04,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            if (index < selectedEvent!.routinesList.length-1) Divider(color: colorSecondText,),
                          ],
                        );
                      }),
                    ),
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            FormContainer([
              FormCustomField(
                  AppLocalizations.of(context)!.colour + ':',
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.radio_button_checked_rounded, color: Color(colorCode), size: deviceWidth*0.05,),
                        SizedBox(width: deviceWidth*0.025,),
                        Text(
                          colorName,
                          style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * fontSize * 0.04,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                  true
              ),
            ]),
            if (selectedEvent!.routineEvent==false)FormSeparator(),
            if (selectedEvent!.routineEvent==false)FormContainer([
              FormCustomField(AppLocalizations.of(context)!.notifications + ':',
                  [
                    if (selectedEvent!.notificationsList.length == 0) Container(
                      height: deviceHeight*0.035,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.notifications_off_outlined, color: Colors.red, size: deviceWidth*0.05,),
                          SizedBox(width: deviceWidth*0.025,),
                          Text(AppLocalizations.of(context)!.noNotifications,
                              style: TextStyle(
                                  color: colorMainText,
                                  fontSize: deviceWidth * fontSize * 0.04,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                    if (selectedEvent!.notificationsList.length > 0) Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(selectedEvent!.notificationsList.length,(index){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: deviceHeight*0.035,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (selectedEvent!.notificationsList[index].values.first.toDate().isBefore(eventDateTime)) Icon(Icons.notifications_active_outlined, color: colorSpecialItem, size: deviceWidth*0.05,),
                                  if (selectedEvent!.notificationsList[index].values.first.toDate().isAfter(eventDateTime)) Icon(Icons.notification_important_outlined, color: Colors.red, size: deviceWidth*0.05,),
                                  SizedBox(width: deviceWidth*0.025,),
                                  Text(formatEventNotificationDate(selectedEvent!.notificationsList[index].values.first.toDate()),
                                      style: TextStyle(
                                          color: colorMainText,
                                          fontSize: deviceWidth * fontSize * 0.04,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            if (index < selectedEvent!.notificationsList.length-1) Divider(color: colorSecondText,),
                          ],
                        );
                      }),
                    ),
                  ],
                  true
              ),
            ]),
            FormSeparator(),
            MainButton(Icons.edit, colorSpecialItem, ' ' + AppLocalizations.of(context)!.editEvent + ' ', (){
              Navigator.pushNamed(context, '/events/edit_event');
            }),
            FormSeparator(),
            MainButton(Icons.delete_outline_rounded, Colors.red,' ' + AppLocalizations.of(context)!.deleteEvent + ' ', (){
              showTextDialog(
                  context,
                  Icons.delete_outline_outlined,
                  AppLocalizations.of(context)!.deleteEvent,
                  AppLocalizations.of(context)!.deleteEventExplanation,
                  AppLocalizations.of(context)!.delete,
                  AppLocalizations.of(context)!.cancel,
                      () async {
                    await cancelAllEventNotifications(selectedEvent!.id);
                    await deleteEventById(selectedEvent!.id);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    showInfoSnackBar(context, AppLocalizations.of(context)!.eventDeleted);
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

