import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';


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
        body: homeArea([
          authHeader(),
          SizedBox(height: deviceHeight * 0.03,),
          alternativeFormContainer([
            Text('Restablecer contraseña', style: TextStyle(color: colorMainText,
                fontSize: deviceWidth * 0.075,
                fontWeight: FontWeight.bold),),
            SizedBox(height: deviceHeight * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email de recuperación:', style: TextStyle(color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.bold),),
                SizedBox(height: deviceHeight * 0.005),
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
                      borderSide: BorderSide(
                          color: colorThirdBackground, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: colorSpecialItem, width: 2),
                    ),
                    hintText: 'ejemplo@email.es',
                    hintStyle: TextStyle(color: colorThirdText),
                  ),
                ),
              ],
            ),
          ]),
          SizedBox(height: deviceHeight * 0.025),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorSecondBackground,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [ SizedBox(
                width: deviceWidth*0.8,
                height: deviceHeight*0.07,
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.mark_email_read_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                      Text(
                        ' Enviar email ',
                        style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.05,
                            fontWeight: FontWeight.normal),
                      ),
                      Icon(Icons.mark_email_read_rounded, color: Colors.transparent, size: deviceWidth * 0.06),
                    ],
                  ),
                  onPressed: () {
                    if (emailController.text == '' || RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim())==false) {
                      emailFocusNode.requestFocus();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Debes indicar un email válido"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      resetPassword();
                    }
                  },
                ),
              ),],
            ),
          ),
          SizedBox(height: deviceHeight * 0.025),
          Text('Se enviará un email de recuperación con las instrucciones para '
              'que puedas restablecer la contraseña de tu cuenta de Simplex.\n'
              'Si no ves el email comprueba tu bandeja de spam.',
            style: TextStyle(color: colorSecondText,
                fontSize: deviceWidth * 0.0375,
                fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
          SizedBox(height: deviceHeight * 0.025),
          customDivider('O'),
          SizedBox(height: deviceHeight * 0.01),
          TextButton(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Volver a  ', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal),),
                  Text('Iniciar sesión', style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
                ],
              ),
            ),
            onPressed: (){
              loginIndex = 0;
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
          SizedBox(height: deviceHeight * 0.025),
        ]));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Se ha enviado un email de recuperación, comprueba tu bandeja de entrada"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
      debugPrint('[OK] Password recovery email sent');
    } on FirebaseAuthException catch (e){
      if (e.message!.contains('There is no user record corresponding to this identifier. The user may have been deleted.')) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No existe ninguna cuenta con este email"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Ha ocurrido un error, inténtalo de nuevo"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ));
      debugPrint('[ERR] ' + e.message.toString());
    }
    navigatorKey.currentState!.pop();
  }

}