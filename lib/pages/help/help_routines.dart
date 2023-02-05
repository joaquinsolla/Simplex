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

    late String calendarButtonImage;
    if (darkMode) calendarButtonImage = 'assets/calendar_button_dark.png';
    else calendarButtonImage = 'assets/calendar_button_light.png';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea([
        PageHeader(context, 'Notas'),

        SizedBox(height: deviceHeight * 0.03),
        Text('Notas', style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.05,
            fontWeight: FontWeight.bold)),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),

        ],),

        FooterWithUrl(),
      ]),
    );
  }

}

