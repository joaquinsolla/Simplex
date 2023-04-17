import 'package:flutter/material.dart';
import 'package:simplex/classes/stats/usage_stat.dart';
import 'package:simplex/classes/stats/element_stat.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class StatsUsage extends StatefulWidget {
  const StatsUsage({Key? key}) : super(key: key);

  @override
  _StatsUsageState createState() => _StatsUsageState();
}

class _StatsUsageState extends State<StatsUsage> {

  int index = 0;

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

    UsageStat eventsStat = UsageStat(elementName: "Eventos", total: 10, active: 7, deleted: 3);
    UsageStat todosStat = UsageStat(elementName: "Tareas", total: 20, active: 5, deleted: 15);
    UsageStat notesStat = UsageStat(elementName: "Notas", total: 6, active: 6, deleted: 0);

    ElementStat activeEventsStat = ElementStat(status: "Activos", quantity: 7);
    ElementStat deletedEventsStat = ElementStat(status: "Eliminados", quantity: 3);

    ElementStat activeTodosStat = ElementStat(status: "Activos", quantity: 5);
    ElementStat deletedTodosStat = ElementStat(status: "Eliminados", quantity: 15);

    ElementStat activeNotesStat = ElementStat(status: "Activos", quantity: 6);
    ElementStat deletedNotesStat = ElementStat(status: "Eliminados", quantity: 0);


    List<UsageStat> usageData = [
      eventsStat,
      todosStat,
      notesStat
    ];

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, 'Estadísticas'),
          FooterCredits(),
          [
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
                      child: Text(eventsStat.total.toString(),
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
                      child: Text(todosStat.total.toString(),
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.035),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                      alignment: Alignment.center,
                      child: Text((90).toString() + "%",
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
                      child: Text(notesStat.total.toString(),
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * fontSize * 0.035),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                      alignment: Alignment.center,
                      child: Text((20).toString() + "%",
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
                    Colors.redAccent,
                  ],
                  series: <ChartSeries>[
                    StackedColumnSeries<UsageStat, String>(
                      dataLabelSettings: DataLabelSettings(
                        isVisible:true,
                        showCumulativeValues: false,
                      ),
                      dataSource: usageData,
                      name: 'Activo',
                      xValueMapper: (UsageStat stat, _) => stat.elementName,
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
                      xValueMapper: (UsageStat stat, _) => stat.elementName,
                      yValueMapper: (UsageStat stat, _) => stat.deleted,
                      animationDuration: 1250,
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
              Text('Proporciones de actividad',
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
                    if(index == 0) Wrap(
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
                    if(index != 0) Expanded(
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
                              index = 0;
                            });
                          },
                        )),
                    SizedBox(width: deviceWidth * 0.025,),
                    if(index == 1) Wrap(
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
                    if(index != 1) Expanded(
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
                              index = 1;
                            });
                          },
                        )),
                    SizedBox(width: deviceWidth * 0.025,),
                    if(index == 2) Wrap(
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
                    if(index != 2) Expanded(
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
                              index = 2;
                            });
                          },
                        )),
                  ],
                ),
              ),
              if(index==0) SfCircularChart(
                  margin: EdgeInsets.all(0),
                  palette: <Color>[
                    colorSpecialItem,
                    Colors.redAccent,
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
                        yValueMapper: (ElementStat stat, _) => stat.quantity,
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
              if(index==1) SfCircularChart(
                  margin: EdgeInsets.all(0),
                  palette: <Color>[
                    colorSpecialItem,
                    Colors.redAccent,
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
                        yValueMapper: (ElementStat stat, _) => stat.quantity,
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
              if(index==2) SfCircularChart(
                  margin: EdgeInsets.all(0),
                  palette: <Color>[
                    colorSpecialItem,
                    Colors.redAccent,
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
                        yValueMapper: (ElementStat stat, _) => stat.quantity,
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
          ]
      ),
    );
  }

}