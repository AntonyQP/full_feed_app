import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:full_feed_app/model/entities/patient.dart';
import 'package:full_feed_app/util/MultipartRequestEx.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/dtos/doctor_register_dto.dart';
import '../../model/dtos/patient_update_dto.dart';
import '../../model/dtos/preference_register_dto.dart';
import '../../model/entities/doctor.dart';
import '../../model/entities/nutrition_stat.dart';
import '../../model/entities/region.dart';
import '../../model/entities/user_session.dart';
import '../../model/entities/weight_history.dart';
import '../../util/connection_tags.dart';
import '../../util/util.dart';
import '../../view_model/profile_view_model.dart';

class UserService{

  Future<bool> registerAndLogin(Map<dynamic, dynamic> patientRegisterDto, Map<dynamic, dynamic> userLoginDto) async{
    await registerPatient(patientRegisterDto).whenComplete(() {
      loginUser(userLoginDto);
    });
    return true;
  }

  Future<int> loginUser(Map<dynamic, dynamic> userLoginDto) async{

    var api = baseUrl + userEndpoint + userLogin;
    int errorCode = 0;

    final dio = Dio();
    Response response = await dio.post(api, data: userLoginDto);
    errorCode = response.data["errorCode"];

    if(response.statusCode == 200 && response.data['data'] != null){
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      UserSession().create(response.data["data"]["profile"]["user"]["userId"], response.data["data"]["profile"]["user"]["username"],
          response.data["data"]["profile"]["user"]["firstName"], response.data["data"]["profile"]["user"]["lastName"],
          response.headers.value("Token")!, response.data["data"]["profile"]["user"]["rol"], int.parse(response.headers.value("Firstdayofweek")!),
          response.headers.value("Date")!, response.data["data"]["profile"]["user"]["dni"]);
      if(UserSession().rol == "p"){
        UserSession().setProfileId(response.data["data"]["profile"]["patientId"]);
      }
      else{
        UserSession().setProfileId(response.data["data"]["profile"]["doctorId"]);
        UserSession().setActivePatients(response.data["data"]["profile"]["activePatients"]);
      }

      _prefs.setString("full_feed_email", userLoginDto['email']);
      _prefs.setString("full_feed_password", userLoginDto['password']);

      return errorCode;
    }

    return errorCode;
  }

  Future<bool> getUserSuccessfulDays() async{
    var api = baseUrl + patientEndpoint + successfulDays;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(api, queryParameters: {'patientId' : UserSession().profileId});

    if(response.statusCode == 200){
      UserSession().setSuccessfulDays(response.data['data']['successfulDays']);
      UserSession().lossWeight = response.data['data']['lostWeight'];
      return true;
    }
    return false;
  }

