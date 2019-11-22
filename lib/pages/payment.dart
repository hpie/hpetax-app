import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hp_one/netwoklayer/challan.dart';
import 'package:hp_one/util/validations.dart';
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
import 'package:url_launcher/url_launcher.dart';

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



  EpaymentApi _epaymentApi = new EpaymentApi();
  Epayment _epayment = new Epayment();
  CustomValidations _customValidations = new CustomValidations();

  final customLoaderField =  CircularProgressIndicator();

  List<Challan> challan_queue;
  bool is_loading = false;
  bool payment_called = false;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  List<String> data_items = [];
  TextEditingController challanIdCnt = TextEditingController();
  final TextEditingController referenceCtrl = new TextEditingController();
  final TextEditingController amountCtrl = new TextEditingController();
  final TextEditingController tenderByCtrl = new TextEditingController();
  final TextEditingController fromCtrl = new TextEditingController();
  final TextEditingController toCtrl = new TextEditingController();
  final TextEditingController statusCtrl = new TextEditingController();
  final TextEditingController transactionStatusCtrl = new TextEditingController();



  @override
  void initState() {
    super.initState();
    listTaxItemQueue(globals.challanId);
  }

  _launchURL() async {
    String reference = referenceCtrl.text;
    String amount = amountCtrl.text;
    String tender_by = tenderByCtrl.text;
    String from = fromCtrl.text;
    String to = toCtrl.text;

    String url = globals.paymentUrl + '?reference='+ reference +'&amount='+ amount +'&tender_by='+ tender_by +'&from='+ from +'&to='+ to;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future listTaxItemQueue(String newQuery) async {
    is_loading = true;
    print("chalan parameter : " + newQuery);
    var search = await _epaymentApi.challan_list_for_payment(newQuery);
    print(search.list[0].tax_challan_id);
    setState(() {
      is_loading = false;
      challan_queue = search.list;

      referenceCtrl.text = search.list[0].queue_session;
      amountCtrl.text = search.list[0].tax_challan_amount;
      tenderByCtrl.text = search.list[0].tax_depositors_name;
      fromCtrl.text = search.list[0].tax_challan_from_dt;
      toCtrl.text = search.list[0].tax_challan_to_dt;
      statusCtrl.text = search.list[0].tax_challan_status;
      transactionStatusCtrl.text = search.list[0].tax_transaction_status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Payment"),
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

    challanIdCnt.text = globals.challanId;

    return new Column(
      children: <Widget>[
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Tax Challan ID',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: challanIdCnt
        ),
        TextFormField(
            //initialValue: 'Pune',
            decoration: new InputDecoration(
            labelText: 'Reference Number',
        ),
            enabled : false,
        onSaved: (String val) {
        //_invoice.ship_to = val;
        },
        controller: referenceCtrl
        ),
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Amount',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: amountCtrl
        ),
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Tender By',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: tenderByCtrl
        ),
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Period From',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: fromCtrl
        ),
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Period To',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: toCtrl
        ),
        /*
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Challan Status',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: statusCtrl
        ),
        */
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Challan Transaction Status',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: transactionStatusCtrl
        ),
        SizedBox(
          height: 20.0,
        ),
        (!payment_called) ? Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.greenAccent,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              setState(() {
                //isLoading = true;
                payment_called = true;
                _launchURL();
              });
              //_validateInputs(context);
              //register_user(context);
            },
            child: Text("Make Payment",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ) : Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.greenAccent,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              listTaxItemQueue(challanIdCnt.text);
            },
            child: Text("Refresh",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              Navigator.pushNamed(context, '/test');
            },
            child: Text("Back",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),


        /*
        const SizedBox(height: 30),

        new Row(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _launchURL();
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
            RaisedButton(
              onPressed: () {
                listTaxItemQueue(challanIdCnt.text);
              },
              child: Text('get datar'),
            )

            /*
            RaisedButton(
              onPressed: _launchURL,
              child: Text('Make Payment'),
            ),
            */
          ],
        ),
        */
      ],
    );
  }










}

