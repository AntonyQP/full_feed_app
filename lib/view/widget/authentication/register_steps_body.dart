import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';

class RegisterStepBody extends StatefulWidget {
  final String title;
  final Widget child;
  final VoidCallback fabOnPressed;
  final VoidCallback arrowBackOnPressed;
  const RegisterStepBody({required this.fabOnPressed, required this.arrowBackOnPressed,
    required this.title, required this.child, Key? key}) : super(key: key);

  @override
  _RegisterStepBodyState createState() => _RegisterStepBodyState();
}

class _RegisterStepBodyState extends State<RegisterStepBody> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        leading: Padding(
          padding: EdgeInsets.only(top: size.height/40, left: size.width/30),
          child: IconButton(onPressed: widget.arrowBackOnPressed,
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        elevation: 0.0,
        title: Padding(
          padding: EdgeInsets.only(top: size.height/40),
          child: Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
      backgroundColor: primaryColor,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          gradient: RadialGradient(
            colors: [
              cardColor,
              Colors.white.withOpacity(0.9),
            ],
            stops: [0.50, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
            BoxShadow(
              color: primaryColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(-5, -5),
            )
          ],
        ),
        margin: const EdgeInsets.all(10.0),
        child: widget.child,
      ),
    );
  }
}