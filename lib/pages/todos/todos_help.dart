import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class TodosHelp extends StatefulWidget {
  const TodosHelp({Key? key}) : super(key: key);

  @override
  _TodosHelpState createState() => _TodosHelpState();
}

class _TodosHelpState extends State<TodosHelp> {

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
      body: homeArea([
        pageHeaderWithBackArrow(context, 'Acerca de las tareas'),
        Text('Botones',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        buttonExplanationContainer(Icon(Icons.add_rounded, color: colorSpecialItem, size: deviceWidth * 0.085),
            'Añadir una tarea',
            'Accederás a un breve formulario para crear la tarea '
                'con los datos que desees. Una vez confirmada, la tarea'
                ' aparecerá en la lista de tareas pendientes. Si la tarea '
                'tiene fecha límite, también aparecerá en el calendario.'),
        SizedBox(height: deviceHeight * 0.0125),
        buttonExplanationContainer(
            Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Column(
                children: [
                  Row(children: [
                    Icon(Icons.done_all_rounded,
                        color: colorSpecialItem, size: deviceWidth * 0.0405),
                    Icon(Icons.delete_outline_rounded,
                        color: Colors.transparent, size: deviceWidth * 0.0405),
                  ],),
                  Row(children: [
                    Icon(Icons.subdirectory_arrow_right_rounded,
                        color: colorSpecialItem, size: deviceWidth * 0.0405),
                    Icon(Icons.delete_outline_rounded,
                        color: colorSpecialItem, size: deviceWidth * 0.0405),
                  ],),
                ],
              ),
              ),
            ),
            'Eliminar las tareas hechas',
            'Si confirmas la acción, se eliminarán todas las tareas marcadas como hechas.'
                ' No podrás restaurarlas.'),
        SizedBox(height: deviceHeight * 0.0125),
        buttonExplanationContainer(
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  width: 1.5,
                  color: colorSpecialItem,
                ),
              ),
            ),
            'Tarea pendiente',
            'El botón vacío indica que la tarea sigue pendiente, si lo pulsas la marcarás '
                'como hecha.'),
        SizedBox(height: deviceHeight * 0.0125),
        buttonExplanationContainer(
            Container(
              child: Icon(Icons.check_rounded, size: deviceWidth*0.07, color: colorSpecialItem,),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  width: 1.5,
                  color: colorSpecialItem,
                ),
              ),
            ),
            'Tarea hecha',
            'El botón con un check indica que la tarea está hecha, puedes volver a ponerla '
                'como pendiente pulsando en él.'),
        SizedBox(height: deviceHeight * 0.0125),
        buttonExplanationContainer(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.visibility_outlined, color: colorSpecialItem, size: deviceWidth * 0.085),
            Icon(Icons.visibility_off_outlined, color: colorSpecialItem, size: deviceWidth * 0.085),
          ],),
            'Visibilidad de las tareas',
            'Podrás seleccionar si mostrar o no las tareas, tanto las pendientes como las hechas. Por defecto:\n'
                'Pendientes: Visibles\n'
                'Hechas: Ocultas'),
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
        othersExplanationContainer('Manipulación de tareas',
            'Las tareas siempre podrán editarse, eliminarse y verse sus detalles. '
                'Puedes hacerlo manteniendo pulsado sobre una de ellas, o simplemente tocándola, '
                'también desde el calendario (tareas con fecha límite). '
                'Además, puede cambiarse su estado de pendientes a hechas y viceversa en cualquier momento.'),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        othersExplanationContainer('Prioridad de las tareas',
            'Existen 3 niveles de prioridad para las tareas. Las tareas de mayor prioridad aparecerán '
                'sobre las que tengan una prioridad inferior, también en el calendario (tareas con fecha límite).'),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        othersExplanationContainer('Tareas con fecha límite',
            'Estas tareas aparecerán también en el calendario, localizadas en el día de su fecha límite. '
                'También recibirás una notificación si una de esas tareas no ha sido hecha y, o '
                'se ha alcanzado su fecha límite, o la fecha límite ha expirado.'),


        SizedBox(
          height: deviceHeight * 0.025,
        ),
      ]),
    );
  }
}

