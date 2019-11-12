import 'package:hp_one/netwoklayer/tax.dart';

import 'challan.dart';
import 'epayment.dart';

class ChallanitemModel {
  int status;
  String message;
  String response;
  bool success;
  bool error;
  List<Challan> list;

  ChallanitemModel.map(dynamic obj) {
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

  ChallanitemModel.searchResult(dynamic obj) {
    if(obj != null) {
      list = obj.map<Challan>((json) => new Challan.fromJson_challan(json))
          .toList();
    }
  }
}