
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/view/page/authentication/authentication_screen.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:page_transition/page_transition.dart';

import 'authentication_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    //Provider.of<UserProvider>(context, listen: false).getCredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/fullfeedwhite.png',
      splashIconSize: 150,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: primaryColor,
      nextScreen: const AuthenticationScreen(),);
  }

}

