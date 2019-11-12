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

class PaymentPage extends StatefulWidget {
  @override
  _Payment createState() {
    var frm_data = new DeviceData();
    frm_data.get_data();
    return _Payment();
  }
}

class _Payment extends State<PaymentPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController challanIdCnt = TextEditingController();

  EpaymentApi _epaymentApi = new EpaymentApi();
  Epayment _epayment = new Epayment();

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Payment"),
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

    challanIdCnt.text = globals.challanId;

    return new Column(
      children: <Widget>[
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Tax Challan ID : ",
            style: TextStyle(fontSize: 15,
                fontWeight:FontWeight.bold),
          ),
        ),
        new TextField(
            decoration: new InputDecoration(hintText: "Challan Id", contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5)),
            style: new TextStyle(
              //fontSize: 5.0,
                height: 0.5,
                color: Colors.black
            ),
            enabled : false,
            controller: challanIdCnt,
            onChanged: (text) {
              //_tax.total_tax = text;
            }
        ),

        const SizedBox(height: 30),

        new Row(
          children: <Widget>[
            RaisedButton(
              onPressed: () {

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

