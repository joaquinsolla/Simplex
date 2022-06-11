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

    String eventDate = DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(selectedEvent!.dateTime*1000));
    String eventTime = DateFormat('HH:mm').format(DateTime.fromMicrosecondsSinceEpoch(selectedEvent!.dateTime*1000));
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
        pageHeader(context, 'Evento', '/home'),
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
          Text(
            eventDate,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.04,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(height: deviceHeight * 0.025),
          Text(
            'Hora: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Text(
            eventTime,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.04,
                fontWeight: FontWeight.normal),
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
        alternativeFormContainer([
          Text(
            'Gestionar notificaciones: ',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          if (selectedEvent!.notification5Min == -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: colorSpecialItem, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  DateTime now = DateTime.now();
                  int eventId = selectedEvent!.id;
                  int notification5MinId = int.parse("1"+"$eventId");
                  bool validNotification = showNotification(context, notification5MinId, selectedEvent!.name, 1, now, DateTime.fromMicrosecondsSinceEpoch(selectedEvent!.dateTime*1000));

                  if (validNotification){
                    Event newEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color,
                        notification5Min: notification5MinId, notification1Hour: selectedEvent!.notification1Hour,
                        notification1Day: selectedEvent!.notification1Day);
                    createEvent(newEvent);
                    setState(() {
                      selectedEvent = newEvent;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Notificación añadida: 5 minutos antes"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No se puede añadir la notificación: El tiempo ya ha vencido"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                  }

                },
              ),
              Text(
                '5 minutos antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          if (selectedEvent!.notification5Min != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  cancelNotification(selectedEvent!.notification5Min);
                  setState(() {
                    selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color, notification5Min: -1,
                        notification1Hour: selectedEvent!.notification1Hour, notification1Day: selectedEvent!.notification1Day);
                    createEvent(selectedEvent!);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Notificación eliminada: 5 minutos antes"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ));
                },
              ),
              Text(
                '5 minutos antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Divider(color: colorThirdText),
          if (selectedEvent!.notification1Hour == -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: colorSpecialItem, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  DateTime now = DateTime.now();
                  int eventId = selectedEvent!.id;
                  int notification1HourId = int.parse("2"+"$eventId");
                  bool validNotification = showNotification(context, notification1HourId, selectedEvent!.name, 2, now, DateTime.fromMicrosecondsSinceEpoch(selectedEvent!.dateTime*1000));
                  if (validNotification) {
                    Event newEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color,
                        notification5Min: selectedEvent!.notification5Min, notification1Hour: notification1HourId,
                        notification1Day: selectedEvent!.notification1Day);
                    createEvent(newEvent);
                    setState(() {
                      selectedEvent = newEvent;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Notificación añadida: 1 hora antes"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No se puede añadir la notificación: El tiempo ya ha vencido"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
              ),
              Text(
                '1 hora antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          if (selectedEvent!.notification1Hour != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  cancelNotification(selectedEvent!.notification1Hour);
                  setState(() {
                    selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color, notification5Min: selectedEvent!.notification5Min,
                        notification1Hour: -1, notification1Day: selectedEvent!.notification1Day);
                    createEvent(selectedEvent!);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Notificación eliminada: 1 hora antes"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ));
                },
              ),
              Text(
                '1 hora antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Divider(color: colorThirdText),
          if (selectedEvent!.notification1Day == -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: colorSpecialItem, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  DateTime now = DateTime.now();
                  int eventId = selectedEvent!.id;
                  int notification1DayId = int.parse("3"+"$eventId");
                  bool validNotification = showNotification(context, notification1DayId, selectedEvent!.name, 3, now, DateTime.fromMicrosecondsSinceEpoch(selectedEvent!.dateTime*1000));
                  if (validNotification) {
                    Event newEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color,
                        notification5Min: selectedEvent!.notification5Min, notification1Hour: selectedEvent!.notification1Hour,
                        notification1Day: notification1DayId);
                    createEvent(newEvent);
                    setState(() {
                      selectedEvent = newEvent;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Notificación añadida: 1 día antes"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No se puede añadir la notificación: El tiempo ya ha vencido"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
              ),
              Text(
                '1 día antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          if (selectedEvent!.notification1Day != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  cancelNotification(selectedEvent!.notification1Day);
                  setState(() {
                    selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color, notification5Min: selectedEvent!.notification5Min,
                        notification1Hour: selectedEvent!.notification1Hour, notification1Day: -1);
                    createEvent(selectedEvent!);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Notificación eliminada: 1 día antes"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ));
                },
              ),
              Text(
                '1 día antes',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),

        ]),
        SizedBox(height: deviceHeight * 0.025),
        eventActionsButton(Icons.edit, colorSpecialItem, ' Editar evento ', (){
          Navigator.pushReplacementNamed(context, '/events/edit_event');
        }),
        SizedBox(height: deviceHeight * 0.025),
        eventActionsButton(Icons.delete_outline_rounded, Colors.red, ' Eliminar evento ', (){
          deleteEventDialog(context);
        }),
        SizedBox(height: deviceHeight * 0.025),
      ]),
    );
  }

  void deleteEventDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: colorMainBackground,
            insetPadding: EdgeInsets.fromLTRB(deviceWidth*0.075,deviceHeight*0.385,deviceWidth*0.075,deviceHeight*0.385),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              padding: EdgeInsets.fromLTRB(deviceWidth * 0.075, 0.0, deviceWidth * 0.075, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Eliminar evento', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.05, fontWeight: FontWeight.bold),),
                  SizedBox(height: deviceHeight*0.01,),
                  Text('Estás a punto de eliminar el evento "' + selectedEvent!.name + '". Una vez eliminado no podrás restablecerlo. También se eliminarán sus notificaciones asignadas.',
                    style: TextStyle(color: colorMainText, fontSize: deviceWidth*0.035, fontWeight: FontWeight.normal),textAlign: TextAlign.center,),
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
                          if (selectedEvent!.notification5Min != -1) cancelNotification(selectedEvent!.notification5Min);
                          if (selectedEvent!.notification1Hour != -1) cancelNotification(selectedEvent!.notification1Hour);
                          if (selectedEvent!.notification1Day != -1) cancelNotification(selectedEvent!.notification1Day);
                          deleteEventById(selectedEvent!.id);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/home');
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Evento eliminado"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ));
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

