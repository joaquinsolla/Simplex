import 'package:flutter/material.dart';
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
            //Navigator.pushNamed(context, '/todos/add_todo');
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


              return Text('aaa');
            } else {
              return Container(
                height: deviceHeight*0.35,
                child: Center(child: CircularProgressIndicator(color: colorSpecialItem)),
              );
            }
          }),

      StreamBuilder<List<Todo>>(
          stream: readPendingTodos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load done todos: ' + snapshot.error.toString());
              return SizedBox.shrink();
            } else if (snapshot.hasData) {
              final todos = snapshot.data!;


              return Text('aaa');
            } else {
              return Container(
                height: deviceHeight*0.35,
                child: Center(child: CircularProgressIndicator(color: colorSpecialItem)),
              );
            }
          }),

    ]);
  }

}