import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:async';
import 'package:tax/globals.dart' as globals;
import 'package:tax/networklayer/commodity.dart';
import 'package:tax/networklayer/commodity_api.dart';
import 'package:tax/networklayer/places_api.dart';
import 'package:tax/networklayer/tax.dart';
import 'package:tax/networklayer/tax_api.dart';
import 'package:tax/networklayer/taxtype_api.dart';
import 'package:tax/util/function_collection.dart';
import 'package:tax/util/widget_source.dart';
import 'package:toast/toast.dart';

class EpaymentformPage extends StatefulWidget {
  @override
  _Epaymentform createState() {
    //var frm_data = new DeviceData();
    //frm_data.get_data();
    return _Epaymentform();
  }
}
//enum Departments { Production, Research, Purchasing, Marketing, Accounting }
class _Epaymentform extends State<EpaymentformPage> {
/*
*  Start Variable declarations
*/
  //variable to hide show rows of form
  String distance = "0";
  String weight = "0";
  String places = "0";
  String passengers = "0";
  String sourcePlaceId, destinationPlaceId;
  double smallfontSize = 15;
  double mediumfontSize = 20;
  double bigfontSize = 25;

  String cess_text = "0";

  double commodity_rate = 0.0;
  int commodity_rate_unit = 0;
  String commodity_measure_unit = "";
  String commodity_tax_calculation = "";
  bool commodity_isdistancedependent = true;

  List<Tax> tax_queue;

  double total_tax = 0.0;

  bool is_edit = false;
  bool is_edit_loading = false;
  bool vehicleIsEnabled = true;

  // Text controllers
  TextEditingController sourceLocationCnt = TextEditingController();
  TextEditingController destinationLocationCnt = TextEditingController();
  TextEditingController passengersCnt = TextEditingController();
  TextEditingController distanceCnt = TextEditingController();
  TextEditingController vehicleCnt = TextEditingController();
  TextEditingController taxCnt = TextEditingController();
  TextEditingController cessCnt = TextEditingController();
  TextEditingController totaltaxCnt = TextEditingController();
  TextEditingController weightCnt = TextEditingController();

  TextEditingController editTaxTypeCnt = TextEditingController();
  TextEditingController editCommodityCnt = TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TaxtypeApi _taxtypeApi;
  CommodityApi _commodityApi;
  Tax _tax = new Tax();
  TaxApi _taxApi = new TaxApi();
  PlacesApi _placesApi = new PlacesApi();

  TextStyle contentTxt = TextStyle(fontSize: 16.0);
  TextStyle labelTxt = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey);
