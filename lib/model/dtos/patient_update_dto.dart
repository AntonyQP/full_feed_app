class PatientUpdateDto{

  final int patientId;
  final double height;
  final double imc;
  final double weight;
  final double arm;
  final double abdominal;
  final double tmb;

  PatientUpdateDto(this.patientId, this.height, this.imc, this.weight, this.arm, this.abdominal, this.tmb);


  Map toJson() =>{
    'abdominal': abdominal,
    'arm': arm,
    'height': height,
    'imc': imc,
    'patientId': patientId,
    'tmb': tmb,
    'weight': weight
  };
}