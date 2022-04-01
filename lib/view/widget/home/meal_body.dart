import 'package:flutter/material.dart';
import 'package:full_feed_app/providers/diet_provider.dart';
import 'package:provider/provider.dart';

import '../../../model/entities/meal.dart';
import '../../../util/colors.dart';
import '../../../util/util.dart';

class MealHome extends StatefulWidget {
  final Meal meal;
  const MealHome({Key? key, required this.meal}) : super(key: key);

  @override
  MealHomeState createState() => MealHomeState();
}

class MealHomeState extends State<MealHome> {
  List<bool> isSelected = List.generate(1, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      height: 50,
      width: 120,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(setFoodDayName(widget.meal.schedule.toString()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(widget.meal.name.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12),)
            ],
          ),
          Positioned(
            bottom: 5, right: 5,
            child: ToggleButtons(
              constraints: const BoxConstraints(minHeight: 18, minWidth: 18),
              children: const [
                Icon(Icons.check, size: 18)
              ],
              isSelected: isSelected,
              onPressed: (int index) {
                setState((){
                  isSelected[index] = !isSelected[index];
                });
              },
              fillColor: mealCheckColor,
              color: Colors.transparent,
              selectedColor: Colors.white,
              selectedBorderColor: mealCheckColor,
              borderRadius: BorderRadius.circular(50),
              borderWidth: 1,
              borderColor: mealCheckColor,
            ),
          )
        ],
      ),
    );
  }
}