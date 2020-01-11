import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hpetax/networklayer/challan.dart';
import 'package:hpetax/networklayer/epayment_api.dart';
import 'package:hpetax/networklayer/invoice.dart';
import 'package:hpetax/networklayer/invoice_api.dart';
import 'package:hpetax/networklayer/user_api.dart';
import 'package:hpetax/util/widget_source.dart';
import 'package:intl/intl.dart';
//import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hpetax/globals.dart' as globals;


class RecordinvoicePage extends StatefulWidget {
  @override
  _Recordinvoice createState() {
    return _Recordinvoice();
  }
}

class _Recordinvoice extends State<RecordinvoicePage> {
/*
*  Start Variable declarations
*/

  String user_type, registered_search_query_key, unregistered_search_query_key;

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
  UserApi _userApi = new UserApi();
  bool is_loading = false;

  List<Invoice> search_result;

  Invoice invoice = new Invoice();

  TextEditingController challanFilterCnt = TextEditingController();
  TextEditingController registeredUsersCnt = TextEditingController();

  TextEditingController invoice_noCnt = TextEditingController();
  TextEditingController invoiceDateCnt = TextEditingController();
  TextEditingController invoiceInspectedDate = TextEditingController();
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
  TextEditingController searchFieldCnt = TextEditingController();

  bool isLoading;

  String _identificationVal;
  String search_text = "";

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
    user_type = "registered";
    registered_search_query_key = "tax_dealer_code";
    unregistered_search_query_key = "identification_number";
    _checkLogin();
    isLoading = false;
    //listTaxItemQueue("");
    super.initState();
    _identificationVal = '';
    _invoice.is_registered = "1";

    setState(() {
      search_result = null;
    });

