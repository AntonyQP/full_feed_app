
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
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
          color: Color(0xFFFFBAB9),
          borderRadius: BorderRadius.all(Radius.circular(18.0))
      ),
      width: size.width/2.7,
      height: size.height/12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            width: size.width/6.5,
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(14.0))
            ),
            child: SvgPicture.asset(widget.asset, height: size.height/20,),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: size.width/50, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                Text(widget.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          )
        ],
      ),
    );
  }
}