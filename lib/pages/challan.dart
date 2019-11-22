import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hp_one/netwoklayer/user_api.dart';
//import 'package:flutter_date_picker/flutter_date_picker.dart';
import 'package:hp_one/util/validations.dart';
import 'package:intl/intl.dart';
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
  bool _autoValidate = false;
  bool isLoading;

  TextEditingController personNameCnt = TextEditingController();
  TextEditingController mobileNumberCnt = TextEditingController();
  TextEditingController emailCnt = TextEditingController();

  TextEditingController eptaxtypeCnt = TextEditingController();
  TextEditingController purposeCnt = TextEditingController();
  TextEditingController codeCnt = TextEditingController();
  TextEditingController totaltaxCnt = TextEditingController();
  TextEditingController taxPeriodFromCnt = TextEditingController();
  TextEditingController taxPeriodToCnt = TextEditingController();
  TextEditingController dealerTypeCnt = TextEditingController();

  EpaymentApi _epaymentApi = new EpaymentApi();
  Epayment _epayment = new Epayment();

  //User _user = new User();
  UserApi _userApi = new UserApi();

  CustomValidations _customValidations = new CustomValidations();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    super.initState();
    isLoading = false;
    getPaymentData("");

    if(globals.username != "") {
      getUserData(globals.userid);
    }
    dealerTypeCnt.text = (globals.username != "") ? "Registered" : "Unregistered";
  }

  /*
  get user details
   */
  Future getUserData(String newQuery) async {
    var response;
    //Toast.show("hiiiiiiiiiiiii", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    response = await _userApi.get_user(newQuery);
    Toast.show(response["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    ///*
    if(response["success"]) {
      print("in success");
      print(response);

      personNameCnt.text = response["tax_dealer_name"];
      mobileNumberCnt.text = response["tax_dealer_mobile"];
      emailCnt.text = response["tax_dealer_email"];

      dealerTypeCnt.text = (globals.username != "") ? "Registered" : "Unregistered";

    } else {
      print("in else");
    }
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
      setState(() {
        isLoading = false;
      });
      print("in else");
    }

  }

  String format_date(var date) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(date);
    print(formatted); // something like 2013-04-20
    return formatted;
  }
  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Epayment"),
          //automaticallyImplyLeading:false,

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

        TextFormField(
            decoration: new InputDecoration(
            labelText: 'Invoice Number'
        ),
        enabled : false,
        controller: eptaxtypeCnt
        ),
        TextFormField(
          validator: validateName,
            decoration: new InputDecoration(
                labelText: 'Name of Person'
            ),
            onChanged: (text) {
              _epayment.person_name = text;
            },
            onSaved: (String val) {
              _epayment.person_name = val;
            },
            controller: personNameCnt
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          validator: validateMobile,
          decoration: new InputDecoration(
              labelText: 'Mobile Number'
          ),
          onChanged: (text) {
            _epayment.mobile_number = text;
          },
            onSaved: (String val) {
              _epayment.mobile_number = val;
            },
            controller: mobileNumberCnt
        ),

        TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          decoration: new InputDecoration(
              labelText: 'Email ID'
          ),
          onChanged: (text) {
            _epayment.email = text;
          },
            onSaved: (String val) {
              _epayment.email = val;
            },
            controller: emailCnt
        ),

        TextFormField(
          decoration: new InputDecoration(
              labelText: 'Address'
          ),
          onChanged: (text) {
            _epayment.address = text;
          },
        ),

        TextFormField(
          decoration: new InputDecoration(
              labelText: 'Location'
          ),
          onChanged: (text) {
            _epayment.location = text;
          },
        ),

        TextFormField(
          decoration: new InputDecoration(
              labelText: 'Dealer Type'
          ),
          onChanged: (text) {
            _epayment.dealer_type = text;
          },
            onSaved: (String val) {
              _epayment.dealer_type = val;
            },
            controller: dealerTypeCnt
        ),


        TextFormField(
          obscureText: false,
          //style: style,
          controller: taxPeriodFromCnt,
          validator: validateName,
          onSaved: (String val) {
            _epayment.tax_period_from = val;
          },
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(1940, 1, 1),
                // maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                  taxPeriodFromCnt.text = date.toString();
                  _epayment.tax_period_from = date.toString();
                }, onConfirm: (date) {
                  taxPeriodFromCnt.text = format_date(date);
                }, currentTime: DateTime.now());
          },
          decoration: InputDecoration(
              labelText: 'Tax Period From'
          ),
        ),

        TextFormField(
          obscureText: false,
          //style: style,
          controller: taxPeriodToCnt,
          validator: validateName,
          onSaved: (String val) {
            _epayment.tax_period_to = val;
          },
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(1940, 1, 1),
                // maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                  taxPeriodToCnt.text = date.toString();
                  _epayment.tax_period_to = date.toString();
                }, onConfirm: (date) {
                  taxPeriodToCnt.text = format_date(date);
                }, currentTime: DateTime.now());
          },
          decoration: InputDecoration(
              labelText: 'Tax Period To'
          ),
        ),


        TextFormField(
          decoration: new InputDecoration(
              labelText: 'Purpose'
          ),
          enabled : false,
          controller: purposeCnt,
          onChanged: (text) {
            _epayment.purpose = text;
          },
        ),

        TextFormField(
          decoration: new InputDecoration(
              labelText: 'Code'
          ),
          enabled:false,
          controller: codeCnt,
          onChanged: (text) {
            _epayment.code = text;
          },
        ),
        TextFormField(
          decoration: new InputDecoration(
              labelText: 'Amount'
          ),
          enabled : false,
          controller: totaltaxCnt,
          onChanged: (text) {
            _epayment.amount = text;
          },
        ),


        const SizedBox(height: 30),

        new Row(
          children: <Widget>[
            (!isLoading) ? RaisedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                _validateInputs(context);
                //add_epayment_data(context);
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
            ) : CircularProgressIndicator(),
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
        RaisedButton(
          onPressed: () {
            setState(() {
              isLoading = false;
            });
            getUserData(globals.userid);
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
                'Get User',
                style: TextStyle(fontSize: 20)
            ),
          ),
        )
      ],
    );
  }

  void _validateInputs(context) {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables

      // No any error in validation
      _formKey.currentState.save();
print("hiiiiiiiiiiiiiiiiiiiii");
      add_epayment_data(context);

    } else {
//    If all data are not valid then start auto validation.
      print("hiiiiiiiiiielseriiiiiiiiiii");
      setState(() {
        isLoading = false;
        _autoValidate = true;
      });
    }
  }
}

