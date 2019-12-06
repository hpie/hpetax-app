import 'commodity.dart';

class CommodityModel {
  int status;
  String message;
  String response;
  List<Commodity> list;

  CommodityModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"];
      if (status == null) {
        this.status = obj["status_code"];
      }
      this.message = obj["message"];
      this.response =
      obj["response"] != null ? obj["response"].toString() : null;
    }
  }

  CommodityModel.searchResult(dynamic obj) {
    list = obj.map<Commodity>((json) => new Commodity.fromJson(json)).toList();
  }
}