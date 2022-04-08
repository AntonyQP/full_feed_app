import 'package:flutter/material.dart';
import 'package:full_feed_app/domain/service/illness_service.dart';
import 'package:full_feed_app/model/entities/illness.dart';
import 'package:full_feed_app/view_model/illness_view_model.dart';

class IllnessListViewModel extends ChangeNotifier {

  final IllnessService _service = IllnessService();

  final List<IllnessViewModel> _illnessesList = [];

  final List<IllnessViewModel> _patientIllnessesList = [];

  late List<IllnessViewModel> _registerPatientIllnesses;

  setPatientIllnesses(List<IllnessViewModel> illnesses) {
    _registerPatientIllnesses = illnesses;
  }

  List<IllnessViewModel> getIllnesses(){
    return _illnessesList;
  }

  List<IllnessViewModel> getPatientIllnesses(){
    return _patientIllnessesList;
  }

  Future<void> populateIllnessesList() async {

    _illnessesList.clear();

    List<Illness> auxList =  await _service.getAllIllnesses();

    for(var illness in auxList) {
      _illnessesList.add(IllnessViewModel(illness: illness));
    }

  }

  Future<void> populateIllnessesByPatient() async {

    _patientIllnessesList.clear();

    List<Illness> auxList =  await _service.getIllnessesByPatient();

    for(var illness in auxList) {
      _patientIllnessesList.add(IllnessViewModel(illness: illness));
    }

  }

  Future<bool> registerPatientIllnesses() async {
    List<int> illnessesIds = [];

    for (var illnesses in _registerPatientIllnesses) {
      illnessesIds.add(illnesses.illnessId!);
    }

    await _service.registerPatientIllnesses(illnessesIds).then((value){
      if(value == true) {
        return true;
      }
    });

    return false;

  }

}