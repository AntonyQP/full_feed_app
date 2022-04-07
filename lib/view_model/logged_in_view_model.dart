import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/domain/service/user_service.dart';
import 'package:full_feed_app/model/entities/meal.dart';
import '../domain/service/diet_service.dart';
import '../model/entities/doctor.dart';
import '../model/entities/patient.dart';

class LoggedInViewModel extends ChangeNotifier{

  late List<Patient> _patientsByDoctor = [];
  late List<List<Meal>> _patientsDayMeals = [];
  late List<Meal> _dayMeals = [];
  late Doctor _doctorByPatient;
  bool _getMealsReady = false;
  bool _mealsReady = false;
  final DietService _dietService = DietService();
  final UserService _userService = UserService();

  clean(){
    if(_dayMeals.isNotEmpty){
      _dayMeals.clear();
    }
    if(_patientsByDoctor.isNotEmpty){
      _patientsByDoctor.clear();
    }
  }

  Future<bool> setHomeDietDayMeals() async {
    await _dietService.getDayMeals().then((dayMealList){
      _dayMeals = dayMealList;
      if(_dayMeals.isNotEmpty){
        _getMealsReady = true;
      }
    });
    return _getMealsReady;
  }
  
  Future<void> setHomePatientMeals() async{
    int aux = 0;
    _patientsDayMeals = List.filled(_patientsByDoctor.length, []);
    if(_patientsByDoctor.isEmpty){
     _mealsReady = true;
    }
    else{
      for(int i = 0; i < _patientsByDoctor.length; i++){
        await _dietService.getDayMealsByPatient(_patientsByDoctor[i].patientId!).then((patientMealList){
          _patientsDayMeals[_patientsByDoctor.indexOf(_patientsByDoctor[i])] = patientMealList;
          aux++;
          if(aux == _patientsByDoctor.length){
            _mealsReady = true;
          }
        });
      }
    }
  }

  List<Meal> getDayMeals(){
    return _dayMeals;
  }

  List<List<Meal>> getPatientDayMeals(){
    return _patientsDayMeals;
  }

  Future<void> setPatientsByDoctor() async{
    await _userService.getPatientsByDoctor().then((patientsList){
      _patientsByDoctor = patientsList;
    });
  }


  List<Patient> getPatientsByDoctor(){
    return _patientsByDoctor;
  }

  Doctor getDoctorByPatient(){
    return _doctorByPatient;
  }

  bool getMealsReady(){
    return _mealsReady;
  }

  setMealsReady(bool newState){
    _mealsReady = newState;
  }

  Future<void> setDoctorByPatient() async {
    await _userService.getDoctorByPatient().then((doctor){
      _doctorByPatient = doctor;
    });
  }

  setPatientAfterUpdate(Patient patient){
    for(int i = 0; i < _patientsByDoctor.length; i++){
      if(_patientsByDoctor[i].patientId == patient.patientId){
        _patientsByDoctor[i] = patient;
        notifyListeners();
        break;
      }
    }
  }

  Patient getPatientAt(int patientId){
    return _patientsByDoctor.where((element) => element.patientId == patientId).first;
  }

}