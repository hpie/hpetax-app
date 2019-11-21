import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hp_one/netwoklayer/challan.dart';
import 'package:hp_one/netwoklayer/epayment.dart';
import 'package:hp_one/netwoklayer/epayment_api.dart';
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

import 'package:hp_one/globals.dart' as globals;


import 'package:hp_one/util/device_data.dart';

class UserchallanPage extends StatefulWidget {
  @override
  _Userchallan createState() {
    return _Userchallan();
  }
}

class _Userchallan extends State<UserchallanPage> {
/*
*  Start Variable declarations
*/

  _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.username = prefs.getString('username');
    globals.usertype = prefs.getInt('usertype').toString();

    print("user_challan.dart user name : " + globals.username);
    print("user_challan.dart user typeLogged in : " + globals.usertype);
  }

  //variable to hide show rows of form
  TextEditingController challanFilterCnt = TextEditingController();
  List<Challan> tax_queue;
  EpaymentApi _epaymentApi = new EpaymentApi();
  bool is_loading = false;

/*
*  End Variable declarations
*/

  final _formKey = GlobalKey<FormState>();
  List<String> items = [""];


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
    _checkLogin();
    listTaxItemQueue("");
    super.initState();
  }
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Challan"),
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

  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  @override
  Widget build (BuildContext ctxt) {

    final challanFilterField = new TextField(
      controller: eCtrl,
      onSubmitted: (text) {
       // litems.add(text);
        listTaxItemQueue(text);
        eCtrl.clear();
        setState(() {});
      },
    );

    Widget get_challan(var data) {
      //return new Text(data);
      return TextFormField(
        obscureText: false,

        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: data,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      );
    }

    final customLoaderField =  CircularProgressIndicator();
    
    Widget get_challan_data(challan_item) {
      return Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          //_editQueueItem(challan_item.tax_item_id, context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          //_deleteQueueItem(challan_item.tax_item_id);
                        },
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "ID",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.tax_challan_id,
                        //"hello",
                        style: TextStyle(fontSize: 12.0),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ]
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Person :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.tax_depositors_name,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              /*
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Mobile :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.mobile_number,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Email :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.email,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Address :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.address,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Location :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.location,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Dealer Type :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.dealer_type,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Tax From :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.tax_period_from,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Tax To :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.tax_period_to,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Purpose :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.purpose,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Code :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.code,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        "Amount :",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                      child: Text(
                        challan_item.amount,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ]
              )
              */
            ],
          ),
/*
                          ],
                        ),
                        */
          Divider(
            height: 2.0,
            color: Colors.grey,
          )
        ],
      );
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text("Challan List"),),
        body: new Column(
          children: <Widget>[
            challanFilterField,
            (is_loading == true) ? customLoaderField : new Expanded(
                child: new ListView.builder
                  (
                    itemCount: (tax_queue != null) ? tax_queue.length : 1,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      //return get_challan(litems[Index]);
                      if(tax_queue != null) {
                        return get_challan_data(tax_queue[Index]);
                      } else {
                        return ListTile(
                          title: Text('List is empty'),
                        );
                      }
                    }
                )
            )
          ],
        )
    );
  }
}

