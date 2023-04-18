
import 'package:flutter/material.dart';
//import 'package:flutter_session/flutter_session.dart';

class Data {
  final int id;
  final String data;

  Data({required this.data, required this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["data"] = this.data;
    return data;
  }
}
