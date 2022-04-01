
import 'package:full_feed_app/model/entities/preference_category.dart';

class Preference {
  final int? preferencesId;
  final String? name;
  final PreferenceCategory? category;

  Preference({this.preferencesId, this.name, this.category});

  factory Preference.fromJson(dynamic json) {

    Map<String, dynamic> userJson = json;
    return Preference(
      preferencesId: userJson['preferencesId'],
      name: userJson['name'].toString(),
      category: PreferenceCategory.fromJson(userJson['category']),
    );
  }
}