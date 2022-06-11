import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';

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
  }

  @override
  Widget build(BuildContext context) {

    if (deviceChecked == false) check_device();

    List<Widget> homeViews = [
      eventsView(context, _todayEvents, _tomorrowEvents, _thisMonthEvents, _restOfEvents),
      habitsView(context),
      notesView(context),
      settingsView(context)
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

}
