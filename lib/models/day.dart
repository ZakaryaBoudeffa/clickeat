import 'package:flutter/material.dart';

class Day {
  String? name;
  String? startTime;
  String? endTime;

  Day(this.name, this.startTime, this.endTime);

  Map<String, dynamic> toMap() {
    return {'name': name, 'startTime': startTime, 'endTime': endTime};
  }

  factory Day.fromMap(json) =>
      Day(json['name'], json['startTime'], json['endTime']);
}
