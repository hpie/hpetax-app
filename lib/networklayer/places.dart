class Places {
  String id;
  String place_id;
  String description;

  Places({this.id, this.place_id, this.description});

  factory Places.fromJson(Map<String, dynamic> parsedJson) {
    return Places(
      id: parsedJson["id"],
      place_id: parsedJson["place_id"] as String,
      description: parsedJson["description"] as String,
    );
  }
}