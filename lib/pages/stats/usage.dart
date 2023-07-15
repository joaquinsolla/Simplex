import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simplex/classes/stats/usage_stat.dart';
import 'package:simplex/classes/stats/element_stat.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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

    String nowString = dateToString(DateTime.now()) + AppLocalizations.of(context)!.at + timeToString(DateTime.now());

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, AppLocalizations.of(context)!.stats),
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
                        AppLocalizations.of(context)!.errorCannotLoadStats, 0.9, context);
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

                    ElementStat activeEventsStat = ElementStat(status: AppLocalizations.of(context)!.activePlural, percentage: 0);
                    ElementStat deletedEventsStat = ElementStat(status: AppLocalizations.of(context)!.deletedPlural, percentage: 0);
                    ElementStat activeTodosStat = ElementStat(status: AppLocalizations.of(context)!.activePlural, percentage: 0);
                    ElementStat deletedTodosStat = ElementStat(status: AppLocalizations.of(context)!.deletedPlural, percentage: 0);
                    ElementStat activeNotesStat = ElementStat(status: AppLocalizations.of(context)!.activePlural, percentage: 0);
                    ElementStat deletedNotesStat = ElementStat(status: AppLocalizations.of(context)!.deletedPlural, percentage: 0);

                    if (eventsStat.active > 0) activeEventsStat.percentage = double.parse(((eventsStat.active/eventsStat.total)*100).toStringAsFixed(1));
                    if (eventsStat.deleted > 0) deletedEventsStat.percentage = double.parse(((eventsStat.deleted/eventsStat.total)*100).toStringAsFixed(1));
                    if (todosStat.active > 0) activeTodosStat.percentage = double.parse(((todosStat.active/todosStat.total)*100).toStringAsFixed(1));
                    if (todosStat.deleted > 0) deletedTodosStat.percentage = double.parse(((todosStat.deleted/todosStat.total)*100).toStringAsFixed(1));
                    if (notesStat.active > 0) activeNotesStat.percentage = double.parse(((notesStat.active/notesStat.total)*100).toStringAsFixed(1));
                    if (notesStat.deleted > 0) deletedNotesStat.percentage = double.parse(((notesStat.deleted/notesStat.total)*100).toStringAsFixed(1));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.updatedAt + nowString + '.',
                            style: TextStyle(
                                color: colorMainText,
                                fontSize: deviceWidth * fontSize * 0.03,
                                fontWeight: FontWeight.normal)),
                        SizedBox(
                          height: deviceHeight * 0.0125,
                        ),

                        FormContainer([
                          Text(AppLocalizations.of(context)!.users,
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
                                  child: Text(AppLocalizations.of(context)!.total + ':',
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
                                  child: Text(AppLocalizations.of(context)!.emailVerified + ':',
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
                                  child: Text(AppLocalizations.of(context)!.testers + ':',
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
                          Text(AppLocalizations.of(context)!.appUsage,
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
                                  name: AppLocalizations.of(context)!.active,
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
                                  name: AppLocalizations.of(context)!.deleted,
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
                          Text(AppLocalizations.of(context)!.elementsCount,
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
                                  child: Text(AppLocalizations.of(context)!.total,
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
                                  child: Text(AppLocalizations.of(context)!.activePlural,
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
                                  child: Text(AppLocalizations.of(context)!.deletedPlural,
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
                                  child: Text(AppLocalizations.of(context)!.eventsCapital,
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
                                  child: Text(AppLocalizations.of(context)!.todos,
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
                                  child: Text(AppLocalizations.of(context)!.notes,
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
                          Text(AppLocalizations.of(context)!.activityProportions,
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
                                        AppLocalizations.of(context)!.eventsCapital,
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
                                        AppLocalizations.of(context)!.eventsCapital,
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
                                        AppLocalizations.of(context)!.todos,
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
                                        AppLocalizations.of(context)!.todos,
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
                                        AppLocalizations.of(context)!.notes,
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
                                        AppLocalizations.of(context)!.notes,
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
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                  widget:
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(AppLocalizations.of(context)!.total + ':\n' + eventsStat.total.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.035,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                              series: <CircularSeries>[
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
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                  widget:
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(AppLocalizations.of(context)!.total + ':\n' + todosStat.total.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.035,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                              series: <CircularSeries>[
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
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                  widget:
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(AppLocalizations.of(context)!.total + ':\n' + notesStat.total.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: colorMainText,
                                            fontSize: deviceWidth * fontSize * 0.035,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                              series: <CircularSeries>[
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
                  else return LoadingContainer(AppLocalizations.of(context)!.loadingStats, 0.9);
                }
            ),
          ]
      ),
    );
  }

}