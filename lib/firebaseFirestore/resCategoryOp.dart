import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseResCategoriesOp {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getCategoriesFuture() {
    return firestore.collection('categories').get();
  }

}
