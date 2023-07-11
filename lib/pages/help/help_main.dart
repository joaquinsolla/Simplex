import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HelpMainPage extends StatefulWidget {
  const HelpMainPage({Key? key}) : super(key: key);

  @override
  _HelpMainPageState createState() => _HelpMainPageState();
}

class _HelpMainPageState extends State<HelpMainPage> {

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
          PageHeader(context, AppLocalizations.of(context)!.help),
          FooterCredits(),
          [

        Text(AppLocalizations.of(context)!.appUsage,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        FormContainer([
          SecondaryButton(colorMainText, AppLocalizations.of(context)!.buttons, (){
            Navigator.pushNamed(context, '/help/help_buttons');
          }),
          Divider(color: colorThirdText),
          SecondaryButton(colorMainText, AppLocalizations.of(context)!.calendar, (){
            Navigator.pushNamed(context, '/help/help_events');
          }),
          Divider(color: colorThirdText),
          SecondaryButton(colorMainText, AppLocalizations.of(context)!.todos, (){
            Navigator.pushNamed(context, '/help/help_todos');
          }),
          Divider(color: colorThirdText),
          SecondaryButton(colorMainText, AppLocalizations.of(context)!.notes, (){
            Navigator.pushNamed(context, '/help/help_notes');
          }),
          Divider(color: colorThirdText),
          SecondaryButton(colorMainText, AppLocalizations.of(context)!.routine, (){
            Navigator.pushNamed(context, '/help/help_routines');
          }),

        ]),

        SizedBox(height: deviceHeight * 0.03),
        Text(AppLocalizations.of(context)!.others,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.05,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: deviceHeight * 0.0125,
        ),
        FormContainer([
          SecondaryButton(colorMainText, AppLocalizations.of(context)!.privacyPolicy, (){
            tryLaunchUrl(privacyPolicyUrl);
          }),
          Divider(color: colorThirdText),
          SecondaryButton(Colors.red, AppLocalizations.of(context)!.reportAProblem, (){
            Navigator.pushNamed(context, '/help/help_report');
          }),
        ]),

      ]
      ),
    );
  }

}

