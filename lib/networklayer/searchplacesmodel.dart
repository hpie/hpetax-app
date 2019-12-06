

import 'package:hpetax/networklayer/players.dart';

class SearchplacesModel {
  int status;
  String message;
  String response;
  bool success;
  bool error;
  List<Players> list;

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
    list = obj.map<Players>((json) => new Players.fromJson(json)).toList();
  }
}