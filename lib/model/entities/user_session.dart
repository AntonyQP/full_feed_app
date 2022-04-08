class UserSession {

  int userId = 0, profileId = 0, firstDayOfWeek = 0, successfulDays = 0, lossWeight = 0, activePatients = 0;
  String userName = "", userLastName = "", userFirstName = "", token = "", rol="", date = "", dni = "";
  double arm = 0.0, tmb = 0.0, abdominal = 0.0, weight = 0.0, height = 0.0, bmi = 0.0;

  static final UserSession _singleton = UserSession._internal();

  factory UserSession() {
    return _singleton;
  }

  UserSession._internal();

  create(int _userId, String _userName, String _userFirstName, String _userLastName, String _token, String _rol, int _firsDayOfWeek, String _date, String _dni){
    userId = _userId;
    userName = _userName;
    userFirstName = _userFirstName;
    userLastName = _userLastName;
    token = _token;
    rol = _rol;
    firstDayOfWeek = _firsDayOfWeek;
    date = _date;
    dni = _dni;
  }

  setProfileId(int _profileId){
    profileId = _profileId;
  }

  //Setters
  setUserId(_userId){ userId = _userId; }
  setSuccessfulDays(_successfulDays){
    double sd = _successfulDays/5;
    successfulDays = sd.floor();

  }

  setSize(double _arm, double _tmb, double _abdominal,double _weight, double _height, double _bmi){
    arm = _arm;
    tmb = _tmb;
    abdominal = _abdominal;
    weight = _weight;
    height = _height;
    bmi =_bmi;
  }

  logOut(){
    userId = 0;
    profileId = 0;
    firstDayOfWeek = 0; successfulDays = 0; lossWeight = 0; activePatients = 0;
    userName = "";
    userLastName = "";
    userFirstName = "";
    token = "";
    rol="";
    date = "";
  }

  setSystemId(_systemId){ userId = _systemId; }
  setUserName(_userName){ userName = _userName; }
  setUserLastName(_userLastName){ userLastName = _userLastName; }
  setActivePatients(_activePatients){ activePatients = _activePatients;}
}