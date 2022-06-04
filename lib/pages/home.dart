import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    darkMode = SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
    initializeDB().whenComplete(() async {
      _refreshEvents();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshEvents() async {
    final events = await getEvents();
    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (deviceChecked == false) {
      var padding = MediaQuery.of(context).padding;

      setState(() {
        deviceWidth = MediaQuery.of(context).size.width;
        deviceHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
        deviceChecked = true;

        if (darkMode) {
            colorMainBackground = Colors.black;
            colorSecondBackground = const Color(0xff1c1c1f);
            colorNavigationBarBackground = const Color(0xff1c1c1f);
            colorNavigationBarText = const Color(0xff3a393e);
            colorMainText = Colors.white;
            colorSecondText = const Color(0xff706e74);
        }
      });

      debugPrint('[OK] Device checked.');
    }

    List<Widget> homeViews = [
      eventsView(context, _events),
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
}
