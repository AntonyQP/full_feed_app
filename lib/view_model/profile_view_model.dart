import 'package:full_feed_app/domain/service/user_service.dart';
import 'package:full_feed_app/util/util.dart';

import '../model/entities/nutrition_stat.dart';
import '../model/entities/weight_history.dart';


class WeightData {
  final double? lostWeight;
  final String month;

  WeightData(this.lostWeight, this.month);
}

class CarbohydrateData {
  final double kCal;
  final String days;

  CarbohydrateData(this.kCal, this.days);
}

class ProteinData {
  final double kCal;
  final String days;

  ProteinData(this.kCal, this.days);
}


class ProfileViewModel{

  final List<WeightData> _weightHistoryToShow = [
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

  final  List<CarbohydrateData> _carbohydrateChartDataToShow = [
    CarbohydrateData(0, 'Lun'),
    CarbohydrateData(0, 'Mar'),
    CarbohydrateData(0, 'Mie'),
    CarbohydrateData(0, 'Jue'),
    CarbohydrateData(0, 'Vie'),
    CarbohydrateData(0, 'Sab'),
    CarbohydrateData(0, 'Dom'),
  ];

  final List<ProteinData> _proteinChartDataToShow = [
    ProteinData(0, 'Lun'),
    ProteinData(0, 'Mar'),
    ProteinData(0, 'Mie'),
    ProteinData(0, 'Jue'),
    ProteinData(0, 'Vie'),
    ProteinData(0, 'Sab'),
    ProteinData(0, 'Dom'),
  ];


  final UserService _userService = UserService();

  List<ProteinData> getProteinChartDataToShow(){
    return _proteinChartDataToShow;
  }

  List<WeightData> getWeightHistory(){
    return _weightHistoryToShow;
  }

  List<CarbohydrateData> getCarbohydrateChartData(){
    return _carbohydrateChartDataToShow;
  }

  Future<void> initPatientData() async {
    if(isPatient()){
      await  _userService.getUserSuccessfulDays().then((value){
        _userService.getWeightEvolution().then((weightHistory){
          generateWeightHistory(weightHistory);
        });
      });
      await _userService.getConsumedBalance().then((nutritionStats){
        generateNutritionStats(nutritionStats);
      });
    }
  }

  generateWeightHistory(List<WeightHistory> weightHistory){
    if(weightHistory.isNotEmpty){
      for(int i = 0; i < weightHistory.length; i++){
        _weightHistoryToShow.add(WeightData(weightHistory[i].weight!, getMonth(weightHistory[i].date!)));
      }
    }
  }

  generateNutritionStats(List<NutritionStat> nutritionStats){
    if(nutritionStats.isNotEmpty){
      for(int i = 0; i < nutritionStats.length; i++){
      _carbohydrateChartDataToShow.add(CarbohydrateData(nutritionStats[i].carbohydrates!, getDay(nutritionStats[i].date!)));
      _proteinChartDataToShow.add(ProteinData(nutritionStats[i].protein!, getDay(nutritionStats[i].date!)));
      }
    }
  }

}