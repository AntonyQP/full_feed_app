import 'package:full_feed_app/model/entities/user.dart';

class Doctor {
  final int? doctorId;
  final String? accessCode;
  final int? activePatients;
  final String? licenseNumber;
  final User? user;

  Doctor({this.doctorId, this.activePatients, this.licenseNumber, this.user, this.accessCode});

  factory Doctor.fromJson(dynamic json) {

    Map<String, dynamic> doctorJson = json;
    return Doctor(
      doctorId: doctorJson['doctorId'],
      accessCode: doctorJson['accessCode'],
      activePatients: doctorJson['activePatients'],
      licenseNumber: doctorJson['licenseNumber'],
      user: User.fromJson(doctorJson['user']),
    );
  }
}