import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/domain/service/diet_service.dart';
import 'package:full_feed_app/model/entities/patient.dart';
import 'package:full_feed_app/view_model/diet_day_detail_view_model.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../model/entities/meal.dart';
import '../model/entities/user_session.dart';
import '../util/util.dart';

class DietViewModel extends ChangeNotifier {

  final int _dietFirstDay = UserSession().firstDayOfWeek;
  late Patient _patient;
  late DateTime _initialDate;
  late DateTime _lastDate;
  late List<Meal> _weekMealList;
  final List<DateTime> _daysForDetail = [];
  final List<DietDayDetailViewModel> _dietDayViewModels = [];
  final DateRangePickerController _controller = DateRangePickerController();
  final DietService _dietService = DietService();


  DateRangePickerController getController(){
    return _controller;
  }

  List<DateTime> getDaysForDetail(){
    return _daysForDetail;
  }

  setPatient(Patient patient){
    _patient = patient;
  }

  List<DietDayDetailViewModel> getDietDayViewModels(){
    return _dietDayViewModels;
  }

  // DietViewModel(BuildContext _context, Patient? patient) {
  //   if(isPatient()){
  //     _dietFirstDay = UserSession().firstDayOfWeek;
  //   }
  //   else{
  //     _patient = patient!;
  //     _dietFirstDay = patient.firstDayOfWeek!;
  //   }
  // }

  initDaysAtRegister(String date){
    _initialDate = DateTime.parse(date);
    _lastDate = _initialDate.add(const Duration(days: 6));
    getDays();
    //initWeekMealList(_weekMealList);
  }

  Future<bool> initWeekMealList() async{
    if(_weekMealList.isNotEmpty){
      if(_dietDayViewModels.isNotEmpty){
        _dietDayViewModels.clear();
      }

      for(int i = 0; i < _daysForDetail.length; i++) {
        _dietDayViewModels.add(DietDayDetailViewModel(getDayMeals(DateFormat('yyyy-MM-dd').format(_daysForDetail[i]))));
      }
    }
    return _weekMealList.isNotEmpty;
  }

  bool isSameDate(dynamic date1, dynamic date2) {
    if (date2 == date1) {
      return true;
    }

    if (date1 == null || date2 == null) {
      return false;
    }

    return date1.month == date2.month &&
        date1.year == date2.year &&
        date1.day == date2.day;
  }

  getDays(){
    _daysForDetail.clear();
    for(int i = 0; i < 7; i ++){
      _daysForDetail.add(_initialDate.add(Duration(days: i)));
    }
  }

  getWeek(DateRangePickerSelectionChangedArgs args){
    int firstDayOfWeek = _dietFirstDay % 7;
    int endDayOfWeek = (firstDayOfWeek - 1) % 7;
    endDayOfWeek = endDayOfWeek < 0? 7 + endDayOfWeek : endDayOfWeek;
    PickerDateRange ranges = args.value;
    DateTime date1 = (ranges.endDate ?? ranges.startDate)!;
    DateTime date2 = (ranges.endDate?? ranges.startDate)!;
    if(date1.isAfter(date2))
    {
      var date=date1;
      date1=date2;
      date2=date;
    }
    int day1 = date1.weekday % 7;
    int day2 = date2.weekday % 7;

    int toAdd1;
    int toAdd2;

    if(date1.weekday < firstDayOfWeek || date1.weekday == 7){
      toAdd2 = endDayOfWeek - day2;
      toAdd1 = -1 * (6 - toAdd2.abs());
    }
    else{
      toAdd1 = firstDayOfWeek - day1;
      toAdd2 = 6 - toAdd1.abs();
    }
    DateTime dat1 = date1.add(Duration(days: toAdd1));
    DateTime dat2 = date2.add(Duration(days: toAdd2));

    if(ranges.endDate == null){
      if(date1.weekday == firstDayOfWeek){
        _controller.selectedRange = PickerDateRange(dat1, dat2);
      }
      else{
        if(!isSameDate(dat1, ranges.startDate))
        {
          _controller.selectedRange = PickerDateRange(dat1, dat2);
        }
      }

      _initialDate = dat1;
      _lastDate = dat2;

    }
  }

  setCalendar(){

    int firstDayOfWeek = _dietFirstDay % 7;
    int endDayOfWeek = (firstDayOfWeek - 1) % 7;
    endDayOfWeek = endDayOfWeek < 0? 7 + endDayOfWeek : endDayOfWeek;
    DateTime date1 = DateTime.now();
    DateTime date2 = DateTime.now();
    if(date1.isAfter(date2))
    {
      var date=date1;
      date1=date2;
      date2=date;
    }
    int day1 = date1.weekday % 7;
    int day2 = date2.weekday % 7;

    int toAdd1;
    int toAdd2;


    if(date1.weekday < firstDayOfWeek || date1.weekday == 7){
      toAdd2 = endDayOfWeek - day2;
      toAdd1 = -1 * (6 - toAdd2.abs());
    }
    else{
      toAdd1 = firstDayOfWeek - day1;
      toAdd2 = 6 - toAdd1.abs();
    }

    DateTime dat1 = date1.add(Duration(days: toAdd1));
    DateTime dat2 = date2.add(Duration(days: toAdd2));

    _controller.selectedRange = PickerDateRange(dat1, dat2);

    _initialDate = dat1;
    _lastDate = dat2;
  }

  List<Meal> getDayMeals(String date){
    var dayMeals = _weekMealList.where((element) => element.day!.substring(0, 10) == date).toList();
    return dayMeals;
  }

  setNewMeal(Meal meal){
    for(int i = 0; i < _weekMealList.length; i++){
      if(_weekMealList[i].mealId == meal.mealId){
        _weekMealList[i] = meal;
      }
    }
  }

  Future<void> generateNutritionPlan(int doctorId) async{
    await _dietService.generateNutritionPlan(UserSession().profileId, doctorId).then((value){
      _weekMealList = value;
      _initialDate = DateTime.parse(value[0].day!);
      getDays();
      for(int i = 0; i < _daysForDetail.length; i++) {
        _dietDayViewModels.add(DietDayDetailViewModel(getDayMeals(DateFormat('yyyy-MM-dd').format(_daysForDetail[i]))));
      }
    });
  }

  Future<void> getWeekDietMeals() async {
    await _dietService.getWeekDietMeals(_initialDate, _lastDate).then((mealList){
      _weekMealList = mealList;
    });
  }

  Future<void> getWeekDietMealsByPatient(Patient patient) async {
    await _dietService.getWeekDietMealsByPatient(patient.patientId!, _lastDate, _initialDate).then((mealList){
      _weekMealList = mealList;
    });
  }

}