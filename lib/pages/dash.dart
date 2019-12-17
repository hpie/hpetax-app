import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hpetax/networklayer/user.dart';
import 'package:hpetax/networklayer/user_api.dart';
import 'package:hpetax/util/device_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';


import 'package:hpetax/globals.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';

class DashPage extends StatefulWidget {
  @override
  _Dash createState() {
    var frm_data = new DeviceData();
    frm_data.get_data();
    return _Dash();
  }
}

class _Dash extends State<DashPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.username = prefs.getString('username');
    globals.usertype = prefs.getInt('usertype').toString();
    globals.userid = prefs.getInt('userid').toString();

    print("Dash.dart user name : " + globals.username);
    print("Dash.dart user type : " + globals.usertype);
    print("Dash.dart user id : " + globals.userid);
  }

  /* Start Radio button functionality */

  int correctScore = 0;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  User _user = new User();
  UserApi _userApi = new UserApi();

  @override
  initState() {
    super.initState();
    _checkLogin();
    _user.user_type = 1;
  }

  void _validateInputs(context) {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables

      // No any error in validation
      _formKey.currentState.save();
      login(context);

    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
  Future login(context) async {
    var response;
    //Toast.show("hiiiiiiiiiiiii", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    response = await _userApi.login(_user);
    Toast.show(response["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    ///*
    if(response["success"]) {
      print("in success");
      //clear_fields();
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();

      String username = (response.containsKey("tax_dealer_email")) ? response["tax_dealer_email"] : response["tax_employee_email"];
      int usertype = (response.containsKey("tax_dealer_email")) ? 1 : 2;

      print("Logged in : " + username + " || type : " + usertype.toString());
      // set value
      prefs.setString('username', username);
      prefs.setInt('usertype', usertype);

      globals.selectedVehicleNumber = "";
      globals.selectedTaxType = "";

      var now = new DateTime.now();
      print(now.millisecondsSinceEpoch);
      globals.userSession = globals.isLoggedIn + "_" + (now.millisecondsSinceEpoch).toString();

      Navigator.pushNamed(context, '/dashboard');
    } else {
      print("in else");
    }
   // */
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _user.user_type = value;

      switch (_user.user_type) {
        case 1:
          //Fluttertoast.showToast(msg: 'Correct !',toastLength: Toast.LENGTH_SHORT);
          //Toast.show("Dealer !", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          correctScore++;
          break;
        case 2:
          //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          //Toast.show("Employee !", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          break;
      }
    });
  }
  /* End Radio button functionality */

  @override
  Widget build(BuildContext context) {
    //Loading counter value on start
    _logOut() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', "");
      prefs.setInt('usertype', null);
      prefs.setInt('userid', null);

      globals.username = "";
      globals.usertype = null;
      globals.userid = null;

      globals.selectedVehicleNumber = "";
      globals.selectedTaxType = "";

      var now = new DateTime.now();
      print(now.millisecondsSinceEpoch);
      globals.userSession = globals.isLoggedIn + "_" + (now.millisecondsSinceEpoch).toString();


      print("logged out");
    }

    String validatePassword(String value) {
      if (value.length < 3)
        return 'Name must be more than 2 charater';
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

    final emailField = TextFormField(
      obscureText: false,
      style: style,
      validator: validateEmail,
      onSaved: (String val) {
        //_dealer.tax_dealer_email = val;
        _user.user_email = val;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      validator: validatePassword,
      onSaved: (String val) {
        //_dealer.tax_dealer_email = val;
        _user.user_password = val;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _validateInputs(context);
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final usertypeField = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: 1,
          groupValue: _user.user_type,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Dealer',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: 2,
          groupValue: _user.user_type,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Employee',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.power_settings_new),
            onPressed: () {
              _logOut();
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text("Welcome", style: new TextStyle(fontSize: 30.0)),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(globals.username, style: new TextStyle(fontSize: 20.0)),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text("User : " + globals.usertype, style: new TextStyle(fontSize: 20.0)),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                        child: new Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 200.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('Profile', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),

                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                        child: new Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 200.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('Search Invoice', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/record_invoice');
                        },
                      ),

                    ),
                  ),
                ],
              ),
              (globals.usertype == "2") ? new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                        child: new Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 200.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('Invoice Recording', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/invoice_recording');
                        },
                      ),

                    ),
                  ),
                ],
              ) : new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                        child: new Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 200.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('Tax Challan', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/epayment_form');
                        },
                      ),

                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                        child: new Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: 200.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('LogOut', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          _logOut();
                          Navigator.pushNamed(context, '/');
                        },
                      ),

                    ),
                  ),
                ],
              ),

            ],
          )
      ),
    );
  }
}

