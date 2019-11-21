import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hp_one/netwoklayer/challan.dart';
import 'package:hp_one/netwoklayer/epayment.dart';
import 'package:hp_one/netwoklayer/epayment_api.dart';
import 'package:hp_one/netwoklayer/invoice.dart';
import 'package:hp_one/netwoklayer/invoice_api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'package:flutter/material.dart';
import 'package:hp_one/netwoklayer/tax.dart';
import 'package:hp_one/netwoklayer/taxtype_api.dart';
import 'package:hp_one/netwoklayer/commodity_api.dart';
import 'package:hp_one/netwoklayer/tax_api.dart';
import 'package:hp_one/netwoklayer/commodity.dart';
import 'package:http/http.dart' as http;
import 'package:hp_one/model/post.dart';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'package:hp_one/globals.dart' as globals;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';


import 'package:hp_one/util/device_data.dart';

class InvoicePage extends StatefulWidget {
  @override
  _Invoice createState() {
    return _Invoice();
  }
}

class _Invoice extends State<InvoicePage> {
/*
*  Start Variable declarations
*/

  int user_type;

  _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.username = prefs.getString('username');
    globals.usertype = prefs.getInt('usertype').toString();
    globals.userid = prefs.getInt('userid').toString();
  }

  //variable to hide show rows of form
  Invoice _invoice = new Invoice();
  InvoiceApi _invoiceApi = new InvoiceApi();
  final _formKey = GlobalKey<FormState>();
  List<String> items = [""];
  bool _autoValidate = false;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  List<Challan> tax_queue;
  EpaymentApi _epaymentApi = new EpaymentApi();
  bool is_loading = false;

  Invoice invoice = new Invoice();

  TextEditingController challanFilterCnt = TextEditingController();
  TextEditingController registeredUsersCnt = TextEditingController();

  TextEditingController invoice_noCnt = TextEditingController();
  TextEditingController invoiceDateCnt = TextEditingController();
  TextEditingController invoice_amountCnt = TextEditingController();
  TextEditingController vehicle_numberCnt = TextEditingController();
  TextEditingController transaction_typeCnt = TextEditingController();
  TextEditingController consigner_gstCnt = TextEditingController();
  TextEditingController firm_nameCnt = TextEditingController();
  TextEditingController firm_addressCnt = TextEditingController();
  TextEditingController consignee_gstCnt = TextEditingController();
  TextEditingController consignee_firm_nameCnt = TextEditingController();
  TextEditingController bill_toCnt = TextEditingController();
  TextEditingController ship_toCnt = TextEditingController();
  TextEditingController identificationNoCnt = TextEditingController();

  bool isLoading;

  String _identificationVal;

/*
*  End Variable declarations
*/




  Future listTaxItemQueue(String newQuery) async {
    is_loading = true;
    var search = await _epaymentApi.challan_list(newQuery);

    setState(() {
      is_loading = false;
      tax_queue = search.list;
    });
  }

  @override
  void initState() {
    user_type = 1;
    _checkLogin();
    isLoading = false;
    //listTaxItemQueue("");
    super.initState();
    _identificationVal = '';
    _invoice.is_registered = "1";
  }


  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

  void _handleRadioValueChange1(int value) {
    setState(() {
      user_type = value;
      _invoice.is_registered = user_type.toString();
      switch (user_type) {
        case 1:
        //Fluttertoast.showToast(msg: 'Correct !',toastLength: Toast.LENGTH_SHORT);

          Toast.show("Registered Users!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

          break;
        case 0:
        //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          Toast.show("Unregistered Users!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          break;
      }
    });
  }


  @override
  Widget build (BuildContext ctxt) {

    Widget registeredUsersDropdown = TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: registeredUsersCnt,
          decoration: InputDecoration(
              labelText: 'Source'
          )
      ),
      suggestionsCallback: (pattern) async {
        return await _epaymentApi.challan_user_list(pattern);;
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          //leading: Icon(Icons.shopping_cart),
          //title: Text(suggestion.id),
          //subtitle: Text('\$${suggestion.description}'),
          title: Text(suggestion.tax_depositors_name),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        registeredUsersCnt.text = suggestion.tax_depositors_name;
        //// _tax.source_location = suggestion.description;
        print(suggestion.tax_depositors_name);
      },
      validator: (value) {
        if(value.isEmpty) {
          return 'Please select a city';
        }
      },
      //onSaved: (value) => _selectedCity = value,
    );

    Future record_invoice(context) async {
      var response;

      response = await _invoiceApi.add(_invoice);
      Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      if(response['success']) {isLoading = false;
      print("in success");
      setState(() {
        isLoading = false;
      });

      invoice_noCnt.text = "";
      invoiceDateCnt.text = "";
      invoice_amountCnt.text = "";
      vehicle_numberCnt.text = "";
      transaction_typeCnt.text = "";
      consigner_gstCnt.text = "";
      firm_nameCnt.text = "";
      firm_addressCnt.text = "";
      consignee_gstCnt.text = "";
      consignee_firm_nameCnt.text = "";
      bill_toCnt.text = "";
      ship_toCnt.text = "";
      _identificationVal = "";
      identificationNoCnt.text = "";

      } else {
        setState(() {
          isLoading = false;
        });
        print("in else");
      }
    }

    void _validateInputs(context) {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables

        // No any error in validation
        _formKey.currentState.save();

        record_invoice(context);
        //print("Name $_firstname");
        // print("Mobile $_mobile");
        //print("Email $_email");
      } else {
//    If all data are not valid then start auto validation.
        setState(() {
          isLoading = false;
          _autoValidate = true;
        });
      }
    }

    final usertypeField = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: 1,
          groupValue: user_type,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Registered',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: 0,
          groupValue: user_type,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Unregistered',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        )
      ],
    );

    Widget invoice_block = new Row(
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            //_tax.total_tax = totaltaxCnt.text;
            // print(_tax.tax_item_id);

            // add_tax(context);

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
                'Update',
                style: TextStyle(fontSize: 20)
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              // is_edit = false;
            });
            // clear_fields();

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
                'Cancle',
                style: TextStyle(fontSize: 20)
            ),
          ),
        ),
      ],
    );
