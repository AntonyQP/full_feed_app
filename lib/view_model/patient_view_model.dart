import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/domain/service/diet_service.dart';
import 'package:full_feed_app/domain/service/user_service.dart';
import 'package:full_feed_app/model/dtos/patient_update_dto.dart';
import 'package:full_feed_app/model/entities/user_session.dart';
import 'package:full_feed_app/view_model/logged_in_view_model.dart';
import 'package:full_feed_app/view_model/login_view_model.dart';
import 'package:full_feed_app/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../model/entities/patient.dart';

class PatientViewModel with ChangeNotifier {

  late Patient _patientSelected;
  final UserService _userService = UserService();
  final DietService _dietService = DietService();

  setPatientSelected(Patient _toSelect){
    _patientSelected = _toSelect;
    notifyListeners();
  }

  Patient getPatientSelected(){
    return _patientSelected;
  }

  Future<void> updatePatient(double height, double weight, double arm, double abdominal, double tmb, BuildContext context) async {
    double imc = weight/pow(height/100, 2);
    await _userService.updatePatientInfo(PatientUpdateDto(_patientSelected.patientId!, height, imc, weight, arm, abdominal, tmb)).then((newPatient){
      if(newPatient.patientId == _patientSelected.patientId){
        newPatient.setFirstDayOfWeek(_patientSelected.firstDayOfWeek!);
        _patientSelected = newPatient;
        Provider.of<LoggedInViewModel>(context, listen: false).setPatientAfterUpdate(newPatient);
        notifyListeners();
      }
    });
  }

  Future<List> getConsumedBalanceOfSelectedPatient() async{
    return _userService.getConsumedBalanceByPatient(_patientSelected.patientId!);
  }

  Future<List<WeightData>> getWeightEvolutionOfSelectedPatient() async{
    return _userService.getWeightEvolutionByPatient(_patientSelected.patientId!);
  }

  Future<bool> generateNewDiet() async{
    await _dietService.generateNutritionPlan(_patientSelected.patientId!, UserSession().profileId).then((value){
      if(value.isNotEmpty){
        return true;
      }
    });
    return false;
  }


}
