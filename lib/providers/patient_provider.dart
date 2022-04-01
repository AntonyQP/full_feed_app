import 'package:flutter/cupertino.dart';

class PatientProvider with ChangeNotifier {

  bool _isPatientUpdating = false;

  setPatientUpdating(bool newState){
    _isPatientUpdating = newState;
    notifyListeners();
  }

  getIsPatientUpdating(){
    return _isPatientUpdating;
  }
}
