import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../util/colors.dart';
import '../../../util/util.dart';

class HomeDietCard extends StatefulWidget {
  final Widget child;
  const HomeDietCard({required this.child, Key? key}) : super(key: key);

  @override
  _HomeDietCardState createState() => _HomeDietCardState();
}

class _HomeDietCardState extends State<HomeDietCard> {

  int getCurrentWeek(){
    String date = DateTime.now().toString();
    String firstDay = date.substring(0, 8) + '01' + date.substring(10);
    int weekDay = DateTime.parse(firstDay).weekday;
    DateTime testDate = DateTime.now();
    int weekOfMonth;
    weekDay--;
    weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
    weekDay++;
    if (weekDay == 7) {
      weekDay = 0;
    }
    weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
    return weekOfMonth;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.only(bottom: 20),
      width: size.width,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          gradient: RadialGradient(
            colors: [
              cardColor,
              Colors.white.withOpacity(0.6),
            ],
            stops: [0.50, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(-5, -5),
            )
          ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: size.width * 0.01),
                  child: Text(getCurrentDay(DateFormat('EEEE').format(DateTime.now())), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 35, color: primaryColor),
                    Positioned(
                        top: 11,
                        child: Text(DateFormat('d').format(DateTime.now()), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
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
