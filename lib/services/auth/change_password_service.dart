import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';


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
      body: HomeArea([
        PageHeader(context, 'Cambia tu contraseña'),
        FormContainer([
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contraseña actual:', style: TextStyle(color: colorMainText,
                  fontSize: deviceWidth * 0.045,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: deviceHeight * 0.005),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                focusNode: oldPassFocusNode,
                style: TextStyle(color: colorMainText),
                controller: oldPassController,
                decoration: InputDecoration(
                  fillColor: colorThirdBackground,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: colorThirdBackground, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: colorSpecialItem, width: 2),
                  ),
                  hintText: 'Confirma que eres tú',
                  hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: deviceHeight * 0.025),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nueva contraseña:', style: TextStyle(color: colorMainText,
                  fontSize: deviceWidth * 0.045,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: deviceHeight * 0.005),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                focusNode: newPassFocusNode1,
                style: TextStyle(color: colorMainText),
                controller: newPassController1,
                decoration: InputDecoration(
                  fillColor: colorThirdBackground,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: colorThirdBackground, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: colorSpecialItem, width: 2),
                  ),
                  hintText: 'Al menos 6 caracteres',
                  hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: deviceHeight * 0.025),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirmar contraseña:', style: TextStyle(color: colorMainText,
                  fontSize: deviceWidth * 0.045,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: deviceHeight * 0.005),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                focusNode: newPassFocusNode2,
                style: TextStyle(color: colorMainText),
                controller: newPassController2,
                decoration: InputDecoration(
                  fillColor: colorThirdBackground,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: colorThirdBackground, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: colorSpecialItem, width: 2),
                  ),
                  hintText: 'Repite la contraseña',
                  hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ]),
        SizedBox(height: deviceHeight * 0.025),
        MainButton(
            Icons.edit,
            colorSpecialItem,
            ' Cambiar contraseña ',
                () {
              if (oldPassController.text.trim().isEmpty) {
                oldPassFocusNode.requestFocus();
                showSnackBar(context, 'Debes introducir tu contraseña actual', Colors.red);
              }
              else if (newPassController1.text
                  .trim()
                  .length < 6) {
                newPassFocusNode1.requestFocus();
                showSnackBar(context, 'La contraseña debe contener al menos 6 caracteres', Colors.red);
              }
              else if (newPassController1.text.trim() !=
                  newPassController2.text.trim()) {
                newPassFocusNode2.requestFocus();
                showSnackBar(context, 'Las contraseñas no coinciden', Colors.red);
              }
              else if (newPassController1.text.trim() ==
                  oldPassController.text.trim()) {
                newPassFocusNode1.requestFocus();
                showSnackBar(context, 'La contraseña nueva es igual que la actual', Colors.red);
              }
              else
                changePassword(oldPassController.text.trim(),
                    newPassController1.text.trim());
            }
        ),
        SizedBox(height: deviceHeight * 0.025),
        Text("Si no recuerdas tu contraseña debes cerrar sesión y acceder al "
            "apartado '¿Has olvidado tu contraseña?'.",
          style: TextStyle(color: colorSecondText,
              fontSize: deviceWidth * 0.0375,
              fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
        FooterCredits(),
      ]),
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
        showSnackBar(context, 'Contraseña actual incorrecta', Colors.red);
      }
      else showSnackBar(context, 'Ha ocurrido un error, inténtalo de nuevo', Colors.red);
      debugPrint('[ERR] ' + e.message.toString());
      hasErrors = true;
    }

    if (hasErrors==false) try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      showSnackBar(context, 'Contraseña actualizada', Colors.green);
      debugPrint('[OK] Password updated');
    } on Exception catch (e){
      showSnackBar(context, 'Ha ocurrido un error, inténtalo de nuevo', Colors.red);
      debugPrint('[ERR] ' + e.toString());
    }

    navigatorKey.currentState!.pop();
    if (hasErrors==false) Navigator.pop(context);

  }
}