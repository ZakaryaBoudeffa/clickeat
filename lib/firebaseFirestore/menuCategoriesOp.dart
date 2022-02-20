import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMenuCategoriesOp{
  String collectionName = 'restos';
  String subCollection = 'categories';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCategories(resId, List<String> filter) {
    print("FILTER LENGTH: ${filter.length}");
    List<String> lst = filter;
    if (lst.length > 0 && lst.length < 10)
      return firestore
          .collection(collectionName).doc(resId).collection(subCollection)
          .where('name', whereIn: lst)
          .snapshots();
    else
    return firestore
        .collection(collectionName)
        .doc(resId)
        .collection(subCollection)
        .snapshots();
  }

  Future<DocumentSnapshot> getMealDetails(mid, resId) {
    return firestore
        .collection(collectionName)
        .doc(resId)
        .collection('meals')
        .doc(mid)
        .get();
  }
}