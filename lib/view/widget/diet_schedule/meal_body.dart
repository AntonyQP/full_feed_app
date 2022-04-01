import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';


class Meal extends StatefulWidget {
  final String mealType;
  final String description;
  const Meal({Key? key, required this.mealType, required this.description}) : super(key: key);

  @override
  _MealState createState() => _MealState();
}

class _MealState extends State<Meal> {
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
              Text(widget.mealType, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.description)
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