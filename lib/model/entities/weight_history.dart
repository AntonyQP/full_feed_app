class WeightHistory {
  final String? date;
  final double? weight;

  WeightHistory({this.date, this.weight});

  factory WeightHistory.fromJson(dynamic json) {

    Map<String, dynamic> userJson = json;
    return WeightHistory(
    date: userJson['date'].toString(),
    weight: userJson['weight']
    );
  }
}