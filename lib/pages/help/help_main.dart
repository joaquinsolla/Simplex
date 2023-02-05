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

    late String calendarButtonImage;
    if (darkMode) calendarButtonImage = 'assets/calendar_button_dark.png';
    else calendarButtonImage = 'assets/calendar_button_light.png';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea([
        PageHeader(context, 'Ayuda'),

        Text('Uso de la aplicación',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        FormContainer([
          Container(
            width: deviceHeight,
            height: deviceHeight * 0.05,
            child: TextButton(
              child: Text(
                'Botones',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/help/help_buttons');
              },
            ),
          ),
          Divider(color: colorThirdText),
          Container(
            width: deviceHeight,
            height: deviceHeight * 0.05,
            child: TextButton(
              child: Text(
                'Calendario',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/help/help_events');
              },
            ),
          ),
          Divider(color: colorThirdText),
          Container(
            width: deviceHeight,
            height: deviceHeight * 0.05,
            child: TextButton(
              child: Text(
                'Tareas',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/help/help_todos');
              },
            ),
          ),
          Divider(color: colorThirdText),
          Container(
            width: deviceHeight,
            height: deviceHeight * 0.05,
            child: TextButton(
              child: Text(
                'Notas',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/help/help_notes');
              },
            ),
          ),
          Divider(color: colorThirdText),
          Container(
            width: deviceHeight,
            height: deviceHeight * 0.05,
            child: TextButton(
              child: Text(
                'Rutinas',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/help/help_routines');
              },
            ),
          ),
        ]),

        SizedBox(height: deviceHeight * 0.03),
        Text('Otros',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        FormContainer([
          Container(
            width: deviceHeight,
            height: deviceHeight * 0.05,
            child: TextButton(
              child: Text(
                'Política de privacidad',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                // TODO: privacy policy
              },
            ),
          ),
          Divider(color: colorThirdText),
          Container(
            width: deviceHeight,
            height: deviceHeight * 0.05,
            child: TextButton(
              child: Text(
                'Reportar un problema',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                // TODO: problems report
              },
            ),
          ),

        ]),

        FooterWithUrl(),
      ]),
    );
  }

}

