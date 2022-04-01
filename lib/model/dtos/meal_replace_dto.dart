class MealReplaceDto {
  final int mealId;
  final String name;
  final double carbohydrates;
  final double fat;
  final double gramsPortion;
  final String ingredients;
  final double protein;
  final double totalCalories;
  final String imageUrl;

  MealReplaceDto(this.mealId, this.name, this.carbohydrates, this.fat, this.gramsPortion, this.ingredients, this.protein, this.totalCalories,
      this.imageUrl);

  Map toJson() => {
    'mealId': mealId,
    'name': name,
    'carbohydrates' : carbohydrates,
    'fat' : fat,
    'gramsPortion' : gramsPortion,
    'ingredients' : ingredients,
    'protein' : protein,
    'totalCalories' : totalCalories,
    'imageUrl' : imageUrl
  };
}