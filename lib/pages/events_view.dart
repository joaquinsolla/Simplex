import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/sqlite_service.dart';

Container eventsView(BuildContext context, List<Event> events) {

  return homeArea([
    homeHeader('Eventos', () {
      // TODO: Navigate to new event
    }),

    for (var event in events) eventBox(event.name, event.description, DateTime.fromMicrosecondsSinceEpoch(event.date * 1000)),

  ]);
}
