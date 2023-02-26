import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';


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
            AuthHeader(),
            FooterEmpty(),
            [
          FormContainer([
            Text('Restablecer contraseña', style: TextStyle(color: colorMainText,
                fontSize: deviceWidth * 0.075,
                fontWeight: FontWeight.bold),),
            FormSeparator(),
            FormTextFieldEmail(emailController, 'Email de recuperación', 'ejemplo@email.es', emailFocusNode, true),
          ]),
          SizedBox(height: deviceHeight * 0.025),
          MainButton(
              Icons.mark_email_read_rounded,
              colorSpecialItem,
              ' Enviar email ',
              () {
                if (emailController.text.trim().isEmpty || RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(emailController.text.trim()) == false) {
                  emailFocusNode.requestFocus();
                  showErrorSnackBar(context, 'Debes indicar un email válido');
                } else {
                  resetPassword();
                }
              }
          ),
          SizedBox(height: deviceHeight * 0.025),
          Text('Se enviará un email de recuperación con las instrucciones para '
              'que puedas restablecer la contraseña de tu cuenta de Simplex.\n'
              'Si no ves el email comprueba tu bandeja de spam.',
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
      showInfoSnackBar(context, 'Se ha enviado un email de recuperación, comprueba tu bandeja de entrada.');
      debugPrint('[OK] Password recovery email sent');
    } on FirebaseAuthException catch (e){
      if (e.message!.contains('There is no user record corresponding to this identifier. The user may have been deleted.'))
        showErrorSnackBar(context, 'No existe ninguna cuenta con este email');
      else showErrorSnackBar(context, 'Ha ocurrido un error, inténtalo de nuevo');
      debugPrint('[ERR] ' + e.message.toString());
    }
    navigatorKey.currentState!.pop();
  }

}