import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class HelpNotes extends StatefulWidget {
  const HelpNotes({Key? key}) : super(key: key);

  @override
  _HelpNotesState createState() => _HelpNotesState();
}

class _HelpNotesState extends State<HelpNotes> {

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
        PageHeader(context, 'Tareas'),

        SizedBox(height: deviceHeight * 0.03),
        Text('Tareas', style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.05,
            fontWeight: FontWeight.bold)),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.clear_all_rounded, color: Colors.blue, size: deviceWidth * 0.075),
              'Eliminar tareas hechas',
              'Se borrarán todas las tareas marcadas como hechas. Una vez '
                  'eliminadas no se podrán recuperar.'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Manipulación de tareas',
              'Las tareas siempre podrán editarse, eliminarse y verse sus detalles. '
                  'Puedes hacerlo manteniendo pulsado sobre una de ellas, o simplemente tocándola, '
                  'también desde el calendario (tareas con fecha límite). '
                  'Además, puede cambiarse su estado de pendientes a hechas y viceversa en cualquier momento.'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Prioridad de las tareas',
              'Existen 3 niveles de prioridad para las tareas. Las tareas de mayor prioridad aparecerán '
                  'sobre las que tengan una prioridad inferior, también en el calendario (tareas con fecha límite).'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Tareas con fecha límite',
              'Estas tareas aparecerán también en el calendario, localizadas en el día de su fecha límite. '
                  'También recibirás una notificación si una de esas tareas no ha sido hecha y, o '
                  'se ha alcanzado su fecha límite, o la fecha límite ha expirado.'),
        ],),

        FooterWithUrl(),
      ]),
    );
  }

}

