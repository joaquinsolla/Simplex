import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/shared_preferences_service.dart';
import 'all_pages.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    selectedEvent = null;
    final user = FirebaseAuth.instance.currentUser!;
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    doc.get().then((val) => isTester = val.data()!['tester']);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (deviceChecked == false) check_device();

    List<Widget> homeViews = [
      EventsMainPage(),
      TodosMainPage(),
      NotesMainPage(),
      RoutinesMainPage(),
      SettingsView(),
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

  /// SETTINGS VIEW
  Container SettingsView(){
    final user = FirebaseAuth.instance.currentUser!;

    return homeArea([
      headerText('Ajustes'),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
      Text('Formatos y medidas',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)),
      SizedBox(
        height: deviceHeight * 0.0125,
      ),
      formContainer([
        settingsRow(
          'Formato 24 horas',
          'Activado: 24 horas.\n'
              'Desactivado: 12 horas + AM/PM.',
          Switch(
            value: format24Hours,
            onChanged: (val) {
              setState(() {
                format24Hours = val;
              });
              saveSetting('format24Hours', val);
            },
            activeColor: colorSpecialItem,
          ),
        ),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
        Divider(color: colorThirdText),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
        settingsRow(
          'Formato de fechas',
          'Activado: dd/mm/aaaa (Europa).\n'
              'Desactivado: mm/dd/aaaa (US).',
          Switch(
            value: formatDates,
            onChanged: (val) {
              setState(() {
                formatDates = val;
              });
              saveSetting('formatDates', val);
            },
            activeColor: colorSpecialItem,
          ),
        ),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
        Divider(color: colorThirdText),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
        settingsRow(
          'Calendario Europeo',
          'Decide en qué día comienza la semana.'
              '\nActivado: Lunes (Europa).\n'
              'Desactivado: Domingo (US).',
          Switch(
            value: (appLocale == Locale('es', '')),
            onChanged: (val) {
              setState(() {
                if (val == true)
                  appLocale = Locale('es', '');
                else
                  appLocale = Locale('en', '');
              });
              saveSetting('appLocale', val);
            },
            activeColor: colorSpecialItem,
          ),
        ),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
      ]),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
      Text('Apariencia',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)),
      SizedBox(
        height: deviceHeight * 0.0125,
      ),
      formContainer([
        settingsRow(
          'Tema oscuro',
          'Activado: Tema oscuro.\n'
              'Desactivado: Tema claro.',
          Switch(
            value: darkMode,
            onChanged: (val) {
              setState(() {
                darkMode = val;
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
                  colorCalendarEvent = Color(0xfff2f2f7);
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
                  colorCalendarEvent = Color(0xff1f2932);
                }
              });
              saveSetting('darkMode', val);
            },
            activeColor: colorSpecialItem,
          ),
        ),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
      ]),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
      Text('Cuenta',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.bold)),
      SizedBox(
        height: deviceHeight * 0.0125,
      ),
      formContainer([
        Text(
          'Email:',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.0475,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: deviceHeight * 0.0025,
        ),
        Wrap(
          children: [
            Text(
              user.email!,
              style: TextStyle(
                  color: colorSecondText,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              width: deviceWidth * 0.005,
            ),
            Icon(
              Icons.verified_rounded,
              color: colorSecondText,
              size: deviceWidth * 0.04,
            ),
          ],
        ),
        if (isTester)
          SizedBox(
            height: deviceHeight * 0.005,
          ),
        if (isTester) Divider(color: colorThirdText),
        if (isTester)
          SizedBox(
            height: deviceHeight * 0.005,
          ),
        if (isTester)
          Text(
            'Tester:',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),
          ),
        if (isTester)
          SizedBox(
            height: deviceHeight * 0.0025,
          ),
        if (isTester)
          Text(
            'Formas parte del programa de testers.',
            style: TextStyle(
                color: colorSecondText,
                fontSize: deviceWidth * 0.04,
                fontWeight: FontWeight.normal),
          ),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
        Divider(color: colorThirdText),
        Container(
          width: deviceHeight,
          height: deviceHeight * 0.05,
          child: TextButton(
            child: Text(
              'Cambia tu contraseña',
              style: TextStyle(
                  color: colorSpecialItem,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/services/change_password_service');
            },
          ),
        ),
      ]),
      SizedBox(height: deviceHeight * 0.025),
      actionsButton(
          Icons.logout_rounded,
          Colors.red,
          ' Cerrar sesión ',
          () {
            loginIndex = 0;
            homeIndex = 0;
            FirebaseAuth.instance.signOut();
            debugPrint('[OK] Signed out');
          }
      ),
      SizedBox(height: deviceHeight * 0.025),
    ]);
  }

  /// AUX FUNCTIONS
  void check_device(){
    setState(() {
      var padding = MediaQuery.of(context).padding;
      deviceHeight = max(MediaQuery.of(context).size.height - padding.top - padding.bottom, MediaQuery.of(context).size.width - padding.top - padding.bottom);
      deviceWidth = min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

      if (deviceHeight!=0 || deviceWidth!=0){
        debugPrint('[OK] Device checked.');
        deviceChecked = true;
      } else check_device();
    });
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
        myBottomNavyBarItem('Calendario', const Icon(Icons.today_rounded)),
        myBottomNavyBarItem('Tareas', const Icon(Icons.check_circle_outline_rounded)),
        myBottomNavyBarItem('Notas', const Icon(Icons.sticky_note_2_outlined)),
        myBottomNavyBarItem('Rutina', const Icon(Icons.timeline_rounded)),
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
