import 'package:flutter/material.dart';
import 'package:hp_one/pages/dash.dart';
import 'package:hp_one/pages/dashboard.dart';
import 'package:hp_one/pages/invoice_recording.dart';
import 'package:hp_one/pages/landing.dart';
import 'package:hp_one/pages/login.dart';
import 'package:hp_one/pages/register.dart';
import 'package:hp_one/pages/test.dart';
import 'package:hp_one/pages/challan.dart';
import 'package:hp_one/pages/payment.dart';
import 'package:hp_one/pages/unregistered.dart';
import 'package:hp_one/pages/user_challan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import 'package:hp_one/util/device_data.dart';

import 'netwoklayer/places_api.dart';

void main() {
  var frm_data = new DeviceData();
  globals.isLoggedIn = (frm_data.get_data()).toString();
  int _counter = 0;

  //Loading counter value on start
  _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.username = prefs.getString('username');
    globals.usertype = prefs.getInt('usertype').toString();

    //print("Main.dart user name : " + (globals.username != null) ? globals.username : "");
    //print("Main.dart user type : " + (globals.usertype != null) ? globals.usertype : "");
  }

  //PlacesApi places_api = new PlacesApi();

  //places_api.get_places("nas");

  _checkLogin();

  runApp(MaterialApp(
    title: 'HpTax',
    initialRoute: '/',
    routes: {
      //'/': (context) => (globals.username == "") ? HomePage() : DashboardPage(),
      '/': (context) => (globals.username == "" || globals.username == null) ? HomePage() : DashPage(),
      //'/dashboard': (context) => DashboardPage(),

      '/unregistered': (context) => UnregisteredPage(),
      '/dashboard': (context) => DashPage(),
      '/invoice_recording': (context) => InvoicePage(),
      '/user_challan': (context) => UserchallanPage(),
      '/test': (context) => TestPage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/epayment': (context) => EpaymentPage(),
      '/payment': (context) => PaymentPage(),
    },
  ));
}



