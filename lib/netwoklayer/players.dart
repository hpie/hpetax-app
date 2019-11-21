class Players {
  String id;
  String place_id;
  String description;

  Players({this.id, this.place_id, this.description});

  factory Players.fromJson(Map<String, dynamic> parsedJson) {
    return Players(
      id: parsedJson["id"],
      place_id: parsedJson["place_id"] as String,
      description: parsedJson["description"] as String,
    );
  }
}