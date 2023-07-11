import 'package:flutter/material.dart';
import 'package:simplex/classes/report.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HelpReport extends StatefulWidget {
  const HelpReport({Key? key}) : super(key: key);

  @override
  _HelpReportState createState() => _HelpReportState();
}

class _HelpReportState extends State<HelpReport> {
  final TextEditingController problemController = TextEditingController();
  final FocusNode problemFocusNode = FocusNode();

  String id = int.parse((DateTime.now().millisecondsSinceEpoch).toString().substring(6)).toString();
  bool sendAccountData = true;

  @override
  void dispose() {
    super.dispose();
    problemController.dispose();
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
          PageHeader(context, AppLocalizations.of(context)!.reportAProblem),
          FooterCredits(),
          [
        FormContainer([
          FormTextField(problemController, AppLocalizations.of(context)!.problem, AppLocalizations.of(context)!.describeProblem, problemFocusNode, true),

        ]),
        FormSeparator(),
        FormContainer([
          Text(
            AppLocalizations.of(context)!.accountData,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.045,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          Theme(
            data: ThemeData(unselectedWidgetColor: colorMainText),
            child: CheckboxListTile(
              activeColor: colorSpecialItem,
              title: Text(
                AppLocalizations.of(context)!.sendAccountData,
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              value: sendAccountData,
              onChanged: (val) {
                setState(() {
                  sendAccountData = val!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ]),
        FormSeparator(),
        MainButton(Icons.report_gmailerrorred_rounded, Colors.red, ' ' + AppLocalizations.of(context)!.reportProblem + ' ',
                () {
                  if (problemController.text.trim().isEmpty) {
                    showErrorSnackBar(context, AppLocalizations.of(context)!.errorDescribeProblem);
                    problemFocusNode.requestFocus();
                  } else {
                    try {
                      Report newReport = Report(
                        id: id,
                        problem: problemController.text.trim(),
                        date: DateTime.now(),
                        userId: null,
                        userEmail: null,
                        active: true,
                      );

                      sendReport(newReport, sendAccountData);
                      Navigator.pop(context);
                      showInfoSnackBar(context, AppLocalizations.of(context)!.reportSent);

                    } on Exception catch (e) {
                      debugPrint('[ERR] Could not send report: $e');
                      showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
                    }
                  }
            }),
        FormSeparator(),
        Text(AppLocalizations.of(context)!.reportExplanation,
          style: TextStyle(color: colorSecondText,
              fontSize: deviceWidth * fontSize * 0.0375,
              fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
      ]
      ),
    );
  }

}