/*
*  End Variable declarations
*/

  final _formKey = GlobalKey<FormState>();
  List<String> items = [""];

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
              title: (globals.usertype == "") ? Text('Unregistered') : Text('Challan'),
              leading: IconButton(icon:Icon(Icons.arrow_back),
                  onPressed:() {
                    if(globals.isLoggedIn != "") {
                      Navigator.pushNamed(context, '/dashboard');
                    } else {
                      Navigator.pushNamed(context, '/landing');
                    }
                  }
              )
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

                            return Container(
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0) //                 <--- border radius here
                                    )
                                ),
                                child:  new Column(
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
                                                  color: Colors.lightBlue,
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    _editQueueItem(tax_queue[index].tax_item_id, context);
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: IconButton(
                                                  color: Colors.black38,
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    _deleteQueueItem(tax_queue[index].tax_item_id);
                                                  },
                                                ),
                                              )
                                            ]
                                        ),

                                        list_get_content("Queue ID :", tax_queue[index].tax_item_queue_id, index),
                                        list_get_content("Tax Type :", tax_queue[index].tax_type, index),
                                        list_get_location("Tax Commodity :", tax_queue[index].tax_commodity_name, index),
                                        list_get_content("Vehicle Number :", tax_queue[index].vehicle_number, index),
                                        (commodityObj.tax_type_id != "PGT") ? list_get_content("Weight :", tax_queue[index].weight, index) : new SizedBox.shrink(),

                                        (tax_queue[index].unit != "0" && commodityObj.tax_type_id != "PGT" && commodityObj.tax_commodity_taxcalculation == "BY_WEIGHT") ? list_get_content("Unit :",
                                            tax_queue[index].unit, index)  : new SizedBox.shrink(),

                                        (tax_queue[index].quantity != "0" && commodityObj.tax_type_id != "PGT" && commodityObj.tax_commodity_taxcalculation == "BY_COUNT") ? list_get_content("Quantity :",
                                            tax_queue[index].quantity, index)  : new SizedBox.shrink(),


                                        list_get_location("Source Location :",
                                            tax_queue[index].source_location, index),
                                        list_get_location("Destination Location :",
                                            tax_queue[index].destination_location, index),

                                        (commodityObj.tax_type_id != "PGT") ? list_get_content("Distance (in Km within HP) :", tax_queue[index].distance, index) : new SizedBox.shrink(),
                                        list_get_content("Total Tax (in Rs.) :", tax_queue[index].total_tax, index),
                                      ],
                                    ),

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
                  const SizedBox(height: 10),
                  list_submit_data(context, tax_queue),

                  const SizedBox(height: 10),
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
        //weight = "1";
        places = "1";
        distance = "1";
      }

      if(selectedType == "PTCG") {
        distance = "1";
        passengers = "1";
      }

      if(selectedType == "CGCR") {
        // weight = "1";
        places = "1";
        distance = "1";
      }

      sourceLocationCnt.text = "" ;
      destinationLocationCnt.text = "" ;
      weightCnt.text = "" ;
      passengersCnt.text = "" ;
      distanceCnt.text = "" ;
      vehicleCnt.text = "" ;
      taxCnt.text = "" ;
      cessCnt.text = "" ;
      totaltaxCnt.text = "" ;

      _selectedTaxType = selectedType;
    });
  }

  void changedDropDownItem2(String selectedCommodity) {
    print("Called : changedDropDownItem2");
    //if(!is_edit) {

    setState(() {
      _selectedCommodity = selectedCommodity;
      /*
      weight = "0";
      places = "0";
      distance = "0";
      passengers = "0";
      */
      getCommodityDetails(selectedCommodity);
      /*
      if(_selectedTaxType == "AG") {
        places = "1";
        distance = "1";
      }

      if(_selectedTaxType == "PTCG") {
        distance = "1";
        passengers = "1";
      }

      if(_selectedTaxType == "CGCR") {
        places = "1";
        distance = "1";
      }
      print(selectedCommodity);
      */
    });
    //}
  }

  @override
  void initState() {
    _selectedCommodity = "";

    _taxtypeApi = new TaxtypeApi();
    _commodityApi = new CommodityApi();

    sourcePlaceId = "";
    destinationPlaceId = "";

    updateTaxtypeDropdown("");
    listTaxItemQueue("");
    super.initState();
  }




  Future calculate_distance() async {
    print("calculate_distance Called : Source - " + sourcePlaceId + " ||| Desitnation - " + destinationPlaceId);
    if(sourcePlaceId != "" && destinationPlaceId != "") {
      var distanceData = await _placesApi.get_distance(
          sourcePlaceId, destinationPlaceId);

      if(distanceData["status"] == "OK") {
        var calculated_distance = (distanceData["rows"][0]["elements"][0]["distance"]["value"] / 1000).round();

        _tax.distance = calculated_distance.toString();

        distanceCnt.text = calculated_distance.toString();
      }
    }
  }

  /*
  List items of tax queue
   */
  Future listTaxItemQueue(String newQuery) async {

    var search = await _taxApi.list(newQuery);

    setState(() {
      tax_queue = search.list;
      //if(tax_queue != null) {
      // if (tax_queue.length > 0) {
      if (tax_queue != null && tax_queue.length > 0) {
        globals.selectedTaxType = tax_queue[0].tax_type;
        globals.selectedVehicleNumber = tax_queue[0].vehicle_number;

        print("check vehicle number : " + tax_queue[0].vehicle_number);
        if(tax_queue[0].vehicle_number != null && tax_queue[0].vehicle_number != "" && tax_queue.length >= 1) {
          print("in false");
          vehicleIsEnabled = false;
        } else {
          print("in true");
          vehicleIsEnabled = true;
        }
        _selectedTaxType = tax_queue[0].tax_type;
        editTaxTypeCnt.text = get_txtype_from_code(_selectedTaxType);

        //set vehicle number
        vehicleCnt.text = tax_queue[0].vehicle_number;
        _tax.vehicle_number = tax_queue[0].vehicle_number;
        updateCommodityDropdown(_selectedTaxType);
      } else {
        globals.selectedTaxType = "";
        globals.selectedVehicleNumber = "";
        vehicleIsEnabled = true;
      }
      // }
    });

  }

  String get_txtype_from_code(String tax_code) {
    if(_taxtypeVal.indexOf(tax_queue[0].tax_type) > 0) {
      //print("=======_taxtype string : ======== : " + (_taxtype[_taxtypeVal.indexOf(tax_queue[0].tax_type)]).toString());

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
      _dropDownMenuItems = buildAndGetDropDownMenuItems(_taxtype, _taxtypeVal);
      _dropDownMenuItems2 = buildAndGetDropDownMenuItems2([""], [""]);
      if(globals.selectedTaxType != "") {
        _selectedTaxType = globals.selectedTaxType;
      } else {
        _selectedTaxType = _dropDownMenuItems[0].value;
      }
      if(globals.selectedVehicleNumber != "") {
        vehicleCnt.text = globals.selectedVehicleNumber;
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
      _dropDownMenuItems2 = buildAndGetDropDownMenuItems2(_commodityname, _commodityid);
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
      _tax.tax_type                   = commodityObj.tax_type_id;
      _tax.tax_commodity_id = commodityObj.tax_commodity_id;
      _tax.tax_commodity_name = commodityObj.tax_commodity_name;
      _tax.tax_commodity_description = commodityObj.tax_commodity_description;
      _tax.unit = commodityObj.tax_commodity_unit_measure;

      setState(() {

        commodity_rate = commodityObj.tax_commodity_rate;
        commodity_rate_unit = commodityObj.tax_commodity_rate_unit;
        commodity_measure_unit = commodityObj.tax_commodity_unit_measure;
        commodity_tax_calculation = commodityObj.tax_commodity_taxcalculation;
        commodity_isdistancedependent = (commodityObj.tax_commodity_isdistancedependent == "NO") ? true : false;

        taxCnt.text = (commodityObj.tax_commodity_rate).toString();
        cess_text = commodityObj.tax_commodity_cess.toString();
        if(commodityObj.tax_commodity_cess > 0) {
          show_cess = true;
         var calculated_cess =  commodityObj.tax_commodity_cess / 100 * commodityObj.tax_commodity_rate;
          totaltaxCnt.text = (commodityObj.tax_commodity_rate + calculated_cess).toString();
          cessCnt.text = calculated_cess.toString();
        } else {
          show_cess = false;
          totaltaxCnt.text = (commodityObj.tax_commodity_rate).toString();
        }
        /*
        if (_selectedTaxType == "AG") {
          weight = "1";
        } else if(_selectedTaxType == "CGCR") {
          weight = "1";
        } else {
          weight = "0";
        }
        */

        print("====== : " + commodityObj.tax_type_id);
        if(_tax.tax_type == "AG") {
          weight = "1";
          places = "1";
          distance = "1";
        }

        if(_tax.tax_type == "PTCG") {
          distance = "1";
          passengers = "1";
        }

        if(_tax.tax_type == "CGCR") {
          weight = "1";
          places = "1";
          distance = "1";
        }
      });
    }
    if(is_edit) {
      //set_edit_values();
      print("edit called tax type : " + _tax.tax_type);
      setState(() {
        if(_tax.tax_type == "AG") {
          weight = "1";
          places = "1";
          distance = "1";
        }

        if(_tax.tax_type == "PTCG") {
          distance = "1";
          passengers = "1";
        }

        if(_tax.tax_type == "CGCR") {
          weight = "1";
          places = "1";
          distance = "1";
        }
      });

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
      weight = "0";
      places = "0";
      distance = "0";
      passengers = "0";

      if(_tax.tax_type == "AG") {
        weight = "1";
        places = "1";
        distance = "1";
      }

      if(_tax.tax_type == "PTCG") {
        distance = "1";
        passengers = "1";
      }

      if(_tax.tax_type == "CGCR") {
        weight = "1";
        places = "1";
        distance = "1";
      }
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

    sourcePlaceId = "";
    destinationPlaceId = "";
  }

  Future add_tax(context) async {
    var response;

    if(!is_edit) {
      print("edit false");
      Tax.item_queue_id++;
      response = await _taxApi.add(_tax);
    } else {
      print("edit true");
      response = await _taxApi.update(_tax);
    }

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


  bool loading = true;
  bool show_cess = false;

  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedCity;


  Widget formUI() {
    List<String> source_places = [];
    final TextEditingController sourcePlacesCtrl = new TextEditingController();

    Widget sourceDropdown = TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: sourceLocationCnt,
          decoration: InputDecoration(
              labelText: 'Source'
          )
      ),
      suggestionsCallback: (pattern) async {
        print("========= : " + pattern);
        return await _placesApi.get_places(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          //title: Text(suggestion.description),
            title : places_suggestions(suggestion.description)
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        sourceLocationCnt.text = suggestion.description;
        _tax.source_location = suggestion.description;
        sourcePlaceId = suggestion.place_id;

        calculate_distance();
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please select a city';
        }
        return "";
      },
      onSaved: (value) => _selectedCity = value,
    );

    Widget destinationDropdown = TypeAheadFormField(
      autoFlipDirection : true,
      textFieldConfiguration: TextFieldConfiguration(
          controller: destinationLocationCnt,
          decoration: InputDecoration(
              labelText: 'Destination'
          )
      ),
      suggestionsCallback: (pattern) async {
        return await _placesApi.get_places(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          //title: Text(suggestion.description),
          title : places_suggestions(suggestion.description)
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        destinationLocationCnt.text = suggestion.description;
        _tax.destination_location = suggestion.description;
        destinationPlaceId = suggestion.place_id;
        calculate_distance();
        //print(suggestion.description);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please select a city';
        }
        return "";
      },
      onSaved: (value) => _selectedCity = value,
    );

    return new Column(
      children: <Widget>[
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Tax Type",
            style: TextStyle(
                fontSize: globals.smallfontSize,
                fontWeight:FontWeight.bold
            ),
          ),
        ),
        (!is_edit && globals.selectedTaxType == "") ? Container(

            margin: const EdgeInsets.only(bottom: 10.0),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              border: new Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: new BorderRadius.all(
              Radius.circular(5.0)),
            ),
            child : new Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.grey.shade200
                ),
                child : new DropdownButton(
             // elevation: 0,
          value: _selectedTaxType,
          items: _dropDownMenuItems,
          onChanged: changedDropDownItem,
          isExpanded: true,
          underline: Container(
            height: 0,
            color: Colors.deepPurpleAccent,
          ),
          style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: globals.mediumfontSize,
              //decorationStyle: TextDecorationStyle.dotted,
          ),

        ) )) : new TextField(
            decoration: new InputDecoration(hintText: "Tax Type",
              filled: true,
              fillColor: Colors.grey,
            ),
            style: TextStyle(
                fontSize: globals.smallfontSize,
                fontWeight:FontWeight.bold),
            enabled : false,
            controller: editTaxTypeCnt
        ),
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Commodity / Description :",
            style: TextStyle(fontSize: globals.smallfontSize,
                fontWeight:FontWeight.bold),
          ),
        ),
        (!is_edit) ? Container(
            //margin: const EdgeInsets.only(bottom: 5.0),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              border: new Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: new BorderRadius.all(
                  Radius.circular(5.0)),
            ),

    child : new Theme(
    data: Theme.of(context).copyWith(
    canvasColor: Colors.grey.shade200
    ),
    child : new DropdownButton(
          value: _selectedCommodity,
          items: _dropDownMenuItems2,
          onChanged: changedDropDownItem2,
          isExpanded: true,
              underline: Container(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: globals.mediumfontSize,
              decorationStyle: TextDecorationStyle.dotted),
        )) ) : new TextField(
            decoration: new InputDecoration(hintText: "Commodity",
              filled: true,
              fillColor: Colors.grey,
            ),
            enabled : false,
            controller: editCommodityCnt
        ),

        (weight == "1") ? form_weight_field(weightCnt, commodityObj, _tax, totaltaxCnt, taxCnt) : new SizedBox.shrink(),
        (places == "1") ? sourceDropdown : new SizedBox.shrink(),
        (places == "1") ? destinationDropdown : new SizedBox.shrink(),
        form_distance_field(commodityObj, _tax, totaltaxCnt, distanceCnt, passengersCnt, distance),
        form_passanger_field(commodityObj, _tax, totaltaxCnt, distanceCnt, passengersCnt, passengers),
        form_vehicle_field(vehicleCnt, vehicleIsEnabled, _tax),
        (show_cess) ? form_tax_field(taxCnt, _tax) : new SizedBox.shrink(),
        (show_cess) ? form_cess_field(cessCnt, _tax, cess_text) : new SizedBox.shrink(),
        form_total_field(totaltaxCnt, _tax),

        const SizedBox(height: 30),
        (!is_edit) ? Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlueAccent,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              _tax.total_tax = totaltaxCnt.text;
              print("total Tax : " + _tax.total_tax);

              add_tax(context);
            },
            child: Text("Add to queue",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ) : new SizedBox.shrink(),

        (is_edit) ? new Row (
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
                    _tax.total_tax = totaltaxCnt.text;
                    print(_tax.tax_item_id);

                    add_tax(context);
                    setState(() {
                      is_edit = false;
                    });
                    clear_fields();
                  },
                  child: Text("Update",
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
                    setState(() {
                      is_edit = false;
                    });
                    clear_fields();
                  },
                  child: Text("Cancel",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ) : new SizedBox.shrink(),
        //sourcePlacesFilterField,
      ],
    );
  }
}