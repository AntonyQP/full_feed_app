
import 'dart:ui';

import 'package:full_feed_app/model/entities/user.dart';
import 'package:full_feed_app/util/util.dart';

class Patient {
  final int? patientId;
  final double? arm;
  final int? age;
  final double? tmb;
  final double? height;
  final double? weight;
  final double? imc;
  final double? abdominal;
  final User? user;
  int? firstDayOfWeek;
  Color? stateColor;
  String? stateName;

  setFirstDayOfWeek(int _firstDayOfWeek){
    firstDayOfWeek = _firstDayOfWeek;
  }

  setState(){
    stateColor = setPatientStateColor(imc!);
    stateName = setPatientStateName(imc!);
  }

  Patient({this.patientId, this.arm, this.age, this.tmb, this.height, this.weight, this.imc, this.abdominal, this.user, this.firstDayOfWeek}){
   if(imc != null){
     stateColor = setPatientStateColor(imc!);
     stateName = setPatientStateName(imc!);
   }
  }

  factory Patient.fromJson(dynamic json) {

    Map<String, dynamic> patientJson = json;
    return Patient(
      patientId: patientJson['patientId'],
      age: patientJson['age'],
      arm: patientJson['arm'],
      firstDayOfWeek: patientJson['firstDayOfWeek'],
      tmb: patientJson['tmb'],
      height: patientJson['height'],
      weight: patientJson['weight'],
      imc: patientJson['imc'],
      abdominal: patientJson['abdominal'],
      user: User.fromJson(patientJson['user']),
    );
  }
}

