import 'package:clicandeats/firebaseFirestore/auth.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/pages/ContactUs.dart';
import 'package:clicandeats/pages/signInPage.dart';
import 'package:clicandeats/pages/termsAndConditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clicandeats/widgets/drawer/billingInfos.dart';
import 'package:clicandeats/widgets/drawer/shippinginfos.dart';
import 'package:clicandeats/widgets/drawer/userInfos.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ConfirmAction { Cancel, Accept }

class MyDrawer extends StatefulWidget {


  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isSwitched = false;

  void toggleSwitch(bool value) {
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text('Switch Theme'),
          content: Text(value == true
              ? "Êtes-vous sûr de passer à un thème clair?"
              : 'Êtes-vous sûr de passer à un thème sombre?'),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            MaterialButton(
              child: Text(
                'Confirmer',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('theme', value);
                Provider.of<AppStateManager>(context, listen: false).switchTheme(value);
                setState(() {
                  //FirebaseOpRestaurantInfo().updateOpenCloseStatus(value, currentUserID);
                });
                Navigator.of(context).pop(ConfirmAction.Accept);
              },
            )
          ],
        );
      },
    );
  }

  Future<bool> getThemeValueFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool themeLight = true;
    if (prefs.containsKey('theme')) themeLight = prefs.getBool('theme')!;
    //
    return themeLight;
  }

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
    var _settings = Provider.of<AppStateManager>(context);

    return Drawer(
      child: SafeArea(
          child: Container(
        color: _settings.themeLight
            ? Colors.grey.shade50
            : Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
          child: userId != ""
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mes informations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Icon(
                            Icons.menu,
                            size: 35,
                            color: Color(0xfffc9568),
                          ),
                        ],
                      ),
                      UserInfos(
                        uId: userId,
                      ),
                      // FutureBuilder<bool>(
                      //     future: getThemeValueFromSharedPref(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         return Padding(
                      //           padding:
                      //               const EdgeInsets.symmetric(horizontal: 15),
                      //           child: Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               snapshot.data! == true
                      //                   ? Text(
                      //                       "light theme on",
                      //                       style: TextStyle(
                      //                           color: Theme.of(context)
                      //                               .primaryColor,
                      //                           fontWeight: FontWeight.bold),
                      //                     )
                      //                   : Text(
                      //                       "Light theme off",
                      //                       style: TextStyle(
                      //                           color: Theme.of(context)
                      //                               .accentColor,
                      //                           fontWeight: FontWeight.normal),
                      //                     ),
                      //               Transform.scale(
                      //                   scale: 1,
                      //                   child: CupertinoSwitch(
                      //                     onChanged: toggleSwitch,
                      //                     value: snapshot.data!,
                      //                     activeColor:
                      //                         Theme.of(context).primaryColor,
                      //                   )),
                      //             ],
                      //           ),
                      //         );
                      //       } else
                      //         return Text('-');
                      //     }),
                      // Divider(),
                      ShippingInfos(
                        onclick: () {},
                        uId: userId,
                      ),
                      Divider(),
                      BillingInfos(
                        uId: userId,
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // MaterialButton(
                          //   focusElevation: 0,
                          //   hoverElevation: 0,
                          //   hoverColor: Colors.white,
                          //   splashColor: Colors.white,
                          //   clipBehavior: Clip.antiAliasWithSaveLayer,
                          //   color: Colors.white,
                          //  // clipBehavior: Clip.antiAliasWithSaveLayer,
                          //   //color: Colors.white,
                          //   elevation: 0.0,
                          //   height: 45,
                          //   onPressed: () =>
                          //       Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBillingInfo(uId: uId))),
                          //   child: Center(
                          //     child: Row(
                          //
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           'Facturation et paiements',
                          //           style: TextStyle(
                          //             fontWeight: FontWeight.w500,
                          //             //color: Colors.white
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // Divider(),
                          MaterialButton(
                            focusElevation: 0,
                            hoverElevation: 0,
                            hoverColor: _settings.themeLight
                                ? Colors.white
                                : darkAccentColor,
                            splashColor: _settings.themeLight
                                ? Colors.white
                                : darkAccentColor,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: _settings.themeLight
                                ? Colors.white
                                : darkAccentColor,
                            height: 45,
                            elevation: 0.0,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ContactUs(uId: userId))),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nous contacter',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: _settings.themeLight
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          MaterialButton(
                            focusElevation: 0,
                            hoverElevation: 0,
                            hoverColor: _settings.themeLight
                                ? Colors.white
                                : darkAccentColor,
                            splashColor: _settings.themeLight
                                ? Colors.white
                                : darkAccentColor,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: _settings.themeLight
                                ? Colors.white
                                : darkAccentColor,
                            height: 45,
                            elevation: 0.0,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TermsCondition())),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Termes et conditions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: _settings.themeLight
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          MaterialButton(
                            onPressed: () {
                              Authentication().signOut();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/signin', (route) => false);
                              //Navigator.push(context, '/signin');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Se déconnecter',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.logout,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Expanded(child: Container(),),
                    SvgPicture.asset(
                      'assets/images/decor.svg',
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Connectez-vous pour voir votre panier',
                        style: Theme.of(context).textTheme.button,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Expanded(child: Container(),),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.6,
                      height: 48,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
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
                ),
        ),
      )),
    );
  }
}
