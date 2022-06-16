import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

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
        body: homeArea([
          authHeader(),
          SizedBox(height: deviceHeight * 0.03,),
          alternativeFormContainer([
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
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(color: colorSpecialItem, width: 2),
                    ),
                    hintText: 'ejemplo@email.es',
                    hintStyle: TextStyle(color: colorThirdText),
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
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(color: colorSpecialItem, width: 2),
                    ),
                    hintText: 'Contraseña',
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
                      Icon(Icons.lock_open_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                      Text(
                        ' Entrar ',
                        style: TextStyle(
                            color: colorSpecialItem,
                            fontSize: deviceWidth * 0.05,
                            fontWeight: FontWeight.normal),
                      ),
                      Icon(Icons.lock_open_rounded, color: Colors.transparent, size: deviceWidth * 0.06),
                    ],
                  ),
                  onPressed: (){
                    if (emailController.text == '' || passwordController.text == ''){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Debes cubrir todos los campos"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ));
                      if (emailController.text == '') emailFocusNode.requestFocus();
                      else passwordFocusNode.requestFocus();
                    } else {
                      if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim())) signIn();
                      else {
                        emailFocusNode.requestFocus();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Formato de email inválido"),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    }
                  },
                ),
              ),],
            ),
          ),
          SizedBox(height: deviceHeight * 0.025),
          TextButton(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¿Todavía no tienes una cuenta?  ', style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal),),
                  Text('Regístrate', style: TextStyle(color: colorSpecialItem, fontSize: deviceWidth*0.0375, fontWeight: FontWeight.normal, decoration: TextDecoration.underline),),
                ],
              ),
            ),
            onPressed: (){
              atLogin = false;
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
          SizedBox(height: deviceHeight * 0.025),
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
    } on FirebaseAuthException catch (e){
      if (e.message!.contains('The password is invalid or the user does not have a password.')) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Contraseña incorrecta"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
      else if (e.message!.contains('There is no user record corresponding to this identifier. The user may have been deleted.')) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No existe una cuenta con este email"),
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
      print(e);
    }
    navigatorKey.currentState!.pop();
  }

  void check_device(){
    setState(() {
      var padding = MediaQuery.of(context).padding;
      deviceHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
      deviceWidth = MediaQuery.of(context).size.width;

      if (deviceHeight!=0 || deviceWidth!=0){
        debugPrint('[OK] Device checked.');
        deviceChecked = true;
      } else check_device();
    });
  }

}