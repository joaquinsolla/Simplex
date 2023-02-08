import 'package:flutter/material.dart';
import 'package:simplex/classes/report.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';

class HelpReport extends StatefulWidget {
  const HelpReport({Key? key}) : super(key: key);

  @override
  _HelpReportState createState() => _HelpReportState();
}

class _HelpReportState extends State<HelpReport> {
  final TextEditingController problemController = TextEditingController();
  final FocusNode problemFocusNode = FocusNode();

  String id = int.parse((DateTime.now().millisecondsSinceEpoch).toString().substring(6)).toString();
  bool sendAccountData = false;

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
      body: HomeArea([
        PageHeader(context, 'Reportar un problema'),
        FormContainer([
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Problema', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.045, fontWeight: FontWeight.bold),),
              SizedBox(height: deviceHeight*0.005),
              TextField(
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                focusNode: problemFocusNode,
                style: TextStyle(color: colorMainText),
                controller: problemController,
                decoration: InputDecoration(
                  fillColor: colorThirdBackground,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorThirdBackground, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: colorSpecialItem, width: 2),
                  ),

                  hintText: 'Describe el problema',
                  hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        FormContainer([
          Text(
            'Información de la cuenta',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.045,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: deviceHeight * 0.005),
          CheckboxListTile(
            activeColor: colorSpecialItem,
            title: Text(
              'Enviar información de mi cuenta',
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * 0.04,
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
          SizedBox(height: deviceHeight * 0.01),
          Text(
            'Es posible que el problema sea más fácil de resolver si se adjunta'
                ' cierta información de la cuenta como el email o el id de '
                'cuenta. También podremos informarte con un email cuando tu '
                'problema se solucione.',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.03,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic),
          ),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        MainButton(Icons.report_gmailerrorred_rounded, Colors.red, ' Reportar '
            'problema ',
                () {
                  if (problemController.text.trim().isEmpty) {
                    showSnackBar(context, 'Debes describir el problema', Colors.red);
                    problemFocusNode.requestFocus();
                  } else {
                    try {
                      Report newReport = Report(
                        id: id,
                        problem: problemController.text.trim(),
                        date: DateTime.now(),
                        userId: null,
                        userEmail: null,
                      );

                      sendReport(newReport, sendAccountData);
                      Navigator.pop(context);
                      showSnackBar(context, 'Problema reportado', Colors.green);

                    } on Exception catch (e) {
                      debugPrint('[ERR] Could not send report: $e');
                      showSnackBar(context, 'Ha ocurrido un error', Colors.red);
                    }
                  }
            }),

        FooterCredits(),
      ]),
    );
  }

}
