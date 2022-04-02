
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_feed_app/providers/diet_provider.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:full_feed_app/view/widget/diet_schedule/shimmers/food_option_shimmer.dart';
import 'package:full_feed_app/view_model/diet_view_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../model/entities/meal.dart';
import '../../../view_model/diet_day_detail_view_model.dart';
import 'food_option.dart';
import 'message.dart';

class FoodDetail extends StatefulWidget {

  final Meal meal;
  final Function(String) notifyParent;
  const FoodDetail({Key? key, required this.meal, required this.notifyParent}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FoodDetailState();

}



class FoodDetailState extends State<FoodDetail> {
  int selected = 0;

  _showDialog(){
    showDialog(
      barrierColor: Colors.white70,
      context: context,
      builder: (BuildContext context) {
        return Message(text: '¿Desea continuar con el cambio de dieta?', yesFunction: (){
          Provider.of<DietProvider>(context, listen: false).getDietDayDetailViewModel().prepareNewMeal();
          Provider.of<DietProvider>(context, listen: false).replaceMeal().whenComplete((){
            Navigator.pop(context);
          });
        }, noFunction: (){}, options: true,);
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(horizontal: size.width/20, vertical: size.height/90),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: foodDetailColor,
          ),
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height/80),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Align(
                          alignment: Alignment.center,
                          heightFactor: size.width/500,
                          widthFactor: size.width/500,
                          child: Image.network("https://blogladiadoresfit.com/wp-content/uploads/2021/02/avena-fitness.jpg", height: size.width/3,),
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width/40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width/2,
                            child: Text(widget.meal.name.toString(), style: const TextStyle(color: Color(0xFF2D2D2D), fontSize: 15, fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: size.height/80,),
                          Container(
                            padding: const EdgeInsets.all(15),
                            //width: size.width/2.05,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD698),
                              borderRadius: BorderRadius.all(Radius.circular(15.0))
                            ),
                            constraints: BoxConstraints(
                                minHeight: size.height/6, minWidth: size.width/2,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.emoji_food_beverage_rounded, color: Colors.black, size: 10,),
                                    Text('     Ingredientes', style: TextStyle(color: Color(0xFF2D2D2D), fontSize: 10, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                SizedBox(height: size.height/80,),
                                Wrap(
                                  spacing: 2.0,
                                  direction: Axis.vertical,
                                  children: List.generate(Provider.of<DietProvider>(context).getDietDayDetailViewModel().splitIngredients(widget.meal).length, (index){
                                    return Text(Provider.of<DietProvider>(context).getDietDayDetailViewModel().getIngredients()[index], style: const TextStyle(color: Color(0xFF2D2D2D), fontSize: 10),);
                                  }),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),)
                  ],
                ),),
              SizedBox(
                height: size.height/80,
              ),
              SizedBox(
                width: size.width,
                height: size.width/4,
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  palette: const [
                    Color(0XFF02D871),
                    Color(0XFFFFEA29),
                    Color(0XFFFF003E)
                  ],
                  series: <ChartSeries>[
                    BarSeries<ProteinDetail, String>(
                        dataSource: Provider.of<DietProvider>(context).getDietDayDetailViewModel().generateData(widget.meal),
                        xValueMapper: (ProteinDetail pd, _) => pd.protein,
                        yValueMapper: (ProteinDetail pd, _) => pd.q,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(color: Color(0xFF2D2D2D))
                        ))
                  ],
                  primaryXAxis: CategoryAxis(
                    borderColor: Color(0xFFFFCC7E),
                    borderWidth: 2,
                    labelStyle: TextStyle(color: Color(0xFF2D2D2D)),
                    majorGridLines: MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                      isVisible: false
                  ),),
              ),
              Row(
                  children: [
                    const Text("Opciones", style: TextStyle(color: Color(0xFF2D2D2D), fontWeight: FontWeight.bold),),
                    SizedBox(
                      width: size.width/15,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              
                            });
                            //Provider.of<DietProvider>(context, listen: false).getDietDayDetailViewModel().setAlternativeMealList(Provider.of<DietProvider>(context, listen: false).getAlternativeMealSelected(), widget.meal);
                          },
                          icon: Icon(CupertinoIcons.refresh_thin, color: const Color(0xFF2D2D2D), size: size.width/25,)
                      ),
                    )
                  ],
              ),
              FutureBuilder(
                future: Provider.of<DietProvider>(context, listen: false).getDietDayDetailViewModel().setAlternativeMealList(Provider.of<DietProvider>(context, listen: false).getAlternativeMealSelected(), widget.meal),
                builder: (context, snapshot) {
                  return Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(3, (index) {
                      if(Provider.of<DietProvider>(context,listen: false).getDietDayDetailViewModel().getAlternativeMealList().isNotEmpty){
                        return InkWell(
                          onTap: () {
                            Provider.of<DietProvider>(context, listen: false).setAlternativeMeal(index);
                          },
                          child: FoodOption(meal: Provider.of<DietProvider>(context).getDietDayDetailViewModel().getAlternativeMealList()[index]),
                        );
                      }
                      else{
                        return const FoodOptionShimmer();
                      }
                    }),);
                }
              ),
            ],
          ),
        ),
        AnimatedPositioned(
            top: 150,
            left: Provider.of<DietProvider>(context).getIsAlternativeMealSelected() ? size.width/35 : -150.0,
            curve: Curves.fastOutSlowIn,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _showDialog();
                  },
                  child: Icon(CupertinoIcons.arrow_2_circlepath, color: Colors.white, size: size.height/50,),
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(size.height/10, size.height/10),
                    elevation: 0,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(size.height/90),
                    primary: primaryColor, // <-- Button color
                    onPrimary: Colors.white, // <-- Splash color
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Provider.of<DietProvider>(context, listen: false).deselectAlternativeMeal();
                  },
                  child: Icon(CupertinoIcons.xmark, color: Colors.white, size: size.height/50,),
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(size.height/10, size.height/10),
                    elevation: 0,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(size.height/90),
                    primary: Colors.red, // <-- Button color
                    onPrimary: Colors.white, // <-- Splash color
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2))
      ],
    );
  }
}