    apply_values(false);
  }

  void apply_values(is_empty) {
    //challanFilterCnt.text = (is_empty) ? "" : "";
    //registeredUsersCnt.text = (is_empty) ? "" : "";

    invoice_noCnt.text = (is_empty) ? "" : "INC1234";
    invoiceDateCnt.text = (is_empty) ? "" : "2019-12-10";
    invoiceInspectedDate.text = (is_empty) ? "" : "2019-12-16";
    invoice_amountCnt.text = (is_empty) ? "" : "2000";
    vehicle_numberCnt.text = (is_empty) ? "" : "vehicle number";
    transaction_typeCnt.text = (is_empty) ? "" : "transaction type";
    consigner_gstCnt.text = (is_empty) ? "" : "consigner gst";
    firm_nameCnt.text = (is_empty) ? "" : "firm name";
    firm_addressCnt.text = (is_empty) ? "" : "firm address";
    consignee_gstCnt.text = (is_empty) ? "" : "consignee gst";
    consignee_firm_nameCnt.text = (is_empty) ? "" : "consignee firm name";
    bill_toCnt.text = (is_empty) ? "" : "bill to";
    ship_toCnt.text = (is_empty) ? "" : "ship to";
    identificationNoCnt.text = (is_empty) ? "" : "identificationNo";
  }


  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

  void _handleRadioValueChange1(String value) {
    setState(() {
      user_type = value;
      _invoice.is_registered = user_type.toString();
      switch (user_type) {
        case "registered":
        //Fluttertoast.showToast(msg: 'Correct !',toastLength: Toast.LENGTH_SHORT);

          Toast.show("Registered Users!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

          break;
        case "unregistered":
        //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          Toast.show("Unregistered Users!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          break;
      }
    });
  }

  void _handleRegisteredRadioValueChange1(String value) {
    setState(() {
      registered_search_query_key = value;
      switch (registered_search_query_key) {
        case "tax_dealer_code":
        //Fluttertoast.showToast(msg: 'Correct !',toastLength: Toast.LENGTH_SHORT);

          Toast.show("Registered key 1! " + registered_search_query_key, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

          break;
        case "consigner_firm_name":
        //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          Toast.show("Registered key 0! " + registered_search_query_key, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          break;
      }
    });
  }

  void _handleUnRegisteredRadioValueChange1(String value) {
    setState(() {
      unregistered_search_query_key = value;
      switch (unregistered_search_query_key) {
        case "identification_number":
        //Fluttertoast.showToast(msg: 'Correct !',toastLength: Toast.LENGTH_SHORT);

          Toast.show("Registered Users! " + unregistered_search_query_key, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

          break;
        case "consigner_firm_name":
        //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          Toast.show("Unregistered Users! " + unregistered_search_query_key, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          break;
      }
    });
  }


  @override
  Widget build (BuildContext ctxt) {

    //=====================Pdf code========================================

    //=============================================================

    /*
  List items of tax queue
   */
    Future get_search_records(String newQuery) async {

      print("User type : " + user_type.toString());
      print("registered_search_query_key : " + registered_search_query_key.toString());
      print("unregistered_search_query_key : " + unregistered_search_query_key.toString());

      String search_column_key = (user_type == 1) ?  registered_search_query_key.toString() : unregistered_search_query_key.toString();
      var search = await _invoiceApi.search_record(user_type.toString(),search_column_key, search_text);

      setState(() {
        search_result = search.list;
      });
      print(search_result);

      /*
      print(search['Result'][0]['tax_edt_invoice_id']);
      for(var i = 0; i < search['Result'].length; i++){
       search_result.add(search['Result'][i]);
      }
      print(search_result);
      */
      /*
      setState(() {
        tax_queue = search.list;

        if (tax_queue != null && tax_queue.length > 0) {

        } else {
          globals.selectedTaxType = "";
          globals.selectedVehicleNumber = "";
        }

        // }
      });
      */

    }

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
      invoiceInspectedDate.text = "";
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
          value: "registered",
          groupValue: user_type.toString(),
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Registered',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: "unregistered",
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

    final registeredSearchTypeField = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: "tax_dealer_code",
          groupValue: registered_search_query_key,
          onChanged: _handleRegisteredRadioValueChange1,
        ),
        new Text(
          'Dealer Code',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: "consigner_firm_name",
          groupValue: registered_search_query_key,
          onChanged: _handleRegisteredRadioValueChange1,
        ),
        new Text(
          'Firm Name',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        )
      ],
    );

    final unregisteredSearchTypeField = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: "identification_number",
          groupValue: unregistered_search_query_key,
          onChanged: _handleUnRegisteredRadioValueChange1,
        ),
        new Text(
          'Identification Number',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: "consigner_firm_name",
          groupValue: unregistered_search_query_key,
          onChanged: _handleUnRegisteredRadioValueChange1,
        ),
        new Text(
          'Firm Name',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        )
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


    final searchField = TextFormField(
        decoration: new InputDecoration(
          labelText: 'Search Text',
        ),
        onChanged: (String val) {
          search_text = val;
        },
        controller: searchFieldCnt
    );

    final searchButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            //isLoading = true;
          });

          print("User type : " + user_type.toString());
          print("registered_search_query_key : " + registered_search_query_key.toString());
          print("unregistered_search_query_key : " + unregistered_search_query_key.toString());
          get_search_records("");
        },
        child: Text("Search",
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

    _fetchDetails(String item_id, context) {
      print(item_id);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Epayment"),
          //automaticallyImplyLeading:false,

        ),
        body: new Column(
            children: <Widget>[
              usertypeField,
              (user_type == "registered") ? registeredSearchTypeField :  new SizedBox.shrink(),
              (user_type == "unregistered") ? unregisteredSearchTypeField :  new SizedBox.shrink(),
              searchField,
              const SizedBox(height: 10),
              searchButton,
              new Expanded(
                  child: new ListView.builder(
                      itemCount: (search_result != null) ? search_result.length : 0,
                      itemBuilder: (context, index) {
                        if(search_result != null) {
                          return Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0) //                 <--- border radius here
                                )
                            ),
                            child:
                            /*
                            new Column(
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            color: Colors.lightBlue,
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              _fetchDetails(search_result[index].tax_edt_invoice_id, context);
                                            },
                                          ),
                                        )
                                      ]
                                  ),
                                  new Align(alignment: Alignment.bottomRight,
                                    child: FloatingActionButton(
                                        child: new Icon(Icons.add),
                                        onPressed: (){}),
                                  ),
                                  list_get_content("Queue ID :", search_result[index].invoice_no, index),
                                ]
                            )
                              */
                            new Stack(children: <Widget>[
                            new Column(
                            children: <Widget>[
                              list_get_content("Queue ID :", search_result[index].invoice_no, index),
                              list_get_content("Firm Name:", search_result[index].consigner_firm_name, index),
                              list_get_content("Firm Address :", search_result[index].invoice_no, index),
                              ]
                            ),
                              new Align(alignment: Alignment.bottomRight,
                                child: IconButton(
                                  color: Colors.lightBlue,
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                   // _fetchDetails(search_result[index].tax_edt_invoice_id, context);

                                    globals.invoice_recording_user_type = user_type;
                                    globals.invoice_recording_user_id = search_result[index].tax_edt_invoice_id;
                                    Navigator.pushNamed(context, '/invoice_recording');
                                  },
                                ),
                              )
                            ],
                            )
                          );
                        } else {
                          return ListTile(
                            title: Text('List is empty'),
                          );
                        }
                      },
                  )
              ),
              /*
              const SizedBox(height: 10),
              (!isLoading) ? recordButon : CircularProgressIndicator(),
              const SizedBox(height: 10),
              */
            ]
        )
    );
  }
}

