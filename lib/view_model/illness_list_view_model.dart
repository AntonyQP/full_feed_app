import 'package:flutter/material.dart';
import 'package:full_feed_app/domain/service/illness_service.dart';
import 'package:full_feed_app/domain/service/user_service.dart';
import 'package:full_feed_app/model/entities/illness.dart';
import 'package:full_feed_app/view_model/illness_view_model.dart';
import 'package:full_feed_app/view_model/patient_view_model.dart';
import 'package:provider/provider.dart';

class IllnessListViewModel extends ChangeNotifier {

  final IllnessService _illnessService = IllnessService();

  final UserService _userService = UserService();

  final List<IllnessViewModel> _illnessesList = [];

  final List<IllnessViewModel> _patientIllnessesList = [];

  //LISTA DESDE DOCTOR

  final List<IllnessViewModel> _selectedPatientIllnessesList = [];

  late List<IllnessViewModel> _registerPatientIllnesses;

  Future<void> setPatientIllnesses(List<IllnessViewModel> illnesses)  async {
    _registerPatientIllnesses = illnesses;
  }

  List<IllnessViewModel> getIllnesses(){
    return _illnessesList;
  }

  List<IllnessViewModel> getPatientIllnesses(){
    return _patientIllnessesList;
  }

  List<IllnessViewModel> getSelectedPatientIllnesses() {
    return _selectedPatientIllnessesList;
  }

  Future<void> populateIllnessesList() async {

    _illnessesList.clear();

    List<Illness> auxList =  await _illnessService.getAllIllnesses();

    for(var illness in auxList) {
      _illnessesList.add(IllnessViewModel(illness: illness));
    }

  }

  Future<void> populateIllnessesByPatient() async {

    _patientIllnessesList.clear();

    List<Illness> auxList =  await _illnessService.getIllnessesByPatient();

    for(var illness in auxList) {
      _patientIllnessesList.add(IllnessViewModel(illness: illness));
    }

  }

  Future<bool> registerPatientIllnesses() async {
    List<int> illnessesIds = [];

    bool returningValue = false;

    for (var illnesses in _registerPatientIllnesses) {
      illnessesIds.add(illnesses.illnessId!);
    }

    await _illnessService.registerPatientIllnesses(illnessesIds).then((value){
      if(value == true) {
        returningValue = true;
      }
    });

    return returningValue;

  }

  Future<void> populateSelectedPatientIllnessesList(BuildContext context) async {
    _selectedPatientIllnessesList.clear();

    await _userService.getPatientIllnessesByDoctor(
        Provider.of<PatientViewModel>(context).getPatientSelected().patientId!).then((illnessesList){
      for(var illness in illnessesList) {
        _selectedPatientIllnessesList.add(IllnessViewModel(illness: illness));
      }
    });


  }

}