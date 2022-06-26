import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';

import 'package:simplex/common/all_common.dart';
import 'package:simplex/classes/all_classes.dart';
import 'package:simplex/services/firestore_service.dart';
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

    final user = FirebaseAuth.instance.currentUser!;

    if (deviceChecked == false) check_device();

    List<Widget> homeViews = [
      EventsMainPage(),
      routinesView(),
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
  Container routinesView() {
    return homeArea([
      homeHeaderSimple(
        'Rutina',
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
    late IconData filterIcon;
    if (useTodosFilters==false) filterIcon = Icons.filter_list_rounded;
    else filterIcon = Icons.filter_list_off_rounded;

    return homeArea([
      homeHeaderDouble(
        'Tareas',
        IconButton(
          icon: Icon(filterIcon,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            setState(() {
              useTodosFilters = !useTodosFilters;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            Navigator.pushNamed(context, '/todos/add_todo');
          },
        ),
      ),

      if(useTodosFilters) filterSelector(),
      if(useTodosFilters) SizedBox(height: deviceHeight*0.02,),

      StreamBuilder<List<Todo>>(
          stream: readPendingTodos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] ' + snapshot.error.toString());
              return SizedBox.shrink();
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;
              return SizedBox();
            } else {
              return SizedBox.shrink();
            }
          }),

      StreamBuilder<List<Todo>>(
          stream: readDoneTodos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] ' + snapshot.error.toString());
              return SizedBox.shrink();
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;
              return SizedBox();
            } else {
              return SizedBox.shrink();
            }
          }),

      StreamBuilder<List<Todo>>(
          stream: readAllTodos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] ' + snapshot.error.toString());
              return SizedBox.shrink();
            } else if (snapshot.hasData) {
              final todosLength = snapshot.data!.length;
              if (darkMode==false && todosLength<=0 &&useTodosFilters==false) return Container(
                width: deviceWidth*0.85,
                height: deviceHeight*0.65,
                alignment: Alignment.center,
                child: Image.asset('assets/event_preview_light.png', scale: deviceWidth*0.008,),
              );
              else if (darkMode==true && todosLength<=0 &&useTodosFilters==false) return Container(
                width: deviceWidth*0.85,
                height: deviceHeight*0.65,
                alignment: Alignment.center,
                child: Image.asset('assets/event_preview_dark.png', scale: deviceWidth*0.008,),
              );
              else return SizedBox.shrink();
            } else {
              return SizedBox.shrink();
            }
          }),

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
              });
              saveSetting('format24Hours', val);
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
              });
              saveSetting('formatDates', val);
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
                if (val == true)
                  appLocale = Locale('es', '');
                else
                  appLocale = Locale('en', '');
              });
              saveSetting('appLocale', val);
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
        SizedBox(height: deviceHeight * 0.0025,),
        Wrap(
          children: [
            Text(user.email!, style: TextStyle(
                color: colorSecondText,
                fontSize: deviceWidth * 0.04,
                fontWeight: FontWeight.normal),),
            SizedBox(width: deviceWidth * 0.005,),
            Icon(Icons.verified_rounded, color: colorSecondText, size: deviceWidth*0.04,),
          ],
        ),
        if (isTester) SizedBox(height: deviceHeight * 0.005,),
        if (isTester) Divider(color: colorThirdText),
        if (isTester) SizedBox(height: deviceHeight * 0.005,),
        if (isTester) Text('Tester:', style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.0475,
            fontWeight: FontWeight.bold),),
        if (isTester) SizedBox(height: deviceHeight * 0.0025,),
        if (isTester) Text('Formas parte del programa de testers.', style: TextStyle(
            color: colorSecondText,
            fontSize: deviceWidth * 0.04,
            fontWeight: FontWeight.normal),),
        SizedBox(height: deviceHeight * 0.005,),
        Divider(color: colorThirdText),
        Container(
          width: deviceWidth*0.8,
          height: deviceHeight*0.05,
          child: TextButton(
            child: Text('Cambia tu contraseña', style: TextStyle(
                color: colorSpecialItem,
                fontSize: deviceWidth * 0.04,
                fontWeight: FontWeight.normal),),
            onPressed: (){
              Navigator.pushNamed(context, '/services/change_password_service');
            },
          ),
        ),
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
          children: [
            SizedBox(
              width: deviceWidth * 0.8,
              height: deviceHeight * 0.07,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red,
                        size: deviceWidth * 0.06),
                    Text(
                      ' Cerrar sesión ',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: deviceWidth * 0.05,
                          fontWeight: FontWeight.normal),
                    ),
                    Icon(Icons.logout_rounded, color: Colors.transparent,
                        size: deviceWidth * 0.06),
                  ],
                ),
                onPressed: () {
                  loginIndex = 0;
                  homeIndex = 0;
                  FirebaseAuth.instance.signOut();
                  debugPrint('[OK] Signed out');
                },
              ),
            ),
          ],
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
        myBottomNavyBarItem('Rutina', const Icon(Icons.timeline_rounded)),
        myBottomNavyBarItem('Tareas', const Icon(Icons.check_circle_outline_rounded)),
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
                    groupValue: currentFilter,
                    activeColor: colorThirdBackground,
                    onChanged: (val) {
                      setState(() {
                        currentFilter = val as int;
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
                  groupValue: currentFilter,
                  activeColor: const Color(0xffF44336),
                  onChanged: (val) {
                    setState(() {
                      currentFilter = val as int;
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
                  groupValue: currentFilter,
                  activeColor: const Color(0xffFF9800),
                  onChanged: (val) {
                    setState(() {
                      currentFilter = val as int;
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
                  groupValue: currentFilter,
                  activeColor: const Color(0xff4CAF50),
                  onChanged: (val) {
                    setState(() {
                      currentFilter = val as int;
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
                  groupValue: currentFilter,
                  activeColor: const Color(0xff448AFF),
                  onChanged: (val) {
                    setState(() {
                      currentFilter = val as int;
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
                  groupValue: currentFilter,
                  activeColor: const Color(0xff7C4DFF),
                  onChanged: (val) {
                    setState(() {
                      currentFilter = val as int;
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
    String eventTime = DateFormat('HH:mm').format(event.dateTime);
    if (format24Hours==false) eventTime = DateFormat('h:mm aa').format(event.dateTime);
    Color timeColor = colorSecondText;
    Color iconColor = colorSpecialItem;
    if(event.color != -1) {
      timeColor = colorMainText;
      iconColor = colorMainText;
    }

    if ((useEventFilters && (event.color == currentFilter || currentFilter == 0)) || useEventFilters==false) return FocusedMenuHolder(
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
    else return SizedBox.shrink();
  }

}
