import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';

import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/sqlite_service.dart';
import 'all_pages.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageController = PageController();
  List<Event> _todayEvents = [];
  List<Event> _tomorrowEvents = [];
  List<Event> _thisMonthEvents = [];
  List<Event> _restOfEvents = [];

  @override
  void initState() {
    super.initState();
    darkMode = SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
    if (darkMode) {
      colorMainBackground = Colors.black;
      colorSecondBackground = const Color(0xff1c1c1f);
      colorThirdBackground = const Color(0xff706e74);
      colorButtonText = const Color(0xff1c1c1f);
      colorNavigationBarBackground = const Color(0xff1c1c1f);
      colorNavigationBarText = const Color(0xff3a393e);
      colorMainText = Colors.white;
      colorSecondText = const Color(0xff706e74);
      colorThirdText = const Color(0xff3a393e);
    }
    initializeDB().whenComplete(() async {
      _refreshEvents();
      setState(() {
        selectedEvent = null;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (deviceChecked == false) check_device();

    List<Widget> homeViews = [
      eventsView(),
      habitsView(),
      notesView(),
      settingsView()
    ];

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: PageView(
          children: homeViews,
          controller: _pageController,
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          onPageChanged: (index) {
            setState(() {
              homeIndex = index;
            });
          }),
      bottomNavigationBar: homeBottomNavigationBar(),
    );
  }

  /// VIEWS
  Container eventsView() {

    String todayAmount = _todayEvents.length.toString();
    String tomorrowAmount = _tomorrowEvents.length.toString();
    String thisMonthAmount = _thisMonthEvents.length.toString();
    String restAmount = _restOfEvents.length.toString();
    late IconData filterIcon;
    if (useEventFilters==false) filterIcon = Icons.filter_list_rounded;
    else filterIcon = Icons.filter_list_off_rounded;

    if (expiredEventsDeleted==false){
      deleteExpiredEvents();
      expiredEventsDeleted=true;
    }

    return homeArea([
      homeHeaderAdvanced('Eventos',
        IconButton(
          icon: Icon(filterIcon,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            setState(() {
              useEventFilters = !useEventFilters;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/events/add_event');
          },
        ),
      ),

      if(useEventFilters) filterSelector(),
      if(useEventFilters) SizedBox(height: deviceHeight*0.02,),

      if (_todayEvents.isNotEmpty && useEventFilters==false) Text('Hoy ($todayAmount)',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)
      ),
      if (_todayEvents.isNotEmpty && useEventFilters==false) SizedBox(height: deviceHeight * 0.01),
      if (useEventFilters==false) for (var event in _todayEvents)eventBox(context, event),
      if (useEventFilters) for (var event in _todayEvents) if (event.color == currentEventFilter || currentEventFilter==0) eventBox(context, event),

      if (_tomorrowEvents.isNotEmpty && useEventFilters==false) SizedBox(height: deviceHeight * 0.02),
      if (_tomorrowEvents.isNotEmpty && useEventFilters==false) Text('Mañana ($tomorrowAmount)',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)
      ),
      if (_tomorrowEvents.isNotEmpty && useEventFilters==false) SizedBox(height: deviceHeight * 0.01),
      if (useEventFilters==false) for (var event in _tomorrowEvents)eventBox(context, event),
      if (useEventFilters) for (var event in _tomorrowEvents) if (event.color == currentEventFilter || currentEventFilter==0) eventBox(context, event),

      if (_thisMonthEvents.isNotEmpty && useEventFilters==false) SizedBox(height: deviceHeight * 0.02),
      if (_thisMonthEvents.isNotEmpty && useEventFilters==false) Text('Este mes ($thisMonthAmount)',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)
      ),
      if (_thisMonthEvents.isNotEmpty && useEventFilters==false) SizedBox(height: deviceHeight * 0.01),
      if (useEventFilters==false) for (var event in _thisMonthEvents)eventBox(context, event),
      if (useEventFilters) for (var event in _thisMonthEvents) if (event.color == currentEventFilter || currentEventFilter==0) eventBox(context, event),

      if (_thisMonthEvents.isNotEmpty && useEventFilters==false) SizedBox(height: deviceHeight * 0.02),
      if (_restOfEvents.isNotEmpty && useEventFilters==false) Text('Próximamente ($restAmount)',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)
      ),
      if (_restOfEvents.isNotEmpty && useEventFilters==false) SizedBox(height: deviceHeight * 0.01),
      if (useEventFilters==false) for (var event in _restOfEvents)eventBox(context, event),
      if (useEventFilters) for (var event in _restOfEvents) if (event.color == currentEventFilter || currentEventFilter==0) eventBox(context, event),

      if (_todayEvents.isEmpty && _tomorrowEvents.isEmpty && _thisMonthEvents.isEmpty && _restOfEvents.isEmpty) Container(
        height: deviceHeight*0.65,
        alignment: Alignment.center,
        child: Text('No tienes eventos guardados todavía. Para crear uno pulsa el botón + en la parte superior de la pantalla.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: deviceWidth*0.0475, color: colorSecondText),),
      ),
    ]);
  }

  Container habitsView() {
    return homeArea([
      homeHeaderSimple(
        'Nuevos hábitos',
        IconButton(
          icon: Icon(Icons.add_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {},
        ),
      )
    ]);
  }

  Container notesView() {
    return homeArea([
      homeHeaderSimple(
        'To-Do',
        IconButton(
          icon: Icon(Icons.add_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {},
        ),
      ),
    ]);
  }

  Container settingsView(){
    return homeArea([
      headerText('Ajustes'),
      SizedBox(height: deviceHeight*0.03,),

    ]);
  }


  /// AUX FUNCTIONS
  void check_device(){
    setState(() {
      var padding = MediaQuery.of(context).padding;
      deviceHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
      deviceWidth = MediaQuery.of(context).size.width;

      if (deviceHeight!=0 || deviceWidth!=0){
        debugPrint('[OK] Device checked.');
        deviceChecked = true;
      } else check_device();
    });
  }

  void _refreshEvents() async {
    final todayEvents = await getTodayEvents();
    final tomorrowEvents = await getTomorrowEvents();
    final thisMonthEvents = await getThisMonthEvents();
    final restOfEvents = await getRestOfEvents();
    setState(() {
      _todayEvents = todayEvents;
      _tomorrowEvents = tomorrowEvents;
      _thisMonthEvents = thisMonthEvents;
      _restOfEvents = restOfEvents;
    });
    debugPrint('[OK] Read events');
  }

  /// AUX WIDGETS
  BottomNavyBar homeBottomNavigationBar() {
    return BottomNavyBar(
      backgroundColor: colorNavigationBarBackground,
      selectedIndex: homeIndex,
      onItemSelected: (index) {
        setState(() => homeIndex = index);
        _pageController.jumpToPage(index);
      },
      containerHeight: deviceHeight*0.08,
      iconSize: deviceHeight*0.0325,
      curve: Curves.easeInOutQuart,
      items: <BottomNavyBarItem>[
        myBottomNavyBarItem('Eventos', const Icon(Icons.today_rounded)),
        myBottomNavyBarItem('Hábitos', const Icon(Icons.lightbulb_outline_rounded)),
        myBottomNavyBarItem('To-Do', const Icon(Icons.check_circle_outline_rounded)),
        myBottomNavyBarItem('Ajustes', const Icon(Icons.settings_outlined)),
      ],
    );
  }

  BottomNavyBarItem myBottomNavyBarItem(String text, Icon icon) {
    return BottomNavyBarItem(
        title: Text(text),
        icon: icon,
        activeColor: colorSpecialItem,
        inactiveColor: colorNavigationBarText,
        textAlign: TextAlign.center);
  }

  FocusedMenuHolder eventBox(BuildContext context, Event event) {

    late int color;
    if (event.color == -1 && darkMode == false) {
      color = 0xFFFFFFFF;
    } else if (event.color == -1 && darkMode == true) {
      color = 0xff1c1c1f;
    } else {
      color = event.color;
    }

    DateTime eventDate = DateTime.fromMicrosecondsSinceEpoch(event.dateTime * 1000);

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;
    String eventTime = DateFormat('HH:mm').format(DateTime.fromMicrosecondsSinceEpoch(event.dateTime*1000));
    Color timeColor = colorSecondText;
    Color iconColor = colorSpecialItem;
    if(event.color != -1) {
      timeColor = colorMainText;
      iconColor = colorMainText;
    }

    return FocusedMenuHolder(
      onPressed: (){
        selectedEvent = event;
        Navigator.pushReplacementNamed(context, '/events/event_details');
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
            Navigator.pushReplacementNamed(context, '/events/event_details');
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
            Navigator.pushReplacementNamed(context, '/events/edit_event');
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
            selectedEvent = event;
            if (selectedEvent!.notification5Min != -1) cancelNotification(selectedEvent!.notification5Min);
            if (selectedEvent!.notification1Hour != -1) cancelNotification(selectedEvent!.notification1Hour);
            if (selectedEvent!.notification1Day != -1) cancelNotification(selectedEvent!.notification1Day);
            deleteEventById(selectedEvent!.id);
            _refreshEvents();
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
                      Text(eventDate.day.toString(), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.0625, fontWeight: FontWeight.bold)),
                      Text(monthConversor(eventDate), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.04, fontWeight: FontWeight.normal)),
                      if (DateTime.now().year != eventDate.year) Text(eventDate.year.toString(), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.034, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  SizedBox(width: deviceWidth*0.0125,),
                  VerticalDivider(color: colorSecondText,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: deviceWidth*0.6,
                          alignment: Alignment.centerLeft,
                          child: Text(event.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.06, fontWeight: FontWeight.bold))),
                      SizedBox(height: deviceHeight*0.00375,),
                      Container(
                          width: deviceWidth*0.6,
                          alignment: Alignment.centerLeft,
                          child: Text('A las $eventTime',
                              style: TextStyle(color: timeColor, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                    ],
                  ),
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

  Container filterSelector(){
    return Container(
      padding: EdgeInsets.all(deviceWidth * 0.025),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorSecondBackground,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtrar por color:',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.045,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.015),
          Container(
            alignment: Alignment.center,
            child: Wrap(children: [
              Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: colorThirdBackground,
                    disabledColor: colorThirdBackground,
                  ),
                  child: Radio(
                    value: 0,
                    groupValue: currentEventFilter,
                    activeColor: colorThirdBackground,
                    onChanged: (val) {
                      setState(() {
                        currentEventFilter = val as int;
                      });
                    },
                  )
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: const Color(0xffF44336),
                  disabledColor: const Color(0xffF44336),
                ),
                child: Radio(
                  value: 0xffF44336,
                  groupValue: currentEventFilter,
                  activeColor: const Color(0xffF44336),
                  onChanged: (val) {
                    setState(() {
                      currentEventFilter = val as int;
                    });
                  },
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: const Color(0xffFF9800),
                  disabledColor: const Color(0xffFF9800),
                ),
                child: Radio(
                  value: 0xffFF9800,
                  groupValue: currentEventFilter,
                  activeColor: const Color(0xffFF9800),
                  onChanged: (val) {
                    setState(() {
                      currentEventFilter = val as int;
                    });
                  },
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: const Color(0xff4CAF50),
                  disabledColor: const Color(0xff4CAF50),
                ),
                child: Radio(
                  value: 0xff4CAF50,
                  groupValue: currentEventFilter,
                  activeColor: const Color(0xff4CAF50),
                  onChanged: (val) {
                    setState(() {
                      currentEventFilter = val as int;
                    });
                  },
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: const Color(0xff448AFF),
                  disabledColor: const Color(0xff448AFF),
                ),
                child: Radio(
                  value: 0xff448AFF,
                  groupValue: currentEventFilter,
                  activeColor: const Color(0xff448AFF),
                  onChanged: (val) {
                    setState(() {
                      currentEventFilter = val as int;
                    });
                  },
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: const Color(0xff7C4DFF),
                  disabledColor: const Color(0xff7C4DFF),
                ),
                child: Radio(
                  value: 0xff7C4DFF,
                  groupValue: currentEventFilter,
                  activeColor: const Color(0xff7C4DFF),
                  onChanged: (val) {
                    setState(() {
                      currentEventFilter = val as int;
                    });
                  },
                ),
              ),
            ],),
          ),
        ],
      ),
    );
  }

}
