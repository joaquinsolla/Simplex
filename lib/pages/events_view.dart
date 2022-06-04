import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

Container eventsView(BuildContext context) {

  // TESTING DATES
  DateTime date1 = DateTime.utc(2022, 5, 18);
  DateTime date2 = DateTime.utc(2022, 7, 30);
  DateTime date3 = DateTime.utc(2022, 9, 3);

  return homeArea([
    homeHeader('Eventos', () {
      // TODO: Navigate to new event
    }),
    eventBox('Examen Flutter', 'Descripcion del evento aaa hola fgyeds a veces si pero no siempre.', date1),
    eventBox('Poner tareas', null, date2),
    eventBox('Comer mucho porque si leñe', 'Descripcion del evento aaa hola fgyeds a veces si pero no siempre. '
        'Descripcion del evento aaa hola fgyeds a veces si pero no siempre.Descripcion del evento aaa hola fgyeds a veces si pero no siempre.'
        'Descripcion del evento aaa hola fgyeds a veces si pero no siempre.'
        'Descripcion del evento aaa hola fgyeds a veces si pero no siempre.', date3),
  ]);
}
