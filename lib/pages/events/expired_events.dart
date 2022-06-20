import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';


class ExpiredEvents extends StatefulWidget {
  const ExpiredEvents({Key? key}) : super(key: key);

  @override
  _ExpiredEventsState createState() => _ExpiredEventsState();
}

class _ExpiredEventsState extends State<ExpiredEvents> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedEvent = null;
  }

  @override
  Widget build(BuildContext context) {

    //bool hasEvents = false;

    return Scaffold(
        backgroundColor: colorMainBackground,
        body: homeArea([
          pageHeader(context, 'Historial de eventos'),

          Text('Aquí se muestran los eventos que han expirado. Toca un evento para eliminarlo definitivamente:',
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.05,
                  fontWeight: FontWeight.bold)
          ),
          SizedBox(height: deviceHeight * 0.01),

          StreamBuilder<List<Event>>(
              stream: readExpiredEvents(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('[ERR] ' + snapshot.error.toString());
                  return Container(
                    height: deviceHeight * 0.65,
                    alignment: Alignment.center,
                    child: Text(
                      'Ha ocurrido un error. Revisa tu conexión a Internet o reinicia la app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: deviceWidth * 0.0475, color: colorSecondText),),
                  );
                } else if (snapshot.hasData) {
                  final events = snapshot.data!;
                  //if (events.length>0) hasEvents = true;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (events.length>0) SizedBox(height: deviceHeight * 0.01),
                      Column(children: events.map(buildEventBox).toList(),),
                      if (events.length>0) SizedBox(height: deviceHeight * 0.01),
                    ],);
                } else {
                  return SizedBox.shrink();
                }
              }),

          /*
      // TODO: fix
      if (hasEvents==false) Container(
        height: deviceHeight*0.65,
        alignment: Alignment.center,
        child: Text('No tienes eventos expirados todavía. Estos aparecerán aquí cuando venza su fecha.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: deviceWidth*0.0475, color: colorSecondText),),
      ),
      */
        ]));
  }

  Widget buildEventBox(Event event){

    late int color;
    if (event.color == -1 && darkMode == false) {
      color = 0xFFFFFFFF;
    } else if (event.color == -1 && darkMode == true) {
      color = 0xff1c1c1f;
    } else {
      color = event.color;
    }

    DateTime eventDate = event.dateTime;

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;
    String eventTime = DateFormat('HH:mm').format(event.dateTime);
    if (format24Hours==false) eventTime = DateFormat('h:mm aa').format(event.dateTime);
    Color timeColor = colorSecondText;
    Color iconColor = Colors.red;
    if(event.color != -1) {
      timeColor = colorMainText;
      iconColor = colorMainText;
    }

    return FocusedMenuHolder(
      onPressed: (){
        cancelAllNotifications(event.id);
        deleteEventById(event.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Evento eliminado"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ));
      },
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline_rounded, color: Colors.red, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Eliminar', style: TextStyle(
                    color: Colors.red,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            cancelAllNotifications(event.id);
            deleteEventById(event.id);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Evento eliminado"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ));
          },
        ),
      ],
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(deviceWidth * 0.018),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(color),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(width: deviceWidth*0.0125,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(eventDate.day.toString(), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.0625, fontWeight: FontWeight.bold)),
                      Text(monthConversor(eventDate), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.04, fontWeight: FontWeight.normal)),
                      if (DateTime.now().year != eventDate.year) Text(eventDate.year.toString(), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.034, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  SizedBox(width: deviceWidth*0.0125,),
                  VerticalDivider(color: colorSecondText,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: deviceWidth*0.6,
                          alignment: Alignment.centerLeft,
                          child: Text(event.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.06, fontWeight: FontWeight.bold))),
                      SizedBox(height: deviceHeight*0.00375,),
                      Container(
                          width: deviceWidth*0.6,
                          alignment: Alignment.centerLeft,
                          child: Text('A las $eventTime',
                              style: TextStyle(color: timeColor, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                    ],
                  ),
                  Icon(Icons.delete_outline_rounded, color: iconColor, size: deviceWidth * 0.06),
                ],
              ),
            ),
          ),
          SizedBox(height: deviceHeight*0.0125,),
        ],
      ),
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