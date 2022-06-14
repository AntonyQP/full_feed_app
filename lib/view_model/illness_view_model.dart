import 'package:full_feed_app/model/entities/illness.dart';

class IllnessViewModel {
  final Illness illness;

  IllnessViewModel({required this.illness});

  String? get description => illness.description;

  String? get name => illness.name;

  int? get illnessId => illness.illnessesId;
}