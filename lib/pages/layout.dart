import 'dart:developer';

import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/pages/myOrders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'cart.dart';
//
// class LayoutPage extends StatefulWidget {
//   LayoutPage({required this.uId});
//   final String uId;
//   @override
//   _LayoutPageState createState() => _LayoutPageState();
// }
//
// class _LayoutPageState extends State<LayoutPage> {
//   List<dynamic> _titles = [
//     DonatedMoney(uId: widget.uId,),
//     //'Food',
//     'Panier',
//     'Commandes',
//   ];
//
//   List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     //GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     var _settings = Provider.of<Settings>(context);
//     return Scaffold(
//       drawer: MyDrawer(
//         uId: widget.uId,
//       ),
//       body: Stack(
//         children: [
//           _buildOffstageNavigator(0),
//           //_buildOffstageNavigator(1),
//           _buildOffstageNavigator(1),
//           _buildOffstageNavigator(2),
//         ],
//       ),
//     );
//   }
//
//   Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
//     return {
//       '/': (context) {
//         return [
//           HomePage(
//             uId: widget.uId,
//           ),
//           // RestaurantPage(),
//           Cart(
//             false,
//             uId: widget.uId,
//           ),
//           MyOrders(
//             uId: widget.uId,
//           ),
//         ].elementAt(index);
//       },
//     };
//   }
//
//   Widget _buildOffstageNavigator(int index) {
//     var routeBuilders = _routeBuilders(context, index);
//     var _settings = Provider.of<Settings>(context);
//     return Offstage(
//       offstage: _settings.currentTab != index,
//       child: Navigator(
//         key: _navigatorKeys[index],
//         onGenerateRoute: (routeSettings) {
//           log("RouteSettings ${routeSettings.name}");
//           return MaterialPageRoute(
//             builder: (context) => routeBuilders[routeSettings.name]!(context),
//           );
//         },
//       ),
//     );
//   }
// }

class Layout extends StatefulWidget {
  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = [];
  void _onItemTapped(int index) {
    // var _settings = Provider.of<Settings>(context);
  }

  late String userId;
  @override
  void initState() {
    print("LAYOUT init state");
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;

    } else {
      userId = "";
      //_widgetOptions = [];
    }
    _widgetOptions = <Widget>[
      HomePage(),
      // RestaurantPage(),
      CartPage(
        false,
        uId: userId,
        resId: inCart.length > 0 ? inCart[0].resId : "",
      ),
      MyOrders(),
    ];

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("LAYOUT did change dependencies");
    // TODO: implement didChangeDependencies
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
      _widgetOptions = <Widget>[
        HomePage(),
        // RestaurantPage(),
        CartPage(
          false,
          uId: userId,
          resId: inCart.length > 0 ? inCart[0].resId : "",
        ),
        MyOrders(),
      ];
    } else
      userId = "";
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);

    return Scaffold(
      body: Column(
        children: [
          _widgetOptions.isNotEmpty
              ? Expanded(
                  child: Center(
                      child: _widgetOptions.elementAt(_settings.currentTab)))
              : Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // showSelectedLabels: false,
        //sshowUnselectedLabels: false,
        // backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart_rounded),
                Positioned(
                    right: 0,
                    child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(0xfffc9568),
                        child: Text(
                          inCart.length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )))
              ],
            ),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.package_mco),
            label: 'Commandes',
          ),
        ],
        currentIndex: _settings.currentTab,
        unselectedItemColor: Colors.grey.shade600,
        elevation: 10,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _settings.changeTab(index);
          });
        },
      ),
    );
  }
}
