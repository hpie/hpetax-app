import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hp_one/netwoklayer/dealer.dart';
import 'package:hp_one/netwoklayer/user.dart';
import 'package:hp_one/netwoklayer/user_api.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _Login createState() {
    var frm_data = new DeviceData();
    frm_data.get_data();
    return _Login();
  }
}

class _Login extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  /* Start Radio button functionality */

  int correctScore = 0;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  User _user = new User();
  UserApi _userApi = new UserApi();

  @override
  initState() {
    super.initState();
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
          Toast.show("Dealer !", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          correctScore++;
          break;
        case 2:
          //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          Toast.show("Employee !", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          break;
      }
    });
  }
  /* End Radio button functionality */

  @override
  Widget build(BuildContext context) {

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
        title: Text("Log In"),
      ),
      body: new SingleChildScrollView(
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
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}

