import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HelpButtons extends StatefulWidget {
  const HelpButtons({Key? key}) : super(key: key);

  @override
  _HelpButtonsState createState() => _HelpButtonsState();
}

class _HelpButtonsState extends State<HelpButtons> {

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

    late String calendarButtonImage;
    if (darkMode) calendarButtonImage = 'assets/calendar_button_dark.png';
    else calendarButtonImage = 'assets/calendar_button_light.png';

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, AppLocalizations.of(context)!.buttons),
          FooterCredits(),
          [
        Text(AppLocalizations.of(context)!.commonButtons, style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * fontSize * 0.05,
            fontWeight: FontWeight.bold)),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.add_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              AppLocalizations.of(context)!.create,
              AppLocalizations.of(context)!.createExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.search_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              AppLocalizations.of(context)!.search,
              AppLocalizations.of(context)!.searchExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.input_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              AppLocalizations.of(context)!.seeDetails,
              AppLocalizations.of(context)!.seeDetailsExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.edit, color: colorSpecialItem, size: deviceWidth * 0.075),
              AppLocalizations.of(context)!.edit,
              AppLocalizations.of(context)!.editExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.share_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              AppLocalizations.of(context)!.share,
              AppLocalizations.of(context)!.shareExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.delete_outline_rounded, color: Colors.red, size: deviceWidth * 0.075),
              AppLocalizations.of(context)!.delete,
              AppLocalizations.of(context)!.deleteExplanation),
        ],),
        SizedBox(height: deviceHeight * 0.03),

        Text(AppLocalizations.of(context)!.calendarButtons, style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * fontSize * 0.05,
            fontWeight: FontWeight.bold)),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(Image.asset(calendarButtonImage),
              AppLocalizations.of(context)!.toggleCalendarView,
              AppLocalizations.of(context)!.toggleCalendarViewExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.keyboard_arrow_left_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
                Icon(Icons.keyboard_arrow_right_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              ],),
              AppLocalizations.of(context)!.datesNavigation,
              AppLocalizations.of(context)!.datesNavigationExplanation),
        ],),
        SizedBox(height: deviceHeight * 0.03),

        Text(AppLocalizations.of(context)!.toDoButtons, style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * fontSize * 0.05,
            fontWeight: FontWeight.bold)),
        Column(children: [
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.keyboard_arrow_up_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
                Icon(Icons.keyboard_arrow_down_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              ],),
              AppLocalizations.of(context)!.toDoVisibility,
              AppLocalizations.of(context)!.toDoVisibilityExplanation),
          SizedBox(height: deviceHeight * 0.0125),
          ButtonExplanationContainer(
              Icon(Icons.clear_all_rounded, color: colorSpecialItem, size: deviceWidth * 0.075),
              AppLocalizations.of(context)!.deleteDoneToDos,
              AppLocalizations.of(context)!.deleteDoneToDosExplanation),
        ],),
      ]
      ),
    );
  }

}

