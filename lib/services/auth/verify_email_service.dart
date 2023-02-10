import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/pages/home.dart';
import 'package:simplex/common/widgets/all_widgets.dart';


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
          body: NewHomeArea(null,
              AuthHeader(),
              FooterEmpty(),
              [
            FormContainer([
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
            MainButton(
                Icons.mark_email_read_rounded,
                colorSpecialItem,
                ' Enviar email de nuevo ',
                () {
                  if (canResendEmail) {
                    sendVerificationEmail();
                  }
                },
            ),
            SizedBox(height: deviceHeight * 0.025),
            MainButton(
                Icons.close_rounded,
                Colors.red,
                ' Cancelar ',
                () => FirebaseAuth.instance.signOut()
            ),
          ]));

  Future checkVerifiedEmail() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      verifiedEmail = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (verifiedEmail) {
      timer?.cancel();

      final user = FirebaseAuth.instance.currentUser!;
      final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      final json = {
        'emailVerified': user.emailVerified,
      };

      await doc.update(json);
      debugPrint('[OK] Email verified');
    }
  }

  Future sendVerificationEmail() async {
    try {

      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      showSnackBar(context, 'Se ha enviado un email de verificación a ' + user.email.toString(), Colors.green);
      debugPrint('[OK] Verification email sent');

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } on Exception catch (e) {
      showSnackBar(context, 'Ha ocurrido un error, inténtalo de nuevo', Colors.red);
      debugPrint('[ERR] ' + e.toString());
    }
  }
}
