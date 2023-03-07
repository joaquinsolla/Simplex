import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

class RoutinesMainPage extends StatefulWidget {
  const RoutinesMainPage({Key? key}) : super(key: key);

  @override
  _RoutinesMainPageState createState() => _RoutinesMainPageState();
}

class _RoutinesMainPageState extends State<RoutinesMainPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setRoutineDay(weekDay);
  }

  @override
  Widget build(BuildContext context) {
    return HomeArea(_scrollController,
        HomeHeader('Rutina', [
            IconButton(
              icon: Icon(Icons.add_rounded,
                  color: colorSpecialItem, size: deviceWidth*fontSize*0.085),
              splashRadius: 0.001,
              onPressed: () {
                showInfoSnackBar(context, '[Beta] En desarrollo.');
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
          )
        ]
    );
  }

  void _setRoutineDay(int index){
    setState(() {
      routineDay = index;
    });
    debugPrint('[OK] routineDay set to: $routineDay');
  }

}