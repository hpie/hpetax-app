import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
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

class TestPage extends StatefulWidget {
  @override
  _Test createState() {
    var frm_data = new DeviceData();
    frm_data.get_data();
    return _Test();
  }
}

class _Test extends State<TestPage> {
/*
*  Start Variable declarations
*/
  //variable to hide show rows of form
  String distance = "0";
  String weight = "0";
  String places = "0";
  String passengers = "0";

  List<Tax> tax_queue;

  double total_tax = 0.0;

  bool is_edit = false;
  bool is_edit_loading = false;

  // Text controllers
  TextEditingController sourceLocationCnt = TextEditingController();
  TextEditingController destinationLocationCnt = TextEditingController();
  TextEditingController passengersCnt = TextEditingController();
  TextEditingController distanceCnt = TextEditingController();
  TextEditingController vehicleCnt = TextEditingController();
  TextEditingController totaltaxCnt = TextEditingController();
  TextEditingController weightCnt = TextEditingController();

  TextEditingController editTaxTypeCnt = TextEditingController();
  TextEditingController editCommodityCnt = TextEditingController();

  TaxtypeApi _taxtypeApi;
  CommodityApi _commodityApi;
  Tax _tax = new Tax();
  TaxApi _taxApi = new TaxApi();
/*
*  End Variable declarations
*/

