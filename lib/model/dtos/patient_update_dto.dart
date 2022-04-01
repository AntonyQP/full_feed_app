class PatientUpdateDto{

  final int patientId;
  final double height;
  final double imc;
  final double weight;

  PatientUpdateDto(this.patientId, this.height, this.imc, this.weight);


  Map toJson() =>{
    'abdominal': 0,
    'arm': 0,
    'height': height,
    'imc': imc,
    'patientId': patientId,
    'tmb': 0,
    'weight': weight
  };
}