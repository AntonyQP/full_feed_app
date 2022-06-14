import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/domain/local/doctor_notification_service.dart';
import 'package:full_feed_app/domain/service/doctor_service.dart';
import 'package:full_feed_app/model/entities/patient_incomplete.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProvider with ChangeNotifier {

  final DoctorNotificationService _doctorNotificationService = DoctorNotificationService();
  final DoctorService _doctorService = DoctorService();
  final DateTime _actualDateTime = DateTime.now();
  List<PatientIncomplete> _incompleteDietPatientList = [];
  String actualSchedule = "";
  int currentDay = 0;

  bool _alterChecked = false;

  List<PatientIncomplete> incompleteDietPatientList(){
    return _incompleteDietPatientList;
  }

  getAlertChecked(){
    return _alterChecked;
  }

  bool needAlert(){
    if(_incompleteDietPatientList.isNotEmpty && _alterChecked == false){
      return true;
    }
    return false;
  }

  Future<void> getIncompleteDietPatientList() async{
    await _doctorService.patientListThatNotCompleteDayDiet(actualSchedule).then((value){
      _incompleteDietPatientList = value;
    });
  }

  Future<void> setAlertChecked(bool newState) async {
    _alterChecked = newState;
    notifyListeners();

    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    switch(actualSchedule){
      case 'DESAYUNO':
        _prefs.setBool('alertCheckedBreakfast', true);
        break;
      case 'MERIENDA_DIA':
        _prefs.setBool('alertCheckedMealDay', true);
        break;
      case 'ALMUERZO':
        _prefs.setBool('alertCheckedLunch', true);
        break;
      case 'MERIENDA_TARDE':
        _prefs.setBool('alertCheckedMealEvening', true);
        break;
      case 'CENA':
        _prefs.setBool('alertCheckedDinner', true);
        break;
    }

    _prefs.commit();
  }

  getAlertCheckedFromSharedPreferences() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    actualSchedule = _doctorNotificationService.validateMealAtHour(_actualDateTime);

    switch(actualSchedule){
      case 'DESAYUNO':
        _alterChecked = _prefs.getBool('alertCheckedBreakfast') ?? false;
        break;
      case 'MERIENDA_DIA':
        _alterChecked = _prefs.getBool('alertCheckedMealDay') ?? false;
        break;
      case 'ALMUERZO':
        _alterChecked = _prefs.getBool('alertCheckedLunch') ?? false;
        break;
      case 'MERIENDA_TARDE':
        _alterChecked = _prefs.getBool('alertCheckedMealEvening') ?? false;
        break;
      case 'CENA':
        _alterChecked = _prefs.getBool('alertCheckedDinner') ?? false;
        break;
    }

    notifyListeners();
  }

  Future<void> validateActualDate() async{
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    currentDay = _prefs.getInt('lastDay') ?? 0;

    if(currentDay != _actualDateTime.day){

      _prefs.setBool('alertCheckedBreakfast', false);

      _prefs.setBool('alertCheckedMealDay', false);

      _prefs.setBool('alertCheckedLunch', false);

      _prefs.setBool('alertCheckedMealEvening', false);

      _prefs.setBool('alertCheckedDinner', false);

      _prefs.setInt('lastDay', _actualDateTime.day);
      _prefs.commit();
    }
  }

}