import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageController = new PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
          children: homeViews,
          controller: _pageController,
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          onPageChanged: (index) {
            setState(() {
              homeIndex = index;
            });
          }),
      bottomNavigationBar: homeBottomNavigationBar(),
    );
  }

  List<Widget> homeViews = [
    new Center(child: Text("Page 1", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold))),
    new Center(child: Text("Page 2", style: TextStyle(fontSize: 50))),
    new Center(child: Text("Page 3", style: TextStyle(fontSize: 50))),
    new Center(child: Text("Page 4", style: TextStyle(fontSize: 50)))
  ];

  BottomNavyBar homeBottomNavigationBar() {
    return BottomNavyBar(
      selectedIndex: homeIndex,
      onItemSelected: (index) {
        setState(() => homeIndex = index);
        _pageController.jumpToPage(index);
      },
      containerHeight: 70,
      iconSize: 27.5,
      curve: Curves.easeInOutQuart,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            title: Text('Eventos'),
            icon: Icon(Icons.today_rounded),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center),
        BottomNavyBarItem(
            title: Text('Hábitos'),
            icon: Icon(Icons.lightbulb_outline_rounded),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center),
        BottomNavyBarItem(
            title: Text('Notas'),
            icon: Icon(Icons.sticky_note_2_outlined),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center),
        BottomNavyBarItem(
            title: Text('Ajustes'),
            icon: Icon(Icons.settings_outlined),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center),
      ],
    );
  }
}
