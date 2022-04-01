import 'package:dio/dio.dart';
import 'package:full_feed_app/model/entities/preference.dart';

import '../../util/connection_tags.dart';

class PreferenceService {

  Future<List<Preference>> listAllPreferences() async{

    var api = baseUrl + preferencesEndpoint;

    final dio = Dio();
    Response response;
    response = await dio.get(api);
    if(response.statusCode == 200){
      var data = response.data["data"] as List;
      var preferenceList = data.map((e) => Preference.fromJson(e)).toList();
      return preferenceList;
    }
    return [];
  }

}