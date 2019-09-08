import 'dart:async';
import 'dart:convert';
import 'package:hp_one/netwoklayer/basemodel.dart';
import 'package:hp_one/netwoklayer/network_util.dart';

class TaxtypeApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<BaseModel> search(String query) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "epayment_unregister/get-tax-type";

    var match = {
      "token": "123",
      "device": "android",
    };

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {
      var results = new BaseModel.searchResult(res["Result"]);
      results.status = 200;
      return results;
    });
  }
}