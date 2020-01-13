import 'dart:async';
import 'dart:convert';

import 'package:tax/globals.dart' as globals;
import 'package:tax/networklayer/taxitemmodel.dart';

import 'dealer.dart';
import 'network_util.dart';

class RegisterApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<dynamic> add(Dealer dealer) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_dealer/register-dealer";

    var match = {
      "tax_dealer_id": dealer.tax_dealer_id,
      "tax_dealer_name": dealer.tax_dealer_name,
      "queue_session": globals.userSession,
      "tax_dealer_code": dealer.tax_dealer_code,
      "tax_dealer_password": dealer.tax_dealer_password,
      "tax_dealer_tin": dealer.tax_dealer_tin,
      "tax_dealer_tin_expiry": dealer.tax_dealer_tin_expiry,
      "tax_dealer_mobile": dealer.tax_dealer_mobile,
      "tax_dealer_pan": dealer.tax_dealer_pan,
      "tax_dealer_aadhar": dealer.tax_dealer_aadhar,
      "tax_dealer_security_q": (dealer.tax_dealer_security_q != "") ? dealer.tax_dealer_security_q : dealer.tax_dealer_security_q,
      "tax_dealer_security_a": dealer.tax_dealer_security_a,
      "tax_dealer_email": dealer.tax_dealer_email,
      "tax_dealer_lastlogin": dealer.tax_dealer_lastlogin,
      "tax_delaer_status": dealer.tax_delaer_status,
      "created_by": dealer.created_by,
      "modified_by": dealer.modified_by,
      "modified_dt": dealer.modified_dt,

      "created_by":"Suresh",
      "modified_by":"Suresh",
      "token":"123",
      "device":"android"


    };

    print(match);
   // /*
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
      var results = new TaxitemModel.map(res);
      results.status = 200;

      //print("=======3333333=======");
      //print(results);
      //print("=======3333333=======");

      return results;

    });

    // */
  }

  Future<dynamic> update(Dealer dealer) {
   // String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/update-tax-item-queue/"+dealer.tax_item_id;

    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/update-tax-item-queue/"+dealer.tax_dealer_id;

    //String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/add-tax-item-queue";

    //print("=======3333333333333=======" + BASE_TOKEN_URL);

    var match = {
    "tax_dealer_id": dealer.tax_dealer_id,
    "tax_dealer_name": dealer.tax_dealer_name,
    "queue_session": globals.userSession,
    "tax_dealer_code": dealer.tax_dealer_code,
    "tax_dealer_password": dealer.tax_dealer_password,
    "tax_dealer_tin": dealer.tax_dealer_tin,
    "tax_dealer_tin_expiry": dealer.tax_dealer_tin_expiry,
    "tax_dealer_mobile": dealer.tax_dealer_mobile,
    "tax_dealer_pan": dealer.tax_dealer_pan,
    "tax_dealer_aadhar": dealer.tax_dealer_aadhar,
    "tax_dealer_security_q": (dealer.tax_dealer_security_q != "") ? dealer.tax_dealer_security_q : dealer.tax_dealer_security_q,
    "tax_dealer_security_a": dealer.tax_dealer_security_a,
    "tax_dealer_email": dealer.tax_dealer_email,
    "tax_dealer_lastlogin": dealer.tax_dealer_lastlogin,
    "tax_delaer_status": dealer.tax_delaer_status,
    "created_by": dealer.created_by,
    "modified_by": dealer.modified_by,
    "modified_dt": dealer.modified_dt,

      "item_status": "1",

      "created_by":"Suresh",
      "modified_by":"Suresh",
      "token":"123",
      "device":"android"


    };

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {

      //var results = res["Result"];
      print("=======222update222222=======");
      print(res);
      //return res;
      //print("=======222222222=======");
      var results = new TaxitemModel.map(res);
      results.status = 200;

      //print("=======3333333=======");
      //print(results);
      //print("=======3333333=======");

      return results;
    });
  }

  Future<dynamic> delete(String item_id) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/delete-tax-item-queue/"+item_id;
    //String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "epayment_unregister/get-tax-type";

    String query = "AG";

    //String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "epayment_unregister/get-comodity-list/"+query;
    print(BASE_TOKEN_URL);

    var match = {
      "token":"123",
      "device":"android"
    };

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {

      //var results = res["Result"];
      /*
      print("=======222222222=======");
      print(res);
      print("=======222222222=======");
      return res;
      */
      var results = new TaxitemModel.map(res);
      results.status = 200;

      //print("=======3333333=======");
      //print(results);
      //print("=======3333333=======");

      return results;

    });
  }

  //Future<TaxitemModel> search(String query) {
  Future<TaxitemModel> list(String query) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/list-tax-item-queue";

    var match = {
      "queue_session": globals.userSession,
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
    /*
      print("=======list que after insert=======");
      print(res);
      print("=======list que after insert=======");
      */
      var results = new TaxitemModel.searchResult(res["Result"]);

      results.status = 200;
      return results;
    });
  }
}