import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/sqlite_service.dart';


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

    String eventDate = DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(selectedEvent!.date*1000));
    String colorName = 'Por defecto';
    int colorCode = selectedEvent!.color;
    bool hasNotifications = true;

    if (selectedEvent!.notificationDay==-1 && selectedEvent!.notificationWeek==-1
        && selectedEvent!.notificationMonth==-1) hasNotifications = false;

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
        pageHeader(context, 'Evento'),
        alternativeFormContainer([
          Text(
            selectedEvent!.name,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.065,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          if (selectedEvent!.description == '') Container(
            width: deviceWidth*0.8,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text('Sin descripción',
              style: TextStyle(color: colorThirdText, fontSize: deviceWidth * 0.04,),),
          ),
          if (selectedEvent!.description != '') Container(
            width: deviceWidth*0.8,
            padding: EdgeInsets.all(deviceWidth * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorThirdBackground,
            ),
            child: Text(selectedEvent!.description,
              style: TextStyle(color: colorThirdText, fontSize: deviceWidth * 0.04,),),
          ),
          SizedBox(height: deviceHeight * 0.02),
          Text(
            'Fecha del evento: $eventDate',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
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
              Container(
                width: deviceWidth*0.04,
                height: deviceHeight*0.04,
                margin: const EdgeInsets.fromLTRB(5.0,0.0,5.0,0.0),
                decoration: BoxDecoration(
                    color: Color(colorCode),
                    shape: BoxShape.circle
                ),),
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
        // TODO: desactivar notificaciones (con dialogo)
        alternativeFormContainer([
          Text(
            'Notificaciones: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          if (hasNotifications == false) Text(
            'Sin notificaciones',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.04,
                fontWeight: FontWeight.normal),
          ),
          if (selectedEvent!.notificationDay != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  deleteNotificationDialog(context, selectedEvent!.notificationDay, 'un día antes', 1);
                },
              ),
              Text(
                'Un día antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          if (selectedEvent!.notificationDay != -1 && (selectedEvent!.notificationWeek != -1 || selectedEvent!.notificationMonth != -1)) Divider(color: colorThirdText),
          if (selectedEvent!.notificationWeek != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  deleteNotificationDialog(context, selectedEvent!.notificationWeek, 'una semana antes', 7);
                },
              ),
              Text(
                'Una semana antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          if (selectedEvent!.notificationWeek != -1 && selectedEvent!.notificationMonth != -1) Divider(color: colorThirdText),
          if (selectedEvent!.notificationMonth != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  deleteNotificationDialog(context, selectedEvent!.notificationMonth, 'un mes antes', 30);
                },
              ),
              Text(
                'Un mes antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        eventActionsButton(Icons.edit, colorSpecialItem, ' Editar evento ', (){}),
        SizedBox(height: deviceHeight * 0.025),
        eventActionsButton(Icons.delete_outline_rounded, Colors.red, ' Eliminar evento ', (){}),
        SizedBox(height: deviceHeight * 0.025),
      ]),
    );
  }

  void deleteNotificationDialog(BuildContext context, int id, String notificationText, int notificationType) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: colorMainBackground,
            insetPadding: EdgeInsets.fromLTRB(deviceWidth*0.075,deviceHeight*0.4,deviceWidth*0.075,deviceHeight*0.4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              padding: EdgeInsets.fromLTRB(deviceWidth * 0.075, 0.0, deviceWidth * 0.075, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Eliminar notificación', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.05, fontWeight: FontWeight.bold),),
                  SizedBox(height: deviceHeight*0.01,),
                  Text('Estás a punto de eliminar la notificación de $notificationText. No podrás volver a programarla una vez eliminada.',
                    style: TextStyle(color: colorMainText, fontSize: deviceWidth*0.035, fontWeight: FontWeight.normal),),
                  SizedBox(height: deviceHeight*0.01,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text('Cancelar', style: TextStyle(color: colorSecondText, fontSize: deviceWidth*0.04)),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: deviceWidth*0.075,),
                      TextButton(
                        child: Text('Eliminar', style: TextStyle(color: Colors.red, fontSize: deviceWidth*0.04)),
                        onPressed: (){
                          cancelNotification(id);
                          if (notificationType == 1) {
                            setState(() {
                              selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                                  date: selectedEvent!.date, color: selectedEvent!.color, notificationDay: -1,
                                  notificationWeek: selectedEvent!.notificationWeek, notificationMonth: selectedEvent!.notificationMonth);
                              createEvent(selectedEvent!);
                            });
                          } else if (notificationType == 7) {
                            setState(() {
                              selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                                  date: selectedEvent!.date, color: selectedEvent!.color, notificationDay: selectedEvent!.notificationDay,
                                  notificationWeek: -1, notificationMonth: selectedEvent!.notificationMonth);
                            });
                            createEvent(selectedEvent!);
                          } else {
                            setState(() {
                              selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                                  date: selectedEvent!.date, color: selectedEvent!.color, notificationDay: selectedEvent!.notificationDay,
                                  notificationWeek: selectedEvent!.notificationWeek, notificationMonth: -1);
                            });
                            createEvent(selectedEvent!);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

}

