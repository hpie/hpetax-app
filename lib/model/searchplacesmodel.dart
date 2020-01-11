
import 'package:hpetax/networklayer/places.dart';

class SearchplacesModel {
  int status;
  String message;
  String response;
  bool success;
  bool error;
  List<Places> list;

  SearchplacesModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"];
      this.success = obj["success"];
      this.error = obj["error"];
      if (status == null) {
        this.status = obj["status_code"];
      }
      this.message = obj["message"];
      this.response =
      obj["response"] != null ? obj["response"].toString() : null;
    }
  }

  SearchplacesModel.searchResult(dynamic obj) {
    list = obj.map<Places>((json) => new Places.fromJson(json)).toList();
  }
}