  final _formKey = GlobalKey<FormState>();
  List<String> items = [""];

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Unregistered"),
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

  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset : true,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(Icons.list))
              ],
            ),
            title: Text('Unregistered'),
          ),
          body: TabBarView(
            children: [
              new ListView(
            shrinkWrap: true,
            //padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Form(key: _formKey,child: formUI()),
                  )
                //child: new Form(key: _formKey,child: Text("Hello")),
              )
              ]
              ),
              new Column(
                children: <Widget>[
                  new Expanded(
                      child: new ListView.builder(
                        itemCount: (tax_queue != null) ? tax_queue.length : 0,
                        itemBuilder: (context, index) {

                          if(tax_queue != null) {
                            /*
                    return ListTile(
                      title: Text('${tax_queue[index].tax_item_id}'),
                    );
                    */
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
                                                _editQueueItem(tax_queue[index].tax_item_id, context);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                _deleteQueueItem(tax_queue[index].tax_item_id);
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
                                              "Queue ID :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].tax_item_queue_id,
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
                                              "Tax Type :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].tax_type,
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
                                              "Commodity :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].tax_commodity_name,
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
                                              "Vehicle Number :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].vehicle_number,
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
                                              "Weight :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].weight,
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
                                              "Unit :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].unit,
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
                                              "Quantity :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].quantity,
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
                                              "Source Location :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].source_location,
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
                                              "Destination Location :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].destination_location,
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
                                              "Distance (in Km within HP) :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].distance,
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
                                              "Total Tax (in Rs.) :",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
                                            child: Text(
                                              tax_queue[index].total_tax,
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          )
                                        ]
                                    )

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
                          } else {
                            return ListTile(
                              title: Text('List is empty'),
                            );
                          }
                        },
                      )
                  ),
                  new Row(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {


                          if(tax_queue != null && tax_queue.length > 0) {
                            Navigator.pushNamed(context, '/epayment');
                          } else {
                            Toast.show("Please add items to queue", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }

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

                    ],
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  //List _currentCommodityVal;

  Commodity commodityObj = new Commodity();

  List _taxtypeVal = [""];
  List _taxtype = [""];

  List _commodityname = [""];
  List _commodityid = [""];


  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<String>> _dropDownMenuItems2;

  String _selectedTaxType, _selectedCommodity;
  int _selectedForm = 0;

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List taxtype) {
    List<DropdownMenuItem<String>> items = new List();
    int i = 0;
    for (String type in taxtype) {
      items.add(new DropdownMenuItem(value: _taxtypeVal[i].toString(), child: new Text(type)));
      i++;
    }
    return items;
  }
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems2(List commodity) {
    List<DropdownMenuItem<String>> items = new List();
    int i = 0;
    for (String com in commodity) {
      items.add(new DropdownMenuItem(value: _commodityid[i].toString(), child: new Text(com.toString())));
      i++;
    }
    return items;
  }

  void changedDropDownItem(String selectedType) {
    print("Called : changedDropDownItem");
    //clear_fields();
    listTaxItemQueue("");
    updateCommodityDropdown(selectedType);

    setState(() {
      weight = "0";
      places = "0";
      distance = "0";
      passengers = "0";

      if(selectedType == "AG") {
        places = "1";
        distance = "1";
      }

      if(selectedType == "PTCG") {
        distance = "1";
        passengers = "1";
      }

      if(selectedType == "CGCR") {
        places = "1";
        distance = "1";
      }

      _selectedTaxType = selectedType;
    });
  }

  void changedDropDownItem2(String selectedCommodity) {
    print("Called : changedDropDownItem2");
    //if(!is_edit) {
      getCommodityDetails(selectedCommodity);
      setState(() {
        _selectedCommodity = selectedCommodity;
        print(selectedCommodity);
      });
    //}
  }

  @override
  void initState() {
    _selectedCommodity = "";

    _taxtypeApi = new TaxtypeApi();
    _commodityApi = new CommodityApi();

    updateTaxtypeDropdown("");
    listTaxItemQueue("");
    super.initState();
  }

  /*
  List items of tax queue
   */
  Future listTaxItemQueue(String newQuery) async {
    var search = await _taxApi.list(newQuery);

    setState(() {
      tax_queue = search.list;

      if(tax_queue.length > 0) {
        globals.selectedTaxType = tax_queue[0].tax_type;
        _selectedTaxType = tax_queue[0].tax_type;
        editTaxTypeCnt.text = get_txtype_from_code(_selectedTaxType);
        updateCommodityDropdown(_selectedTaxType);
      }
    });
  }

  String get_txtype_from_code(String tax_code) {
    if(_taxtypeVal.indexOf(tax_queue[0].tax_type) > 0) {
      print("=======_taxtype string : ======== : " + (_taxtype[_taxtypeVal.indexOf(tax_queue[0].tax_type)]).toString());

      return _taxtype[_taxtypeVal.indexOf(tax_queue[0].tax_type)];
    }

    return "";
  }

  /*
  * When page loads for first time
   */
  Future updateTaxtypeDropdown(String newQuery) async {

    print("Called : updateTaxtypeDropdown");
    var search = await _taxtypeApi.search(newQuery);

    for(var i = 0; i < search.list.length; i++){
      _taxtype.add(search.list[i].tax_type_name.trim());
      _taxtypeVal.add(search.list[i].tax_type_id.trim());
    }

    setState(() {
      _dropDownMenuItems = buildAndGetDropDownMenuItems(_taxtype);
      if(globals.selectedTaxType != "") {
        _selectedTaxType = globals.selectedTaxType;
      } else {
        _selectedTaxType = _dropDownMenuItems[0].value;
      }
    });


  }

  Future updateCommodityDropdown(String newQuery) async {

    print("Called : updateCommodityDropdown");
    var search = await _commodityApi.search(newQuery);

    _commodityname = [""];
    _commodityid = [""];
    if(search.list != null) {
      for (var i = 0; i < search.list.length; i++) {
        _commodityname.add(search.list[i].tax_commodity_name.trim());
        _commodityid.add(search.list[i].tax_commodity_id.trim());
      }
    }

    setState(() {
      _dropDownMenuItems2 = buildAndGetDropDownMenuItems2(_commodityname);
      _selectedCommodity = _dropDownMenuItems[0].value;
    });

    if(is_edit_loading) {
      is_edit_loading = false;
      changedDropDownItem2(_tax.tax_commodity_id);
      setState(() {
        _selectedCommodity = _tax.tax_commodity_id;
      });
    }

  }

  Future getCommodityDetails(String newQuery) async {
    print("Called : getCommodityDetails");
    if(!is_edit) {
    var search = await _commodityApi.getdata(newQuery);
    commodityObj.data(search);
    totaltaxCnt.text = commodityObj.tax_commodity_taxcalculation;

    _tax.tax_type_id = commodityObj.tax_type_id;
    // _tax.tax_type                   = commodityObj.tax_type_id;
    _tax.tax_commodity_id = commodityObj.tax_commodity_id;
    _tax.tax_commodity_name = commodityObj.tax_commodity_name;
    _tax.tax_commodity_description = commodityObj.tax_commodity_description;
    _tax.unit = commodityObj.tax_commodity_unit_measure;

    setState(() {
      if (_selectedTaxType == "AG") {
        weight = "1";
      } else {
        weight = "0";
      }
    });
  }
    if(is_edit) {
      //set_edit_values();
    }
  }

  _editQueueItem(String item_id, context) {
    //clear_fields();
    print("edit_called : " + item_id);

    for(var i = 0; i < tax_queue.length; i++){
      if(tax_queue[i].tax_item_id == item_id) {

        _tax.tax_item_id = tax_queue[i].tax_item_id;
        _tax.tax_item_queue_id = tax_queue[i].tax_item_queue_id;
        _tax.tax_queue_session = tax_queue[i].tax_queue_session;

        _tax.tax_type_id = tax_queue[i].tax_type_id;
        _tax.tax_type = tax_queue[i].tax_type;
        _tax.tax_commodity_id = tax_queue[i].tax_commodity_id;
        _tax.tax_commodity_name = tax_queue[i].tax_commodity_name;
        _tax.tax_commodity_description = tax_queue[i].tax_commodity_description;
        _tax.vehicle_number = tax_queue[i].vehicle_number;
        _tax.weight = tax_queue[i].weight;
        _tax.unit = tax_queue[i].unit;
        _tax.quantity = tax_queue[i].quantity;
        _tax.source_location = tax_queue[i].source_location;
        _tax.destination_location = tax_queue[i].destination_location;
        _tax.distance = tax_queue[i].distance;
        _tax.total_tax = tax_queue[i].total_tax;
      }
    }


    //changedDropDownItem(_tax.tax_type);

    //clear_fields();
    DefaultTabController.of(context).animateTo(0);

    setState(() {
      is_edit = true;
      is_edit_loading = true;
    });

    set_edit_values();
  }

  set_edit_values() {
    print("Called : set_edit_values");

    changedDropDownItem(_tax.tax_type);

    editTaxTypeCnt.text = _tax.tax_type;
    editCommodityCnt.text = _tax.tax_commodity_name;
    totaltaxCnt.text = _tax.total_tax;
    sourceLocationCnt.text = _tax.source_location;
    destinationLocationCnt.text = _tax.destination_location;
    passengersCnt.text = _tax.quantity;
    weightCnt.text = _tax.weight;
    vehicleCnt.text = _tax.vehicle_number;
    distanceCnt.text = _tax.distance;

    setState(() {
      //is_edit_loading = false;
    });
  }

  Future _deleteQueueItem(String item_id) async {
    var response = await _taxApi.delete(item_id);


    print("Called : _deleteQueueItem");
    print(response);

    Toast.show(response.message, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);


    if(response.success) {
      print("in success");
      clear_fields();
      setState(() {
        listTaxItemQueue("");
      });
    } else {
      print("in else");
    }

  }



  clear_fields() {

    changedDropDownItem("");
    setState((){
      _selectedTaxType = "";
    });

    totaltaxCnt.text = "";
    sourceLocationCnt.text = "";
    destinationLocationCnt.text = "";
    passengersCnt.text = "";
    weightCnt.text = "";
    vehicleCnt.text = "";
    distanceCnt.text = "";
  }

  Future add_tax(context) async {
    var response;

    //response = await _taxApi.add(_tax);
    ///*
    if(!is_edit) {
      print("edit false");
      Tax.item_queue_id++;
      response = await _taxApi.add(_tax);
    } else {
      print("edit true");
      response = await _taxApi.update(_tax);
    }
    //*/
    //print(Tax.item_queue_id);

    Toast.show(response.message, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    if(response.success) {
      print("in success");
      clear_fields();
      setState(() {
        listTaxItemQueue("");
      });
    } else {
      print("in else");
    }


    //Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();
    //Alert.toast(context,"Very long toast",position: ToastPosition.bottom, duration: ToastDuration.long);
    /*
    if(response.success) {
      setState(() {
        // listTaxItemQueue("");
      });
    } else {

    }
    */

    /*

    */
    /*
    print("==========In add =================");
    print(_tax.total_tax);
    if(response.success) {
      clear_fields();
    }
    */
  }

  Widget formUI() {
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
    (!is_edit && globals.selectedTaxType == "") ? new DropdownButton(
          value: _selectedTaxType,
          items: _dropDownMenuItems,
          onChanged: changedDropDownItem,
          isExpanded: true,
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 10.0,
              decorationStyle: TextDecorationStyle.dotted),

        ) : new TextField(
            decoration: new InputDecoration(hintText: "Tax Type",
              filled: true,
              fillColor: Colors.grey,
            ),
            enabled : false,
            controller: editTaxTypeCnt
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Commodity / Description :",
            style: TextStyle(fontSize: 15,
                fontWeight:FontWeight.bold),
          ),
        ),
        (!is_edit) ? new DropdownButton(
          value: _selectedCommodity,
          items: _dropDownMenuItems2,
          onChanged: changedDropDownItem2,
          isExpanded: true,
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 15.0,
              decorationStyle: TextDecorationStyle.dotted),
        ) : new TextField(
        decoration: new InputDecoration(hintText: "Commodity",
          filled: true,
          fillColor: Colors.grey,
        ),
        enabled : false,
        controller: editCommodityCnt
        ),

    (weight == "1") ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: new TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Weight"
                    ),
                    keyboardType: TextInputType.number,
                    controller: weightCnt,
                    onChanged: (text) {
                      totaltaxCnt.text = (double.parse(text) * double.parse(commodityObj.tax_commodity_taxcalculation)).toString();
                      _tax.weight = text;
                    }
                ),
              ),
            ),
            new Align(
              alignment: Alignment.topLeft,
              child: Text(
                commodityObj.tax_commodity_unit_measure,
                style: TextStyle(
                  // fontSize: 20,
                  // fontWeight:FontWeight.bold
                ),
              ),
            )
          ],
        ) : new SizedBox.shrink(),
        (places == "1") ? new Column(
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(hintText: "Source Location"),
                controller: sourceLocationCnt,
              onChanged: (text) {
                _tax.source_location = text;
              }
            ),
            new TextField(
              decoration: new InputDecoration(hintText: "Destination Location"),
                controller: destinationLocationCnt,
              onChanged: (text) {
                _tax.destination_location = text;
              }
            )
          ]
        ) : new SizedBox.shrink(),
        (distance == "1") ? new TextField(
          decoration: new InputDecoration(hintText: "Distance (in Km) within HP"),
          controller: distanceCnt,
          onChanged: (text) {
            _tax.distance = text;
          }
        ) : new SizedBox.shrink(),
        (passengers == "1") ? new TextField(
          decoration: new InputDecoration(hintText: "No. of Passenger"),
          controller: passengersCnt,
          onChanged: (text) {
          _tax.quantity = text;
          },
        ) : new SizedBox.shrink(),
        new TextField(
          decoration: new InputDecoration(hintText: "Vehicle Number"),
          controller: vehicleCnt,
          onChanged: (text) {
            _tax.vehicle_number = text;
          }
        ),
        new TextField(
          decoration: new InputDecoration(hintText: "Total Tax (In Rs.)"),
          controller: totaltaxCnt,
          onChanged: (text) {
            _tax.total_tax = text;
          }
        ),
        const SizedBox(height: 30),
        (!is_edit) ? RaisedButton(
          onPressed: () {
            _tax.total_tax = totaltaxCnt.text;
            print("total Tax : " + _tax.total_tax);

            add_tax(context);

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
                'Add',
                style: TextStyle(fontSize: 20)
            ),
          ),
        ) : new SizedBox.shrink(),
    (is_edit) ? new Row(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _tax.total_tax = totaltaxCnt.text;
                print(_tax.tax_item_id);

                add_tax(context);

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
                  is_edit = false;
                });
                clear_fields();

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
        ) : new SizedBox.shrink(),
      ],
    );
  }
}