// /*
    String format_date(var date) {
      var formatter = new DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(date);
      print(formatted); // something like 2013-04-20
      return formatted;
    }

    String validateName(String value) {
      if (value.length < 3)
        return 'Should not be empty';
      else
        return null;
    }

    final invoiceNoField = TextFormField(
        decoration: new InputDecoration(
            labelText: 'Invoice Number'
        ),
        validator: validateName,

        onSaved: (String val) {
          _invoice.invoice_no = val;
        },
        autofocus: false,
        //initialValue: 'invoice001',
        controller: invoice_noCnt
    );


    final invoiceDateField = TextFormField(
      obscureText: false,
      //style: style,
      controller: invoiceDateCnt,
      validator: validateName,
      onSaved: (String val) {
        _invoice.invoice_no = val;
      },
      onTap: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(1940, 1, 1),
            // maxTime: DateTime(2099, 6, 7), onChanged: (date) {
            maxTime: DateTime(2099, 6, 7), onChanged: (date) {
              print('change $date');
              invoiceDateCnt.text = date.toString();
              _invoice.invoice_date = date.toString();
            }, onConfirm: (date) {
              invoiceDateCnt.text = format_date(date);
              _invoice.invoice_date = format_date(date);
              print('confirm $date');
            }, currentTime: DateTime.now());
      },
      decoration: InputDecoration(
          labelText: 'Invoice Date'
      ),
    );

    final invoiceAmountField = TextFormField(
        //initialValue: '20000',
        decoration: new InputDecoration(
          labelText: 'Invoice Amount',
        ),
        onSaved: (String val) {
          _invoice.invoice_amount = val;
        },
        keyboardType: TextInputType.number,
        controller: invoice_amountCnt
    );
    final vehicleNumberField = TextFormField(
        //initialValue: 'MH12AC1234',
        decoration: new InputDecoration(
          labelText: 'Vehicle Number',
        ),
        onSaved: (String val) {
          _invoice.vehicle_number = val;
        },
        controller: vehicle_numberCnt
    );
    final transactionTypeField = TextFormField(
        //initialValue: 'Paid',
        decoration: new InputDecoration(
          labelText: 'Transaction Type',
        ),
        onSaved: (String val) {
          _invoice.transaction_type = val;
        },
        controller: transaction_typeCnt
    );
    final consignerGstField = TextFormField(
        //initialValue: 'ABCDEFGHI',
        decoration: new InputDecoration(
          labelText: 'Consigner GST',
        ),
        onSaved: (String val) {
          _invoice.consigner_gst = val;
        },
        controller: consigner_gstCnt
    );
    final firmNameField = TextFormField(
        //initialValue: 'Suresh',
        decoration: new InputDecoration(
          labelText: 'Firm Name',
        ),
        onSaved: (String val) {
          _invoice.firm_name = val;
        },
        controller: firm_nameCnt
    );

    final firmAddressField = TextFormField(
        //initialValue: 'Nashik',
        decoration: new InputDecoration(
          labelText: 'Firm Address',
        ),
        onSaved: (String val) {
          _invoice.firm_address = val;
        },
        controller: firm_addressCnt
    );


    final consigneeGstField = TextFormField(
        //initialValue: 'HIJKLMNO',
        decoration: new InputDecoration(
          labelText: 'Consignnee GST',
        ),
        onSaved: (String val) {
          _invoice.consignee_gst = val;
        },
        controller: consignee_gstCnt
    );
    final consigneeFirmNameField = TextFormField(
        //initialValue: 'Deepak',
        decoration: new InputDecoration(
          labelText: 'Consignee Firm Name',
        ),
        onSaved: (String val) {
          _invoice.consignee_firm_name = val;
        },
        controller: consignee_firm_nameCnt
    );
    final billToField = TextFormField(
        //initialValue: 'Suresh',
        decoration: new InputDecoration(
          labelText: 'Bill To',
        ),
        onSaved: (String val) {
          _invoice.bill_to = val;
        },
        controller: bill_toCnt
    );
    final shipToField = TextFormField(
        //initialValue: 'Pune',
        decoration: new InputDecoration(
          labelText: 'Ship To',
        ),
        onSaved: (String val) {
          _invoice.ship_to = val;
        },
        controller: ship_toCnt
    );
    final identificationNoField = TextFormField(
        decoration: new InputDecoration(
          labelText: 'Identification Number',
        ),
        onSaved: (String val) {
          _invoice.identification_number = val;
        },
        controller: identificationNoCnt
    );

    final recordButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          _validateInputs(context);
          //register_user(context);
        },
        child: Text("Record Invoice",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    List<DropdownMenuItem<String>> _dropDownMenuItems;
    String _selectedIdentification;

    void changedDropDownItem(String selectedIdentification) {
      print("Called : changedDropDownItem");
      setState(() {
        _selectedIdentification = selectedIdentification;
      });
    }

    List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List commodity) {
      List<DropdownMenuItem<String>> items = new List();
      int i = 0;
      for (String com in commodity) {
        items.add(new DropdownMenuItem(value: "", child: new Text(com.toString())));
        i++;
      }
      return items;
    }

    _dropDownMenuItems = buildAndGetDropDownMenuItems(["Adhar Card", "Voter Id", "Driving Lisence"]);

    Widget identification_dropdown1 = new DropdownButton(
      value: _selectedIdentification,
      items: _dropDownMenuItems,
      onChanged: changedDropDownItem,
      isExpanded: true,
      style: new TextStyle(
          color: Colors.black,
          //fontWeight: FontWeight.normal,
          //fontSize: 15.0,
          decorationStyle: TextDecorationStyle.dotted
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice Recording"),
      ),
      body:  new SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  usertypeField,
                  //(user_type == 1) ? registeredUsersDropdown :  new SizedBox.shrink(),
                  //(user_type == 2) ? new Column(
                  new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        invoiceNoField,
                        invoiceDateField,
                        invoiceAmountField,
                        vehicleNumberField,
                        transactionTypeField,
                        (user_type == 1) ? consignerGstField :  new SizedBox.shrink(),
                        firmNameField,
                        firmAddressField,
                        consigneeGstField,
                        consigneeFirmNameField,
                        billToField,
                        shipToField,
                        //identification_dropdown,
                        (user_type == 0) ? Container(
                         // padding: EdgeInsets.all(16),
                          color: Colors.white,
                          child: DropDownFormField(
                            titleText: 'Identification Type',
                            hintText: 'Please choose one',
                            value: _identificationVal,
                            onSaved: (value) {
                              setState(() {
                                _identificationVal = value;
                                _invoice.identification_type = value;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _identificationVal = value;
                                _invoice.identification_type = value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Adhar Card",
                                "value": "adhar",
                              },
                              {
                                "display": "Voting Card",
                                "value": "voting",
                              },
                              {
                                "display": "Driving License",
                                "value": "driving",
                              }
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ) :  new SizedBox.shrink(),
                        (user_type == 0) ? identificationNoField :  new SizedBox.shrink(),
                        SizedBox(
                          height: 20.0,
                        ),
                        (!isLoading) ? recordButon : CircularProgressIndicator(),
                      ]
                  )
                  //):  new SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}

