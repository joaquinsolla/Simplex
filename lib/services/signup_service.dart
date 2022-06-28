import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';

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
        body: homeArea([
          authHeader(),
          SizedBox(height: deviceHeight * 0.03,),
          formContainer([
            Text('Registrarse', style: TextStyle(color: colorMainText,
                fontSize: deviceWidth * 0.075,
                fontWeight: FontWeight.bold),),
            SizedBox(height: deviceHeight * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email:', style: TextStyle(color: colorMainText,
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
                SizedBox(height: deviceHeight * 0.025),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contraseña:', style: TextStyle(color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.bold),),
                SizedBox(height: deviceHeight * 0.005),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  focusNode: passwordFocusNode,
                  style: TextStyle(color: colorMainText),
                  controller: passwordController,
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
                    hintStyle: TextStyle(color: colorThirdText),
                  ),
                ),
                SizedBox(height: deviceHeight * 0.025),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confirmar contraseña:', style: TextStyle(color: colorMainText,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.bold),),
                SizedBox(height: deviceHeight * 0.005),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  focusNode: confirmPasswordFocusNode,
                  style: TextStyle(color: colorMainText),
                  controller: confirmPasswordController,
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
                    hintStyle: TextStyle(color: colorThirdText),
                  ),
                ),
              ],
            ),
          ]),
          SizedBox(height: deviceHeight * 0.025),
          actionsButton(
              Icons.person_add_alt_rounded,
              colorSpecialItem,
              ' Registrarme ',
              () {
                if (emailController.text == '' ||
                    passwordController.text == '' ||
                    confirmPasswordController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Debes cubrir todos los campos"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ));
                  if (emailController.text == '')
                    emailFocusNode.requestFocus();
                  else if (passwordController.text == '')
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
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "La contraseña debe contener al menos 6 caracteres"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ));
                    } else {
                      if (passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        passwordFocusNode.requestFocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Las contraseñas no coinciden"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ));
                      } else
                        signUp();
                    }
                  }
                  else {
                    emailFocusNode.requestFocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Formato de email inválido"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ));
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
                  Text('Inicia sesión', style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
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
      if (e.message!.contains('The email address is already in use by another account.')) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ya existe una cuenta con este email"),
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
    createUserDoc();
    navigatorKey.currentState!.pop();
  }

}