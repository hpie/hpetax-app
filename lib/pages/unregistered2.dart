import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hp_one/api.dart';

Future<Post> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}

class UnregisteredPage2 extends StatefulWidget {
  @override
  _Unregistered2 createState() {
    return _Unregistered2();
  }
}

class _Unregistered2 extends State<UnregisteredPage2> {
  final _formKey = GlobalKey<FormState>();
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


  static final CREATE_POST_URL = 'http://sptechnoweb.com/hp_tax/getCommodity.php';

  List _currentCommodityVal;

  List _taxtypeVal = ["", "AGT", "PGT", "PGTP", "CGCR"];

  List _taxtype = ["","Additional Goods Tax", "Passenger And Goods Tax", "Passenger Tax on Contract Carriage", "Certain Goods Carried by Road Tax"];


  List _agtVal = ["", "615", "616", "618", "619", "620", "621", "622", "623", "624", "625", "626"];
  List _agt = ["",
              "All type of yarn(excluding woolen yarn) : Rs. 3.00 per 10 kg or part thereof",
              "All types of Conductors and aluminium wire rods : Rs. 1.50 per 10 kg or part thereof",
              "Lime Stone : Rs. 26.25 Per Ton",
              "Carpets of all types : Rs. 10 per 10 kg or part thereof",
              "Terminalia Chebula(Harar fruit) and Terminalia Belerica(Behra fruit)  : Rs. 4 per 10 kg or part thereof",
              "Granite and Marble including Marble Chips and Pieces : Rs. 0.75 per 10 kg or part thereof",
              "Lime Stone Chips : Rs. 0.07 per 10 kg or part thereof",
              "Fly Ash : Rs. 26.25 per Ton",
              "Iron and Steel : Rs. 5.00 per Kg or part thereof",
              "Plastic goods,sheets,pipes films and mouldings excluding plastic footwear,plastic chips,plastic powder and plastic granules : Rs. 0.75 per kg or part thereof",
              "Barytes shale and Rock salt : Rs. 7 per Ton"];


  List _pgtVal = ["", "LT10", "10-20", "20-30", "30-120", "ABV120", "MINBUS", "BIGBUS", "SEAT9-12", "SEAT7-8", "AB1000", "UP1000", "AB1500"];

  List _pgt = ["",
  "less than 10 quintals",
  "between 10 - 20 quintals",
  "between 20 - 30 quintals",
  "between 30 - 120 quintals ( 6 tyres)",
  "above 120 quintals (10-18 tyres)",
  "Mini Bus",
  "Big Bus",
  "having seats between 9 - 12",
  "having seats between 7-8",
  "Cars/Vehicles above 1000CC and upto 1500CC",
  "Cars/Vehicles upto 1000CC",
  "Cars/Vehicles above 1500CC"];

  List _pgtpVal = ["", "SMDX", "DXBS", "ORBS", "NGES"];

  List _pgtp = ["",
  "Semi Deluxe Bus Services",
  "Deluxe Bus Services",
  "Ordinary Bus Services",
  "Night Express Services"];

  List _cgcrVal = ["", "250", "251", "252",
  "253",
  "254",
  "255",
  "256",
  "257",
  "258",
  "259",
  "260",
  "261",
  "262",
  "263",
  "264",
  "265",
  "266",
  "267",
  "268",
  "269",
  "270",
  "271",
  "272",
  "273",
  "274",
  "275",
  "276",
  "277",
  "278",
  "279",
  "280",
  "281",
  "282",
  "283",
  "284"];

  List _cgcr = ["",
  "Apples contained in the boxes upto 10 Kg.: Rs. 0.50 per box",
  "Apples contained in the boxes of more than 10 Kg and upto 20 Kg.:Rs. 1.00 per box",
  "Apples contained in any other packing or loose 10 Kg.:Rs.0.50 per kg",
  "Mangoes: Rs. 0.50 per 10 kg",
  "Mandrin, Sweet Oranges including Kinnu: Rs. 0.50 per 10 kg",
  "Apricots, Peaches, Plums: Rs. 0.50 per 10 kg",
  "Grapes: Rs. 0.50 per 10 kg",
  "Bananas: Rs. 0.50 per 10 kg",
  "Pears: Rs. 0.50 per 10 kg",
  "All other fruits: Rs. 0.50 per 10 kg",
  "Potatoes: Rs. 0.25 per 10 kg",
  "All other vegetables: Rs. 0.25 per 10 kg",
  "Forest produce: Timber (Sawn, Hakries, Dimdimas, logs)  Ballies and Rough Axed of All sizes : Rs. 65.00 per cum",
  "Forest produce: Khair Wood (including rots or in any other form): Rs. 90.00 per quintal",
  "Forest produce: Fuel Wood and Chil Pulpwood: Rs. 10.00 per quintal",
  "Seeds: Seeds of all forest species like Deodar,Kail,Chil and Broad leaved species : Rs. 10.00 per 10 Kg",
  "Other Forest Produce: Bhabar Grass : Rs. 5.00 per quintal",
  "Other Forest Produce: Bamboo, Barberies,Emblica offcianale or (Amla fruit) and Resin :  Rs. 2.00 per 10 Kg",
  "Other Forest Produce: Diescoreca, Saussure lappa (Kuth) Retha: Rs. 4.00 per 10 Kg",
  "Other Forest Produce: Centiana Karu (Kaur), Jurinea or Macrorephila (Dhoop)Picrothiza Karrosa (Kaur, Karu): Rs. 5.00 per 10 Kg",
  "Other Forest Produce: Juglansregia (Akhrot bark and fruit), or Violserpens Violaodorata (Banafsha)and Chilgoza: Rs. 10.00 per 10 Kg",
  "Other Forest Produce: Carum Carvi (Kala Zeera and Katha ) (excluding Kutch): Rs. 30 per 10 Kg",
  "Other Forest Produce: Rauwelfia Serpantina (Rauwelfia): Rs. 75 per 10 Kg",
  "Other Forest Produce: Marchella Esculents (Guchhi): Rs. 30 per 10 Kg",
  "Other Forest Produce: Kutch: Rs. 1.70 per 10 kg",
  "Bricks: Rs 65 Per Thousand Unit",
  "Bajri : Rs. 10 Per Ton",
  "Sand : Rs. 10 Per Ton",
  "Other minerals (excluding  Barytes, Shale and Rock Salt): Rs. 7 Per Ton",
  "Cement: Rs.7.50 per bag of 50 KG",
  "Brick bats: Rs. 22.00 per ton",
  "Clinker: Rs. 160.00 per ton",
  "Prepared explosive, safety fuses, detonating  fuses, detonating caps, detonators and propellant powder: Rs. 5.00 per 10 Kg",
  "Tobacoo in all forms, including Pan Masala, Pan Chatney and Preparations containing Tobacoo or,  Tobacoo substitutes: Rs. 3.00 per kg",
  "Packaged drinking water: Rs. 2.00 per 10 litre"];


  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<String>> _dropDownMenuItems2;

