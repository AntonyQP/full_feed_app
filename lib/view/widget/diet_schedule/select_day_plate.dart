import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/providers/diet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../model/entities/meal.dart';
import 'day_plate.dart';

class SelectDayPlate extends StatefulWidget {

  final List<Meal> dayMeals;
  const SelectDayPlate({Key? key, required this.dayMeals}) : super(key: key);

  @override
  _SelectDayPlateState createState() => _SelectDayPlateState();

}

class _SelectDayPlateState extends State<SelectDayPlate> {

  int selected = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(padding: EdgeInsets.symmetric(vertical: size.height/50),
      child: Wrap(
        direction: Axis.horizontal,
        children: List.generate(widget.dayMeals.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = index;
                Provider.of<DietProvider>(context, listen: false).setMealSelected(widget.dayMeals[selected]);
              });
            },
            child: DayPlate(meal: widget.dayMeals[index], selected: index == selected, ),
          );
        }),),);
  }
}