import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class StatsUsage extends StatefulWidget {
  const StatsUsage({Key? key}) : super(key: key);

  @override
  _StatsUsageState createState() => _StatsUsageState();
}

class _StatsUsageState extends State<StatsUsage> {

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
          PageHeader(context, 'Estadísticas'),
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


            SizedBox(
              height: deviceHeight * 0.0125,
            ),
            Text('Recuento de elementos',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * fontSize * 0.05,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: deviceHeight * 0.0125,
            ),

            SizedBox(
              height: deviceHeight * 0.0125,
            ),
            Text('Usuarios',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * fontSize * 0.05,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: deviceHeight * 0.0125,
            ),
          ]
      ),
    );
  }

}