  String _selectedTaxType, _selectedCommodity;
  int _selectedForm = 0;

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List taxtype) {
    List<DropdownMenuItem<String>> items = new List();
    int i = 0;
    for (String type in taxtype) {
      print(" =====_taxtypeVal===== : " + _taxtypeVal[i]);
      items.add(new DropdownMenuItem(value: _taxtypeVal[i].toString(), child: new Text(type)));
      i++;
    }
    return items;
  }
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems2(List commodity) {
    List<DropdownMenuItem<String>> items = new List();
    int i = 0;
    for (String com in commodity) {
      print(" =====_currentCommodityVal===== : " + _currentCommodityVal[i]);
      items.add(new DropdownMenuItem(value: _currentCommodityVal[i].toString(), child: new Text(com.toString())));
      i++;
    }
    return items;
  }

  void changedDropDownItem(String selectedType) {
    setState(() {
      _selectedTaxType = selectedType;
      print("Selected tax type : " + selectedType);
      _selectedForm = 1;

      if(selectedType == "AGT") {
        _currentCommodityVal = _agtVal;
        _dropDownMenuItems2 = buildAndGetDropDownMenuItems2(_agt);
      } else if(selectedType == "PGT") {
        _currentCommodityVal = _pgtVal;
        _dropDownMenuItems2 = buildAndGetDropDownMenuItems2(_pgt);
      } else if(selectedType == "PGTP") {
        _currentCommodityVal = _pgtpVal;
        _dropDownMenuItems2 = buildAndGetDropDownMenuItems2(_pgtp);
      } else if(selectedType == "CGCR") {
        _currentCommodityVal = _cgcrVal;
        _dropDownMenuItems2 = buildAndGetDropDownMenuItems2(_cgcr);
      }

    });
  }

  void changedDropDownItem2(String selectedCommodity) {
    setState(() {
      _selectedCommodity= selectedCommodity;
      print(selectedCommodity);

    });
  }

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_taxtype);
    _selectedTaxType = _dropDownMenuItems[0].value;
    _selectedCommodity = "";
    super.initState();
  }

  @override
  void changeState() {

  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Tax Type",
            style: TextStyle(fontSize: 20,
            fontWeight:FontWeight.bold),
          ),
        ),
        new DropdownButton(
          value: _selectedTaxType,
          items: _dropDownMenuItems,
          onChanged: changedDropDownItem,
          isExpanded: true,
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 10.0,
              decorationStyle: TextDecorationStyle.dotted),

        ),
        //new Text("Commodity / Description: "),
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Commodity / Description :",
            style: TextStyle(fontSize: 20,
                fontWeight:FontWeight.bold),
          ),
        ),
        new DropdownButton(
          value: _selectedCommodity,
          items: _dropDownMenuItems2,
          onChanged: changedDropDownItem2,
          isExpanded: true,
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 10.0,
              decorationStyle: TextDecorationStyle.dotted),
        ),
        new Row(
          children: [
            Text(
              'Flutter',
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 30.0
              ),
            ),
            Text(
              'Flutter',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0
              ),
            ),
          ],
        ),
        new TextField(
          decoration: new InputDecoration(hintText: "Source Location"),
        ),
        new TextField(
          decoration: new InputDecoration(hintText: "Destination Location"),
        ),
        new TextField(
          decoration: new InputDecoration(hintText: "Distance (in Km) within HP"),
        ),
        new TextField(
          decoration: new InputDecoration(hintText: "Vehicle Number"),
        ),
        new TextField(
          decoration: new InputDecoration(hintText: "Total Tax (In Rs.)"),
        ),
      ],
    );
  }

}

