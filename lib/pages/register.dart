import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hp_one/netwoklayer/dealer.dart';
import 'package:hp_one/netwoklayer/register_api.dart';
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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import 'package:hp_one/globals.dart' as globals;


import 'package:hp_one/util/device_data.dart';

class RegisterPage extends StatefulWidget {
  @override
  _Register createState() {
    var frm_data = new DeviceData();
    frm_data.get_data();
    return _Register();
  }
}

class _Register extends State<RegisterPage> {
/*
*  Start Variable declarations
*/
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  Dealer _dealer = new Dealer();
  RegisterApi _registerApi = new RegisterApi();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _firstname;
  String _surname;
  String _mobile;
  String _email;
  String _password;

  TextEditingController editTaxDealerTinExpiryCnt = TextEditingController();

/*
*  End Variable declarations
*/


  List<String> items = [""];

  @override
  Widget build(BuildContext context) {

    String format_date(var date) {
      var formatter = new DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(date);
      print(formatted); // something like 2013-04-20
      return formatted;
    }
    String validateName(String value) {
      if (value.length < 3)
        return 'Name must be more than 2 charater';
      else
        return null;
    }

    String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
      if (value.length != 10)
        return 'Mobile Number must be of 10 digit';
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

    void _validateInputs(context) {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables

        // No any error in validation
        _formKey.currentState.save();
        //register_user(context);
        print("Name $_firstname");
        print("Mobile $_mobile");
        print("Email $_email");
      } else {
//    If all data are not valid then start auto validation.
        setState(() {
          _autoValidate = true;
        });
      }
    }
    Future register_user(context) async {
      var response;

      //response = await _taxApi.add(_tax);
      ///*
      /*
      if(!is_edit) {
        print("edit false");
        Tax.item_queue_id++;
        //response = await _taxApi.add(_tax);
      } else {
        print("edit true");
        //response = await _taxApi.update(_tax);
      }
      */
      response = await _registerApi.add(_dealer);
      Toast.show(response.message, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      if(response.success) {
        print("in success");
        //clear_fields();
        setState(() {

        });
      } else {
        print("in else");
      }
    }

    final firstnameField = TextFormField(
      obscureText: false,
      style: style,
      validator: validateName,
      onSaved: (String val) {
        _firstname = val;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Firstname",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final surnameField = TextFormField(
      obscureText: false,
      style: style,
      validator: validateName,
      onSaved: (String val) {
        _surname = val;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Surname",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final mobileField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.phone,
      validator: validateMobile,
      onSaved: (String val) {
        _dealer.tax_dealer_mobile = val;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mobile",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );
    final emailField = TextFormField(
      obscureText: false,
      style: style,
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        onSaved: (String val) {
          _dealer.tax_dealer_email = val;
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
        onSaved: (String val) {
          _dealer.tax_dealer_password = val;
        },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final dealerTinField = TextFormField(
      obscureText: false,
      style: style,
      //validator: validateName,
      onSaved: (String val) {
        _dealer.tax_dealer_tin = val;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Dealer Tin",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final dealerTinExpiryField = TextFormField(
      obscureText: false,
      style: style,
      controller: editTaxDealerTinExpiryCnt,
      validator: validateName,
      onSaved: (String val) {
        _dealer.tax_dealer_tin_expiry = val;
      },
      onTap: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime.now(),
           // maxTime: DateTime(2099, 6, 7), onChanged: (date) {
            maxTime: DateTime(2099, 6, 7), onChanged: (date) {
              print('change $date');
              editTaxDealerTinExpiryCnt.text = date.toString();
              _dealer.tax_dealer_tin_expiry = date.toString();
            }, onConfirm: (date) {
              editTaxDealerTinExpiryCnt.text = format_date(date);
              print('confirm $date');
            }, currentTime: DateTime.now());
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Dealer Tin Expiry Date",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final registerButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {

          _validateInputs(context);
          register_user(context);


        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );



    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                //SizedBox(height: 45.0),
                firstnameField,
                SizedBox(height: 20.0),
                surnameField,
                SizedBox(height: 20.0),
                dealerTinField,
                SizedBox(height: 20.0),
                dealerTinExpiryField,
                SizedBox(height: 20.0),
                mobileField,
                SizedBox(height: 20.0),
                emailField,
                SizedBox(height: 20.0),
                passwordField,
                SizedBox(
                  height: 20.0,
                ),
                registerButon,
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

