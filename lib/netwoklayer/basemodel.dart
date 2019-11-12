import 'package:hp_one/netwoklayer/taxtype.dart';
import 'package:hp_one/netwoklayer/user.dart';

class BaseModel {
  int status;
  String message;
  String response;
  bool success;
  bool error;
  List<Taxtype> list;

  BaseModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"];
      this.success = obj["sucess"];
      this.error = obj["error"];
      if (status == null) {
        this.status = obj["status_code"];
      }
      this.message = obj["message"];
      this.response =
      obj["response"] != null ? obj["response"].toString() : null;
    }
  }

  BaseModel.searchResult(dynamic obj) {
    list = obj.map<Taxtype>((json) => new Taxtype.fromJson(json)).toList();
  }

  BaseModel.userResult(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"];
      this.success = obj["success"];
      this.error = obj["error"];
      if (status == null) {
        this.status = obj["status_code"];
      }
      this.message = obj["message"];
      this.response =
      obj["response"] != null ? obj.toString() : null;
    }
  }
}