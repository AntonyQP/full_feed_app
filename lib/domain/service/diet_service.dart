import 'package:dio/dio.dart';
import 'package:full_feed_app/model/dtos/patient_update_dto.dart';
import 'package:intl/intl.dart';

import '../../model/dtos/meal_replace_dto.dart';
import '../../model/entities/meal.dart';
import '../../model/entities/user_session.dart';
import '../../util/connection_tags.dart';

class DietService {

  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<List<Meal>> getWeekDietMeals(DateTime initialDate, DateTime lastDate) async{

    var api = baseUrl + mealEndpoint + weekMealList;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(api, queryParameters: {'endDate' : _dateFormat.format(lastDate), 'patientId' : UserSession().profileId, 'startDate': _dateFormat.format(initialDate)});

    if(response.statusCode == 200){
      List aux = response.data.map((e) => Meal.fromJson(e)).toList();
      return aux.cast<Meal>();
    }
    return [];
  }

  Future<List<Meal>> getWeekDietMealsByPatient(int patientId, DateTime lastDate, DateTime initialDate) async{

    var api = baseUrl + mealEndpoint + weekMealList;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(api, queryParameters: {'endDate' : _dateFormat.format(lastDate), 'patientId' : patientId, 'startDate': _dateFormat.format(initialDate)});

    if(response.statusCode == 200){
      List aux = response.data.map((e) => Meal.fromJson(e)).toList();
      return aux.cast<Meal>();
    }
    return [];
  }


  Future<List<Meal>> getDayMeals() async{

    var api = baseUrl + mealEndpoint + dayMealList;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(api, queryParameters: {'date' : _today, 'patientId' : UserSession().profileId});
    if(response.statusCode == 200){
      List aux = response.data.map((e) => Meal.fromJson(e)).toList();
      return aux.cast<Meal>();
    }
    return [];
  }

  Future<List<Meal>> getDayMealsByPatient(int patientId) async{
    var api = baseUrl + mealEndpoint + dayMealList;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.get(api, queryParameters: {'date' : _today, 'patientId' : patientId});
    if(response.statusCode == 200){
      List aux = response.data.map((e) => Meal.fromJson(e)).toList();
      return aux.cast<Meal>();
    }
    return [];
  }

  Future<List<Meal>> getAlternativeMeals(Meal meal) async{
    var api = baseUrl + mealEndpoint + alternativeMeals;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.post(api, data: {'calories': meal.totalCalories, 'schedule': meal.schedule});

    if(response.statusCode == 200){
      List aux = response.data["data"].map((e) => Meal.fromJson(e)).toList();
      return aux.cast<Meal>();
    }

    return [];
  }

  Future<List<Meal>> generateNutritionPlan(int patientId, int doctorId) async {
    var api = baseUrl + patientEndpoint + newNutritionalPlan;

    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.post(api, queryParameters: {'patientId' : patientId, 'doctorId' : doctorId});

    if(response.statusCode == 201){
      List aux = response.data['data'].map((e) => Meal.fromJson(e)).toList();
      return aux.cast<Meal>();
    }

    return [];
  }

  Future<Meal> setCompleteMeal(int mealId) async {
    var api = baseUrl + mealEndpoint + completeMeal;
    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.put(api, queryParameters: {'mealId' : mealId});
    if(response.statusCode == 200){
      Meal aux = Meal.fromJson(response.data["data"]);
      return aux;
    }
    return Meal();
  }

  Future<Meal> setRestoreMeal(int mealId) async {
    var api = baseUrl + mealEndpoint + restoreMeal;
    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.put(api, queryParameters: {'mealId' : mealId});
    if(response.statusCode == 200){
      Meal aux = Meal.fromJson(response.data["data"]);
      return aux;
    }
    return Meal();
  }

  Future<Meal> replaceMeal(MealReplaceDto meal) async {
    var api = baseUrl + mealEndpoint + replaceMealEndpoint;
    final dio = Dio();
    dio.options.headers["authorization"] = "Bearer ${UserSession().token}";

    Response response = await dio.put(api, data: meal.toJson());
    if(response.statusCode == 200){
      Meal aux = Meal.fromJson(response.data["data"]);
      return aux;
    }
    return Meal();
  }


}