import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';


class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late final int oldNot5Min;
  late final int oldNot1Hour;
  late final int oldNot1Day;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    oldNot5Min = selectedEvent!.not5Min;
    oldNot1Hour = selectedEvent!.not1Hour;
    oldNot1Day = selectedEvent!.not1Day;
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
                    if (oldNot5Min != selectedEvent!.not5Min || oldNot1Hour != selectedEvent!.not1Hour || oldNot1Day != selectedEvent!.not1Day)
                      updateEventNotifications(selectedEvent!.id, selectedEvent!.not5Min, selectedEvent!.not1Hour, selectedEvent!.not1Day);
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
          if (selectedEvent!.not5Min == -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: colorSpecialItem, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){

                  DateTime now = DateTime.now();
                  int eventId = selectedEvent!.id;
                  int not5Min = int.parse("1"+"$eventId");
                  bool canNotify = showNotification(context, not5Min, selectedEvent!.name, 1, now, selectedEvent!.dateTime);

                  if (canNotify){
                    setState(() {
                      selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                          dateTime: selectedEvent!.dateTime, color: selectedEvent!.color,
                          not5Min: not5Min, not1Hour: selectedEvent!.not1Hour,
                          not1Day: selectedEvent!.not1Day);
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
          if (selectedEvent!.not5Min != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  cancelNotification(selectedEvent!.not5Min);
                  setState(() {
                    selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color, not5Min: -1,
                        not1Hour: selectedEvent!.not1Hour, not1Day: selectedEvent!.not1Day);
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
          if (selectedEvent!.not1Hour == -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: colorSpecialItem, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  DateTime now = DateTime.now();
                  int eventId = selectedEvent!.id;
                  int not1Hour = int.parse("2"+"$eventId");
                  bool canNotify = showNotification(context, not1Hour, selectedEvent!.name, 2, now, selectedEvent!.dateTime);

                  if (canNotify){
                    setState(() {
                      selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                          dateTime: selectedEvent!.dateTime, color: selectedEvent!.color,
                          not5Min: selectedEvent!.not5Min, not1Hour: not1Hour,
                          not1Day: selectedEvent!.not1Day);
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
          if (selectedEvent!.not1Hour != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  cancelNotification(selectedEvent!.not1Hour);
                  setState(() {
                    selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color, not5Min: selectedEvent!.not5Min,
                        not1Hour: -1, not1Day: selectedEvent!.not1Day);
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
          if (selectedEvent!.not1Day == -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.add_rounded,
                    color: colorSpecialItem, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  DateTime now = DateTime.now();
                  int eventId = selectedEvent!.id;
                  int not1Day = int.parse("3"+"$eventId");
                  bool canNotify = showNotification(context, not1Day, selectedEvent!.name, 3, now, selectedEvent!.dateTime);

                  if (canNotify){
                    setState(() {
                      selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                          dateTime: selectedEvent!.dateTime, color: selectedEvent!.color,
                          not5Min: selectedEvent!.not5Min, not1Hour: selectedEvent!.not1Hour,
                          not1Day: not1Day);
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
          if (selectedEvent!.not1Day != -1) Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: deviceWidth * 0.06),
                splashRadius: 0.001,
                onPressed: (){
                  cancelNotification(selectedEvent!.not1Day);
                  setState(() {
                    selectedEvent = Event(id: selectedEvent!.id, name: selectedEvent!.name, description: selectedEvent!.description,
                        dateTime: selectedEvent!.dateTime, color: selectedEvent!.color, not5Min: selectedEvent!.not5Min,
                        not1Hour: selectedEvent!.not1Hour, not1Day: -1);
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
          if (oldNot5Min != selectedEvent!.not5Min || oldNot1Hour != selectedEvent!.not1Hour || oldNot1Day != selectedEvent!.not1Day)
            updateEventNotifications(selectedEvent!.id, selectedEvent!.not5Min, selectedEvent!.not1Hour, selectedEvent!.not1Day);
          Navigator.pushNamed(context, '/events/edit_event');
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
                          cancelAllNotifications(selectedEvent!.id);
                          deleteEventById(selectedEvent!.id);
                          Navigator.of(context).popUntil((route) => route.isFirst);
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

