import 'dart:async';
import 'dart:convert';

import 'package:hpetax/networklayer/taxitemmodel.dart';

import 'challanitemmodel.dart';
import 'epayment.dart';
import 'network_util.dart';
import 'package:hpetax/globals.dart' as globals;

class EpaymentApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<dynamic> add(Epayment epayment, String ddo, String receipt) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_challan/add-tax-challan";

print(epayment.tax_type);

/*
`tax_challan_id`, `tax_challan_title`, `tax_depositors_email`,
`tax_depositors_address`, `tax_depositors_city`, `tax_depositors_zip`, `tax_challan_location`,
`tax_challan_duration`, `tax_challan_from_dt`, `tax_challan_to_dt`, `tax_challan_purpose`,
`tax_challan_amount`, `tax_transaction_no`, `tax_transaction_status`, `tax_challan_status`,
`tax_type_id`, `tax_dealer_id`, `ddo`, `receipt`, `created_by`,
`created_dt`, `modified_by`, `modified_dt`
 */

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
      //"type_code": epayment.code,
      "type_code": epayment.tax_type,
      "tax_challan_amount": epayment.amount,


      "ddo": ddo,
      "receipt": receipt,

      "tax_dealer_id": globals.userid,

      "created_by": globals.userid,
      "modified_by":"",
      "token":"123",
      "device":"android"
    };

   // print(match);

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {



/*
      //var results = res["Result"];
      print("=======222222222=======");
      print(res);
      print("=======222222222=======");

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

      //print("=======challan initial data=======");
      //print(res);
      //print("=======challan initial data=======");
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

      //print("=======results=======");
     // print(results);
      //print("=======results=======");

      results.status = 200;
      return results;
    });
  }

  // THis method is use on challan payment page
  Future<ChallanitemModel> challan_list_for_payment(String query, bool is_insert) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_challan_list/get-list-by-session";

    print("in challan_list_for_payment : " + BASE_TOKEN_URL);
    var match;
    if(!is_insert) {
      match = {
        "search_query": query,
        "is_insert": 1,
        "token": "123",
        "device": "android",
      };
    } else {
      match = {
        "search_query": query,
        "token": "123",
        "device": "android",
      };
    }

    print(match);

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {
      /*
      print("=======challan_list_for_payment result=======");
      print(res);
      print("=======challan_list_for_payment result=======");
     */
      var results = new ChallanitemModel.searchResult(res["Result"]);

      print("=======results=======");
      print(results);
      print("=======results=======");

      results.status = 200;
      return results;
    });
  }

  Future<dynamic> challan_user_list(String query) {
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
      var results = new ChallanitemModel.searchResult(res["Result"]);
/*
      print("=======results=======");
      print(results);
      print("=======results=======");
*/
      results.status = 200;
      return results.list;
    });
  }
}