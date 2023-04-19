import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simplex/classes/stats/reports_stat.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class StatsReports extends StatefulWidget {
  const StatsReports({Key? key}) : super(key: key);

  @override
  _StatsReportsState createState() => _StatsReportsState();
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
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

    String nowString = dateToString(DateTime.now()) + " a las " + timeToString(DateTime.now());

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, 'Estadísticas'),
          FooterCredits(),
          [
            StreamBuilder<List<dynamic>>(
                stream: CombineLatestStream.list([
                  readReports(),
                  readReportsStats(true),
                  readReportsStats(false),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint(
                        '[ERR] Cannot read stats: ' + snapshot.error.toString());
                    return ErrorContainer(
                        'No se pueden cargar las estadísticas.', 0.9);
                  }
                  else if (snapshot.hasData) {

                    final List<ReportHistory> reportHistoryItems = getReportHistoryItems(snapshot.data![0]);
                    final activeReports = snapshot.data![1];
                    final closedReports = snapshot.data![2];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Actualizado a $nowString.',
                            style: TextStyle(
                                color: colorMainText,
                                fontSize: deviceWidth * fontSize * 0.03,
                                fontWeight: FontWeight.normal)),
                        SizedBox(
                          height: deviceHeight * 0.0125,
                        ),

                        FormContainer([
                          Text('Historial de reportes',
                              style: TextStyle(
                                  color: colorMainText,
                                  fontSize: deviceWidth * fontSize * 0.05,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: deviceHeight * 0.0125,
                          ),
                          SfCartesianChart(
                              primaryXAxis: NumericAxis(
                                numberFormat: NumberFormat('######'),
                                interval: 1,
                              ),
                              primaryYAxis: NumericAxis(
                                numberFormat: NumberFormat('######'),
                                interval: 1,
                              ),
                              palette: <Color>[
                                colorSpecialItem,
                              ],
                              series: <ChartSeries>[
                                LineSeries<ReportHistory, int>(
                                  dataSource: reportHistoryItems,
                                  xValueMapper: (ReportHistory data, _) => data.year,
                                  yValueMapper: (ReportHistory data, _) => data.quantity,
                                  animationDuration: 1000,
                                )
                              ]
                          ),
                        ]),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),

                        FormContainer([
                          Text('Estado de los reportes',
                              style: TextStyle(
                                  color: colorMainText,
                                  fontSize: deviceWidth * fontSize * 0.05,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: deviceHeight * 0.0125,
                          ),
                          SfCircularChart(
                              margin: EdgeInsets.all(0),
                              palette: <Color>[
                                colorSpecialItem,
                                colorCalendarEvent,
                              ],
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                alignment: ChartAlignment.center,
                                overflowMode: LegendItemOverflowMode.wrap,
                              ),
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                  widget:
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text('Total:\n' + (activeReports.quantity + closedReports.quantity).toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: colorMainText,
                                              fontSize: deviceWidth * fontSize * 0.035,
                                              fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                              series: <CircularSeries>[
                                DoughnutSeries<ReportsStat, String>(
                                    dataSource: [activeReports, closedReports],
                                    xValueMapper: (ReportsStat stat, _) => stat.status,
                                    yValueMapper: (ReportsStat stat, _) => stat.quantity,
                                    innerRadius: '60%',
                                    radius: '75%',
                                    explode: true,
                                    explodeIndex: null,
                                    animationDuration: 1000,
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true
                                    )
                                )
                              ]
                          ),
                        ]),
                      ],);
                  }
                  else return LoadingContainer('Cargando estadísticas...', 0.9);
                }
            ),
          ]
      ),
    );
  }

}

