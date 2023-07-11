import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HelpEvents extends StatefulWidget {
  const HelpEvents({Key? key}) : super(key: key);

  @override
  _HelpEventsState createState() => _HelpEventsState();
}

class _HelpEventsState extends State<HelpEvents> {

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
          PageHeader(context, AppLocalizations.of(context)!.calendar),
          FooterCredits(),
          [
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.theEvents,
              AppLocalizations.of(context)!.theEventsExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.eventsCreation,
              AppLocalizations.of(context)!.eventsCreationExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.eventsNotifications,
              AppLocalizations.of(context)!.eventsNotificationsExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          TextExplanationContainer(AppLocalizations.of(context)!.otherElementsCalendar,
              AppLocalizations.of(context)!.otherElementsCalendarExplanation),
        ],),
      ]
      ),
    );
  }

}

