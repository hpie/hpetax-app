import 'package:flutter/material.dart';
import 'package:hp_one/pages/landing.dart';
import 'package:hp_one/pages/test.dart';
import 'package:hp_one/pages/unregistered.dart';
import 'package:hp_one/pages/unregistered2.dart';


void main() {
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



