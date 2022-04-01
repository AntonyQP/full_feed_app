
class Meal {
  final int? mealId;
  final String? name;
  final String? schedule;
  final String? day;
  final double? carbohydrates;
  final double? fat;
  final double? gramsPortion;
  final String? ingredients;
  final double? protein;
  final double? totalCalories;
  final int? status;
  final String? imageUrl;

  Meal({this.mealId, this.name, this.schedule, this.day, this.carbohydrates, this.fat, this.gramsPortion, this.ingredients, this.protein, this.totalCalories, this.status, this.imageUrl});

  factory Meal.fromJson(dynamic json) {

    Map<String, dynamic> patientJson = json;
    return Meal(
      mealId: patientJson['mealId'],
      name: patientJson['name'].toString(),
      schedule: patientJson['schedule'].toString(),
      day: patientJson['day'].toString(),
      carbohydrates: patientJson['carbohydrates'],
      fat: patientJson['fat'],
      gramsPortion: patientJson['gramsPortion'],
      ingredients: patientJson['ingredients'],
      protein: patientJson['protein'],
      totalCalories: patientJson['totalCalories'],
      status: patientJson['status'],
      imageUrl: patientJson['imageUrl'].toString()
    );
  }

  Map toJson() => {
    'mealId': mealId,
    'name': name,
    'schedule' : schedule,
    'day' : day,
    'carbohydrates' : carbohydrates,
    'fat' : fat,
    'gramsPortion' : gramsPortion,
    'ingredients' : ingredients,
    'protein' : protein,
    'totalCalories' : totalCalories,
    'status' : status,
    'imageUrl' : imageUrl
  };

}