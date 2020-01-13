
import 'package:tax/networklayer/tax.dart';

class TaxitemModel {
  int status;
  String message;
  String response;
  bool success;
  bool error;
  List<Tax> list;

  TaxitemModel.map(dynamic obj) {
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

  TaxitemModel.searchResult(dynamic obj) {
    if(obj != null) {
      list = obj.map<Tax>((json) => new Tax.fromJson(json)).toList();
    }
  }
}