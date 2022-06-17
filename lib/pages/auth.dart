import 'package:flutter/material.dart';

import 'package:simplex/common/all_common.dart';
import 'package:simplex/pages/home.dart';
import 'package:simplex/services/login_service.dart';
import 'package:simplex/services/signup_service.dart';
import 'package:simplex/services/recover_password_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: colorSpecialItem,),);
          } else if (snapshot.hasError){
            if (loginIndex == 0) return LogInService();
            else if (loginIndex == 1) return SignUpService();
            else return RecoverPasswordService();
          } else if(snapshot.hasData){
            return Home();
          }else{
            if (loginIndex == 0)return LogInService();
            else if (loginIndex == 1)  return SignUpService();
            else return RecoverPasswordService();
          }
        }
      ),
    );
  }

}
