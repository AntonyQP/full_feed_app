
class NutritionStat {
  final double? carbohydrates;
  final String? date;
  final double? fat;
  final double? protein;

  NutritionStat({this.date, this.carbohydrates, this.fat, this.protein});

  factory NutritionStat.fromJson(dynamic json) {

    Map<String, dynamic> userJson = json;
    return NutritionStat(
      date: userJson['date'].toString(),
      carbohydrates: userJson['carbohydrates'],
      fat: userJson['fat'],
      protein: userJson['protein']
    );
  }
}