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
  }


  @override
  Widget build(BuildContext context) {
    return HomeArea(_scrollController,
        HomeHeader('Rutina', [
            IconButton(
              icon: Icon(Icons.add_rounded,
                  color: colorSpecialItem, size: deviceWidth * 0.085),
              splashRadius: 0.001,
              onPressed: () {
                showInfoSnackBar(context, '[Beta] En desarrollo');
              },
            ),
          ]),
        FooterEmpty(),
        []
    );
  }

}