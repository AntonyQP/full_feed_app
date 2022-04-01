


import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/model/entities/meal.dart';
import 'package:full_feed_app/view_model/diet_view_model.dart';
import 'package:provider/provider.dart';

import '../view_model/diet_day_detail_view_model.dart';

class DietProvider with ChangeNotifier {

  bool firstDayEntry = true;
  late DietDayDetailViewModel _dayDetailViewModel;

  bool _isAlternativeMealSelected = false;
  int _foodSelectedIndex = 0;

  getAlternativeMealSelected(){
    return _isAlternativeMealSelected;
  }

  homePresenterChange(){
    notifyListeners();
  }

  setMealsReady(bool _mealsReady){
    //homePresenter.mealsReady = _mealsReady;
    notifyListeners();
  }

  bool getIsAlternativeMealSelected(){
    return _isAlternativeMealSelected;
  }

  int getFoodSelectedIndex(){
    return _foodSelectedIndex;
  }

  setDayDetailPresenter(int index, BuildContext context){
    _dayDetailViewModel = Provider.of<DietViewModel>(context, listen: false).getDietDayViewModels()[index];
  }

  setAlternativeMeal(int index){
    _dayDetailViewModel.setAlternativeMeal(index);
    _isAlternativeMealSelected = true;
    notifyListeners();
  }

  deselectAlternativeMeal(){
    _isAlternativeMealSelected = false;
    notifyListeners();
  }

  DietDayDetailViewModel getDietDayDetailViewModel(){
    return _dayDetailViewModel;
  }

  setMealSelected(Meal meal){
    _dayDetailViewModel.setMealSelected(meal);
    notifyListeners();
  }

  // setAlternativeMeal(Meal alternativeMeal, bool _changeFood){
  //   dayDetailPresenter.changeFood = _changeFood;
  //   dayDetailPresenter.alternativeMeal = alternativeMeal;
  //   dayDetailPresenter.splitIngredients(_changeFood);
  //   dayDetailPresenter.generateData();
  //   notifyListeners();
  // }

}
