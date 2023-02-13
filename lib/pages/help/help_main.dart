import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class HelpMainPage extends StatefulWidget {
  const HelpMainPage({Key? key}) : super(key: key);

  @override
  _HelpMainPageState createState() => _HelpMainPageState();
}

class _HelpMainPageState extends State<HelpMainPage> {

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
          PageHeader(context, 'Ayuda'),
          FooterCredits(),
          [

        Text('Uso de la aplicación',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        FormContainer([
          SecondaryButton(colorMainText, 'Botones', (){
            Navigator.pushNamed(context, '/help/help_buttons');
          }),
          Divider(color: colorThirdText),
          SecondaryButton(colorMainText, 'Calendario', (){
            Navigator.pushNamed(context, '/help/help_events');
          }),
          Divider(color: colorThirdText),
          SecondaryButton(colorMainText, 'Tareas', (){
            Navigator.pushNamed(context, '/help/help_todos');
          }),
          Divider(color: colorThirdText),
          SecondaryButton(colorMainText, 'Notas', (){
            Navigator.pushNamed(context, '/help/help_notes');
          }),
          Divider(color: colorThirdText),
          SecondaryButton(colorMainText, 'Rutinas', (){
            Navigator.pushNamed(context, '/help/help_routines');
          }),

        ]),

        SizedBox(height: deviceHeight * 0.03),
        Text('Otros',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        FormContainer([
          SecondaryButton(colorMainText, 'Política de privacidad', (){
            tryLaunchUrl(privacyPolicyUrl);
          }),
          Divider(color: colorThirdText),
          SecondaryButton(Colors.red, 'Reportar un problema', (){
            Navigator.pushNamed(context, '/help/help_report');
          }),
        ]),

      ]
      ),
    );
  }

}

