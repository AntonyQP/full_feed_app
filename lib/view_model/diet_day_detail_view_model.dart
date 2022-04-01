

import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/domain/service/diet_service.dart';
import 'package:full_feed_app/model/dtos/meal_replace_dto.dart';
import 'package:full_feed_app/model/entities/meal.dart';

class ProteinDetail extends ChangeNotifier{
  final String protein;
  final double q;

  ProteinDetail(this.protein, this.q);
}


class DietDayDetailViewModel{
  List<ProteinDetail> chartData = [];

  late List<Meal> _dayMeals = [];
  late Meal _mealSelected;
  late MealReplaceDto mealToReplace;
  late Meal _alternativeMeal;
  late List<String> _ingredients;
  late List<Meal> _alternativeMealList = [];

  final DietService _dietService = DietService();

  List<String> getIngredients(){
    return _ingredients;
  }

  Future<void> completeMeal(int mealId) async {
    await _dietService.setCompleteMeal(mealId).then((newMeal){
      if(newMeal.status != null){
        setMealState(newMeal, mealId);
      }
    });
  }

  Future<void> restoreMeal(int mealId) async {
    await _dietService.setRestoreMeal(mealId).then((newMeal){
      if(newMeal.status != null){
        setMealState(newMeal, mealId);
      }
    });
  }

  setMealState(Meal meal, int mealId){
    int index = _dayMeals.indexOf(_dayMeals.where((element) => element.mealId == mealId).first);
    _dayMeals[index] = meal;
  }

  DietDayDetailViewModel(List<Meal> _meals){
    _dayMeals = _meals;
    _mealSelected = _dayMeals[0];
    _alternativeMeal = Meal();
    _dietService.getAlternativeMeals(_mealSelected).then((mealList){
      _alternativeMealList = mealList;
    });
  }

  setMealSelected(Meal meal){
    _mealSelected = meal;
  }

  setAlternativeMeal(int index){
    _alternativeMeal = _alternativeMealList[index];
  }

  Future<List<Meal>> setAlternativeMealList(bool isAlternativeMealSelected, Meal meal) async {
    if(isAlternativeMealSelected){
      _alternativeMealList = _alternativeMealList;
    }
    else{
      await _dietService.getAlternativeMeals(_mealSelected).then((mealList){
        _alternativeMealList = mealList;
      });
    }
    return _alternativeMealList;
  }

  List<Meal> getAlternativeMealList(){
    return _alternativeMealList;
  }

  Meal getMealSelected(){
    return _mealSelected;
  }

  Meal getAlternativeMeal(){
    return _alternativeMeal;
  }

  List<Meal> getDayMeals(){
    return _dayMeals;
  }

  prepareNewMeal(){
    mealToReplace = MealReplaceDto(_mealSelected.mealId!, _alternativeMeal.name!, _alternativeMeal.carbohydrates!,
        _alternativeMeal.fat!, _alternativeMeal.gramsPortion!, _alternativeMeal.ingredients!, _alternativeMeal.protein!, _alternativeMeal.totalCalories!,
        _alternativeMeal.imageUrl!);
  }

  afterMealChanged(Meal newMeal){
    for(int i = 0; i < _dayMeals.length; i++){
      if(_dayMeals[i].mealId == newMeal.mealId){
        _dayMeals[i] = newMeal;
      }
    }
    _mealSelected = newMeal;
  }

  List<String> splitIngredients(Meal meal){
    _ingredients = meal.ingredients!.split('-');
    for(int i =0; i< _ingredients.length; i ++){
      _ingredients[i] = _ingredients[i].substring(0, 1) + _ingredients[i].substring(1).toLowerCase();
    }

    return _ingredients;
  }

  List<ProteinDetail> generateData(Meal meal){

    if(chartData.isNotEmpty){
      chartData.clear();
    }
    if(_alternativeMeal.name != null){
      chartData = [
        ProteinDetail('Peso', double.parse(_alternativeMeal.gramsPortion.toString())),
        ProteinDetail('Grasas', double.parse(_alternativeMeal.fat.toString())),
        ProteinDetail('Proteinas', double.parse(_alternativeMeal.protein.toString())),
        ProteinDetail('Carbohidratos', double.parse(_alternativeMeal.carbohydrates.toString())),
      ];
    }
    else{
      chartData = [
        ProteinDetail('Peso', double.parse(_mealSelected.gramsPortion.toString())),
        ProteinDetail('Grasas', double.parse(_mealSelected.fat.toString())),
        ProteinDetail('Proteinas', double.parse(_mealSelected.protein.toString())),
        ProteinDetail('Carbohidratos', double.parse(_mealSelected.carbohydrates.toString())),
      ];
    }

    return chartData;
  }

}