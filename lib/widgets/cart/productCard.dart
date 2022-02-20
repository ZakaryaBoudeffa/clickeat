import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/extras.dart';
import 'package:clicandeats/models/order.dart';
import 'package:clicandeats/pages/HomePage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ProductCard extends StatefulWidget {
  final InCartOrder order;
  final VoidCallback onclick;
  ProductCard({required this.order, required this.onclick});
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  //double extrasAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    //extrasAmount = widget.order.extrasAmount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    List<Extras> extras = [];
    extras = widget.order.selectedExtrasList
        .map((i) => Extras.fromJson(i))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: _settings.themeLight ? Colors.white : darkAccentColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: _settings.themeLight? Colors.grey[100]! : Colors.black26,
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
            //  color: Colors.pink,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(widget.order.img, fit: BoxFit.cover,),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${(widget.order.calculatedDishOnlyPrice ).toStringAsFixed(2)}€",
                        style: TextStyle(
                          fontSize: 14,
                          //color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      widget.order.discountPercent > 0 ? Text(
                        "${(widget.order.originalPrice).toStringAsFixed(2)}€",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ) : Container(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                children: [
                  Container(
                    //color: Colors.pink,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.order.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black,
                          ),
                        ),
                        Container(
                        //  color: Colors.pink,
                          child: Row(
                            children: [

                              Text(
                                "${(widget.order.calculatedDishOnlyPrice ).toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  //color: Colors.black,
                                ),
                              ),
                             widget.order.selectedExtrasList.length > 0 ? Text
                                (' + ${(
                                 widget.order
                                 .extrasAmount)
                                  .toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    //  decoration: TextDecoration.lineThrough,
                                   // color: Colors.black,
                                  )) : Container()
                             // widget.order.discountPercent > 0 ? Expanded(
                             //    child: Text(
                             //      " (${(widget.order.originalPrice).toStringAsFixed(2)}€)",
                             //      textAlign: TextAlign.center,
                             //      style: TextStyle(
                             //        fontSize: 12,
                             //        decoration: TextDecoration.lineThrough,
                             //        color: Colors.grey,
                             //      ),
                             //    ),
                             //  ) : Container(),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...extras.map((extra)
                      {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${extra
                                .name}:',
                              style: TextStyle
                                (
                                  fontWeight:
                                  FontWeight.w500,
                                  decoration:
                                  TextDecoration
                                      .underline),),
                            Padding(
                              padding: const
                              EdgeInsets
                                  .symmetric
                                (horizontal:
                              10, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...extra
                                      .extraItems!.map(
                                          (extraItems) {
                                        ExtrasItem extraItem = ExtrasItem.fromJson(extraItems);
                                        return
                                          Row(
                                            children: [
                                              Text
                                                (extraItem.name),
                                              Expanded(child: Container(),),
                                              Text('${extraItem.price!
                                                  .toStringAsFixed(2)} €')
                                            ],
                                          );
                                      })
                                ],),
                            )
                          ],
                        );}
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              //color: Colors.pink,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _settings.themeLight ? Colors.white : Colors.black54,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: _settings.themeLight ? Colors.grey[300]! : Colors.black26,
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: _settings.themeLight ? Colors.white : Colors.black54,
                        child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                if (widget.order.qtt > 1) {
                                  widget.order.qtt--;
                                //  widget.order.extrasAmount-=extrasAmount;
                                }
                                else
                                  inCart.remove(widget.order);
                              });
                              widget.onclick();
                            }),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "${widget.order.qtt} ",
                      style: TextStyle(
                        fontSize: 12,
                        color: _settings.themeLight ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _settings.themeLight ? Colors.white : Colors.black54,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: _settings.themeLight ? Colors.grey[300]! : Colors.black26,
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: _settings.themeLight ? Colors.white : Colors.black54,
                        child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.order.qtt++;
                            //    widget.order.extrasAmount+=extrasAmount;
                              });
                              widget.onclick();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
