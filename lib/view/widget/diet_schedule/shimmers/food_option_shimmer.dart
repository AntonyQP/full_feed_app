import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/colors.dart';

class FoodOptionShimmer extends StatefulWidget {


  const FoodOptionShimmer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FoodOptionShimmerState();

}

class FoodOptionShimmerState extends State<FoodOptionShimmer> {
  int selected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width/50, vertical: 5),
      child: Shimmer.fromColors(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: size.height/90),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              width: size.width/4.5,
              height: size.height/6.25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: size.width/500,
                        widthFactor: size.width/500,
                        child: Image.network("https://blogladiadoresfit.com/wp-content/uploads/2021/02/avena-fitness.jpg", height: size.width/4,),
                      )
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10), child: Container(
                    color: Colors.grey,
                    width: size.width/10,
                    height: size.height/70,
                  ),),
                ],
              )
          ),
          baseColor: primaryColor,
          highlightColor: secondaryColor
      ),
    );
  }
}