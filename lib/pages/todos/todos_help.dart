import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

class TodosHelp extends StatefulWidget {
  const TodosHelp({Key? key}) : super(key: key);

  @override
  _TodosHelpState createState() => _TodosHelpState();
}

class _TodosHelpState extends State<TodosHelp> {

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
    return Scaffold(
        backgroundColor: colorMainBackground,
        body: homeArea([
          pageHeader(context, 'Acerca de las tareas'),
        ])
    );
  }
}

