import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:simplex/common/all_common.dart';
import 'package:simplex/pages/home.dart';
import 'package:simplex/services/login_service.dart';
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
            return LoginService();
          } else if(snapshot.hasData){
            return Home();
          }else{
            return LoginService();
          }
        }
      ),
    );
  }

}
