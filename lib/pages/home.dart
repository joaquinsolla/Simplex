import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/shared_preferences_service.dart';
import 'all_pages.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    selectedEvent = null;
    selectedTodo = null;
    selectedNote = null;
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

    if (deviceChecked == false) _check_device();
    if (routineDay == 0) _calculateDayOfWeek();

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
          controller: pageController,
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          onPageChanged: (index) {
            setState(() {
              homeIndex = index;
            });
          }),
      bottomNavigationBar: _homeBottomNavigationBar(),
    );
  }

  /// SETTINGS VIEW
  Container SettingsView(){
    final user = FirebaseAuth.instance.currentUser!;

    return HomeArea(null,
        HomeHeader('Ajustes', []),
        FooterCredits(),
        [
      Text('Globalización',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * fontSize * 0.05,
              fontWeight: FontWeight.bold)),
      SizedBox(
        height: deviceHeight * 0.0125,
      ),
      FormContainer([
        SettingsRow(
          'Formato 24 horas',
          'Activado: 24 horas.\n'
              'Desactivado: 12 horas + AM/PM.',
          Switch(
            value: format24Hours,
            onChanged: (val) {
              setState(() {
                format24Hours = val;
              });
              saveSettingBool('format24Hours', val);
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
        SettingsRow(
          'Formato de fechas',
          'Activado: dd/mm/aaaa (Europa).\n'
              'Desactivado: mm/dd/aaaa (US).',
          Switch(
            value: formatDates,
            onChanged: (val) {
              setState(() {
                formatDates = val;
              });
              saveSettingBool('formatDates', val);
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
        SettingsRow(
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
              saveSettingBool('appLocale', val);
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
              fontSize: deviceWidth * fontSize * 0.05,
              fontWeight: FontWeight.bold)),
      SizedBox(
        height: deviceHeight * 0.0125,
      ),
      FormContainer([
        SettingsRow(
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
                  colorThirdBackground = const Color(0xff3a393e);
                  colorButtonText = const Color(0xff1c1c1f);
                  colorNavigationBarBackground = const Color(0xff1c1c1f);
                  colorNavigationBarText = const Color(0xff3a393e);
                  colorMainText = Colors.white;
                  colorSecondText = const Color(0xff706e74);
                  colorThirdText = const Color(0xff706e74);
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
              saveSettingBool('darkMode', val);
            },
            activeColor: colorSpecialItem,
          ),
        ),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
        Divider(color: colorThirdText),
        SecondaryButton(colorSpecialItem, 'Ajusta el tamaño del texto', (){
          Navigator.pushNamed(context, '/settings/settings_font');
        }),
      ]),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
      Text('Cuenta',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * fontSize * 0.05,
              fontWeight: FontWeight.bold)),
      SizedBox(
        height: deviceHeight * 0.0125,
      ),
      FormContainer([
        Text(
          'Email:',
          style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * fontSize * 0.0475,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: deviceHeight * 0.0025,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                user.email!,
                style: TextStyle(
                    color: colorSecondText,
                    fontSize: deviceWidth * fontSize * 0.04,
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
                fontSize: deviceWidth * fontSize * 0.0475,
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
                fontSize: deviceWidth * fontSize * 0.04,
                fontWeight: FontWeight.normal),
          ),
        SizedBox(
          height: deviceHeight * 0.005,
        ),
        Divider(color: colorThirdText),
        SecondaryButton(colorSpecialItem, 'Cambia tu contraseña', (){
          Navigator.pushNamed(context, '/services/change_password_service');
        }),
      ]),
      SizedBox(height: deviceHeight * 0.025),
      MainButton(
          Icons.help_outline_rounded,
          colorSpecialItem,
          ' Ayuda ',
              () {
                Navigator.pushNamed(context, '/help/help_main');
              }
      ),
      SizedBox(height: deviceHeight * 0.025),
      MainButton(
          Icons.logout_rounded,
          Colors.red,
          ' Cerrar sesión ',
          () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Cerrar sesión'),
                    content: Text('Para volver a acceder a tu cuenta deberás '
                        'proporcionar tu email y contraseña.'),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            try{
                              loginIndex = 0;
                              homeIndex = 0;
                              FirebaseAuth.instance.signOut();
                              debugPrint('[OK] Signed out');
                            } on Exception catch (e) {
                              debugPrint('[ERR] Cannot sign out: $e');
                              showErrorSnackBar(context, 'Ha ocurrido un error, '
                                  'inténtalo de nuevo');
                            }
                          },
                          child: Text('Aceptar', style: TextStyle(color: colorSpecialItem),)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar', style: TextStyle(color: Colors.red),),
                      )
                    ],
                  );
                });
          }
      ),
    ]
    );
  }

  /// AUX FUNCTIONS
  void _check_device(){
    setState(() {
      var padding = MediaQuery.of(context).padding;
      verticalDevice = MediaQuery.of(context).orientation == Orientation.portrait;

      deviceHeight = max(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) - padding.top - padding.bottom;
      deviceWidth = min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

      if (deviceHeight!=0 || deviceWidth!=0){
        debugPrint('[OK] Device checked.');
        deviceChecked = true;
      } else _check_device();
    });
  }

  void _calculateDayOfWeek(){
    weekDay = DateTime.now().weekday;
    debugPrint('[OK] weekDay set to: $weekDay');
    routineDay = weekDay;
    debugPrint('[OK] routineDay set to: $routineDay');
  }

  /// AUX WIDGETS
  BottomNavyBar _homeBottomNavigationBar() {
    return BottomNavyBar(
      backgroundColor: colorNavigationBarBackground,
      selectedIndex: homeIndex,
      onItemSelected: (index) {
        setState(() => homeIndex = index);
        pageController.jumpToPage(index);
      },
      containerHeight: deviceHeight*0.08,
      iconSize: deviceHeight*0.0325,
      curve: Curves.easeInOutQuart,
      items: <BottomNavyBarItem>[
        _homeBottomNavigationBarItem('Calendario', const Icon(Icons.calendar_month_rounded)),
        _homeBottomNavigationBarItem('Tareas', const Icon(Icons.check_circle_outline_rounded)),
        _homeBottomNavigationBarItem('Notas', const Icon(Icons.sticky_note_2_outlined)),
        _homeBottomNavigationBarItem('Rutina', const Icon(Icons.loop_rounded)),
        _homeBottomNavigationBarItem('Ajustes', const Icon(Icons.settings_outlined)),
      ],
    );
  }

  BottomNavyBarItem _homeBottomNavigationBarItem(String text, Icon icon) {
    return BottomNavyBarItem(
        title: Text(text,
          style: TextStyle(
            fontSize: deviceWidth * fontSize * 0.036,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: icon,
        activeColor: colorSpecialItem,
        inactiveColor: colorNavigationBarText,
        textAlign: TextAlign.center);
  }

}
