import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.transparent,
        ),
        onPressed: () {},
        child: const Text(
          'Olvidé mi contraseña',
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w200,
            color: Color(0xffFF295D),
          ),
        ),
      ),
    );
  }
}
