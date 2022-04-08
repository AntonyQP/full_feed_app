import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:full_feed_app/util/connection_tags.dart';

import '../../model/entities/illness.dart';
import '../../model/entities/user_session.dart';
import '../../util/MultipartRequestEx.dart';

class IllnessService {

  Future<bool> registerPatientIllnesses(List<int> illnessesIds) async {
    var uri = baseUrl + illnessEndpoint;
    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.post(uri, data: illnessesIds, queryParameters: {
      'patientId': UserSession().profileId
      }
    );

    if(response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<List<Illness>> getAllIllnesses() async {
    var uri = baseUrl + illnessEndpoint + getAllIllnessesEndpoint;

    final dio = Dio();

    Response response = await dio.get(uri);

    if(response.statusCode == 200) {
      List aux = response.data["data"].map((e) => Illness.fromJson(e)).toList();
      return aux.cast<Illness>();
    }

    return [];

  }

  Future<List<Illness>> getIllnessesByPatient() async {

    var uri = baseUrl + illnessEndpoint;

    final dio = Dio();

    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(uri, queryParameters: {
      'patientId': UserSession().profileId
    });

    if(response.statusCode == 200) {
      List aux = response.data["data"].map((e) => Illness.fromJson(e)).toList();
      return aux.cast<Illness>();
    }

    return [];
  }

}