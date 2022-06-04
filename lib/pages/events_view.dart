import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/sqlite_service.dart';

Container eventsView(BuildContext context, List<Event> events) {

  return homeArea([
    homeHeader('Eventos', () {
      Navigator.pushNamed(context, '/add_event');
    }),

    for (var event in events) eventBox(event.name, event.description, DateTime.fromMicrosecondsSinceEpoch(event.date * 1000)),

    if (events.isEmpty) Container(
      height: deviceHeight*0.65,
      alignment: Alignment.center,
      child: Text('No tienes eventos guardados todavía. Para crear uno pulsa el botón + en la parte superior de la pantalla.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: deviceWidth*0.0475, color: colorSecondText),),
    ),
  ]);
}
