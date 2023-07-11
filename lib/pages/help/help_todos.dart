import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HelpTodos extends StatefulWidget {
  const HelpTodos({Key? key}) : super(key: key);

  @override
  _HelpTodosState createState() => _HelpTodosState();
}

class _HelpTodosState extends State<HelpTodos> {

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
      body: HomeArea(null,
          PageHeader(context, AppLocalizations.of(context)!.toDo),
          FooterCredits(),
          [
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.theToDos,
              AppLocalizations.of(context)!.theToDosExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.limitedToDos,
              AppLocalizations.of(context)!.limitedToDosExplanation),
        ],),
      ]
      ),
    );
  }

}

