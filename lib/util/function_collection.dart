import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tax/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

/*
List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List taxtype, _taxtypeVal) {
  List<DropdownMenuItem<String>> items = new List();
  int i = 0;
  for (String type in taxtype) {
    items.add(new DropdownMenuItem(value: _taxtypeVal[i].toString(), child: new Text(type)));
    i++;
  }
  return items;
}
*/

/*
List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List taxtype, _taxtypeVal) {
  List<DropdownMenuItem<String>> items = new List();
  int i = 0;
  for (String type in taxtype) {
    //items.add(new DropdownMenuItem(value: _taxtypeVal[i].toString(), child: new Text(type)));

    items.add(new DropdownMenuItem(value: _taxtypeVal[i].toString(),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //(i != 0) ? Icon(Icons.arrow_forward_ios, color: Colors.white30,) : new SizedBox.shrink(),
            // SizedBox(width: 10),
            Expanded(child: Text(type)),
          ],

        )

    ));
    i++;
  }
  return items;
}
*/

List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List taxtype, _taxtypeVal) {
  List<DropdownMenuItem<String>> items = new List();
  int i = 0;
  for (String type in taxtype) {
    items.add(new DropdownMenuItem(value: _taxtypeVal[i].toString(), child:
      new Container(

          decoration: new BoxDecoration(

            border: Border(
              bottom: BorderSide(width: 1.0, color: (i != 0) ? Colors.white : Colors.grey.shade200),
            ),
            //color: Colors.white,
          ),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //(i != 0) ? Icon(Icons.arrow_forward_ios, color: Colors.white30,) : new SizedBox.shrink(),
              // SizedBox(width: 10),
              Expanded(child: Text(type)),
            ],

          ),
      )
    ));
    i++;
  }
  return items;
}

List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems2(List commodity, _commodityid) {
  List<DropdownMenuItem<String>> items = new List();
  int i = 0;
  for (String com in commodity) {
    items.add(new DropdownMenuItem(value: _commodityid[i].toString(), child:

    new Container(
      decoration: new BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: (i != 0) ? Colors.white : Colors.grey.shade200),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Text(com.toString())),
        ],

      ),
    )

    )

    );
    i++;
  }
  return items;
}

/*
List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems2(List commodity, _commodityid) {
  List<DropdownMenuItem<String>> items = new List();
  int i = 0;
  for (String com in commodity) {
    items.add(new DropdownMenuItem(value: _commodityid[i].toString(), child: new Text(com.toString())));
    i++;
  }
  return items;
}
*/

Widget places_suggestions(String suggestion) {
  return Container(
    decoration: new BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.white),
      ),
    ),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Text(suggestion)),
      ],
    ),
  );
}

double dp(double val, int places){
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

String set_session() {

if(globals.userSession == "") {
var now = new DateTime.now();
print(now.millisecondsSinceEpoch);
//globals.unique_identifier = str.toString();
globals.userSession = globals.device_id + "_" + (now.millisecondsSinceEpoch).toString();
}

return globals.userSession;
}

void logout() async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setString('username', "");
  prefs.setInt('usertype', null);
  prefs.setInt('userid', null);
  prefs.setInt('isLoggedIn', null);

  globals.username = "";
  globals.usertype = "";
  globals.userid = "";
  globals.isLoggedIn = "";

  globals.selectedVehicleNumber = "";
  globals.selectedTaxType = "";

  set_session();

  print("Logout Called");
}