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

    late String calendarButtonImage;
    if (darkMode) calendarButtonImage = 'assets/calendar_button_dark.png';
    else calendarButtonImage = 'assets/calendar_button_light.png';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea([
        PageHeader(context, 'Calendario'),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Elementos en el calendario',
              'El calendario puede mostrar: eventos, tareas con fecha límite y '
                  'notas. Estos elementos aparecerán marcados como puntos en el '
                  'calendario. Para ver los elementos que contiene un día pulsa en'
                  ' él o llega a él mediante las flechas de navegación entre '
                  'fechas (<, >).'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Creación de eventos',
              'Los eventos pueden ser creados de dos formas: \n'
                  '1) Pulsando el botón +.\n'
                  '2) Manteniendo pulsado el día deseado en el calendario.'),
        ],),

        FooterWithUrl(),
      ]),
    );
  }

}

