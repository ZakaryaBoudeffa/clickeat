import 'package:clicandeats/firebaseFirestore/couponsOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/coupon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ApplyCoupon extends StatelessWidget {
  String resId;
  final Function(double, String) onCouponApplied;
  ApplyCoupon({required this.resId, required this.onCouponApplied});

  TextEditingController couponCodeCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _settings.themeLight ? Colors.white : darkAccentColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: _settings.themeLight? Colors.grey[100]! : Colors.black26,
                  )
                ],
              ),
              child: TextFormField(
                controller: couponCodeCtrl,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Entrer le code promotionnel',
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: _settings.themeLight ?   darkAccentColor: Colors.white,
                  ),
                  fillColor: _settings.themeLight ? Colors.white : darkAccentColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: 10,
          // ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.28,
            child: MaterialButton(
              color: Theme.of(context).primaryColor,
              height: 48,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
              onPressed: () async {
                QuerySnapshot res = await FirebaseCouponOperations().getCoupons(resId, couponCodeCtrl.text);
                print("COUPON RES: ${res.size}");
                if(res.size > 0){
                  Coupon couponData = Coupon().fromSnapshot(res.docs[0]);
                  print("COUPON Percentage: ${couponData.percentage}");
                  onCouponApplied(couponData.percentage!, couponCodeCtrl.text);
                }
                else
                  onCouponApplied(0.0, couponCodeCtrl.text);
              },
              child: Text(
                'Appliquer',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),

            ),
          ),
        ],
      ),
    );
  }
}
