import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class HelpRoutines extends StatefulWidget {
  const HelpRoutines({Key? key}) : super(key: key);

  @override
  _HelpRoutinesState createState() => _HelpRoutinesState();
}

class _HelpRoutinesState extends State<HelpRoutines> {

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
      body: HomeArea(null,
          PageHeader(context, 'Rutinas'),
          FooterCredits(),
          [
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Las rutinas',
              'Las rutinas consisten en elementos que se repiten ciertos días'
                  ' de la semana a una hora en particular (por ejemplo una'
                  ' asignatura del colegio todos los lunes a las 9:00).'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Elementos de las rutinas',
              'Pueden definirse dos tipos de elementos para las rutinas: '
                  'Eventos y notas. Para definirlos como rutina debes '
                  'seleccionar dicha opción cuando vayas a crearlos, también '
                  'puedes hacer esto editándolos. Los elementos rutinarios no '
                  'tienen notificaciones.'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Visualización de rutinas',
              'En la sección de rutinas, podrás ver los diferentes días de la '
                  'semana con sus respectivos elementos.'),
        ],),
      ]
      ),
    );
  }

}

