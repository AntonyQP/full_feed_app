
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_feed_app/util/colors.dart';

class PatientDetailCard extends StatefulWidget {
  final String asset;
  final String text;
  final String title;
  const PatientDetailCard({Key? key, required this.asset, required this.text, required this.title}) : super(key: key);

  @override
  PatientDetailCardState createState() => PatientDetailCardState();
}

class PatientDetailCardState extends State<PatientDetailCard> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              cardColor,
              Colors.white.withOpacity(0.6),
            ],
            stops: [0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.005),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(-5, -5),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      width: size.width/2.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(widget.asset, height: size.height * 0.035, color: darkColor,),
          Padding(
            padding: EdgeInsets.only(top: 10, left: size.width/50, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(color: darkColor, fontWeight: FontWeight.w400, fontSize: 10),),
                Text(widget.text, style: const TextStyle(color: darkColor, fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          )
        ],
      ),
    );
  }
}