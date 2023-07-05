import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class HelpTodos extends StatefulWidget {
  const HelpTodos({Key? key}) : super(key: key);

  @override
  _HelpTodosState createState() => _HelpTodosState();
}

class _HelpTodosState extends State<HelpTodos> {

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
          PageHeader(context, 'Tareas'),
          FooterCredits(),
          [
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Las tareas',
              'Las tareas representan objetivos o actividades que tienen dos '
                  'posibldes estados: pendientes y completadas. Cada tarea cuenta '
                  'con: título, descripción, una prioridad y una fecha límite '
                  'opcional.'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Tareas limitadas y sus notificaciones',
              'Puede definirse una fecha límite para las tareas. Las tareas '
                  'limitadas y pendientes aparecerán en el calendario en la '
                  'fecha límite. Además, se notificará cuando queden 24 horas '
                  'para que se alcance la fecha límite y cuando la tarea ya '
                  'haya caducado.'),
        ],),
      ]
      ),
    );
  }

}

