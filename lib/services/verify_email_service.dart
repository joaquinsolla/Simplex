import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/pages/home.dart';

class VerifyEmailService extends StatefulWidget {
  const VerifyEmailService({Key? key}) : super(key: key);

  @override
  _VerifyEmailServiceState createState() => _VerifyEmailServiceState();
}

class _VerifyEmailServiceState extends State<VerifyEmailService> {
  bool verifiedEmail = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    verifiedEmail = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!verifiedEmail) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkVerifiedEmail(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => verifiedEmail
      ? Home()
      : Scaffold(
          backgroundColor: colorMainBackground,
          body: homeArea([
            authHeader(),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            alternativeFormContainer([
              Text(
                'Verifica tu email',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * 0.075,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: deviceHeight * 0.01),
              Text('Se ha enviado un email de verificación a tu dirección de correo: '
                + FirebaseAuth.instance.currentUser!.email.toString()
                + '\n\nComprueba tu bandeja de entrada. Si no ves el email, revisa tu bandeja de spam.'
                      ' También puedes enviar el email de nuevo.',
                style: TextStyle(color: colorSecondText,
                    fontSize: deviceWidth * 0.0375,
                    fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
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
                children: [
                  SizedBox(
                    width: deviceWidth * 0.8,
                    height: deviceHeight * 0.07,
                    child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.mark_email_read_rounded,
                              color: colorSpecialItem,
                              size: deviceWidth * 0.06),
                          Text(
                            ' Enviar email de nuevo ',
                            style: TextStyle(
                                color: colorSpecialItem,
                                fontSize: deviceWidth * 0.05,
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(Icons.mark_email_read_rounded,
                              color: Colors.transparent,
                              size: deviceWidth * 0.06),
                        ],
                      ),
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: deviceHeight * 0.025),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorSecondBackground,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: deviceWidth * 0.8,
                    height: deviceHeight * 0.07,
                    child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.close_rounded,
                              color: Colors.red,
                              size: deviceWidth * 0.06),
                          Text(
                            ' Cancelar ',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: deviceWidth * 0.05,
                                fontWeight: FontWeight.normal),
                          ),
                          Icon(Icons.close_rounded,
                              color: Colors.transparent,
                              size: deviceWidth * 0.06),
                        ],
                      ),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: deviceHeight * 0.025),
          ]));

  Future checkVerifiedEmail() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      verifiedEmail = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (verifiedEmail) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {

      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Se ha enviado un email de verificación a " + user.email.toString()),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
      debugPrint('[OK] Verification email sent');

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ha ocurrido un error, inténtalo de nuevo"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
      debugPrint('[ERR] ' + e.toString());
    }
  }
}
