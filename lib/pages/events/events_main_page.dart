import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/services/firestore_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:simplex/common/all_common.dart';

class EventsMainPage extends StatefulWidget {
  const EventsMainPage({Key? key}) : super(key: key);

  @override
  _EventsMainPageState createState() => _EventsMainPageState();
}

class _EventsMainPageState extends State<EventsMainPage> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
  }

  Future<List<Event>> _listOfDayEvents(DateTime dateTime) async {
    return await readEventsOfDate(dateTime).first;
  }

  @override
  Widget build(BuildContext context) {
    late String locale;
    late StartingDayOfWeek startingDayOfWeek;
    late String dateFormat;
    if (appLocale == Locale('es', '')) {
      locale = 'es_ES';
      startingDayOfWeek = StartingDayOfWeek.monday;
    } else {
      locale = 'en_EN';
      startingDayOfWeek = StartingDayOfWeek.sunday;
    }
    if (formatDates==true) dateFormat='dd-MM-yyyy';
    else  dateFormat='MM-dd-yyyy';

    return homeArea([
      homeHeaderSimple('Calendario',
        IconButton(
          icon: Icon(Icons.add_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            Navigator.pushNamed(context, '/events/add_event');
          },
        ),
      ),

      Card(
        color: colorSecondBackground,
        child: TableCalendar(
        locale: locale,
        firstDay: DateTime.utc(2000),
        lastDay: DateTime.utc(2099),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        startingDayOfWeek: startingDayOfWeek,
        daysOfWeekVisible: true,
        rowHeight: deviceHeight*0.06,
        availableCalendarFormats: {CalendarFormat.month : 'Mes', CalendarFormat.week : 'Semana'},

        ///CALENDAR FUNS
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        selectedDayPredicate: (day) =>isSameDay(day, _selectedDay),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },

        ///CALENDAR STYLE
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            color: colorSecondBackground,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: colorSpecialItem),
          ),
          defaultTextStyle: TextStyle(
            color: colorMainText,
          ),
          selectedTextStyle: TextStyle(
            color: colorMainText,
          ),
          weekendTextStyle: TextStyle(
            color: colorSecondText,
          ),
          outsideTextStyle: TextStyle(
            color: colorThirdText,
          ),
          todayTextStyle: TextStyle(
            color: colorSpecialItem,
            fontWeight: FontWeight.bold,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          formatButtonShowsNext: false,
          titleTextStyle: TextStyle(
            color: colorMainText,
          ),
          formatButtonTextStyle: TextStyle(
            color: colorMainText,
          ),
          formatButtonDecoration: BoxDecoration(
            border: Border.all(color: colorSpecialItem),
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)
            ),
          ),
          leftChevronIcon: Icon(Icons.keyboard_arrow_left_rounded, color: colorSpecialItem,),
          rightChevronIcon: Icon(Icons.keyboard_arrow_right_rounded, color: colorSpecialItem,),
        ),
      ),
      ),

      StreamBuilder<List<Event>>(
          stream: readEventsOfDate(_selectedDay),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] ' + snapshot.error.toString());
              return Container(
                height: deviceHeight * 0.65,
                alignment: Alignment.center,
                child: Text(
                  'Ha ocurrido un error. Revisa tu conexión a Internet o reinicia la app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: deviceWidth * 0.0475, color: colorSecondText),),
              );
            } else if (snapshot.hasData) {
              final events = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: deviceHeight*0.0125,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_left_rounded,
                            color: colorSpecialItem, size: deviceWidth * 0.06),
                        splashRadius: 0.001,
                        onPressed: () {
                          setState(() {
                            _selectedDay=_selectedDay.subtract(Duration(days: 1));
                          });
                        },
                      ),
                      SizedBox(width: deviceWidth*0.01),
                      Container(
                        alignment: Alignment.center,
                        child: Text(DateFormat(dateFormat).format(_selectedDay),
                            style: TextStyle(
                                color: colorMainText,
                                fontSize: deviceWidth * 0.05,
                                fontWeight: FontWeight.bold)
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.01),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right_rounded,
                            color: colorSpecialItem, size: deviceWidth * 0.06),
                        splashRadius: 0.001,
                        onPressed: () {
                          setState(() {
                            _selectedDay=_selectedDay.add(Duration(days: 1));
                          });
                        },
                      ),
                    ],
                  ),

                  if (events.length == 0) SizedBox(height: deviceHeight*0.025,),
                  if (events.length == 0) Container(
                    width: deviceWidth * 0.85,
                    alignment: Alignment.center,
                    child: Image.asset('assets/event_preview_dark.png',
                      scale: deviceWidth * 0.0001,),
                  ),
                  if (events.length > 0) SizedBox(height: deviceHeight * 0.01),
                  Column(children: events.map(buildEventBox).toList(),),
                  if (events.length > 0) SizedBox(height: deviceHeight * 0.01),
                ],);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: deviceHeight*0.075,),
                  Container(child: CircularProgressIndicator(color: colorSpecialItem)),
                ],
              );
            }
          }),

    ]);
  }

  Widget buildEventBox(Event event){

    late int color;
    if (event.color == -1 && darkMode == false) {
      color = 0xFFFFFFFF;
    } else if (event.color == -1 && darkMode == true) {
      color = 0xff1c1c1f;
    } else {
      color = event.color;
    }

    DateTime eventDate = event.dateTime;

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;
    Color secondColor = colorSecondText;
    Color iconColor = colorSpecialItem;
    if(event.color != -1) {
      secondColor = colorMainText;
      iconColor = colorMainText;
    }

    return FocusedMenuHolder(
      onPressed: (){
        selectedEvent = event;
        Navigator.pushNamed(context, '/events/event_details');
      },
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.open_in_new_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Ver detalles', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            selectedEvent = event;
            Navigator.pushNamed(context, '/events/event_details');
          },
        ),
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, color: colorSpecialItem, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Editar', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            selectedEvent = event;
            Navigator.pushNamed(context, '/events/edit_event');
          },
        ),
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Compartir', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            // TODO: Share events
          },
        ),
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline_rounded, color: Colors.red, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Eliminar', style: TextStyle(
                    color: Colors.red,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            cancelAllNotifications(event.id);
            deleteEventById(event.id);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Evento eliminado"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ));
          },
        ),
      ],
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(deviceWidth * 0.018),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(color),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(width: deviceWidth*0.0125,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat('HH').format(eventDate), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.0625, fontWeight: FontWeight.bold)),
                      Text(DateFormat('mm').format(eventDate), style: TextStyle(color: secondColor, fontSize: deviceWidth * 0.05, fontWeight: FontWeight.normal)),
                      if (format24Hours==false) Text(DateFormat('aa').format(eventDate), style: TextStyle(color: secondColor, fontSize: deviceWidth * 0.034, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  SizedBox(width: deviceWidth*0.0125,),
                  VerticalDivider(color: colorSecondText,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: deviceWidth*0.575,
                          alignment: Alignment.centerLeft,
                          child: Text(event.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.06, fontWeight: FontWeight.bold))),
                      if (event.description!='') SizedBox(height: deviceHeight*0.00375,),
                      if (event.description!='') Container(
                          width: deviceWidth*0.575,
                          alignment: Alignment.centerLeft,
                          child: Text(event.description,
                              textAlign: TextAlign.justify,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: secondColor, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                    ],
                  ),
                  SizedBox(width: deviceWidth*0.025,),
                  Icon(Icons.open_in_new_rounded, color: iconColor, size: deviceWidth * 0.06),
                ],
              ),
            ),
          ),
          SizedBox(height: deviceHeight*0.0125,),
        ],
      ),
    );
  }

}

