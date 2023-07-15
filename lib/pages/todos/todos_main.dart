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

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
  bool showSearchbar = false;

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
    String string = AppLocalizations.of(context)!.dueDate + ':';
    late String dateFormat;

    if (formatDates==true) dateFormat = 'dd/MM/yyyy';
    else dateFormat = 'MM/dd/yyyy';

    string = string + DateFormat(dateFormat).format(dateTime);

    return string;
  }

  @override
  Widget build(BuildContext context) {
    IconData searcherIcon = Icons.search_rounded;
    if (showSearchbar==true) searcherIcon = Icons.search_off_rounded;

    return HomeAreaWithSearchbar(_scrollController, showSearchbar,
      HomeHeader(AppLocalizations.of(context)!.todos, [
        IconButton(
        icon: Icon(Icons.clear_all_rounded,
            color: colorSpecialItem, size: deviceWidth*fontSize*0.085),
        splashRadius: 0.001,
        onPressed: () => _showDeleteAllDoneDialog(),
      ),
      IconButton(
        icon: Icon(searcherIcon,
            color: colorSpecialItem, size: deviceWidth*fontSize*0.085),
        splashRadius: 0.001,
        onPressed: () {
          setState(() {
            showSearchbar=!showSearchbar;
            keywordsController.clear();
            keywords='';
            if (showSearchbar) keywordsFocusNode.requestFocus();
          });
        },
      ),
      IconButton(
        icon: Icon(Icons.add_rounded,
            color: colorSpecialItem, size: deviceWidth*fontSize*0.085),
        splashRadius: 0.001,
        onPressed: () {
          Navigator.pushNamed(context, '/todos/add_todo');
        },
      ),
      ]),
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: deviceWidth*0.65,
            child: TextField(
              focusNode: keywordsFocusNode,
              controller: keywordsController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.search,
              maxLines: 1,
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

                hintText: AppLocalizations.of(context)!.searchToDos,
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
                    AppLocalizations.of(context)!.search,
                    style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.035,
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
      FooterEmpty(),
        [
          StreamBuilder<List<List<Todo>>>(
              stream: CombineLatestStream.list([
                readDoneTodosByName(keywords.trim()),
                readPendingTodosByPriorityAndName(1, keywords.trim()),
                readPendingTodosByPriorityAndName(2, keywords.trim()),
                readPendingTodosByPriorityAndName(3, keywords.trim()),
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('[ERR] Cannot load todos: ' + snapshot.error.toString());
                  return ErrorContainer(AppLocalizations.of(context)!.errorCannotLoadToDos, 0.75);
                }
                else if (snapshot.hasData) {

                  final doneTodos = snapshot.data![0];
                  final pendingTodosPriority1 = snapshot.data![1];
                  final pendingTodosPriority2 = snapshot.data![2];
                  final pendingTodosPriority3 = snapshot.data![3];

                  int pendingTodosLength = pendingTodosPriority1.length +
                      pendingTodosPriority2.length +
                      pendingTodosPriority3.length;

                  return Column(
                    children: [
                      VisibilityButton(
                        AppLocalizations.of(context)!.pending + ': ' + pendingTodosLength.toString(),
                          showPendingTodos,
                              (){
                            setState(() {
                              showPendingTodos = !showPendingTodos;
                            });
                          }
                      ),

                      if (pendingTodosLength == 0 && showPendingTodos && keywords=='') NoItemsContainer(AppLocalizations.of(context)!.pendingToDosSmall, 0.2),
                      if (pendingTodosLength == 0 && showPendingTodos && keywords!='') NoResultsContainer(0.2),

                      if (pendingTodosPriority3.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                      if (pendingTodosPriority3.length > 0 && showPendingTodos) CustomDivider(AppLocalizations.of(context)!.highPriority),
                      if (pendingTodosPriority3.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                      if (showPendingTodos) Column(children: pendingTodosPriority3.map(buildPendingTodoBox).toList(),),

                      if (pendingTodosPriority2.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                      if (pendingTodosPriority2.length > 0 && showPendingTodos) CustomDivider(AppLocalizations.of(context)!.mediumPriority),
                      if (pendingTodosPriority2.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                      if (showPendingTodos) Column(children: pendingTodosPriority2.map(buildPendingTodoBox).toList(),),

                      if (pendingTodosPriority1.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                      if (pendingTodosPriority1.length > 0 && showPendingTodos) CustomDivider(AppLocalizations.of(context)!.lowPriority),
                      if (pendingTodosPriority1.length > 0 && showPendingTodos) SizedBox(height: deviceHeight*0.01,),
                      if (showPendingTodos) Column(children: pendingTodosPriority1.map(buildPendingTodoBox).toList(),),

                      SizedBox(height: deviceHeight*0.02,),

                      VisibilityButton(
                        AppLocalizations.of(context)!.completed + ': ' + doneTodos.length.toString(),
                          showDoneTodos,
                              () {
                            setState(() {
                              showDoneTodos = !showDoneTodos;
                            });
                          }
                      ),

                      if (doneTodos.length == 0 && showDoneTodos && keywords=='') NoItemsContainer(AppLocalizations.of(context)!.completedToDosSmall, 0.2),
                      if (doneTodos.length == 0 && showDoneTodos && keywords!='') NoResultsContainer(0.2),

                      if (doneTodos.length > 0 && showDoneTodos) Column(children: doneTodos.map(buildDoneTodoBox).toList(),),

                      if (pendingTodosLength != 0 || doneTodos.length != 0) SizedBox(height: deviceHeight*0.01,),
                      if (pendingTodosLength != 0 || doneTodos.length != 0) Container(
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
                }
                else return LoadingContainer(AppLocalizations.of(context)!.loadingToDos, 0.75);
              }),
        ],
    );
  }

  Widget buildPendingTodoBox(Todo todo) {
    DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime limitDate = DateTime(todo.limitDate.year, todo.limitDate.month, todo.limitDate.day);

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;

    bool hasDescription = (todo.description != '');
    bool hasLimitDate = todo.limited;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: deviceWidth*0.125,
          child: IconButton(
            splashRadius: 0.0001,
            icon: Icon(Icons.circle_outlined, color: colorSecondText,
                size: deviceWidth * 0.07),
            onPressed: () => toggleTodo(todo.id, todo.name, todo.limited, todo.limitDate, true),
          ),
        ),
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
                    Icon(Icons.input_rounded,
                        color: colorSpecialItem,
                        size: deviceWidth * 0.06),
                    SizedBox(width: deviceWidth * 0.025,),
                    Text(AppLocalizations.of(context)!.seeDetails, style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.04,
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
                    Icon(Icons.check_circle_outline_rounded,
                        color: colorSpecialItem,
                        size: deviceWidth * 0.06),
                    SizedBox(width: deviceWidth * 0.025,),
                    Text(AppLocalizations.of(context)!.markAsCompleted, style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.04,
                        fontWeight: FontWeight.normal),),
                  ],
                ),
              ),
              onPressed: () {
                toggleTodo(todo.id, todo.name, todo.limited, todo.limitDate, !todo.done);
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
                    Text(AppLocalizations.of(context)!.edit, style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.04,
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
                    Icon(Icons.share_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                    SizedBox(width: deviceWidth*0.025,),
                    Text(AppLocalizations.of(context)!.share, style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.04,
                        fontWeight: FontWeight.normal),),
                  ],
                ),
              ),
              onPressed: (){
                selectedTodo = todo;
                socialShare(selectedTodo);
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
                    Text(AppLocalizations.of(context)!.delete, style: TextStyle(
                        color: Colors.red,
                        fontSize: deviceWidth * fontSize * 0.04,
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
            children: [
              SizedBox(height: deviceHeight*0.005,),
              Container(
                width: deviceWidth * 0.7,
                padding: EdgeInsets.all(deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: colorSecondBackground,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpandedRow(
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorMainText,
                                    fontSize: deviceWidth * fontSize * 0.06,
                                    fontWeight: FontWeight.bold))),
                        Row(children: [
                          if(todo.limited) Icon(Icons.calendar_month_rounded,
                            color: colorSpecialItem, size: deviceWidth*fontSize*0.04,),
                        ],)
                    ),
                    if (hasDescription) SizedBox(
                        height: deviceHeight * 0.00375),
                    if (hasDescription) Container(
                        alignment: Alignment.centerLeft,
                        width: deviceWidth * 0.65,
                        child: Text(todo.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorSecondText,
                                fontSize: deviceWidth * fontSize * 0.03,
                                fontWeight: FontWeight.normal))),

                    if (hasLimitDate) Divider(color: colorSecondText),
                    if (hasLimitDate) Row(
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
                                    fontSize: deviceWidth * fontSize * 0.03,
                                    fontWeight: FontWeight.normal))),
                        if ((todayDate.isAfter(limitDate))==false) Container(
                            alignment: Alignment.centerLeft,
                            child: Text(dateToString(limitDate),
                                style: TextStyle(color: colorMainText,
                                    fontSize: deviceWidth * fontSize * 0.03,
                                    fontWeight: FontWeight.normal))),
                      ],),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight*0.005,),
            ],
          ),
        ),
      ],
    );

  }

  Widget buildDoneTodoBox(Todo todo) {
    DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime limitDate = DateTime(todo.limitDate.year, todo.limitDate.month, todo.limitDate.day);

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;

    bool hasDescription = (todo.description != '');
    bool hasLimitDate = (todo.limited);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: deviceWidth*0.125,
          alignment: Alignment.centerLeft,
          child: IconButton(
            splashRadius: 0.0001,
            icon: Icon(Icons.check_circle_outline_rounded, color: colorSecondText,
                size: deviceWidth * 0.07),
            onPressed: () => toggleTodo(todo.id, todo.name, todo.limited, todo.limitDate, false),
          ),
        ),
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
                    Icon(Icons.input_rounded,
                        color: colorSpecialItem,
                        size: deviceWidth * 0.06),
                    SizedBox(width: deviceWidth * 0.025,),
                    Text(AppLocalizations.of(context)!.seeDetails, style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.04,
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
                    Icon(Icons.circle_outlined,
                        color: colorSpecialItem,
                        size: deviceWidth * 0.06),
                    SizedBox(width: deviceWidth * 0.025,),
                    Text(AppLocalizations.of(context)!.markAsPending, style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.04,
                        fontWeight: FontWeight.normal),),
                  ],
                ),
              ),
              onPressed: () {
                toggleTodo(todo.id, todo.name, todo.limited, todo.limitDate, !todo.done);
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
                    Text(AppLocalizations.of(context)!.edit, style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.04,
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
                    Icon(Icons.share_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                    SizedBox(width: deviceWidth*0.025,),
                    Text(AppLocalizations.of(context)!.share, style: TextStyle(
                        color: colorSpecialItem,
                        fontSize: deviceWidth * fontSize * 0.04,
                        fontWeight: FontWeight.normal),),
                  ],
                ),
              ),
              onPressed: (){
                  selectedTodo = todo;
                  socialShare(selectedTodo);
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
                    Text(AppLocalizations.of(context)!.delete, style: TextStyle(
                        color: Colors.red,
                        fontSize: deviceWidth * fontSize * 0.04,
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
            children: [
              SizedBox(height: deviceHeight*0.005,),
              Container(
                width: deviceWidth * 0.7,
                padding: EdgeInsets.all(deviceWidth * 0.0185),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: colorThirdBackground,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpandedRow(
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(todo.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * fontSize * 0.06,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough))),
                        Row(children: [
                          if(todo.limited) Icon(Icons.calendar_month_rounded,
                            color: colorThirdText, size: deviceWidth*fontSize*0.04,),
                        ],)
                    ),
                    if (hasDescription) SizedBox(
                        height: deviceHeight * 0.00375),
                    if (hasDescription) Container(
                        alignment: Alignment.centerLeft,
                        width: deviceWidth * 0.65,
                        child: Text(todo.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorThirdText,
                                fontSize: deviceWidth * fontSize * 0.03,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.lineThrough))),

                    if (hasLimitDate) Divider(color: colorThirdText),
                    if (hasLimitDate) Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (todayDate.isAtSameMomentAs(limitDate)) Icon(
                            Icons.error_outline_rounded,
                            color: colorThirdText,
                            size: deviceWidth * 0.05),
                        if (todayDate.isAfter(limitDate)) Icon(
                            Icons.cancel_outlined, color: colorThirdText,
                            size: deviceWidth * 0.05),
                        if (todayDate.isAtSameMomentAs(limitDate)
                            || todayDate.isAfter(limitDate)) SizedBox(
                          width: deviceWidth * 0.0125,),
                        if (todayDate.isAfter(limitDate)) Container(
                            alignment: Alignment.centerLeft,
                            child: Text(dateToString(limitDate),
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * fontSize * 0.03,
                                    fontWeight: FontWeight.normal))),
                        if ((todayDate.isAfter(limitDate))==false) Container(
                            alignment: Alignment.centerLeft,
                            child: Text(dateToString(limitDate),
                                style: TextStyle(color: colorThirdText,
                                    fontSize: deviceWidth * fontSize * 0.03,
                                    fontWeight: FontWeight.normal))),
                      ],),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight*0.005,),
            ],
          ),
        ),
      ],
    );

  }
  
  void _showDeleteTodoDialog(int id){
    showTextDialog(
        context,
        Icons.delete_outline_outlined,
        AppLocalizations.of(context)!.deleteToDo,
        AppLocalizations.of(context)!.deleteToDoExplanation,
        AppLocalizations.of(context)!.delete,
        AppLocalizations.of(context)!.cancel,
            () async {
          await cancelAllTodoNotifications(id);
          await deleteTodoById(id);
          Navigator.pop(context);
          showInfoSnackBar(context, AppLocalizations.of(context)!.toDoDeleted);
        },
            () {
          Navigator.pop(context);
        }
    );
  }

  void _showDeleteAllDoneDialog() {
    showTextDialog(
        context,
        Icons.delete_outline_outlined,
        AppLocalizations.of(context)!.deleteDoneToDos,
        AppLocalizations.of(context)!.deleteDoneToDosExplanation,
        AppLocalizations.of(context)!.delete,
        AppLocalizations.of(context)!.cancel,
            () async {
          await deleteDoneTodos();
          Navigator.pop(context);
          showInfoSnackBar(context, AppLocalizations.of(context)!.deletedDoneToDos);
        },
            () {
          Navigator.pop(context);
        }
    );
  }

}