import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HelpRoutines extends StatefulWidget {
  const HelpRoutines({Key? key}) : super(key: key);

  @override
  _HelpRoutinesState createState() => _HelpRoutinesState();
}

class _HelpRoutinesState extends State<HelpRoutines> {

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
          PageHeader(context, AppLocalizations.of(context)!.routine),
          FooterCredits(),
          [
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.theRoutines,
              AppLocalizations.of(context)!.theRoutinesExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.routinesElements,
              AppLocalizations.of(context)!.routinesElementsExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.routinesDisplay,
              AppLocalizations.of(context)!.routinesDisplayExplanation),
        ],),
      ]
      ),
    );
  }

}

