
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/providers/diet_provider.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:provider/provider.dart';

import '../../../model/entities/meal.dart';

class FoodOption extends StatefulWidget {

  final int index;
  final Meal meal;

  const FoodOption({Key? key, required this.meal, required this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FoodOptionState();

}

class FoodOptionState extends State<FoodOption> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int selected = Provider.of<DietProvider>(context).optionSelected;
    return SizedBox(
      height: size.height * 0.2,
      width: size.width *0.26,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: widget.index == selected ? size.height * 0.05 : size.height * 0.03,
            child: Container(
                padding: EdgeInsets.only(left: 10, top: 20, right: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: darkColor,
                ),
                width: widget.index == selected ? size.width * 0.22 : size.width * 0.18,
                height: widget.index == selected ? size.height * 0.12 : size.height * 0.11,
                child: Center(
                  child: Text(widget.meal.name.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: Colors.white) ,
                    textAlign: TextAlign.start,),
                )
            ),
          ),
          CircleAvatar(
            radius: widget.index == selected ? size.height * 0.05 : size.height * 0.04,
            backgroundImage: NetworkImage(
                widget.meal.imageUrl != null && widget.meal.imageUrl != "" ?
                widget.meal.imageUrl! :
                "https://blogladiadoresfit.com/wp-content/uploads/2021/02/avena-fitness.jpg"),
          ),
        ],
      ),
    );
  }
}