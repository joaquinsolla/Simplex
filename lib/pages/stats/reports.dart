import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class StatsReports extends StatefulWidget {
  const StatsReports({Key? key}) : super(key: key);

  @override
  _StatsReportsState createState() => _StatsReportsState();
}

class _StatsReportsState extends State<StatsReports> {

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
            Text('Reportes',
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

