import 'package:flutter/cupertino.dart';
import 'package:full_feed_app/domain/service/user_service.dart';

import '../model/dtos/user_login_dto.dart';


class LoginViewModel extends ChangeNotifier{

  final Map<dynamic, dynamic> _userLoginDto = UserLoginDto("", "").toJson();
  final UserService _userService = UserService();
  late String _errorMessage = "";
  bool _canLogin = false;

  String getErrorMessage(){
    return _errorMessage;
  }

  setUserLoginDto(String value, dynamic newValue){
    _userLoginDto[value] = newValue;
  }

  Future<bool> doLogin() async{
    await _userService.loginUser(_userLoginDto).then((value){
      if(value == 0){
        _canLogin = true;
      }
      else{
        switch(value){
          case 1:
            _errorMessage = "Usuario no registrado";
            break;
          case 2:
            _errorMessage = "Contraseña incorrecta";
            break;
        }
        _canLogin = false;
      }
    });

    return _canLogin;
  }
}