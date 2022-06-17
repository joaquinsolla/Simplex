import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  late Setting _settings;

  @override
  void initState() {
    super.initState();
    selectedEvent = null;
    initializeDB().whenComplete(() async {
      _readSettings();
      deleteExpiredEvents();
      _refreshEvents();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;

    if (deviceChecked == false) check_device();

    List<Widget> homeViews = [
      eventsView(),
      habitsView(),
      todosView(),
      notesView(),
      settingsView(user)
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

  Container todosView() {
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

  Container notesView() {
    return homeArea([
      homeHeaderSimple(
        'Notas',
        IconButton(
          icon: Icon(Icons.add_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {},
        ),
      ),
    ]);
  }

  Container settingsView(User user) {

    late int format24HoursInt;
    late int formatDatesInt;
    late int appLocaleInt;
    late int darkModeInt;

    return homeArea([
      headerText('Ajustes'),
      SizedBox(height: deviceHeight * 0.03,),
      Text('Formatos y medidas',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)
      ),
      SizedBox(height: deviceHeight * 0.005,),
      alternativeFormContainer([
        settingsRow(
          'Formato 24 horas', 'Activado: 24 horas.\n'
            'Desactivado: 12 horas + AM/PM.',
          Switch(
            value: format24Hours,
            onChanged: (val) {
              setState(() {
                format24Hours = val;
                if (val==false) format24HoursInt = 0;
                else format24HoursInt = 1;
                // To avoid data lost
                if (formatDates==false) formatDatesInt=0;
                else formatDatesInt=1;
                if (appLocale==Locale('es', '')) appLocaleInt=1;
                else appLocaleInt=0;
                if (darkMode==false) darkModeInt=0;
                else darkModeInt=1;
                updateSettings(Setting(id: 1, format24Hours: format24HoursInt, formatDates: formatDatesInt, appLocale: appLocaleInt, darkMode: darkModeInt));
              });
              debugPrint('[OK] Time format changed');
            },
            activeColor: colorSpecialItem,
          ),),

        SizedBox(height: deviceHeight * 0.005,),
        Divider(color: colorThirdText),
        SizedBox(height: deviceHeight * 0.005,),

        settingsRow(
          'Formato de fechas', 'Activado: dd/mm/aaaa (Europa).\n'
            'Desactivado: mm/dd/aaaa (US).',
          Switch(
            value: formatDates,
            onChanged: (val) {
              setState(() {
                formatDates = val;
                if (val==false) formatDatesInt = 0;
                else formatDatesInt = 1;
                // To avoid data lost
                if (format24Hours==false) format24HoursInt=0;
                else format24HoursInt=1;
                if (appLocale==Locale('es', '')) appLocaleInt=1;
                else appLocaleInt=0;
                if (darkMode==false) darkModeInt=0;
                else darkModeInt=1;
                updateSettings(Setting(id: 1, format24Hours: format24HoursInt, formatDates: formatDatesInt, appLocale: appLocaleInt, darkMode: darkModeInt));
              });
              debugPrint('[OK] Time format changed');
            },
            activeColor: colorSpecialItem,
          ),),

        SizedBox(height: deviceHeight * 0.005,),
        Divider(color: colorThirdText),
        SizedBox(height: deviceHeight * 0.005,),

        settingsRow(
          'Calendario Europeo',
          'Decide en qué día comienza la semana.'
            '\nActivado: Lunes (Europa).\n'
            'Desactivado: Domingo (US).',
          Switch(
            value: (appLocale == Locale('es', '')),
            onChanged: (val) {
              setState(() {
                if (val==true) appLocale = Locale('es', '');
                else appLocale = Locale('en', '');
                if (val==false) appLocaleInt = 0;
                else appLocaleInt = 1;
                // To avoid data lost
                if (format24Hours==false) format24HoursInt=0;
                else format24HoursInt=1;
                if (formatDates==false) formatDatesInt=0;
                else formatDatesInt=1;
                if (darkMode==false) darkModeInt=0;
                else darkModeInt=1;
                updateSettings(Setting(id: 1, format24Hours: format24HoursInt, formatDates: formatDatesInt, appLocale: appLocaleInt, darkMode: darkModeInt));
              });
              debugPrint('[OK] Calendar format changed');
            },
            activeColor: colorSpecialItem,
          ),),

        SizedBox(height: deviceHeight * 0.005,),
      ]),
      SizedBox(height: deviceHeight * 0.03,),
      Text('Apariencia',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)
      ),
      SizedBox(height: deviceHeight * 0.005,),
      alternativeFormContainer([
        settingsRow(
          'Tema oscuro', 'Activado: Tema oscuro.\n'
            'Desactivado: Tema claro.',
          Switch(
            value: darkMode,
            onChanged: (val) {
              setState(() {
                darkMode = val;
                if (val==false) darkModeInt = 0;
                else darkModeInt = 1;
                // To avoid data lost
                if (format24Hours==false) format24HoursInt=0;
                else format24HoursInt=1;
                if (formatDates==false) formatDatesInt=0;
                else formatDatesInt=1;
                if (appLocale==Locale('es', '')) appLocaleInt=1;
                else appLocaleInt=0;
                updateSettings(Setting(id: 1, format24Hours: format24HoursInt, formatDates: formatDatesInt, appLocale: appLocaleInt, darkMode: darkModeInt));
                if (val == true) {
                  colorMainBackground = Colors.black;
                  colorSecondBackground = const Color(0xff1c1c1f);
                  colorThirdBackground = const Color(0xff706e74);
                  colorButtonText = const Color(0xff1c1c1f);
                  colorNavigationBarBackground = const Color(0xff1c1c1f);
                  colorNavigationBarText = const Color(0xff3a393e);
                  colorMainText = Colors.white;
                  colorSecondText = const Color(0xff706e74);
                  colorThirdText = const Color(0xff3a393e);
                } else {
                  colorMainBackground = const Color(0xfff2f2f7);
                  colorSecondBackground = Colors.white;
                  colorThirdBackground = const Color(0xffe3e3e9);
                  colorButtonText = Colors.white;
                  colorNavigationBarBackground = const Color(0xffe3e3e9);
                  colorNavigationBarText = const Color(0xff747471);
                  colorMainText = Colors.black;
                  colorSecondText = Colors.grey;
                  colorThirdText = const Color(0xff747471);
                }
              });
              debugPrint('[OK] DarkMode changed');
            },
            activeColor: colorSpecialItem,
          ),),

        SizedBox(height: deviceHeight * 0.005,),
      ]),

      SizedBox(height: deviceHeight * 0.03,),
      Text('Cuenta',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)
      ),
      SizedBox(height: deviceHeight * 0.005,),
      alternativeFormContainer([
        Text('Email:', style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.0475,
            fontWeight: FontWeight.bold),),
        SizedBox(height: deviceHeight*0.0025,),
        Text(user.email!, style: TextStyle(
            color: colorSecondText,
            fontSize: deviceWidth * 0.04,
            fontWeight: FontWeight.normal),),
        SizedBox(height: deviceHeight * 0.005,),
      ]),
      SizedBox(height: deviceHeight * 0.025),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorSecondBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ SizedBox(
            width: deviceWidth*0.8,
            height: deviceHeight*0.07,
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red, size: deviceWidth * 0.06),
                  Text(
                    ' Cerrar sesión ',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: deviceWidth * 0.05,
                        fontWeight: FontWeight.normal),
                  ),
                  Icon(Icons.logout_rounded, color: Colors.transparent, size: deviceWidth * 0.06),
                ],
              ),
              onPressed: (){
                loginIndex = 0;
                FirebaseAuth.instance.signOut();
              },
            ),
          ),],
        ),
      ),
      SizedBox(height: deviceHeight * 0.025),
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

  void _readSettings() async {
    final settings = await getSettings();
    setState(() {
      _settings = settings[0];
    });
    if (settingsRead == false){
      setState(() {
        format24Hours = (_settings.format24Hours==1);
        formatDates = (_settings.formatDates==1);
        if (_settings.appLocale==1) appLocale = Locale('es', '');
        else appLocale = Locale('en', '');
        darkMode = (_settings.darkMode==1);
        if (darkMode == true) {
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
        settingsRead = true;
      });
    }
    debugPrint('[OK] Read settings');
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
        myBottomNavyBarItem('Notas', const Icon(Icons.sticky_note_2_outlined)),
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
    if (format24Hours==false) eventTime = DateFormat('h:mm aa').format(DateTime.fromMicrosecondsSinceEpoch(event.dateTime*1000));
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
