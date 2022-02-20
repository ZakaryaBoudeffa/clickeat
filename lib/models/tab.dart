import 'package:clicandeats/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../main.dart';

class Tab {
  String name;
  Widget icon;
  Tab({ required this.name, required this.icon});
}

final List<Tab> tabs = [
  Tab(name: 'Accueil', icon: Icon(Icons.home)),
  //Tab(name: 'Food', icon: Icon(FlutterIcons.hamburger_faw5s)),
  Tab(name: 'Cart', icon: Stack(children: [
    Icon(Icons.shopping_cart_rounded),
    Positioned(
        right: 0,
        child: CircleAvatar(
            radius: 6,
            backgroundColor: Color(0xfffc9568),

            child: Text(inCart.length.toString(), style: TextStyle(color: Colors.white, fontSize: 10),)))
  ],)),
  Tab(name: 'Commandes', icon: Icon(FlutterIcons.package_mco)),
];

