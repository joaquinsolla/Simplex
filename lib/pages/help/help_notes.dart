import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HelpNotes extends StatefulWidget {
  const HelpNotes({Key? key}) : super(key: key);

  @override
  _HelpNotesState createState() => _HelpNotesState();
}

class _HelpNotesState extends State<HelpNotes> {

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
          PageHeader(context, AppLocalizations.of(context)!.notes),
          FooterCredits(),
          [
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.theNotes,
              AppLocalizations.of(context)!.theNotesExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.notesOnTheCalendar,
              AppLocalizations.of(context)!.notesOnTheCalendarExplanation),
        ],),
      ]
      ),
    );
  }

}

