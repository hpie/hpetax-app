import 'package:flutter/material.dart';

class UnregisteredPage extends StatefulWidget {
  @override
  _Unregistered createState() {
    return _Unregistered();
  }
}

class _Unregistered extends State<UnregisteredPage> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue;
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
        ),
      )
    );
  }

  List _taxtype = ["","Additional Goods Tax", "Passenger And Goods Tax", "Passenger Tax on Contract Carriage", "Certain Goods Carried by Road Tax"];
  List<int> _fruits2 = [1, 2, 3, 4];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<int>> _dropDownMenuItems2;
  String _selectedType, _selectedFruit;
  int _selectedForm = 0;

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_taxtype);
    _selectedType = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  void changeState() {

  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List taxtype) {
    List<DropdownMenuItem<String>> items = new List();
    for (String type in taxtype) {

      items.add(new DropdownMenuItem(value: type, child: new Text(type)));
    }
    return items;
  }

  List<DropdownMenuItem<int>> buildAndGetDropDownMenuItems2(List fruits) {
    List<DropdownMenuItem<int>> items = new List();
    for (int fruit in fruits) {
      items.add(new DropdownMenuItem(value: fruit, child: new Text(fruit.toString())));
    }
    return items;
  }

  void changedDropDownItem(String selectedFruit) {
    setState(() {
      _selectedFruit = selectedFruit;
      print(selectedFruit);
      _selectedForm = 1;
      _dropDownMenuItems2 = buildAndGetDropDownMenuItems2(_fruits2);
    });
  }

  void changedDropDownItem2(int selectedFruit) {
    _selectedForm = selectedFruit;
    print(selectedFruit);
  }

  Widget formUI() {

    if(_selectedForm == 0) {
      return new Column(
        children: <Widget>[
          new Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Tax Type :",
              style: TextStyle(fontSize: 30),
            ),
          ),
          //new Text("Tax Type: "),
          new DropdownButton(
            value: _selectedType,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
            isExpanded: true,
            style: new TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                decorationStyle: TextDecorationStyle.dotted),

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

    if(_selectedForm == 1) {
    return new Column(
      children: <Widget>[
        new Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Tax Type :",
            style: TextStyle(fontSize: 30),
          ),
        ),
        new DropdownButton(
          value: _selectedType,
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
            style: TextStyle(fontSize: 30),
          ),
        ),
        new DropdownButton(
          items: _dropDownMenuItems2,
          onChanged: changedDropDownItem2,
          isExpanded: true,
          style: new TextStyle(color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 10.0,
              decorationStyle: TextDecorationStyle.dotted),

        ),
        new TextField(
          decoration: new InputDecoration(hintText: "Vehicle Number"),
        ),
        new TextField(
          decoration: new InputDecoration(hintText: "Total Tax (In Rs.)"),
        ),

        new RaisedButton(onPressed: _sendToServer, child: Text("save"))
      ],
    );
  }

    if(_selectedForm == 2) {
      return new Column(
        children: <Widget>[
          new Text("Tax Type: "),
          new TextField(
            decoration: new InputDecoration(hintText: "Full Name"),
          ),
          new TextField(
            decoration: new InputDecoration(hintText: "Mobile Number"),
          ),
          new TextField(
            decoration: new InputDecoration(hintText: "Email"),
          ),

          new RaisedButton(onPressed: _sendToServer, child: Text("save"))
        ],
      );
    }
  }

  _sendToServer() {
    print("hello");
  }
}

