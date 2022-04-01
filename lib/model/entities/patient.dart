
import 'package:full_feed_app/model/entities/user.dart';

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
  final int? firstDayOfWeek;

  Patient({this.patientId, this.arm, this.age, this.tmb, this.height, this.weight, this.imc, this.abdominal, this.user, this.firstDayOfWeek});

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

