import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoverPasswordService extends StatefulWidget{
  const RecoverPasswordService({Key? key}) : super(key: key);

  @override
  _RecoverPasswordServiceState createState() => _RecoverPasswordServiceState();
}

class _RecoverPasswordServiceState extends State<RecoverPasswordService> {
  final emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorMainBackground,
        body: HomeArea(null,
            AuthHeader(context),
            FooterEmpty(),
            [
          FormContainer([
            Text(AppLocalizations.of(context)!.recoverPassword, style: TextStyle(color: colorMainText,
                fontSize: deviceWidth * 0.075,
                fontWeight: FontWeight.bold),),
            FormSeparator(),
            FormTextFieldEmail(emailController, AppLocalizations.of(context)!.recoveryEmail, AppLocalizations.of(context)!.emailExample, emailFocusNode, true),
          ]),
          SizedBox(height: deviceHeight * 0.025),
          MainButton(
              Icons.mark_email_read_rounded,
              colorSpecialItem,
              ' ' + AppLocalizations.of(context)!.toSendEmail + ' ',
              () {
                if (emailController.text.trim().isEmpty || RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(emailController.text.trim()) == false) {
                  emailFocusNode.requestFocus();
                  showErrorSnackBar(context, AppLocalizations.of(context)!.errorInvalidEmailFormat);
                } else {
                  resetPassword();
                }
              }
          ),
          SizedBox(height: deviceHeight * 0.025),
          Text(AppLocalizations.of(context)!.recoverPasswordExplanation,
            style: TextStyle(color: colorSecondText,
                fontSize: deviceWidth * 0.0375,
                fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
          SizedBox(height: deviceHeight * 0.025),
          CustomDivider('O'),
          SizedBox(height: deviceHeight * 0.01),
          TextButton(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.returnTo + ' ', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal),),
                  Text(AppLocalizations.of(context)!.toLogIn, style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
                ],
              ),
            ),
            onPressed: (){
              loginIndex = 0;
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ])
    );
  }

  Future resetPassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),)
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      showInfoSnackBar(context, AppLocalizations.of(context)!.emailSent);
      debugPrint('[OK] Password recovery email sent');
    } on FirebaseAuthException catch (e){
      if (e.message!.contains('There is no user record corresponding to this identifier. The user may have been deleted.'))
        showErrorSnackBar(context, AppLocalizations.of(context)!.nonExistingEmail);
      else showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
      debugPrint('[ERR] ' + e.message.toString());
    }
    navigatorKey.currentState!.pop();
  }

}