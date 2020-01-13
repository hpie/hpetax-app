import 'dart:async';
import 'dart:convert';

import 'package:tax/model/Invoicemodel.dart';
import 'package:tax/networklayer/user.dart';

import 'basemodel.dart';
import 'network_util.dart';

class UserApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<BaseModel> login_wrong(User user) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_user/login";
    //String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_dealer/register-dealer";

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
      //var results = res["Result"];
      print("=======222222222=======");
      print(res);
      print("=======222222222=======");

      //return res;
      var results = new BaseModel.userResult(res["Result"]);
      results.status = 200;
      return results;
    });
  }

  Future<dynamic> login(User user) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_user/login";

    var match = {
      "username" : user.user_email,
      "password" : user.user_password,
      "user_type" : user.user_type,

      "token": "123",
      "device": "android",
    };

    print(match);

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {
      // /*
      print("=======22222222222=======");
      print(res);
      print("=======2222222222=======");
/*
      var results = res["Result"];
      */
      //results.status = 200;
      return res;
    });
  }

  Future<dynamic> get_user(String userid) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_user/get_user";

    var match = {
      "userid" : userid,

      "token": "123",
      "device": "android",
    };

    print(match);

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {
      // /*
      //print("=======22222222222=======");
      //print(res);
      //print("=======2222222222=======");
/*
      var results = res["Result"];
      */
      //results.status = 200;
      return res;
    });
  }

  Future<dynamic> get_dealer(String dealerid) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_user/get_dealer";

    var match = {
      "dealerid" : dealerid,
      "token": "123",
      "device": "android",
    };

    print(match);

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {

      print("====User api===22222222222=======");
      print(res);
      print("=======2222222222=======");

      var results = new InvoiceModel.searchResult(res["Result"]);
      // /*
      print("====User api===22222222222=======");
      print(results.list);
      print("=======2222222222=======");

      results.status = 200;
      return results.list;
    });
  }
}