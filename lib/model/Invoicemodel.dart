
import 'package:hpetax/networklayer/invoice.dart';

class InvoiceModel {
  int status;
  String message;
  String response;
  bool success;
  bool error;
  List<Invoice> list;

  InvoiceModel.map(dynamic obj) {
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

  InvoiceModel.searchResult(dynamic obj) {
    if(obj != null) {
      list = obj.map<Invoice>((json) => new Invoice.fromJson(json))
          .toList();
    }
  }
}