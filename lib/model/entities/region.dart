class Region {
  final int? regionId;
  final String? name;

  Region({this.regionId, this.name});

  factory Region.fromJson(dynamic json) {

    Map<String, dynamic> userJson = json;
    return Region(
        regionId: userJson['regionId'],
        name: userJson['name'].toString()
    );
  }
}