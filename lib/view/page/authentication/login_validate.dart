
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view/page/home/home_screen.dart';
import 'package:full_feed_app/view_model/login_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../util/util.dart';
import '../../../view_model/logged_in_view_model.dart';

class LoginValidate extends StatefulWidget {
  const LoginValidate({Key? key}) : super(key: key);

  @override
  LoginValidateState createState() => LoginValidateState();
}

class LoginValidateState extends State<LoginValidate> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LoginViewModel>(context, listen: false).doLogin().then((response){
      if(response){
        if(isPatient()){

        }
        else{
          Provider.of<LoggedInViewModel>(context, listen: false).setDoctorByPatient();
        }
        Navigator.pushReplacement(context,
            PageTransition(
                duration: const Duration(milliseconds: 200),
                reverseDuration: const Duration(milliseconds: 200),
                type: PageTransitionType.rightToLeft,
                child: const HomeScreen()
            ));
      }
      else{
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset("assets/fullfeedwhite.png", width: size.width/10,),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: size.width/6,
                height: size.width/6,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}