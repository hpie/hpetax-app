import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

import 'package:flutter/material.dart';
import 'package:hp_one/netwoklayer/tax.dart';
import 'package:hp_one/netwoklayer/epayment.dart';
import 'package:hp_one/netwoklayer/taxtype_api.dart';
import 'package:hp_one/netwoklayer/commodity_api.dart';
import 'package:hp_one/netwoklayer/tax_api.dart';
import 'package:hp_one/netwoklayer/epayment_api.dart';
import 'package:hp_one/netwoklayer/commodity.dart';
import 'package:http/http.dart' as http;
import 'package:hp_one/model/post.dart';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import 'package:hp_one/globals.dart' as globals;


import 'package:hp_one/util/device_data.dart';

class EpaymentPage extends StatefulWidget {
  @override
  _Epayment createState() {
    var frm_data = new DeviceData();
    frm_data.get_data();
    return _Epayment();
  }
}

class _Epayment extends State<EpaymentPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController eptaxtypeCnt = TextEditingController();
  TextEditingController purposeCnt = TextEditingController();
  TextEditingController codeCnt = TextEditingController();
  TextEditingController totaltaxCnt = TextEditingController();

  EpaymentApi _epaymentApi = new EpaymentApi();
  Epayment _epayment = new Epayment();

  @override
  void initState() {
    super.initState();
    getPaymentData("");
  }

  /*
  List items of tax queue
   */
  Future getPaymentData(String newQuery) async {
    var search = await _epaymentApi.get_initial_challan_data(newQuery);

    setState(() {
    // print("========tax_type_id======= : " + search[0]["tax_type_id"].toString());
    // print("========tax_type_name======= : " + search[0]["tax_type_name"].toString());
    // print("========tax_amount======= : " + search[0]["tax_amount"].toString());

     eptaxtypeCnt.text = search[0]["tax_type_name"].toString();
     purposeCnt.text = search[0]["challan_purpose"].toString();
     codeCnt.text = search[0]["challan_code"].toString();
     totaltaxCnt.text = search[0]["tax_amount"].toString();

     _epayment.purpose = search[0]["challan_purpose"].toString();
     _epayment.code = search[0]["challan_code"].toString();
     _epayment.amount = search[0]["tax_amount"].toString();
    });
  }

  Future add_epayment_data(context) async {
    var response;

    response = await _epaymentApi.add(_epayment);

    Toast.show(response["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    if(response["success"]) {
      print("in success");
      globals.challanId = response["challan_id"];
      globals.selectedTaxType = "";

      var now = new DateTime.now();
      print(now.millisecondsSinceEpoch);
      globals.userSession = globals.isLoggedIn + "_" + (now.millisecondsSinceEpoch).toString();

      Navigator.pushNamed(context, '/payment');
      setState(() {
        //listTaxItemQueue("");
      });
    } else {
      print("in else");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Epayment"),
          automaticallyImplyLeading:false,
        ),
        body:  new SingleChildScrollView(

          child: new Container(
            alignment: Alignment.topLeft,
            child: new Form(key: _formKey,child: formUI()),
            //child: new Form(key: _formKey,child: Text("Hello")),
          ),
        )
    );
  }

  Widget formUI() {

    eptaxtypeCnt.text = globals.selectedTaxType;

    return new Column(
      children: <Widget>[
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Tax Type",
            style: TextStyle(fontSize: 15,
                fontWeight:FontWeight.bold),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "Tax Type", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            enabled : false,
            controller: eptaxtypeCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Name of Person",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            //controller: totaltaxCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.person_name = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Mobile Number",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
        decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
            //fontSize: 5.0,
            height: 0.5,
            color: Colors.black
            ),
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.mobile_number = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Email ID",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
            //fontSize: 5.0,
            height: 0.5,
            color: Colors.black
            ),
            //controller: totaltaxCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.email = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Address",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            //controller: totaltaxCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.address = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Location",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            //controller: totaltaxCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.location = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Dealer Type",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            //controller: totaltaxCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.dealer_type = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Tax Period From",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            //controller: totaltaxCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.tax_period_from = text;
            },
            keyboardType: TextInputType.datetime,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Tax Period To",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            //controller: totaltaxCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.tax_period_to = text;
            },
            keyboardType: TextInputType.datetime,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Purpose",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            enabled : false,
            controller: purposeCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.purpose = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Code",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            enabled:false,
            controller: codeCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.code = text;
            }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Amount",
              style: TextStyle(fontSize: 15,
                  fontWeight:FontWeight.bold),
            ),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            enabled : false,
            controller: totaltaxCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
              _epayment.amount = text;
            }
        ),

        const SizedBox(height: 30),

        new Row(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                add_epayment_data(context);
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20)
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/test');
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 20)
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }










}

