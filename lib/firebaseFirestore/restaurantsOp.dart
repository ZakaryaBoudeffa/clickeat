import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseResOp {
  String collectionName = 'restos';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///get all restaurants
  Stream<QuerySnapshot> getAllRestaurants(List<String> filter) {
    List<String> lst = filter;
    if (lst.length > 0 && lst.length < 10)
      return firestore
          .collection(collectionName)
          .where('category', arrayContainsAny: lst)
          .snapshots();
    else
      return firestore.collection(collectionName).snapshots();
  }

  ///get popular restaurants - means sort by max number of orders
  Stream<QuerySnapshot> getPopularRestaurants(List<String> filter) {
    print("FILTER LENGTH: ${filter.length}");
    List<String> lst = filter;
    if (lst.length > 0 && lst.length < 10)
      return firestore
          .collection(collectionName)
          .where('category', arrayContainsAny: lst)
          .orderBy('totalOrders', descending: true)
          .snapshots();
    else
      return firestore
          .collection(collectionName)
          .orderBy('totalOrders', descending: true)
          .snapshots();
  }

  ///get top rated  restaurants
  Stream<QuerySnapshot> getTopRatedRestaurants(List<String> filter) {
    List<String> lst = filter;
    if (lst.length > 0 && lst.length < 10)
      return firestore
          .collection(collectionName)
          .where('category', arrayContainsAny: lst)
          .orderBy('rating.stars', descending: true)
          .snapshots();
    else
      return firestore
          .collection(collectionName)
          .orderBy('rating.stars', descending: true)
          .limit(10)
          .snapshots();
  }

  Stream<QuerySnapshot> getBestDealRestaurants(List<String> filter) {
    List<String> lst = filter;
    if (lst.length > 0 && lst.length < 10)
      return firestore
          .collection(collectionName)
          .where('category', arrayContainsAny: lst)
          .orderBy('maxDiscount', descending: true)
          .snapshots();
    else
      return firestore
          .collection(collectionName)
          .orderBy('maxDiscount', descending: true)
          .limit(10)
          .snapshots();
  }

  Future<DocumentSnapshot> getRestaurantDetails({resId}) {
    print("resId $resId");
    return firestore.collection(collectionName).doc(resId).get();
  }
}
