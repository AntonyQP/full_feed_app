class UserLoginDto {
  final String email;
  final String password;

  UserLoginDto(this.email, this.password);

  Map toJson() => {
    'email' : email,
    'password' : password,
  };
}