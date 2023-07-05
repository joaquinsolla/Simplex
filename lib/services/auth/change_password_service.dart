import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordService extends StatefulWidget{
  const ChangePasswordService({Key? key}) : super(key: key);

  @override
  _ChangePasswordServiceState createState() => _ChangePasswordServiceState();
}

class _ChangePasswordServiceState extends State<ChangePasswordService> {
  final oldPassController = TextEditingController();
  final newPassController1 = TextEditingController();
  final newPassController2 = TextEditingController();
  FocusNode oldPassFocusNode = FocusNode();
  FocusNode newPassFocusNode1 = FocusNode();
  FocusNode newPassFocusNode2 = FocusNode();

  @override
  void dispose(){
    oldPassController.dispose();
    newPassController1.dispose();
    newPassController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeArea(null,
          PageHeader(context, AppLocalizations.of(context)!.changePassword),
          FooterCredits(),
          [
        FormContainer([
          FormTextFieldPassword(oldPassController, AppLocalizations.of(context)!.currentPassword, AppLocalizations.of(context)!.confirmYourIdentity, oldPassFocusNode, false),
          FormTextFieldPassword(newPassController1, AppLocalizations.of(context)!.newPassword, AppLocalizations.of(context)!.min6Chars, newPassFocusNode1, false),
          FormTextFieldPassword(newPassController2, AppLocalizations.of(context)!.confirmPassword, AppLocalizations.of(context)!.repeatPassword, newPassFocusNode2, true),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        MainButton(
            Icons.edit,
            colorSpecialItem,
            ' ' + AppLocalizations.of(context)!.toChangePassword + ' ',
                () {
              if (oldPassController.text.trim().isEmpty) {
                oldPassFocusNode.requestFocus();
                showErrorSnackBar(context, AppLocalizations.of(context)!.errorTypeCurrentPassword);
              }
              else if (newPassController1.text
                  .trim()
                  .length < 6) {
                newPassFocusNode1.requestFocus();
                showErrorSnackBar(context, AppLocalizations.of(context)!.errorPasswordMinChars);
              }
              else if (newPassController1.text.trim() !=
                  newPassController2.text.trim()) {
                newPassFocusNode2.requestFocus();
                showErrorSnackBar(context, AppLocalizations.of(context)!.errorPasswordsNotEqual);
              }
              else if (newPassController1.text.trim() ==
                  oldPassController.text.trim()) {
                newPassFocusNode1.requestFocus();
                showErrorSnackBar(context, AppLocalizations.of(context)!.errorPasswordAlreadyUsed);
              }
              else
                changePassword(oldPassController.text.trim(),
                    newPassController1.text.trim());
            }
        ),
        SizedBox(height: deviceHeight * 0.025),
        Text(AppLocalizations.of(context)!.changePasswordExplanation,
          style: TextStyle(color: colorSecondText,
              fontSize: deviceWidth * fontSize * 0.0375,
              fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
          ]
      ),
    );
  }

  Future changePassword(String currentPassword, String newPassword) async{
    bool hasErrors = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),)
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: FirebaseAuth.instance.currentUser!.email.toString(),
        password: currentPassword,
      );
    } on FirebaseAuthException catch (e){
      if (e.message!.contains('The password is invalid or the user does not have a password.')) {
        oldPassFocusNode.requestFocus();
        showErrorSnackBar(context, AppLocalizations.of(context)!.errorWrongCurrentPassword);
      }
      else showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
      debugPrint('[ERR] ' + e.message.toString());
      hasErrors = true;
    }

    if (hasErrors==false) try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      showInfoSnackBar(context, AppLocalizations.of(context)!.passwordUpdated);
      debugPrint('[OK] Password updated');
    } on Exception catch (e){
      showErrorSnackBar(context, AppLocalizations.of(context)!.errorTryAgain);
      debugPrint('[ERR] ' + e.toString());
    }

    navigatorKey.currentState!.pop();
    if (hasErrors==false) Navigator.pop(context);

  }
}