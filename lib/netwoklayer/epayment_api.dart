import 'dart:async';
import 'dart:convert';
import 'package:hp_one/netwoklayer/taxitemmodel.dart';
import 'package:hp_one/netwoklayer/network_util.dart';
import 'package:hp_one/netwoklayer/epayment.dart';
import 'package:hp_one/globals.dart' as globals;

import 'challanitemmodel.dart';

class EpaymentApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<dynamic> add(Epayment epayment) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_challan/add-tax-challan";
/*
    $params['tax_challan_id'] = $VARS['challan_id'];
    $params['tax_challan_title'] = $VARS['challan_title'];

    $params['tax_challan_duration'] = $VARS['challan_duration'];

    $params['tax_transaction_no'] = $VARS['transaction_no'];
    $params['tax_challan_status'] = $VARS['challan_status'];
    $params['tax_transaction_status'] = $VARS['transaction_status'];
*/

print(epayment.tax_type);
    var match = {
      "queue_session": globals.userSession,
      "tax_type_id": epayment.tax_type,
      "tax_depositors_name": epayment.person_name,
      "tax_depositors_phone": epayment.mobile_number,
      "email": epayment.email,
      "tax_depositors_address": epayment.address,
      "tax_challan_location": epayment.location,
      "dealer_type": epayment.dealer_type,
      "tax_challan_from_dt": epayment.tax_period_from,
      "tax_challan_to_dt": epayment.tax_period_to,
      "tax_challan_purpose": epayment.purpose,
      "type_code": epayment.code,
      "tax_challan_amount": epayment.amount,

      "created_by":"Suresh",
      "modified_by":"Suresh",
      "token":"123",
      "device":"android"
    };

    //print(match);

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
      /*
      //return res;
      var results = new TaxitemModel.map(res);
      results.status = 200;

      print("=======3333333=======");
      print(results);
      print("=======3333333=======");
      */
      return res;
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
  Future<dynamic> get_initial_challan_data(String query) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/get-challan-data";

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

      print("=======challan initial data=======");
      print(res);
      print("=======challan initial data=======");
      //var results = Epayment.fromJson(res["Result"]);

      //results.status = 200;
      return res["Result"];
    });
  }

  Future<ChallanitemModel> challan_list(String query) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_challan_list/get-list";

    var match = {
      "search_query": query,
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
      var results = new ChallanitemModel.searchResult(res["Result"]);

      print("=======results=======");
      print(results);
      print("=======results=======");

      results.status = 200;
      return results;
    });
  }
}