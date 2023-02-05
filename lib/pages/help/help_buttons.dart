import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class HelpButtons extends StatefulWidget {
  const HelpButtons({Key? key}) : super(key: key);

  @override
  _HelpButtonsState createState() => _HelpButtonsState();
}

class _HelpButtonsState extends State<HelpButtons> {

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
        PageHeader(context, 'Botones'),

        Text('Botones comunes', style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.05,
            fontWeight: FontWeight.bold)),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.add_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              'Nuevo',
              'En cada apartado (calendario, tareas, notas...) tendrás disponible '
                  'este botón para crear sus repectivos elementos. Serás dirigido '
                  'a un formulario para rellenar los datos del elemento a crear.'),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.search_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              'Buscar',
              'Se despliega un buscador para poder filtrar los elementos por su '
                  'título.'),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.input_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              'Ver detalles',
              'Este botón te dirigirá a una ventana con los detalles del elemento '
                  'seleccionado.'),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.edit, color: colorSpecialItem, size: deviceWidth * 0.075),
              'Editar',
              'Accederás a un formulario para editar los datos que desees del '
                  'elemento que hayas seleccionado, después sólo tendrás que '
                  'confirmar los cambios.'),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.share_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              'Compartir',
              '[Beta] Podrás compartir los elementos que desees con los demás a '
                  'través de múltiples aplicaciones o copiando el contenido '
                  'en el portapapeles.'),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.delete_outline_rounded, color: Colors.red, size: deviceWidth * 0.075),
              'Eliminar',
              'Se eliminará definitivamente el elemento seleccionado. Una vez '
                  'eliminados, los elementos no se pueden recuperar.'),
        ],),
        SizedBox(height: deviceHeight * 0.03),

        Text('Botones del calendario', style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.05,
            fontWeight: FontWeight.bold)),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(Image.asset(calendarButtonImage),
              'Alternar vista de calendario',
              'Podrás cambiar entre la vista de mes comleto y la de semana.'),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Column(children: [
                Icon(Icons.keyboard_arrow_left_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
                Icon(Icons.keyboard_arrow_right_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              ],),
              'Navegación entre fechas',
              'Permiten moverse hacia atrás y hacia adelante entre fechas.'),
        ],),
        SizedBox(height: deviceHeight * 0.03),

        Text('Botones de las tareas', style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.05,
            fontWeight: FontWeight.bold)),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.visibility_outlined, color: colorSpecialItem, size: deviceWidth * 0.075),
              'Visibilidad de tareas',
              'Puedes decidir si mostrar u ocultar tanto las tareas pendientes '
                  'como las hechas.'),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.clear_all_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              'Eliminar tareas hechas',
              'Se eliminarán todas las tareas que estén marcadas como hechas. '
                  'Una vez eliminadas no podrás recuperarlas.'),
        ],),

        FooterWithUrl(),
      ]),
    );
  }

}

