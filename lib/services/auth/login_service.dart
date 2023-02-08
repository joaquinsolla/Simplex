import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';


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
        body: HomeArea([
          AuthHeader(),
          SizedBox(height: deviceHeight * 0.03,),
          FormContainer([
            Text('Iniciar sesión', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.075, fontWeight: FontWeight.bold),),
            SizedBox(height: deviceHeight*0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email:', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.045, fontWeight: FontWeight.bold),),
                SizedBox(height: deviceHeight*0.005),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  focusNode: emailFocusNode,
                  style: TextStyle(color: colorMainText),
                  controller: emailController,
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
                    hintText: 'ejemplo@email.es',
                    hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(height: deviceHeight*0.025),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contraseña:', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.045, fontWeight: FontWeight.bold),),
                SizedBox(height: deviceHeight*0.005),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  focusNode: passwordFocusNode,
                  style: TextStyle(color: colorMainText),
                  controller: passwordController,
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
                    hintText: 'Contraseña',
                    hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ]),
          SizedBox(height: deviceHeight * 0.025),
          MainButton(
              Icons.lock_open_rounded,
              colorSpecialItem,
              ' Entrar ',
              () {
                if (emailController.text.trim().isEmpty ||
                    passwordController.text.trim().isEmpty) {
                  showSnackBar(context, 'Debes cubrir todos los campos', Colors.red);
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
                    showSnackBar(context, 'Formato de email inválido', Colors.red);
                  }
                }
              }
          ),
          SizedBox(height: deviceHeight * 0.025),
          TextButton(
            child: Container(
              child: Text('¿Has olvidado tu contraseña?', style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
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
                  Text('¿No tienes una cuenta?  ', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal),),
                  Text('Regístrate', style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
                ],
              ),
            ),
            onPressed: (){
              loginIndex = 1;
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
          FooterPrivacyPolicy(),
        ]),
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
        showSnackBar(context, 'Contraseña incorrecta', Colors.red);
      else if (e.message!.contains('There is no user record corresponding to this identifier. The user may have been deleted.'))
        showSnackBar(context, 'No existe ninguna cuenta con este email', Colors.red);
      else showSnackBar(context, 'Ha ocurrido un error, inténtalo de nuevo', Colors.red);
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