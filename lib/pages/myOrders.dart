import 'package:clicandeats/firebaseFirestore/ordersOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/pages/signInPage.dart';
import 'package:clicandeats/utils/appBar.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/drawer/myDrawer.dart';
import 'package:clicandeats/widgets/myOrders/orderedrCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {


  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String userId = "";
  @override
  void initState() {
    // TODO: implement initState
    if(FirebaseAuth.instance.currentUser != null){
      userId = FirebaseAuth.instance.currentUser!.uid;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("user id myOrders: ${userId}");
    var _settings = Provider.of<AppStateManager>(context);
    return Scaffold(
      appBar: userId == ""
          ? AppBar(
              title: Text(
                "Commandes",
                style: TextStyle(fontSize: 16,  color: _settings.themeLight ? Colors.black : Colors.white),
              ),
            )
          : MyAppBar(
              title: Text('Commandes', style: TextStyle(fontSize: 16, color: _settings.themeLight ? Colors.black : Colors.white)),
              back: false,
              uId: userId,
            ),
      drawer: MyDrawer(

      ),
      body: Column(
        children: [
          userId == ""
              ? Expanded(child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Expanded(child: Container(),),
                  SvgPicture.asset('assets/images/decor.svg', height: 150,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Connectez-vous pour voir vos commandes',
                      style: Theme.of(context)
                          .textTheme.headline6,
                      textAlign: TextAlign.center,),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Expanded(child: Container(),),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.6,
                    height: 48,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Text(
                      'Connectez-vous',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                ],
              )))
              : Expanded(
                  child: StreamBuilder(
                      stream: FirebaseOpOrders().getMyOrders(userId),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.length > 0) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...snapshot.data!.docs.map((e) {
                                    Order order = Order.fromSnapShot(e);
                                    List<OrderedMeal> orderedMeals = order
                                        .orderedMealsList
                                        .map((meal) =>
                                            OrderedMeal.fromSnapshot(meal))
                                        .toList();
                                    return order.status > 0
                                        ? Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: OrderedCard(
                                              order: order,
                                              orderedMeals: orderedMeals,
                                            ),
                                          )
                                        : Container();
                                  })
                                ],
                              ),
                            );
                          } else
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/decor2.svg',
                                  height: 200,
                                  width: 100,
                                ),
                                Text(
                                  'aucune commande',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ));
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return Center(child: Text('$errorText'));
                        } else
                          return Center(child: Text('$loadingText'));
                      }),
                ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _settings.currentTab,
      //   onTap: (i) => _settings.changeTab(i),
      //   items: tabs.map((e) {
      //     return BottomNavigationBarItem(
      //         icon: e.icon,
      //         label: e.name
      //       //: Color(0xfffc9568),
      //       // unselectedColor: Color(0xff747474),
      //     );
      //   }).toList(),
      // ),
    );
  }
}
