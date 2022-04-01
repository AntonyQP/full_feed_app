
import 'package:flutter/cupertino.dart';


import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/util/strings.dart';
import 'package:full_feed_app/view_model/diet_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../providers/diet_provider.dart';
import '../../../util/util.dart';
import '../../../view/widget/diet_schedule/food_detail.dart';
import '../../../view/page/register/welcome_screen.dart';
import '../../../view/widget/diet_schedule/message.dart';
import '../../widget/diet_schedule/select_day_plate.dart';




class DietDayDetail extends StatefulWidget {

  final bool fromRegister;
  const DietDayDetail({Key? key, required this.fromRegister}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DietDayDetailState();

}

class DietDayDetailState extends State<DietDayDetail> {
  int selected = 0;
  int foodSelected = 0;

  @override
  void initState() {
    super.initState();
  }

  _showDialog(){
    showDialog(
      barrierColor: Colors.white70,
      context: context,
      builder: (BuildContext context) {
        return Message(text: '¿Desea continuar con este plan dietético?', yesFunction: (){
          Navigator.pushReplacement(
              context,
              PageTransition(
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  type: PageTransitionType.rightToLeft,
                  child: const WelcomeScreen()
              )
          );
        }, noFunction: (){}, options: true,);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  refresh(String day){
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var size2 = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(logoImagePath, width: 40,
                    height: 40, fit: BoxFit.contain),
                Image.asset(logoTextPath, width: 70,
                    height: 70, fit: BoxFit.contain)
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Provider.of<DietProvider>(context, listen: false).firstDayEntry = true; //TODO: CHECK BEST OPTION
                  Navigator.pop(context); },
                icon: const Icon(CupertinoIcons.back, color: primaryColor,),
              ),
              const Text("Semana 1", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15),)
            ],
          ),
          SizedBox(height: size2/50,),
          Wrap(
            spacing: size/50,
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: List.generate( Provider.of<DietViewModel>(context, listen: false).getDaysForDetail().length, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selected = index;
                    Provider.of<DietProvider>(context, listen: false).setDayDetailPresenter(index, context);
                    Provider.of<DietProvider>(context, listen: false).firstDayEntry = true;
                  });
                },
                child: CircleAvatar(
                  backgroundColor: selected == index? primaryColor : Colors.white60,
                  child: Text( setDayByDayIndex(Provider.of<DietViewModel>(context, listen: false).getDaysForDetail()[index].weekday),
                    style: TextStyle(fontWeight: FontWeight.bold, color: selected == index? Colors.white : Colors.black),),
                ),
              );
            }),),
          Provider.of<DietProvider>(context).getDietDayDetailViewModel().getThereAreDiet() ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 2,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
                color: Colors.white
            ),
            width: size,
            child: Column(
                children: [
                  SelectDayPlate(dayMeals: Provider.of<DietProvider>(context).getDietDayDetailViewModel().getDayMeals(),),
                  FoodDetail(
                      notifyParent: refresh,
                      meal: Provider.of<DietProvider>(context).getIsAlternativeMealSelected() ?
                      Provider.of<DietProvider>(context).getDietDayDetailViewModel().getAlternativeMeal() :
                      Provider.of<DietProvider>(context).getDietDayDetailViewModel().getMealSelected()),
                ],
              ),
          )
              : SizedBox(
            height: size2/2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Este dia no existen dietas", style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
          Visibility(
            visible: widget.fromRegister,
            child: Padding(
                padding: EdgeInsets.only(top: size2/20),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xFFFF295D), Color(0xFFFE7EB4)],
                          stops: [0.05, 1]
                      )
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _showDialog();
                    },
                    child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: size2/20,),
                    style: ElevatedButton.styleFrom(
                      maximumSize: const Size( 200,  200),
                      elevation: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Colors.transparent, // <-- Button color
                      onPrimary: Colors.transparent, // <-- Splash color
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}