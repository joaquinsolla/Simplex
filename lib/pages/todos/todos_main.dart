import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:simplex/classes/todo.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';

class TodosMainPage extends StatefulWidget {
  const TodosMainPage({Key? key}) : super(key: key);

  @override
  _TodosMainPageState createState() => _TodosMainPageState();
}

class _TodosMainPageState extends State<TodosMainPage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  String dateToString(DateTime dateTime){
    String string = 'Fecha límite: ';
    late String dateFormat;

    if (formatDates==true) dateFormat = 'dd/MM/yyyy';
    else dateFormat = 'MM/dd/yyyy';

    string = string + DateFormat(dateFormat).format(dateTime);

    return string;
  }

  @override
  Widget build(BuildContext context) {
    return homeArea([
      homeHeaderTriple(
        'Tareas',
        IconButton(
          icon: Icon(Icons.help_outline_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            //TODO: help
            snackBar(context, '[Beta] En desarrollo', colorSpecialItem);
          },
        ),
        IconButton(
          icon: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(children: [
                  Icon(Icons.done_all_rounded,
                      color: colorSpecialItem, size: deviceWidth * 0.0405),
                  Icon(Icons.delete_outline_rounded,
                      color: Colors.transparent, size: deviceWidth * 0.0405),
                ],),
                Row(children: [
                  Icon(Icons.subdirectory_arrow_right_rounded,
                      color: colorSpecialItem, size: deviceWidth * 0.0405),
                  Icon(Icons.delete_outline_rounded,
                      color: colorSpecialItem, size: deviceWidth * 0.0405),
                ],),
              ],
            ),
          ),
          splashRadius: 0.001,
          onPressed: () {
            //TODO: remove done
            snackBar(context, '[Beta] En desarrollo', colorSpecialItem);
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

      StreamBuilder<List<Todo>>(
          stream: readPendingTodos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load pending todos: ' + snapshot.error.toString());
              return SizedBox.shrink();
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;
              late IconData showPendingTodosIcon;
              if (showPendingTodos) showPendingTodosIcon = Icons.keyboard_arrow_down_rounded;
              else showPendingTodosIcon = Icons.keyboard_arrow_right_rounded;
              return Row(children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(deviceWidth*0.01, deviceWidth*0.0025, deviceWidth*0.01, deviceWidth*0.005),
                  child: Text(todos.length.toString(),
                      style: TextStyle(
                          color: colorMainText,
                          fontSize: deviceWidth * 0.04,
                          fontWeight: FontWeight.bold)
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: 1.5,
                      color: colorSpecialItem,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(width: deviceWidth*0.015,),
                Text('Pendiente:',
                    style: TextStyle(
                        color: colorMainText,
                        fontSize: deviceWidth * 0.05,
                        fontWeight: FontWeight.bold)
                ),
                IconButton(
                  icon: Icon(showPendingTodosIcon, color: colorSpecialItem,),
                  onPressed: (){
                    setState(() {
                      showPendingTodos = !showPendingTodos;
                    });
                  },
                  splashRadius: 0.0001,
                ),
              ],);
            } else {
              late IconData showPendingTodosIcon;
              if (showPendingTodos) showPendingTodosIcon = Icons.keyboard_arrow_down_rounded;
              else showPendingTodosIcon = Icons.keyboard_arrow_right_rounded;
              return Row(children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(deviceWidth*0.01, deviceWidth*0.0025, deviceWidth*0.01, deviceWidth*0.005),
                  child: Text('0',
                      style: TextStyle(
                          color: colorMainText,
                          fontSize: deviceWidth * 0.04,
                          fontWeight: FontWeight.bold)
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: 1.5,
                      color: colorSpecialItem,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(width: deviceWidth*0.015,),
                Text('Pendiente:',
                    style: TextStyle(
                        color: colorMainText,
                        fontSize: deviceWidth * 0.05,
                        fontWeight: FontWeight.bold)
                ),
                IconButton(
                  icon: Icon(showPendingTodosIcon, color: colorSpecialItem,),
                  onPressed: (){
                    setState(() {
                      showPendingTodos = !showPendingTodos;
                    });
                  },
                  splashRadius: 0.0001,
                ),
              ],);
            }
          }),

      StreamBuilder<List<Todo>>(
          stream: readPendingTodosWithPriority(3),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load pending todos: ' + snapshot.error.toString());
              return Container(
                height: deviceHeight * 0.675,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_tethering_error_rounded, color: colorSecondText, size: deviceWidth*0.125,),
                    SizedBox(height: deviceHeight*0.025,),
                    Text(
                      'No se pueden cargar las tareas. Revisa tu conexión a Internet y reinicia la app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: deviceWidth * 0.0475, color: colorSecondText),),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;
              if (showPendingTodos) return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todos.length > 0) customDivider('Prioridad Alta'),
                  if (todos.length > 0) SizedBox(height: deviceHeight*0.01,),
                  if (showPendingTodos) Column(children: todos.map(buildPendingTodoBox).toList(),),
              ],
              );
              else return SizedBox.shrink();
            } else {
              return Container(
                height: deviceHeight*0.35,
                child: Center(child: CircularProgressIndicator(color: colorSpecialItem)),
              );
            }
          }),

      StreamBuilder<List<Todo>>(
          stream: readPendingTodosWithPriority(2),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load pending todos: ' + snapshot.error.toString());
              return SizedBox.shrink();
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;
              if (showPendingTodos) return Column(
                children: [
                  if (todos.length > 0) customDivider('Prioridad Media'),
                  if (todos.length > 0) SizedBox(height: deviceHeight*0.01,),
                  Column(children: todos.map(buildPendingTodoBox).toList()),
                ],
              );
              else return SizedBox.shrink();
            } else {
              return SizedBox.shrink();
            }
          }),

      StreamBuilder<List<Todo>>(
          stream: readPendingTodosWithPriority(1),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load pending todos: ' + snapshot.error.toString());
              return SizedBox.shrink();
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;
              if (showPendingTodos) return Column(
                children: [
                  if (todos.length > 0) customDivider('Prioridad Baja'),
                  if (todos.length > 0) SizedBox(height: deviceHeight*0.01,),
                  Column(children: todos.map(buildPendingTodoBox).toList()),
                ],
              );
              else return SizedBox.shrink();
            } else {
              return SizedBox.shrink();
            }
          }),

      StreamBuilder<List<Todo>>(
          stream: readDoneTodos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load done todos: ' + snapshot.error.toString());
              return SizedBox.shrink();
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;
              late IconData showDoneTodosIcon;
              if (showDoneTodos) showDoneTodosIcon = Icons.keyboard_arrow_down_rounded;
              else showDoneTodosIcon = Icons.keyboard_arrow_right_rounded;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: deviceHeight*0.02,),
                  Row(children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(deviceWidth*0.01, deviceWidth*0.0025, deviceWidth*0.01, deviceWidth*0.005),
                      child: Text(todos.length.toString(),
                          style: TextStyle(
                              color: colorMainText,
                              fontSize: deviceWidth * 0.04,
                              fontWeight: FontWeight.bold)
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          width: 1.5,
                          color: colorSpecialItem,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(width: deviceWidth*0.015,),
                    Text('Hecho:',
                        style: TextStyle(
                            color: colorMainText,
                            fontSize: deviceWidth * 0.05,
                            fontWeight: FontWeight.bold)
                    ),
                    IconButton(
                      icon: Icon(showDoneTodosIcon, color: colorSpecialItem,),
                      onPressed: (){
                        setState(() {
                          showDoneTodos = !showDoneTodos;
                        });
                      },
                      splashRadius: 0.0001,
                    ),
                  ],),
                  if (showDoneTodos) Column(children: todos.map(buildDoneTodoBox).toList(),),
                ],
              );
            } else {
              return Container(
                height: deviceHeight*0.35,
                child: Center(child: CircularProgressIndicator(color: colorSpecialItem)),
              );
            }
          }),

    ]);
  }

  Widget buildPendingTodoBox(Todo todo) {
    DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime limitDate = DateTime(todo.limitDate.year, todo.limitDate.month, todo.limitDate.day);

    Color focusedMenuItemBackgroundColor = colorThirdBackground;
    if (darkMode) focusedMenuItemBackgroundColor = colorSecondBackground;

    bool hasDescription = (todo.description != '');
    bool hasLimitDate = todo.limited;

    if(hasDescription) {
      if (hasLimitDate){
        // YES DESC - YES LIMIT
        return Row(
          children: [
            FocusedMenuHolder(
              onPressed: () {
                selectedTodo = todo;
                Navigator.pushNamed(context, '/todos/todo_details');
              },
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Ver detalles', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/todo_details');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Editar', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/edit_todo');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.delete_outline_rounded, color: Colors.red,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Eliminar', style: TextStyle(
                            color: Colors.red,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    cancelAllTodoNotifications(todo.id);
                    deleteTodoById(todo.id);
                    snackBar(context, 'Tarea eliminada', Colors.greenAccent);
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: deviceHeight*0.1175,
                    padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                        deviceWidth * 0.0185),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: colorSecondBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: deviceWidth * 0.65,
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorMainText,
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.bold))),

                        SizedBox(
                          height: deviceHeight * 0.00375,),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: deviceWidth * 0.65,
                            child: Text(todo.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorSecondText,
                                    fontSize: deviceWidth * 0.03,
                                    fontWeight: FontWeight.normal))),

                        Container(
                          width: deviceWidth * 0.65,
                          child: Divider(color: colorSecondText,),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (todayDate.isAtSameMomentAs(limitDate)) Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                                size: deviceWidth * 0.05),
                            if (todayDate.isAfter(limitDate)) Icon(
                                Icons.cancel_outlined, color: Colors.red,
                                size: deviceWidth * 0.05),
                            if (todayDate.isAtSameMomentAs(limitDate)
                            || todayDate.isAfter(limitDate)) SizedBox(
                              width: deviceWidth * 0.0125,),
                            if (todayDate.isAfter(limitDate)) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(limitDate),
                                    style: TextStyle(color: Colors.red,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal))),
                            if ((todayDate.isAfter(limitDate))==false) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(limitDate),
                                    style: TextStyle(color: colorMainText,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal))),
                          ],),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.0125,),
                ],
              ),
            ),
            Column(children: [
              IntrinsicHeight(child: Container(
                height: deviceHeight*0.1175,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    0.0, deviceWidth * 0.0185, deviceWidth * 0.0185,
                    deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: colorSecondBackground,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VerticalDivider(color: colorSecondText,),
                    SizedBox(
                      height: deviceHeight*0.1175,
                      width: deviceWidth * 0.12,
                      child: TextButton(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: colorSpecialItem,
                            ),
                          ),
                        ),
                        onPressed: () => toggleTodo(todo.id, true),
                      ),
                    ),
                  ],),
              ),),
              SizedBox(height: deviceHeight * 0.0125,),
            ],),
          ],
        );
      } else {
        // YES DESC - NO LIMIT
        return Row(
          children: [
            FocusedMenuHolder(
              onPressed: () {
                selectedTodo = todo;
                Navigator.pushNamed(context, '/todos/todo_details');
              },
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Ver detalles', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/todo_details');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Editar', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/edit_todo');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.delete_outline_rounded, color: Colors.red,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Eliminar', style: TextStyle(
                            color: Colors.red,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    cancelAllTodoNotifications(todo.id);
                    deleteTodoById(todo.id);
                    snackBar(context, 'Tarea eliminada', Colors.green);
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: deviceHeight*0.075,
                    padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                        deviceWidth * 0.0185),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: colorSecondBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: deviceWidth * 0.65,
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorMainText,
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.bold))),

                        SizedBox(
                          height: deviceHeight * 0.00375,),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: deviceWidth * 0.65,
                            child: Text(todo.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorSecondText,
                                    fontSize: deviceWidth * 0.03,
                                    fontWeight: FontWeight.normal))),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.0125,),
                ],
              ),
            ),
            Column(children: [
              IntrinsicHeight(child: Container(
                height: deviceHeight*0.075,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    0.0, deviceWidth * 0.0185, deviceWidth * 0.0185,
                    deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: colorSecondBackground,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VerticalDivider(color: colorSecondText,),
                    SizedBox(
                      height: deviceHeight * 0.075,
                      width: deviceWidth * 0.12,
                      child: TextButton(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: colorSpecialItem,
                            ),
                          ),
                        ),
                        onPressed: () => toggleTodo(todo.id, true),
                      ),
                    ),
                  ],),
              ),),
              SizedBox(height: deviceHeight * 0.0125,),
            ],),
          ],
        );
      }
    } else {
      if (hasLimitDate){
        // NO DESC - YES LIMIT
        return Row(
          children: [
            FocusedMenuHolder(
              onPressed: () {
                selectedTodo = todo;
                Navigator.pushNamed(context, '/todos/todo_details');
              },
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Ver detalles', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/todo_details');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Editar', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/edit_todo');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.delete_outline_rounded, color: Colors.red,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Eliminar', style: TextStyle(
                            color: Colors.red,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    cancelAllTodoNotifications(todo.id);
                    deleteTodoById(todo.id);
                    snackBar(context, 'Tarea eliminada', Colors.green);
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: deviceHeight*0.0975,
                    padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                        deviceWidth * 0.0185),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: colorSecondBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: deviceWidth * 0.65,
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorMainText,
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.bold))),
                        Container(
                          width: deviceWidth * 0.65,
                          child: Divider(color: colorSecondText,),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (todayDate.isAtSameMomentAs(limitDate)) Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                                size: deviceWidth * 0.05),
                            if (todayDate.isAfter(limitDate)) Icon(
                                Icons.cancel_outlined, color: Colors.red,
                                size: deviceWidth * 0.05),
                            if (todayDate.isAtSameMomentAs(limitDate)
                                || todayDate.isAfter(limitDate)) SizedBox(
                              width: deviceWidth * 0.0125,),
                            if (todayDate.isAfter(limitDate)) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(limitDate),
                                    style: TextStyle(color: Colors.red,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal))),
                            if ((todayDate.isAfter(limitDate))==false) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(limitDate),
                                    style: TextStyle(color: colorMainText,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal))),
                          ],),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.0125,),
                ],
              ),
            ),
            Column(children: [
              IntrinsicHeight(child: Container(
                height: deviceHeight*0.0975,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    0.0, deviceWidth * 0.01, deviceWidth * 0.0185,
                    deviceWidth * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: colorSecondBackground,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalDivider(color: colorSecondText,),
                    SizedBox(
                      height: deviceHeight * 0.0975,
                      width: deviceWidth * 0.12,
                      child: TextButton(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: colorSpecialItem,
                            ),
                          ),
                        ),
                        onPressed: () => toggleTodo(todo.id, true),
                      ),
                    )
                  ],),
              ),),
              SizedBox(height: deviceHeight * 0.0125,),
            ],),
          ],
        );
      } else {
        // NO DESC - NO LIMIT
        return Row(
          children: [
            FocusedMenuHolder(
              onPressed: () {
                selectedTodo = todo;
                Navigator.pushNamed(context, '/todos/todo_details');
              },
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Ver detalles', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/todo_details');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Editar', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/edit_todo');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: focusedMenuItemBackgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.delete_outline_rounded, color: Colors.red,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Eliminar', style: TextStyle(
                            color: Colors.red,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    cancelAllTodoNotifications(todo.id);
                    deleteTodoById(todo.id);
                    snackBar(context, 'Tarea eliminada', Colors.green);
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: deviceHeight*0.065,
                    padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                        deviceWidth * 0.0185),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: colorSecondBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: deviceWidth * 0.65,
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorMainText,
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.0125,),
                ],
              ),
            ),
            Column(children: [
              IntrinsicHeight(child: Container(
                height: deviceHeight*0.065,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    0.0, deviceWidth * 0.01, deviceWidth * 0.0185,
                    deviceWidth * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: colorSecondBackground,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalDivider(color: colorSecondText,),
                    SizedBox(
                      height: deviceHeight*0.065,
                      width: deviceWidth * 0.12,
                      child: TextButton(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: colorSpecialItem,
                            ),
                          ),
                        ),
                        onPressed: () => toggleTodo(todo.id, true),
                      ),
                    )
                  ],),
              ),),
              SizedBox(height: deviceHeight * 0.0125,),
            ],),
          ],
        );
      }
    }

  }

  Widget buildDoneTodoBox(Todo todo) {
    DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime todoDate = DateTime(todo.limitDate.year, todo.limitDate.month, todo.limitDate.day);

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;

    bool hasDescription = (todo.description != '');
    bool hasLimitDate = (todo.limitDate != DateTime(3000));

    if(hasDescription) {
      if (hasLimitDate){
        // YES DESC - YES LIMIT
        return Row(
          children: [
            FocusedMenuHolder(
              onPressed: () {
                selectedTodo = todo;
                Navigator.pushNamed(context, '/todos/todo_details');
              },
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Ver detalles', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/todo_details');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Editar', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/edit_todo');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.delete_outline_rounded, color: Colors.red,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Eliminar', style: TextStyle(
                            color: Colors.red,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    cancelAllTodoNotifications(todo.id);
                    deleteTodoById(todo.id);
                    snackBar(context, 'Tarea eliminada', Colors.green);
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: deviceHeight*0.1175,
                    padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                        deviceWidth * 0.0185),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: colorThirdBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: deviceWidth * 0.65,
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough))),

                        SizedBox(
                          height: deviceHeight * 0.00375,),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: deviceWidth * 0.65,
                            child: Text(todo.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * 0.03,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.lineThrough))),

                        Container(
                          width: deviceWidth * 0.65,
                          child: Divider(color: colorThirdText,),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (todayDate.isAtSameMomentAs(todoDate)) Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                                size: deviceWidth * 0.05),
                            if (todayDate.isAfter(todoDate)) Icon(
                                Icons.cancel_outlined, color: Colors.red,
                                size: deviceWidth * 0.05),
                            if (todayDate.isAtSameMomentAs(todoDate)
                                || todayDate.isAfter(todoDate)) SizedBox(
                              width: deviceWidth * 0.0125,),
                            if (todayDate.isAfter(todoDate)) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(todoDate),
                                    style: TextStyle(color: Colors.red,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal))),
                            if ((todayDate.isAfter(todoDate))==false) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(todoDate),
                                    style: TextStyle(color: colorThirdText,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal))),
                          ],),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.0125,),
                ],
              ),
            ),
            Column(children: [
              IntrinsicHeight(child: Container(
                height: deviceHeight*0.1175,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    0.0, deviceWidth * 0.0185, deviceWidth * 0.0185,
                    deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: colorThirdBackground,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VerticalDivider(color: colorThirdText,),
                    SizedBox(
                      height: deviceHeight*0.1175,
                      width: deviceWidth * 0.12,
                      child: TextButton(
                        child: Container(
                          child: Icon(Icons.check_rounded, size: deviceWidth*0.07, color: colorSpecialItem,),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: colorSpecialItem,
                            ),
                          ),
                        ),
                        onPressed: () => toggleTodo(todo.id, false),
                      ),
                    ),
                  ],),
              ),),
              SizedBox(height: deviceHeight * 0.0125,),
            ],),
          ],
        );
      } else {
        // YES DESC - NO LIMIT
        return Row(
          children: [
            FocusedMenuHolder(
              onPressed: () {
                selectedTodo = todo;
                Navigator.pushNamed(context, '/todos/todo_details');
              },
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Ver detalles', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/todo_details');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Editar', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/edit_todo');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.delete_outline_rounded, color: Colors.red,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Eliminar', style: TextStyle(
                            color: Colors.red,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    cancelAllTodoNotifications(todo.id);
                    deleteTodoById(todo.id);
                    snackBar(context, 'Tarea eliminada', Colors.green);
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: deviceHeight*0.075,
                    padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                        deviceWidth * 0.0185),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: colorThirdBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: deviceWidth * 0.65,
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough))),

                        SizedBox(
                          height: deviceHeight * 0.00375,),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: deviceWidth * 0.65,
                            child: Text(todo.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * 0.03,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.lineThrough))),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.0125,),
                ],
              ),
            ),
            Column(children: [
              IntrinsicHeight(child: Container(
                height: deviceHeight*0.075,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    0.0, deviceWidth * 0.0185, deviceWidth * 0.0185,
                    deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: colorThirdBackground,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VerticalDivider(color: colorThirdText,),
                    SizedBox(
                      height: deviceHeight * 0.075,
                      width: deviceWidth * 0.12,
                      child: TextButton(
                        child: Container(
                          child: Icon(Icons.check_rounded, size: deviceWidth*0.07, color: colorSpecialItem,),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: colorSpecialItem,
                            ),
                          ),
                        ),
                        onPressed: () => toggleTodo(todo.id, false),
                      ),
                    ),
                  ],),
              ),),
              SizedBox(height: deviceHeight * 0.0125,),
            ],),
          ],
        );
      }
    } else {
      if (hasLimitDate){
        // NO DESC - YES LIMIT
        return Row(
          children: [
            FocusedMenuHolder(
              onPressed: () {
                selectedTodo = todo;
                Navigator.pushNamed(context, '/todos/todo_details');
              },
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Ver detalles', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/todo_details');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Editar', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/edit_todo');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.delete_outline_rounded, color: Colors.red,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Eliminar', style: TextStyle(
                            color: Colors.red,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    cancelAllTodoNotifications(todo.id);
                    deleteTodoById(todo.id);
                    snackBar(context, 'Tarea eliminada', Colors.green);
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: deviceHeight*0.0975,
                    padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                        deviceWidth * 0.0185),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: colorThirdBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: deviceWidth * 0.65,
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough))),
                        Container(
                          width: deviceWidth * 0.65,
                          child: Divider(color: colorThirdText,),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (todayDate.isAtSameMomentAs(todoDate)) Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                                size: deviceWidth * 0.05),
                            if (todayDate.isAfter(todoDate)) Icon(
                                Icons.cancel_outlined, color: Colors.red,
                                size: deviceWidth * 0.05),
                            if (todayDate.isAtSameMomentAs(todoDate)
                                || todayDate.isAfter(todoDate)) SizedBox(
                              width: deviceWidth * 0.0125,),
                            if (todayDate.isAfter(todoDate)) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(todoDate),
                                    style: TextStyle(color: Colors.red,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal))),
                            if ((todayDate.isAfter(todoDate))==false) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(todoDate),
                                    style: TextStyle(color: colorThirdText,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal))),
                          ],),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.0125,),
                ],
              ),
            ),
            Column(children: [
              IntrinsicHeight(child: Container(
                height: deviceHeight*0.0975,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    0.0, deviceWidth * 0.01, deviceWidth * 0.0185,
                    deviceWidth * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: colorThirdBackground,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalDivider(color: colorThirdText,),
                    SizedBox(
                      height: deviceHeight * 0.0975,
                      width: deviceWidth * 0.12,
                      child: TextButton(
                        child: Container(
                          child: Icon(Icons.check_rounded, size: deviceWidth*0.07, color: colorSpecialItem,),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: colorSpecialItem,
                            ),
                          ),
                        ),
                        onPressed: () => toggleTodo(todo.id, false),
                      ),
                    )
                  ],),
              ),),
              SizedBox(height: deviceHeight * 0.0125,),
            ],),
          ],
        );
      } else {
        // NO DESC - NO LIMIT
        return Row(
          children: [
            FocusedMenuHolder(
              onPressed: () {
                selectedTodo = todo;
                Navigator.pushNamed(context, '/todos/todo_details');
              },
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Ver detalles', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/todo_details');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Editar', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    selectedTodo = todo;
                    Navigator.pushNamed(context, '/todos/edit_todo');
                  },
                ),
                FocusedMenuItem(
                  backgroundColor: backgroundColor,
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.delete_outline_rounded, color: Colors.red,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Eliminar', style: TextStyle(
                            color: Colors.red,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    cancelAllTodoNotifications(todo.id);
                    deleteTodoById(todo.id);
                    snackBar(context, 'Tarea eliminada', Colors.green);
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: deviceHeight*0.065,
                    padding: EdgeInsets.fromLTRB(
                        deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                        deviceWidth * 0.0185),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: colorThirdBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: deviceWidth * 0.65,
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough))),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.0125,),
                ],
              ),
            ),
            Column(children: [
              IntrinsicHeight(child: Container(
                height: deviceHeight*0.065,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    0.0, deviceWidth * 0.01, deviceWidth * 0.0185,
                    deviceWidth * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: colorThirdBackground,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalDivider(color: colorThirdText,),
                    SizedBox(
                      height: deviceHeight*0.065,
                      width: deviceWidth * 0.12,
                      child: TextButton(
                        child: Container(
                          child: Icon(Icons.check_rounded, size: deviceWidth*0.07, color: colorSpecialItem,),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: colorSpecialItem,
                            ),
                          ),
                        ),
                        onPressed: () => toggleTodo(todo.id, false),
                      ),
                    )
                  ],),
              ),),
              SizedBox(height: deviceHeight * 0.0125,),
            ],),
          ],
        );
      }
    }

  }

}