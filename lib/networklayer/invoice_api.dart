import 'dart:async';
import 'dart:convert';
import 'package:hpetax/globals.dart' as globals;
import 'package:hpetax/model/Invoicemodel.dart';
import 'package:hpetax/networklayer/taxitemmodel.dart';

import 'invoice.dart';
import 'network_util.dart';

class InvoiceApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<dynamic> add(Invoice invoice) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_invoice/add-invoice";

    String consigner_gst = "", identification_type = "", identification_number = "", tax_dealer_code = "";
    if(invoice.is_registered == "1") {
      tax_dealer_code = invoice.tax_dealer_code;
      consigner_gst = invoice.consigner_gst;
    } else {
      identification_type = invoice.identification_type;
      identification_number = invoice.identification_number;
    }

    var match = {
      "queue_session": globals.userSession,
      "id": invoice.tax_edt_invoice_id,
      "invoice_no": invoice.invoice_no,
      "invoice_date": invoice.invoice_date,
      "invoice_amount": invoice.invoice_amount,
      "vehicle_number": invoice.vehicle_number,
      "transaction_type": invoice.transaction_type,
      "consigner_gst": consigner_gst,
      "consigner_firm_name": invoice.consigner_firm_name,
      "consigner_firm_address": invoice.consigner_firm_address,

      "consignee_gst": invoice.consignee_gst,
      "consignee_firm_name": invoice.consignee_firm_name,

      "consignee_bill_to": invoice.consignee_bill_to,
      "consignee_ship_to": invoice.consignee_ship_to,
      "identification_type": identification_type,
      "identification_number": identification_number,
      "is_registered": invoice.is_registered,

      "tax_dealer_code": tax_dealer_code,
      "inspected_date": invoice.inspected_date,
      "tax_employee_code": globals.userid,

      "file": invoice.file,
      "file_name": invoice.file_name,

      "created_by": globals.userid,
      "token":"123",
      "device":"android"
    };


    print("data to send : r");
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

    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/update-tax-item-queue/"+invoice.tax_edt_invoice_id;

    //String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_item_queue/add-tax-item-queue";

    //print("=======3333333333333=======" + BASE_TOKEN_URL);

    String consigner_gst = "", identification_type = "", identification_number = "";
    if(invoice.is_registered == "1") {
      consigner_gst = invoice.consignee_gst;
    } else {
      identification_type = invoice.identification_type;
      identification_number = invoice.identification_number;
    }

    var match = {
      "queue_session": globals.userSession,
      "id": invoice.tax_edt_invoice_id,
      "invoice_no": invoice.invoice_no,
      "invoice_date": invoice.invoice_date,
      "invoice_amount": invoice.invoice_amount,
      "vehicle_number": invoice.vehicle_number,
      "transaction_type": invoice.transaction_type,
      "consigner_gst": consigner_gst,
      "consigner_firm_address": invoice.consigner_firm_address,
      "consigner_firm_address": invoice.consigner_firm_address,


      "consignee_gst": invoice.consignee_gst,
      "consignee_firm_name": invoice.consignee_firm_name,

      "consignee_bill_to": invoice.consignee_bill_to,
      "consignee_ship_to": invoice.consignee_ship_to,
      "identification_type": identification_type,
      "identification_number": identification_number,
      "is_registered": invoice.is_registered,

      "tax_dealer_code": invoice.tax_dealer_code,
      "inspected_date": invoice.inspected_date,
      "tax_employee_code": invoice.tax_employee_code,

      "created_by": globals.userid,
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
  Future<InvoiceModel> search_record(String user_type, String search_field, String search_text) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_invoice/search-record";

    var match = {
      "user_type" : user_type,
      "search_text" : search_text,
      "search_field" : search_field,
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
      ///*
     // print("=======Search result=======");
     print(res);
     // print("=======Search result=======");
      //*/
      var results = new InvoiceModel.searchResult(res["Result"]);

      results.status = 200;
      return results;
    });
  }

  Future<dynamic> get_record(String user_type, String search_field, String search_text) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_invoice/get-record";

    var match = {
      "user_type" : user_type,
      "search_text" : search_text,
      "search_field" : search_field,
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
      ///*
      print("=======Get result=======");
       print(res);
      print("=======Get result=======");
      //*/
      //var results = new InvoiceModel.searchResult(res["Result"]);

      //results.status = 200;
      return res;
    });
  }
}