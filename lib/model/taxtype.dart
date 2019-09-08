import 'package:flutter/material.dart';

class Taxtype {
  final int userId;
  final int id;
  final String title;
  final String body;

  Taxtype({this.userId, this.id, this.title, this.body});

  factory Taxtype.fromJson(Map<String, dynamic> json) {
    return Taxtype(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}