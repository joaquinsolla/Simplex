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

    late String calendarButtonImage;
    if (darkMode) calendarButtonImage = 'assets/calendar_button_dark.png';
    else calendarButtonImage = 'assets/calendar_button_light.png';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea([
        PageHeader(context, 'Rutinas'),

        Text('Rutinas', style: TextStyle(
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

