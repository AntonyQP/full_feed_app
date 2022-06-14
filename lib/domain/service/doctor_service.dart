import 'package:dio/dio.dart';
import 'package:full_feed_app/util/connection_tags.dart';

import '../../model/entities/patient_incomplete.dart';
import '../../model/entities/user_session.dart';

class DoctorService{

  Future<List<PatientIncomplete>> patientListThatNotCompleteDayDiet(String schedule) async{
    var api = baseUrl + doctorEndpoint + getPatientThatNotCompleteDayDiet;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(api, queryParameters: {'doctorId' : UserSession().profileId, 'schedule' : schedule });

    if(response.statusCode == 200){
      List aux = response.data['data'].map((e) => PatientIncomplete.fromJson(e)).toList();
      return aux.cast<PatientIncomplete>();
    }

    return [];
  }

}