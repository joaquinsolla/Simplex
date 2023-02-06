import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class HelpEvents extends StatefulWidget {
  const HelpEvents({Key? key}) : super(key: key);

  @override
  _HelpEventsState createState() => _HelpEventsState();
}

class _HelpEventsState extends State<HelpEvents> {

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

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea([
        PageHeader(context, 'Calendario'),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Los eventos',
              'Los eventos repesentan actividades o sucesos en una fecha y hora '
                  'concretos. Siempre aparecen en el calendario y cuentan con: '
                  'un título, descripción, fecha, hora, color y hasta 5 '
                  'notificaciones.'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Creación de eventos',
              'Los eventos pueden ser creados de dos formas: \n'
                  '1) Pulsando el botón + en la ventana del calendario.\n'
                  '2) Manteniendo pulsado el día deseado en el calendario.'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Notificaciones de eventos',
              'Se te notificará acerca de un evento si configuras una '
                  'notificación, esta te llegará al móvil en el momento '
                  'seleccionado a modo de recordatorio indicándote en qué fecha'
                  ' y hora será.'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Otros elementos en el calendario',
              'Además de eventos, el calendario también puede mostrar: tareas '
                  'con fecha límite, notas de calendario y rutinas. '
                  'Todos estos elementos aparecerán representados como puntos '
                  'en su día correspondiente.'),
        ],),
        FooterCredits(),
      ]),
    );
  }

}

