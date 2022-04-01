class DoctorRegisterDto {
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
  final String licenseNumber;

  DoctorRegisterDto(this.username, this.firstName, this.lastName, this.dni, this.email, this.password, this.rol, this.sex,
      this.birthDate, this.phone, this.licenseNumber);

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
    'licenseNumber' : licenseNumber,
  };


}