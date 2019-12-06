import 'dart:async';
import 'dart:convert';

import 'commoditymodel.dart';
import 'network_util.dart';

class CommodityApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<CommodityModel> search(String query) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "epayment_unregister/get-comodity-list/"+query;

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
      var results;
/*
          print("=======commodity data=======");
          print(res);
          print("=======commodity data=======");
*/
      if(res["Result"] != null) {
        results = new CommodityModel.searchResult(res["Result"]);
      } else {
        results = new CommodityModel.map(res);
      }
      results.status = 200;
      return results;
    });
  }

  Future<dynamic> getdata(String query) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "epayment_unregister/get-comodity-details/"+query;

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

      print("=======Selected commodity=======");
      print(res);
      print("=======Selected commodity=======");

      var results = res["Result"];

      //results.status = 200;
      return results;
    });
  }
}