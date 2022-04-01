

class PreferenceCategory {
  final int? categoryId;
  final String? name;

  PreferenceCategory({this.categoryId, this.name});

  factory PreferenceCategory.fromJson(dynamic json) {

    Map<String, dynamic> preferenceCategoryJson = json;
    return PreferenceCategory(
      categoryId: preferenceCategoryJson['categoryId'],
      name: preferenceCategoryJson['name'].toString(),
    );
  }
}