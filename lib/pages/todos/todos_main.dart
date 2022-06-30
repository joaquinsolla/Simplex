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
      homeHeaderSimple(
        'Tareas',
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
              late IconData showPendingTodosIcon;
              if (showPendingTodos) showPendingTodosIcon = Icons.keyboard_arrow_down_rounded;
              else showPendingTodosIcon = Icons.keyboard_arrow_right_rounded;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('Pendiente (' + todos.length.toString() + '):',
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
                  ],),
                  if (showPendingTodos) Column(children: todos.map(buildPendingTodoBox).toList(),),
              ],
              );
            } else {
              return Container(
                height: deviceHeight*0.35,
                child: Center(child: CircularProgressIndicator(color: colorSpecialItem)),
              );
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
                    Text('Hecho (' + todos.length.toString() + '):',
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
    late int color;
    late Color alertColor;
    if (todo.color == -1 && darkMode == false) {
      color = 0xFFFFFFFF;
      alertColor = Colors.red;
    } else if (todo.color == -1 && darkMode == true) {
      color = 0xff1c1c1f;
      alertColor = Colors.red;
    } else {
      color = todo.color;
      alertColor = colorMainText;
    }

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;
    Color secondColor = colorSecondText;
    Color iconColor = colorSpecialItem;
    if (todo.color != -1) {
      secondColor = colorMainText;
      iconColor = colorMainText;
    }
    bool hasDescription = (todo.description != '');

    return Row(
      children: [
        if (hasDescription==false) FocusedMenuHolder(
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
                // TODO: revisar
                // cancelAllNotifications(todo.id);
                // deleteTodoById(todo.id);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tarea eliminada"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: deviceHeight*0.1),
                padding: EdgeInsets.fromLTRB(
                    deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                    deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  color: Color(color),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: deviceWidth * 0.6,
                        alignment: Alignment.centerLeft,
                        child: Text(todo.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorMainText,
                                fontSize: deviceWidth * 0.06,
                                fontWeight: FontWeight.bold))),
                    Container(
                      width: deviceWidth * 0.6,
                      child: Divider(color: secondColor,),
                    ),
                    if (todo.limitDate != DateTime(3000)) Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if ((DateTime.now()
                            .add(Duration(days: 1))
                            .isAfter(
                            todo.limitDate)) &&
                            DateTime.now().isBefore(
                                todo.limitDate)) Icon(
                            Icons
                                .error_outline_rounded,
                            color: alertColor,
                            size: deviceWidth * 0.05),
                        if (DateTime.now().isAfter(
                            todo.limitDate)) Icon(
                            Icons
                                .cancel_outlined, color: alertColor,
                            size: deviceWidth * 0.05),
                        if ((DateTime.now()
                            .add(Duration(days: 1))
                            .isAfter(todo
                            .limitDate))) SizedBox(
                          width: deviceWidth * 0.0125,),
                        if (DateTime.now()
                            .add(Duration(days: 1))
                            .isBefore(todo
                            .limitDate)) Container(
                            alignment: Alignment.centerLeft,
                            child: Text(dateToString(todo.limitDate),
                                style: TextStyle(color: colorMainText,
                                    fontSize: deviceWidth * 0.03,
                                    fontWeight: FontWeight.normal))),
                        if (DateTime.now()
                            .add(Duration(days: 1))
                            .isAfter(
                            todo
                                .limitDate)) Container(
                            alignment: Alignment.centerLeft,
                            child: Text(dateToString(todo.limitDate),
                                style: TextStyle(color: alertColor,
                                    fontSize: deviceWidth * 0.03,
                                    fontWeight: FontWeight.normal))),
                      ],),
                    if (todo.limitDate == DateTime(3000)) Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Sin fecha límite',
                            style: TextStyle(color: secondColor,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic))),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight * 0.0125,),
            ],
          ),
        ),
        if (hasDescription==false) Column(children: [
          IntrinsicHeight(child: Container(
            constraints: BoxConstraints(minHeight: deviceHeight*0.1),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(
                0.0, deviceWidth * 0.0185, deviceWidth * 0.0185,
                deviceWidth * 0.0185),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
              color: Color(color),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VerticalDivider(color: secondColor,),
                TextButton(
                  child: Container(
                    width: deviceWidth * 0.115,
                    height: deviceWidth * 0.115,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        width: 2,
                        color: iconColor,
                      ),
                    ),
                  ),
                  onPressed: () => toggleTodo(todo.id, true),
                ),
              ],),
          ),),
          SizedBox(height: deviceHeight * 0.0125,),
        ],),

        if (hasDescription==true) FocusedMenuHolder(
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
                // TODO: revisar
                // cancelAllNotifications(todo.id);
                // deleteTodoById(todo.id);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tarea eliminada"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: deviceHeight*0.1165),
                padding: EdgeInsets.fromLTRB(
                    deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                    deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  color: Color(color),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: deviceWidth * 0.6,
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
                        width: deviceWidth * 0.6,
                        child: Text(todo.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: secondColor,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.normal))),

                    Container(
                      width: deviceWidth * 0.6,
                      child: Divider(color: secondColor,),
                    ),
                    if (todo.limitDate != DateTime(3000)) Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if ((DateTime.now()
                            .add(Duration(days: 1))
                            .isAfter(
                            todo.limitDate)) &&
                            DateTime.now().isBefore(
                                todo.limitDate)) Icon(
                            Icons
                                .error_outline_rounded,
                            color: alertColor,
                            size: deviceWidth * 0.05),
                        if (DateTime.now().isAfter(
                            todo.limitDate)) Icon(
                            Icons
                                .cancel_outlined, color: alertColor,
                            size: deviceWidth * 0.05),
                        if ((DateTime.now()
                            .add(Duration(days: 1))
                            .isAfter(todo
                            .limitDate))) SizedBox(
                          width: deviceWidth * 0.0125,),
                        if (DateTime.now()
                            .add(Duration(days: 1))
                            .isBefore(todo
                            .limitDate)) Container(
                            alignment: Alignment.centerLeft,
                            child: Text(dateToString(todo.limitDate),
                                style: TextStyle(color: colorMainText,
                                    fontSize: deviceWidth * 0.03,
                                    fontWeight: FontWeight.normal))),
                        if (DateTime.now()
                            .add(Duration(days: 1))
                            .isAfter(
                            todo
                                .limitDate)) Container(
                            alignment: Alignment.centerLeft,
                            child: Text(dateToString(todo.limitDate),
                                style: TextStyle(color: alertColor,
                                    fontSize: deviceWidth * 0.03,
                                    fontWeight: FontWeight.normal))),
                      ],),
                    if (todo.limitDate == DateTime(3000)) Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Sin fecha límite',
                            style: TextStyle(color: secondColor,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic))),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight * 0.0125,),
            ],
          ),
        ),
        if (hasDescription==true) Column(children: [
          IntrinsicHeight(child: Container(
            constraints: BoxConstraints(minHeight: deviceHeight*0.1165),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(
                0.0, deviceWidth * 0.0185, deviceWidth * 0.0185,
                deviceWidth * 0.0185),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
              color: Color(color),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VerticalDivider(color: secondColor,),
                TextButton(
                  child: Container(
                    width: deviceWidth * 0.115,
                    height: deviceWidth * 0.115,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        width: 2,
                        color: iconColor,
                      ),
                    ),
                  ),
                  onPressed: () => toggleTodo(todo.id, true),
                ),
              ],),
          ),),
          SizedBox(height: deviceHeight * 0.0125,),
        ],),
      ],
    );
  }

  Widget buildDoneTodoBox(Todo todo) {
    late int color;
    if (todo.color == -1 && darkMode == false) {
      color = 0xFFFFFFFF;
    } else if (todo.color == -1 && darkMode == true) {
      color = 0xff1c1c1f;
    } else {
      color = todo.color;
    }

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;
    Color secondColor = colorSecondText;
    Color iconColor = colorSpecialItem;
    if (todo.color != -1) {
      secondColor = colorMainText;
      iconColor = colorMainText;
    }
    bool hasDescription = (todo.description != '');

    return Row(
      children: [
        if (hasDescription==false) FocusedMenuHolder(
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
                // TODO: revisar
                // cancelAllNotifications(todo.id);
                // deleteTodoById(todo.id);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tarea eliminada"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: deviceHeight*0.1),
                padding: EdgeInsets.fromLTRB(
                    deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                    deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  color: Color(color),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: deviceWidth * 0.6,
                        alignment: Alignment.centerLeft,
                        child: Text(todo.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorMainText,
                                fontSize: deviceWidth * 0.06,
                                fontWeight: FontWeight.bold))),
                    Container(
                      width: deviceWidth * 0.6,
                      child: Divider(color: secondColor,),
                    ),
                    if (todo.limitDate != DateTime(3000))Container(
                        alignment: Alignment.centerLeft,
                        child: Text(dateToString(todo.limitDate),
                            style: TextStyle(color: colorMainText,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.normal))),
                    if (todo.limitDate == DateTime(3000)) Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Sin fecha límite',
                            style: TextStyle(color: secondColor,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic))),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight * 0.0125,),
            ],
          ),
        ),
        if (hasDescription==false) Column(children: [
          IntrinsicHeight(child: Container(
            constraints: BoxConstraints(minHeight: deviceHeight*0.1),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(
                0.0, deviceWidth * 0.0185, deviceWidth * 0.0185,
                deviceWidth * 0.0185),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
              color: Color(color),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VerticalDivider(color: secondColor,),
                TextButton(
                  child: Container(
                    child: Icon(Icons.check_rounded, color: iconColor, size: deviceWidth*0.09,),
                    width: deviceWidth * 0.115,
                    height: deviceWidth * 0.115,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        width: 2,
                        color: iconColor,
                      ),
                    ),
                  ),
                  onPressed: () => toggleTodo(todo.id, false),
                ),
              ],),
          ),),
          SizedBox(height: deviceHeight * 0.0125,),
        ],),

        if (hasDescription==true) FocusedMenuHolder(
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
                // TODO: revisar
                // cancelAllNotifications(todo.id);
                // deleteTodoById(todo.id);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tarea eliminada"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: deviceHeight*0.1165),
                padding: EdgeInsets.fromLTRB(
                    deviceWidth * 0.0185, deviceWidth * 0.0185, 0.0,
                    deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  color: Color(color),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: deviceWidth * 0.6,
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
                        width: deviceWidth * 0.6,
                        child: Text(todo.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: secondColor,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.normal))),

                    Container(
                      width: deviceWidth * 0.6,
                      child: Divider(color: secondColor,),
                    ),
                    if (todo.limitDate != DateTime(3000)) Container(
                        alignment: Alignment.centerLeft,
                        child: Text(dateToString(todo.limitDate),
                            style: TextStyle(color: colorMainText,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.normal))),
                    if (todo.limitDate == DateTime(3000)) Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Sin fecha límite',
                            style: TextStyle(color: secondColor,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic))),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight * 0.0125,),
            ],
          ),
        ),
        if (hasDescription==true) Column(children: [
          IntrinsicHeight(child: Container(
            constraints: BoxConstraints(minHeight: deviceHeight*0.1165),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(
                0.0, deviceWidth * 0.0185, deviceWidth * 0.0185,
                deviceWidth * 0.0185),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
              color: Color(color),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VerticalDivider(color: secondColor,),
                TextButton(
                  child: Container(
                    child: Icon(Icons.check_rounded, color: iconColor, size: deviceWidth*0.09,),
                    width: deviceWidth * 0.115,
                    height: deviceWidth * 0.115,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        width: 2,
                        color: iconColor,
                      ),
                    ),
                  ),
                  onPressed: () => toggleTodo(todo.id, false),
                ),
              ],),
          ),),
          SizedBox(height: deviceHeight * 0.0125,),
        ],),
      ],
    );
  }

}