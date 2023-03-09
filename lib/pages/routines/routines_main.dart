import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

class RoutinesMainPage extends StatefulWidget {
  const RoutinesMainPage({Key? key}) : super(key: key);

  @override
  _RoutinesMainPageState createState() => _RoutinesMainPageState();
}

class _RoutinesMainPageState extends State<RoutinesMainPage> {
  final ScrollController _scrollController = ScrollController();

  late String dayText;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(weekDay == routineDay) dayText = 'hoy';
    else if(weekDay != routineDay && routineDay == 1) dayText = 'lunes';
    else if(weekDay != routineDay && routineDay == 2) dayText = 'martes';
    else if(weekDay != routineDay && routineDay == 3) dayText = 'miércoles';
    else if(weekDay != routineDay && routineDay == 4) dayText = 'jueves';
    else if(weekDay != routineDay && routineDay == 5) dayText = 'viernes';
    else if(weekDay != routineDay && routineDay == 6) dayText = 'sábado';
    else if(weekDay != routineDay && routineDay == 7) dayText = 'domingo';

    return HomeArea(_scrollController,
        HomeHeader('Rutina', [
            IconButton(
              icon: Icon(Icons.add_rounded,
                  color: colorSpecialItem, size: deviceWidth*fontSize*0.085),
              splashRadius: 0.001,
              onPressed: () {
                Navigator.pushNamed(context, '/routines/add_routine_element');
              },
            ),
          ]),
        FooterEmpty(),
        [
          RoutineWeekDaysButton(
              routineDay,
              [
                (){_setRoutineDay(1);},
                (){_setRoutineDay(2);},
                (){_setRoutineDay(3);},
                (){_setRoutineDay(4);},
                (){_setRoutineDay(5);},
                (){_setRoutineDay(6);},
                (){_setRoutineDay(7);},
              ]
          ),

          StreamBuilder<List<dynamic>>(
              stream: CombineLatestStream.list([
                readNotesOfRoutine(routineDay),
                readEventsOfRoutine(routineDay),
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('[ERR] Cannot load routine: ' + snapshot.error.toString());
                  return ErrorContainer('No se puede cargar esta rutina.', 0.35);
                }
                else if (snapshot.hasData) {

                  final notes = snapshot.data![0];
                  final events = snapshot.data![1];

                  if(notes.length>0 || events.length>0) return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      if(notes.length > 0) FormSeparator(),
                      if(notes.length > 0) FormCustomField(
                          'Tus notas para $dayText:',
                          [
                            Container(
                          height: deviceHeight*0.175,
                          child: ShaderMask(
                            shaderCallback: (Rect rect) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [colorMainBackground, Colors.transparent, Colors.transparent, colorMainBackground],
                                stops: [0.0, 0.035, 0.965, 1.0],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstOut,
                            child: ListView(
                                shrinkWrap: true,
                                addAutomaticKeepAlives: true,
                                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                                scrollDirection: Axis.horizontal,
                                children: notes.map<Widget>(buildNoteCard).toList()
                            ),
                          ),
                        ),
                          ],
                          true
                      ),

                      if(events.length > 0) FormSeparator(),
                      if(events.length > 0) FormCustomField(
                          'Tu rutina de $dayText:',
                          [
                            Column(children: events.map<Widget>(buildEventBox).toList(),),
                          ],
                          true
                      ),

                      if (events.length > 0) SizedBox(height: deviceHeight*0.01,),
                      if (events.length > 0) Container(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(Icons.arrow_circle_up_rounded,
                              color: colorSpecialItem, size: deviceWidth * 0.08),
                          splashRadius: 0.001,
                          onPressed: () async {
                            await Future.delayed(const Duration(milliseconds: 100));
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn);
                            });
                          },
                        ),),

                    ],
                  );

                  else return NoItemsContainer('elementos para tu rutina de $dayText', 0.65);

                }
                else return LoadingContainer('Cargando rutinas...', 0.35);
              }),
        ]
    );
  }

  void _setRoutineDay(int index){
    setState(() {
      routineDay = index;
    });
    debugPrint('[OK] routineDay set to: $routineDay');
  }

  Widget buildNoteCard(dynamic note){

    late int color;
    if (darkMode == false) {
      color = 0xFFFFFFFF;
    } else {
      color = 0xff1c1c1f;
    }

    Color secondColor = colorSecondText;
    Color iconColor = colorSpecialItem;
    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;

    return FocusedMenuHolder(
      onPressed: (){
        selectedNote = note;
        Navigator.pushNamed(context, '/notes/note_details');
      },
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.input_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Ver detalles', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            selectedNote = note;
            Navigator.pushNamed(context, '/notes/note_details');
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
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            selectedNote = note;
            Navigator.pushNamed(context, '/notes/edit_note');
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
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            showInfoSnackBar(context, 'En desarollo...');
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
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            showTextDialog(
                context,
                Icon(Icons.delete_outline_outlined),
                'Eliminar nota',
                'Una vez eliminada no podrás restaurarla.',
                'Eliminar',
                'Cancelar',
                    () async {
                  await cancelNoteNotification(note.id);
                  await deleteNoteById(note.id);
                  Navigator.pop(context);
                  showInfoSnackBar(context, 'Nota eliminada.');
                },
                    () {
                  Navigator.pop(context);
                }
            );
          },
        ),
      ],
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(color),
        child: Container(
          padding: EdgeInsets.all(deviceWidth*0.02),
          width: deviceWidth*0.35,
          height: deviceHeight*0.175,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.name != '') ExpandedRow(
                  Text(note.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorMainText,
                          fontSize: deviceWidth * fontSize * 0.04,
                          fontWeight: FontWeight.bold)
                  ),
                  Row(children: [
                    if(note.onCalendar) Icon(Icons.calendar_month_rounded, color: iconColor, size: deviceWidth*fontSize*0.04,),
                    if(note.routineNote) Icon(Icons.loop_rounded, color: iconColor, size: deviceWidth*fontSize*0.04,),
                  ],)
              ),
              if (note.name == '') ExpandedRow(
                  Text('Sin título',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorSecondText,
                          fontSize: deviceWidth * fontSize * 0.04,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic)
                  ),
                  Row(children: [
                    if(note.onCalendar) Icon(Icons.calendar_month_rounded, color: iconColor, size: deviceWidth*fontSize*0.04,),
                    if(note.routineNote) Icon(Icons.loop_rounded, color: iconColor, size: deviceWidth*fontSize*0.04,),
                  ],)
              ),
              SizedBox(height: deviceHeight*0.01,),
              if (note.content != '') Expanded(child: Text(note.content,
                  maxLines: 8,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: colorMainText,
                      fontSize: deviceWidth * fontSize * 0.03,
                      fontWeight: FontWeight.normal)
              ),),
              if (note.content == '') Expanded(child: Text('Sin contenido',
                  style: TextStyle(
                      color: colorSecondText,
                      fontSize: deviceWidth * fontSize * 0.03,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic)
              ),),
              Divider(color: secondColor,),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Icon(Icons.edit_note_rounded, color: iconColor, size: deviceWidth*fontSize*0.04,),
                  SizedBox(width: deviceWidth*0.01,),
                  Text('Editado: ' + dateToString(note.modificationDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorSecondText,
                          fontSize: deviceWidth * fontSize * 0.025,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic)
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
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
    if(event.color != -1) secondColor = colorMainText;

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
                Icon(Icons.input_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Ver detalles', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
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
                    fontSize: deviceWidth * fontSize * 0.04,
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
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            showInfoSnackBar(context, 'En desarollo...');
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
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            showTextDialog(
                context,
                Icon(Icons.delete_outline_outlined),
                'Eliminar evento',
                'Una vez eliminado no podrás restaurarlo.',
                'Eliminar',
                'Cancelar',
                    () async {
                  await cancelAllEventNotifications(event.id);
                  await deleteEventById(event.id);
                  Navigator.pop(context);
                  showInfoSnackBar(context, 'Evento eliminado.');
                },
                    () {
                  Navigator.pop(context);
                }
            );
          },
        ),
      ],
      child: Column(
        children: [
          SizedBox(height: deviceHeight*0.005,),
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
                    width: deviceWidth*0.175,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(DateFormat(dateFormat).format(eventDate), style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.055, fontWeight: FontWeight.bold)),
                        if (format24Hours==false) Text(DateFormat('aa').format(eventDate), style: TextStyle(color: secondColor, fontSize: deviceWidth * fontSize * 0.034, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  VerticalDivider(color: secondColor,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: deviceWidth*0.585,
                          alignment: Alignment.centerLeft,
                          child: Text(event.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.06, fontWeight: FontWeight.bold))),
                      if (event.description!='') SizedBox(height: deviceHeight*0.00375,),
                      if (event.description!='') Container(
                          width: deviceWidth*0.585,
                          alignment: Alignment.centerLeft,
                          child: Text(event.description,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: secondColor, fontSize: deviceWidth * fontSize * 0.03, fontWeight: FontWeight.normal))),
                    ],
                  ),
                  /*Icon(Icons.input_rounded, color: iconColor, size: deviceWidth * 0.06),*/
                  SizedBox(width: deviceWidth*0.01,),
                ],
              ),
            ),
          ),
          SizedBox(height: deviceHeight*0.005,),
        ],
      ),
    );
  }

}