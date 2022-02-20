import 'package:clicandeats/firebaseFirestore/profileOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/client.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/drawer/ediShippingInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingInfos extends StatelessWidget {
  final String uId;
  final VoidCallback onclick;
  ShippingInfos({required this.onclick, required this.uId});
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: _settings.themeLight ? Colors.white : darkAccentColor
        ,
      ),
      child: StreamBuilder(
        stream: FirebaseProfileOp().getShippingInfo(uId),
        builder: (context, AsyncSnapshot<QuerySnapshot>  snapshot) {
         if(snapshot.hasData){
           //print("SNAPDATA: ${snapshot.data!.size}");
           if(snapshot.data!.size > 0){
             ShippingInfo info = ShippingInfo.fromSnapshot(snapshot.data!.docs.first);
             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Expanded(
                       child: Text(
                         'Informations de livraison',
                         style: TextStyle(
                           //  fontSize: 13,
                           fontWeight: FontWeight.bold,
                           //color: Colors.black,
                         ),
                       ),
                     ),
                     MaterialButton(
                       onPressed: () {
                         editShippingInfos(context, true, infoId: snapshot.data!.docs.first.id , info: info, uId: uId, onclick: onclick);
                       },
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),
                           side: BorderSide(color: Theme.of(context).primaryColor)),
                       child: Text(
                         'Changer',
                         style: TextStyle(
                             fontSize: 12,
                             color: _settings.themeLight ? Colors.black87 : Colors.white70
                           //fontWeight: FontWeight.w900,
                         ),
                       ),
                     ),
                   ],
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         '${info.firstName} ${info.lastName}',
                         style: TextStyle(height: 1.5,
                           fontWeight: FontWeight.w600
                           //  fontSize: 15,
                         ),
                       ),
                       Text(
                         /*'${info.roadNumber}, ${info.doorNumber},*/ '${myCart.shippingAddress}',
                         style: TextStyle(
                           //  height:
                           // fontSize: 15,
                         ),
                       ),
                     info.city == "" ? Container():  Text(
                         '${info.city}',
                         style: TextStyle(
                           //fontSize: 15,
                         ),
                       ),
                       Text(
                         '${info.phone}',
                         style: TextStyle(
                             color: Theme.of(context).primaryColor,
                             height: 1.5
                           // fontSize: 15,
                         ),
                       ),
                     ],
                   ),
                 ),
                 // Row(
                 //   mainAxisAlignment: MainAxisAlignment.end,
                 //   children: [
                 //
                 //   ],
                 // ),
               ],
             );
           }
          return   MaterialButton(
            onPressed: () {
              editShippingInfos(context, false,onclick: onclick, uId: uId);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            child: Text(
              'Ajouter des informations de livraison',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87
                //fontWeight: FontWeight.w900,
              ),
            ),
          );
         }

         else return Center(child: Text('$loadingText...'));
        }
      ),
    );
  }
}
