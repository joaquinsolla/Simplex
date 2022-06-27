import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

class NotesMainPage extends StatefulWidget {
  const NotesMainPage({Key? key}) : super(key: key);

  @override
  _NotesMainPageState createState() => _NotesMainPageState();
}

class _NotesMainPageState extends State<NotesMainPage> {

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

}

