import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../util/colors.dart';
import '../../../util/util.dart';

class HomeDoctorDietCard extends StatefulWidget {
  final Widget child;
  const HomeDoctorDietCard({required this.child, Key? key}) : super(key: key);

  @override
  HomeDoctorDietCardState createState() => HomeDoctorDietCardState();
}

class HomeDoctorDietCardState extends State<HomeDoctorDietCard> {


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height / 3,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                color: containerUpperColor),
            child: Row(
              children: [
                const Text('Semana '),
                Text(getCurrentWeek().toString(), style: const TextStyle(fontSize: 15)),
                const Spacer(),
                Padding(padding: EdgeInsets.only(right: size.width/50), child: Text(getCurrentDay(DateFormat('EEEE').format(DateTime.now())), style: const TextStyle(fontSize: 16)),),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 35, color: primaryColor),
                    Positioned(
                        top: 11,
                        child: Text(DateFormat('d').format(DateTime.now()), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
                    )
                  ],
                ),
              ],
            ),
          ),
          widget.child
        ],
      ),
    );
  }
}
