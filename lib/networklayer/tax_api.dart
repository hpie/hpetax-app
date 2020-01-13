import 'dart:async';
import 'dart:convert';


import 'package:tax/globals.dart' as globals;
import 'package:tax/networklayer/tax.dart';
import 'package:tax/networklayer/taxitemmodel.dart';

import 'network_util.dart';

class TaxApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<dynamic> add(Tax tax) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/add-tax-item-queue";

    var match = {
      "item_queue_id": Tax.item_queue_id,
      "queue_session": globals.userSession,
      "type_id": tax.tax_type_id,
      "type_name": tax.tax_type_id,
      "commodity_id": tax.tax_commodity_id,
      "commodity_name": tax.tax_commodity_name,
      "vehicle_number": tax.vehicle_number,
      "item_weight": tax.weight,
      "item_weight_units": tax.unit,
      "item_quantity": (tax.quantity != "") ? tax.quantity : tax.weight,
      "item_quantity_units": tax.unit,
      "item_source_location": tax.source_location,
      "item_destination_location": tax.destination_location,
      "item_distanceinkm": tax.distance,
      "item_tax_amount": tax.total_tax,

      "item_status": "1",

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

      //return res;
      var results = new TaxitemModel.map(res);
      results.status = 200;

      //print("=======3333333=======");
      //print(results);
      //print("=======3333333=======");

      return results;
    });
  }

  Future<dynamic> update(Tax tax) {
   // String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/update-tax-item-queue/"+tax.tax_item_id;

    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/update-tax-item-queue/"+tax.tax_item_id;

    //String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/add-tax-item-queue";

    //print("=======3333333333333=======" + BASE_TOKEN_URL);

    var match = {
      "tax_item_id": tax.tax_item_id,
      "tax_item_queue_id": tax.tax_item_queue_id,
      "queue_session": globals.userSession,
      "type_id": tax.tax_type_id,
      "type_name": tax.tax_type_id,
      "commodity_id": tax.tax_commodity_id,
      "commodity_name": tax.tax_commodity_name,
      "vehicle_number": tax.vehicle_number,
      "item_weight": tax.weight,
      "item_weight_units": tax.unit,
      "item_quantity": (tax.quantity != "") ? tax.quantity : tax.weight,
      "item_quantity_units": tax.unit,
      "item_source_location": tax.source_location,
      "item_destination_location": tax.destination_location,
      "item_distanceinkm": tax.distance,
      "item_tax_amount": tax.total_tax,

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