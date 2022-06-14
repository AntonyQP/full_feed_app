class PatientIncomplete{
  final int? patientId;
  final String? patientName;

  PatientIncomplete({this.patientId, this.patientName});

  factory PatientIncomplete.fromJson(dynamic json) {

    Map<String, dynamic> patientJson = json;
    return PatientIncomplete(
      patientId: patientJson['patientId'],
      patientName: patientJson['patientName'].toString()
    );
  }
}