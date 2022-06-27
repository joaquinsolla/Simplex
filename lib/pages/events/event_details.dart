import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';


class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

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

    String eventDate = DateFormat('dd/MM/yyyy').format(selectedEvent!.dateTime);
    if (formatDates == false) eventDate = DateFormat('MM/dd/yyyy').format(selectedEvent!.dateTime);
    String eventTime = DateFormat('HH:mm').format(selectedEvent!.dateTime);
    if (format24Hours==false) eventTime = DateFormat('h:mm aa').format(selectedEvent!.dateTime);
    String colorName = 'Por defecto';
    int colorCode = selectedEvent!.color;

    if(colorCode == -1 && darkMode == false) colorCode = 0xffe3e3e9;
    else if(colorCode == -1 && darkMode == true) colorCode = 0xff706e74;

    switch (colorCode) {
      case 0xffF44336:
        colorName = 'Rojo';
        break;
      case 0xffFF9800:
        colorName = 'Naranja';
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

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: homeArea([
        Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded,
                      color: colorSpecialItem, size: deviceWidth * 0.08),
                  splashRadius: 0.001,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: deviceWidth * 0.0075,
                ),
                headerText('Evento'),
              ],
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            )
          ],
        ),
        alternativeFormContainer([
          Text(
            selectedEvent!.name,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.065,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.01),
          if (selectedEvent!.description == '') Container(
            width: deviceHeight,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text('Sin descripción',
              style: TextStyle(color: colorThirdText, fontSize: deviceWidth * 0.04, fontStyle: FontStyle.italic),),
          ),
          if (selectedEvent!.description != '') Container(
            width: deviceHeight,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text(selectedEvent!.description,
              style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.04,),),
          ),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        alternativeFormContainer([
          Text(
            'Fecha: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Row(children: [
            Icon(Icons.today_rounded, color: colorSpecialItem, size: deviceWidth*0.05,),
            SizedBox(width: deviceWidth*0.025,),
            Text(
              eventDate,
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),
            ),
          ],),
          SizedBox(height: deviceHeight * 0.025),
          Text(
            'Hora: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Row(children: [
            Icon(Icons.watch_later_outlined, color: colorSpecialItem, size: deviceWidth*0.05,),
            SizedBox(width: deviceWidth*0.025,),
            Text(
              eventTime,
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),
            ),
          ],),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        alternativeFormContainer([
          Text(
            'Color: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.radio_button_checked_rounded, color: Color(colorCode), size: deviceWidth*0.05,),
              SizedBox(width: deviceWidth*0.025,),
              Text(
                colorName,
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ]),
        SizedBox(height: deviceHeight * 0.025),

        alternativeFormContainer([
          Text(
            'Notificaciones: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
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
                        fontSize: deviceWidth * 0.04,
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
                        if (selectedEvent!.notificationsList[index].values.first.toDate().isBefore(selectedEvent!.dateTime)) Icon(Icons.notifications_active_outlined, color: colorSpecialItem, size: deviceWidth*0.05,),
                        if (selectedEvent!.notificationsList[index].values.first.toDate().isAfter(selectedEvent!.dateTime)) Icon(Icons.notification_important_outlined, color: Colors.red, size: deviceWidth*0.05,),
                        SizedBox(width: deviceWidth*0.025,),
                        Text(formatNotificationDate(selectedEvent!.notificationsList[index].values.first.toDate()),
                            style: TextStyle(
                                color: colorMainText,
                                fontSize: deviceWidth * 0.04,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  if (index < selectedEvent!.notificationsList.length-1) Divider(color: colorSecondText,),
                ],
              );
            }),
          ),
        ]),
        
        SizedBox(height: deviceHeight * 0.025),
        eventActionsButton(Icons.edit, colorSpecialItem, ' Editar evento ', (){
          Navigator.pushNamed(context, '/events/edit_event');
        }),
        SizedBox(height: deviceHeight * 0.025),
        eventActionsButton(Icons.delete_outline_rounded, Colors.red, ' Eliminar evento ', (){
          cancelAllNotifications(selectedEvent!.id);
          deleteEventById(selectedEvent!.id);
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Evento eliminado"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ));
        }),
        SizedBox(height: deviceHeight * 0.025),
      ]),
    );
  }

}

