
import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/model/entities/user_session.dart';
import 'package:full_feed_app/providers/diet_provider.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:provider/provider.dart';

import '../../../model/entities/meal.dart';
import '../../../util/strings.dart';
import '../../../util/util.dart';

class DayPlate extends StatefulWidget {

  final Meal meal;
  final bool selected;

  const DayPlate({Key? key, required this.meal, required this.selected}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DayPlateState();

}

class DayPlateState extends State<DayPlate> {
  late bool completed;

  @override
  void initState() {
    if(widget.meal.status == 1){
      completed = true;
    }
    else{
      completed = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size/60, vertical: 5),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: size2/90),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.selected ? selectedColor : Colors.white,
          ),
          width: size/2.5,
          child: Stack(
            children: [
              Padding(padding: EdgeInsets.only(left: size/40),
                child: SizedBox(
                  width: size/3.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(setFoodDayName(widget.meal.schedule.toString()), style: TextStyle(fontSize: size/40, fontWeight: FontWeight.w600),),
                          Image.asset(breakfastImg, width: 30,
                              height: 20, fit: BoxFit.contain),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: size/4,
                          child: Text(
                            widget.meal.name.toString(),
                            style: TextStyle(fontSize: size/35, fontWeight: FontWeight.w200, overflow: TextOverflow.ellipsis),),
                        ),)
                    ],
                  ),
                ),),
              Align(
                alignment: Alignment.centerRight,
                child: Checkbox(
                    value: completed,
                    checkColor: selectedColor,
                    fillColor: MaterialStateProperty.all( primaryColor),
                    activeColor: primaryColor,
                    shape: const CircleBorder(),
                    onChanged: (value){
                      // if(isPatient()){
                      //   if(completed == false){
                      //     Provider.of<DietProvider>(context, listen: false).completeMeal(widget.meal.mealId!).then((value){
                      //       setState(() {
                      //         completed = value;
                      //       });
                      //     });
                      //   }
                      //   else{
                      //     Provider.of<DietProvider>(context, listen: false).restoreMeal(widget.meal.mealId!).then((value){
                      //       setState(() {
                      //         completed = value;
                      //       });
                      //     });
                      //   }
                      // }
                    }),
              ),
            ],
          )
      ),);
  }
}