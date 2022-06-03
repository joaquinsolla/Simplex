import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simplex/common/all_common.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageController = PageController();

  @override
  void initState() {
    darkMode = SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            colorSecondText = const Color(0xff3a393e);
        }
      });

      if (kDebugMode) {
        print('[OK] Device checked.');
      }
    }

    List<Widget> homeViews = [
      // EVENTOS
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          color: colorSecondBackground,
          child: Text("Page 1",
              style: TextStyle(
                  fontSize: 50, fontWeight: FontWeight.bold, color: colorMainText)),),
        Container(
          color: colorSecondBackground,
          child: Text("Page 1",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.normal, color: colorSecondText)),),

      ]),

      // HABITOS
      new Center(child: Text("Page 2", style: TextStyle(fontSize: 50))),

      // NOTAS
      new Center(child: Text("Page 3", style: TextStyle(fontSize: 50))),

      // AJUSTES
      new Center(child: Text("Page 4", style: TextStyle(fontSize: 50)))
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
      containerHeight: 70,
      iconSize: 27.5,
      curve: Curves.easeInOutQuart,
      items: <BottomNavyBarItem>[
        myBottomNavyBarItem('Eventos', const Icon(Icons.today_rounded)),
        myBottomNavyBarItem(
            'Hábitos', const Icon(Icons.lightbulb_outline_rounded)),
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
}
