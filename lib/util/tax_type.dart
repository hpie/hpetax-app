import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class TaxType {
  const TaxType(this.type_id,this.type_name);

  final String type_name;
  final String type_id;
}