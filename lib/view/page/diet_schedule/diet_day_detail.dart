
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
        return Message(text: '¿Desea continuar con este plan dietético?',
          advice: '',
          yesFunction: (){
          Navigator.pushReplacement(
              context,
              PageTransition(
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  type: PageTransitionType.rightToLeft,
                  child: const WelcomeScreen()
              )
          );
        }, noFunction: (){ Navigator.pop(context); }, options: true,);
      },
    );
  }

  @override
  void dispose() {
    if(Provider.of<DietProvider>(context, listen: false).getIsAlternativeMealSelected()){
      Provider.of<DietProvider>(context, listen: false).deselectAlternativeMeal();
    }
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
      backgroundColor: const Color(0xFFE5E5E5),
      body: ListView(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Provider.of<DietProvider>(context, listen: false).deselectAlternativeMeal();
                  Provider.of<DietProvider>(context, listen: false).firstDayEntry = true; //TODO: CHECK BEST OPTION
                  Navigator.pop(context); },
                icon: const Icon(CupertinoIcons.back, color: primaryColor,),
              ),
              const Text("Plan Nutricional", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15),)
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
                  if(Provider.of<DietProvider>(context, listen: false).getIsAlternativeMealSelected()){
                    Provider.of<DietProvider>(context, listen: false).deselectAlternativeMeal();
                  }
                  Provider.of<DietProvider>(context, listen: false).setDayDetailPresenter(index, context);
                  Provider.of<DietProvider>(context, listen: false).firstDayEntry = true;
                  setState(() {
                    selected = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: selected == index? primaryColor : Colors.transparent,
                  ),
                  child: Text( setDayByDayIndex(Provider.of<DietViewModel>(context, listen: false).getDaysForDetail()[index].weekday),
                    style: TextStyle(fontWeight: FontWeight.bold, color: selected == index? Colors.white : Colors.black),),
                ),
              );
            }),),
          Provider.of<DietProvider>(context).getDietDayDetailViewModel().getThereAreDiet() ?
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                gradient: RadialGradient(
                  colors: [
                    cardColor,
                    Colors.white.withOpacity(0.6),
                  ],
                  stops: [0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.005),
                    spreadRadius: 1,
                    blurRadius: 12,
                    offset: const Offset(-5, -5),
                  )
                ],
            ),
            width: size,
            height: size2 * 1.1,
            child: Stack(
                children: [
                  SelectDayPlate(dayMeals: Provider.of<DietProvider>(context).getDietDayDetailViewModel().getDayMeals(),),
                  Positioned(
                    top: size2 * 0.3,
                    child: FoodDetail(
                        notifyParent: refresh,
                        meal: Provider.of<DietProvider>(context).getIsAlternativeMealSelected() ?
                        Provider.of<DietProvider>(context).getDietDayDetailViewModel().getAlternativeMeal() :
                        Provider.of<DietProvider>(context).getDietDayDetailViewModel().getMealSelected()),
                  ),
                  Positioned(
                    right: 15,
                    top: size2 * 0.2,
                    child: CircleAvatar(
                      backgroundImage:
                      Provider.of<DietProvider>(context).getIsAlternativeMealSelected() ?
                      NetworkImage(
                          Provider.of<DietProvider>(context).getDietDayDetailViewModel().getAlternativeMeal().imageUrl != null && Provider.of<DietProvider>(context).getDietDayDetailViewModel().getAlternativeMeal().imageUrl != "" ?
                          Provider.of<DietProvider>(context).getDietDayDetailViewModel().getAlternativeMeal().imageUrl! :
                          "https://blogladiadoresfit.com/wp-content/uploads/2021/02/avena-fitness.jpg"
                      ) :
                      NetworkImage(
                          Provider.of<DietProvider>(context).getDietDayDetailViewModel().getMealSelected().imageUrl != null && Provider.of<DietProvider>(context).getDietDayDetailViewModel().getMealSelected().imageUrl != "" ?
                          Provider.of<DietProvider>(context).getDietDayDetailViewModel().getMealSelected().imageUrl! :
                          "https://blogladiadoresfit.com/wp-content/uploads/2021/02/avena-fitness.jpg"
                      ),
                      radius: 80,
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: size2 * 0.32,
                    child: CircleAvatar(
                      backgroundColor: chatCardPrimaryColor,
                      radius: 28,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Porción', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white),),
                          Provider.of<DietProvider>(context).getIsAlternativeMealSelected() ?
                          Text(Provider.of<DietProvider>(context).getDietDayDetailViewModel().getAlternativeMeal().gramsPortion.toString() + ' gr', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold ),)
                           :
                          Text(Provider.of<DietProvider>(context).getDietDayDetailViewModel().getMealSelected().gramsPortion.toString() + ' gr', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),),

                        ],
                      ),
                    ),
                  ),
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
                padding: EdgeInsets.only(top: size2/20, bottom: size2 * 0.02),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
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