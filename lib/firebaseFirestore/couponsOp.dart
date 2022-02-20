import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCouponOperations {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getCoupons(resID, name) {
    return firestore
        .collection('restos')
        .doc(resID)
        .collection('coupons')
        .where('coupon.expiration', isGreaterThanOrEqualTo: Timestamp.now())
        .where('coupon.name', isEqualTo: name).get();
  }
}
