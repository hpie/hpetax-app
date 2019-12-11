import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hpetax/networklayer/epayment.dart';
import 'package:hpetax/networklayer/epayment_api.dart';
import 'package:hpetax/networklayer/user_api.dart';
import 'package:intl/intl.dart';


import 'package:toast/toast.dart';

import 'package:hpetax/globals.dart' as globals;


import 'package:hpetax/util/device_data.dart';

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
  TextEditingController addressCnt = TextEditingController();
  TextEditingController locationCnt = TextEditingController();

  EpaymentApi _epaymentApi = new EpaymentApi();
  Epayment _epayment = new Epayment();

  //User _user = new User();
  UserApi _userApi = new UserApi();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  List _ddoName = [""];
  List _ddoVal = [""];

  List _receiptName = [""];
  List _receiptVal = [""];

  //String _selectedDdo, _selectedReceipt;

  String _selectedDdo = "";
  String _selectedReceipt = "";


  List<DropdownMenuItem<String>> _dropDownDdoItems;
  List<DropdownMenuItem<String>> _dropDownReceiptItems;

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(data) {
    //print("In dropdown item : ");
    //print(data);
    List<DropdownMenuItem<String>> items = new List();
    int i = 0;
    for (String record in data) {
      items.add(new DropdownMenuItem(value: _ddoVal[i].toString(), child: new Text(record)));
      i++;
    }
    return items;
  }
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems2(data) {
    List<DropdownMenuItem<String>> items = new List();
    int i = 0;
    for (String record in data) {
      items.add(new DropdownMenuItem(value: _receiptVal[i].toString(), child: new Text(record.toString())));
      i++;
    }
    return items;
  }

  void changedDropDownDdo(String data) {
    //print("Called : changedDropDownDdo");

    setState(() {
      _selectedDdo = data;

     // print("Selected ddo : " + _selectedDdo);
    });
  }

  void changedDropDownReceipt(String data) {
    //print("Called : changedDropDownReceipt");

    setState(() {
      _selectedReceipt = data;

      //print("Selected ddo : " + _selectedReceipt);
    });
    //}
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    getPaymentData("");

    if(globals.username != "" && globals.username != null) {
      print("User name : " + globals.username);
      getUserData(globals.userid);
      dealerTypeCnt.text = "Registered";
    } else {
      dealerTypeCnt.text = "Unregistered";
    }
    /*
    if(globals.username != "") {
      getUserData(globals.userid);
    }
    dealerTypeCnt.text = (globals.username != "") ? "Registered" : "Unregistered";
    */
    // =========== test purpose ===============
    /*
    var now1 = new DateTime.now();
    personNameCnt.text = "Suresh " + (now1.millisecondsSinceEpoch).toString();
    mobileNumberCnt.text = "9156497693";
    emailCnt.text = "sureshramsakha@gmail.com";
    addressCnt.text = "Nashik";
    locationCnt.text = "Pune";
    taxPeriodFromCnt.text = "2019-12-06";
    taxPeriodToCnt.text = "2019-12-08";
*/
    //===================================
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
      _epayment.tax_type = search[0]["tax_type_name"].toString();
      _epayment.purpose = search[0]["challan_purpose"].toString();
      _epayment.code = search[0]["challan_code"].toString();
      _epayment.amount = search[0]["tax_amount"].toString();

      //print(search[0]["LocationDDO"]);
      //print(search[0]["receiptHead"]);

      updateDdoDropdown(search[0]["LocationDDO"]);
      updateReceiptDropdown(search[0]["receiptHead"]);
    });
  }

  updateDdoDropdown(data) {
    //print("update dropdown called");
    //print(data);
    for(var i = 0; i < data.length; i++){
      if(data[i]['tax_location_ddo_name'] != "") {
        _ddoName.add(data[i]['tax_location_ddo_location'].trim() + ' - ' + data[i]['tax_location_ddo_code'].trim());
        _ddoVal.add(data[i]['tax_location_ddo_code']);
      }
    }

    //<?php echo $row['tax_location_ddo_location']; ?> - <?php echo $row['tax_location_ddo_code']; ?>

    //print("dropdown names");
    //print(_ddoName);
    setState(() {
      _dropDownDdoItems = buildAndGetDropDownMenuItems(_ddoName);
    });
  }

  updateReceiptDropdown(data) {
    //print("update Receipt dropdown called");
    //print(data);
    //print(_receiptName);
    for(var i = 0; i < data.length; i++){
      if(data[i]['tax_revenue_receipt_name'].trim() != "") {
        _receiptName.add(data[i]['tax_revenue_receipt_name'].trim());
        _receiptVal.add(data[i]['tax_revenue_receipt_id']);
      }
    }
  //<option class="" value="<?php echo $row['tax_receipt_head']; ?>"><?php echo $row['tax_revenue_receipt_name']; ?></option>
    //print("receipt dropdown names");
    //print(_receiptVal);
    setState(() {
      _dropDownReceiptItems = buildAndGetDropDownMenuItems2(_receiptName);
    });
  }
  /*
  Future updateTaxtypeDropdown(data) async {

    print("Called : updateTaxtypeDropdown");
    var search = await _taxtypeApi.search(newQuery);

    for(var i = 0; i < search.list.length; i++){
      _taxtype.add(search.list[i].tax_type_name.trim());
      _taxtypeVal.add(search.list[i].tax_type_id.trim());
    }

    setState(() {
      _dropDownMenuItems = buildAndGetDropDownMenuItems(_taxtype);
    });
  }
  */
  Future add_epayment_data(context) async {
    var response;

    response = await _epaymentApi.add(_epayment, _selectedDdo.toLowerCase(), _selectedReceipt.toLowerCase());

    Toast.show(response["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    if(response["success"]) {
      //print("in success");
      globals.challanId = response["challan_id"];
      globals.selectedTaxType = "";

      var now = new DateTime.now();
      print(now.millisecondsSinceEpoch);

      // commented for test purpose
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

  String validateDate(String value) {
    if (value == "")
      return 'Please enter date';
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

  /*
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
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Challan Details"),
          //automaticallyImplyLeading:false,

        ),
        body: new Column(
            children: <Widget>[
              new Expanded(
                  child: new ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                            children: <Widget>[
                              new Form(key: _formKey,child: formUI2()),
                            ]
                        );
                      }
                  )
              ),
              const SizedBox(height: 10),
              (!isLoading) ? new Row (
                children: <Widget>[
                  Expanded(
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.lightBlueAccent,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () {
                          setState(() {
                            //isLoading = true;
                          });
                          _validateInputs(context);
                        },
                        child: Text("Submit",
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () {
                          Navigator.pushNamed(context, '/epayment_form');
                        },
                        child: Text("Back",
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ) : CircularProgressIndicator(),
              const SizedBox(height: 10),
            ]
        )
    );
  }

  Widget formUI2() {

    eptaxtypeCnt.text = globals.selectedTaxType;

    return new Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        child : Column(
      children: <Widget>[
        TextFormField(
            decoration: new InputDecoration(
                labelText: 'Invoice Number'
            ),
            enabled : false,
            controller: eptaxtypeCnt
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Location Name ",
            style: TextStyle(
                fontSize: globals.smallfontSize,
            ),
          ),
        ),
        new DropdownButton(
          value: _selectedDdo,
          items: _dropDownDdoItems,
          onChanged: changedDropDownDdo,
          isExpanded: true,
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: globals.mediumfontSize,
              decorationStyle: TextDecorationStyle.dotted),

        ),
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Receipt ",
            style: TextStyle(
                fontSize: globals.smallfontSize,
            ),
          ),
        ),
        new DropdownButton(
          value: _selectedReceipt,
          items: _dropDownReceiptItems,
          onChanged: changedDropDownReceipt,
          isExpanded: true,
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: globals.mediumfontSize,
              decorationStyle: TextDecorationStyle.dotted),

        ),
        /*
        new DropdownButton(
          value: _selectedTaxType,
          items: _dropDownMenuItems,
          onChanged: changedDropDownItem,
          isExpanded: true,
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: mediumfontSize,
              decorationStyle: TextDecorationStyle.dotted),

        ),*/
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
            controller: addressCnt
        ),
/*
        TextFormField(
          decoration: new InputDecoration(
              labelText: 'Location'
          ),
          onChanged: (text) {
            _epayment.location = text;
          },
            controller: locationCnt
        ),
*/
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
          validator: validateDate,
          onSaved: (String val) {
            _epayment.tax_period_from = val;
          },
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(1940, 1, 1),
                // maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                  taxPeriodFromCnt.text = format_date(date);
                  _epayment.tax_period_from = format_date(date);
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
          validator: validateDate,
          onSaved: (String val) {
            _epayment.tax_period_to = val;
          },
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(1940, 1, 1),
                // maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                  taxPeriodToCnt.text = format_date(date);
                  _epayment.tax_period_to = format_date(date);
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

      ],
    ));
  }

  void _validateInputs(context) {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables

      // No any error in validation
      _formKey.currentState.save();
      print("hiiiiiiiiiiiiiiiiiiiii");
      print(_epayment.tax_period_from);
      print(_epayment.tax_period_to);
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

