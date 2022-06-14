import 'package:flutter/material.dart';
import 'package:full_feed_app/model/entities/preference.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:provider/provider.dart';

import '../../../view/widget/authentication/food_check_item.dart';
import '../../../util/colors.dart';
import 'loading_screen.dart';


class UserLikesScreen extends StatefulWidget {
  final String type;
  final Function goToNextPage;
  const UserLikesScreen({Key? key, required this.type, required this.goToNextPage}) : super(key: key);

  @override
  _UserLikesScreenState createState() => _UserLikesScreenState();
}

class _UserLikesScreenState extends State<UserLikesScreen> with
    AutomaticKeepAliveClientMixin{

  late Future _future;

  @override
  void initState() {
    _future = Provider.of<RegisterViewModel>(context, listen: false).registerAndLogin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    List<Preference> _meats = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("meat");
    List<Preference> _seaFood = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("seaFood");
    List<Preference> _vegetables = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("vegetable");
    List<Preference> _tubers = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("tuber");
    List<Preference> _fruits = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("fruit");

    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: Future.wait([
          _future
        ]),
        builder: (context, snapshot){
          if((snapshot.data == false || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting)){
            return const LoadingScreen(text: "Estamos configurando tu cuenta...", generateDiet: false,);
          }
          else{
            return SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width/10, top: size.height/30, bottom: size.height/60),
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Selecciona que comidas te gustan de la siguiente lista.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),)),),
                    Padding(
                      padding: EdgeInsets.only(left: size.width/10),
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Carnes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height/50),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: List.generate(_meats.length, (index) =>
                                FoodItem(
                                  type: "FAVORITE",
                                  preference: _meats[index],

                                  color: meatItemColor,
                                ),),
                          ),
                        ),
                      ),),
                    Padding(
                      padding: EdgeInsets.only(left: size.width/10),
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Mariscos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height/50),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: List.generate(_seaFood.length, (index) =>
                              FoodItem(
                                type: "FAVORITE",
                                preference: _seaFood[index],

                                color: seaFoodItemColor,
                              ),),
                        ),
                      ),),
                    Padding(
                      padding: EdgeInsets.only(left: size.width/10),
                      child: const Align (
                          alignment: Alignment.topLeft,
                          child: Text('Verduras', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height/50),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: List.generate(_vegetables.length, (index) =>
                              FoodItem(
                                type: "FAVORITE",
                                preference: _vegetables[index],

                                color: vegetableItemColor,
                              ),),
                        ),
                      ),),
                    Padding(
                      padding: EdgeInsets.only(left: size.width/10),
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Tuberculos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height/50),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: List.generate(_tubers.length, (index) =>
                              FoodItem(
                                type: "FAVORITE",
                                preference: _tubers[index],

                                color: proteinItemColor,
                              ),),
                        ),
                      ),),
                    Padding(
                      padding: EdgeInsets.only(left: size.width/10),
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Frutas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height/50),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: List.generate(_fruits.length, (index) =>
                              FoodItem(
                                type: widget.type,
                                preference: _fruits[index],

                                color: fruitItemColor,
                              ),),
                        ),
                      ),),
                    SizedBox(height: size.height/20,),
                    FloatingActionButton(
                      onPressed: (){
                        Provider.of<RegisterViewModel>(context, listen: false).registerPreferences().then((value){
                          if(value){
                            widget.goToNextPage();
                          }
                        });

                      },
                      elevation: 1,
                      child: Ink(
                        width: 200,
                        height: 200,
                        decoration: const ShapeDecoration(
                            shape: CircleBorder(),
                            gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                stops: [0.05, 1]
                            )
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 25),
                      ),
                    ),
                    SizedBox(height: size.height/20,),
                  ],
                ),
              ),
            );
          }
        }
    );
  }
}
