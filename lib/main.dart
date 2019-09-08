import 'package:flutter/material.dart';
import 'package:hp_one/pages/landing.dart';
import 'package:hp_one/pages/test.dart';
import 'package:hp_one/pages/unregistered.dart';
import 'package:hp_one/pages/unregistered2.dart';

import 'globals.dart' as globals;
import 'package:hp_one/util/device_data.dart';




void main() {
  var frm_data = new DeviceData();
  globals.isLoggedIn = (frm_data.get_data()).toString();

  runApp(MaterialApp(
    title: 'HpTax',
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/unregistered': (context) => UnregisteredPage(),
      '/unregistered2': (context) => UnregisteredPage2(),
      '/test': (context) => TestPage(),
    },
  ));
}



