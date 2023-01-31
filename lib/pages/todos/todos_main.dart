import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simplex/classes/todo.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

class TodosMainPage extends StatefulWidget {
  const TodosMainPage({Key? key}) : super(key: key);

  @override
  _TodosMainPageState createState() => _TodosMainPageState();
}

class _TodosMainPageState extends State<TodosMainPage> {
  final ScrollController _scrollController = ScrollController();
  FocusNode keywordsFocusNode = FocusNode();
  final keywordsController = TextEditingController();
  String keywords = '';
  bool showSearcher = false;

  @override
  void dispose() {
    super.dispose();
    keywordsController.dispose();
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
    IconData searcherIcon = Icons.search_rounded;
    if (showSearcher==true) searcherIcon = Icons.search_off_rounded;

    return Container(
        color: colorMainBackground,
        alignment: Alignment.topLeft,
        margin: EdgeInsets.fromLTRB(
            deviceWidth * 0.075, deviceHeight * 0.075, deviceWidth * 0.075, 0.0),
        child: ListView(
          addAutomaticKeepAlives: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            homeHeaderTriple(
              'Tareas',
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
                onPressed: () => _showDeleteAllDoneDialog(),
              ),
              IconButton(
                icon: Icon(searcherIcon,
                    color: colorSpecialItem, size: deviceWidth * 0.085),
                splashRadius: 0.001,
                onPressed: () {
                  setState(() {
                    showSearcher=!showSearcher;
                    keywordsController.clear();
                    keywords='';
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

            if (showSearcher) Wrap(
              alignment: WrapAlignment.center,
              children: [
                Container(
                  width: deviceWidth*0.65,
                  child: TextField(
                    focusNode: keywordsFocusNode,
                    controller: keywordsController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.search,
                    maxLines: null,
                    style: TextStyle(color: colorMainText),
                    decoration: InputDecoration(
                      fillColor: colorThirdBackground,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorThirdBackground, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: colorSpecialItem, width: 2),
                      ),

                      hintText: 'Buscar tareas...',
                      hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                    ),
                    onChanged: (text){
                      setState(() {
                        keywords=text;
                      });
                    },
                  ),
                ),
                SizedBox(width: deviceWidth*0.015,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorSecondBackground,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [ SizedBox(
                      //width: deviceWidth*0.1,
                      height: deviceHeight*0.07,
                      child: TextButton(
                        child: Text(
                          'Borrar',
                          style: TextStyle(
                              color: colorSpecialItem,
                              fontSize: deviceWidth * 0.035,
                              fontWeight: FontWeight.normal),
                        ),
                        onPressed: (){
                          setState(() {
                            keywords='';
                            keywordsController.clear();
                            keywordsFocusNode.unfocus();
                          });
                        },
                      ),
                    ),],
                  ),
                ),
              ],),
            if (showSearcher) SizedBox(height: deviceHeight*0.015,),

            Container(
                height: deviceHeight*0.725,
                child: StreamBuilder<List<List<Todo>>>(
                    stream: CombineLatestStream.list([
                      readDoneTodos(),
                      readPendingTodosWithPriority(1),
                      readPendingTodosWithPriority(2),
                      readPendingTodosWithPriority(3),
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        debugPrint('[ERR] Cannot load todos: ' + snapshot.error.toString());
                        return errorContainer('No se pueden cargar las tareas.', 0.75);
                      }
                      else if (snapshot.hasData) {

                        final doneTodos = snapshot.data![0];
                        final pendingTodosPriority1 = snapshot.data![1];
                        final pendingTodosPriority2 = snapshot.data![2];
                        final pendingTodosPriority3 = snapshot.data![3];

                        int pendingTodosLength = pendingTodosPriority1.length +
                            pendingTodosPriority2.length +
                            pendingTodosPriority3.length;

                        late IconData showPendingTodosIcon;
                        late IconData showDoneTodosIcon;

                        if (showPendingTodos) showPendingTodosIcon = Icons.visibility_outlined;
                        else showPendingTodosIcon = Icons.visibility_off_outlined;
                        if (showDoneTodos) showDoneTodosIcon = Icons.visibility_outlined;
                        else showDoneTodosIcon = Icons.visibility_off_outlined;

                        return ListView(
                          addAutomaticKeepAlives: true,
                          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                          controller: _scrollController,
                          children: [
                            TextButton(
                              child: Row(children: [
                                Container(
                                  padding: EdgeInsets.all(deviceWidth*0.0075),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorSpecialItem,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)
                                    ),
                                  ),
                                  child: Text('Pendiente: ' + pendingTodosLength.toString(),
                                      style: TextStyle(
                                          color: colorMainText,
                                          fontSize: deviceWidth * 0.05,
                                          fontWeight: FontWeight.bold)
                                  ),
                                ),
                                SizedBox(width: deviceWidth*0.02,),
                                Icon(showPendingTodosIcon, color: colorSpecialItem,),
                              ],),
                              onPressed: (){
                                setState(() {
                                  showPendingTodos = !showPendingTodos;
                                });
                              },
                            ),
                            if (pendingTodosLength > 0 && showPendingTodos) SizedBox(height: deviceHeight * 0.005),
                            if (pendingTodosLength == 0 && darkMode==true && showPendingTodos) Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Container(
                                width: deviceWidth * 0.85,
                                alignment: Alignment.center,
                                child: Image.asset('assets/todo_preview_dark.png',
                                  scale: deviceWidth * 0.0001,),
                              ),],
                            ),
                            if (pendingTodosLength == 0 && darkMode==false && showPendingTodos) Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Container(
                                width: deviceWidth * 0.85,
                                alignment: Alignment.center,
                                child: Image.asset('assets/todo_preview_light.png',
                                  scale: deviceWidth * 0.0001,),
                              ),],
                            ),

                            if (pendingTodosPriority3.length > 0 && showPendingTodos) customDivider('Prioridad Alta'),
                            if (pendingTodosPriority3.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                            if (showPendingTodos) Column(children: pendingTodosPriority3.map(buildPendingTodoBox).toList(),),

                            if (pendingTodosPriority2.length > 0 && showPendingTodos) customDivider('Prioridad Media'),
                            if (pendingTodosPriority2.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                            if (showPendingTodos) Column(children: pendingTodosPriority2.map(buildPendingTodoBox).toList(),),

                            if (pendingTodosPriority1.length > 0 && showPendingTodos) customDivider('Prioridad Baja'),
                            if (pendingTodosPriority1.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                            if (showPendingTodos) Column(children: pendingTodosPriority1.map(buildPendingTodoBox).toList(),),

                            SizedBox(height: deviceHeight*0.02,),
                            TextButton(
                              child: Row(children: [
                                Container(
                                  padding: EdgeInsets.all(deviceWidth*0.0075),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorSpecialItem,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)
                                    ),
                                  ),
                                  child: Text('Hecho: ' + doneTodos.length.toString(),
                                      style: TextStyle(
                                          color: colorMainText,
                                          fontSize: deviceWidth * 0.05,
                                          fontWeight: FontWeight.bold)
                                  ),
                                ),
                                SizedBox(width: deviceWidth*0.02,),
                                Icon(showDoneTodosIcon, color: colorSpecialItem,),
                              ],),
                              onPressed: (){
                                setState(() {
                                  showDoneTodos = !showDoneTodos;
                                });
                              },
                            ),
                            if (showDoneTodos) Column(children: doneTodos.map(buildDoneTodoBox).toList(),),
                            SizedBox(height: deviceHeight*0.01,),
                            Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(Icons.arrow_circle_up_rounded,
                                    color: colorSpecialItem, size: deviceWidth * 0.08),
                                splashRadius: 0.001,
                                onPressed: () async {
                                  await Future.delayed(const Duration(milliseconds: 100));
                                  SchedulerBinding.instance?.addPostFrameCallback((_) {
                                    _scrollController.animateTo(
                                        _scrollController.position.minScrollExtent,
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.fastOutSlowIn);
                                  });
                                },
                              ),),
                            SizedBox(height: deviceHeight*0.1,),
                          ],
                        );
                      }
                      else return loadingContainer('Cargando tus tareas...', 0.75);

                    }),),
          ]),
    );

  }

  Widget buildPendingTodoBox(Todo todo) {
    DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime limitDate = DateTime(todo.limitDate.year, todo.limitDate.month, todo.limitDate.day);

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;

    bool hasDescription = (todo.description != '');
    bool hasLimitDate = todo.limited;

    //TODO: optimize
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
                        Icon(Icons.done_all_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Marcar como hecho', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    toggleTodo(todo.id, !todo.done);
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
                    _showDeleteTodoDialog(todo.id);
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
                        Icon(Icons.done_all_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Marcar como hecho', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    toggleTodo(todo.id, !todo.done);
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
                     _showDeleteTodoDialog(todo.id);
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
                        Icon(Icons.done_all_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Marcar como hecho', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    toggleTodo(todo.id, !todo.done);
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
                     _showDeleteTodoDialog(todo.id);
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
                        Icon(Icons.done_all_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Marcar como hecho', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    toggleTodo(todo.id, !todo.done);
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
                     _showDeleteTodoDialog(todo.id);
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
    bool hasLimitDate = (todo.limited);

    //TODO: optimize
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
                        Icon(Icons.remove_done_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Marcar como pendiente', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    toggleTodo(todo.id, !todo.done);
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
                     _showDeleteTodoDialog(todo.id);
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
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.lineThrough))),
                            if ((todayDate.isAfter(todoDate))==false) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(todoDate),
                                    style: TextStyle(color: colorThirdText,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.lineThrough))),
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
                        Icon(Icons.remove_done_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Marcar como pendiente', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    toggleTodo(todo.id, !todo.done);
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
                     _showDeleteTodoDialog(todo.id);
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
                        Icon(Icons.remove_done_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Marcar como pendiente', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    toggleTodo(todo.id, !todo.done);
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
                     _showDeleteTodoDialog(todo.id);
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
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.lineThrough))),
                            if ((todayDate.isAfter(todoDate))==false) Container(
                                alignment: Alignment.centerLeft,
                                child: Text(dateToString(todoDate),
                                    style: TextStyle(color: colorThirdText,
                                        fontSize: deviceWidth * 0.03,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.lineThrough))),
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
                        Icon(Icons.remove_done_rounded,
                            color: colorSpecialItem,
                            size: deviceWidth * 0.06),
                        SizedBox(width: deviceWidth * 0.025,),
                        Text('Marcar como pendiente', style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                  onPressed: () {
                    toggleTodo(todo.id, !todo.done);
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
                     _showDeleteTodoDialog(todo.id);
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
  
  void _showDeleteTodoDialog(int id){
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Eliminar tarea'),
            content: Text('Una vez eliminada no podrás restaurarla.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    await cancelAllTodoNotifications(id);
                    await deleteTodoById(id);
                    Navigator.pop(context);
                    showSnackBar(context, 'Tarea eliminada', Colors.green);
                  },
                  child: Text('Eliminar', style: TextStyle(color: colorSpecialItem),)),
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

  void _showDeleteAllDoneDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Eliminar tareas hechas'),
            content: Text('Una vez eliminadas, no podrás restaurarlas.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    await deleteDoneTodos();
                    Navigator.pop(context);
                    showSnackBar(context, 'Tareas hechas eliminadas', Colors.green);
                  },
                  child: Text('Eliminar', style: TextStyle(color: colorSpecialItem),)),
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

}