import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/event.dart';
import 'package:simplex/classes/todo.dart';
import 'package:simplex/services/firestore_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:simplex/common/all_common.dart';
import 'package:rxdart/rxdart.dart';

class EventsMainPage extends StatefulWidget {
  const EventsMainPage({Key? key}) : super(key: key);

  @override
  _EventsMainPageState createState() => _EventsMainPageState();
}

class _EventsMainPageState extends State<EventsMainPage> {
  Map<DateTime, List<dynamic>> daysWithEvents = {};
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
  }

  loadEventsToCalendar(List<Event> events, List<Todo> todos) {
    daysWithEvents = {};
    events.forEach((event) {
      DateTime date = DateTime(event.dateTime.year, event.dateTime.month, event.dateTime.day);
        if (daysWithEvents[date] != null){
          daysWithEvents[date]?.add(event);
        } else {
          daysWithEvents[date] = [event];
        }
    });
    todos.forEach((todo) {
      DateTime date = DateTime(todo.limitDate.year, todo.limitDate.month, todo.limitDate.day);
      if (daysWithEvents[date] != null){
        daysWithEvents[date]?.add(todo);
      } else {
        daysWithEvents[date] = [todo];
      }
    });
  }

  List<dynamic> _getEventsFromDay(DateTime dateTime){
    DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return daysWithEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    late String locale;
    late StartingDayOfWeek startingDayOfWeek;
    if (appLocale == Locale('es', '')) {
      locale = 'es_ES';
      startingDayOfWeek = StartingDayOfWeek.monday;
    } else {
      locale = 'en_EN';
      startingDayOfWeek = StartingDayOfWeek.sunday;
    }

    DateTime _selectedDayFormatted = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime tomorrow = today.add(Duration(days: 1));
    late String dateText;
    if (_selectedDayFormatted == today) dateText = 'Hoy';
    else if (_selectedDayFormatted == yesterday) dateText = 'Ayer';
    else if (_selectedDayFormatted == tomorrow) dateText = 'Mañana';
    else if (formatDates==true) dateText = DateFormat('dd/MM/yyyy').format(_selectedDay);
    else dateText = DateFormat('MM/dd/yyyy').format(_selectedDay);

    return homeArea([
      homeHeaderDouble('Calendario',
        IconButton(
          icon: Icon(Icons.help_outline_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            Navigator.pushNamed(context, '/events/events_help');
          },
        ),
        IconButton(
          icon: Icon(Icons.add_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            Navigator.pushNamed(context, '/events/add_event');
          },
        ),
      ),

      StreamBuilder<List<List<dynamic>>>(
          stream: CombineLatestStream.list([
            readAllEvents(),
            readPendingLimitedTodos(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load calendar: ' + snapshot.error.toString());
              return errorContainer('No se puede cargar el calendario.', 0.4);
            }
            else if (snapshot.hasData) {

              final events = snapshot.data![0];
              final todos = snapshot.data![1];
              loadEventsToCalendar(events as List<Event>, todos as List<Todo>);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: colorSecondBackground,
                child: TableCalendar(
                  onDayLongPressed: (selectedDay, focusedDay){
                    setState(() {
                      selectedDateTime = selectedDay;
                    });
                    Navigator.pushNamed(context, '/events/add_event');
                  },
                  eventLoader: _getEventsFromDay,
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
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      selectedDateTime = selectedDay;
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
                    markerDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorCalendarEvent,
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
              );
            }
            else return loadingContainer('Cargando calendario...', 0.4);
          }),

      StreamBuilder<List<List<dynamic>>>(
          stream: CombineLatestStream.list([
            readEventsOfDate(_selectedDay),
            readPendingTodosWithLimitDate(dateTimeToDateOnly(_selectedDay))
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load day events: ' + snapshot.error.toString());
              return errorContainer('No se pueden cargar los eventos de este día.', 0.35);
            }
            else if (snapshot.hasData) {
              final events = snapshot.data![0];
              final todos = snapshot.data![1];
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
                        width: deviceWidth*0.275,
                        alignment: Alignment.center,
                        child: Text(dateText,
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

                  if (events.length == 0 && todos.length == 0) SizedBox(height: deviceHeight*0.025,),
                  if (events.length == 0 && todos.length == 0 && darkMode==true) Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(
                      width: deviceWidth * 0.85,
                      alignment: Alignment.center,
                      child: Image.asset('assets/event_preview_dark.png',
                        scale: deviceWidth * 0.0001,),
                    ),],
                  ),
                  if (events.length == 0 && todos.length == 0 && darkMode==false) Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(
                      width: deviceWidth * 0.85,
                      alignment: Alignment.center,
                      child: Image.asset('assets/event_preview_light.png',
                        scale: deviceWidth * 0.0001,),
                    ),],
                  ),
                  if (events.length > 0 || todos.length > 0) SizedBox(height: deviceHeight * 0.01),

                  Column(children: todos.map(buildTodoBox).toList(),),

                  Column(children: events.map(buildEventBox).toList(),),
                  SizedBox(height: deviceHeight * 0.015),
                ],);
            }
            else return loadingContainer('Cargando eventos...', 0.35);
          }),

    ]);
  }

  Widget buildEventBox(dynamic event){

    late int color;
    late String dateFormat;
    if (event.color == -1 && darkMode == false) {
      color = 0xFFFFFFFF;
    } else if (event.color == -1 && darkMode == true) {
      color = 0xff1c1c1f;
    } else {
      color = event.color;
    }

    DateTime eventDate = event.dateTime;
    if (format24Hours==true) dateFormat = 'H:mm';
    else dateFormat = 'K:mm';
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
            // TODO: share events
            snackBar(context, '[Beta] En desarrollo', colorSpecialItem);
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
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('Eliminar evento'),
                  content: Text('Una vez eliminado no podrás restaurarlo.'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () async {
                          await cancelAllEventNotifications(event.id);
                          await deleteEventById(event.id);
                          Navigator.pop(context);
                          snackBar(context, 'Evento eliminado', Colors.green);
                        },
                        child: Text('Eliminar', style: TextStyle(color: colorSpecialItem),)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar', style: TextStyle(color: Colors.red),),
                    )
                  ],
                );
              });
          },
        ),
      ],
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(deviceWidth * 0.0185),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(color),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: deviceWidth*0.155,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(DateFormat(dateFormat).format(eventDate), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.055, fontWeight: FontWeight.bold)),
                        if (format24Hours==false) Text(DateFormat('aa').format(eventDate), style: TextStyle(color: secondColor, fontSize: deviceWidth * 0.034, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  VerticalDivider(color: secondColor,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: deviceWidth*0.515,
                          alignment: Alignment.centerLeft,
                          child: Text(event.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.06, fontWeight: FontWeight.bold))),
                      if (event.description!='') SizedBox(height: deviceHeight*0.00375,),
                      if (event.description!='') Container(
                          width: deviceWidth*0.515,
                          alignment: Alignment.centerLeft,
                          child: Text(event.description,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: secondColor, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                    ],
                  ),
                  Expanded(child: Text(''),),
                  Icon(Icons.open_in_new_rounded, color: iconColor, size: deviceWidth * 0.06),
                  SizedBox(width: deviceWidth*0.01,),
                ],
              ),
            ),
          ),
          SizedBox(height: deviceHeight*0.0125,),
        ],
      ),
    );
  }

  Widget buildTodoBox(dynamic todo){

    late int color;
    if (darkMode == false) {
      color = 0xFFFFFFFF;
    } else {
      color = 0xff1c1c1f;
    }

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;
    Color secondColor = colorSecondText;
    Color iconColor = colorSpecialItem;

    return FocusedMenuHolder(
      onPressed: (){
        selectedTodo = todo;
        Navigator.pushNamed(context, '/todos/todo_details');
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
            selectedTodo = todo;
            Navigator.pushNamed(context, '/todos/todo_details');
          },
        ),
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.done_all_rounded,
                    color: colorSpecialItem,
                    size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth * 0.025,),
                Text('Marcar como hecho', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: () {
            toggleTodo(todo.id, !todo.done);
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
            selectedTodo = todo;
            Navigator.pushNamed(context, '/todos/edit_todo');
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
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Eliminar tarea'),
                    content: Text('Una vez eliminada no podrás restaurarla.'),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () async {
                            await cancelAllTodoNotifications(todo.id);
                            await deleteTodoById(todo.id);
                            Navigator.pop(context);
                            snackBar(context, 'Tarea eliminada', Colors.green);
                          },
                          child: Text('Eliminar', style: TextStyle(color: colorSpecialItem),)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar', style: TextStyle(color: Colors.red),),
                      )
                    ],
                  );
                });
          },
        ),
      ],
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(deviceWidth * 0.0185),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(color),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: deviceWidth*0.155,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Tarea', style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.055, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  VerticalDivider(color: secondColor,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: deviceWidth*0.515,
                          alignment: Alignment.centerLeft,
                          child: Text(todo.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.06, fontWeight: FontWeight.bold))),
                      if (todo.description!='') SizedBox(height: deviceHeight*0.00375,),
                      if (todo.description!='') Container(
                          width: deviceWidth*0.515,
                          alignment: Alignment.centerLeft,
                          child: Text(todo.description,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: secondColor, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                    ],
                  ),
                  Expanded(child: Text(''),),
                  Icon(Icons.open_in_new_rounded, color: iconColor, size: deviceWidth * 0.06),
                  SizedBox(width: deviceWidth*0.01,),
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