  Future<List<NutritionStat>> getConsumedBalance() async{
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 6));

    var api = baseUrl + nutritionalPlanEndpoint + consumedBalance;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(api, queryParameters: {'endDate' : dateFormat.format(endDate), 'startDate' : dateFormat.format(startDate), 'patientId' : UserSession().profileId});

    if(response.statusCode == 200){
      List aux = response.data['data'].map((e) => NutritionStat.fromJson(e)).toList();
      return aux.cast<NutritionStat>();
    }
    return [];
  }

  Future<List<WeightHistory>> getWeightEvolution() async{
    var api = baseUrl + nutritionalPlanEndpoint + weightEvolution;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(api, queryParameters: {'patientId' : UserSession().profileId});

    if(response.statusCode == 200){
      List aux = response.data['data'].map((e) => WeightHistory.fromJson(e)).toList();
      return aux.cast<WeightHistory>();
    }
    return [];
  }

  Future<List> getConsumedBalanceByPatient(int patientId) async{

    List charts = [];

    List<CarbohydrateData> carbohydrateChartData = [
      CarbohydrateData(0, 'Lun'),
      CarbohydrateData(0, 'Mar'),
      CarbohydrateData(0, 'Mie'),
      CarbohydrateData(0, 'Jue'),
      CarbohydrateData(0, 'Vie'),
      CarbohydrateData(0, 'Sab'),
      CarbohydrateData(0, 'Dom'),
    ];

    List<ProteinData> proteinChartData = [
      ProteinData(0, 'Lun'),
      ProteinData(0, 'Mar'),
      ProteinData(0, 'Mie'),
      ProteinData(0, 'Jue'),
      ProteinData(0, 'Vie'),
      ProteinData(0, 'Sab'),
      ProteinData(0, 'Dom'),
    ];

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 6));

    var api = baseUrl + nutritionalPlanEndpoint + consumedBalance;
    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";
    Response response;
    response = await dio.get(api, queryParameters: {'endDate' : dateFormat.format(endDate), 'startDate' : dateFormat.format(startDate), 'patientId' : patientId});
    if(response.statusCode == 200){
      List aux = response.data['data'].map((e) => NutritionStat.fromJson(e)).toList();
      List<NutritionStat> nutritionStats = aux.cast<NutritionStat>();
      for(int i = 0; i < nutritionStats.length; i++){
        carbohydrateChartData.add(CarbohydrateData(nutritionStats[i].carbohydrates!, getDay(nutritionStats[i].date!)));
        proteinChartData.add(ProteinData(nutritionStats[i].protein!, getDay(nutritionStats[i].date!)));
      }
    }

    charts.add(carbohydrateChartData);
    charts.add(proteinChartData);

    return charts;
  }

  Future<List<WeightData>> getWeightEvolutionByPatient(int patientId) async{

    List<WeightData> chartData = [
      WeightData(null, 'Ene'),
      WeightData(null, 'Feb'),
      WeightData(null, 'Mar'),
      WeightData(null, 'Abr'),
      WeightData(null, 'May'),
      WeightData(null, 'Jun'),
      WeightData(null, 'Jul'),
      WeightData(null, 'Ago'),
      WeightData(null, 'Set'),
      WeightData(null, 'Oct'),
      WeightData(null, 'Nov'),
      WeightData(null, 'Dic'),
    ];

    var api = baseUrl + nutritionalPlanEndpoint + weightEvolution;
    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";
    Response response;
    response = await dio.get(api, queryParameters: {'patientId' : patientId});
    if(response.statusCode == 200){
      List aux = response.data['data'].map((e) => WeightHistory.fromJson(e)).toList();
      List<WeightHistory> weightHistory = aux.cast<WeightHistory>();
      for(int i = 0; i < weightHistory.length; i++){
        chartData.add(WeightData(weightHistory[i].weight!, getMonth(weightHistory[i].date!)));
      }
    }
    return chartData;
  }


  Future<bool> registerPatient(Map<dynamic, dynamic> newPatient) async{

    // var api = baseUrl + userEndpoint + patientRegister;
    //
    // final dio = Dio();
    // Response response;
    // response = await dio.post(api, data: newPatient);
    // if(response.statusCode == 201){
    //   return true;
    // }
    // return false;

    String newPatientJson = json.encode(newPatient);

    MultipartField request = MultipartField(newPatientJson,headers: {
      Headers.contentTypeHeader : Headers.jsonContentType
    });

    var uri = Uri.parse(baseUrl + userEndpoint + patientRegister);
    var req = MultipartRequestEx('POST', uri)
      ..fields["request"] = request;

    print(newPatient.toString());


    final response = await req.send();
    final respStr = await response.stream.bytesToString();
    print(respStr);

    if(response.statusCode == 201){
      return true;
    }
    return false;
  }


  Future<bool> registerDoctor(Map<dynamic, dynamic> newDoctor) async{

    var api = baseUrl + userEndpoint + doctorRegister;

    final dio = Dio();
    Response response;
    response = await dio.post(api, data: newDoctor);
    if(response.statusCode == 201){
      return true;
    }
    return false;
  }

  Future<List<Region>> getAllRegions() async{

    var api = baseUrl + regionEndpoint + allRegion;

    final dio = Dio();
    Response response;
    response = await dio.get(api);
    if(response.statusCode == 200){
      List aux = response.data['data'].map((e) => Region.fromJson(e)).toList();
      return aux.cast<Region>();

    }
    return [];
  }

  Future<List<Patient>> getPatientsByDoctor() async{
    var api = baseUrl + doctorEndpoint + getPatientsByDoctorEndpoint;

    final dio = Dio();
    Response response;
    response = await dio.get(api, queryParameters: {'doctorId' : UserSession().profileId});
    if(response.statusCode == 200){
      List aux = response.data['data'].map((e) => Patient.fromJson(e)).toList();
      return aux.cast<Patient>();
    }
    return [];
  }

  Future<Doctor> getDoctorByPatient() async{
    var api = baseUrl + patientEndpoint + getDoctor;

    final dio = Dio();

    Response response = await dio.get(api, queryParameters: {'patientId' : UserSession().profileId});
    if(response.statusCode == 200){
      return Doctor.fromJson(response.data['data']);
    }
    return Doctor();
  }

  Future<bool> registerPreferences(List<PreferenceRegisterDto> preferences) async{
    var api = baseUrl + patientEndpoint + preferencesEndpoint;
    final dio = Dio();

    Response response = await dio.post(api, queryParameters: {'patientId' : UserSession().profileId}, data: jsonEncode(preferences));

    if(response.statusCode == 201){
      return true;
    }
    return false;
  }

  Future<List<Doctor>> getDoctors() async{
    var api = baseUrl + doctorEndpoint;
    final dio = Dio();
    Response response;
    response = await dio.get(api);
    if(response.statusCode == 200){
      List aux = response.data['data'].map((e) => Doctor.fromJson(e)).toList();
      return aux.cast<Doctor>();
    }
    return [];
  }


  Future<String> getAccessCode() async{
    var api = baseUrl + doctorEndpoint + generateAccessCode;
    final dio = Dio();
    Response response;
    response = await dio.get(api, queryParameters: {'doctorId' : UserSession().profileId});
    if(response.statusCode == 200){
      return response.data['data'];
    }
    return "";
  }

  Future<bool> validateAccessCode(String accessCode) async{
    var api = baseUrl + patientEndpoint + validateAccessCodeEndpoint;
    final dio = Dio();
    Response response;
    response = await dio.get(api, queryParameters: {'accessCode' : accessCode});
    if(response.statusCode == 200){
      return response.data['data'];
    }
    return false;
  }

  Future<Patient> updatePatientInfo(PatientUpdateDto patientUpdateDto) async {
    var api = baseUrl + patientEndpoint + updatePatient;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.put(api, data: patientUpdateDto.toJson());
    if(response.statusCode == 200){
      return Patient.fromJson(response.data['data']);
    }
    return Patient();
  }
}