import 'package:flutter/material.dart';
import 'package:full_feed_app/util/colors.dart';
import 'package:provider/provider.dart';

import '../../../model/entities/preference.dart';
import '../../../providers/user_provider.dart';
import '../../../view_model/register_view_model.dart';
import '../../widget/authentication/food_check_item.dart';


class UserAllergiesScreen extends StatefulWidget {
  final String type;
  final Function goToNextPage;
  const UserAllergiesScreen({Key? key, required this.type, required this.goToNextPage}) : super(key: key);

  @override
  _UserAllergiesScreenState createState() => _UserAllergiesScreenState();
}

class _UserAllergiesScreenState extends State<UserAllergiesScreen> with
    AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Preference> _meats = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("meat");
    List<Preference> _seaFood = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("seaFood");
    List<Preference> _vegetables = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("vegetable");
    List<Preference> _tubers = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("tuber");
    List<Preference> _fruits = Provider.of<RegisterViewModel>(context, listen: false).getListPreferenceOf("fruit");

    var size = MediaQuery.of(context).size;
    return Flexible(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: size.width/10, top: size.height/30, bottom: size.height/60),
            child: const Align(
                alignment: Alignment.topLeft,
                child: Text('Selecciona que comidas te provocan alergías', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),)),),
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
                        type: widget.type,
                        preference: _meats[index],
                        imagePath: 'assets/1.png',
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
              child: Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(_seaFood.length, (index) =>
                      FoodItem(
                        type: widget.type,
                        preference: _seaFood[index],
                        imagePath: 'assets/1.png',
                        color: seaFoodItemColor,
                      ),),
                ),
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(left: size.width/10),
            child: const Align(
                alignment: Alignment.topLeft,
                child: Text('Verduras', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height/50),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(_vegetables.length, (index) =>
                      FoodItem(
                        type: widget.type,
                        preference: _vegetables[index],
                        imagePath: 'assets/1.png',
                        color: vegetableItemColor,
                      ),),
                ),
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
              child: Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(_tubers.length, (index) =>
                      FoodItem(
                        type: widget.type,
                        preference: _tubers[index],
                        imagePath: 'assets/1.png',
                        color: proteinItemColor,
                      ),
                  ),
                ),
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
              child: Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 8.0,
                  children: List.generate(_fruits.length, (index) =>
                      FoodItem(
                        type: widget.type,
                        preference: _fruits[index],
                        imagePath: 'assets/1.png',
                        color: fruitItemColor,
                      ),),
                ),
              ),
            ),),
          SizedBox(height: size.height/20,),
          FloatingActionButton(
            onPressed: (){
              widget.goToNextPage();
              // bool isValid = _rolFormKey.currentState!.validate();
              // if(isValid){
              //   _rolFormKey.currentState!.save();
              //
              // }
            },
            elevation: 1,
            child: Ink(
              width: 200,
              height: 200,
              decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: LinearGradient(
                      colors: [primaryColor, Color(0xFFFF9FC8)],
                      stops: [0.05, 1]
                  )
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 25),
            ),
          ),
          SizedBox(height: size.height/20,),
        ],
      ),
    ) ;
  }
}
