import 'dart:async';
import 'dart:convert';
import 'package:hp_one/netwoklayer/invoice.dart';
import 'package:hp_one/netwoklayer/taxitemmodel.dart';
import 'package:hp_one/netwoklayer/network_util.dart';
import 'package:hp_one/netwoklayer/tax.dart';
import 'package:hp_one/globals.dart' as globals;

class InvoiceApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<dynamic> add(Invoice invoice) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_invoice/add-invoice";

    String consigner_gst = "", identification_type = "", identification_number = "";
    if(invoice.is_registered == "1") {
      consigner_gst = invoice.consignee_gst;
    } else {
      identification_type = invoice.identification_type;
      identification_number = invoice.identification_number;
    }

    var match = {
      "queue_session": globals.userSession,
      "id": invoice.id,
      "invoice_no": invoice.invoice_no,
      "invoice_date": invoice.invoice_date,
      "invoice_amount": invoice.invoice_amount,
      "vehicle_number": invoice.vehicle_number,
      "transaction_type": invoice.transaction_type,
      "consigner_gst": consigner_gst,
      "firm_name": invoice.firm_name,
      "firm_address": invoice.firm_address,
      "consignee_gst": invoice.consignee_gst,
      "consignee_firm_name": invoice.consignee_firm_name,
      "bill_to": invoice.bill_to,
      "ship_to": invoice.ship_to,
      "identification_type": identification_type,
      "identification_number": identification_number,
      "is_registered": invoice.is_registered,
      "created_by": globals.userid,
      "modified_by":"Suresh",
      "token":"123",
      "device":"android"
    };



    print(match);

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

      return res;
      //var results = new TaxitemModel.map(res);
      //results.status = 200;

      //print("=======3333333=======");
      //print(results);
      //print("=======3333333=======");

      //return results;
    });
  }

  Future<dynamic> update(Invoice invoice) {
   // String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/update-tax-item-queue/"+invoice.tax_item_id;

    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/update-tax-item-queue/"+invoice.id;

    //String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/add-tax-item-queue";

    //print("=======3333333333333=======" + BASE_TOKEN_URL);

    var match = {
      "id": invoice.id,
      "invoice_no": invoice.invoice_no,
      "queue_session": globals.userSession,
      "invoice_date": invoice.invoice_date,
      "invoice_amount": invoice.invoice_amount,
      "vehicle_number": invoice.vehicle_number,
      "transaction_type": invoice.transaction_type,

      "consigner_gst": invoice.consigner_gst,
      "firm_name": invoice.firm_name,
      "firm_address": invoice.firm_address,

      "consignee_gst": invoice.consignee_gst,
      "consignee_firm_name": invoice.consignee_firm_name,
      "bill_to": invoice.bill_to,
      "ship_to": invoice.ship_to,

      "identification_type": invoice.identification_type,
      "identification_number": invoice.identification_number,

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

      print("=======list que after insert=======");
      print(res);
      print("=======list que after insert=======");
      var results = new TaxitemModel.searchResult(res["Result"]);

      results.status = 200;
      return results;
    });
  }
}