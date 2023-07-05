import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogInService extends StatefulWidget{
  const LogInService({Key? key}) : super(key: key);

  @override
  _LogInServiceState createState() => _LogInServiceState();
}

class _LogInServiceState extends State<LogInService> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (deviceChecked == false) check_device();

    return Scaffold(
        backgroundColor: colorMainBackground,
        body: HomeArea(null,
            AuthHeader(),
            FooterPrivacyPolicy(),
            [
          FormContainer([
            Text(AppLocalizations.of(context)!.toLogIn, style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.075, fontWeight: FontWeight.bold),),
            FormSeparator(),
            FormTextFieldEmail(emailController, AppLocalizations.of(context)!.email + ':', AppLocalizations.of(context)!.emailExample, emailFocusNode, false),
            FormTextFieldPassword(passwordController, AppLocalizations.of(context)!.password + ':', AppLocalizations.of(context)!.password, passwordFocusNode, true),
          ]),
          SizedBox(height: deviceHeight * 0.025),
          MainButton(
              Icons.lock_open_rounded,
              colorSpecialItem,
              ' ' + AppLocalizations.of(context)!.logInto + ' ',
              () {
                if (emailController.text.trim().isEmpty ||
                    passwordController.text.trim().isEmpty) {
                  showErrorSnackBar(context, AppLocalizations.of(context)!.errorTypeAllFields);
                  if (emailController.text.trim().isEmpty)
                    emailFocusNode.requestFocus();
                  else
                    passwordFocusNode.requestFocus();
                } else {
                  if (RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text.trim()))
                    signIn();
                  else {
                    emailFocusNode.requestFocus();
                    showErrorSnackBar(context, AppLocalizations.of(context)!.errorInvalidEmailFormat);
                  }
                }
              }
          ),
          SizedBox(height: deviceHeight * 0.025),
          TextButton(
            child: Container(
              child: Text(AppLocalizations.of(context)!.forgotPassword, style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
            ),
            onPressed: (){
              loginIndex = 2;
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
          SizedBox(height: deviceHeight * 0.01),
          CustomDivider('O'),
          SizedBox(height: deviceHeight * 0.01),
          TextButton(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.noAccount + '  ', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal),),
                  Text(AppLocalizations.of(context)!.getSignedUp, style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
                ],
              ),
            ),
            onPressed: (){
              loginIndex = 1;
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ]
        ),
    );

  }

  /// AUX FUNCTIONS
  Future signIn() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(),)
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      debugPrint('[OK] Logged in');
    } on FirebaseAuthException catch (e){
      if (e.message!.contains('The password is invalid or the user does not have a password.'))
        showErrorSnackBar(context, AppLocalizations.of(context)!.errorWrongPassword);
      else if (e.message!.contains('There is no user record corresponding to this identifier. The user may have been deleted.'))
        showErrorSnackBar(context, AppLocalizations.of(context)!.nonExistingEmail);
      else showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
      debugPrint('[ERR] ' + e.message.toString());
    }
    navigatorKey.currentState!.pop();
  }

  void check_device(){
    setState(() {
      var padding = MediaQuery.of(context).padding;
      deviceHeight = max(MediaQuery.of(context).size.height - padding.top - padding.bottom, MediaQuery.of(context).size.width - padding.top - padding.bottom);
      deviceWidth = min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

      if (deviceHeight!=0 || deviceWidth!=0){
        debugPrint('[OK] Device checked.');
        deviceChecked = true;
      } else check_device();
    });
  }

}