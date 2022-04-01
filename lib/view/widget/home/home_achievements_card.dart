import 'package:flutter/material.dart';

import '../../../model/entities/user_session.dart';
import '../../../util/colors.dart';
import '../../../util/strings.dart';


class HomeAchievementsCard extends StatefulWidget {
  const HomeAchievementsCard({Key? key}) : super(key: key);

  @override
  _HomeAchievementsCardState createState() => _HomeAchievementsCardState();
}

class _HomeAchievementsCardState extends State<HomeAchievementsCard> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2.7,
      height: size.height / 3.5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        color: achievementsCardColor,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(13, 18, 0, 0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Logros', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 25.0),
          Container(
            height: 55,
            width: size.width,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(trophyPath, width: 42, height: 42),
                    Positioned(
                      top: 2,
                      child: Text(UserSession().successfulDays.toString(),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
                              color: trophyTextColor)
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(UserSession().successfulDays.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                    const Text('Días', style: TextStyle(fontSize: 10.5)),
                    const Text('cumplidos', style: TextStyle(fontSize: 10.5))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 25.0),
          Container(
            height: 55,
            width: size.width,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(bodyScalePath, width: 55, height: 55),
                    Positioned(
                      top: 20,
                      child: Text(UserSession().lossWeight.toString(),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
                              color: trophyTextColor)
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(UserSession().lossWeight.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                    const Flexible(child: Text('Kg perdidos', style: TextStyle(fontSize: 10.5)))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}