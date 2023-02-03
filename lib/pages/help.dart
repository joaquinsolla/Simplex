import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {

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
        PageHeader(context, 'Ayuda'),
        Text('Botones generales',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        ButtonExplanationContainer(Icon(Icons.add_rounded, color: colorSpecialItem, size: deviceWidth * 0.085),
            'Añadir un evento al calendario',
            'Accederás a un breve formulario para crear el evento '
                'con los datos que desees. Una vez confirmado, el evento'
                ' aparecerá en el calendario de Simplex.'),
        SizedBox(height: deviceHeight * 0.0125),
        ButtonExplanationContainer(Image.asset(calendarButtonImage),
            'Alternar vista de calendario',
            'Podrás cambiar entre la vista de mes comleto y la de semana.'),

        SizedBox(
          height: deviceHeight * 0.03,
        ),

        Text('Calendario',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        OthersExplanationContainer('Añadir un evento',
            'Puedes añadir un evento pulsando el botón +, o manteniendo pulsado sobre un día del calendario.'),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        OthersExplanationContainer('Manipulación de eventos',
            'Los eventos siempre podrán editarse, eliminarse además de verse sus detalles. '
                'Puedes hacerlo manteniendo pulsado sobre uno de ellos, o simplemente tocándolo.'),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        OthersExplanationContainer('Días con eventos',
            'En el calendario aparecerán marcados con puntos los días que tengan eventos asignados. '
                'Para ver los eventos que contiene un día pulsa en él o llega a él mediante las flechas de navegación de días (<, >).'),

        SizedBox(
          height: deviceHeight * 0.03,
        ),

        Text('Tareas',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        OthersExplanationContainer('Manipulación de tareas',
            'Las tareas siempre podrán editarse, eliminarse y verse sus detalles. '
                'Puedes hacerlo manteniendo pulsado sobre una de ellas, o simplemente tocándola, '
                'también desde el calendario (tareas con fecha límite). '
                'Además, puede cambiarse su estado de pendientes a hechas y viceversa en cualquier momento.'),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        OthersExplanationContainer('Prioridad de las tareas',
            'Existen 3 niveles de prioridad para las tareas. Las tareas de mayor prioridad aparecerán '
                'sobre las que tengan una prioridad inferior, también en el calendario (tareas con fecha límite).'),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        OthersExplanationContainer('Tareas con fecha límite',
            'Estas tareas aparecerán también en el calendario, localizadas en el día de su fecha límite. '
                'También recibirás una notificación si una de esas tareas no ha sido hecha y, o '
                'se ha alcanzado su fecha límite, o la fecha límite ha expirado.'),

        SizedBox(
          height: deviceHeight * 0.03,
        ),

        Text('Notas',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),



        SizedBox(
          height: deviceHeight * 0.03,
        ),

        Text('Rutinas',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),

        SizedBox(
          height: deviceHeight * 0.025,
        ),
      ]),
    );
  }

}

