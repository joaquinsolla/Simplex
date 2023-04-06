import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

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
  String colorName = 'Por defecto';
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

    if(colorCode == -1 && darkMode == false) colorCode = 0xffe3e3e9;
    else if(colorCode == -1 && darkMode == true) colorCode = 0xff706e74;

    switch (colorCode) {
      case 0xffF44336:
        colorName = 'Rojo';
        break;
      case 0xffFF9800:
        colorName = 'Naranja';
        break;
      case 0xffFFCC00:
        colorName = 'Amarillo';
        break;
      case 0xff4CAF50:
        colorName = 'Verde';
        break;
      case 0xff448AFF:
        colorName = 'Azul';
        break;
      case 0xff7C4DFF:
        colorName = 'Violeta';
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(
          null,
          PageHeader(context, 'Evento'),
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
                child: Text('Sin descripción',
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
                  'Tipo de evento:',
                  [
                    if (selectedEvent!.routineEvent==false)Row(children: [
                      Icon(Icons.event_rounded, color: colorSpecialItem, size: deviceWidth*0.05,),
                      SizedBox(width: deviceWidth*0.025,),
                      Text(
                        'Una vez',
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
                        'Rutina',
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
                  'Fecha:',
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
                  'Hora:',
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
                  'Días de la rutina: ',
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
                  'Color:',
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
              FormCustomField('Notificaciones:',
                  [
                    if (selectedEvent!.notificationsList.length == 0) Container(
                      height: deviceHeight*0.035,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.notifications_off_outlined, color: Colors.red, size: deviceWidth*0.05,),
                          SizedBox(width: deviceWidth*0.025,),
                          Text('Sin notificaciones',
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
            MainButton(Icons.edit, colorSpecialItem, ' Editar evento ', (){
              Navigator.pushNamed(context, '/events/edit_event');
            }),
            FormSeparator(),
            MainButton(Icons.delete_outline_rounded, Colors.red, ' Eliminar evento ', (){
              showTextDialog(
                  context,
                  Icons.delete_outline_outlined,
                  'Eliminar evento',
                  'Una vez eliminado no podrás restaurarlo.',
                  'Eliminar',
                  'Cancelar',
                      () async {
                    await cancelAllEventNotifications(selectedEvent!.id);
                    await deleteEventById(selectedEvent!.id);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    showInfoSnackBar(context, 'Evento eliminado.');
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

