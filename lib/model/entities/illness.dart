class Illness {
  final String? description;
  final int? illnessesId;
  final String? name;

  Illness({this.name, this.description, this.illnessesId});

  factory Illness.fromJson(dynamic json) {
    Map<String, dynamic> illnessJson = json;
    return Illness(
      description: illnessJson['description'],
      illnessesId: illnessJson['illnessesId'],
      name: illnessJson['name']
    );
  }

  Map toJson() => {
    'description': description,
    'illnessesId': illnessesId,
    'name': name
  };
}