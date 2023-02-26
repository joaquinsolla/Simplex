import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';
import 'package:simplex/common/widgets/all_widgets.dart';


class SignUpService extends StatefulWidget{
  const SignUpService({Key? key}) : super(key: key);

  @override
  _SignUpServiceState createState() => _SignUpServiceState();
}

class _SignUpServiceState extends State<SignUpService> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorMainBackground,
        body: HomeArea(null,
            AuthHeader(),
            FooterPrivacyPolicy(),
            [
          FormContainer([
            Text('Registrarse', style: TextStyle(color: colorMainText,
                fontSize: deviceWidth * 0.075,
                fontWeight: FontWeight.bold),),
            FormSeparator(),
            FormTextFieldEmail(emailController, 'Email:', 'ejemplo@email.com', emailFocusNode, false),
            FormTextFieldPassword(passwordController, 'Contraseña:', 'Mínimo 6 caracteres', passwordFocusNode, false),
            FormTextFieldPassword(confirmPasswordController, 'Confirmar contraseña:', 'Repite la contraseña', confirmPasswordFocusNode, true),
          ]),
          SizedBox(height: deviceHeight * 0.025),
          MainButton(
              Icons.person_add_alt_rounded,
              colorSpecialItem,
              ' Registrarme ',
              () {
                if (emailController.text.trim().isEmpty ||
                    passwordController.text.trim().isEmpty ||
                    confirmPasswordController.text.trim().isEmpty) {
                  showErrorSnackBar(context, 'Debes cubrir todos los campos');
                  if (emailController.text.trim().isEmpty)
                    emailFocusNode.requestFocus();
                  else if (passwordController.text.trim().isEmpty)
                    passwordFocusNode.requestFocus();
                  else
                    confirmPasswordFocusNode.requestFocus();
                } else {
                  if (RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text.trim())) {
                    if (passwordController.text
                        .trim()
                        .length < 6) {
                      passwordFocusNode.requestFocus();
                      showErrorSnackBar(context, 'La contraseña debe contener al menos 6 caracteres');
                    } else {
                      if (passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        passwordFocusNode.requestFocus();
                        showErrorSnackBar(context, 'Las contraseñas no coinciden');
                      } else
                        signUp();
                    }
                  }
                  else {
                    emailFocusNode.requestFocus();
                    showErrorSnackBar(context, 'Formato de email inválido');
                  }
                }
              }
          ),
          SizedBox(height: deviceHeight * 0.025),
          TextButton(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¿Ya tienes una cuenta?  ', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal),),
                  Text('Iniciar sesión', style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
                ],
              ),
            ),
            onPressed: (){
              loginIndex = 0;
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ]
        )
    );
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),)
    );

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      debugPrint('[OK] Signed up, waiting for email verification');
    } on FirebaseAuthException catch (e){
      if (e.message!.contains('The email address is already in use by another account.'))
        showErrorSnackBar(context, 'Ya existe una cuenta con este email');
      else showErrorSnackBar(context, 'Ha ocurrido un error, inténtalo de nuevo');
      debugPrint('[ERR] ' + e.message.toString());
    }
    createUserDoc();
    navigatorKey.currentState!.pop();
  }

}