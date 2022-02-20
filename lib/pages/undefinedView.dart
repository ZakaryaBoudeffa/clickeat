import 'package:flutter/material.dart';

class UndefinedView extends StatelessWidget {
  String name;
  UndefinedView(this.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$name 404 Not Found!'),),
    );
  }
}
