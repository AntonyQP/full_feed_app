import 'package:flutter/cupertino.dart';

import '../model/entities/patient.dart';

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
