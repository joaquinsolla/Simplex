import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class EventsHelp extends StatefulWidget {
  const EventsHelp({Key? key}) : super(key: key);

  @override
  _EventsHelpState createState() => _EventsHelpState();
}

class _EventsHelpState extends State<EventsHelp> {

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
        body: homeArea([
          pageHeaderWithBackArrow(context, 'Acerca del calendario'),
          Text('Botones',
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.05,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: deviceHeight * 0.0125,
          ),
          buttonExplanationContainer(Icon(Icons.add_rounded, color: colorSpecialItem, size: deviceWidth * 0.085),
              'Añadir un evento al calendario',
              'Accederás a un breve formulario para crear el evento '
                  'con los datos que desees. Una vez confirmado, el evento'
                  ' aparecerá en el calendario de Simplex.'),
          SizedBox(
            height: deviceHeight * 0.0125,
          ),
          buttonExplanationContainer(Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.keyboard_arrow_right_rounded, color: colorSpecialItem, size: deviceWidth * 0.085),
            Icon(Icons.keyboard_arrow_left_rounded, color: colorSpecialItem, size: deviceWidth * 0.085),
          ],),
              'Flechas de desplazamiento',
              'Calendario: Permiten cambiar de mes/semana (dependiendo del modo de vista en el que estés).\n'
                  'Día: Permiten avanzar o retroceder de día en el calendario.'),
          SizedBox(height: deviceHeight * 0.0125),
          buttonExplanationContainer(Image.asset(calendarButtonImage),
              'Alternar vista de calendario',
              'Podrás cambiar entre la vista de mes comleto y la de semana.'),
          SizedBox(height: deviceHeight * 0.0125),
          buttonExplanationContainer(Icon(Icons.help_outline_rounded, color: colorSpecialItem, size: deviceWidth * 0.085),
              'Apartado de ayuda',
              'Esta ventana, con la información necesaria para aprender el funcionamiento de la app.'),

          SizedBox(
            height: deviceHeight * 0.03,
          ),

          Text('Otros aspectos',
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.05,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: deviceHeight * 0.0125,
          ),
          othersExplanationContainer('Añadir un evento',
              'Puedes añadir un evento pulsando el botón +, o manteniendo pulsado sobre un día del calendario. '
                  'Puedes cambiar la fecha del evento en el formulario si lo deseas.'),
          SizedBox(
            height: deviceHeight * 0.0125,
          ),
          othersExplanationContainer('Manipulación de eventos',
              'Los eventos siempre podrán editarse, eliminarse y verse sus detalles. '
                  'Puedes hacerlo manteniendo pulsado sobre uno de ellos, o simplemente tocándolo.'),
          SizedBox(
            height: deviceHeight * 0.0125,
          ),
          othersExplanationContainer('Días con eventos',
              'En el calendario aparecerán marcados con puntos los días que tengan eventos asignados. '
                  'Para ver los eventos que contiene pulsa en ese día en el calendario o llega a él mediante las flechas de desplazamiento.'),
          SizedBox(
            height: deviceHeight * 0.0125,
          ),
          othersExplanationContainer('Tareas con fecha límite',
              'Las tareas pendientes con fecha límite aparecerán también en el calendario de Simplex, puedes acceder a ellas tocándolas o ver'
                  ' más opciones manteniendo pulsado sobre ellas. Una vez marcadas como hechas, ya no aparecerán en el calendario.'),


          SizedBox(
            height: deviceHeight * 0.025,
          ),
        ]),
    );
  }

}

