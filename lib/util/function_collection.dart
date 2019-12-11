

import 'dart:math';

import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List taxtype, _taxtypeVal) {
  List<DropdownMenuItem<String>> items = new List();
  int i = 0;
  for (String type in taxtype) {
    items.add(new DropdownMenuItem(value: _taxtypeVal[i].toString(), child: new Text(type)));
    i++;
  }
  return items;
}

List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems2(List commodity, _commodityid) {
  List<DropdownMenuItem<String>> items = new List();
  int i = 0;
  for (String com in commodity) {
    items.add(new DropdownMenuItem(value: _commodityid[i].toString(), child: new Text(com.toString())));
    i++;
  }
  return items;
}

double dp(double val, int places){
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}