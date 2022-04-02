

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_feed_app/providers/diet_provider.dart';
import 'package:full_feed_app/view_model/diet_view_model.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../util/strings.dart';
import '../diet_schedule/diet_day_detail.dart';

class LoadingScreen extends StatefulWidget {
  final String text;
  final bool generateDiet;
  const LoadingScreen({Key? key, required this.text, required this.generateDiet}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {


  late AnimationController controller;
  late Animation<double> innerAnimation;
  late Animation<double> externalAnimation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    innerAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    externalAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    super.initState();

    if(widget.generateDiet){
      generateDiet();
    }
    controller.repeat();
  }

  generateDiet(){
    Provider.of<DietViewModel>(context, listen: false).generateNutritionPlan(Provider.of<RegisterViewModel>(context, listen: false).getDoctorId()).whenComplete((){
      Provider.of<DietProvider>(context, listen: false).setDayDetailPresenter(0, context);
      controller.stop();
      Navigator.push(
          context,
          PageTransition(
              duration: const Duration(milliseconds: 200),
              reverseDuration: const Duration(milliseconds: 200),
              type: PageTransitionType.rightToLeft,
              child: const DietDayDetail(fromRegister: true,)
          )
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height/80),
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height/4),
              child: RotationTransition(
                turns: innerAnimation,
                child: SvgPicture.asset(innerCircle, width: size.width/4.5,),
              ),),
            Padding(
               padding: EdgeInsets.only(top: size.height/4),
               child: RotationTransition(
                 turns: externalAnimation,
                 child: SvgPicture.asset(externalCircle, width: size.width/3),
               ))
          ],
        ),
      ],
    );
  }
}