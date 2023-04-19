import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simplex/classes/stats/usage_stat.dart';
import 'package:simplex/classes/stats/element_stat.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class StatsUsage extends StatefulWidget {
  const StatsUsage({Key? key}) : super(key: key);

  @override
  _StatsUsageState createState() => _StatsUsageState();
}

class _StatsUsageState extends State<StatsUsage> {

  int proportionsIndex = 0;

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
                  readUsersStats(),
                  readUsageStats('events'),
                  readUsageStats('todos'),
                  readUsageStats('notes'),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint(
                        '[ERR] Cannot read stats: ' + snapshot.error.toString());
                    return ErrorContainer(
                        'No se pueden cargar las estadísticas.', 0.9);
                  }
                  else if (snapshot.hasData) {
                    final userStats = snapshot.data![0];
                    final eventsStat = snapshot.data![1];
                    final todosStat = snapshot.data![2];
                    final notesStat = snapshot.data![3];

                    final List<UsageStat> usageData = [
                      eventsStat,
                      todosStat,
                      notesStat
                    ];

                    ElementStat activeEventsStat = ElementStat(status: "Activos", percentage: 0);
                    ElementStat deletedEventsStat = ElementStat(status: "Eliminados", percentage: 0);
                    ElementStat activeTodosStat = ElementStat(status: "Activos", percentage: 0);
                    ElementStat deletedTodosStat = ElementStat(status: "Eliminados", percentage: 0);
                    ElementStat activeNotesStat = ElementStat(status: "Activos", percentage: 0);
                    ElementStat deletedNotesStat = ElementStat(status: "Eliminados", percentage: 0);

                    if (eventsStat.active > 0) activeEventsStat.percentage = double.parse(((eventsStat.active/eventsStat.total)*100).toStringAsFixed(1));
                    if (eventsStat.deleted > 0) deletedEventsStat.percentage = double.parse(((eventsStat.deleted/eventsStat.total)*100).toStringAsFixed(1));
                    if (todosStat.active > 0) activeTodosStat.percentage = double.parse(((todosStat.active/todosStat.total)*100).toStringAsFixed(1));
                    if (todosStat.deleted > 0) deletedTodosStat.percentage = double.parse(((todosStat.deleted/todosStat.total)*100).toStringAsFixed(1));
                    if (notesStat.active > 0) activeNotesStat.percentage = double.parse(((notesStat.active/notesStat.total)*100).toStringAsFixed(1));
                    if (notesStat.deleted > 0) deletedNotesStat.percentage = double.parse(((notesStat.deleted/notesStat.total)*100).toStringAsFixed(1));

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
                          Text('Usuarios',
                              style: TextStyle(
                                  color: colorMainText,
                                  fontSize: deviceWidth * fontSize * 0.05,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: deviceHeight * 0.0125,
                          ),
                          Table(
                            children: [
                              TableRow(children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Total:',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text(userStats.total.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text('',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Email verificado:',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text(userStats.verified.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                if(userStats.verified>0) Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text(((userStats.verified/userStats.total)*100).toStringAsFixed(1) + "%",
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                if(userStats.verified==0) Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text("0%",
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Testers:',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text(userStats.tester.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                if(userStats.tester>0) Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text(((userStats.tester/userStats.total)*100).toStringAsFixed(1) + "%",
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                if(userStats.tester==0) Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text("0%",
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),

                        FormContainer([
                          Text('Uso de la aplicación',
                              style: TextStyle(
                                  color: colorMainText,
                                  fontSize: deviceWidth * fontSize * 0.05,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: deviceHeight * 0.0125,
                          ),
                          SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                              ),
                              palette: <Color>[
                                colorSpecialItem,
                                colorCalendarEvent,
                              ],
                              series: <ChartSeries>[
                                StackedColumnSeries<UsageStat, String>(
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible:true,
                                    showCumulativeValues: false,
                                  ),
                                  dataSource: usageData,
                                  name: 'Activo',
                                  xValueMapper: (UsageStat stat, _) => stat.name,
                                  yValueMapper: (UsageStat stat, _) => stat.active,
                                  animationDuration: 1000,
                                ),
                                StackedColumnSeries<UsageStat, String>(
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible:true,
                                    showCumulativeValues: false,
                                  ),
                                  dataSource: usageData,
                                  name: 'Eliminado',
                                  xValueMapper: (UsageStat stat, _) => stat.name,
                                  yValueMapper: (UsageStat stat, _) => stat.deleted,
                                  animationDuration: 1000,
                                ),
                              ]
                          ),
                        ]),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),

                        FormContainer([
                          Text('Recuento de elementos',
                              style: TextStyle(
                                  color: colorMainText,
                                  fontSize: deviceWidth * fontSize * 0.05,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: deviceHeight * 0.0125,
                          ),
                          Table(
                            children: [
                              TableRow(children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: colorMainText),
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Total',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: colorMainText),
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Activos',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: colorMainText),
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Eliminados',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text('Eventos',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(eventsStat.total.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(eventsStat.active.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(eventsStat.deleted.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text('Tareas',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(todosStat.total.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(todosStat.active.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(todosStat.deleted.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  alignment: Alignment.center,
                                  child: Text('Notas',
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(notesStat.total.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(notesStat.active.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: colorMainText),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(notesStat.deleted.toString(),
                                    style: TextStyle(
                                        color: colorMainText,
                                        fontSize: deviceWidth * fontSize * 0.035),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),

                        FormContainer([
                          Text('Proporciones de actividad (%)',
                              style: TextStyle(
                                  color: colorMainText,
                                  fontSize: deviceWidth * fontSize * 0.05,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: deviceHeight * 0.0125,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: colorThirdBackground,
                            ),
                            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if(proportionsIndex == 0) Wrap(
                                  children: [
                                    TextButton(
                                      child: Text(
                                        'Eventos',
                                        style: TextStyle(
                                            color: colorSpecialItem,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(colorMainBackground),
                                        overlayColor: MaterialStateProperty.all(
                                            colorSpecialItem.withOpacity(0.1)),
                                      ),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                                if(proportionsIndex != 0) Expanded(
                                    child: OutlinedButton(
                                      child: Text(
                                        'Eventos',
                                        style: TextStyle(
                                            color: colorSpecialItem,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                                        backgroundColor: MaterialStateProperty.all(
                                            colorThirdBackground),
                                        overlayColor: MaterialStateProperty.all(
                                            colorSpecialItem.withOpacity(0.1)),
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          proportionsIndex = 0;
                                        });
                                      },
                                    )),
                                SizedBox(width: deviceWidth * 0.025,),
                                if(proportionsIndex == 1) Wrap(
                                  children: [
                                    TextButton(
                                      child: Text(
                                        'Tareas',
                                        style: TextStyle(
                                            color: colorSpecialItem,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(colorMainBackground),
                                        overlayColor: MaterialStateProperty.all(
                                            colorSpecialItem.withOpacity(0.1)),
                                      ),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                                if(proportionsIndex != 1) Expanded(
                                    child: OutlinedButton(
                                      child: Text(
                                        'Tareas',
                                        style: TextStyle(
                                            color: colorSpecialItem,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                                        backgroundColor: MaterialStateProperty.all(
                                            colorThirdBackground),
                                        overlayColor: MaterialStateProperty.all(
                                            colorSpecialItem.withOpacity(0.1)),
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          proportionsIndex = 1;
                                        });
                                      },
                                    )),
                                SizedBox(width: deviceWidth * 0.025,),
                                if(proportionsIndex == 2) Wrap(
                                  children: [
                                    TextButton(
                                      child: Text(
                                        'Notas',
                                        style: TextStyle(
                                            color: colorSpecialItem,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(colorMainBackground),
                                        overlayColor: MaterialStateProperty.all(
                                            colorSpecialItem.withOpacity(0.1)),
                                      ),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                                if(proportionsIndex != 2) Expanded(
                                    child: OutlinedButton(
                                      child: Text(
                                        'Notas',
                                        style: TextStyle(
                                            color: colorSpecialItem,
                                            fontSize: deviceWidth * fontSize * 0.04,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                                        backgroundColor: MaterialStateProperty.all(
                                            colorThirdBackground),
                                        overlayColor: MaterialStateProperty.all(
                                            colorSpecialItem.withOpacity(0.1)),
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          proportionsIndex = 2;
                                        });
                                      },
                                    )),
                              ],
                            ),
                          ),
                          if(proportionsIndex==0) SfCircularChart(
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
                              series: <CircularSeries>[
                                // Renders doughnut chart
                                DoughnutSeries<ElementStat, String>(
                                    dataSource: [activeEventsStat, deletedEventsStat],
                                    xValueMapper: (ElementStat stat, _) => stat.status,
                                    yValueMapper: (ElementStat stat, _) => stat.percentage,
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
                          if(proportionsIndex==1) SfCircularChart(
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
                              series: <CircularSeries>[
                                // Renders doughnut chart
                                DoughnutSeries<ElementStat, String>(
                                    dataSource: [activeTodosStat, deletedTodosStat],
                                    xValueMapper: (ElementStat stat, _) => stat.status,
                                    yValueMapper: (ElementStat stat, _) => stat.percentage,
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
                          if(proportionsIndex==2) SfCircularChart(
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
                              series: <CircularSeries>[
                                // Renders doughnut chart
                                DoughnutSeries<ElementStat, String>(
                                    dataSource: [activeNotesStat, deletedNotesStat],
                                    xValueMapper: (ElementStat stat, _) => stat.status,
                                    yValueMapper: (ElementStat stat, _) => stat.percentage,
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