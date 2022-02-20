import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/dish.dart';
import 'package:clicandeats/models/extras.dart';
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/plate/additions.dart';
import 'package:clicandeats/widgets/plate/infosPlat.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'cart.dart';

// ignore: must_be_immutable
class PlatePage extends StatefulWidget {
  final VoidCallback onclick;
  final Dish plat;
  final String resId;
  List<Extras>? extras;
  final String resName;
  final String platId;
  final String uId;
  PlatePage(
      {required this.uId,
      required this.platId,
      required this.onclick,
      required this.plat,
      required this.resId,
      required this.resName,
      this.extras});
  @override
  _PlatePageState createState() => _PlatePageState();
}

class _PlatePageState extends State<PlatePage> {
  int _qtt = 1;
  List<Map<String, dynamic>> extrasMap = [];
  // bool _fav = false;
  double extraAmount = 0.0;
  bool requiredExtrasSelected = false;
  List<bool> allExtrasAdded = [];
  List<Map<String, dynamic>> selectedExtras = [];
  @override
  void initState() {
    if (widget.extras != null) {
      for (int i = 0; i < widget.extras!.length; i++) {
        allExtrasAdded.add(widget.extras![i].isRequired == 0 ? true : false);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    //print('discount: ${widget.plat.discountedPrice}');
    return Scaffold(
      //backgroundColor: Colors.pink,
      body: Column(
        children: [
          Expanded(
            child: Container(
              // color: Colors.orange,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            InfoPlat(
                                uId: widget.uId,
                                plat: widget.plat,
                                resId: widget.resId,
                                resName: widget.resName,
                                platId: widget.platId),
                            widget.extras != null ? Divider() : Container(),
                            widget.extras != null
                                ? Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    //color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 4),
                                          child: Text(
                                            'Extras',
                                            style: TextStyle(
                                             // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        allExtrasAdded.contains(false)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 2),
                                                // child: Text('Please select required extras with minimum'),
                                                child: Text(
                                                    'Veuillez choisir les extras requis'),
                                              )
                                            : Text(''),
                                        Container(
                                          color:  _settings.themeLight ? Colors.white :darkAccentColor,
                                          child: Column(
                                            children: widget.extras!
                                                .map((e) => Additions(
                                                      extra: e,
                                                      title: e.name,
                                                      options: e.extraItems,
                                                      onExtraAmountChanged: (double
                                                              val,
                                                          int
                                                              noOfSelectedExtras,
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              selectedExtra) {
                                                        print(
                                                            noOfSelectedExtras);

                                                        if (selectedExtra
                                                                .length >
                                                            0) {
                                                          selectedExtras.add(Extras(
                                                                  name: e.name,
                                                                  extraItems:
                                                                      selectedExtra,
                                                                  isRequired: 0,
                                                                  noOfSelectableExtras:
                                                                      0)
                                                              .toMap());
                                                        }

                                                        // if(selectedExtras
                                                        //     .toString()
                                                        //     .contains(e.name)) {
                                                        //
                                                        //   // print
                                                        //   //   ('++++WHERE '
                                                        //   //     '${selectedExtras
                                                        //   //     .where((element) => element.containsValue(e.name)).single}');
                                                        //   // print(
                                                        //   //     '${
                                                        //   //         selectedExtras.indexOf(selectedExtras
                                                        //   //             .where((element) => element.containsValue(e.name)).single)
                                                        //   //     }'
                                                        //   // );
                                                        // }

                                                        if (e.isRequired == 0 &&
                                                            noOfSelectedExtras <=
                                                                e.noOfSelectableExtras) {
                                                          setState(() {
                                                            extraAmount += val;
                                                            allExtrasAdded[widget
                                                                .extras!
                                                                .indexOf(
                                                                    e)] = true;
                                                            // selectedExtras.add
                                                            //   (Extras(name: e.name,
                                                            //     extraItems:
                                                            //     selectedExtra,
                                                            //     isRequired: 0,
                                                            //     noOfSelectableExtras: 0).toMap());
                                                          });
                                                        } else if (e.isRequired ==
                                                                1 &&
                                                            e.noOfSelectableExtras ==
                                                                noOfSelectedExtras) {
                                                          setState(() {
                                                            extraAmount += val;
                                                            allExtrasAdded[widget
                                                                .extras!
                                                                .indexOf(
                                                                    e)] = true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            extraAmount += val;
                                                            allExtrasAdded[widget
                                                                .extras!
                                                                .indexOf(
                                                                    e)] = false;
                                                            // selectedExtras.add
                                                            //   (Extras(name: e.name,
                                                            //     extraItems:
                                                            //     selectedExtra,
                                                            //     isRequired: 0,
                                                            //     noOfSelectableExtras: 0).toMap());
                                                          });
                                                        }
                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            c = [];
                                                        print(selectedExtras);
                                                        selectedExtras
                                                            .forEach((element) {
                                                          if (!c
                                                              .toString()
                                                              .contains(
                                                                  e.name)) {
                                                            c.add(element);
                                                          }
                                                        });
                                                        extrasMap = c;

                                                        print("C: $c");
                                                      },
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            Divider(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    child: Text(
                                      'Instructions supplémentaires',
                                      style: TextStyle(
                                       // color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(30),
                                      color: _settings.themeLight? Colors.white :darkAccentColor,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     blurRadius: 10,
                                      //     color: Colors.grey[100]!,
                                      //   )
                                      // ],
                                    ),
                                    child: TextFormField(

                                      style: TextStyle(fontSize: 14, color:  _settings.themeLight? Colors.black : Colors.white),
                                      minLines: 4,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelText: 'Écrivez vos '
                                            'commentaires ici',

                                        alignLabelWithHint: true,
                                        labelStyle: TextStyle(
                                            color:  _settings.themeLight? Colors.black54 : Colors.white60
                                            //fontSize: 18,
                                            ),
                                        //fillColor: Colors.white,
                                       // filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                        Positioned(
                            top: 35,
                            left: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                constraints: BoxConstraints.tight(Size(40, 40)),
                                padding: EdgeInsets.zero,
                                color: Colors.white,
                                icon: Icon(
                                  Icons.arrow_back,
                                  //   size: 40,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  // color: Colors.pink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Container(
                      //   //width: MediaQuery.of(context).size.width*0.5,
                      //   padding:
                      //       EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     color: Colors.white,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         blurRadius: 10,
                      //         color: Colors.grey[100]!,
                      //       )
                      //     ],
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       CircleAvatar(
                      //         radius: 14,
                      //         backgroundColor: Theme.of(context).primaryColor,
                      //         child: IconButton(
                      //             padding: EdgeInsets.zero,
                      //             icon: Icon(
                      //               Icons.remove,
                      //               color: Colors.white,
                      //             ),
                      //             onPressed: () {
                      //               setState(() {
                      //                 if (_qtt > 1) {
                      //                   _qtt--;
                      //                 }
                      //               });
                      //             }),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 8),
                      //         child: Text(
                      //           '$_qtt',
                      //           style: TextStyle(
                      //             //fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //       CircleAvatar(
                      //         radius: 14,
                      //         backgroundColor: Theme.of(context).primaryColor,
                      //         child: IconButton(
                      //             padding: EdgeInsets.zero,
                      //             icon: Icon(
                      //               Icons.add,
                      //               color: Colors.white,
                      //             ),
                      //             onPressed: () {
                      //               setState(() {
                      //                 _qtt++;
                      //               });
                      //             }),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Expanded(
                        child: MaterialButton(
                          height: 48,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: allExtrasAdded.contains(false)
                              ? Theme.of(context).accentColor
                              : Theme.of(context).primaryColor,
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            if (allExtrasAdded.contains(false)) {
                              //print("NOT ALL EXTRAS ADDEDD");
                            } else {
                              //print(" ALL EXTRAS ADDEDD");

                              if (inCart.length > 0) {
                                // print('extraAmount $extraAmount');
                                inCart.forEach((element) {
                                  print(element.resId);
                                });
                                //print("incart contains resId ${inCart.contains(widget.resId)}");
                                if (inCart[0].resId == widget.resId) {
                                  await prefs.setString(
                                      'myCart_resId', widget.resId);
                                  await prefs.setString(
                                      'myCart_resName', widget.resId);
                                  inCart.add(InCartOrder(
                                      platId: widget.platId,
                                      name: widget.plat.name,
                                      img: widget.plat.image,
                                      qtt: _qtt,
                                      originalPrice: widget.plat.price,
                                      calculatedDishOnlyPrice:
                                          widget.plat.discountedPrice > 0
                                              ? calculateDishTotalOnly(
                                                  _qtt * widget.plat.price,
                                                  widget.plat.discountedPrice)
                                              : ((_qtt * widget.plat.price)),
                                      discountPercent:
                                          widget.plat.discountedPrice > 0
                                              ? _qtt *
                                                  widget.plat.discountedPrice
                                              : 0.0,
                                      selectedExtrasList: extrasMap,
                                      resId: widget.resId,
                                      extrasAmount: extraAmount));
                                  myCart.resId = widget.resId;
                                  myCart.resName = widget.resName;
                                  myCart.items = inCart;
                                  myCart.shippingAddress =
                                      myCart.shippingAddress;
                                  // Cart(resId: widget.resId, items: inCart, shippingAddress: myCart.shippingAddress);
                                  _order(context);
                                } else {
                                  print("NO two restos allowed");
                                  _clearCart(context);
                                }
                              } else {
                                await prefs.setString(
                                    'myCart_resId', widget.resId);
                                await prefs.setString(
                                    'myCart_resName', widget.resId);
                                inCart.add(InCartOrder(
                                    platId: widget.platId,
                                    name: widget.plat.name,
                                    img: widget.plat.image,
                                    qtt: _qtt,
                                    originalPrice: widget.plat.price,
                                    calculatedDishOnlyPrice:
                                        widget.plat.discountedPrice > 0
                                            ? calculateDishTotalOnly(
                                                _qtt * widget.plat.price,
                                                widget.plat.discountedPrice)
                                            : ((_qtt * widget.plat.price)),
                                    discountPercent:
                                        widget.plat.discountedPrice > 0
                                            ? _qtt * widget.plat.discountedPrice
                                            : 0.0,
                                    selectedExtrasList: extrasMap,
                                    resId: widget.resId,
                                    extrasAmount: extraAmount));
                                myCart.resId = widget.resId;
                                myCart.resName = widget.resName;
                                myCart.items = inCart;
                                myCart.shippingAddress = myCart.shippingAddress;
                                // myCart = Cart(resId: widget.resId, items: inCart, shippingAddress: myCart.shippingAddress);
                                _order(context);
                              }
                              setState(() {});
                            }
                          },
                          child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  text: 'Ajouter au panier ',
                                  children: [
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  text:
                                      '${widget.plat.discountedPrice > 0 ? (_qtt * widget.plat.price - (_qtt * widget.plat.price * widget.plat.discountedPrice / 100) + extraAmount).toStringAsFixed(2) : ((_qtt * widget.plat.price + extraAmount)).toStringAsFixed(2)} € ',
                                )
                              ])),
                        ),
                      ),
                      // Text(
                      //   'Ajouter au panier '
                      //       '${widget.plat.discountedPrice > 0 ? (_qtt * widget.plat.price - (_qtt * widget.plat.price * widget.plat.discountedPrice / 100) + extraAmount).toStringAsFixed(2) : ((_qtt * widget.plat.price + extraAmount)).toStringAsFixed(2)} € ',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     //fontSize: 17,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // )
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage(
                                        true,
                                        uId: widget.uId,
                                        resId: widget.resId,
                                      )));
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                      radius: 7,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        inCart.length.toString(),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   //  color: Colors.pink,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       MaterialButton(
                //         onPressed: () {
                //           Navigator.popUntil(context, ModalRoute.withName('/'));
                //         },
                //         child: Text('Accueil'),
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       MaterialButton(
                //           minWidth: 60,
                //           onPressed: () {
                //             Navigator.pushNamed(context, '/cart');
                //           },
                //           child: Row(
                //             children: [
                //               Text(
                //                 'Voir le panier ',
                //                 style: TextStyle(
                //                     color: Theme.of(context).primaryColor),
                //               ),
                //               Stack(
                //                 children: [
                //                   Icon(
                //                     Icons.shopping_cart_outlined,
                //                     color: Theme.of(context).primaryColor,
                //                   ),
                //                   Positioned(
                //                       right: 0,
                //                       child: CircleAvatar(
                //                           radius: 6,
                //                           backgroundColor:
                //                               Theme.of(context).primaryColor,
                //                           child: Text(
                //                             inCart.length.toString(),
                //                             style: TextStyle(
                //                                 color: Colors.white,
                //                                 fontSize: 10),
                //                           )))
                //                 ],
                //               )
                //             ],
                //           )),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    Extras.extrasAmount = 0.0;
    super.dispose();
  }

  _order(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            ' Ajouté au panier',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/icons/done.png',
                width: 50,
                height: 50,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          //widget.onclick();
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage(
                                        true,
                                        uId: widget.uId,
                                        resId: widget.resId,
                                      )));
                        },
                        child: Text(
                          'Au panier',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        elevation: 2,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Continuer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _clearCart(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Commandez dans un seul restaurant à la fois',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vous avez des articles dans le panier d\'un autre restaurant. Videz votre panier pour ajouter un article de ce restaurant',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        elevation: 2,
                        // color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        height: 45,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.clear();
                          setState(() {
                            myCart.resId = null;
                            myCart.resName = null;
                            // if(myCart.items!.length > 0)
                            //  myCart.items!.clear();
                            inCart.clear();
                          });
                          Navigator.pop(context);
                          final snackBar = SnackBar(
                              backgroundColor: Colors.black87,
                              behavior: SnackBarBehavior.fixed,
                              duration: Duration(seconds: 3),
                              content: Text('Panier vidé'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          //widget.onclick();
                          // Navigator.pop(context);
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   '/cart',
                          // );
                        },
                        child: Text(
                          'Vider',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
