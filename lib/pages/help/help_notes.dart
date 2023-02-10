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

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: NewHomeArea(null,
          PageHeader(context, 'Notas'),
          FooterCredits(),
          [
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Las notas',
              'Las notas contienen el texto que tú decidas. Tienen: título, '
                  'contenido, fecha de modificación y opcionalmente fecha en el'
                  ' calendario.'),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer('Notas en el calendario',
              'Puedes decidir añadir una nota al calendario, de forma que '
                  'tendrás que indicar una fecha. Una vez hecho esto, podrás '
                  'ver tu nota en el calendario en la fecha indicada. También '
                  'recibirás una notificación en esa fecha.'),
        ],),
      ]
      ),
    );
  }

}

