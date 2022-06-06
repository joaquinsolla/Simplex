import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/sqlite_service.dart';

Container eventsView(BuildContext context, List<Event> todayEvents, List<Event> thisMonthEvents, List<Event> restOfEvents) {

  String todayAmount = todayEvents.length.toString();
  String thisMonthAmount = thisMonthEvents.length.toString();
  String restAmount = restOfEvents.length.toString();

  return homeArea([
    homeHeader('Eventos', () {
      Navigator.pushNamed(context, '/add_event');
    }),

    if (todayEvents.isNotEmpty) Text('Hoy ($todayAmount)',
      style: TextStyle(
      color: colorMainText,
      fontSize: deviceWidth * 0.05,
      fontWeight: FontWeight.bold)
    ),
    if (todayEvents.isNotEmpty) SizedBox(height: deviceHeight * 0.01),
    for (var event in todayEvents) eventBox(event.name, event.description, DateTime.fromMicrosecondsSinceEpoch(event.date * 1000), event.color),

    if (thisMonthEvents.isNotEmpty) SizedBox(height: deviceHeight * 0.02),
    if (thisMonthEvents.isNotEmpty) Text('Este mes ($thisMonthAmount)',
        style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.05,
            fontWeight: FontWeight.bold)
    ),
    if (thisMonthEvents.isNotEmpty) SizedBox(height: deviceHeight * 0.01),
    for (var event in thisMonthEvents) eventBox(event.name, event.description, DateTime.fromMicrosecondsSinceEpoch(event.date * 1000), event.color),

    if (thisMonthEvents.isNotEmpty) SizedBox(height: deviceHeight * 0.02),
    if (restOfEvents.isNotEmpty) Text('Próximamente ($restAmount)',
        style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.05,
            fontWeight: FontWeight.bold)
    ),
    if (restOfEvents.isNotEmpty) SizedBox(height: deviceHeight * 0.01),
    for (var event in restOfEvents) eventBox(event.name, event.description, DateTime.fromMicrosecondsSinceEpoch(event.date * 1000), event.color),


    if (todayEvents.isEmpty && thisMonthEvents.isEmpty && restOfEvents.isEmpty) Container(
      height: deviceHeight*0.65,
      alignment: Alignment.center,
      child: Text('No tienes eventos guardados todavía. Para crear uno pulsa el botón + en la parte superior de la pantalla.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: deviceWidth*0.0475, color: colorSecondText),),
    ),
  ]);
}
