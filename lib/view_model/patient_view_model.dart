import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/domain/service/user_service.dart';
import 'package:full_feed_app/model/dtos/patient_update_dto.dart';
import 'package:full_feed_app/view_model/profile_view_model.dart';

import '../model/entities/patient.dart';

class PatientViewModel with ChangeNotifier {

  late Patient _patientSelected;
  final UserService _userService = UserService();

  setPatientSelected(Patient _toSelect){
    _patientSelected = _toSelect;
    notifyListeners();
  }

  Patient getPatientSelected(){
    return _patientSelected;
  }

  Future<void> updatePatient(double height, double weight) async {
    double imc = weight/pow(height, 2);
    await _userService.updatePatientInfo(PatientUpdateDto(_patientSelected.patientId!, height, imc, weight)).then((newPatient){
      if(newPatient.patientId == _patientSelected.patientId){
        _patientSelected = newPatient;
      }
    });
  }

  Future<List> getConsumedBalanceOfSelectedPatient() async{
    return _userService.getConsumedBalanceByPatient(_patientSelected.patientId!);
  }

  Future<List<WeightData>> getWeightEvolutionOfSelectedPatient() async{
    return _userService.getWeightEvolutionByPatient(_patientSelected.patientId!);
  }
}
