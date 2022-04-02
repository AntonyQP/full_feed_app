import 'package:flutter/material.dart';
import 'package:full_feed_app/providers/user_provider.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../util/util.dart';
import '../authentication/authentication_screen.dart';



class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height/20),
              child: Image.asset("assets/breakfast_back.png", width: size.width/1.5),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height/80),
              child: Text("Todo Listo!", style: TextStyle(fontSize: 36),),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height/80),
              child: SizedBox(
                width: size.width/2,
                child: Text(Provider.of<RegisterViewModel>(context, listen: false).getDesireRol() == 'p' ? "A partir de mañana comienza una nueva vida saludable" :
                "Los pacientes esperan por tu asesoramiento.", style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: size.height/20),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xFFFF295D), Color(0xFFFE7EB4)],
                          stops: [0.05, 1]
                      )
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              duration: const Duration(milliseconds: 200),
                              reverseDuration: const Duration(milliseconds: 200),
                              type: PageTransitionType.bottomToTop,
                              child: const AuthenticationScreen()
                          )
                      );
                    },
                    child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: size.height/20,),
                    style: ElevatedButton.styleFrom(
                      maximumSize: const Size( 200,  200),
                      elevation: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Colors.transparent, // <-- Button color
                      onPrimary: Colors.transparent, // <-- Splash color
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
