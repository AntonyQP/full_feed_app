import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginButton extends StatefulWidget {

  final VoidCallback press;
  const LoginButton({Key? key, required this.press}) : super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(35.0)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      primaryColor,
                      secondaryColor,
                    ],
                    stops: [0.40, 1],
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: widget.press,
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text('Iniciar Sesión',
                    style: GoogleFonts.raleway()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
