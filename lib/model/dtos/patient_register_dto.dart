class PatientRegisterDto {
  final String username;
  final String firstName;
  final String lastName;
  final String dni;
  final String email;
  final String password;
  final String rol;
  final String sex;
  final String birthDate;
  final String phone;
  final int regionId;
  final double abdominal;
  final double arm;
  final double imc;
  final double tmb;
  final double height;
  final double weight;

  PatientRegisterDto(this.username, this.firstName, this.lastName, this.dni, this.email, this.password, this.rol, this.sex,
      this.birthDate, this.phone, this.regionId, this.abdominal, this.arm, this.imc, this.tmb, this.height, this.weight);

  Map toJson() => {
    'username' : username,
    'firstName' : firstName,
    'lastName' : lastName,
    'dni' : dni,
    'email' : email,
    'password' : password,
    'rol' : rol,
    'sex' : sex,
    'birthDate' : birthDate,
    'phone' : phone,
    'regionId' : regionId,
    'abdominal' : abdominal,
    'arm' : arm,
    'imc' : imc,
    'tmb' : tmb,
    'height' : height,
    'weight' : weight,
  };
}